//
//  dingdantianxieViewController.m
//  SBHAPP
//
//  Created by musmile on 14-7-2.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "BeFlightOrderWriteViewController.h"
#import "xuanzechengjirenViewController.h"
#import "BePassengerViewController.h"
#import "gongsilianxirenController.h"
#import "BeFlightOrderPaymentController.h"
#import "BeAuditPersonViewController.h"
#import "BeAuditProjectViewController.h"
#import "BeFlightOrderWriteRuleViewController.h"
#import "BeFlightOrderListViewController.h"

#import "dingdantianxieTableViewCell.h"
#import "gongsilianxirenTableViewCell.h"
#import "SBHDingdtxHeaterCell.h"
#import "SBHDingdanCommonCell.h"
#import "BeOrderWriteInsuranceCell.h"
#import "BeFlightAuditSegTableViewCell.h"
#import "BeOrderTitleTableViewCell.h"
#import "BeHotelOrderFooterView.h"
#import "BeAlteRetView.h"

#import "SBHOrderModel.h"
#import "SBHUserModel.h"
#import "BeOrderWriteModel.h"

#import "SBHHttp.h"
#import "BeAirTicketOrderWriteTool.h"
#import "ServerFactory.h"
#import "ColorUtility.h"
#import "BeRegularExpressionUtil.h"
#import "CommonDefine.h"
#import "UIAlertView+Block.h"

@interface BeFlightOrderWriteViewController ()
@property (nonatomic,strong)BeHotelOrderFooterView *footerView;
@property (nonatomic,strong)UITextField *centerTextField;
@property (nonatomic,strong)UITextField *reasonTextField;
// 航班信息数据模型
@property (nonatomic,strong) BeOrderWriteModel *writeModel;

@end

@implementation BeFlightOrderWriteViewController

- (void)leftMenuClick
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"订单填写尚未完成，是否离开当前页面" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex)
     {
         if (buttonIndex == 1) {
             [super leftMenuClick];
         }
     }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick event:@"J0003"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"dingdantianxieViewController"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAddPerson:) name:kNotificationAddHotelPerson object:nil];
    self.title = @"订单填写";
    self.tableView.hidden = YES;
    self.tableView.height = self.tableView.height - kHotelOrderFooterViewHeight;
    self.footerView = [[BeHotelOrderFooterView alloc]initWithFrame:CGRectMake(0, self.tableView.height, kScreenWidth, kHotelOrderFooterViewHeight)];
    self.footerView.detailButton.hidden = YES;
    [self.footerView.payButton setTitle:@"生成订单" forState:UIControlStateNormal];
    [self.footerView addTarget:self andPayAction:@selector(checkCanCommit) andDetailAction:nil];
    [self.view addSubview:self.footerView];
    [self getWriteOrderData];
}

- (void)setupaddUser
{
    SBHUserModel *userModel = [GlobalData getSharedInstance].userModel;
    selectPerson *selPerson = [[selectPerson alloc] init];
    selPerson.iGender = userModel.Gender;
    selPerson.iBirthday = userModel.BirthDay;
    selPerson.iMobile = userModel.MobilePhone;
    selPerson.iCredtype = userModel.cardType;
    selPerson.iName = userModel.staffname;
    selPerson.rolename = userModel.DptName;
    selPerson.iCredNumber = userModel.certificatenumber;
    selPerson.iId = userModel.PID;
    if (userModel.staffname.length != 0|| ![userModel.staffname isEqualToString:@""])
    {
        [self.writeModel.selectPassArr insertObject:selPerson atIndex:0];
    }
}
#pragma mark - 设置费用中心默认值
- (void)setupCostCenter
{
    if(self.writeModel.isSpecialCompany && [GlobalData getSharedInstance].iTiketOrderInfo.travelReason == kTravelReasonTypeOnBusiness)
    {
        if([self.writeModel.selectPassArr count] == 1)
        {
            //个人账号  订单页面 先获取审批单  有审批单的费用中心把审批单读过来
            //无审批单的 费用中心是空   初始化页面时限给出无审批单提示
            //中新融创  公司和部门账号  订单页面费用中心初始化为空（必填）

            selectPerson *cjMoled = (selectPerson *)[self.writeModel.selectPassArr firstObject];
            [[ServerFactory getServerInstance:@"BeAirTicketOrderWriteTool"]getSpecilCompanyExpenseCenterWith:cjMoled.iName BySuccess:^(NSString *callback)
             {
                 projectObj *obj = [self.writeModel.projectArray firstObject];
                 obj.projectValue = callback;
                 NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:4];
                 [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
             }failure:^(NSString *failure)
             {
                 projectObj *obj = [self.writeModel.projectArray firstObject];
                 obj.projectValue = @"";
                 NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:4];
                 [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                 UIAlertView *alertView=[[UIAlertView alloc]
                                         initWithTitle:@"温馨提示"
                                         message:failure
                                         delegate:nil
                                         cancelButtonTitle:@"知道了"
                                         otherButtonTitles:nil];
                 [alertView show];
             }];
        }
        else
        {
            projectObj *obj = [self.writeModel.projectArray firstObject];
            obj.projectValue = @"";
        }
    }
    else
    {
        BOOL testBool = YES;
        for (int j=0;j<self.writeModel.selectPassArr.count;j++) {
            selectPerson *selPP = (selectPerson *)[self.writeModel.selectPassArr objectAtIndex:j];
            if (selPP.rolename.length != 0 && testBool) {
                projectObj *obj = [self.writeModel.projectArray firstObject];
                obj.projectValue = selPP.rolename;
                testBool = NO;
            }
        }
    }
}
#pragma mark - 显示保险详细
- (void)showInsurance:(UIButton *)sender
{
    BeOrderInsuranceModel *insuModel = [self.writeModel.insuranceArray objectAtIndex:sender.tag];
    BeAlteRetView *altRetView = [[BeAlteRetView alloc] initWithTitle:insuModel.insuranceDescription];
    [altRetView show];
}
#pragma mark - 增加保险
- (void)plusNumberAction:(UIButton *)sender
{
    BeOrderInsuranceModel *insuModel = [self.writeModel.insuranceArray objectAtIndex:sender.tag];
    int currentNumber = insuModel.insuranceCount;
    currentNumber ++;
    insuModel.insuranceCount = currentNumber;
    [self setupPriceTicket:nil];
}
#pragma mark - 减少保险
- (void)reduceNumberAction:(UIButton *)sender
{
    BeOrderInsuranceModel *insuModel = [self.writeModel.insuranceArray objectAtIndex:sender.tag];
    int currentNumber = insuModel.insuranceCount;
    currentNumber --;
    insuModel.insuranceCount = currentNumber;
    [self setupPriceTicket:nil];
}
#pragma mark - 退改规则
- (void)setupAlteRefuntWith:(BeBookFlightModel *)flightM
{
    NSString *contentStr = [NSString stringWithFormat:@"退改签规则\n更改条件:\n\n%@\n\n退票条件:\n\n%@\n\n改签条件:\n\n%@\n\n舱位:\n\n%@", flightM.Endorsement, flightM.Refund, flightM.EI, flightM.Code];
    BeAlteRetView *altRetView = [[BeAlteRetView alloc] initWithTitle:contentStr];
    [altRetView show];
}
#pragma mark - 新增乘机人
- (void)receiveAddPerson:(NSNotification *)noti
{
    selectPerson *personModel = [selectPerson mj_objectWithKeyValues:noti.userInfo];
    [self.writeModel.selectPassArr addObject:personModel];
    //判断是否超出预留机票的票数
    int max = ([[GlobalData getSharedInstance].seatTicketNum intValue] < 9 )? [[GlobalData getSharedInstance].seatTicketNum intValue]:9;
    if(self.writeModel.selectPassArr.count > max)
    {
        NSMutableIndexSet *indexSets = [[NSMutableIndexSet alloc] init];
        for (int i = 0 ; i < (self.writeModel.selectPassArr.count - max); i++)
        {
            [indexSets addIndex:i];
        }
        [self.writeModel.selectPassArr removeObjectsAtIndexes:indexSets];
    }
    [self setupPriceTicket:nil];
    [self setupCostCenter];
    [self.tableView reloadData];
}
- (void)rotDelBtnClick:(UIButton *)btn
{
    btn.layer.anchorPoint = CGPointMake(0.5, 0.5);
    btn.selected = !btn.selected;
    if (btn.selected) {
        [UIView animateWithDuration:0.3 animations:^{
            btn.transform = CGAffineTransformRotate(btn.transform, M_PI_2);
        }];
        NSIndexPath *path = [NSIndexPath indexPathForRow:(btn.tag - 2000 + 1) inSection:1];
        dingdantianxieTableViewCell *cell = (dingdantianxieTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
        cell.delChengjrBtn.hidden = NO;
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            //            btn.transform = CGAffineTransformRotate(btn.transform, );
            btn.transform = CGAffineTransformIdentity;
        }];
        NSIndexPath *path = [NSIndexPath indexPathForRow:(btn.tag - 2000 + 1) inSection:1];
        dingdantianxieTableViewCell *cell = (dingdantianxieTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
        cell.delChengjrBtn.hidden = YES;
    }
}

- (void)deletePassenger:(UIButton *)btn
{
    selectPerson *selpp = [self.writeModel.selectPassArr objectAtIndex:(btn.tag - 3000)];
    NSString *biaoxianStr = selpp.iInsquantity;
    [self.writeModel.selectPassArr removeObjectAtIndex:(btn.tag - 3000)];
    [self setupPriceTicket:biaoxianStr];
    [self setupCostCenter];
    [self.tableView reloadData];
}

- (void)rotDelBtn00Click:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [UIView animateWithDuration:0.3 animations:^{
            btn.transform = CGAffineTransformRotate(btn.transform, M_PI_2);
        }];
        NSIndexPath *path = [NSIndexPath indexPathForRow:(btn.tag - 4000 + 1) inSection:3];
        gongsilianxirenTableViewCell *cell = (gongsilianxirenTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
        cell.delLianxrBtn.hidden = NO;
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            btn.transform = CGAffineTransformIdentity;
        }];
        NSIndexPath *path = [NSIndexPath indexPathForRow:(btn.tag - 4000 + 1) inSection:3];
        gongsilianxirenTableViewCell *cell = (gongsilianxirenTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
        cell.delLianxrBtn.hidden = YES;
    }
}

- (void)dellianxr00Btn:(UIButton *)btn
{
    [self.writeModel.companyContactArray removeObjectAtIndex:(btn.tag - 5000)];
    [self.tableView reloadData];
}
#pragma mark - 添加乘机人
-(void)choosePassenger:(UIButton*)btn
{
    xuanzechengjirenViewController *xuanze = [[xuanzechengjirenViewController alloc] init];
    xuanze.title = @"选择乘机人";
    xuanze.enType = BeChoosePersonTypeAirFlight;
    xuanze.isSpecialCompany = self.writeModel.isSpecialCompany;
    xuanze.maxCount = self.writeModel.maxPassengerCount;
    [xuanze.selectArray addObjectsFromArray:self.writeModel.selectPassArr];
    xuanze.block = ^(NSMutableArray *callback)
    {
        [self.writeModel.selectPassArr removeAllObjects];
        [self.writeModel.selectPassArr addObjectsFromArray:callback];
        [self setupPriceTicket:nil];
        [self setupCostCenter];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:xuanze animated:YES];
}
#pragma mark - 添加联系人
- (void)addConnnectPerson:(UIButton*)btn
{
    gongsilianxirenController *gongsi = [[gongsilianxirenController alloc] init];
    gongsi.sourceType = ContactSourceTypeAdd;
    gongsi.block = ^(selectContact *selectedModel)
    {
        [self.writeModel.companyContactArray addObject:selectedModel];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:gongsi animated:YES];
}
#pragma mark - 获取联系人数据
- (void)requestContactList
{
    [[ServerFactory getServerInstance:@"BeAirTicketOrderWriteTool"]getOrderWriteContactListBySuccess:^(NSArray *callback,NSString *belongfunction)
     {
         self.writeModel.belongfunction = [belongfunction mutableCopy];
         [self.writeModel.companyContactArray removeAllObjects];
         [self.writeModel.companyContactArray addObjectsFromArray:callback];
         [self.tableView reloadData];
     }failure:^(NSString *failure)
    {
        [self handleResuetCode:failure];
    }];
}

#pragma mark - 点击生成订单
- (void)checkCanCommit
{
    
    //益普索 机票，乘机人新增或者修改手机号必填
    //判断时间是否超过
    NSDate * queryDate = [GlobalData getSharedInstance].queryTiketDate;
    NSTimeInterval  timeInterval = [queryDate timeIntervalSinceDate:queryDate];
    if(timeInterval > (60*10))
    {
        [CommonMethod showMessage:@"请在查询完后的10分钟内完成订票！"];
        return;
    }
    else
    {
        //是否选择了乘机人
        if([self.writeModel.selectPassArr count] < 1)
        {
            [CommonMethod showMessage:@"请选择乘机人！"];
            return;
        }
        //判断是否输入了信息
        //是否输入了费用中心
        // 如果有出差原因，检测是否输入了出差信息
        if ([self.writeModel.iscustomized isEqualToString:@"Y"]) {
            projectObj * centerOjb = [self.writeModel.projectArray objectAtIndex:0];
            if([centerOjb.projectValue length]<=0 && [GlobalData getSharedInstance].iTiketOrderInfo.travelReason == kTravelReasonTypeOnBusiness)
            {
                [MBProgressHUD showError:@"请输入费用中心！"];
                if(self.writeModel.isSpecialCompany)
                {
                    return;
                }
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:4];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.centerTextField becomeFirstResponder];
                });
                
                return;
            }
        }
        
        if (self.writeModel.showProjectReasons) {
            if([self.writeModel.projectArray count]>1)
            {
                projectObj *reaOjb = [self.writeModel.projectArray objectAtIndex:1];
                if([reaOjb.projectValue length]<=0 && [GlobalData getSharedInstance].iTiketOrderInfo.travelReason == kTravelReasonTypeOnBusiness)
                {
                    [MBProgressHUD showError:@"请输入出差原因!"];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:4];
                    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.reasonTextField becomeFirstResponder];
                    });
                    return;
                }
            }
        }

        for (int i =0; i<[self.writeModel.selectPassArr count]; i++)
        {
            selectPerson * selPeron = [self.writeModel.selectPassArr objectAtIndex:i];
            if([GlobalData getSharedInstance].userModel.isYiyang &&[selPeron.iCredNumber length] < 1)
            {
                NSString *warningTip = [NSString stringWithFormat:@"请填写乘机人%@的证件号码",selPeron.iName];
                [CommonMethod showMessage:warningTip];
                return;
            }
            if ([selPeron.iCredtype isEqualToString:@"身份证"]||[selPeron.iCredtype isEqualToString:@"1"])
            {
                if([GlobalData getSharedInstance].userModel.isYPS)
                {
                    if(selPeron.iMobile.length == 0)
                    {
                        [CommonMethod showMessage:@"请填写乘机人的手机号码"];
                        return;
                    }
                }
                if (![BeRegularExpressionUtil validateIdentityCard:selPeron.iCredNumber])
                {
                    [CommonMethod showMessage:@"请填写正确的乘机人身份证号码"];
                    return;
                }
            }
        }
    }
    if([GlobalData getSharedInstance].userModel.isYiyang)
    {
        [self checkYiyangFlightExpenseCenter];
    }
    else
    {
        [self commitOrder];
    }
    [MobClick event:@"J0004"];
}
#pragma mark - 查询亿阳的费用中心
- (void)checkYiyangFlightExpenseCenter
{
    [[ServerFactory getServerInstance:@"BeAirTicketOrderWriteTool"]checkYiyangFlightOrderWith:self.writeModel byCallback:^(NSDictionary *responseData)
     {
         if([[responseData stringValueForKey:@"FYZX"] length] > 0)
         {
             for (int i=0; i<[self.writeModel.projectArray count]; i++)
             {
                 projectObj *feicenobj = [self.writeModel.projectArray objectAtIndex:i];
                 if([feicenobj.projectCode isEqual:@"expensecenter"])
                 {
                     feicenobj.projectValue = [responseData stringValueForKey:@"FYZX"];
                 }
             }
             [self commitOrder];
         }
         else
         {
             [CommonMethod showMessage:@"没有查询到差旅单号"];
         }
     }failureCallback:^(NSError *error)
     {
         [CommonMethod showMessage:@"没有查询到差旅单号"];
     }];
    
}
#pragma mark - 提交订单
- (void)commitOrder
{
    [[ServerFactory getServerInstance:@"BeAirTicketOrderWriteTool"]commitFlightOrderWith:self.writeModel BySuccess:^(NSDictionary *dic)
    {
        NSString *status = [NSString stringWithFormat:@"%@",[dic objectForKey:@"state"]];
        NSString *NUM = [dic objectForKey:@"OrderNo"];
        NSString *code = [dic objectForKey:@"code"];
        if([code intValue] == 60001)
        {
            [CommonMethod showMessage:@"项目编号错误"];
            return ;
        }
        if([code intValue] == 20033)
        {
            [CommonMethod showMessage:@"系统正在下单，请稍后重试"];
        }
        else if([code intValue] == 20028)
        {
            BeFlightOrderWriteRuleViewController *ruleVC = [[BeFlightOrderWriteRuleViewController alloc]init];
            ruleVC.writeModel = self.writeModel;
            ruleVC.ruleDict = [dic objectForKey:@"cl"];
            [self.navigationController pushViewController:ruleVC animated:YES];
        }
        else if ([status isEqualToString:@"true"]) {
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
            if ([code intValue] == 20023)
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
                         [self commitOrder];
                    }
                 }];
            }
            else
            {
                [self handleResuetCode:code];
            }
        }
    }failure:^(id failure)
     {
         if([failure isKindOfClass:[NSString class]])
         {
             [CommonMethod showMessage:failure];
             return ;
         }
         [CommonMethod showMessage:kNetworkAbnormal];
    }];
}

#pragma mark - 获取页面数据
- (void)getWriteOrderData
{
    [[ServerFactory getServerInstance:@"BeAirTicketOrderWriteTool"]getOrderWriteDataBySuccess:^(id responseObj)
     {
         NSLog(@"获取页面数据 = %@",responseObj);
         if([[responseObj objectForKey:@"isinscustom"] isEqualToString:@"-1"]&&[[responseObj objectForKey:@"insquantity"] isEqualToString:@"-1"]&&[[responseObj objectForKey:@"insunitprice"] isEqualToString:@"-1"]&&[[responseObj objectForKey:@"insdescribe"] isEqualToString:@"-1"])
         {
             [CommonMethod showMessage:@"您好，以上往返行程需要分开预订，请您重新查询后预订。"];
             return ;
         }
         [BeOrderWriteModel mj_setupObjectClassInArray:^NSDictionary *{
             return @{@"airlist" : [BeOrderWriteAirlistModel class], @"contactList" : [BeOrderWriteAuditInfoModel class]};
         }];
         BeOrderWriteModel *writeM = [BeOrderWriteModel mj_objectWithKeyValues:responseObj];

         writeM.showProjectReasons = [responseObj boolValueForKey:@"isreasons"];
         BeOrderInsuranceModel *insuModel = [[BeOrderInsuranceModel alloc]init];
         insuModel.insuranceName = kInsuranceTitleA;
         int max = [[responseObj objectForKey:@"insquantity"] intValue] > 5?[[responseObj objectForKey:@"insquantity"] intValue]:5;
         insuModel.maxCount = max;
         insuModel.insurancePrice = [responseObj objectForKey:@"insunitprice"];
         insuModel.insuranceType = [[responseObj objectForKey:@"isinscustom"] intValue];
         insuModel.insuranceCount = [[responseObj objectForKey:@"insquantity"] intValue];
         [writeM.insuranceDict setObject:insuModel.insurancePrice forKey:kInsuranceTitleA];
         if(insuModel.insuranceType != 1)
         {
             [writeM.insuranceArray addObject:insuModel];
         }
         if([writeM.dingzhi isEqualToString:[GlobalData getSharedInstance].userModel.entId])
         {
             writeM.isSpecialCompany = YES;
         }
         else
         {
             writeM.isSpecialCompany = NO;
         }
         
         if (writeM.airlist.count > 1) {
             BeOrderWriteAirlistModel *goairM = writeM.airlist.firstObject;
             BeOrderWriteAirlistModel *backairM = writeM.airlist.lastObject;
             goairM.flightno = [NSString stringWithFormat:@"去程:%@", goairM.flightno];
             backairM.flightno = [NSString stringWithFormat:@"返程:%@", backairM.flightno];
         }
         [writeM setupDataWithDict:responseObj];
         if([GlobalData getSharedInstance].userModel.accountType == AccountTypeEntIndividual && [GlobalData getSharedInstance].userModel.IsBooked == 1)
         {
            // 员工账号  判断"IsBooked": "True"   是True的话不能为其他人预定     非True的话可以为其他人预定
             writeM.isContactCanEdit = NO;
         }
         self.writeModel = writeM;
         if([[GlobalData getSharedInstance].seatTicketNum intValue] < 9)
         {
             self.writeModel.maxPassengerCount = [[GlobalData getSharedInstance].seatTicketNum intValue];
         }
         if(self.writeModel.isSpecialCompany)
         {
             self.writeModel.maxPassengerCount = 1;
         }
         //费用中心
         if ([self.writeModel.iscustomized isEqualToString:@"Y"])
         {
             projectObj * aobj = [[projectObj alloc] init];
             aobj.projectCode = @"expensecenter";
             aobj.projectName = @"费用中心";
             aobj.projectValue= @"";
             if (([[GlobalData getSharedInstance].userModel.levelcode isEqualToString:@"2"] ||[[GlobalData getSharedInstance].userModel.levelcode isEqualToString:@"3"]) && ([GlobalData getSharedInstance].userModel.DptName.length > 0))
             {
                 aobj.projectValue = [GlobalData getSharedInstance].userModel.DptName;
             }
             aobj.isShow = YES;
             [self.writeModel.projectArray addObject:aobj];
         }
         
         // 出差原因
         if (self.writeModel.showProjectReasons)
         {
             projectObj *reason = [[projectObj alloc] init];
             reason.projectCode = @"isreasons";
             reason.projectName = @"出差原因";
             reason.projectValue= @"";
             reason.isShow = YES;
             [self.writeModel.projectArray addObject:reason];
         }
         NSString *MINGCHENG =  self.writeModel.isprojectname;
         NSString *BIANMA    = self.writeModel.isprojectno;
         
         MINGCHENG = (MINGCHENG == nil?@"":MINGCHENG);
         BIANMA    = (BIANMA == nil?@"":BIANMA);
         //项目名称
         if([MINGCHENG isEqualToString:@""] || [MINGCHENG isEqualToString:@"Y"])
         {
             projectObj * pronamebj = [[projectObj alloc] init];
             pronamebj.projectCode = @"projectname";
             pronamebj.projectName = @"项目名称";
             pronamebj.projectValue= @"";
             pronamebj.isShow = YES;
             [self.writeModel.projectArray addObject:pronamebj];
         }
         //项目编码
         if([BIANMA isEqualToString:@""]
            || [BIANMA isEqualToString:@"Y"])
         {
             projectObj * pronamebj = [[projectObj alloc] init];
             pronamebj.projectName = @"项目编号";
             pronamebj.projectCode = @"projectcode";
             pronamebj.projectValue= @"";
             pronamebj.isShow = YES;
             [self.writeModel.projectArray addObject:pronamebj];
         }
         if(self.writeModel.isSpecialCompany == YES)
         {
             [self setupCostCenter];
         }
         self.tableView.hidden = NO;
         [self.tableView reloadData];
         [self requestContactList];
         [self setupaddUser];
         [self setupPriceTicket:nil];
         [self getInsuranceData];
     }failure:^(NSError *error)
    {
        [self requestFlase:error];
    }];
}
#pragma mark - 获取保险数据
- (void)getInsuranceData
{
    [[ServerFactory getServerInstance:@"BeAirTicketOrderWriteTool"]getInsuranceDataBySuccess:^(NSString *info1, NSString * price1,NSString *info2, NSString * price2,NSString *info3, NSString * price3,NSArray *successArray)
     {
         BOOL showDelayCell = YES;
         NSDate *today = [NSDate date];
         NSString * todayString = [[today description] substringToIndex:10];
         BeOrderWriteAirlistModel *model = [self.writeModel.airlist firstObject];
         NSString * dateString = [[model.departuredate substringToIndex:10] stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
         if ([dateString isEqualToString:todayString])
         {
             //当天订票，不显示延误险
             showDelayCell = NO;
         }
         if(self.writeModel.insuranceArray.count > 0)
         {
             BeOrderInsuranceModel *firstObject = self.writeModel.insuranceArray.firstObject;
             if([firstObject.insuranceName isEqualToString:kInsuranceTitleA])
             {
                 firstObject.insuranceDescription = [NSString stringWithFormat:@"保险保障明细\n\n%@", [[[successArray objectAtIndex:0] objectForKey:@"info"]stringByReplacingOccurrencesOfString:@"|" withString:@"\n"]];
             }
         }
         
         for(int i = 1;i <= 2;i++)
         {
             NSString *name = [[NSString alloc] init];
             switch (i) {
                 case 1:
                     name = kInsuranceTitleB;
                     break;
                 case 2:
                     name = kInsuranceTitleDelay;
                     break;
                 default:
                     name = kInsuranceTitleDelay;
                     break;
             }
             NSDictionary *member = [successArray objectAtIndex:i];
             BeOrderInsuranceModel *insuModel = [[BeOrderInsuranceModel alloc]init];
             insuModel.insuranceName = name;
             insuModel.maxCount = 1;
             insuModel.insurancePrice = [member objectForKey:@"price"];
             insuModel.insuranceType = [[member objectForKey:@"bt"] intValue];
             if(insuModel.insuranceType == InsuranceTypeForced)
             {
                 insuModel.insuranceCount = 1;//强制的话，份数为1
             }
             else
             {
                 insuModel.insuranceCount = 0;
             }
             insuModel.insuranceDescription = [NSString stringWithFormat:@"保险保障明细\n\n%@", [[member objectForKey:@"info"]stringByReplacingOccurrencesOfString:@"|" withString:@"\n"]];
             [self.writeModel.insuranceDict setObject:insuModel.insurancePrice forKey:name];
             if(([[member objectForKey:@"bt"] intValue] != 1) && (i == 1 || (i == 2 && showDelayCell)))
             {
                 [self.writeModel.insuranceArray addObject:insuModel];
             }
         }
         [self setupPriceTicket:nil];
         [self setupCostCenter];
         [self.tableView reloadData];
     }failure:^(NSString *failure)
     {
         NSLog(@"获取保险失败%@",failure);
     }];
}
#pragma mark - 设置底部显示的总额
- (void)setupPriceTicket:(NSString *)str
{
    int priceInt = [self.writeModel getAllPrice];
    NSString *priceMoney = [NSString stringWithFormat:@"￥%d",priceInt];
    NSString *preStr = [NSString stringWithFormat:@"共%lu人  合计:",(unsigned long)[self.writeModel.selectPassArr count]];
    NSString *string =[NSString stringWithFormat:@"共%lu人  合计:￥%d",(unsigned long)[self.writeModel.selectPassArr count],
                       priceInt];
    NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:string];
    [attrib addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, string.length)];
    [attrib addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(preStr.length, priceMoney.length)];
    self.footerView.priceLabel.attributedText = attrib;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag - 100 >= 0)
    {
        if([self.writeModel.projectArray objectAtIndex:textField.tag - 100]!=nil)
        {
            projectObj *obj = [self.writeModel.projectArray objectAtIndex:textField.tag - 100];
            obj.projectValue = textField.text;
        }
    }
}

#pragma mark - TableViewDelegate && Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return self.writeModel.airlist.count;
    }
    if (section==1)
    {
        return [self.writeModel.selectPassArr count] + 1;
    }
    if (section==2)
    {
        return self.writeModel.insuranceArray.count;
    }
    if (section==3)
    {
        return [self.writeModel.companyContactArray count] + 1;
    }
    if (section==4)
    {
        return [self.writeModel.projectArray count];
    }
    if(section == 5)
    {
        return self.writeModel.auditType == AuditTypeOld?2:0;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([GlobalData getSharedInstance].iTiketOrderInfo.travelReason == kTravelReasonTypePrivate || [GlobalData getSharedInstance].userModel.accountType == AccountTypeIndependentIndividual)
    {
        return 4;
    }
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section==0 ? 145: 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //航班列表
        SBHDingdtxHeaterCell *cell = [SBHDingdtxHeaterCell cellWithTableView:tableView];
        BeOrderWriteAirlistModel *airM = [self.writeModel.airlist objectAtIndex:indexPath.row];
        BeBookFlightModel *bookM = [[GlobalData getSharedInstance].chooseFlightArray objectAtIndex:indexPath.row];
        if (self.writeModel.airlist.count > 1) {
            if (indexPath.row == 0) {
                airM.departuredate = [GlobalData getSharedInstance].quchengDate;
                cell.orderWriteAltRetRuleCell = ^{
                    [self setupAlteRefuntWith:bookM];
                };
            } else {
                airM.departuredate = [GlobalData getSharedInstance].huichengDate;
                cell.orderWriteAltRetRuleCell = ^{
                    [self setupAlteRefuntWith:bookM];
                };
            }
        } else {
            airM.departuredate = [GlobalData getSharedInstance].quchengDate;
            cell.orderWriteAltRetRuleCell = ^{
                [self setupAlteRefuntWith:bookM];
            };
        }
        cell.airListM = airM;
        return cell;
    }
    if (indexPath.section==1)
    {
        //乘机人
        if(indexPath.row == 0)
        {
            BeOrderTitleTableViewCell *cell = [BeOrderTitleTableViewCell cellWithTableView:tableView];
            [cell.bookButton addTarget:self action:@selector(choosePassenger:) forControlEvents:UIControlEventTouchUpInside];
            [cell.bookButton setTitle:@"选择乘机人" forState:UIControlStateNormal];
            cell.titleLabel.text = @"乘机人";
            cell.bookButton.hidden = !self.writeModel.isContactCanEdit;
            return cell;
        }
        else
        {
            dingdantianxieTableViewCell *passengerCell = [dingdantianxieTableViewCell cellWithTableView:tableView];
            passengerCell.sepImageView.hidden = YES;
            selectPerson *cjMoled = (selectPerson *)[self.writeModel.selectPassArr objectAtIndex:indexPath.row-1];
            passengerCell.xingming.text = cjMoled.iName;
            if(!self.writeModel.isContactCanEdit)
            {
                passengerCell.rotDelBtn.hidden = YES;
                passengerCell.delChengjrBtn.hidden = YES;
                passengerCell.rotDelBtn.hidden = YES;
                passengerCell.delChengjrBtn.hidden = YES;
                passengerCell.xingming.frame = CGRectMake(10, 10, 200, 20);
                return passengerCell;
            }
            else
            {
                [passengerCell.rotDelBtn addTarget:self action:@selector(rotDelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                passengerCell.rotDelBtn.tag = 2000 + indexPath.row - 1;
                [passengerCell.delChengjrBtn addTarget:self action:@selector(deletePassenger:) forControlEvents:UIControlEventTouchUpInside];
                passengerCell.delChengjrBtn.tag = 3000 + indexPath.row -1;
                return passengerCell;
            }
        }
    }
    if (indexPath.section==2)
    {
        //航班意外保险
        BeOrderWriteInsuranceCell *cell = [BeOrderWriteInsuranceCell cellWithTableView:tableView];
        BeOrderInsuranceModel *insuModel = [self.writeModel.insuranceArray objectAtIndex:indexPath.row];
        [cell setCellWithName:insuModel.insuranceName andCount:insuModel.insuranceCount andPrice:[insuModel.insurancePrice intValue] andMax:insuModel.maxCount andMin:0 andIsButtonHidden:insuModel.insuranceType == InsuranceTypeForced];
        cell.plusButton.tag = indexPath.row;
        cell.reduceButton.tag = indexPath.row;
        cell.nameButton.tag = indexPath.row;
        if(insuModel.insuranceType == InsuranceTypeOptional)
        {
            //可选
            [cell addTarget:self WithPlusAction:@selector(plusNumberAction:) andReduceAction:@selector(reduceNumberAction:) andShowInsurance:@selector(showInsurance:)];
        }
        else
        {
            //强制
            [cell addTarget:self WithPlusAction:nil andReduceAction:nil andShowInsurance:@selector(showInsurance:)];
        }
        return cell;
    }
    if (indexPath.section==3) {
        if(indexPath.row == 0)
        {
            BeOrderTitleTableViewCell *cell = [BeOrderTitleTableViewCell cellWithTableView:tableView];
            [cell.bookButton addTarget:self action:@selector(addConnnectPerson:) forControlEvents:UIControlEventTouchUpInside];
            [cell.bookButton setTitle:@"添加联系人" forState:UIControlStateNormal];
            cell.titleLabel.text = @"联系人";
            cell.bookButton.hidden = !self.writeModel.isContactCanEdit;
            return cell;
        }
        else
        {
            //联系人
            gongsilianxirenTableViewCell *cell = [gongsilianxirenTableViewCell cellWithTableView:tableView];
            cell.sepImageView.hidden = YES;
            selectContact * aselcontact = [self.writeModel.companyContactArray objectAtIndex:indexPath.row - 1];
            cell.name.text = aselcontact.iName;
            [cell setContact:aselcontact];
            [cell.rotDel00Btn addTarget:self action:@selector(rotDelBtn00Click:) forControlEvents:UIControlEventTouchUpInside];
            cell.rotDel00Btn.tag = 4000 + indexPath.row - 1;
            [cell.delLianxrBtn addTarget:self action:@selector(dellianxr00Btn:) forControlEvents:UIControlEventTouchUpInside];
            cell.delLianxrBtn.tag = 5000 + indexPath.row - 1;
            return cell;
        }
    }
    if (indexPath.section==4) {
        SBHDingdanCommonCell *cell = [SBHDingdanCommonCell cellWithTableView:tableView];
        cell.sepImageView.hidden = YES;
        projectObj * proObject = [self.writeModel.projectArray objectAtIndex:indexPath.row];
        cell.xingming.text = proObject.projectName;
        [cell.commonTextField setText:proObject.projectValue];
        cell.commonTextField.delegate = self;
        cell.commonTextField.tag = 100 + indexPath.row;
        UIColor *color = [UIColor redColor];
        if (indexPath.row==0)
        {
            cell.commonTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"(必填)" attributes:@{NSForegroundColorAttributeName: color}];
            self.centerTextField = cell.commonTextField;
            self.centerTextField.userInteractionEnabled = !self.writeModel.isSpecialCompany;
        }
        if (indexPath.row==1)
        {
            if (self.writeModel.showProjectReasons) {
                cell.commonTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"(必填)" attributes:@{NSForegroundColorAttributeName: color}];
                self.reasonTextField = cell.commonTextField;
            }
        }
        [cell setProject:proObject];
        cell.xingming.textColor = SBHColor(51, 51, 51);
        return cell;
    }
    if (indexPath.section==5) {
        if(indexPath.row == 0)
        {
            SBHDingdanCommonCell *cell = [SBHDingdanCommonCell cellWithTableView:tableView];
            cell.xingming.textColor = [UIColor orangeColor];
            cell.commonTextField.hidden = YES;
            if ([GlobalData getSharedInstance].iTiketOrderInfo.travelReason == kTravelReasonTypePrivate) {
                cell.xingming.text = @"个人支付";
            }
            else if (self.writeModel.auditType == AuditTypeNone)
            {
                
                cell.xingming.text = kPayTipString;
            }
            else
            {
                cell.xingming.text = [NSString stringWithFormat:@"审批通过后，系统自动%@",kPayTipString];
            }
            return cell;
        }
        else
        {
            UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
            BeOrderWriteAuditInfoModel *model = [self.writeModel.selectedAuditPersonArray objectAtIndex:(indexPath.row - 1)];
            cell.textLabel.text = model.displayLevel;
            cell.detailTextLabel.text = model.Name;
            return cell;
        }
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 2)
    {
        return self.writeModel.insuranceArray.count == 0?0.01:6.0f;
    }
    return 6.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==3) {
        if(indexPath.row == 0)
        {
            return;
        }
        NSInteger index = indexPath.row - 1;
        gongsilianxirenController *gongsi = [[gongsilianxirenController alloc]init];
        gongsi.sourceType = ContactSourceTypeEdit;
        gongsi.contactModel = [self.writeModel.companyContactArray objectAtIndex:index];
        gongsi.block = ^ (selectContact *selectedModel)
        {
            [self.writeModel.companyContactArray removeObjectAtIndex:index];
            [self.writeModel.companyContactArray insertObject:selectedModel atIndex:index];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:gongsi animated:YES];
    }
    else if (indexPath.section==1){
        if(indexPath.row == 0)
        {
            return;
        }
        selectPerson * selPeron = [self.writeModel.selectPassArr objectAtIndex:indexPath.row - 1];
        if ([selPeron.iInsquantity isEqualToString:@"0"] || selPeron.iInsquantity.length == 0) {
            selPeron.iInsquantity = [NSString stringWithFormat:@"%d", [GlobalData getSharedInstance].insquantity];
        }
        BePassengerViewController *tian = [[BePassengerViewController alloc] init:selPeron];
        tian.sourceType = AddPassengerSourceTypeAirTicket;
        tian.canEdit = self.writeModel.isContactCanEdit;
        tian.block = ^(selectPerson *callback)
        {
            [self.writeModel.selectPassArr removeObjectAtIndex:indexPath.row - 1];
            [self.writeModel.selectPassArr insertObject:callback atIndex:indexPath.row - 1];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:tian animated:YES];
    }
    else if (indexPath.section == 5)
    {
        if(indexPath.row != 0)
        {
            BeAuditPersonViewController *personVC = [[BeAuditPersonViewController alloc]init];
            personVC.model = [self.writeModel.selectedAuditPersonArray objectAtIndex:indexPath.row -1];
            [self.navigationController pushViewController:personVC animated:YES];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
