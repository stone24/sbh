//
//  BeMeetingOrderDetailViewController.m
//  sbh
//
//  Created by RobinLiu on 16/6/22.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeMeetingOrderDetailViewController.h"
#import "SBHHttp.h"
#import "NSDictionary+Additions.h"
#import "ColorUtility.h"

@interface BeMeetingOrderDetailViewController ()

@end

@implementation BeMeetingOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    [self getOrderDetail];
    [self.dataArray addObjectsFromArray:@[@"订单号：",@"订单状态：",@"订单时间：",@"会议城市：",@"会议时间：",@"会议类型：",@"会议预算：",@"参会人数：",@"联系人：",@"联系电话："]];;

    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    view.backgroundColor = [UIColor clearColor];
    UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(0, 1, kScreenWidth, 0.3)];
    sepLine.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:sepLine];
    
    UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake(14, 11, 2, 14)];
    verticalLine.backgroundColor = [ColorUtility colorFromHex:0xff9a14];
    [view addSubview:verticalLine];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(verticalLine.frame) + 2, 8, 100, 20)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [ColorUtility colorWithRed:38 green:38 blue:38];
    [view addSubview:label];
    if (section == 0) {
        label.text = @"订单信息";
    }
    if (section == 1) {
        label.text = @"预订信息";
    }
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0?3:7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 24.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if(indexPath.section == 0)
    {
        cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    }
    else
    {
        cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row + 3];
    }
    return cell;
}
- (void)getOrderDetail
{
    NSDictionary *dict = @{@"orderno":self.orderNo,@"usertoken":[GlobalData getSharedInstance].token};
    [[SBHHttp sharedInstance]postPath:[NSString stringWithFormat:@"%@%@",kServerHost,@"Meeting/MeetingInfo"] withParameters:dict showHud:YES success:^(NSDictionary *result)
     {
         NSLog(@"订单详情 = %@",result);
         NSArray *titleArray = [self.dataArray mutableCopy];
         [self.dataArray removeAllObjects];
         NSDictionary *infoDict = [[result objectForKey:@"meetingInfo"] objectForKey:@"BackInfo"];
         NSMutableArray *contentArray = [[NSMutableArray alloc] init];
        [contentArray addObject:self.orderNo];
         NSString *status;
         if([[infoDict objectForKey:@"Meeting_OrderStatus"] intValue] == 101)
         {
             status = @"已提交";
         }
         else if([[infoDict objectForKey:@"Meeting_OrderStatus"] intValue] == 110)
         {
             status = @"已确认";
         }
         else if([[infoDict objectForKey:@"Meeting_OrderStatus"] intValue] == 120)
         {
             status = @"已取消";
         }
         [contentArray addObject:status];
         [contentArray addObject:[infoDict objectForKey:@"Meeting_CreateDate"]];
         [contentArray addObject:[infoDict objectForKey:@"Meeting_CityName"]];
                            
        [contentArray addObject:[NSString stringWithFormat:@"%@-%@",[infoDict objectForKey:@"Meeting_StrDate"],[infoDict objectForKey:@"Meeting_EndDate"]]];

         [contentArray addObject:[infoDict objectForKey:@"Meeting_Demand"]];
         
         int budget = [infoDict intValueForKey:@"Meeting_Budget"];
         NSString *budgetString = @"";
         switch (budget) {
             case 0:
             {
                 budgetString = @"未选择";
             }
                 break;
             case 1:
             {
                 budgetString = @"¥5000以下";
             }
                 break;
             case 2:
             {
                 budgetString = @"¥6000-15000";
             }
                 break;
             case 3:
             {
                 budgetString = @"¥6000-50000";
             }
                 break;
             case 4:
             {
                 budgetString = @"¥16000-20000";
             }
                 break;
             case 5:
             {
                 budgetString = @"¥21000-30000";
             }
                 break;
             case 6:
             {
                 budgetString = @"¥30000-50000";
             }
                 break;
             case 7:
             {
                 budgetString = @"¥50000-80000";
             }
                 break;
             case 8:
             {
                 budgetString = @"¥100000以上";
             }
                 break;
             default:
                 break;
         }
         [contentArray addObject:budgetString];
         
         int number = [infoDict intValueForKey:@""];
         NSString *numberString = @"";
         switch (number) {
             case 0:
             {
                 numberString = @"未选择";
             }
                 break;
             case 1:
             {
                 numberString = @"20人以下";
             }
                 break;
             case 2:
             {
                 numberString = @"21-50人";
             }
                 break;
             case 3:
             {
                 numberString = @"51-100人";
             }
                 break;
             case 4:
             {
                 numberString = @"101-200人";
             }
                 break;
             case 5:
             {
                 numberString = @"201-500人";
             }
                 break;
             case 6:
             {
                 numberString = @"500人以上";
             }
                 break;
             default:
                 break;
         }
         [contentArray addObject:numberString];
         
         [contentArray addObject:[infoDict objectForKey:@"Meeting_LinkMan"]];
         [contentArray addObject:[infoDict objectForKey:@"Meeting_LinkTelephone"]];


         
         for (int i = 0;i < contentArray.count ;i++ ) {
             NSString *content = [NSString stringWithFormat:@"%@%@",[titleArray objectAtIndex:i],[contentArray objectAtIndex:i]];
             [self.dataArray addObject:content];
         }
         [self.tableView reloadData];
     }failure:^(NSError *error)
     {
         [self requestFlase:error];
     }];
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
