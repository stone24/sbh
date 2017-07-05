//
//  BeHotelOrderDetailController.m
//  SideBenefit
//
//  Created by SBH on 15-3-10.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelOrderDetailController.h"
#import "BeHotelOrderModel.h"
#import "ServerFactory.h"
#import "BeHotelOrderServer.h"
#import "NSDictionary+Additions.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "BeHotelDetailController.h"
#import "BeHotelOrderPayViewController.h"
#import "BeHotelCityManager.h"
#import "NSDate+WQCalendarLogic.h"
#import "SBHAuditCoverView.h"
#import "ServerFactory.h"
#import "BeHotelServer.h"
#define kHotelOrderDetailFont [UIFont systemFontOfSize:14]
@interface BeHotelOrderDetailController ()
{
    UIView *footerView;
    NSTimer *timer;
    NSMutableArray *section1Array;
    NSDictionary *detailDict;
    NSString *cancelReason;
}
@property (nonatomic, strong) SBHAuditCoverView *cancelReasonView;
@property (nonatomic,strong)UIView *dimView;


@end

@implementation BeHotelOrderDetailController
@synthesize hotModel;
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewValueChanged) name:UITextViewTextDidChangeNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    cancelReason = [[NSString alloc]init];
    [self addCancelReasonView];
    self.tableView.hidden = YES;
    detailDict = [[NSDictionary alloc]init];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    section1Array = [[NSMutableArray alloc]init];
    [self customFooterView];
    [self setupRequestDetail];
}
#pragma mark - 获取订单详情
- (void)setupRequestDetail
{
    [MBProgressHUD showMessage:nil];
    [[ServerFactory getServerInstance:@"BeHotelOrderServer"]doGetHotelOrderDetailWith:self.hotModel andSuccessCallback:^(NSDictionary *callback)
    {
        NSLog(@"酒店订单详情= %@",callback);
        [MBProgressHUD hideHUD];
        detailDict = callback;
        self.tableView.hidden = NO;
        [self.hotModel setDetailDataWithDict:[[[detailDict objectForKey:@"orderinfo"]objectForKey:@"ho"] firstObject]];
        [self setupData];
    }andFailureCallback:^(NSString *failure)
    {
        [MBProgressHUD hideHUD];
        [self handleResuetCode:failure];
        self.tableView.hidden = YES;
        [timer invalidate];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(doBack) userInfo:nil repeats:YES];
    }];
}
- (void)setupData
{
    [self.dataArray addObject:[NSString stringWithFormat:@"订单号：%@",self.hotModel.OrderNo]];
    [self.dataArray addObject:[NSString stringWithFormat:@"订单金额：￥%@",self.hotModel.OrderSumFee]];
    [self.dataArray addObject:[NSString stringWithFormat:@"订单状态：%@",self.hotModel.OrderStatus]];
    [self.dataArray addObject:[NSString stringWithFormat:@"订单日期：%@",self.hotModel.CreateTime]];
    
    [section1Array addObject:[NSString stringWithFormat:@"酒店名称：%@",self.hotModel.HotelName]];
    [section1Array addObject:[NSString stringWithFormat:@"房型：%@",self.hotModel.exRoomType]];
    [section1Array addObject:[NSString stringWithFormat:@"房间数：%@间",self.hotModel.RoomCount]];
    [section1Array addObject:[NSString stringWithFormat:@"订单日期：%@至%@ 共%d晚", self.hotModel.CheckInDate, self.hotModel.CheckOutDate, self.hotModel.exDays]];
    
    if(self.hotModel.personArray!=nil || self.hotModel.personArray.count > 0)
    {
        if(self.hotModel.personArray.count == 1)
        {
            [section1Array addObject:[NSString stringWithFormat:@"入住人：%@",[[self.hotModel.personArray firstObject] objectForKey:@"Name"]]];
        }
        else
        {
            int i = 0;
            for (NSDictionary *dict in self.hotModel.personArray) {
                [section1Array addObject:[NSString stringWithFormat:@"入住人%d：%@",i + 1,[dict objectForKey:@"Name"]]];
                i++;
            }
        }
    }
    if(self.hotModel.contanctArray!=nil || self.hotModel.contanctArray.count > 0)
    {
        [section1Array addObject:[NSString stringWithFormat:@"联系人：%@", [[self.hotModel.contanctArray firstObject] objectForKey:@"Name"]]];
        [section1Array addObject:[NSString stringWithFormat:@"联系人手机号：%@",[[self.hotModel.contanctArray firstObject] objectForKey:@"Mobile"]]];
    }
    [section1Array addObject:[NSString stringWithFormat:@"酒店地址：%@",self.hotModel.Address]];
    [self.tableView reloadData];
}
- (void)doBack
{
    [timer invalidate];
    timer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return self.dataArray.count;
    }
    return section1Array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return [self getHeightWith:[self.dataArray objectAtIndex:indexPath.row]] + 10;
    }
    if(indexPath.section == 1)
    {
        return [self getHeightWith:[section1Array objectAtIndex:indexPath.row]] + 10;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.font = kHotelOrderDetailFont;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    if (indexPath.section == 0)
    {
        cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    }
    if(indexPath.section == 1)
    {
        cell.textLabel.text = [section1Array objectAtIndex:indexPath.row];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
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
#pragma mark - 取消订单
- (void)cancelAction
{
    self.cancelReasonView.contentTextView.text = @"取消原因";
    self.dimView.hidden = NO;
    self.cancelReasonView.hidden = NO;

}
#pragma mark - 支付
- (void)payAction
{
    BeHotelOrderWriteModel *writerModel = [[BeHotelOrderWriteModel alloc]init];
    [writerModel setupDataWithHotelOrderData:detailDict];
    [[ServerFactory getServerInstance:@"BeHotelServer"]getHotelAuditWith:writerModel byCallback:^(id callback)
     {
         NSLog(@"审批信息 = %@",callback);
         [writerModel getHotelAuditWith:callback];
         BeHotelOrderPayViewController *payVC = [[BeHotelOrderPayViewController alloc]init];
         payVC.sourceType = HotelOrderPaySourceTypeOrderList;
         payVC.writeModel = writerModel;
         [self.navigationController pushViewController:payVC animated:YES];
     }failureCallback:^(NSError *error)
     {
         NSLog(@"审批信息错误 = %@",error);
         [self requestFlase:error];
     }];
   /* if([writerModel.PayType isEqualToString:@"1"]||[writerModel.PayType isEqualToString:@"3"])
    {
        //到付
        
    }
    else
    {
        BeHotelOrderPayViewController *payVC = [[BeHotelOrderPayViewController alloc]init];
        payVC.sourceType = HotelOrderPaySourceTypeOrderList;
        writerModel.auditType = HotelAuditTypeNone;
        payVC.writeModel = writerModel;
        [self.navigationController pushViewController:payVC animated:YES];
    }*/
}
#pragma mark - 再次预订
- (void)bookAction
{
    BeHotelListItem *listItem = [[BeHotelListItem alloc]init];
    listItem.hotelId = [NSString stringWithFormat:@"%@",[[[[[detailDict objectForKey:@"orderinfo"]objectForKey:@"ho"] firstObject] objectForKey:@"Order"]objectForKey:@"HotelId"]];
    NSDate *startDate = [[NSDate date]dateByAddingTimeInterval:3600*24*1];
    listItem.CheckInDate = [startDate stringFromDate:startDate];
    NSDate *leaveDate = [startDate dateByAddingTimeInterval:3600*24*1];
    listItem.CheckOutDate = [leaveDate stringFromDate:leaveDate];
    NSString *cityName = [[[[[detailDict objectForKey:@"orderinfo"]objectForKey:@"ho"] firstObject] objectForKey:@"Order"]objectForKey:@"CityName"];

    [[BeHotelCityManager sharedInstance]getCityDataWithCityName:cityName andCallback:^(CityData *cityData)
     {
         listItem.cityId = cityData.cityId;
         listItem.cityName = cityName;
         BeHotelDetailController *detailVC = [[BeHotelDetailController alloc]init];
         detailVC.item = listItem;
         detailVC.sourceType = HotelDetailSourceTypeOrderList;
         [self.navigationController pushViewController:detailVC animated:YES];
     }];
}
- (CGFloat)getHotelNameHeaderViewHeight
{
    NSString *labelText = [NSString stringWithFormat:@"%@%@",self.hotModel.HotelName,self.hotModel.starDescription];
    UIFont *addressFont = [UIFont systemFontOfSize:14];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat width = CGRectGetWidth(app.keyWindow.bounds)-30;
    CGRect addressBounds = [labelText boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:addressFont} context:nil];
    return addressBounds.size.height+30;
}
- (void)customFooterView
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 70)];
    footerView.backgroundColor = [UIColor clearColor];
    UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.3)];
    sepLine.backgroundColor = [UIColor lightGrayColor];
    [footerView addSubview:sepLine];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(25, 20, kScreenWidth - 50, 32);
    button1.layer.cornerRadius = 3.0f;
    button1.layer.borderWidth = 1.0f;
    button1.titleLabel.font = [UIFont systemFontOfSize:14];
    [footerView addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(25, 20, kScreenWidth - 50, 32);
    button2.layer.cornerRadius = 3.0f;
    button2.layer.borderWidth = 1.0f;
    button2.titleLabel.font = [UIFont systemFontOfSize:14];
    [footerView addSubview:button2];
    
    if([self.hotModel.OrderStatus intValue] == 200)
    {
        if(self.hotModel.PayStatus == 0)
        {
            if(self.hotModel.ExamineStatus == 0)
            {
                //待审批
                button1.hidden = YES;
                [button2 setTitle:@"去审批" forState:UIControlStateNormal];
                [button2 setTitleColor:[ColorUtility colorFromHex:0xfe9b14] forState:UIControlStateNormal];
                button2.layer.borderColor = [[ColorUtility colorFromHex:0xfe9b14] CGColor];
                [button2 addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
            }
            else if(self.hotModel.ExamineStatus == 5)
            {
                [button1 setTitle:@"取消" forState:UIControlStateNormal];
                [button1 setTitleColor:[ColorUtility colorFromHex:0x31ccb7] forState:UIControlStateNormal];
                button1.layer.borderColor = [[ColorUtility colorFromHex:0x31ccb7] CGColor];
                [button1 addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
                
                [button2 setTitle:@"支付" forState:UIControlStateNormal];
                [button2 setTitleColor:[ColorUtility colorFromHex:0xfe9b14] forState:UIControlStateNormal];
                button2.layer.borderColor = [[ColorUtility colorFromHex:0xfe9b14] CGColor];
                [button2 addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                button1.hidden = YES;
                button2.hidden = YES;
            }
        }
        else
        {
            button1.hidden = YES;
            [button2 setTitle:@"取消" forState:UIControlStateNormal];
            [button2 setTitleColor:[ColorUtility colorFromHex:0x31ccb7] forState:UIControlStateNormal];
            button2.layer.borderColor = [[ColorUtility colorFromHex:0x31ccb7] CGColor];
            [button2 addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    else if([self.hotModel.OrderStatus isEqualToString:kStatusYiqueren])
    {
        //"已确认"
        button1.hidden = YES;
        [button2 setTitle:@"再次预订" forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button2.layer.borderColor = [[UIColor grayColor] CGColor];        [button2 addTarget:self action:@selector(bookAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([self.hotModel.OrderStatus isEqualToString:kStatusYituiding])
    {
        //已退订"
        button1.hidden = YES;
        [button2 setTitle:@"再次预订" forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button2.layer.borderColor = [[UIColor grayColor] CGColor];        [button2 addTarget:self action:@selector(bookAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([self.hotModel.OrderStatus isEqualToString:kStatusYiquxiao])
    {
        //已取消
        button1.hidden = YES;
        [button2 setTitle:@"再次预订" forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button2.layer.borderColor = [[UIColor grayColor] CGColor];
        [button2 addTarget:self action:@selector(bookAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([self.hotModel.OrderStatus isEqualToString:kStatusDaiqueren] || [self.hotModel.OrderStatus isEqualToString:kStatusApply]||[self.hotModel.OrderStatus isEqualToString:kStatusApply])
    {
        //待确认 申请单
        button1.hidden = YES;
        [button2 setTitle:@"取消" forState:UIControlStateNormal];
        [button2 setTitleColor:[ColorUtility colorFromHex:0x31ccb7] forState:UIControlStateNormal];
        button2.layer.borderColor = [[ColorUtility colorFromHex:0x31ccb7] CGColor];
        [button2 addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([self.hotModel.OrderStatus isEqualToString:kStatusChulizhong])
    {
        //处理中
        button1.hidden = YES;
        button2.hidden = YES;
    }
    else if([self.hotModel.OrderStatus isEqualToString:kStatusDaizhifu])
    {
        //待支付
        button1.x = 13;
        button1.width = (kScreenWidth - 26 - 23)/2.0;
        button2.x = kScreenWidth - 13 - 23 - button1.width;
        button2.width = button1.width;

        [button1 setTitle:@"取消" forState:UIControlStateNormal];
        [button1 setTitleColor:[ColorUtility colorFromHex:0x31ccb7] forState:UIControlStateNormal];
        button1.layer.borderColor = [[ColorUtility colorFromHex:0x31ccb7] CGColor];
        [button1 addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        
        [button2 setTitle:@"支付" forState:UIControlStateNormal];
        [button2 setTitleColor:[ColorUtility colorFromHex:0xfe9b14] forState:UIControlStateNormal];
        button2.layer.borderColor = [[ColorUtility colorFromHex:0xfe9b14] CGColor];
        [button2 addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([self.hotModel.OrderStatus isEqualToString:kStatusToAudit])
    {
        //待审批
        button1.hidden = YES;
        [button2 setTitle:@"去审批" forState:UIControlStateNormal];
        [button2 setTitleColor:[ColorUtility colorFromHex:0xfe9b14] forState:UIControlStateNormal];
        button2.layer.borderColor = [[ColorUtility colorFromHex:0xfe9b14] CGColor];
        [button2 addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([self.hotModel.OrderStatus isEqualToString:kStatusHaveAudit])
    {
        button1.hidden = YES;
        button2.hidden = YES;
    }
    self.tableView.tableFooterView = footerView;
}
- (CGFloat)getHeightWith:(NSString *)text
{
    CGRect sumRect = [text boundingRectWithSize:CGSizeMake(kScreenWidth - 28, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:kHotelOrderDetailFont} context:nil];
    return sumRect.size.height;
}
- (void)addCancelReasonView
{
    self.dimView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.dimView.backgroundColor = [UIColor whiteColor];
    self.dimView.alpha = 0.8;
    [[UIApplication sharedApplication].keyWindow addSubview:self.dimView];
    self.cancelReasonView = [[[NSBundle mainBundle] loadNibNamed:@"SBHAuditCoverView" owner:nil options:nil] firstObject];
    self.cancelReasonView.width = self.view.width - 20;
    self.cancelReasonView.height = 345;
    self.cancelReasonView.x = 10 ;
    self.cancelReasonView.y = (kScreenHeight - self.cancelReasonView.height) * 0.2;
    [self.cancelReasonView.closeCoverBtn addTarget:self action:@selector(auditCloseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelReasonView.doneBtn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:self.cancelReasonView];
    self.dimView.hidden = YES;
    self.cancelReasonView.hidden = YES;
}
- (void)textViewValueChanged
{
    cancelReason = self.cancelReasonView.contentTextView.text;
}
- (void)auditCloseButtonClick:(UIButton *)sender
{
    self.dimView.hidden = YES;
    self.cancelReasonView.hidden = YES;

}
- (void)doneBtnClick:(UIButton *)sender
{
    if (cancelReason.length == 0 || [cancelReason isEqualToString:@"取消原因"]) {
        [MBProgressHUD showError:@"请填写取消原因"];
    }
    else
    {
        self.dimView.hidden = YES;
        self.cancelReasonView.hidden = YES;

        [MBProgressHUD showMessage:nil];
        [[ServerFactory getServerInstance:@"BeHotelOrderServer"]doCancelOrderWith:self.hotModel andReason:cancelReason andSuccess:^(NSString *success)
         {
             [MBProgressHUD hideHUD];
             [MBProgressHUD showSuccess:@"订单取消成功"];
             self.cancelBlock();
             [timer invalidate];
             timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(doBack) userInfo:nil repeats:YES];
         }andFailure:^(NSString *failure)
         {
             [MBProgressHUD hideHUD];
             [MBProgressHUD showError:failure];
         }];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
