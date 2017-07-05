//
//  BeSpeFinishController.m
//  sbh
//
//  Created by SBH on 15/7/15.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeSpeFinishController.h"
#import "BeSpeCallCarPramaModel.h"
#import "SBHHttp.h"
#import "BeSpeCallCarResultModel.h"
#import "UIAlertView+Block.h"

#import "BeSpeCarLevelModel.h"
#import "BeSpecialCarHttp.h"
#import "BeSpeCarFinishTableViewCell.h"

typedef NS_ENUM(NSInteger,BeSpeFinishControllerType) {
    DriverNoResponse = 0,
    DriverHaveResponse = 1,
    NoSuchKindDriver = 2,
};

@interface BeSpeFinishController ()
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) int minInt;
@property (nonatomic, assign) int senInt;
@property (nonatomic, assign) int callNum;
@property (nonatomic, strong) BeSpeCallCarResultModel *reModel;
@property (nonatomic, assign) BeSpeFinishControllerType driverResponseType;
@end

@implementation BeSpeFinishController

- (BeSpeCallCarResultModel *)reModel
{
    if (_reModel == nil) {
        _reModel = [[BeSpeCallCarResultModel alloc] init];
    }
    return _reModel;
}

- (void)leftMenuClick
{
    if (self.reModel.DriverName.length != 0 || [self.reModel.order_status isEqualToString:@"已取消"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.sourceType == SpecialCarFinishControllerTypeCar?@"派车":(self.sourceType == SpecialCarFinishControllerTypePickUp?@"接机":@"送机");
    self.driverResponseType = DriverNoResponse;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消叫车" style:UIBarButtonItemStylePlain target:self action:@selector(cancelCallCarAction)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor clearColor];
    [self setupRequestDetail];
    [self addTimers];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sepStateNotificationAction:) name:kNotificationSpecial object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0?kBeSpeCarFinishTableViewCellTitleHeight:(indexPath.row == 1?kBeSpeCarFinishTableViewCellTimerHeight:kBeSpeCarFinishTableViewCellOrderContentHeight);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        BeSpeCarFinishTitleTableViewCell *cell = [BeSpeCarFinishTitleTableViewCell cellWithTableView:tableView];
        if(self.driverResponseType == DriverNoResponse)
        {
            [cell setTitle:@"正在派单" andContent:@"请稍后..."];
        }
        else if(self.driverResponseType == DriverHaveResponse)
        {
            [cell setTitle:@"司机已接单,服务中" andContent:@""];
        }
        else{
            [cell setTitle:@"没有此类车型的司机在线" andContent:@""];
        }
        return cell;
    }
    if(indexPath.row == 1 && self.driverResponseType == DriverHaveResponse)
    {
        BeSpeCarFinishDriverTableViewCell *cell = [BeSpeCarFinishDriverTableViewCell cellWithTableView:tableView];
        cell.driverModel = self.reModel;
        [cell.phoneButton addTarget:self action:@selector(phontBtnAction) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    if(indexPath.row == 1 && self.driverResponseType != DriverHaveResponse)
    {
        BeSpeCarFinishTimerTableViewCell *cell = [BeSpeCarFinishTimerTableViewCell cellWithTableView:tableView];
        [cell setCellWithMinute:self.minInt andSecond:self.senInt andCarNum:self.callNum];
        return cell;
    }
    if(indexPath.row == 2)
    {
        BeSpeCarFinishTableViewCell *cell = [BeSpeCarFinishTableViewCell cellWithTableView:tableView];
        cell.carModel = self.callModel;
        return cell;
    }
    return nil;
}

- (void)sepStateNotificationAction:(NSNotification *)not
{
    NSDictionary *dict = not.userInfo;
    self.reModel.order_status = [dict objectForKey:@"order_status"];
    if ([[dict objectForKey:@"order_status"] isEqualToString:@"已取消"]) {
        self.driverResponseType = NoSuchKindDriver;
    } else {
        self.driverResponseType = DriverHaveResponse;
        self.reModel.DriverName = [dict objectForKey:@"driver"];
        self.reModel.DriverMobile = [dict objectForKey:@"driver_phone"];
        self.navigationItem.rightBarButtonItem = nil;
    }
    [self.tableView reloadData];
    [_timer invalidate];
    _timer = nil;
}

- (void)addTimers
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)timerAction
{
    self.senInt += 1;
    if (self.senInt == 60) {
        self.senInt = 0;
        self.minInt += 1;
        if (self.minInt == 15) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"温馨提示"
                                  message:@"订单超时已取消，请重新叫车"
                                  delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"知道了", nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger index)
             {
                  [self.navigationController popViewControllerAnimated:YES];
             }];
        }
    }
    if(self.senInt % 6 == 0)
    {
        self.callNum = self.callNum + arc4random()%8;
        [self setupRequestDetail];
    }
    if(self.driverResponseType != DriverHaveResponse)
    {
        BeSpeCarFinishTimerTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [cell setCellWithMinute:self.minInt andSecond:self.senInt andCarNum:self.callNum];
    }
}

- (void)setupRequestDetail
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kServerHost,@"ZuChe/DriverInfo"];
    // 2.封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderid"] = self.callModel.orderNum;
    params[@"usertoken"] = [GlobalData getSharedInstance].token;
    SBHLog(@"%@", params);
    [[SBHHttp sharedInstance] postPath:urlStr withParameters:params showHud:NO success:^(id responseObj)
    {
        NSArray *array = [responseObj objectForKey:@"DriverInfo"];
        [BeSpeCallCarResultModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *
         {
             return @{@"ID" : @"id"};
         }];
        self.reModel = [BeSpeCallCarResultModel mj_objectWithKeyValues:array.firstObject];
        self.driverResponseType = DriverHaveResponse;
        self.navigationItem.rightBarButtonItem = nil;
        [self.tableView reloadData];
        [_timer invalidate];
        _timer = nil;
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 取消叫车
- (void)setupRequestCancelCall:(NSString *)forceParam
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kSpeRequestUrl,@"ZC11_orderCancel"];
    NSString *valueStr = [NSString stringWithFormat:@"order_id=%@&force=%@&orderno=%@&accountid=%@", self.callModel.order_id, forceParam, self.callModel.orderNum, [GlobalData getSharedInstance].userModel.AccountID];
    [BeSpecialCarHttp postPath:urlStr withParameters:valueStr success:^(id dict)
     {
         [MBProgressHUD hideHUD];
         NSString *msgStr = [dict stringValueForKey:@"status"];
         NSString *costStr = [dict stringValueForKey:@"cost"];
         if (costStr.length != 0) {
             UIAlertView *alert = [[UIAlertView alloc]
                                   initWithTitle:@"提示信息"
                                   message:@"取消叫车将扣10元，是否确定取消"
                                   delegate:self
                                   cancelButtonTitle:@"否"
                                   otherButtonTitles:@"是", nil];
             [alert showAlertViewWithCompleteBlock:^(NSInteger index)
              {
                  if(index == 1)
                  {
                      [self setupRequestCancelCall:@"true"];
                  }
              }];
         } else {
             if ([msgStr isEqualToString:@"true"]) {
                 [MBProgressHUD showSuccess:@"已取消叫车"];
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [self.navigationController popViewControllerAnimated:YES];
                 });
             } else {
                 [MBProgressHUD showError:@"取消叫车失败"];
             }
         }
     }failure:^(NSError *error){
         [MBProgressHUD hideHUD];
         NSLog(@"失败 = %@",error);
     }];
}

#pragma mark - 接送机取消
- (void)cancelJiesongji
{
    NSString *urlStr = [NSString stringWithFormat:@"%@ShouQi",@"http://192.168.10.27:8999/"];
    NSString *valueStr = [NSString stringWithFormat:@"orderNo=%@&orderId=%@&cancelType=39&channel=emax&method=cancelOrderBeforeAccepted",self.callModel.orderno,self.callModel.order_id];
    [MBProgressHUD showMessage:@""];
    [BeSpecialCarHttp postPath:urlStr withParameters:valueStr success:^(id dict)
     {
         [MBProgressHUD hideHUD];
         NSLog(@"接送机取消叫车 = %@",dict);
     }failure:^(NSError *error){
         [MBProgressHUD hideHUD];
         NSLog(@"失败 = %@",error);
     }];
}

- (void)cancelCallCarAction {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示信息"
                          message:@"确认取消叫车吗？"
                          delegate:self
                          cancelButtonTitle:@"继续等待"
                          otherButtonTitles:@"确认取消", nil];
    [alert showAlertViewWithCompleteBlock:^(NSInteger index)
     {
         if(index == 1)
         {
             if(self.sourceType == SpecialCarFinishControllerTypeCar)
             {
                 [self setupRequestCancelCall:@"false"];
             }
             else
             {
                 [self cancelJiesongji];
             }
         }
     }];
}
- (void)phontBtnAction
{
    NSString *str00 = [NSString stringWithFormat:@"是否拨打:%@",self.reModel.DriverMobile];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示信息"
                          message:str00
                          delegate:self
                          cancelButtonTitle:@"取消"
                          otherButtonTitles:@"拨打", nil];
    [alert showAlertViewWithCompleteBlock:^(NSInteger index)
     {
         if(index == 1)
         {
             [[UIApplication sharedApplication] openURL:
              [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.reModel.DriverMobile]]];
         }
     }];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
