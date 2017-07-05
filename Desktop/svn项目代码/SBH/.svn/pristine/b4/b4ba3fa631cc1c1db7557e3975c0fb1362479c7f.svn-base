//
//  SHBTabbarController.m
//  sbh
//
//  Created by SBH on 14-12-1.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "SHBTabbarController.h"
#import "ServerFactory.h"
#import "MessageServer.h"
#import "SBHHomeController.h"
#import "BeIndividualViewController.h"
#import "CommonDefine.h"
#import "BeCommonUI.h"
#import "FontConfigure.h"

@interface SHBTabbarController ()
{
    UIImageView *leftBarButtonItem;
    UIImageView *rightBarButtonItem;
    UILabel *redHint;
    UIImageView *titleView;
}
@end

@implementation SHBTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self barButtonItems];
    [self setControllers];
}
- (void)barButtonItems
{
    titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhuangtai_beijiang"]];
    
    leftBarButtonItem = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xzlxr_weixuanzeIcon"]];
    leftBarButtonItem.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftBarAction)];
    [leftBarButtonItem addGestureRecognizer:tap];
    
    
    rightBarButtonItem = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xzlxr_weixuanzeIcon"]];
    rightBarButtonItem.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightBarAction)];
    [rightBarButtonItem addGestureRecognizer:tap1];
    
    redHint = [[UILabel alloc] initWithFrame:CGRectMake(rightBarButtonItem.width - 8, rightBarButtonItem.height * 0.5 - 10, 8, 8)];
    redHint.backgroundColor = [UIColor redColor];
    redHint.layer.cornerRadius = 4.f;
    redHint.layer.masksToBounds = YES;
    [rightBarButtonItem addSubview:redHint];
    redHint.hidden = YES;
}
- (void)setControllers
{
    SBHHomeController *homeVC = [[SBHHomeController alloc] init];
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[UIImage imageNamed:@"tabar_home_nor"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabar_home_sel"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    homeVC.tabBarItem.tag = 0;
    
    BeIndividualViewController *indiVC = [[BeIndividualViewController alloc]init];
    indiVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"tabar_mine_nor"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabar_mine_sel"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    indiVC.tabBarItem.tag = 1;
    
    self.viewControllers = @[homeVC,indiVC];
    [self tabBar:self.tabBar didSelectItem:homeVC.tabBarItem];
    self.selectedIndex = 0;
    
    [[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys:kLightGreenColor,NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys:kBlueColor,NSForegroundColorAttributeName, nil]forState:UIControlStateNormal];
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    self.navigationItem.titleView = titleView;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarButtonItem];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarButtonItem];
    if (item.tag == 0) {
        [MobClick event:@"DD0001"];
    } else if (item.tag == 1){
        [MobClick event:@"MY0001"];
    }
}
- (void)leftBarAction
{
    
}
- (void)rightBarAction
{
    
}
@end
