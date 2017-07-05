//
//  SBHSettingController.m
//  sbh
//
//  Created by SBH on 14-12-3.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "SBHSettingController.h"
#import "SBHResetpwController.h"
#import "SBHUserModel.h"
#import "BeSettingFooterView.h"
#import "BeLoginManager.h"
#import "BeWebViewController.h"
#import "SDImageCache.h"

#define kModifyPWText           @"修改密码"
#define kPrivacyPolicyText      @"隐私条款"
#define kClearCacheText         @"清除缓存"
#define kRceiveMessagePushText  @"接收消息推送"
#define kTelephoneText          @"客服电话"

@interface SBHSettingController ()
@end

@implementation SBHSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self addVersionLabel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotification) name:kNotificationLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginNotification) name:kNotificationLogOffSuccess object:nil];
    [self loginNotification];
}

- (void)setupFootViewWithIsLogin:(BOOL)isLogin
{
    self.tableView.tableFooterView = nil;
    BeSettingFooterView *footerView = [[[NSBundle mainBundle]loadNibNamed:@"BeSettingFooterView" owner:self options:nil]lastObject];
    footerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 115);
    if(!isLogin)
    {
        footerView.footerViewLogOffButton.hidden = YES;
    }
    else
    {
        [footerView.footerViewLogOffButton addTarget:self action:@selector(logOffAction) forControlEvents:UIControlEventTouchUpInside];
    }
    self.tableView.tableFooterView = footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    NSString *cellTextLabel = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = cellTextLabel;
    if([cellTextLabel isEqualToString:kModifyPWText])
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if([cellTextLabel isEqualToString:kPrivacyPolicyText])
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if([cellTextLabel isEqualToString:kClearCacheText])
    {
        float imageSize = ([[SDImageCache sharedImageCache] getSize]/1024.0/1024.0);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",imageSize];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if([cellTextLabel isEqualToString:kRceiveMessagePushText])
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.text = [UIApplication sharedApplication].currentUserNotificationSettings.types == UIUserNotificationTypeNone?@"已关闭":@"已打开";
    }
    if([cellTextLabel isEqualToString:kTelephoneText])
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = @"400 - 606 - 6288";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *textLabel = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    if([textLabel isEqualToString: kModifyPWText])
    {
        SBHResetpwController *resetVc = [[SBHResetpwController alloc]init];
        [self.navigationController pushViewController:resetVc animated:YES];
    }
    if([textLabel isEqualToString: kPrivacyPolicyText])
    {
        BeWebViewController *privacyVC = [[BeWebViewController alloc]init];
        privacyVC.webViewUrl = @"http://apptest.shenbianhui.cn/ystk.html";
        [self.navigationController pushViewController:privacyVC animated:YES];
    }
    if([textLabel isEqualToString: kClearCacheText])
    {
        [[SDImageCache sharedImageCache]clearDisk];
        [[SDImageCache sharedImageCache]clearMemory];
        [MBProgressHUD showSuccess:@"清除缓存成功"];
        NSIndexPath *tmpIndexpath=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[tmpIndexpath] withRowAnimation:UITableViewRowAnimationNone];
    }
    if([textLabel isEqualToString:kTelephoneText])
    {
        NSString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",kCallTelephone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    if([textLabel isEqualToString: kRceiveMessagePushText])
    {
        return;
    }
}
#pragma mark - 退出登录
- (void)logOffAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"退出当前账号？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[BeLoginManager sharedInstance]startLogOffWithSuccessBlock:^(NSString *success)
         {
             [MBProgressHUD showSuccess:success];
             [self performSelector:@selector(leftMenuClick) withObject:nil afterDelay:1.0];
         }andFailureBlock:^(NSString *failure)
         {
             [MBProgressHUD showError:failure];
         }];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)loginNotification
{
    [self.dataArray removeAllObjects];
    if([GlobalData getSharedInstance].userModel.isLogin)
    {
        if([GlobalData getSharedInstance].userModel.isEnterpriseUser)
        {
            [self.dataArray addObject:kModifyPWText];
        }
        [self setupFootViewWithIsLogin:YES];
    }
    else
    {
        [self setupFootViewWithIsLogin:NO];
    }
    [self.dataArray addObject: kPrivacyPolicyText];
    [self.dataArray addObject: kClearCacheText];
    [self.dataArray addObject: kRceiveMessagePushText];
    [self.tableView reloadData];
}
- (void)addVersionLabel
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    versionLabel.numberOfLines = 0;
    versionLabel.text = [NSString stringWithFormat:@"%@ %@",appCurName,appCurVersion];
    versionLabel.textColor = [UIColor darkGrayColor];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = [UIFont systemFontOfSize:14];
    versionLabel.centerY = CGRectGetHeight(self.view.bounds)-CGRectGetHeight(self.navigationController.navigationBar.frame)-CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) - versionLabel.height;
    [self.tableView addSubview:versionLabel];
}
@end
