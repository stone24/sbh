//
//  SBHOrderFinishController.m
//  sbh
//
//  Created by SBH on 14-12-26.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "BeFlightOrderPaymentController.h"
#import "BePriceListController.h"
#import "BeAuditPersonViewController.h"
#import "BeAuditProjectViewController.h"

#import "projectObj.h"
#import "selectPerson.h"
#import "selectContact.h"
#import "BeOrderInfoModel.h"
#import "BeFlightModel.h"
#import "BePassengerModel.h"
#import "BeOrderContactModel.h"
#import "NSDate+WQCalendarLogic.h"
#import "BePriceListModel.h"

#import "BeAlteRetView.h"
#import "BeAlertView.h"
#import "SBHDingdanCommonCell.h"
#import "BeFlightOrderPaymentHeaderView.h"
#import "BeFlightAuditSegTableViewCell.h"
#import "BeHotelOrderFooterView.h"

#import "SBHHttp.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ColorUtility.h"
#import "UIAlertView+Block.h"
#import "UIActionSheet+Block.h"
#import "ServerFactory.h"
#import "BeAirTicketOrderWriteTool.h"
#import "NSString+Extension.h"

#define kOrderPayHeaderViewTitleFont [UIFont systemFontOfSize:17]

@interface BeFlightOrderPaymentController () <BeAlertViewDelegate>
@property (nonatomic, strong) NSString *orderNum;
@property (nonatomic, strong) NSString *secondTime;
@property (nonatomic, strong) NSString *minuTime;
@property (nonatomic, strong) NSTimer *timer;

// 订单详情所有数据模型
@property (nonatomic, strong) BeOrderInfoModel *orderInfoModel;
@property (nonatomic, strong) BeFlightOrderPaymentHeaderView *headerView;
@property (nonatomic, strong) BeHotelOrderFooterView *footerView;
@end

@implementation BeFlightOrderPaymentController

- (id)initWith:(NSString *)orderNum
{
    if (self = [super init]) {
        self.orderNum = orderNum;
        self.orderInfoModel =[[BeOrderInfoModel alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    self.tableView.backgroundColor = [ColorUtility colorFromHex:0xf8f8f8];
    self.tableView.hidden = YES;
    [self getOrderDetailInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"P0001"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}
#pragma mark - 设置headerView
- (void)setTableViewHeaderView
{
    self.headerView = [[BeFlightOrderPaymentHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    self.headerView.model = self.orderInfoModel;
    [self.headerView addTarget:self andQuchengRuleAction:@selector(goFlightRuleBtnAction) andFanchengRule:@selector(backFlightRuleBtnAction)];
    self.tableView.tableHeaderView = self.headerView;
    [self countDownAction];
}
#pragma mark - 设置footerView
- (void)setTableViewFooterView
{
    self.tableView.height = self.tableView.height - kHotelOrderFooterViewHeight;
    self.footerView = [[BeHotelOrderFooterView alloc]initWithFrame:CGRectMake(0, self.tableView.height, kScreenWidth, kHotelOrderFooterViewHeight)];
    [self.footerView.payButton setTitle:@"生成订单" forState:UIControlStateNormal];
    [self.footerView addTarget:self andPayAction:@selector(gotoPayBtnClick) andDetailAction:@selector(checkPriceDetailAction)];
    [self.view addSubview:self.footerView];
    
    NSString *priceStr = [NSString stringWithFormat:@"￥%d",[self.orderInfoModel.accountreceivable intValue]+[self.orderInfoModel.servicecharge intValue]];
    NSString *string = [NSString stringWithFormat:@"合计:%@",priceStr];
    NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:string];
    [attrib addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(3, priceStr.length)];
    self.footerView.priceLabel.attributedText = attrib;
    
    if (self.orderInfoModel.auditType  == AuditTypeNone ) {
        [self.footerView.payButton setTitle:@"支付" forState:UIControlStateNormal];
    }
    if ([self.orderInfoModel.isAudit intValue] == 1 && [self.orderInfoModel.officialorprivate isEqualToString:@"因公"]) {
        [self.footerView.payButton setTitle:@"提交审批" forState:UIControlStateNormal];
    }
}
- (void)setupAlteRefuntWith:(BeFlightModel *)flightM
{
    // 拼就显示的退改规则
    NSString *contentStr = [NSString stringWithFormat:@"退改签规则\n更改条件:\n\n%@\n\n退票条件:\n\n%@\n\n改签条件:\n\n%@\n\n舱位:\n\n%@", flightM.endorsement, flightM.refundmemo, flightM.ei, flightM.classcode];
    BeAlteRetView *altRetView = [[BeAlteRetView alloc] initWithTitle:contentStr];
    [altRetView show];
}

// 去程退改规则
- (void)goFlightRuleBtnAction
{
    [self setupAlteRefuntWith:self.orderInfoModel.airorderflights.firstObject];
    
}
// 返程退改规则
- (void)backFlightRuleBtnAction
{
    [self setupAlteRefuntWith:self.orderInfoModel.airorderflights.lastObject];
}
#pragma mark - 当公司、部门、个人、项目审批全有时，选择审批模式
- (void)changeSelectAudit:(UISegmentedControl *)seg
{
    if(self.orderInfoModel.selectAudit == seg.selectedSegmentIndex)
    {
        return;
    }
    [self.orderInfoModel.selectedAuditPersonArray removeAllObjects];
    if(seg.selectedSegmentIndex == 0)
    {
        self.orderInfoModel.selectAudit = SelectedAuditModeOther;
        [self.orderInfoModel.selectedAuditPersonArray addObjectsFromArray:self.orderInfoModel.otherAuditPersonArray];
        [[ServerFactory getServerInstance:@"BeAirTicketOrderWriteTool"]changeAuditTypeWith:@"" And:@"" andTicketId:self.orderInfoModel.TicketId andType:AuditNewTypeTicket andTripMans:self.orderInfoModel.passengers andIsExceed:[self getOrderIsExceed] andOrderNo:self.orderInfoModel.orderno BySuccess:^(id responseObj)
         {
         }failure:^(NSString *error)
         {
             // [self requestFlase:error];
         }];
    }
    else
    {
        self.orderInfoModel.selectAudit = SelectedAuditModeProject;
        [self.orderInfoModel.selectedAuditPersonArray addObjectsFromArray:self.orderInfoModel.projectAuditPersonArray];
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - 获取订单详情
- (void)getOrderDetailInfo
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"Order/OrderDetail"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderno"] = self.orderNum;
    params[@"usertoken"] = [GlobalData getSharedInstance].token;
    [[SBHHttp sharedInstance] postPath:urlStr withParameters:params showHud:YES success:^(id responseObj) {
        NSLog(@"订单详情的数据=%@",responseObj);
        self.tableView.hidden = NO;
        [BeAirticketModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *
         {
             return @{@"ID" : @"id"};
         }];
        [BePassengerModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID" : @"id"};
        }];
        [BePassengerModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"airtickets" : [BeAirticketModel class]};
        }];
        [BeOrderInfoModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"airorderflights" : [BeFlightModel class], @"passengers" : [BePassengerModel class], @"contact" : [BeOrderContactModel class], @"orderlog" : [SBHLogModel class], @"stgpassengers" : [BePassengerModel class]};
        }];
        BeOrderInfoModel *orderModel = [BeOrderInfoModel mj_objectWithKeyValues:[responseObj objectForKey:@"orderdetail"]];
        orderModel.creattime = [responseObj objectForKey:@"creattime"];
        orderModel.servicecharge = [responseObj objectForKey:@"servicecharge"];
        orderModel.isAudit = [responseObj objectForKey:@"isaudit"];
        orderModel.newaudit = [responseObj objectForKey:@"newaudit"];
        [orderModel.orderInfoDict removeAllObjects];
        [orderModel.orderInfoDict setValuesForKeysWithDictionary:responseObj];
        [orderModel getAuitDataWith:responseObj withSourceType:self.sourceType];
        for(NSDictionary *listMember in [responseObj objectForKey:@"baoxianlist"])
        {
            BeOrderInsuranceType *type = [BeOrderInsuranceType mj_objectWithKeyValues:listMember];
            [orderModel.baoxianlist addObject:type];
        }
        [orderModel setSumDetailStr];
        self.orderInfoModel = orderModel;
        
        if([GlobalData getSharedInstance].userModel.isTianzhi)
        {
            [self getTianzhiProjectAuditData];
        }
        [self.tableView reloadData];
        [self setCountDownData];
        [self setTableViewHeaderView];
        [self setTableViewFooterView];
    } failure:^(NSError *error) {
        [self requestFlase:error];
    }];
}
#pragma mark - 设置倒计时显示的数据
- (void)setCountDownData
{
    NSString *creatStr = self.orderInfoModel.creattime;
    creatStr = [creatStr stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSString *chaSecond = [NSString intervalSinceNow:creatStr];
    int chaDouble = [chaSecond intValue];
    if (chaDouble < 13*60) {
        int int1 = (13*60-chaDouble) / 60;
        int int2 = (13*60-chaDouble) % 60;
        self.minuTime = [NSString stringWithFormat:@"%02d",int1];
        self.secondTime = [NSString stringWithFormat:@"%02d",int2];
    } else {
        self.minuTime = @"00";
        self.secondTime = @"00";
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
}
#pragma mark - 订单支付倒计时
- (void)countDownAction
{
    int secondInt = [self.secondTime intValue];
    int minuInt = [self.minuTime intValue];
    secondInt = secondInt - 1;
    if (secondInt < 0) {
        if (minuInt > 0){
            secondInt = 59;
            minuInt = minuInt - 1;
            self.secondTime = [NSString stringWithFormat:@"%02d",secondInt];
            self.minuTime = [NSString stringWithFormat:@"%02d",minuInt];
        }else {
            [self.timer invalidate];
            self.timer = nil;
        }
        
    } else {
        self.secondTime = [NSString stringWithFormat:@"%02d",secondInt];
    }
    [self.headerView setCountDownLabelWithMinute:self.minuTime andSecond:self.secondTime];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return [self.orderInfoModel.passengers count];
    }
    if (section==1) {
        return [self.orderInfoModel.contact count];
    }
    if( section == 2)
    {
        if([GlobalData getSharedInstance].iTiketOrderInfo.travelReason == kTravelReasonTypePrivate || [GlobalData getSharedInstance].userModel.accountType == AccountTypeIndependentIndividual)
        {
            return 0;
        }
        return 1;
    }
    if (section==3)
    {
        if(self.orderInfoModel.auditType == AuditTypeNone)
        {
            return 1;
        }
        else if(self.orderInfoModel.auditType == AuditTypeOld)
        {
            return 1;
        }
        else if (self.orderInfoModel.auditType == AuditTypeWithoutProject)
        {
            return self.orderInfoModel.selectedAuditPersonArray.count + 1;
        }
        else if (self.orderInfoModel.auditType == AuditTypeOnlyProject)
        {
            return self.orderInfoModel.selectedAuditPersonArray.count + 2;
        }
        else if(self.orderInfoModel.auditType == AuditTypeProjectAndEnt || self.orderInfoModel.auditType ==  AuditTypeProjectAndDep ||self.orderInfoModel.auditType ==AuditTypeProjectAndInd)
        {
            if(self.orderInfoModel.selectAudit == SelectedAuditModeOther)
            {
                return self.orderInfoModel.selectedAuditPersonArray.count + 2;
            }
            else
            {
                return self.orderInfoModel.selectedAuditPersonArray.count + 3;
            }
        }
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2)
    {
        if([[GlobalData getSharedInstance].userModel.EntName isEqualToString:kAccountCondition] )
        {
            return 0.01f;
        }
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SBHDingdanCommonCell *cell = nil;
    static NSString *identifier = @"commonCell";
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
    }

     if (indexPath.section == 0){
       BePassengerModel *pasModel = [self.orderInfoModel.passengers objectAtIndex:indexPath.row];
        cell.commonTextField.text = pasModel.cardno;
        cell.xingming.text = pasModel.psgname;
         return cell;

        
    } else if (indexPath.section == 1) {
        BeOrderContactModel *contactM = [self.orderInfoModel.contact objectAtIndex:indexPath.row];
        cell.xingming.text = contactM.pername;
        cell.commonTextField.text = contactM.phone;
        return cell;

    } else if (indexPath.section == 2) {
        if([[GlobalData getSharedInstance].userModel.EntName isEqualToString:kAccountCondition] )
        {
            return cell;
        }
        else
        {
            cell.xingming.text = @"费用中心";
            if (self.orderInfoModel.expensecenter.length == 0) {
                self.orderInfoModel.expensecenter = @"无";
            }
            cell.commonTextField.text = self.orderInfoModel.expensecenter;
        }
        return cell;

    } else if (indexPath.section == 3){
        if(indexPath.row == 0)
        {
            if ([self.orderInfoModel.officialorprivate isEqualToString:@"因私"]) {
                static NSString *identifier = @"auditIdentifier";
                UITableViewCell *auditCell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if(!auditCell)
                {
                    auditCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                }
                auditCell.textLabel.font = [UIFont systemFontOfSize:16.0];
                auditCell.textLabel.textColor = SBHYellowColor;
                auditCell.textLabel.text = @"支付宝支付";
                auditCell.detailTextLabel.text = @"";
                auditCell.accessoryType = UITableViewCellAccessoryNone;
                auditCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return auditCell;
            }
           else if([GlobalData getSharedInstance].userModel.accountType == AccountTypeEntIndividual && [[GlobalData getSharedInstance].userModel.StaffBaoLi intValue ] == 0)
            {
                
                //1、level code = 3 && StaffBaoLi=1
                // 个人帐户是否开通保理 如开通=1 可保理和支付宝，,没有只能是支付宝
                if([self.orderInfoModel.isAudit intValue] == 1)
                {
                    //员工账号 有审批 未开通保理支付
                    static NSString *identifier = @"auditIdentifier";
                    UITableViewCell *auditCell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if(!auditCell)
                    {
                        auditCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                    }
                    auditCell.textLabel.font = [UIFont systemFontOfSize:16.0];
                    auditCell.textLabel.textColor = SBHYellowColor;
                    auditCell.textLabel.text = [NSString stringWithFormat:@"审批通过后，系统自动%@",kPayTipString];
                    auditCell.detailTextLabel.text = @"";
                    auditCell.accessoryType = UITableViewCellAccessoryNone;
                    auditCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return auditCell;
                }
                else
                {
                    static NSString *identifier = @"auditIdentifier";
                    UITableViewCell *auditCell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if(!auditCell)
                    {
                        auditCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                    }
                    auditCell.textLabel.font = [UIFont systemFontOfSize:16.0];
                    auditCell.textLabel.textColor = SBHYellowColor;
                    auditCell.textLabel.text = @"支付宝支付";
                    auditCell.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
                    auditCell.detailTextLabel.text = [NSString stringWithFormat:@"账号未开通%@权限",kPayTipString];
                    auditCell.accessoryType = UITableViewCellAccessoryNone;
                    auditCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return auditCell;
                }
                
            }
            
            else if (self.orderInfoModel.auditType == AuditTypeNone)
            {
                static NSString *identifier = @"auditIdentifier";
                UITableViewCell *auditCell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if(!auditCell)
                {
                    auditCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                }
                auditCell.textLabel.font = [UIFont systemFontOfSize:16.0];
                auditCell.textLabel.textColor = SBHYellowColor;
                auditCell.textLabel.text = self.orderInfoModel.isSelectBaoli == YES?kPayTipString:@"支付宝支付";
                auditCell.detailTextLabel.text = @"";
                auditCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                auditCell.selectionStyle = UITableViewCellSelectionStyleGray;
                return auditCell;
                
            }
            else if ([self.orderInfoModel.isAudit intValue] == 1)
            {
                static NSString *identifier = @"auditIdentifier";
                UITableViewCell *auditCell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if(!auditCell)
                {
                    auditCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                }
                auditCell.textLabel.font = [UIFont systemFontOfSize:16.0];
                auditCell.textLabel.textColor = SBHYellowColor;
                auditCell.textLabel.text = [NSString stringWithFormat:@"审批通过后，系统自动%@",kPayTipString];
                auditCell.detailTextLabel.text = @"";
                auditCell.accessoryType = UITableViewCellAccessoryNone;
                auditCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return auditCell;
            }
         else
        {
            //其他的账号都可以保理和支付宝
            static NSString *identifier = @"auditIdentifier";
            UITableViewCell *auditCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(!auditCell)
            {
                auditCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            }
            auditCell.textLabel.font = [UIFont systemFontOfSize:16.0];
            auditCell.textLabel.textColor = SBHYellowColor;
            auditCell.textLabel.text = self.orderInfoModel.isSelectBaoli == YES?kPayTipString:@"支付宝支付";
            auditCell.detailTextLabel.text = @"";
            auditCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            auditCell.selectionStyle = UITableViewCellSelectionStyleGray;
            return auditCell;
        }
        }
    else if(indexPath.row == 1 && (self.orderInfoModel.auditType == AuditTypeProjectAndEnt ||self.orderInfoModel.auditType ==AuditTypeProjectAndDep ||self.orderInfoModel.auditType ==AuditTypeProjectAndInd))
        {
            //选择框 seg
            BeFlightAuditSegTableViewCell *cell = [BeFlightAuditSegTableViewCell cellWithTableView:tableView];
            if(self.orderInfoModel.auditType == AuditTypeProjectAndEnt)
            {
                [cell.segControl setTitle:@"公司" forSegmentAtIndex:0];
            }
            else if(self.orderInfoModel.auditType == AuditTypeProjectAndDep)
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
            cell.segControl.selectedSegmentIndex = self.orderInfoModel.selectAudit == SelectedAuditModeProject?1:0;
            [cell.segControl addTarget:self action:@selector(changeSelectAudit:) forControlEvents:UIControlEventValueChanged];
            return cell;
        }
        else
        {
            //项目选择
            if((indexPath.row == 1 && self.orderInfoModel.auditType == AuditTypeOnlyProject) || (indexPath.row == 2 && (self.orderInfoModel.auditType == AuditTypeProjectAndEnt ||self.orderInfoModel.auditType ==AuditTypeProjectAndDep || self.orderInfoModel.auditType ==AuditTypeProjectAndInd) && self.orderInfoModel.selectAudit == SelectedAuditModeProject))
            {
                //项目审批的时候
                static NSString *identifier = @"projectIdentifier";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if(!cell)
                {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"项目编号";
                cell.textLabel.textColor = [ColorUtility colorWithRed:51 green:51 blue:51];
                if(self.orderInfoModel.selectedProject.porjectNo.length < 1)
                {
                    cell.detailTextLabel.text = @"选择项目";
                }
                else
                {
                    cell.detailTextLabel.text = self.orderInfoModel.selectedProject.porjectNo;
                }
                if([GlobalData getSharedInstance].userModel.isTianzhi)
                {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                cell.textLabel.font = [UIFont systemFontOfSize:16];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
                return cell;
            }
            else
            {
                //审批人cell
                static NSString *identifier = @"auditIdentifier";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if(!cell)
                {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if (self.orderInfoModel.auditType == AuditTypeWithoutProject || self.orderInfoModel.auditType == AuditTypeOld)
                {
                    BeOrderWriteAuditInfoModel *model = [self.orderInfoModel.selectedAuditPersonArray objectAtIndex:(indexPath.row - 1)];
                    cell.textLabel.text = model.displayLevel;
                    cell.detailTextLabel.text = model.Name;
                }
                else if (self.orderInfoModel.auditType == AuditTypeOnlyProject||(( self.orderInfoModel.auditType == AuditTypeProjectAndEnt || self.orderInfoModel.auditType ==  AuditTypeProjectAndDep||self.orderInfoModel.auditType ==AuditTypeProjectAndInd) && self.orderInfoModel.selectAudit == SelectedAuditModeOther))
                {
                    BeOrderWriteAuditInfoModel *model = [self.orderInfoModel.selectedAuditPersonArray objectAtIndex:(indexPath.row - 2)];
                    cell.textLabel.text = model.displayLevel;
                    cell.detailTextLabel.text = model.Name;
                }
                else
                {
                    BeOrderWriteAuditInfoModel *model = [self.orderInfoModel.selectedAuditPersonArray objectAtIndex:(indexPath.row - 3)];
                    cell.textLabel.text = model.displayLevel;
                    cell.detailTextLabel.text = model.Name;
                }
                cell.textLabel.font = [UIFont systemFontOfSize:16];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
                cell.textLabel.textColor = [ColorUtility colorWithRed:51 green:51 blue:51];
                return cell;
            }
        }
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 3 && indexPath.row == 0)
    {
        if ([self.orderInfoModel.officialorprivate isEqualToString:@"因私"])
        {
            return;
        }
        if([GlobalData getSharedInstance].userModel.accountType == AccountTypeEntIndividual && [[GlobalData getSharedInstance].userModel.StaffBaoLi intValue ] == 0)
        {
            return;
        }
        if(self.orderInfoModel.auditType == AuditTypeNone)
        {
            //保理支付和支付宝支付的情况都有
            UIActionSheet* mySheet = [[UIActionSheet alloc]initWithTitle:@"选择支付方式"delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:kPayTipString,@"支付宝支付", nil];
            [mySheet showActionSheetWithClickBlock:^(NSInteger buttonIndex)
             {
                 if (buttonIndex==0) {
                     self.orderInfoModel.isSelectBaoli = YES;
                     [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                     return;

                 }
                 else if (buttonIndex==1)
                 {
                     self.orderInfoModel.isSelectBaoli = NO;
                     [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                     return;
                 }
             }];
            return;
        }
        if ((![self.orderInfoModel.officialorprivate isEqualToString:@"因私"]) && (([self.orderInfoModel.isAudit intValue] != 1) && (!([GlobalData getSharedInstance].userModel.accountType == AccountTypeEntIndividual && ([[GlobalData getSharedInstance].userModel.StaffBaoLi intValue] !=1 )))))
            
        {  //保理支付和支付宝支付的情况都有
           
           UIActionSheet* mySheet = [[UIActionSheet alloc]initWithTitle:@"选择支付方式"delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:kPayTipString,@"支付宝支付", nil];
           [mySheet showActionSheetWithClickBlock:^(NSInteger buttonIndex)
            {
                if (buttonIndex==0) {
                    self.orderInfoModel.isSelectBaoli = YES;
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

                }
                else if (buttonIndex==1)
                {
                    self.orderInfoModel.isSelectBaoli = NO;
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

                }
            }];
       }
    }
    if (indexPath.section == 3 && indexPath.row != 0)
    {
        if ((self.orderInfoModel.auditType == AuditTypeWithoutProject && indexPath.row != 0)||(self.orderInfoModel.auditType == AuditTypeOld && indexPath.row != 0)) {
            // 非项目审批(新审批)或者老审批
            BeAuditPersonViewController *personVC = [[BeAuditPersonViewController alloc]init];
            personVC.model = [self.orderInfoModel.selectedAuditPersonArray objectAtIndex:indexPath.row -1];
            [self.navigationController pushViewController:personVC animated:YES];
        }
        if(self.orderInfoModel.auditType == AuditTypeProjectAndEnt || self.orderInfoModel.auditType == AuditTypeProjectAndDep||self.orderInfoModel.auditType == AuditTypeProjectAndInd)
        {
            if((self.orderInfoModel.selectAudit == SelectedAuditModeOther && indexPath.row != 0 && indexPath.row != 1) ||(self.orderInfoModel.selectAudit == SelectedAuditModeProject && indexPath.row != 0 && indexPath.row != 1 && indexPath.row != 2))
            {
                NSUInteger index = self.orderInfoModel.selectAudit == SelectedAuditModeOther?indexPath.row - 2:indexPath.row -3;
                BeAuditPersonViewController *personVC = [[BeAuditPersonViewController alloc]init];
                personVC.model = [self.orderInfoModel.selectedAuditPersonArray objectAtIndex:index];
                [self.navigationController pushViewController:personVC animated:YES];
            }
            else  if(self.orderInfoModel.selectAudit == SelectedAuditModeProject && indexPath.row == 2 )
            {
                [self getProjectDataWithIndexPath:indexPath];
            }
        }
        else  if(self.orderInfoModel.auditType == AuditTypeOnlyProject)
        {
            if(indexPath.row == 1)
            {
                if([GlobalData getSharedInstance].userModel.isTianzhi)
                {
                    //天职不能选择
                    return;
                }
                [self getProjectDataWithIndexPath:indexPath];
            }
            else if (indexPath.row !=1&& indexPath.row !=0)
            {
                BeAuditPersonViewController *personVC = [[BeAuditPersonViewController alloc]init];
                personVC.model = [self.orderInfoModel.selectedAuditPersonArray objectAtIndex:indexPath.row -2];
                [self.navigationController pushViewController:personVC animated:YES];
            }
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 0||section == 1)
    {
        return 6.0f;
    }
    else if (section == 2)
    {
        if([[GlobalData getSharedInstance].userModel.EntName isEqualToString:kAccountCondition])
        {
            return 0.1f;
        }
        else
        {
            return 6.0f;
        }
    }
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0||section == 1)
    {
        return 36.0f;
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 36)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    titleLabel.textColor = [UIColor darkGrayColor];
    [headerView addSubview:titleLabel];
    UIView *sepLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.3)];
    sepLine1.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:sepLine1];
    if (section==0)
    {
        titleLabel.text = @"乘机人";
        return headerView;
    }
    if (section==1)
    {
        titleLabel.text = @"联系人";
        return headerView;
    }
    return nil;
}
#pragma mark - 获取项目审批数据
- (void)getProjectDataWithIndexPath:(NSIndexPath *)indexP
{
    BeAuditProjectViewController *projectVC = [[BeAuditProjectViewController alloc]init];
    projectVC.priceAmount = [NSString stringWithFormat:@"%d",[self.orderInfoModel.accountreceivable intValue]+[self.orderInfoModel.servicecharge intValue]];
    projectVC.TicketId = self.orderInfoModel.TicketId;
    projectVC.passengerArray = self.orderInfoModel.passengers;
    projectVC.projectSourceType = AuditNewTypeTicket;
    projectVC.block = ^(NSMutableArray *projectA,BeAuditProjectModel *projectModel,NSString*proflowId)
    {
        self.orderInfoModel.projectFlowID = proflowId;
        [self.orderInfoModel.projectAuditPersonArray removeAllObjects];
        [self.orderInfoModel.projectAuditPersonArray addObjectsFromArray:projectA];
        [self.orderInfoModel.selectedAuditPersonArray removeAllObjects];
        [self.orderInfoModel.selectedAuditPersonArray addObjectsFromArray:self.orderInfoModel.projectAuditPersonArray];
        self.orderInfoModel.selectedProject.projectName = [projectModel.projectName mutableCopy];
        self.orderInfoModel.selectedProject.porjectNo = [projectModel.porjectNo mutableCopy];
        [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:indexP.section] withRowAnimation:UITableViewRowAnimationNone];
        [[ServerFactory getServerInstance:@"BeAirTicketOrderWriteTool"]changeAuditTypeWith:self.orderInfoModel.selectedProject.porjectNo And:self.orderInfoModel.selectedProject.projectName   andTicketId:self.orderInfoModel.TicketId andType:AuditNewTypeTicket andTripMans:self.orderInfoModel.passengers andIsExceed:[self getOrderIsExceed] andOrderNo:self.orderInfoModel.orderno BySuccess:^(id responseObj)
         {
         }failure:^(NSString *error)
         {
             // [self requestFlase:error];
         }];
    };
    [self.navigationController pushViewController:projectVC animated:YES];
}
#pragma mark - 提交审批或者去支付
- (void)gotoPayBtnClick
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    NSString *titleString = cell.textLabel.text;
    if([titleString isEqualToString:kPayTipString])
    {
        //保理支付
        [self payRequest];
        return;
    }
    else if([titleString isEqualToString:@"支付宝支付"])
    {
        //支付宝支付
        [self setupRequestPayCenter];
        return;
    }
    else
    {
        if(self.orderInfoModel.auditType == AuditTypeOld)
        {
            //旧审批
            [self setupSubmitAudit];
            return;
        }
        else
        {
            //新审批
            [self commitNewAudit];
            return;
        }
    }
}
#pragma mark - 提交新审批
- (void)commitNewAudit
{
    if(self.orderInfoModel.auditType == AuditTypeOnlyProject|| ((self.orderInfoModel.auditType == AuditTypeProjectAndEnt ||self.orderInfoModel.auditType ==AuditTypeProjectAndDep || self.orderInfoModel.auditType ==AuditTypeProjectAndInd) && self.orderInfoModel.selectAudit == SelectedAuditModeProject))
    {
        if([self.orderInfoModel.selectedAuditPersonArray count] < 1)
        {
            [CommonMethod showMessage:@"请选择审批项目"];
            return;
        }
    }
    
    NSDictionary *paramsDict = [[NSDictionary alloc]initWithDictionary:[self.orderInfoModel getAuditDict]];
    [[ServerFactory getServerInstance:@"BeAirTicketOrderWriteTool"]commitNewAuditWith:paramsDict andType:AuditNewTypeTicket BySuccess:^ (NSDictionary *responseObject) {
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

#pragma mark - 是否放弃支付
- (void)leftMenuClick
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    NSString *titleString = cell.textLabel.text;
    if([titleString isEqualToString:kPayTipString] || [titleString isEqualToString:@"支付宝支付"])
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
                 if(self.orderInfoModel.auditType != AuditTypeNone  && self.orderInfoModel.auditType != AuditTypeOld)
                 {
                     if(self.orderInfoModel.TicketId.length > 0)
                     {
                         [[ServerFactory getServerInstance:@"BeAirTicketOrderWriteTool"]changeAuditTypeWith:@"" And:@""   andTicketId:self.orderInfoModel.TicketId andType:AuditNewTypeTicket andTripMans:self.orderInfoModel.passengers andIsExceed:[self getOrderIsExceed] andOrderNo:self.orderInfoModel.orderno BySuccess:^(id responseObj)
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
                 else
                 {
                     [self.navigationController popToRootViewControllerAnimated:YES];
                 }
            }
         }];
    }
}

#pragma mark - 保理支付接口请求
- (void)payRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"Payment/PaymentOrder"];
    [[SBHHttp sharedInstance] postPath:urlStr withParameters:@{@"orderno":self.orderNum} showHud:YES success:^(id responseObj)
     {
        UIAlertView *beAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您已支付成功，我们会尽快为您出票" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [beAlert showAlertViewWithCompleteBlock:^(NSInteger index)
         {
             [self.navigationController popToRootViewControllerAnimated:YES];
         }];
     } failure:^(NSError *error)
     {
         NSDictionary *dic = [error userInfo];
         NSString * code = [dic stringValueForKey:@"code"];
         if ([code isEqualToString:@"10004"]) {
             [CommonMethod showMessage:[NSString stringWithFormat:@"没有开通%@",kPayTipString]];
         }
         else if ([code isEqualToString:@"20030"]) {
             [CommonMethod showMessage:[dic stringValueForKey:@"msg"]];
         }
         else if(code.length > 0)
         {
             [self handleResuetCode:code];
         }
         else
         {
             [CommonMethod showMessage:@"支付失败！"];
         }
    }];
}

- (NSMutableArray *)setupPriceDetailArray
{
    NSMutableArray *arrayM = [NSMutableArray array];
    BePriceListModel *sellM = [[BePriceListModel alloc] init];
    sellM.RoomDate = @"票价";
    sellM.SalePrice = self.orderInfoModel.sellprice;
    [arrayM addObject:sellM];
    
    BePriceListModel *fueltexM = [[BePriceListModel alloc] init];
    fueltexM.RoomDate = @"机建";
    fueltexM.SalePrice = self.orderInfoModel.fueltex;
    [arrayM addObject:fueltexM];
    
    BePriceListModel *airporttaxM = [[BePriceListModel alloc] init];
    airporttaxM.RoomDate = @"燃油";
    airporttaxM.SalePrice = self.orderInfoModel.airporttax;
    [arrayM addObject:airporttaxM];
    
   /* BePriceListModel *insuM = [[BePriceListModel alloc] init];
    insuM.RoomDate = @"保险";
    insuM.SalePrice = self.orderInfoModel.insurancepricetotal;
    [arrayM addObject:insuM];
    */
    BePriceListModel *serM = [[BePriceListModel alloc] init];
    serM.RoomDate = @"服务费";
    serM.SalePrice = self.orderInfoModel.servicecharge;
    [arrayM addObject:serM];
    
    int typeA = 0;int priceA = 0;
    int typeB = 0;int priceB = 0;
    int typeC = 0;int priceC = 0;
    for(BeOrderInsuranceType *member in self.orderInfoModel.baoxianlist)
    {
        /*
         亚太航空意外险B款（单次航班）3
          平安航班延误险（单次航班）4
         综合交通意外险（10天）/原易购合众保险；1
         人保交通意外救援保险（7天） 5
         */
        if([member.businesstype intValue ] == 1)
        {
            typeA = typeA + [member.insuranceneedcount intValue];
            priceA = priceA + [member.paidmoney intValue];
        }
        else if([member.businesstype intValue ] == 3)
        {
            typeB = typeB + [member.insuranceneedcount intValue];
            priceB = priceB + [member.paidmoney intValue];
        }
        else if([member.businesstype intValue ] == 4)
        {
            typeC = typeC + [member.insuranceneedcount intValue];
            priceC = priceC + [member.paidmoney intValue];
        }
    }
    if(typeA > 0)
    {
        BePriceListModel *sellM = [[BePriceListModel alloc] init];
        sellM.RoomDate = [NSString stringWithFormat:@"航班意外险（A款） %d份",typeA];
        sellM.SalePrice = [NSString stringWithFormat:@"%.d",priceA];
        [arrayM addObject:sellM];
    }
    if(typeB > 0)
    {
        BePriceListModel *sellM = [[BePriceListModel alloc] init];
        sellM.RoomDate = [NSString stringWithFormat:@"航班意外险（B款） %d份",typeB];
        sellM.SalePrice = [NSString stringWithFormat:@"%.d",priceB];
        [arrayM addObject:sellM];
    }
    if(typeC > 0)
    {
        BePriceListModel *sellM = [[BePriceListModel alloc] init];
        sellM.RoomDate = [NSString stringWithFormat:@"延误取消险%d份",typeC];
        sellM.SalePrice = [NSString stringWithFormat:@"%.d",priceC];
        [arrayM addObject:sellM];
    }
    return arrayM;
}

#pragma mark - 查看费用明细
- (void)checkPriceDetailAction
{
    BePriceListController *prVc = [[BePriceListController alloc] init];
    prVc.tableView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    prVc.tableView.backgroundColor = [UIColor blackColor];
    prVc.tableView.alpha = 0.85;
    prVc.listArray = [self setupPriceDetailArray];
    prVc.roomNum = 1;
    prVc.totleMoneyStr = [NSString stringWithFormat:@"%d", [self.orderInfoModel.accountreceivable intValue] + [self.orderInfoModel.servicecharge intValue]];
    prVc.titleStr = @"机票费";
    [prVc.tableView reloadData];
    [[UIApplication sharedApplication].keyWindow addSubview:prVc.tableView];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePriceListAction:)];
    [prVc.tableView addGestureRecognizer:tapGes];
}
#pragma mark - 隐藏费用明细
- (void)hidePriceListAction:(UIGestureRecognizer *)gesture
{
    UITableView *superView = (UITableView *)[gesture view];
    [superView removeFromSuperview];
    superView = nil;
}

#pragma mark - 推荐酒店请求
- (void)setupRecommendHotelRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"Payment/Xuqiudan"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSArray *array = self.orderInfoModel.airorderflights;
    NSString *edateStr = nil;
    if (array.count > 1) {
        edateStr = [array.lastObject arrivaldate];
    } else {
       NSDate *date = [CommonMethod dateFromString:[array.firstObject arrivaldate] WithParseStr:@"yyyy-MM-dd"];;
       NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] + 3*24*3600)];
        edateStr = [newDate stringFromDate:newDate];
    }
    params[@"orderno"] = self.orderNum;
    params[@"usertoken"] = [GlobalData getSharedInstance].token;
    params[@"sdate"] = [array.firstObject arrivaldate];
    params[@"edate"] = edateStr;
    [[SBHHttp sharedInstance] postPath:urlStr withParameters:params showHud:YES success:^(id responseObj) {

        [MBProgressHUD showSuccess:@"操作成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        [self requestFlase:error];
    }];
}

#pragma mark - 旧审批
- (void)setupSubmitAudit
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"Audit/AuditMsg"];
    // 拼乘机人
    NSMutableArray *preNameArray = [NSMutableArray array];
    for (BePassengerModel *personM in self.orderInfoModel.passengers) {
        [preNameArray addObject:personM.psgname];
    }
    NSString *preNameStr = [preNameArray componentsJoinedByString:@","];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = self.orderNum;
    NSString *linetypeStr = nil;
    if (self.orderInfoModel.airorderflights.count > 1) {
        linetypeStr = @"RT";
    } else {
        linetypeStr = @"OW";
    }
    BeFlightModel *flightM = self.orderInfoModel.airorderflights.firstObject;
    params[@"airlinetype"] = linetypeStr;
    params[@"depairdate"] = flightM.fltdate;
    params[@"depairport"] = flightM.boardname;
    params[@"arrairport"] = flightM.offname;
    params[@"passengers"] = preNameStr;
     [[SBHHttp sharedInstance]postPath:urlStr withParameters:params showHud:YES success:^(NSDictionary *responseObject)
    {
        if ([[responseObject objectForKey:@"code"] intValue] == 20020)
        {
            UIAlertView *beAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"已提交审批，请尽快联系审批人进行审批!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [beAlert showAlertViewWithCompleteBlock:^(NSInteger index)
             {
                 [self.navigationController popToRootViewControllerAnimated:YES];
             }];
        } else
        {
            [MBProgressHUD showError:@"未开通审批"];
        }
    }failure:^(NSError *error)
    {
        NSString *codeStr = [[error userInfo] stringValueForKey:@"code"];
        [self handleResuetCode:codeStr];
    }];
}

#pragma mark - 个人支付请求
- (void)setupRequestPayCenter
{
    NSString *priceStr = [NSString stringWithFormat:@"%d",[self.orderInfoModel.accountreceivable intValue]+[self.orderInfoModel.servicecharge intValue]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"SystemId"] = @"4";
    params[@"format"] = @"json";
    params[@"Platform"] = @"4";
    params[@"PlatType"] = @"4";
    params[@"PaySource"] = @"4";
    params[@"BankCode"] = @"";
    params[@"PayMoney"] = priceStr;
    params[@"BusinessCode"] = @"1";
    params[@"ReturnUrl"] = @"";
    params[@"CardNo"] = @"";
    params[@"BankAcctName"] = @"";
    params[@"BankIdType"] = @"";
    params[@"BankIdNo"] = @"";
    params[@"RiskData"] = @"";
    params[@"SharingData"] = @"";
    params[@"OrderNo"] = self.orderNum;
    params[@"UserName"] = [GlobalData getSharedInstance].userModel.AccountID;
    params[@"OrderDateTime"] = self.orderInfoModel.creattime;
    params[@"GoodsName"] = @"支付";
    params[@"OrderInfo"] = @"支付";
    params[@"usertoken"] = [GlobalData getSharedInstance].token;
    params[@"proOrderType"] = @"JP";
    [[SBHHttp sharedInstance]postPath:kPayCenterUrl withParameters:params showHud:YES success:^(NSDictionary *responseObject)
     {
         NSLog(@"支付宝返回 = %@",responseObject);
         NSString *codeStr = [responseObject objectForKey:@"Code"];
         if ([codeStr intValue] == 1) {
             NSString *msgStr = [responseObject objectForKey:@"MsgStr"];
             [self requestAliPayWithString:msgStr];
         } else if ([codeStr intValue] == 2){
             [self handleResuetCode:@"10006"];
         } else if([codeStr intValue] == 6)
         {
             [CommonMethod showMessage:[responseObject objectForKey:@"MsgStr"]];
             
         }else {
             [MBProgressHUD showError:@"支付失败"];
         }
     } failure:^(NSError * error) {
         [MBProgressHUD showError:@"网络不给力"];
     }];
}

#pragma mark - 支付宝支付接口
- (void)requestAliPayWithString:(NSString *)msgStr
{
    NSString *appScheme = @"sidebenefit";
    [[AlipaySDK defaultService] payOrder:msgStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSArray *array = [[UIApplication sharedApplication] windows];
        UIWindow *win=[array objectAtIndex:0];
        [win setHidden:YES];
        NSString *status = [resultDic stringValueForKey:@"resultStatus"];
        if ([status isEqualToString:@"9000"]) {
            [MBProgressHUD showSuccess:@"支付成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [MBProgressHUD showError:@"支付失败"];
        }
    }];
    NSArray *array = [[UIApplication sharedApplication] windows];
    UIWindow *win=[array objectAtIndex:0];
    [win setHidden:NO];
}
- (NSString *)getOrderIsExceed
{
    BOOL isExceed = NO;
    if([[self.orderInfoModel.orderInfoDict stringValueForKey:@"overproreasons" defaultValue:@""] length] >0 || [[self.orderInfoModel.orderInfoDict stringValueForKey:@"overproreasons" defaultValue:@""] intValue] == 0)
    {
        isExceed = YES;
    }
    
    return [NSString stringWithFormat:@"%d",isExceed];
}
#pragma mark --- BeAlertViewDelegate
- (void)beAlertViewClickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
#pragma mark - 天职直接获取项目审批人
- (void)getTianzhiProjectAuditData
{
    BeAuditProjectModel *auditModel = [[BeAuditProjectModel alloc]init];
    auditModel.projectName = [[self.orderInfoModel.orderInfoDict dictValueForKey:@"orderdetail"] stringValueForKey:@"projectcode"];
    auditModel.porjectNo = [[self.orderInfoModel.orderInfoDict dictValueForKey:@"orderdetail"] stringValueForKey:@"projectcode"];
    [[ServerFactory getServerInstance:@"BeAirTicketOrderWriteTool"]getProjectAuditPersonsWith:auditModel andPassengers:self.orderInfoModel.passengers andTicketId:self.orderInfoModel.TicketId andType:AuditNewTypeTicket BySuccess:^(id dict)
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
                     self.orderInfoModel.projectFlowID = flowID;
                     [self.orderInfoModel.projectAuditPersonArray removeAllObjects];
                     [self.orderInfoModel.projectAuditPersonArray addObjectsFromArray:projectA];
                     [self.orderInfoModel.selectedAuditPersonArray removeAllObjects];
                     [self.orderInfoModel.selectedAuditPersonArray addObjectsFromArray:self.orderInfoModel.projectAuditPersonArray];
                     self.orderInfoModel.selectedProject.projectName = [auditModel.projectName mutableCopy];
                     self.orderInfoModel.selectedProject.porjectNo = [auditModel.porjectNo mutableCopy];
                     [self.tableView reloadData];
                     [[ServerFactory getServerInstance:@"BeAirTicketOrderWriteTool"]changeAuditTypeWith:self.orderInfoModel.selectedProject.porjectNo And:self.orderInfoModel.selectedProject.projectName   andTicketId:self.orderInfoModel.TicketId andType:AuditNewTypeTicket andTripMans:self.orderInfoModel.passengers andIsExceed:[self getOrderIsExceed] andOrderNo:self.orderInfoModel.orderno BySuccess:^(id responseObj)
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
         
     }];
}
@end
