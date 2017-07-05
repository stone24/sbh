//
//  BeLogonViewController.m
//  SideBenefit
//
//  Created by RobinLiu on 15/3/3.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeLoginViewController.h"
#import "BeLoginTableViewCell.h"
#import "BeLoginManager.h"
#import "ServerFactory.h"
#import "BeLoginServer.h"
#import "DateFormatterConfig.h"

@interface BeLoginViewController ()<BeloginViewDelegate>

@end

@implementation BeLoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"A0001"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUD];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = self.view.bounds;
}
- (void)backAction:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeLoginTableViewCell *cell = [BeLoginTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.lastestAccount = [[GlobalData getSharedInstance].userModel latestLoginUserAccount];
    return cell;
}

- (void)doLoginEnterpriseWith:(NSDictionary *)dict
{
    [MBProgressHUD showMessage:@""];
    [[BeLoginManager sharedInstance]enterpriseLoginWithObject:dict andSuccessBlock:^(NSString *success)
    {
        [MBProgressHUD hideHUD];

    }andFailBlock:^(NSString *failure)
    {
        [MBProgressHUD hideHUD];
        [self handleResuetCode:failure];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
