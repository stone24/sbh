//
//  SBHHomeController.m
//  sbh
//
//  Created by SBH on 14-12-1.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "SBHHomeController.h"
#import "BeWebViewController.h"
#import "BeHotelViewController.h"
#import "BeFlightTabBarController.h"


#import "CommonDefine.h"
#import "ColorUtility.h"
#import "ServerFactory.h"
#import "BeTrainTicketHomeViewController.h"
#import "NSDictionary+Additions.h"

#import "ServerConfigure.h"
#import "ColorConfigure.h"
#import "BeSpecialSubController.h"
#import "SBHHttp.h"
#import "BeAddressModel.h"
#import "BeCarOrderListModel.h"
#import "BeSpeFinishController.h"
#import "BeSpeCallCarPramaModel.h"
#import "BeMeetingViewController.h"
#import "UINavigationBar+GMAlpha.h"

#import "BeHomeFooterView.h"

@interface SBHHomeController ()<BeHomeFooterViewDelegate>
{
    BOOL isSupportTrain;
}
@property (nonatomic,strong)BeAddressModel *destinationModel;

@end

@implementation SBHHomeController

- (id)init
{
    if(self = [super init])
    {
        isSupportTrain = NO;
    }
    return self;
}
- (void)checkTrain
{
    //,"IsTrain":"1" 是否开通高铁 0未开通 1开通
    if([[GlobalData getSharedInstance].userModel.IsTrain intValue]==1)
    {
        isSupportTrain = YES;
    }
    else
    {
        isSupportTrain = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"A0003"];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self checkTrain];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.frame = CGRectMake(0, -64, kScreenWidth, kScreenHeight - 49 + 64);
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"individual_cell_background"]];
    imageView.frame = CGRectMake(0, 0, kScreenWidth, 200);
    UIView *blueView = [[UIView alloc]initWithFrame:CGRectMake(0, -1000, kScreenWidth, 1000)];
    UIColor *currentColor = [imageView colorOfPoint:CGPointMake(10, 10)];
    blueView.backgroundColor = currentColor;
    [imageView addSubview:blueView];
    self.tableView.tableHeaderView = imageView;
    BeHomeFooterView *footerView = [[BeHomeFooterView alloc]initWithFrame:[BeHomeFooterView footerViewFrameWithHeaderHeight:imageView.height]];
    footerView.delegate = self;
    self.tableView.tableFooterView = footerView;
    self.tableView.separatorColor = [UIColor clearColor];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (void)homeFooterViewClick:(int)tag
{
    switch (tag) {
        case 0:
            [self ticketReserveAction];
            break;
        case 1:
            [self trainAction];
            break;
        case 2:
            [self hotelBookAction];
            break;
        case 3:
            [self specialAction];
            break;
        case 4:
            [self ticketReserveAction];
            break;
        case 5:
            [self meetingAction];
            break;
        default:
            break;
    }
}
#pragma mark - 会议
- (void)meetingAction
{
    if(![GlobalData getSharedInstance].userModel.isLogin)
    {
        [BeLogUtility doLogOn];
        return;
    }
    else
    {
        if([[GlobalData getSharedInstance].userModel.ismeeting intValue]== 0)
        {
            [CommonMethod showMessage:@"您的企业暂未开通会议服务"];
            return;
        }
    }
    BeMeetingViewController *meetVC = [[BeMeetingViewController alloc]init];
    [self.navigationController pushViewController:meetVC animated:YES];
    return;
}
- (void)ticketReserveAction
{
    if([GlobalData getSharedInstance].userModel.isLogin &&[[GlobalData getSharedInstance].userModel.IsInternalAirTicket intValue]== 0 && ![[GlobalData getSharedInstance].userModel.EntName isEqualToString:kAccountCondition])
    {
        [CommonMethod showMessage:@"您的企业暂未开通机票服务"];
        return;
    }
    BeFlightTabBarController *flightVC = [[BeFlightTabBarController alloc]init];
    [self.navigationController pushViewController:flightVC animated:YES];
}

- (void)hotelBookAction
{
    if(![GlobalData getSharedInstance].userModel.isLogin)
    {
        [BeLogUtility doLogOn];
        return;
    }
    else
    {
        if([[GlobalData getSharedInstance].userModel.EntName isEqualToString:kAccountCondition])
        {
            [CommonMethod showMessage:@"暂未对个人用户开通酒店服务"];
            return;
        }
        else if([[GlobalData getSharedInstance].userModel.IsInternalHotel intValue]== 0)
        {
            [CommonMethod showMessage:@"您的企业暂未开通酒店服务"];
            return;
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HotelClearAllCondition" object:nil];
    BeHotelViewController *hotelVC = [[BeHotelViewController alloc]init];
    [self.navigationController pushViewController:hotelVC animated:YES];
}

- (void)trainAction
{
    if(![GlobalData getSharedInstance].userModel.isLogin)
    {
        [BeLogUtility doLogOn];
        return;
    }
    else
    {
        if([[GlobalData getSharedInstance].userModel.EntName isEqualToString:kAccountCondition])
        {
            [CommonMethod showMessage:@"暂未对个人用户开通火车票服务"];
            return;
        }
       else if([[GlobalData getSharedInstance].userModel.IsTrain intValue]== 0)
        {
            [CommonMethod showMessage:@"您的企业暂未开通火车票服务"];
            return;
        }
        NSArray *trainStatusArray = [[GlobalData getSharedInstance].userModel.TrainAPP componentsSeparatedByString:@"|"];
        // value="1|春运期间暂不支持火车票订票！"
        if (![[trainStatusArray firstObject] isEqualToString:@"1"]) {
            [CommonMethod showMessage:[trainStatusArray lastObject]];
            return;
        }
    }
    BeTrainTicketHomeViewController *trainVc = [[BeTrainTicketHomeViewController alloc] init];
    [self.navigationController pushViewController:trainVc animated:YES];
}

- (void)specialAction
{
    if([GlobalData getSharedInstance].userModel.isLogin != 0)
    {
        if([[GlobalData getSharedInstance].userModel.EntName isEqualToString:kAccountCondition])
        {
            [CommonMethod showMessage:@"暂未对个人用户开通用车服务"];
            return;
        }
        
        else if([GlobalData getSharedInstance].userModel.isCar == NO)
        {
            [CommonMethod showMessage:@"您的企业暂未开通用车服务"];
            return;
        }
        [self setupRequestOrderList];
        
    } else {
        [BeLogUtility doLogOn];
    }
}


// 判断是否有待应答的单子
- (void)setupRequestOrderList
{
        NSDictionary *dict = @{@"pageindex":@"1",@"pagesize":@"20",@"totalcount":@"0",@"pagecount":@"0",@"usertoken":[GlobalData getSharedInstance].token};
        [[SBHHttp sharedInstance]postPath:[NSString stringWithFormat:@"%@%@",kServerHost,kCarOrderListUrl] withParameters:dict showHud:YES success:^(NSDictionary *result)
         {
             NSString *dateTime = [result stringValueForKey:@"datetime" defaultValue:@""];
              NSDate *dareParameter = [CommonMethod dateFromString:dateTime WithParseStr:@"yyyy-MM-dd HH:mm:ss"];
              NSTimeInterval time=[dareParameter timeIntervalSinceDate:[NSDate date]];
              int minute = ((int)time)/(60);
              if(!(minute >= -10 && minute <= 10))
              {
                  [[NSUserDefaults standardUserDefaults] setObject:dateTime forKey:kServerDate];
              } else {
                  [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kServerDate];
              }
              /*NSDateComponents *todayDC= [[NSCalendar currentCalendar]components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:[NSDate date]];
              NSDateComponents *parameterDC = [[NSCalendar currentCalendar]components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:dareParameter];
              if(!(todayDC.year == parameterDC.year && todayDC.month == parameterDC.month && todayDC.day == parameterDC.day))
              {
               //
                [MBProgressHUD showError:@"日期不对！"];
                return;
              }*/
             NSArray *array = [result objectForKey:@"ol"];
             NSDictionary *dict = array.firstObject;
             SBHLog(@"%@", dict);
             BeCarOrderListModel *model = [[BeCarOrderListModel alloc]initWithDict:dict];
             
             if (/*[[GlobalData getSharedInstance].userModel.levelcode isEqualToString:@"3"] && array.count > 0 &&*/ [model.OrderStatus isEqualToString:@"待应答"])
             {
                 BeSpeCallCarPramaModel *callModel = [[BeSpeCallCarPramaModel alloc] init];
                 callModel.orderNum = model.OrderNo;
                 callModel.order_id = [dict objectForKey:@"ThirdpartyOrderNo"];
                 callModel.start_address = model.StartAddress;
                 callModel.end_address = model.EndAddress;
                 callModel.passenger_name = [dict objectForKey:@"PassengerName"];
                 callModel.passenger_phone = [dict objectForKey:@"PassengerMobile"];
                 callModel.ridingdate = [dict objectForKey:@"RidingDate"];
                 BeSpeFinishController *finiVc = [[BeSpeFinishController alloc] init];
                 if([dict intValueForKey:@"ServiceProvider" defaultValue:0] == 7 &&[dict intValueForKey:@"OrderType" defaultValue:0] == 2)
                 {
                     finiVc.sourceType = SpecialCarFinishControllerTypePickUp;
                 }
                 else if([dict intValueForKey:@"ServiceProvider" defaultValue:0] == 7 &&[dict intValueForKey:@"OrderType" defaultValue:0] == 3)
                 {
                     finiVc.sourceType = SpecialCarFinishControllerTypeSeeOff;
                 }
                 else
                 {
                     finiVc.sourceType = SpecialCarFinishControllerTypeCar;
                 }
                 finiVc.callModel = callModel;
                 [self.navigationController pushViewController:finiVc animated:YES];
                 return;
             }
             else
             {
                 BeSpecialSubController *speVc = [[BeSpecialSubController alloc] init];
                 speVc.destinationModel = self.destinationModel;
                 speVc.currentDate = dareParameter;
                 [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kAccessToken];
                 [self.navigationController pushViewController:speVc animated:YES];
             }
         }failure:^(NSError *error)
         {
             if([error.userInfo intValueForKey:@"code"] == 20015)
             {
                 BeSpecialSubController *speVc = [[BeSpecialSubController alloc] init];
                 speVc.destinationModel = self.destinationModel;
                 speVc.currentDate = [NSDate date];
                 [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kAccessToken];
                 [self.navigationController pushViewController:speVc animated:YES];
                 return;
             }
             [CommonMethod handleErrorWith:error];
         }];
}

@end
