//
//  BeIndividualViewController.m
//  SideBenefit
//
//  Created by RobinLiu on 15/3/3.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeIndividualViewController.h"
#import "CommonDefine.h"
#import "SBHSettingController.h"
#import "BeIndividualViewController.h"
#import "BeIndividualHeaderView.h"
#import "ColorConfigure.h"
#import "MessageListViewController.h"
#import "SBHMyCell.h"
#import "UINavigationBar+GMAlpha.h"
#import "BeWebViewController.h"
#import "BeOrderManagerViewController.h"
#import "BeCheckInHomeViewController.h"

#define kOrderText          @"订单"
#define kSecretaryText      @"小秘"
#define kMessageText        @"消息"
#define kMoneyText          @"惠财富"
#define kCellSetttingText   @"设置"

@interface BeIndividualViewController ()<BeIndividualHeaderViewDelegate>
{
    BeIndividualHeaderView *headerView;
}

@end

@implementation BeIndividualViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableViewUI) name:kNotificationLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTableViewUI) name:kNotificationLogOffSuccess object:nil];
    self.tableView.frame = CGRectMake(0, -64, kScreenWidth, kScreenHeight - 49 + 64);
    [self updateTableViewUI];
    headerView = [[BeIndividualHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 155.0/320.0 *kScreenWidth)];
    UIView *blueView = [[UIView alloc]initWithFrame:CGRectMake(0, -1000, kScreenWidth, 1000)];
    UIColor *currentColor = [headerView colorOfPoint:CGPointMake(10, 10)];
    blueView.backgroundColor = currentColor;
    [headerView addSubview:blueView];
    self.tableView.tableHeaderView = headerView;
    headerView.delegate = self;
    headerView.accountInfo = [GlobalData getSharedInstance].userModel;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SBHMyCell *cell =  [SBHMyCell cellWithTableView:tableView];
    [cell.myIcon setImage:[UIImage imageNamed:[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"image"]] forState:UIControlStateNormal];
    cell.myTitle.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.sepImageView.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SBHMyCell *cell = (SBHMyCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.myTitle.text;
    if([cellText isEqualToString:kCellSetttingText])
    {
        SBHSettingController *settingVC = [[SBHSettingController alloc]init];
        [self.navigationController pushViewController:settingVC animated:YES];
    }
    if([cellText isEqualToString:kMessageText])
    {
        MessageListViewController *messageListVC = [[MessageListViewController alloc]init];
        [self.navigationController pushViewController:messageListVC animated:YES];
        [MobClick event:@"XX0001"];
    }
    if([cellText isEqualToString:kOrderText])
    {
        BeOrderManagerViewController *messageListVC = [[BeOrderManagerViewController alloc]init];
        [self.navigationController pushViewController:messageListVC animated:YES];
    }
    if([cellText isEqualToString:kSecretaryText])
    {
        BeCheckInHomeViewController *messageListVC = [[BeCheckInHomeViewController alloc]init];
        [self.navigationController pushViewController:messageListVC animated:YES];
    }
    if([cellText isEqualToString:kMoneyText])
    {
        [self financeAction];
    }
}
- (void)detailButtonDidClick
{
    if ([GlobalData getSharedInstance].userModel.isLogin==NO)
    {
        [BeLogUtility doLogOn];
    }
}
- (void)updateTableViewUI
{
    [self.dataArray removeAllObjects];
    
    NSMutableDictionary *menu1 = [NSMutableDictionary dictionary];
    [menu1 setObject:@"individual_cell_setting" forKey:@"image"];
    [menu1 setObject:kOrderText forKey:@"title"];
    
    NSMutableDictionary *menu2 = [NSMutableDictionary dictionary];
    [menu2 setObject:@"individual_cell_setting" forKey:@"image"];
    [menu2 setObject:kSecretaryText forKey:@"title"];
    
    NSMutableDictionary *menu3 = [NSMutableDictionary dictionary];
    [menu3 setObject:@"individual_cell_setting" forKey:@"image"];
    [menu3 setObject:kMessageText forKey:@"title"];
    
    NSMutableDictionary *menu4 = [NSMutableDictionary dictionary];
    [menu4 setObject:@"individual_cell_setting" forKey:@"image"];
    [menu4 setObject:kMoneyText forKey:@"title"];
    
    NSMutableDictionary *menu5 = [NSMutableDictionary dictionary];
    [menu5 setObject:@"individual_cell_setting" forKey:@"image"];
    [menu5 setObject:kCellSetttingText forKey:@"title"];
    
    if([GlobalData getSharedInstance].userModel.isLogin)
    {
        [self.dataArray addObject:menu1];
    }
    [self.dataArray addObject:menu2];
    if([GlobalData getSharedInstance].userModel.isLogin)
    {
        [self.dataArray addObject:menu3];
        [self.dataArray addObject:menu4];
    }
    [self.dataArray addObject:menu5];

    headerView.accountInfo = [GlobalData getSharedInstance].userModel;
    [self.tableView reloadData];
}
#pragma mark - 摇钱树
- (void)financeAction
{
    if([[GlobalData getSharedInstance].userModel.isyqs intValue] == 0)
    {
        [CommonMethod showMessage:@"您的企业暂未开通摇钱树"];
        return;
    }
    else
    {
        BeWebViewController *webVC = [[BeWebViewController alloc] init];
        webVC.webViewUrl = @"http://mobile.emei8.cn";
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
