//
//  SBHNavigationController.m
//  sbh
//
//  Created by SBH on 14-12-1.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "SBHNavigationController.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "FontConfigure.h"

@interface SBHNavigationController ()

@end

@implementation SBHNavigationController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        UINavigationBar *navBar = [UINavigationBar appearance];
        UIImage *barImage = [UIImage imageNamed:@"navImage"];
        [navBar setBackgroundImage:barImage forBarMetrics:UIBarMetricsDefault];
        navBar.tintColor = [UIColor blackColor];
        navBar.shadowImage = [UIImage imageNamed:@""];
        UIColor * color = [UIColor whiteColor];
        NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
        navBar.titleTextAttributes = dict;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance]setTitleTextAttributes:[NSDictionary  dictionaryWithObjectsAndKeys:[ColorConfigure navTitleColor],NSForegroundColorAttributeName,[FontConfigure navTitleFont],NSFontAttributeName, nil]];
    // Do any additional setup after loading the view.
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    imageView.image = [UIImage imageNamed:@"commonBackArrow"];
    self.navigationBar.backIndicatorImage = [UIImage imageNamed:@"commonBackArrow"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
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
