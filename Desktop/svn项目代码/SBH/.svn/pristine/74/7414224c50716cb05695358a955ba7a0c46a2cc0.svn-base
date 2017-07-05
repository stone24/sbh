//
//  BeHotelOrderPayViewController.m
//  sbh
//
//  Created by RobinLiu on 15/12/16.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelOrderPayViewController.h"
#import "BeAuditPersonViewController.h"
#import "BeAuditProjectViewController.h"

#import "selectContact.h"
#import "BeOrderWriteAuditInfoModel.h"
#import "BePriceListModel.h"
#import "BeAirTicketOrderWriteTool.h"

#import "SBHDingdanCommonCell.h"
#import "BeHotelOrderWriteCell.h"
#import "BeHotelOrderHeaderView.h"
#import "BeHotelOrderFooterView.h"
#import "BeHotelOrderPriceListView.h"
#import "BeFlightAuditSegTableViewCell.h"
#import "UIAlertView+Block.h"

#import "ColorUtility.h"
#import "ServerFactory.h"
#import "BeHotelServer.h"
#import "SBHHttp.h"

@interface BeHotelOrderPayViewController ()
{
    BeHotelOrderFooterView *footerView;
    UILabel *tableHeaderLabel;
    NSTimer *myTimer;
    NSString *minuTime;
    NSString *secondTime;
}
@end

@implementation BeHotelOrderPayViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginEvent:@"H0003"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    minuTime = @"45";
    secondTime = @"00";
    [self addHeaderView];
    [self addFooterView];
    if([GlobalData getSharedInstance].userModel.isTianzhi)
    {
        [self getTianzhiProjectAudit];
    }
}
- (void)leftMenuClick
{
    if(self.writeModel.auditType == HotelAuditTypeNone)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"订单超时会被取消,是否放弃支付?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex)
         {
             if (buttonIndex == 1) {
                 [self.navigationController popToRootViewControllerAnimated:YES];
             } else {
                 
             };
         }];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"订单超时会被取消,是否放弃审批?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex)
         {
             if(buttonIndex == 1)
             {
                 if(self.writeModel.TicketId.length > 0)
                 {
                     [[ServerFactory getServerInstance:@"BeAirTicketOrderWriteTool"]changeAuditTypeWith:@"" And:@"" andTicketId:self.writeModel.TicketId andType:AuditNewTypeHotel andTripMans:self.writeModel.Persons andIsExceed:self.writeModel.isExceed andOrderNo:self.writeModel.orderNo BySuccess:^(id responseObj)
                      {
                          [self.navigationController popToRootViewControllerAnimated:YES];
                          
                      }failure:^(NSString *error)
                      {
                          [self handleResuetCode:error];
                          
                      }];
                 }
                 else
                 {
                     [self.navigationController popToRootViewControllerAnimated:YES];
                 }
             }
         }];
    }
}
- (void)addHeaderView
{
    if(self.sourceType == HotelOrderPaySourceTypeWriteOrder)
    {
        minuTime = @"45";
        secondTime = @"00";
    }
    else
    {
        NSDate *dareParameter = [CommonMethod dateFromString:self.writeModel.CreateTime WithParseStr:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeInterval time=[[NSDate date] timeIntervalSinceDate:dareParameter];
        int minute = (45 * 60 - (int)time)/60;
        int second = 45 * 60 - (int)time - minute *60;
        minuTime = [NSString stringWithFormat:@"%02d",minute];
        secondTime = [NSString stringWithFormat:@"%02d",second];
    }
    [myTimer invalidate];
    if([minuTime intValue] < 0 || [secondTime intValue] < 0)
    {
        minuTime = @"00";
        secondTime = @"00";
    }
    else
    {
        myTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(payTimerAction)userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
    }
    
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    tableHeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 30)];
    tableHeaderLabel.font = [UIFont systemFontOfSize:14];
    tableHeaderLabel.numberOfLines = 0;
    tableHeaderLabel.textColor = SBHColor(153, 153, 153);
    NSString *string = [NSString stringWithFormat:@"请在%@:%@内完成支付,逾期将自动取消订单", minuTime, secondTime];
    NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:string];
    [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange(2, 5)];
    [attrib addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:19] range:NSMakeRange(2, 5)];
    tableHeaderLabel.attributedText = attrib;
    [tableHeaderView addSubview:tableHeaderLabel];
    self.tableView.tableHeaderView = tableHeaderView;
    if([minuTime intValue] == 0 && [secondTime intValue]== 0)
    {
        [CommonMethod showMessage:@"订单已超时"];
    }
}
- (void)addFooterView
{
    self.tableView.height = self.tableView.height - kHotelOrderFooterViewHeight;
    
    footerView = [[BeHotelOrderFooterView alloc]initWithFrame:CGRectMake(0, self.tableView.height, kScreenWidth, kHotelOrderFooterViewHeight)];
    footerView.detailButton.x = kScreenWidth - 150;
    footerView.detailButton.width = 74;
    if(self.writeModel.auditType == HotelAuditTypeNone)
    {
        [footerView.payButton setTitle:@"支付" forState:UIControlStateNormal];
    }
    else
    {
        [footerView.payButton setTitle:@"提交审批" forState:UIControlStateNormal];
    }
    [footerView updatePriceUIWith:self.writeModel];
    [footerView addTarget:self andPayAction:@selector(payAction) andDetailAction:@selector(lookUpDetailAction)];
    [self.view addSubview:footerView];
}

#pragma mark - TableView data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        //入住人
        return self.writeModel.Persons.count + 1;
    }
    if (section == 1)
    {
       //联系人
        return 2;
    }
    if(section == 2)
    {
        //费用中心
        return self.writeModel.expenseDisplayArray.count;
    }
    if(section == 3)
    {
        if(self.writeModel.auditType == HotelAuditTypeNone)
        {
            //无审批
            return 1;
        }
        else if (self.writeModel.auditType == HotelAuditTypeWithoutProject)
        {
            //非项目审批
            return self.writeModel.selectedAuditPersonArray.count + 1;
        }
        else if (self.writeModel.auditType == HotelAuditTypeOnlyProject)
        {
            //项目审批
            return self.writeModel.selectedAuditPersonArray.count + 2;
        }
        else
        {
            if(self.writeModel.selectAudit == HotelSelectedAuditModeOther)
            {
                //非项目审批
                return self.writeModel.selectedAuditPersonArray.count + 2;
            }
            else
            {
                //项目审批
                return self.writeModel.selectedAuditPersonArray.count + 3;
            }
        }
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0?kHotelOrderHeaderViewHeight:9.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BeHotelOrderHeaderView *headerView = [[BeHotelOrderHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kHotelOrderHeaderViewHeight)];
    headerView.sourceType = BeHotelOrderHeaderViewOrderPay;
    headerView.writeModel = self.writeModel;
    if(section == 0)
    {
        return headerView;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SBHDingdanCommonCell *cell = nil;
    static NSString *identifier = @"HotelSBHDingdanCommonCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SBHDingdanCommonCell" owner:self options:nil] objectAtIndex:0];
        cell.height = 106;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
        cell.xingming.textColor = SBHColor(51, 51, 51);
        cell.commonTextField.textColor = SBHColor(153, 153, 153);
        cell.commonTextField.userInteractionEnabled = NO;
        cell.sepImageView.hidden = YES;
        cell.commonTextField.textAlignment = NSTextAlignmentRight;
    }
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            cell.xingming.text = @"入住人";
            return cell;
        }
        else
        {
            selectPerson *personModel = [self.writeModel.Persons objectAtIndex:(indexPath.row-1)];
            cell.xingming.text = personModel.iName;
            cell.commonTextField.text = personModel.iCredNumber;
            return cell;
        }
    }
    else if (indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            cell.xingming.text = @"联系人";
            return cell;
        }
        else
        {
            selectContact *conModel = [self.writeModel.Contacts objectAtIndex:(indexPath.row-1)];
            cell.xingming.text = conModel.iName;
            cell.commonTextField.text = conModel.iMobile;
            return cell;
        }
    }
    else if (indexPath.section == 2)
    {
        if([[self.writeModel.expenseDisplayArray objectAtIndex:indexPath.row] isEqualToString:kExpenseCenter])
        {
            cell.xingming.text = @"费用中心";
            cell.commonTextField.text = self.writeModel.ExpenseCenter;
            return cell;
        }
        else if([[self.writeModel.expenseDisplayArray objectAtIndex:indexPath.row] isEqualToString:kBusinessReasons])
        {
            cell.xingming.text = @"出差原因";
            cell.commonTextField.text = self.writeModel.BusinessReasons;
            return cell;
        }
        else if([[self.writeModel.expenseDisplayArray objectAtIndex:indexPath.row] isEqualToString:kProjectName])
        {
            cell.xingming.text = @"项目名称";
            cell.commonTextField.text = self.writeModel.ProjectName;
            return cell;
        }
        else if([[self.writeModel.expenseDisplayArray objectAtIndex:indexPath.row] isEqualToString:kProjectCode])
        {
            cell.xingming.text = @"项目编号";
            cell.commonTextField.text = self.writeModel.ProjectCode;
            return cell;
        }
    }
    else if (indexPath.section == 3)
    {
        if(indexPath.row == 0)
        {
            cell.xingming.textColor = SBHYellowColor;
            cell.xingming.text = self.writeModel.auditType ==HotelAuditTypeNone?kPayTipString:[NSString stringWithFormat:@"审批通过后，系统自动%@",kPayTipString];
            return cell;
        }
         else if(indexPath.row == 1 && (self.writeModel.auditType == HotelAuditTypeProjectAndEnt ||self.writeModel.auditType ==HotelAuditTypeProjectAndDep ||self.writeModel.auditType ==HotelAuditTypeProjectAndInd))
         {
             //选择框 seg
             BeFlightAuditSegTableViewCell *cell = [BeFlightAuditSegTableViewCell cellWithTableView:tableView];
             if(self.writeModel.auditType == HotelAuditTypeProjectAndEnt)
             {
                 [cell.segControl setTitle:@"公司" forSegmentAtIndex:0];
             }
             else if(self.writeModel.auditType == HotelAuditTypeProjectAndDep)
             {
                 [cell.segControl setTitle:@"部门" forSegmentAtIndex:0];
             }
             else{
                 [cell.segControl setTitle:@"个人" forSegmentAtIndex:0];
             }
             if([GlobalData getSharedInstance].userModel.isYPS)
             {
                 [cell.segControl setTitle:@"非项目" forSegmentAtIndex:0];
             }
             cell.segControl.selectedSegmentIndex = self.writeModel.selectAudit == HotelSelectedAuditModeProject?1:0;
             [cell.segControl addTarget:self action:@selector(changeSelectAudit:) forControlEvents:UIControlEventValueChanged];
             return cell;
         }
         else
         {
             //项目选择
             if((indexPath.row == 1 && self.writeModel.auditType == HotelAuditTypeOnlyProject) || (indexPath.row == 2 && (self.writeModel.auditType == HotelAuditTypeProjectAndEnt ||self.writeModel.auditType == HotelAuditTypeProjectAndDep || self.writeModel.auditType == HotelAuditTypeProjectAndInd) && self.writeModel.selectAudit == HotelSelectedAuditModeProject))
             {
                 //项目审批的时候
                 UITableViewCell *projectCell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
                 projectCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                 projectCell.textLabel.text = @"项目编号";
                 projectCell.textLabel.textColor = [ColorUtility colorWithRed:51 green:51 blue:51];
                 if(self.writeModel.selectedProject.porjectNo.length < 1)
                 {
                     projectCell.detailTextLabel.text = @"选择项目";
                 }
                 else
                 {
                     projectCell.detailTextLabel.text = self.writeModel.selectedProject.porjectNo;
                 }
                 if([GlobalData getSharedInstance].userModel.isTianzhi)
                 {
                     projectCell.accessoryType = UITableViewCellAccessoryNone;
                 }
                 projectCell.textLabel.font = [UIFont systemFontOfSize:16];
                 projectCell.detailTextLabel.font = [UIFont systemFontOfSize:16];
                 return projectCell;
             }
             else
             {
                 //审批人cell
                 UITableViewCell *auditCell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
                 auditCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                 auditCell.textLabel.font = [UIFont systemFontOfSize:16];
                 auditCell.detailTextLabel.font = [UIFont systemFontOfSize:16];
                 auditCell.textLabel.textColor = [ColorUtility colorWithRed:51 green:51 blue:51];
                 if (self.writeModel.auditType == HotelAuditTypeWithoutProject )
                 {
                     BeOrderWriteAuditInfoModel *model = [self.writeModel.selectedAuditPersonArray objectAtIndex:(indexPath.row - 1)];
                     auditCell.textLabel.text = model.displayLevel;
                     auditCell.detailTextLabel.text = model.Name;
                     return auditCell;
                 }
                 else if (self.writeModel.auditType == HotelAuditTypeOnlyProject||(( self.writeModel.auditType == HotelAuditTypeProjectAndEnt || self.writeModel.auditType == HotelAuditTypeProjectAndDep||self.writeModel.auditType == HotelAuditTypeProjectAndInd) && self.writeModel.selectAudit == HotelSelectedAuditModeOther))
                 {
                     
                     BeOrderWriteAuditInfoModel *model = [self.writeModel.selectedAuditPersonArray objectAtIndex:(indexPath.row - 2)];
                     auditCell.textLabel.text = model.displayLevel;
                     auditCell.detailTextLabel.text = model.Name;
                     return auditCell;

                 }
                 else
                 {
                     BeOrderWriteAuditInfoModel *model = [self.writeModel.selectedAuditPersonArray objectAtIndex:(indexPath.row - 3)];
                     auditCell.textLabel.text = model.displayLevel;
                     auditCell.detailTextLabel.text = model.Name;
                     return auditCell;

                 }
             }
         }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     if(indexPath.section == 3)
     {
         if(indexPath.row == 0)
         {
             return;
         }
         UILabel *cellLabel = (UILabel *)[[tableView cellForRowAtIndexPath:indexPath] textLabel];
         if([cellLabel.text isEqualToString:@"项目编号"])
         {
             if([GlobalData getSharedInstance].userModel.isTianzhi)
             {
                 return;
             }
             [self getProjectDataWithIndexPath:indexPath];
         }
         else
         {
             //审批人
             NSInteger cellCount = [tableView numberOfRowsInSection:indexPath.section];
             BeAuditPersonViewController *personVC = [[BeAuditPersonViewController alloc]init];
             personVC.model = [self.writeModel.selectedAuditPersonArray objectAtIndex:indexPath.row - (cellCount - [self.writeModel.selectedAuditPersonArray count])];
             [self.navigationController pushViewController:personVC animated:YES];
         }
     }
}
#pragma mark - 获取项目审批人
- (void)getProjectDataWithIndexPath:(NSIndexPath *)indexP
{
    BeAuditProjectViewController *projectVC = [[BeAuditProjectViewController alloc]init];
    CGFloat totalPrice = 0;
    for(BePriceListModel *prModel in self.writeModel.priceArray)
    {
        totalPrice = totalPrice + (int)self.writeModel.Persons.count * [prModel.SalePrice doubleValue];
    }
    projectVC.priceAmount = [NSString stringWithFormat:@"%f",totalPrice];
    projectVC.TicketId = self.writeModel.TicketId;
    projectVC.passengerArray = self.writeModel.Persons;
    projectVC.projectSourceType = AuditNewTypeHotel;
    projectVC.block = ^(NSMutableArray *projectA,BeAuditProjectModel *projectModel,NSString*proflowId)
    {
        self.writeModel.projectFlowID = proflowId;
        [self.writeModel.projectAuditPersonArray removeAllObjects];
        [self.writeModel.projectAuditPersonArray addObjectsFromArray:projectA];
        
        [self.writeModel.selectedAuditPersonArray removeAllObjects];
        [self.writeModel.selectedAuditPersonArray addObjectsFromArray:self.writeModel.projectAuditPersonArray];
        self.writeModel.selectedProject.projectName = [projectModel.projectName mutableCopy];
        self.writeModel.selectedProject.porjectNo = [projectModel.porjectNo mutableCopy];
        [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:indexP.section] withRowAnimation:UITableViewRowAnimationNone];
        [[ServerFactory getServerInstance:@"BeAirTicketOrderWriteTool"]changeAuditTypeWith:self.writeModel.selectedProject.porjectNo And:self.writeModel.selectedProject.projectName andTicketId:self.writeModel.TicketId andType:AuditNewTypeHotel andTripMans:self.writeModel.Persons andIsExceed:self.writeModel.isExceed andOrderNo:self.writeModel.orderNo BySuccess:^(id responseObj)
         {
         }failure:^(NSString *error)
         {
             // [self requestFlase:error];
         }];
    };
    [self.navigationController pushViewController:projectVC animated:YES];
}

#pragma mark - 支付按钮
- (void)payAction
{
    
    if([minuTime intValue] == 0 && [secondTime intValue]== 0)
    {
        [CommonMethod showMessage:@"订单已超时"];
        return;
    }
    if(self.writeModel.auditType == HotelAuditTypeNone)
    {
        [[ServerFactory getServerInstance:@"BeHotelServer"]confirmOrderWith:self.writeModel byCallback:^(NSDictionary *callback)
         {
             UIAlertView *alert=[[UIAlertView alloc]
                                 initWithTitle:@"温馨提示"
                                 message:[NSString stringWithFormat:@"支付成功,确认房间后直接%@",kPayTipString] 
                                 delegate:self
                                 cancelButtonTitle:@"知道了"
                                 otherButtonTitles:nil];
             [alert showAlertViewWithCompleteBlock:^(NSInteger index)
              {
                  [self.navigationController popToRootViewControllerAnimated:YES];
              }];
         }failureCallback:^(NSError *error){
             
         }];
    }
    else
    {
        [self commitNewAudit];
    }
}
#pragma mark - 查看费用明细
- (void)lookUpDetailAction
{
    [[BeHotelOrderPriceListView sharedInstance]showViewWithData:self.writeModel andType:BeHotelOrderPriceListViewTypePay];
}
- (void)payTimerAction
{
    int secondInt = [secondTime intValue];
    int minuInt = [minuTime intValue];
    secondInt = secondInt - 1;
    if (secondInt < 0) {
        if (minuInt > 0){
            secondInt = 59;
            minuInt = minuInt - 1;
            secondTime = [NSString stringWithFormat:@"%02d",secondInt];
            minuTime = [NSString stringWithFormat:@"%02d",minuInt];
        }else {
            [myTimer invalidate];
            myTimer = nil;
        }
    } else
    {
        secondTime = [NSString stringWithFormat:@"%02d",secondInt];
    }
    NSString *string = [NSString stringWithFormat:@"请在%@:%@内完成支付,逾期将自动取消订单", minuTime, secondTime];
    NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:string];
    [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange(2, 5)];
    [attrib addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:19] range:NSMakeRange(2, 5)];
    tableHeaderLabel.attributedText = attrib;
    [self.tableView reloadData];
}
- (void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,13,0,0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,13,0,0)];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,13,0,0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,13,0,0)];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - 当公司、部门、个人、项目审批全有时，选择审批模式
- (void)changeSelectAudit:(UISegmentedControl *)seg
{
    if(self.writeModel.selectAudit == seg.selectedSegmentIndex)
    {
        return;
    }
    [self.writeModel.selectedAuditPersonArray removeAllObjects];
    if(seg.selectedSegmentIndex == 0)
    {
        self.writeModel.selectAudit = HotelSelectedAuditModeOther;
        [self.writeModel.selectedAuditPersonArray addObjectsFromArray:self.writeModel.otherAuditPersonArray];
        [[ServerFactory getServerInstance:@"BeAirTicketOrderWriteTool"]changeAuditTypeWith:@"" And:@"" andTicketId:self.writeModel.TicketId andType:AuditNewTypeHotel andTripMans:self.writeModel.Persons andIsExceed:self.writeModel.isExceed andOrderNo:self.writeModel.orderNo BySuccess:^(id responseObj)
         {
         }failure:^(NSString *error)
         {
             // [self requestFlase:error];
         }];
    }
    else
    {
        self.writeModel.selectAudit = HotelSelectedAuditModeProject;
        [self.writeModel.selectedAuditPersonArray addObjectsFromArray:self.writeModel.projectAuditPersonArray];
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 提交新审批
- (void)commitNewAudit
{
    if(self.writeModel.auditType == HotelAuditTypeOnlyProject|| ((self.writeModel.auditType == HotelAuditTypeProjectAndEnt ||self.writeModel.auditType == HotelAuditTypeProjectAndDep || self.writeModel.auditType == HotelAuditTypeProjectAndInd) && self.writeModel.selectAudit == HotelSelectedAuditModeProject))
    {
        if([self.writeModel.selectedAuditPersonArray count] < 1)
        {
            [CommonMethod showMessage:@"请选择审批项目"];
            return;
        }
    }
    NSDictionary *paramsDict = [[NSDictionary alloc]initWithDictionary:[self.writeModel getAuditDict]];
    [[ServerFactory getServerInstance:@"BeAirTicketOrderWriteTool"]commitNewAuditWith:paramsDict andType:AuditNewTypeHotel BySuccess:^(NSDictionary *responseObject) {
        NSLog(@"酒店返回数据=%@",responseObject);
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"true"]) {
            if ([[responseObject objectForKey:@"code"] intValue] == 20027) {
                if([responseObject objectForKey:@"audit"]!=nil)
                {
                    if([[[responseObject objectForKey:@"audit"]objectForKey:@"resultcode"] intValue]== 1)
                    {
                        UIAlertView *beAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"已提交审批，请尽快联系审批人进行审批!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                        [beAlert showAlertViewWithCompleteBlock:^(NSInteger index)
                         {
                             [self.navigationController popToRootViewControllerAnimated:YES];
                         }];
                    }
                    else
                    {
                        [MBProgressHUD showError:[[responseObject objectForKey:@"audit"]objectForKey:@"message"]];
                    }
                }
            } else {
                [MBProgressHUD showError:@"未开通审批"];
            }
        }else {
            NSString *codeStr = [responseObject objectForKey:@"code"];
            [self handleResuetCode:codeStr];
        }
    } failure:^(NSError *error) {
        [self requestFlase:error];
    }];
}
#pragma mark - 天职直接获取项目审批人
- (void)getTianzhiProjectAudit
{
    BeAuditProjectModel *auditModel = [[BeAuditProjectModel alloc]init];
    auditModel.porjectNo = [self.writeModel.ProjectCode mutableCopy];
    auditModel.projectName = [self.writeModel.ProjectCode mutableCopy];
    [[ServerFactory getServerInstance:@"BeAirTicketOrderWriteTool"]getProjectAuditPersonsWith:auditModel andPassengers:self.writeModel.Persons andTicketId:self.writeModel.TicketId andType:AuditNewTypeHotel BySuccess:^(id dict)
     {
         if([dict dictValueForKey:@"projects"]!=nil)
         {
             NSMutableArray *projectA = [[NSMutableArray alloc]init];
             NSDictionary *projects = [dict dictValueForKey:@"projects"];
             if([projects arrayValueForKey:@"FlowInformations"]!=nil)
             {
                 for(id member in [projects arrayValueForKey:@"FlowInformations"])
                 {
                     if (!([member isKindOfClass:[NSNull class]]||member==nil))
                     {
                         NSDictionary *dictMember = (NSDictionary *)member;
                         if([[dictMember stringValueForKey:@"type"] isEqualToString:@"3"])
                         {
                             [projectA addObjectsFromArray: [BeOrderWriteModel setupAuditArrayWith:[dictMember arrayValueForKey:@"approvars"]]];
                         }
                     }
                 }
                 if(projectA.count == 0)
                 {
                     UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该项目没有审批人" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                     [al showAlertViewWithCompleteBlock:^(NSInteger index)
                      {
                          return ;
                      }];
                     return;
                 }
                 else
                 {
                     NSString *flowID = [[[[dict objectForKey:@"projects"] objectForKey:@"FlowInformations"] firstObject]stringValueForKey:@"flowID" defaultValue:@""];
                     
                     self.writeModel.projectFlowID = flowID;
                     [self.writeModel.projectAuditPersonArray removeAllObjects];
                     [self.writeModel.projectAuditPersonArray addObjectsFromArray:projectA];
                     
                     [self.writeModel.selectedAuditPersonArray removeAllObjects];
                     [self.writeModel.selectedAuditPersonArray addObjectsFromArray:self.writeModel.projectAuditPersonArray];
                     self.writeModel.selectedProject.projectName = [auditModel.projectName mutableCopy];
                     self.writeModel.selectedProject.porjectNo = [auditModel.porjectNo mutableCopy];
                     [self.tableView reloadData];
                     [[ServerFactory getServerInstance:@"BeAirTicketOrderWriteTool"]changeAuditTypeWith:self.writeModel.selectedProject.porjectNo And:self.writeModel.selectedProject.projectName andTicketId:self.writeModel.TicketId andType:AuditNewTypeHotel andTripMans:self.writeModel.Persons andIsExceed:self.writeModel.isExceed andOrderNo:self.writeModel.orderNo BySuccess:^(id responseObj)
                      {
                      }failure:^(NSString *error)
                      {
                          // [self requestFlase:error];
                      }];
                 }
             }
             else
             {
                 UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该项目没有审批人" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [al showAlertViewWithCompleteBlock:^(NSInteger index)
                  {
                      return ;
                  }];
                 return;
             }
         }
         
     }failure:^(NSString *error)
     {
         // [self requestFlase:error];
     }];
}
@end
