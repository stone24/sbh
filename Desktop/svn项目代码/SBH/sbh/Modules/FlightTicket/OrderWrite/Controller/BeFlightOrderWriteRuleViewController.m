//
//  BeFlightOrderWriteRuleViewController.m
//  sbh
//
//  Created by RobinLiu on 16/3/15.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeFlightOrderWriteRuleViewController.h"
#import "BeTicketRuleReasonView.h"
#import "BeAirTicketOrderWriteTool.h"
#import "UIAlertView+Block.h"
#import "BeFlightOrderPaymentController.h"
#import "BeFlightOrderListViewController.h"

#define kTitleString    @"titleString"
#define kContentString  @"contentString"

@interface BeFlightOrderWriteRuleViewController ()
{
    NSString *selectedReason;
}

@end

@implementation BeFlightOrderWriteRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"差旅政策";
    selectedReason = [[NSString alloc]init];
    [self getData];
    [self addHeaderView];
    [self addFooterView];
}
- (void)getData
{
    for(NSDictionary *member in [self.ruleDict arrayValueForKey:@"Messages"])
    {
        if([[member arrayValueForKey:@"Hints"] count] > 0 && [[member stringValueForKey:@"Remark"] length] > 0)
        {
            NSString *titleStr = [NSString stringWithFormat:@"【%@】【%@】本次预订违反了企业的差旅政策。",[member stringValueForKey:@"PassengerName"],[member stringValueForKey:@"Remark"]];
            NSString *contentStr= @"差旅政策标准：\n";
            int i = 1;
            for(NSString *ruleStr in [member arrayValueForKey:@"Hints"])
            {
                contentStr = [contentStr stringByAppendingFormat:@"%d、%@",i,ruleStr];
                if(i < [[member arrayValueForKey:@"Hints"] count])
                {
                    contentStr = [contentStr stringByAppendingFormat:@"\n"];
                }
                i++;
            }
            [self.dataArray addObject:@{kTitleString:titleStr,kContentString:contentStr}];
        }
    }
/*    {
        Result = 1;
        IsForced = 0;
        Messages =     (
                        {
                            Hints =             (
                            );
                            NoSettings =             (
                            );
                            PassengerID = 0;
                            PassengerName = "\U65e0\U6b64\U4eba";
                            Remark = "<null>";
                        },
                        {
                            Hints =             (
                            );
                            NoSettings =             (
                            );
                            PassengerID = 0;
                            PassengerName = "\U65e0\U6b64\U4eba";
                            Remark = "<null>";
                        },
                        {
                            Hints =             (
                                                 "\U9700\U8981\U63d0\U524d3\U5929\U9884\U8ba2",
                                                 "\U56fd\U5185\U673a\U7968\U9700\U8981\U9884\U8ba2 \U6700\U9ad8\U4e0d\U80fd\U8d85\U8fc71000.00\U5143"
                                                 );
                            NoSettings =             (
                                                      "\U8be5\U4f01\U4e1a\U65e0\Uff1a\U3010\U4ea4\U901a\U5de5\U5177\U3011\U653f\U7b56"
                                                      );
                            PassengerID = 113642;
                            PassengerName = "C\U7ad9";
                            Remark = CA1426;
                        },
                        {
                            Hints =             (
                                                 "\U9700\U8981\U63d0\U524d3\U5929\U9884\U8ba2",
                                                 "\U56fd\U5185\U673a\U7968\U7ecf\U6d4e\U8231\U9700\U8981\U9884\U5b9a 7\U6298\U4ee5\U4e0b\U673a\U7968",
                                                 "\U56fd\U5185\U673a\U7968\U9700\U8981\U9884\U8ba2 \U6700\U9ad8\U4e0d\U80fd\U8d85\U8fc71000.00\U5143"
                                                 );
                            NoSettings =             (
                                                      "\U8be5\U4f01\U4e1a\U65e0\Uff1a\U3010\U4ea4\U901a\U5de5\U5177\U3011\U653f\U7b56"
                                                      );
                            PassengerID = 113642;
                            PassengerName = "C\U7ad9";
                            Remark = CZ3903;
                            MobilePhone = 18910132057;
                            Email = tao.liu@shenbianhui.cn;
                            CardNo = 1267382;
                        }
                        );
        Reasons =     (
                       4332,
                       "\U9ed8\U8ba4\U539f\U56e01",
                       "\U9ed8\U8ba4\U539f\U56e02"
                       );
        Result = 0;
    }
*/
}
- (void)addHeaderView
{
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    tableHeaderView.backgroundColor = [UIColor whiteColor];
    UILabel *tableHeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 30)];
    tableHeaderLabel.font = [UIFont systemFontOfSize:14];
    tableHeaderLabel.numberOfLines = 0;
   // tableHeaderLabel.textColor = SBHColor(153, 153, 153);
    tableHeaderLabel.text = @"您好，根据贵公司要求";
    [tableHeaderView addSubview:tableHeaderLabel];
    self.tableView.tableHeaderView = tableHeaderView;
}
- (void)addFooterView
{
    if([[self.ruleDict objectForKey:@"IsForced"] intValue] == 0)
    {
        UIView *tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
        UIButton *inquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
        inquireButton.frame = CGRectMake(15, 30, SBHScreenW - 30, 40);
        inquireButton.layer.cornerRadius = 4.0f;
        [inquireButton addTarget:self action:@selector(generateAction) forControlEvents:UIControlEventTouchUpInside];
        [inquireButton setBackgroundColor:[ColorConfigure loginButtonColor]];
        [inquireButton setTitle:@"继续生成订单" forState:UIControlStateNormal];
        [tableFooterView addSubview:inquireButton];
        self.tableView.tableFooterView = tableFooterView;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([[self.ruleDict objectForKey:@"IsForced"] intValue] == 0)
    {
        return self.dataArray.count + 1;
    }
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section < self.dataArray.count)
    {
        return 2;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section < self.dataArray.count)
    {
        if(indexPath.row == 0)
        {
            CGRect sumRect = [[[self.dataArray objectAtIndex:indexPath.section] objectForKey:kTitleString] boundingRectWithSize:CGSizeMake(kScreenWidth - 28, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
            return sumRect.size.height +15;

        }
        else
        {
            CGRect sumRect = [[[self.dataArray objectAtIndex:indexPath.section] objectForKey:kContentString] boundingRectWithSize:CGSizeMake(kScreenWidth - 28, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
            return sumRect.size.height +15;
        }
    }
    else
    {
        return 40;
    }
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section < self.dataArray.count)
    {
        if (indexPath.row == 0)
        {
            //标题
            UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text = [[self.dataArray objectAtIndex:indexPath.section] objectForKey:kTitleString];
            cell.textLabel.textColor = [UIColor redColor];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.numberOfLines = 0;
            return cell;
        }
        else if (indexPath.row == 1)
        {
            //内容
            UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text = [[self.dataArray objectAtIndex:indexPath.section] objectForKey:kContentString];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
          //  cell.textLabel.textColor = [UIColor grayColor];
            return cell;
        }
    }
    else
    {
        //选择超标原因
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"选择超标原因：";
        cell.detailTextLabel.text = selectedReason;
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == self.dataArray.count)
    {
        NSArray *reasons = [[NSArray alloc]initWithArray:[self.ruleDict objectForKey:@"Reasons"]];
        [[BeTicketRuleReasonView sharedInstance]showViewWith:reasons  andBlock:^(NSString *selectedString){
            selectedReason = [selectedString mutableCopy];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
}
- (void)generateAction
{
    if([selectedReason length] < 1)
    {
        [CommonMethod showMessage:@"请选择超标原因"];
        return;
    }
    [GlobalData getSharedInstance].overproreasons = [[GlobalData getSharedInstance].overproreasons stringByAppendingFormat:@",%@",selectedReason];
    [[GlobalData getSharedInstance].storedCommitInfo setObject:[GlobalData getSharedInstance].overproreasons forKey:@"overproreasons"];
    [[GlobalData getSharedInstance].storedCommitInfo setObject:@"1" forKey:@"isexceed"];
    [self getPolicy];
    [BeAirTicketOrderWriteTool commmitFlightOrderServerWith:[GlobalData getSharedInstance].storedCommitInfo BySuccess:^(NSDictionary *dic)
     {
         NSString *status = [dic objectForKey:@"state"];
         NSString *NUM = [dic objectForKey:@"OrderNo"];
         NSString *code = [dic objectForKey:@"code"];
         
         if ([status isEqualToString:@"true"]) {
             [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationMsgUpdate object:nil];
             NSString *str = [NSString stringWithFormat:@"生成订单成功,订单号为:%@",NUM];
             UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:str delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
             [alert showAlertViewWithCompleteBlock:^(NSInteger index)
              {
                  BeFlightOrderPaymentController *orderVc = [[BeFlightOrderPaymentController alloc] initWith:[dic objectForKey:@"OrderNo"]];
                  orderVc.sourceType = OrderFinishSourceTypeWriteOrder;
                  [self.navigationController pushViewController:orderVc animated:YES];
              }];
         }
         else
         {
             if ([code isEqualToString:@"20023"])
             {
                 [CommonMethod showMessage:@"您的企业剩余额度不足，不能预订本产品，请联系您公司差旅负责人。"];
             }
             else if ([code intValue] == 20010)
             {
                 UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请注意！乘机人已经预定过相同的行程" message:@"" delegate:self cancelButtonTitle:@"继续预定" otherButtonTitles:@"查看订单",nil];
                 [alert showAlertViewWithCompleteBlock:^(NSInteger index)
                  {
                      if(index == 1)
                      {
                          BeFlightOrderListViewController *dingVc = [[BeFlightOrderListViewController alloc] init];
                          dingVc.title = @"机票订单";
                          [self.navigationController pushViewController:dingVc animated:YES];
                      }
                      else
                      {
                          self.writeModel.verifypassengers = @"0";
                          [GlobalData getSharedInstance].storedCommitInfo[@"verifypassengers"] = @"0";
                          [self generateAction];
                      }
                  }];
             }
             else
             {
                 [self handleResuetCode:code];
             }
         }
     }failure:^(NSError *failure)
     {
         [CommonMethod showMessage:kNetworkAbnormal];
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getPolicy
{
    for(NSDictionary *member in [self.ruleDict arrayValueForKey:@"Messages"])
    {
        if([[member arrayValueForKey:@"Hints"] count] > 0 && [[member stringValueForKey:@"Remark"] length] > 0)
        {
            NSString *contentStr= @"";
            int i = 1;
            for(NSString *ruleStr in [member arrayValueForKey:@"Hints"])
            {
                contentStr = [contentStr stringByAppendingFormat:@"%@",ruleStr];
                if(i < [[member arrayValueForKey:@"Hints"] count])
                {
                    contentStr = [contentStr stringByAppendingFormat:@";"];
                }
                i++;
            }
            
            if([[[GlobalData getSharedInstance].storedCommitInfo objectForKey:@"flightno"] isEqualToString:[member stringValueForKey:@"Remark"]])
            {
                //去程
                for(NSMutableDictionary *passenger in [[GlobalData getSharedInstance].storedCommitInfo objectForKey:@"passengers"])
                {
                    if([[passenger objectForKey:@"id"] isEqualToString:[member stringValueForKey:@"PassengerID"]] && [[passenger objectForKey:@"name"] isEqualToString:[member stringValueForKey:@"PassengerName"]])
                    {
                        passenger[@"owcb"] = contentStr;//去程
                    }
                }
            }
            else if ([[[GlobalData getSharedInstance].storedCommitInfo objectForKey:@"flightnort"] isEqualToString:[member stringValueForKey:@"Remark"]])
            {
                //返程
                for(NSMutableDictionary *passenger in [[GlobalData getSharedInstance].storedCommitInfo objectForKey:@"passengers"])
                {
                    if([[passenger objectForKey:@"id"] isEqualToString:[member stringValueForKey:@"PassengerID"]] && [[passenger objectForKey:@"name"] isEqualToString:[member stringValueForKey:@"PassengerName"]])
                    {
                        passenger[@"rtcb"] = contentStr;//返程
                    }
                }
            }
        }
    }
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
