//
//  BeHotelTravelPolicyViewController.m
//  sbh
//
//  Created by RobinLiu on 16/4/14.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeHotelTravelPolicyViewController.h"
#import "BeTicketRuleReasonView.h"
#import "BeAirTicketOrderWriteTool.h"
#import "UIAlertView+Block.h"
#import "BePriceListModel.h"
#import "BeHotelOrderPayViewController.h"

#import "SBHHttp.h"
#import "ServerFactory.h"
#import "BeHotelServer.h"

#define kTitleString    @"titleString"
#define kContentString  @"contentString"

@interface BeHotelTravelPolicyViewController ()
{
    NSString *selectedReason;
}

@end

@implementation BeHotelTravelPolicyViewController

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
        if([[member arrayValueForKey:@"Hints"] count] > 0)
        {
            //[member stringValueForKey:@"Remark"]
            NSString *titleStr = [NSString stringWithFormat:@"【%@】本次预订违反了企业的差旅政策。",[member stringValueForKey:@"PassengerName"]];
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
    
    
    /*   {
     IsForced = 0;
     Messages =         (
     {
     Hints =                 (
     "\U5f53\U524d\U51fa\U5dee\U5730\U7684\U9152\U5e97\U6807\U51c6\U4e3a 1.00\U5143\U6807\U51c6"
     );
     NoSettings =                 (
     );
     PassengerID = "<null>";
     PassengerName = "\U5b59\U5f66\U594e";
     Remark = "<null>";
     }
     );
     Reasons =         (
     "\U966a\U540c\U9886\U5bfc",
     "\U5f00\U4f1a\U65fa\U5b63",
     "\U9ed8\U8ba4\U539f\U56e01",
     "\U9ed8\U8ba4\U539f\U56e02",
     "\U9ed8\U8ba4\U516c\U5171-1",
     wedx,
     ew,
     wq
     );
     Result = 0;
     };
     */
}
- (void)addHeaderView
{
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    tableHeaderView.backgroundColor = [UIColor whiteColor];
    UILabel *tableHeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 30)];
    tableHeaderLabel.font = [UIFont systemFontOfSize:14];
    tableHeaderLabel.numberOfLines = 0;
    tableHeaderLabel.textColor = SBHColor(153, 153, 153);
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
            cell.textLabel.textColor = [UIColor grayColor];
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
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor blackColor];
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

#pragma mark - 生成订单
- (void)generateAction
{
    if([selectedReason length] < 1)
    {
        [CommonMethod showMessage:@"请选择超标原因"];
        return;
    }
    self.writeModel.isExceed = @"1";
    self.writeModel.PolicyReason = [selectedReason mutableCopy];
    [[ServerFactory getServerInstance:@"BeHotelServer"]commitOrderWith:self.writeModel byCallback:^(NSDictionary *callback)
     {
         self.writeModel.orderNo = [callback objectForKey:@"orderNo"];
        [[ServerFactory getServerInstance:@"BeHotelServer"]getHotelAuditWith:self.writeModel byCallback:^(id callback)
          {
              NSLog(@"审批信息 = %@",callback);
              [self.writeModel getHotelAuditWith:callback];
              if([self.writeModel.PayType isEqualToString:@"1"]||[self.writeModel.PayType isEqualToString:@"3"])
              {
                  //到付
                  if(self.writeModel.auditType == HotelAuditTypeNone)
                  {
                      //无审批
                      UIAlertView *alert=[[UIAlertView alloc]
                                          initWithTitle:@"温馨提示"
                                          message:@"预订成功，房费请于酒店前台支付"
                                          delegate:self
                                          cancelButtonTitle:@"知道了"
                                          otherButtonTitles:nil];
                      [alert showAlertViewWithCompleteBlock:^(NSInteger index)
                       {
                           [self.navigationController popToRootViewControllerAnimated:YES];
                       }];
                  }
                  else
                  {
                      BeHotelOrderPayViewController *payVC = [[BeHotelOrderPayViewController alloc]init];
                      payVC.sourceType = HotelOrderPaySourceTypeWriteOrder;
                      payVC.writeModel = self.writeModel;
                      [self.navigationController pushViewController:payVC animated:YES];
                  }
          
              }
              else
              {
                  [self.writeModel.priceArray removeAllObjects];
                  for (NSDictionary *member in [callback objectForKey:@"pricesList"])
                  {
                      BePriceListModel *prModel = [BePriceListModel mj_objectWithKeyValues:member];
                      [self.writeModel.priceArray addObject:prModel];
                  }
                  NSString *str = [NSString stringWithFormat:@"生成订单成功,订单号为:%@",self.writeModel.orderNo];
                  UIAlertView *alert=[[UIAlertView alloc]
                                      initWithTitle:@"温馨提示"
                                      message:str
                                      delegate:self
                                      cancelButtonTitle:@"知道了"
                                      otherButtonTitles:nil];
                  [alert showAlertViewWithCompleteBlock:^(NSInteger index)
                   {
                       BeHotelOrderPayViewController *payVC = [[BeHotelOrderPayViewController alloc]init];
                       payVC.sourceType = HotelOrderPaySourceTypeWriteOrder;
                       payVC.writeModel = self.writeModel;
                       [self.navigationController pushViewController:payVC animated:YES];
                   }];
              }
          }failureCallback:^(NSError *error)
         {
             NSLog(@"审批信息错误 = %@",error);
             [self requestFlase:error];
         }];
         
     }failureCallback:^(NSError *error)
     {
         NSString *codeStr = [error.userInfo objectForKey:@"code"];
         if([codeStr isEqualToString:@"20028"])
         {
             BeHotelTravelPolicyViewController *ruleVC = [[BeHotelTravelPolicyViewController alloc]init];
             ruleVC.writeModel = self.writeModel;
             ruleVC.ruleDict = [error.userInfo objectForKey:@"cl"];
             [self.navigationController pushViewController:ruleVC animated:YES];
         }
         else if([codeStr isEqualToString:@"20035"])
         {
             UIAlertView *alert=[[UIAlertView alloc]
                                 initWithTitle:@"温馨提示"
                                 message:@"房间价格变动"
                                 delegate:self
                                 cancelButtonTitle:@"知道了"
                                 otherButtonTitles:nil];
             [alert showAlertViewWithCompleteBlock:^(NSInteger index)
              {
                  [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshHotelDetail" object:nil];
                  [self.navigationController popViewControllerAnimated:YES];
              }];
         }
         else if ([codeStr isEqualToString:@"10003"])
         {
             [self handleResuetCode:codeStr];
         }
         else if([codeStr isEqualToString:@"20031"])
         {
             [CommonMethod showMessage:@"企业额度不够,或是合同已到期，请验证后，再提交"];
         }
         else
         {
             [MBProgressHUD showError:@"网络异常"];
         }
         
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
