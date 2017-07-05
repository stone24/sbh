//
//  WelcomeVC.m
//  sbh
//
//  Created by musmile on 14-7-6.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "BeGuidePageViewController.h"
#import "CommonDefine.h"

@interface BeGuidePageViewController ()
{
    NSArray *guideImageArray;
    UIScrollView *scrollView;
}

@end

@implementation BeGuidePageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self setScollViewImage];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
   // scrollView.backgroundColor = [UIColor redColor];
    [scrollView setContentSize:CGSizeMake(guideImageArray.count * kScreenWidth, kScreenHeight)];
    [scrollView setPagingEnabled:YES];
    [scrollView setBounces:NO];
    [self.view addSubview:scrollView];
    for(int i = 0;i < guideImageArray.count;i++)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        imageView.image = [UIImage imageNamed:[guideImageArray objectAtIndex:i]];
        [scrollView addSubview:imageView];
        if(i == guideImageArray.count - 1)
        {
            imageView.userInteractionEnabled = YES;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:nil forState:UIControlStateNormal];
            [button setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            [button addTarget:self action:@selector(toDetailAction) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
        }
    }
}
- (void)setScollViewImage
{
    if (kIs_iPhone5)
    {
        guideImageArray = @[@"640x1136-1",@"640x1136-2",@"640x1136-3"];
    }
    else if (kIs_iPhone6)
    {
        guideImageArray = @[@"750x1334-1",@"750x1334-2",@"750x1334-3"];
    }
    else if (kIs_iPhone6Plus)
    {
        guideImageArray =@[@"1242x2208-1",@"1242x2208-2",@"1242x2208-3"];
    }
    else
    {
        guideImageArray = @[@"640x960-1",@"640x960-2",@"640x960-3"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)toDetailAction
{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController=[storyBoard instantiateInitialViewController];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationGuidePageDisappear object:nil];
}

@end
