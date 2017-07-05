//
//  BeCheckInHomeViewController.m
//  sbh
//
//  Created by RobinLiu on 15/6/26.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeCheckInHomeViewController.h"
#import "BeWebViewController.h"
#import "ColorUtility.h"

#define kCellAgencyText @"代办登机牌"
#define kCellCheckInText @"值机"

@interface BeCheckInHomeViewController ()

@end

@implementation BeCheckInHomeViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        UIImage *image = [[UIImage imageNamed:@"tabar_sec_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selectedImage = [[UIImage imageNamed:@"tabar_sec_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"小秘" image:image selectedImage:selectedImage];
        [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ColorConfigure globalBgColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    };
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"小秘";
    self.tableView.separatorColor = [UIColor clearColor];
    //  NSDictionary *dict1 = @{@"title":@"  代办登机牌",@"image":@"airport_boardingPass",@"color":[ColorUtility colorFromHex:0xfc7474]};
    NSDictionary *dict2 = @{@"title":@"  在线值机",@"image":@"airport_online",@"color":[ColorUtility colorFromHex:0x58afe5]};
    // NSDictionary *dict3 = @{@"title":@"  紧急物品托运",@"image":@"airport_post",@"color":[ColorUtility colorFromHex:0x65c967]};
    [self.dataArray addObjectsFromArray:@[/*dict1,*/dict2/*,dict3*/]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for(int i = 0;i < self.dataArray.count;i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(12 + ((kScreenWidth - 34)/2.0 + 10)*(i%2), 10 + 47*(i/2), (kScreenWidth - 34)/2.0, 37);
        [cell addSubview:button];
        button.backgroundColor = [[self.dataArray objectAtIndex:i] objectForKey:@"color"];
        button.layer.cornerRadius = 3.0f;
        [button setTitle:[[self.dataArray objectAtIndex:i] objectForKey:@"title"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        [button setImage:[UIImage imageNamed:[[self.dataArray objectAtIndex:i] objectForKey:@"image"]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
    }
    return cell;
}
- (void)buttonAction:(UIButton *)sender
{
    switch (sender.tag) {
        
        case 0:
        {
            BeWebViewController *webVC = [[BeWebViewController alloc]init];
            webVC.webViewUrl = kOnlineCheckInHost;
            [self.navigationController pushViewController:webVC animated:YES];
            // 友盟统计，
            [MobClick event:@"A0006"];
        }
            break;
        case 2:
        {
            BeWebViewController *webVC = [[BeWebViewController alloc]init];
            webVC.webViewUrl = kHomePostUrl;
            [self.navigationController pushViewController:webVC animated:YES];
            // 友盟统计
            [MobClick event:@"A0008"];
        }
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
