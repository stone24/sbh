//
//  BeFlightTabBarController.m
//  sbh
//
//  Created by RobinLiu on 2017/7/4.
//  Copyright © 2017年 shenbianhui. All rights reserved.
//

#import "BeFlightTabBarController.h"
#import "ticketReserveViewController.h"
#import "BeAirDynamicViewController.h"
#import "BeCheckInHomeViewController.h"

#import "ServerFactory.h"
#import "MessageServer.h"
#import "SBHHomeController.h"
#import "CommonDefine.h"
#import "BeCommonUI.h"
#import "FontConfigure.h"

@interface BeFlightTabBarController ()
{
    UIImageView *rightBarButtonItem;
}
@end

@implementation BeFlightTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self barButtonItems];
    [self setControllers];
}
- (void)barButtonItems
{
    rightBarButtonItem = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xzlxr_weixuanzeIcon"]];
    rightBarButtonItem.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightBarAction)];
    [rightBarButtonItem addGestureRecognizer:tap1];
}
- (void)setControllers
{
    ticketReserveViewController *ticketVC = [[ticketReserveViewController alloc] init];
    ticketVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"机票" image:[[UIImage imageNamed:@"tabar_home_nor"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabar_home_sel"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    ticketVC.tabBarItem.tag = 0;
    
    BeAirDynamicViewController *airVC = [[BeAirDynamicViewController alloc] init];
    airVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"航班动态" image:[[UIImage imageNamed:@"tabar_home_nor"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabar_home_sel"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    airVC.tabBarItem.tag = 0;
    
    BeCheckInHomeViewController *checkInVC = [[BeCheckInHomeViewController alloc] init];
    checkInVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"在线值机" image:[[UIImage imageNamed:@"tabar_home_nor"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabar_home_sel"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    checkInVC.tabBarItem.tag = 0;
    
    
    self.viewControllers = @[ticketVC,airVC,checkInVC];
    [self tabBar:self.tabBar didSelectItem:ticketVC.tabBarItem];
    self.selectedIndex = 0;
    
    [[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys:kLightGreenColor,NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys:kBlueColor,NSForegroundColorAttributeName, nil]forState:UIControlStateNormal];
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarButtonItem];
    if (item.tag == 0)
    {
        self.title = @"机票服务";
    }
    else if (item.tag == 1)
    {
        self.title = @"航班动态";
    }
    else if (item.tag == 2){
        self.title = @"在线值机";
    }
}
- (void)rightBarAction
{
    
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
