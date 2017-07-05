//
//  BeHotelViewController.m
//  SideBenefit
//
//  Created by RobinLiu on 15/3/10.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelViewController.h"
#import "BeHotelBookTableViewCell.h"
#import "BeHotelSearchViewController.h"
#import "BeHotelListViewController.h"
#import "CalendarHomeViewController.h"
#import "CalendarDayModel.h"
#import "BeHotelListRequestModel.h"
#import "BeChooseCityViewController.h"
#import "CommonMethod.h"
#import "UIActionSheet+Block.h"
#import "BeHotelPriceSelectView.h"

@interface BeHotelViewController ()

@end

@implementation BeHotelViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"酒店预订";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clearAllCondition) name:@"HotelClearAllCondition" object:nil];
    [self setFooterView];
}
- (void)clearAllCondition
{
    [[BeHotelListRequestModel sharedInstance]clearAllConditions];
}
- (void)setFooterView
{
    UIView *tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
    UIButton *inquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inquireButton.frame = CGRectMake(15, 30, SBHScreenW - 30, 40);
    inquireButton.layer.cornerRadius = 4.0f;
    [inquireButton addTarget:self action:@selector(inquireHotel) forControlEvents:UIControlEventTouchUpInside];
    [inquireButton setBackgroundColor:[ColorConfigure loginButtonColor]];
    [inquireButton setTitle:@"查询酒店" forState:UIControlStateNormal];
    [tableFooterView addSubview:inquireButton];
    self.tableView.tableFooterView = tableFooterView;
    
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    versionLabel.text = @"";//kTelephoneTip;
    versionLabel.textColor = [UIColor darkGrayColor];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = [UIFont systemFontOfSize:14];
    versionLabel.centerY = CGRectGetHeight(self.view.bounds)-CGRectGetHeight(self.navigationController.navigationBar.frame)-CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) - 20;
    versionLabel.userInteractionEnabled = YES;
    [self.tableView addSubview:versionLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callAction)];
    [versionLabel addGestureRecognizer:tap];
}
- (void)chooseCity
{
    BeChooseCityViewController *chooseVC = [[BeChooseCityViewController alloc]init];
    chooseVC.sourceType = kHotelStayType;
    chooseVC.isSearchBarFixed = YES;
    chooseVC.cityBlock = ^(CityData *city)
    {
        [[BeHotelListRequestModel sharedInstance] updateCityWith:city];
        [[BeHotelListRequestModel sharedInstance]clearKeywordCondition];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:chooseVC animated:YES];
}
- (void)chooseStartDate
{
    CalendarHomeViewController *dateSelectVC = [[CalendarHomeViewController alloc]init];
    [dateSelectVC setCalendarType:DayTipsTypeHotelStart andSelectDate:[BeHotelListRequestModel sharedInstance].sdate andStartDate:[NSDate date]];
    dateSelectVC.calendarblock = ^(CalendarDayModel *model){
        [BeHotelListRequestModel sharedInstance].sdate = [model date];
        [self.tableView reloadData];
    };
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:dateSelectVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
- (void)chooseLeaveDate
{
    CalendarHomeViewController *dateSelectVC = [[CalendarHomeViewController alloc]init];
    [dateSelectVC setCalendarType:DayTipsTypeHotelLeave andSelectDate:[BeHotelListRequestModel sharedInstance].edate andStartDate:[[BeHotelListRequestModel sharedInstance] automaticGetLeaveDateWith:[BeHotelListRequestModel sharedInstance].sdate]];
    dateSelectVC.calendarblock = ^(CalendarDayModel *model){
        [BeHotelListRequestModel sharedInstance].edate = [model date];
        [self.tableView reloadData];
    };
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:dateSelectVC];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)chooseKeyword
{
    BeHotelSearchViewController *searchVC = [[BeHotelSearchViewController alloc]init];
    NSMutableArray *dArray = [[BeHotelListRequestModel sharedInstance].districtArray mutableCopy];
    NSMutableArray *brandArray = [[BeHotelListRequestModel sharedInstance].brandArray mutableCopy];
    NSMutableArray *busiArray = [[BeHotelListRequestModel sharedInstance].bussinessArray mutableCopy];
    searchVC.cityId = (NSMutableString *)[BeHotelListRequestModel sharedInstance].cityItem.cityId;
    [searchVC updateWithDistrict:dArray andBussiness:busiArray andBrand:brandArray];
    searchVC.searchBlock = ^(NSMutableArray *selectDistrictA,NSMutableArray *selectBussinessA,NSMutableArray *selectBrandA,NSString *keyword){
        [[BeHotelListRequestModel sharedInstance]updateKeywordWithBussiness:selectBussinessA andDistrict:selectDistrictA andBrand:selectBrandA andKeyword:keyword];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:searchVC animated:YES];
}
- (void)inquireHotel
{
    BeHotelListViewController *listVC = [[BeHotelListViewController alloc]init];
    listVC.requestModel = [BeHotelListRequestModel sharedInstance];
    listVC.block = ^{
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:listVC animated:YES];
}
- (void)priceDelete
{
    [[BeHotelListRequestModel sharedInstance].priceArrayCondition removeAllObjects];
    [[BeHotelListRequestModel sharedInstance].starArrayCondition removeAllObjects];
    [self.tableView reloadData];
}
- (void)keywordDelete
{
    [[BeHotelListRequestModel sharedInstance]clearKeywordCondition];
    [self.tableView reloadData];
}
- (void)priceSelect
{
    [[BeHotelPriceSelectView sharedInstance]showViewWithPriceArray:[BeHotelListRequestModel sharedInstance].priceArrayCondition andStarArray:[BeHotelListRequestModel sharedInstance].starArrayCondition andBlock:^(NSMutableArray *selectPriceA,NSMutableArray *selectStarA){
        [[BeHotelListRequestModel sharedInstance].priceArrayCondition removeAllObjects];
        [[BeHotelListRequestModel sharedInstance].priceArrayCondition addObjectsFromArray:selectPriceA];

        [[BeHotelListRequestModel sharedInstance].starArrayCondition removeAllObjects];
        [[BeHotelListRequestModel sharedInstance].starArrayCondition addObjectsFromArray:selectStarA];

        [self.tableView reloadData];
    }];
}
- (void)reasonSelect
{
        
   /* UIActionSheet* mySheet = [[UIActionSheet alloc]initWithTitle:@"出行事由"delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:kTravelReasonOnBussinessText,kTravelReasonPrivateText, nil];
    [mySheet showActionSheetWithClickBlock:^(NSInteger buttonIndex)
     {
         if (buttonIndex==0) {
             [BeHotelListRequestModel sharedInstance].reason = kTravelReasonOnBussinessText;
         }
         else if (buttonIndex==1)
         {
              [BeHotelListRequestModel sharedInstance].reason = kTravelReasonPrivateText;
         }
         [self.tableView reloadData];
     }];*/
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        BeHotelBookCityNameCell *cell = [BeHotelBookCityNameCell cellWithTableView:tableView];
        cell.cityNameLabel.text = [BeHotelListRequestModel sharedInstance].cityItem.iCityName;
        return cell;
    }
    else if (indexPath.row == 1)
    {
        BeHotelBookStayCell *cell = [BeHotelBookStayCell cellWithTableView:tableView];
        cell.model = [BeHotelListRequestModel sharedInstance];
        [cell addTarget:self WithStartAction:@selector(chooseStartDate) andLeaveAction:@selector(chooseLeaveDate)];
        return cell;
    }
    else if (indexPath.row == 2)
    {
        BeHotelBookKeywordCell *cell = [BeHotelBookKeywordCell cellWithTableView:tableView];
        cell.model = [BeHotelListRequestModel sharedInstance];
        [cell addTarget:self andDeleteKeyword:@selector(keywordDelete)];
        return cell;
    }
    else if (indexPath.row == 3)
    {
        BeHotelBookPriceStarCell *cell = [BeHotelBookPriceStarCell cellWithTableView:tableView];
        cell.model = [BeHotelListRequestModel sharedInstance];
        [cell addTarget:self andDeletePrice:@selector(priceDelete)];
        return cell;
    }
    else if(indexPath.row == 4)
    {
        BeHotelBookReasonCell *cell = [BeHotelBookReasonCell cellWithTableView:tableView];
        cell.model = [BeHotelListRequestModel sharedInstance];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0)
    {
        [self chooseCity];
    }
    else if (indexPath.row == 2)
    {
        [self chooseKeyword];
    }
    else if (indexPath.row == 3)
    {
        [self priceSelect];
    }
}
- (void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,13,0,0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,13,0,0)];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,13,0,0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,13,0,0)];
    }
}
- (void)callAction
{
    NSString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",kCallTelephone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
