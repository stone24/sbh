//
//  BeTrainBookingController.m
//  sbh
//
//  Created by SBH on 15/6/16.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTrainBookingController.h"
#import "xuanzechengjirenViewController.h"
#import "BePassengerViewController.h"
#import "gongsilianxirenController.h"
#import "BePriceListController.h"
#import "BeTrainTicketHomeViewController.h"

#import "dingdantianxieTableViewCell.h"
#import "gongsilianxirenTableViewCell.h"
#import "SBHDingdanCommonCell.h"
#import "SBHItemHeaderView.h"
#import "BeTrainBookingHeaderView.h"
#import "BeHotelOrderFooterView.h"

#import "SBHUserModel.h"
#import "CommonDefine.h"
#import "SBHHttp.h"
#import "BeTrainBookModel.h"
#import "BeRegularExpressionUtil.h"
#import "ServerFactory.h"
#import "BeTrainServer.h"
#import "UIAlertView+Block.h"

#define kSectionTitlePassenger @"0"
#define kSectionTitleContact @"1"
#define kSectionTitlePay @"2"
#define kSectionTitleSum @"3"

@interface BeTrainBookingController () <UITextFieldDelegate>
{
    NSMutableArray *sectionTitleArray;
    NSTimer *myTimer;
    NSString *minuTime;
    NSString *secondTime;
    UILabel *tableHeaderLabel;
}
@property (nonatomic, strong) BeHotelOrderFooterView *footerView;
@property (nonatomic, strong) UITextField *centerTextField;
@end

@implementation BeTrainBookingController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        sectionTitleArray = [[NSMutableArray alloc]init];
        self.sourceType = TrainBookSourceTypeGenerate;
    }
    return self;
}

- (void)rightbtn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"BeTrainBookingController"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"BeTrainBookingController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAddPerson:) name:kNotificationAddHotelPerson object:nil];
    self.tableView.backgroundColor = SBHColor(240, 240, 240);
    self.tableView.height = self.tableView.height - kHotelOrderFooterViewHeight;
    self.footerView = [[BeHotelOrderFooterView alloc]initWithFrame:CGRectMake(0, self.tableView.height, kScreenWidth, kHotelOrderFooterViewHeight)];
    [self.footerView addTarget:self andPayAction:@selector(orderSubmitAction) andDetailAction:@selector(priceDetailBtnClick)];
    [self.view addSubview:self.footerView];

    if(self.sourceType == TrainBookSourceTypeGenerate)
    {
        self.title = @"订单填写";
        [self setupRequestData];
        self.tableView.hidden = YES;
        [self.footerView.payButton setTitle:@"提交订单" forState:UIControlStateNormal];
    }
    else
    {
        [sectionTitleArray removeAllObjects];
        [sectionTitleArray addObjectsFromArray:@[kSectionTitlePassenger,kSectionTitleContact,kSectionTitlePay]];
        if([self.bookModel.projectArray count]> 0)
        {
            [sectionTitleArray addObject:kSectionTitleSum];
        }
        [self setupPriceTicket:nil];
        self.title = @"确认订单";
        [self.footerView.payButton setTitle:@"去支付" forState:UIControlStateNormal];
        minuTime = @"15";
        secondTime = @"00";
        [self setupTableViewHeader];
        [self addPayTimer];
    }
}
#pragma mark - 新增乘客
- (void)receiveAddPerson:(NSNotification *)noti
{
    int max = 5;
    selectPerson *personModel = [selectPerson mj_objectWithKeyValues:noti.userInfo];
    [self.bookModel.passengerArray addObjectsFromArray:@[personModel]];
    if(self.bookModel.passengerArray.count > max)
    {
        NSMutableIndexSet *indexSets = [[NSMutableIndexSet alloc] init];
        for (int i = 0 ; i < (self.bookModel.passengerArray.count - max); i++)
        {
            [indexSets addIndex:i];
        }
        [self.bookModel.passengerArray removeObjectsAtIndexes:indexSets];
    }
    
    [self setupPriceTicket:nil];
    [self setupCostCenter];
    [self.tableView reloadData];
}
- (void)setupTableViewHeader
{
    if(self.sourceType == TrainBookSourceTypeConfirm)
    {
        UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
        tableHeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, kScreenWidth - 30, 60)];
        tableHeaderLabel.font = [UIFont systemFontOfSize:14];
        tableHeaderLabel.numberOfLines = 0;
        tableHeaderLabel.textColor = SBHColor(153, 153, 153);
        NSString *string = [NSString stringWithFormat:@"为确保出票,请在%@:%@内完成支付,逾期将自动取消订单。以免车票售完或价格变化,给您的出行带来不便。", minuTime, secondTime];
        NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:string];
        [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange(8, 5)];
        [attrib addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:19] range:NSMakeRange(8, 5)];
        tableHeaderLabel.attributedText = attrib;
        [tableHeaderView addSubview:tableHeaderLabel];
        self.tableView.tableHeaderView = tableHeaderView;
    }
}
#pragma mark - 设置费用中心默认值
- (void)setupCostCenter
{
    BOOL testBool = YES;
    for (int j=0;j<self.bookModel.passengerArray.count;j++) {
        selectPerson *selPP = (selectPerson *)[self.bookModel.passengerArray objectAtIndex:j];
        if (selPP.rolename.length != 0 && testBool) {
            projectObj *obj = [self.bookModel.projectArray firstObject];
            obj.projectValue = selPP.rolename;
            testBool = NO;
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *title = [sectionTitleArray objectAtIndex:section];
    if([title isEqualToString:kSectionTitlePassenger])
    {
        return [self.bookModel.passengerArray count]+1;
    }
    else if([title isEqualToString:kSectionTitleContact])
    {
        return [self.bookModel.contactArray count]+1;
    }
    else if([title isEqualToString:kSectionTitlePay])
    {
        return 1;
    }
    else if([title isEqualToString:kSectionTitleSum])
    {
        return [self.bookModel.projectArray count];
    }
    return 4;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        BeTrainBookingHeaderView *headerView = [BeTrainBookingHeaderView tabelViewHeaderView];
        headerView.bookModel = self.bookModel;
        headerView.height = 125;
        return headerView;
    }
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionTitleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [sectionTitleArray objectAtIndex:indexPath.section];
    if([title isEqualToString:kSectionTitlePassenger])
    {
        if(indexPath.row == 0)
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            titleLabel.textColor = [UIColor darkGrayColor];
            [cell.contentView addSubview:titleLabel];
            titleLabel.text = @"乘车人";
            if(self.sourceType == TrainBookSourceTypeGenerate)
            {
                UIButton *bookButton = [UIButton buttonWithType:UIButtonTypeCustom];
                bookButton.frame = CGRectMake(kScreenWidth - 85, 8, 72, 23);
                bookButton.layer.cornerRadius = 3.0f;
                [bookButton setBackgroundColor:[ColorConfigure globalBgColor]];
                bookButton.titleLabel.font = [UIFont systemFontOfSize:13];
                [cell.contentView addSubview:bookButton];
                [bookButton addTarget:self action:@selector(btn1:) forControlEvents:UIControlEventTouchUpInside];
                [bookButton setTitle:@"选择乘车人" forState:UIControlStateNormal];
            }
            return cell;
        }
        else
        {
            if(self.sourceType == TrainBookSourceTypeGenerate)
            {
            static NSString *cell1 = @"dingdantianxieTableViewCell";
            dingdantianxieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell1];
            if (!cell)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"dingdantianxieTableViewCell" owner:self options:nil] objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType  = UITableViewCellAccessoryNone;
            }
            cell.sepImageView.hidden = YES;
            selectPerson *cjMoled = (selectPerson *)[self.bookModel.passengerArray objectAtIndex:indexPath.row-1];
            cell.xingming.text = cjMoled.iName;
            
                [cell.rotDelBtn addTarget:self action:@selector(rotDelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.rotDelBtn.tag = 2000 + indexPath.row;
                [cell.delChengjrBtn addTarget:self action:@selector(delChengjrBtn:) forControlEvents:UIControlEventTouchUpInside];
                cell.delChengjrBtn.tag = 3000 + indexPath.row;
                return cell;

            }
           else
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
               
               selectPerson *pasModel = [self.bookModel.passengerArray objectAtIndex:(indexPath.row-1)];
               cell.commonTextField.text = pasModel.iCredNumber;
               cell.xingming.text = pasModel.iName;
               return cell;
           }
        }
    }
    else if([title isEqualToString:kSectionTitleContact])
    {
        if(indexPath.row == 0)
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            titleLabel.textColor = [UIColor darkGrayColor];
            [cell.contentView addSubview:titleLabel];
            titleLabel.text = @"联系人";
            return cell;
        }
        else
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
            
            selectContact *pasModel = [self.bookModel.contactArray objectAtIndex:(indexPath.row-1)];
            cell.commonTextField.text = pasModel.iMobile;
            cell.xingming.text = pasModel.iName;
            return cell;
        }
    }
    else if([title isEqualToString:kSectionTitlePay])
    {
        SBHDingdanCommonCell *cell = nil;
        static NSString *cell1 = @"SBHDingdanCommonCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cell1];
        cell.commonTextField.userInteractionEnabled = NO;
        if (!cell)
        {
            if (indexPath.row==0) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SBHDingdanCommonCell" owner:self options:nil] objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType  = UITableViewCellAccessoryNone;
                cell.xingming.text = kPayTipString;
                cell.xingming.textColor = SBHColor(51, 51, 51);
                cell.sepImageView.hidden = YES;
                cell.commonTextField.hidden = YES;
            }
        }
        return cell;
    }
    else if([title isEqualToString:kSectionTitleSum])
    {
        SBHDingdanCommonCell *cell = nil;
        static NSString *cell1 = @"SBHDingdanCommonCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cell1];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SBHDingdanCommonCell" owner:self options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType  = UITableViewCellAccessoryNone;
            projectObj * proObject = [self.bookModel.projectArray objectAtIndex:indexPath.row];
            cell.xingming.text = proObject.projectName;
            cell.sepImageView.hidden = YES;
            [cell.commonTextField setText:proObject.projectValue];
            if (indexPath.row == 0) {
                self.centerTextField = cell.commonTextField;
            }
            if (indexPath.row==0)
            {
                UIColor *color = [UIColor redColor];
                cell.commonTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"必填" attributes:@{NSForegroundColorAttributeName: color}];
            }
            if(self.sourceType == TrainBookSourceTypeGenerate)
            {
                cell.commonTextField.delegate = self;
                cell.commonTextField.tag = 100 + indexPath.row;
            }
            else
            {
                cell.commonTextField.enabled = NO;
            }
            [cell setProject:proObject];
            
        }
        cell.xingming.textColor = SBHColor(51, 51, 51);
        return cell;
    }
    return nil;
}

- (void)rotDelBtnClick:(UIButton *)btn
{
    btn.layer.anchorPoint = CGPointMake(0.5, 0.5);
    btn.selected = !btn.selected;
    if (btn.selected) {
        
        [UIView animateWithDuration:0.3 animations:^{
            btn.transform = CGAffineTransformRotate(btn.transform, M_PI_2);
        }];
        NSIndexPath *path = [NSIndexPath indexPathForRow:(btn.tag - 2000) inSection:[sectionTitleArray indexOfObject:kSectionTitlePassenger]];
        dingdantianxieTableViewCell *cell = (dingdantianxieTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
        cell.delChengjrBtn.hidden = NO;
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            //            btn.transform = CGAffineTransformRotate(btn.transform, );
            btn.transform = CGAffineTransformIdentity;
        }];
        NSIndexPath *path = [NSIndexPath indexPathForRow:(btn.tag - 2000) inSection:[sectionTitleArray indexOfObject:kSectionTitlePassenger]];
        dingdantianxieTableViewCell *cell = (dingdantianxieTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
        cell.delChengjrBtn.hidden = YES;
    }
}

- (void)delChengjrBtn:(UIButton *)btn
{
    selectPerson *selpp = [self.bookModel.passengerArray objectAtIndex:(btn.tag - 3000-1)];
    NSString *biaoxianStr = selpp.iInsquantity;
    [self.bookModel.passengerArray removeObjectAtIndex:(btn.tag - 3000-1)];
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
        NSIndexPath *path = [NSIndexPath indexPathForRow:(btn.tag - 4000) inSection:[sectionTitleArray indexOfObject:kSectionTitleContact]];
        gongsilianxirenTableViewCell *cell = (gongsilianxirenTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
        cell.delLianxrBtn.hidden = NO;
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            btn.transform = CGAffineTransformIdentity;
        }];
        NSIndexPath *path = [NSIndexPath indexPathForRow:(btn.tag - 4000) inSection:[sectionTitleArray indexOfObject:kSectionTitleContact]];
        gongsilianxirenTableViewCell *cell = (gongsilianxirenTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
        cell.delLianxrBtn.hidden = YES;
    }
}

- (void)dellianxr00Btn:(UIButton *)btn
{
    [self.bookModel.contactArray removeObjectAtIndex:(btn.tag - 5000-1)];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 125.0f;
    }
    return 6.0;
}
#pragma mark - 选择乘车人
-(void)btn1:(UIButton*)btn{
    xuanzechengjirenViewController *xuanze = [[xuanzechengjirenViewController alloc] init];
    xuanze.title = @"选择乘车人";
    xuanze.enType = BeChoosePersonTypeTrain;
    [xuanze.selectArray addObjectsFromArray:self.bookModel.passengerArray];
    xuanze.maxCount = 5;
    xuanze.block = ^(NSMutableArray *callback)
    {
        [self.bookModel.passengerArray removeAllObjects];
        [self.bookModel.passengerArray addObjectsFromArray:callback];
        [self setupPriceTicket:nil];
        [self setupCostCenter];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:xuanze animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.sourceType == TrainBookSourceTypeConfirm)
    {
        return;
    }
    NSString *titleString = [sectionTitleArray objectAtIndex:indexPath.section];
    if ([titleString isEqualToString:kSectionTitleContact]) {
        if (indexPath.row !=0) {
            NSInteger index = indexPath.row - 1;
            gongsilianxirenController *gongsi = [[gongsilianxirenController alloc]init];
            gongsi.sourceType = ContactSourceTypeEdit;
            gongsi.contactModel = [self.bookModel.contactArray objectAtIndex:index];
            gongsi.block = ^ (selectContact *selectedModel)
            {
                [self.bookModel.contactArray removeObjectAtIndex:index];
                [self.bookModel.contactArray insertObject:selectedModel atIndex:index];
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:gongsi animated:YES];
        }
    }
    else if ([titleString isEqualToString:kSectionTitlePassenger]){
        if(indexPath.row !=0)
        {
            selectPerson * selPeron = [self.bookModel.passengerArray objectAtIndex:(indexPath.row-1)];
            BePassengerViewController *tian = [[BePassengerViewController alloc] init:selPeron];
            tian.sourceType = AddPassengerSourceTypeTrain;
            tian.block = ^(selectPerson *callback)
            {
                [self.bookModel.passengerArray removeObjectAtIndex:indexPath.row - 1];
                [self.bookModel.passengerArray insertObject:callback atIndex:indexPath.row - 1];
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            };
            tian.title = kaddPassengerTypeTrain;
            [self.navigationController pushViewController:tian animated:YES];
        }
    }
}

#pragma mark - 提交订单
- (void)setupRequestOrderSubmitWith:(NSString *)ptrue
{
    [[ServerFactory getServerInstance:@"BeTrainServer"]commitTrainOrderWithData:self.bookModel andPture:ptrue andSuccess:^(NSDictionary *callback)
    {
        [MBProgressHUD showSuccess:@"订单提交成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }andFailure:^(NSError *error)
    {
        if([[error.userInfo stringValueForKey:@"code" defaultValue:@""]isEqualToString:@"20010"] && [ptrue isEqualToString:@"0"])
        {
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"" message:@"乘车人已预订同一车次，确定继续预订吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [al showAlertViewWithCompleteBlock:^(NSInteger index)
             {
                 if(index == 0)
                 {
                     [self.navigationController popToRootViewControllerAnimated:YES];
                 }
                 else
                 {
                     [self setupRequestOrderSubmitWith:@"1"];
                 }
             }];
        }
        else if([[error.userInfo stringValueForKey:@"code" defaultValue:@""]isEqualToString:@"20023"])
        {
            [CommonMethod showMessage:@"您的企业剩余额度不足"];
        }
        else if([[error.userInfo stringValueForKey:@"code" defaultValue:@""]isEqualToString:@"10004"])
        {
            [CommonMethod showMessage:@"当前用户没有开通权限"];
        }
        else
        {
            [self requestFlase:error];
        }
    }];
}
- (void)checkYiyangTrainOrder
{
    [[ServerFactory getServerInstance:@"BeTrainServer"]checkYiyangTrainOrderWith:self.bookModel byCallback:^(NSDictionary *responseData)
     {
         if([[responseData stringValueForKey:@"FYZX"] length] > 0)
         {
             for (int i=0; i<[self.bookModel.projectArray count]; i++)
             {
                 projectObj *feicenobj = [self.bookModel.projectArray objectAtIndex:i];
                 if([feicenobj.projectCode isEqual:@"expensecenter"])
                 {
                    feicenobj.projectValue = [responseData stringValueForKey:@"FYZX"];
                 }
             }
             [self showAlert];
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
- (void)showAlert
{

    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"暂不支持退改签,出票完成后直接同步保理,将予短信通知,确认购买吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [al showAlertViewWithCompleteBlock:^(NSInteger index)
     {
        if(index == 0)
        {
            
        }
         else
         {
             [self setupRequestOrderSubmitWith:@"0"];
         }
     }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==3011 || alertView.tag == 5001) {

        
    }
    else if (alertView.tag == 10001){
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    if (alertView.tag==3001) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [BeLogUtility doLogOn];
        });
        
    }
    
    if (alertView.tag == 7777) {
        if (buttonIndex == 1) {
        }
        
    }
}

#pragma mark 火车票预定信息请求
- (void)setupRequestData
{
    [[ServerFactory getServerInstance:@"BeTrainServer"]getTrainOrderWriteData:self.bookModel andSuccess:^(NSDictionary *responseObj)
    {
        self.bookModel.servicemoney = [responseObj stringValueForKey:@"servicemoney" defaultValue:@"0"];

        NSString *isExpense = [responseObj objectForKey:@"iscustomized"];
        NSString *isPro = [responseObj objectForKey:@"isprojectname"];
        NSString *isRea = [responseObj objectForKey:@"isreasons"];
        NSString *projectCode = [responseObj objectForKey:@"isprojectno"];
        //费用中心
        if ([isExpense isEqualToString:@"Y"]) {
            projectObj * aobj = [[projectObj alloc] init];
            aobj.projectCode = @"expensecenter";
            aobj.projectName = @"费用中心";
            aobj.projectValue= @"";
            aobj.isShow = YES;
            aobj.isRequired = YES;
            [self.bookModel.projectArray addObject:aobj];
        }
        
        //项目编号
        if ([projectCode isEqualToString:@"Y"]) {
            projectObj * pronamebj = [[projectObj alloc] init];
            pronamebj.projectCode = @"projectname";
            pronamebj.projectName = @"项目名称";
            pronamebj.projectValue= @"";
            pronamebj.isShow = YES;
            pronamebj.isRequired = NO;
            [self.bookModel.projectArray addObject:pronamebj];
        }
        //项目名称
        if ([isPro isEqualToString:@"Y"]) {
            projectObj * pronamebj = [[projectObj alloc] init];
            pronamebj.projectCode = @"projectname";
            pronamebj.projectName = @"项目名称";
            pronamebj.projectValue= @"";
            pronamebj.isShow = YES;
            pronamebj.isRequired = NO;
            [self.bookModel.projectArray addObject:pronamebj];
        }
        //出差原因
        if ([isRea isEqualToString:@"1"]) {
            projectObj *resonbj = [[projectObj alloc] init];
            resonbj.projectName = @"出行原因";
            resonbj.projectCode = @"reason";
            resonbj.projectValue= @"";
            resonbj.isShow = YES;
            resonbj.isRequired = YES;
            [self.bookModel.projectArray addObject:resonbj];
        }
        // 联系人
        NSArray *array = [responseObj objectForKey:@"contactList"];
        for (NSDictionary *dict in array) {
            selectContact *selCon = [[selectContact alloc] init];
            selCon.iName = [dict objectForKey:@"Name"];
            selCon.iMobile = [dict objectForKey:@"Mobile"];
            selCon.iPhone = [dict objectForKey:@"Tel"];
            selCon.iEmail = [dict objectForKey:@"Email"];
            selCon.PerType = [dict objectForKey:@"PerType"];
            selCon.FlowType = [dict objectForKey:@"FlowType"];
            selCon.LoginName = [GlobalData getSharedInstance].userModel.loginname;
            [self.bookModel.contactArray addObject:selCon];
        }
        [sectionTitleArray removeAllObjects];
        [sectionTitleArray addObjectsFromArray:@[kSectionTitlePassenger,kSectionTitleContact,kSectionTitlePay]];
        if([self.bookModel.projectArray count]> 0)
        {
            [sectionTitleArray addObject:kSectionTitleSum];
        }
        [self setupPriceTicket:nil];
        [self.tableView reloadData];
        self.tableView.hidden = NO;
    }andFailure:^(NSError *error)
    {
        if([[error.userInfo stringValueForKey:@"code" defaultValue:@""]isEqualToString:@"20009"])
        {
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"加载火车票预订信息失败,请重新预订" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [al showAlertViewWithCompleteBlock:^(NSInteger index)
             {
                 UIViewController * ticketHomeVC = [self getNavigationHistoryVC:                                                                                                                                                         [BeTrainTicketHomeViewController class]];
                 if(ticketHomeVC !=nil)
                 {
                     [self.navigationController popToViewController:ticketHomeVC animated:YES];
                 }
             }];
        }else{
            [self requestFlase:error];
        }
    }];
}

- (void)requestFlase:(NSError *)error
{
    if (error.code == kHttpRequestCancelledError || error.code == kErrCodeNetWorkUnavaible){
        [CommonMethod showMessage:kNetworkAbnormal];
    } else {
        if (error.code == 20013 || error.code == 20031) {
            [CommonMethod showMessage:@"企业额度不够,或是合同已到期，请验证后，再提交"];
        } else {
            [self handleResuetCode:[NSString stringWithFormat:@"%zd",error.code]];
        }
    }
}
- (void)getOrderStatus
{
    [[ServerFactory getServerInstance:@"BeTrainServer"]getTrainOrderStatusWith:self.bookModel.orderNo andSuccess:^(NSDictionary *callback)
    {
        if([[callback objectForKey:@"orderstatus"]isEqualToString:@"YQX"])
        {
            [MBProgressHUD hideHUD];
            [myTimer invalidate];
            [MBProgressHUD showError:@"占座失败"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else if([[callback objectForKey:@"orderstatus"]isEqualToString:@"YDZ"])
        {
            [MBProgressHUD hideHUD];
            [myTimer invalidate];
            BeTrainBookingController *bookVC = [[BeTrainBookingController alloc]init];
            bookVC.sourceType = TrainBookSourceTypeConfirm;
            bookVC.bookModel = self.bookModel;
            [self.navigationController pushViewController:bookVC animated:YES];
        }
        else if ([[callback objectForKey:@"orderstatus"]isEqualToString:@"YTJ"])
        {
            [MBProgressHUD hideHUD];
            [myTimer invalidate];
            [MBProgressHUD showSuccess:@"已经提交"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            [self addTimer];
        }
        /*
         code = 20020;
         orderstatus = ZZZ;
         status = ture;
         */
    }andFailure:^(NSError *error)
    {
        [self addTimer];
    }];
}
- (void)addTimer
{
    [myTimer invalidate];
    myTimer = [NSTimer  timerWithTimeInterval:1.0 target:self selector:@selector(getOrderStatus)userInfo:nil repeats:NO];
    [[NSRunLoop  currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
}
- (void)setupPriceTicket:(NSString *)str
{
    double Insure = [self.bookModel.selectPrice doubleValue] + [self.bookModel.servicemoney doubleValue];
    double priceDouble = Insure * [self.bookModel.passengerArray count];
    int priceInt = (int)priceDouble;
    NSString *priceMoney = nil;
    if (priceDouble == priceInt) {
        priceMoney = [NSString stringWithFormat:@"￥%d", priceInt];
    } else {
        priceMoney = [NSString stringWithFormat:@"￥%.2f", priceDouble];
    }
    NSString *preStr = [NSString stringWithFormat:@"共%zd人  合计:",[self.bookModel.passengerArray count]];
    NSString *string =[NSString stringWithFormat:@"共%zd人  合计:%@",[self.bookModel.passengerArray count],
                       priceMoney];
    // 富文本
    NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:string];
    [attrib addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(preStr.length, priceMoney.length)];
    self.footerView.priceLabel.attributedText = attrib;
}

//开始编辑时触发，文本字段将成为first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.tableView.contentOffset = CGPointMake(0, self.tableView.contentSize.height - self.view.height + 250);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 250, 0);
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.tableView.contentOffset = CGPointMake(0, self.tableView.contentSize.height - self.view.height + 49);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    projectObj *obj = [self.bookModel.projectArray objectAtIndex:textField.tag - 100];
    obj.projectValue = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    projectObj *obj = [self.bookModel.projectArray objectAtIndex:textField.tag - 100];
    obj.projectValue = textField.text;
    [self.view endEditing:YES];
    return YES;
}

// 回退方法
- (void)leftMenuClick
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"订单填写尚未完成，是否离开当前页面" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 10001;
    [alertView show];
}

- (void)orderSubmitAction
{
    if(self.sourceType == TrainBookSourceTypeGenerate)
    {
        if (self.bookModel.projectArray.count != 0) {
            projectObj * centerOjb = [self.bookModel.projectArray objectAtIndex:0];
            if([centerOjb.projectValue length]<=0)
            {
                [MBProgressHUD showError:@"请输入费用中心！"];
                [self.centerTextField becomeFirstResponder];
                return;
            }
        }
        NSMutableArray *identifierArray = [NSMutableArray array];
        if([self.bookModel.passengerArray count]<=0)
        {
            [CommonMethod showMessage:@"请选择乘车人！"];
            return;
        }
        for (int i =0; i<[self.bookModel.passengerArray count]; i++){
            selectPerson * selPeron = [self.bookModel.passengerArray objectAtIndex:i];
            if([identifierArray containsObject:selPeron.iCredNumber])
            {
                [CommonMethod showMessage:@"证件号码不能相同"];
                return ;
            }
            [identifierArray addObject:selPeron.iCredNumber];

            if ([selPeron.iType isEqualToString:@""]) {
                selPeron.iType = @"ADT";
            }
            if ([selPeron.iCredNumber isEqualToString:@""]) {
                [CommonMethod showMessage:@"证件号码不能为空"];
                return ;
            }
            if(!([selPeron.iCredtype isEqualToString:@"1"]||[selPeron.iCredtype isEqualToString:@"身份证"]||[selPeron.iCredtype isEqualToString:@"2"]||[selPeron.iCredtype isEqualToString:@"护照"])||[selPeron.iCredtype isEqualToString:@"4"]||[selPeron.iCredtype isEqualToString:@"台胞证"]||[selPeron.iCredtype isEqualToString:@"7"]||[selPeron.iCredtype isEqualToString:@"港澳通行证"])
            {
                NSString *str = [NSString stringWithFormat:@"请%@选择身份证、护照、台胞证、港澳通行证买票", selPeron.iName];
                [CommonMethod showMessage:str];
                return;
            }
            if (([selPeron.iCredtype isEqualToString:@"1"]||[selPeron.iCredtype isEqualToString:@"身份证"])&&(![BeRegularExpressionUtil validateIdentityCard:selPeron.iCredNumber])) {
                NSString *str = [NSString stringWithFormat:@"\"%@\"的身份证号格式不正确", selPeron.iName];
                [CommonMethod showMessage:str];
                return;
            }
        }
        if([GlobalData getSharedInstance].userModel.isYiyang)
        {
            [self checkYiyangTrainOrder];
        }
        else
        {
            [self showAlert];
        }
    }
    else
    {
        [[ServerFactory getServerInstance:@"BeTrainServer"]payTrainOrderWith:self.bookModel.orderNo andSuccess:^(NSDictionary *callback)
         {
            // 20024
             if([[callback stringValueForKey:@"code" defaultValue:@""]isEqualToString:@"20024"])
             {
                 [MBProgressHUD showMessage:@"支付成功"];
                 [self.navigationController popToRootViewControllerAnimated:YES];
             }
         }andFailure:^(NSError *error)
         {
             if(error.userInfo)
             {
                 if([[error.userInfo stringValueForKey:@"code" defaultValue:@""]isEqualToString:@"20023"])
                 {
                     [CommonMethod showMessage:@"保理金额小于当前支付金额"];
                 }
                 else if([[error.userInfo stringValueForKey:@"code" defaultValue:@""]isEqualToString:@"10004"])
                 {
                     [CommonMethod showMessage:@"当前用户没有开通权限"];
                 }
                 else
                 {
                     [self requestFlase:error];
                 }
             }
         }];
    }
}
#pragma mark - 显示费用明细
- (void)priceDetailBtnClick
{
    BePriceListController *prVc = [[BePriceListController alloc] init];
    prVc.tableView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    prVc.tableView.backgroundColor = [UIColor blackColor];
    prVc.tableView.alpha = 0.85;
    

    NSMutableArray *arrayM = [NSMutableArray array];
    BePriceListModel *priM00 = [[BePriceListModel alloc] init];
    
    priM00.RoomDate = @"票面价";
    if([self.bookModel.selectPrice floatValue]==[self.bookModel.selectPrice intValue])
    {
        priM00.SalePrice = [NSString stringWithFormat:@"%dx%zd", [self.bookModel.selectPrice intValue], [self.bookModel.passengerArray count]];
        [arrayM addObject:priM00];
    }
    else
    {
        priM00.SalePrice = [NSString stringWithFormat:@"%.1fx%zd", [self.bookModel.selectPrice floatValue], [self.bookModel.passengerArray count]];
        [arrayM addObject:priM00];
    }
    
    BePriceListModel *priM11 = [[BePriceListModel alloc] init];
    priM11.RoomDate = @"服务费";
    priM11.SalePrice = [NSString stringWithFormat:@"%0.2fx%zd",[self.bookModel.servicemoney doubleValue], [self.bookModel.passengerArray count]];
    [arrayM addObject:priM11];
    
    prVc.listArray = arrayM;
    prVc.roomNum = (int)[self.bookModel.passengerArray count];
    double Insure = [self.bookModel.selectPrice doubleValue] + [self.bookModel.servicemoney doubleValue];
    double priceDouble = Insure * [self.bookModel.passengerArray count];
    int priceInt = (int)priceDouble;
    if (priceDouble == priceInt) {
        prVc.totleMoneyStr = [NSString stringWithFormat:@"%d", priceInt];
    } else {
        prVc.totleMoneyStr = [NSString stringWithFormat:@"%.2f", priceDouble];
    }
    prVc.titleStr = @"车票费";
    [prVc.tableView reloadData];
    
    [[UIApplication sharedApplication].keyWindow addSubview:prVc.tableView];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePriceDetailAction:)];
    [prVc.tableView addGestureRecognizer:tapGes];
}

- (void)hidePriceDetailAction:(UIGestureRecognizer *)gesture
{
    UITableView *table = (UITableView *)[gesture view];
    [table removeFromSuperview];
}
- (void)addPayTimer
{
    [myTimer invalidate];
    myTimer = [NSTimer  timerWithTimeInterval:1.0 target:self selector:@selector(payTimerAction)userInfo:nil repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
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
    NSString *string = [NSString stringWithFormat:@"为确保出票,请在%@:%@内完成支付,逾期将自动取消订单。以免车票售完或价格变化,给您的出行带来不便。", minuTime, secondTime];
    NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:string];
    [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange(8, 5)];
    [attrib addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:19] range:NSMakeRange(8, 5)];
    tableHeaderLabel.attributedText = attrib;
    [self.tableView reloadData];
}
- (void)dealloc
{
    [myTimer invalidate];
    myTimer = nil;
}
@end
