//
//  BeTrainTicketListViewController.m
//  sbh
//
//  Created by RobinLiu on 15/6/15.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTrainTicketListViewController.h"
#import "BeTicketQueryHeaderView.h"
#import "BeTrainListTableViewCell.h"
#import "BeTrainListTabbar.h"
#import "CommonDefine.h"
#import "BeTrainFilterPickerView.h"
#import "BeTrainTicketFilterConditions.h"
#import "BeTrainResultItem.h"
#import "ServerFactory.h"
#import "BeTrainServer.h"
#import "BeTrainDetailViewController.h"

@interface BeTrainTicketListViewController () <UITabBarControllerDelegate>
{
    BeTicketQueryHeaderView *headerView;
    BeTrainListTabbar *tabbar;
    BeTrainTicketFilterConditions *conditions;
    BeTrainResultItem *resultItem;
}

@end

@implementation BeTrainTicketListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self customHeaderAndTitle];
    [self customTabbar];
    [self customTableHeight];
    [self getData];
}
- (void)initData
{
    resultItem = [[BeTrainResultItem alloc]init];
    conditions = [[BeTrainTicketFilterConditions alloc]initConfigure];
}
- (void)getData
{
    [[ServerFactory getServerInstance:@"BeTrainServer"]getDataWithItem:[BeTrainTicketInquireItem sharedInstance] andSuccess:^(NSDictionary *dict)
     {
         [resultItem setDataWithDict:dict];
         [BeTrainTicketInquireItem sharedInstance].GuidSearch = [dict stringValueForKey:@"guidsearch" defaultValue:@""];
         [self.tableView reloadData];
         resultItem.isDataException = NO;
         tabbar.userInteractionEnabled = YES;
     }andFailure:^(NSError *error)
     {
         if([[error.userInfo stringValueForKey:@"code" defaultValue:@""]isEqualToString:@"20009"])
         {
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"查询火车票信息失败,请重新查询" message:nil preferredStyle:UIAlertControllerStyleAlert];
             [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 [self performSelector:@selector(leftMenuClick) withObject:nil afterDelay:0.001];
             }]];
             [self presentViewController:alertController animated:YES completion:nil];
         }
         resultItem.isDataException = YES;
         tabbar.userInteractionEnabled = NO;
     }];
}
- (void)customTableHeight
{
    self.tableView.y = kTicketQueryHeaderHeight;
    CGFloat height = CGRectGetHeight([[UIScreen mainScreen] bounds])-CGRectGetHeight(self.navigationController.navigationBar.frame)-CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)-kTicketQueryHeaderHeight - kTrainListTabbarHeight;
    self.tableView.height = height;
}
- (void)customHeaderAndTitle
{
    self.title = [NSString stringWithFormat:@"%@-%@",[BeTrainTicketInquireItem sharedInstance].fromTrainStation,[BeTrainTicketInquireItem sharedInstance].toTrainStation];
    headerView = [[BeTicketQueryHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kTicketQueryHeaderHeight)];
    [headerView updateUIWithItem:[BeTrainTicketInquireItem sharedInstance]];
    [headerView addTarget:self andBeforeAction:@selector(beforeDayAction) andAfterAction:@selector(nextDayAction)];
    [self.view addSubview:headerView];
}
- (void)customTabbar
{
    tabbar = [[BeTrainListTabbar alloc]initWithFrame:CGRectMake(0, CGRectGetHeight([[UIScreen mainScreen] bounds])-CGRectGetHeight(self.navigationController.navigationBar.frame)-CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)-kTrainListTabbarHeight, kScreenWidth, kTrainListTabbarHeight)];
    [tabbar addTarget:self andFilterAction:@selector(filterAction) andTimeAction:@selector(timeAction) andPriceAction:@selector(priceAction) andDurationAction:@selector(durationAction)];
    [self.view addSubview:tabbar];
}
- (void)beforeDayAction
{
    [resultItem clearAllData];
    [self.tableView reloadData];
    [BeTrainTicketInquireItem sharedInstance].startDate = [CommonMethod getTheDayBefore:[BeTrainTicketInquireItem sharedInstance].startDate];
    [headerView updateUIWithItem:[BeTrainTicketInquireItem sharedInstance]];
    [self getData];
}
- (void)nextDayAction
{
    [resultItem clearAllData];
    [self.tableView reloadData];
    [BeTrainTicketInquireItem sharedInstance].startDate = [CommonMethod getTheDayAfter:[BeTrainTicketInquireItem sharedInstance].startDate];
    [headerView updateUIWithItem:[BeTrainTicketInquireItem sharedInstance]];
    [self getData];
}
- (void)filterAction
{
    [[BeTrainFilterPickerView sharedInstance]showPickerViewWithConditions:conditions andBlock:^ (BeTrainTicketFilterConditions *blockObjc)
     {
         conditions = blockObjc;
         [resultItem filterWithItem:conditions];;
         [self.tableView reloadData];
         [tabbar updateFilterUIWith:resultItem];
     }];
}
- (void)timeAction
{
    [resultItem sortTime];
    [self.tableView reloadData];
    [tabbar updateTimeUIWith:resultItem];
}
- (void)priceAction
{
    [resultItem sortPrice];
    [self.tableView reloadData];
    [tabbar updatePriceUIWith:resultItem];
}
- (void)durationAction
{
    [resultItem sortDuration];
    [self.tableView reloadData];
    [tabbar updateDurationUIWith:resultItem];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return resultItem.filterArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [BeTrainListTableViewCell cellHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeTrainListTableViewCell *cell = [BeTrainListTableViewCell cellWithTableView:tableView];
    cell.listModel = [resultItem.filterArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.sourceType == kTrainTicketListSourceAlte) {  // 改签
        self.trainTicketListModelBlock([resultItem.filterArray objectAtIndex:indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        BeTrainDetailViewController *detailVC = [[BeTrainDetailViewController alloc]init];
        detailVC.model = [resultItem.filterArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
