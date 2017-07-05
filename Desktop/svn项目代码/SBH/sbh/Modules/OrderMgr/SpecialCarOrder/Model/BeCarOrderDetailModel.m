//
//  BeCarOrderDetailModel.m
//  sbh
//
//  Created by RobinLiu on 15/7/15.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeCarOrderDetailModel.h"

@implementation BeCarOrderDetailModel
- (id)init
{
    if(self = [super init])
    {
        _orderState = @"";
        _orderDate = @"";
        _orderNo = @"";
        _serviceType = @"";
        _orderCost = @"";
        _sumDetail = @"";
        
        _driverName = @"";
        _driverPhone = @"";
        _driverCarNo = @"";
        
        _passengers = @"";
        _passengerPhone = @"";
        _expenseCenter = @"";
        _startLocation = @"";
        _destination = @"";
        _reason = @"";
        _orderId = @"";
        _isDriverInfoShow = NO;
        _isSumShow = NO;
    }
    return self;
}
- (void)setDataWith:(NSDictionary *)dict
{
    NSDictionary *OrderInfo = [dict objectForKey:@"OrderInfo"];
    NSDictionary *OrderActualRunInfo = [dict objectForKey:@"OrderActualRunInfo"];
   // NSDictionary *Order_ReserveInfo = [dict objectForKey:@"Order_ReserveInfo"];
    _AccountId = [OrderInfo stringValueForKey:@"AccountId" defaultValue:@""];
    _EstimatedCost = [OrderInfo stringValueForKey:@"EstimatedCost" defaultValue:@""];
    _orderDate = [OrderInfo stringValueForKey:@"RidingDate" defaultValue:@""];
    _createOrderDate = [OrderInfo stringValueForKey:@"OrderCreateDate" defaultValue:@""];
    NSString *ReserveDate = [OrderInfo stringValueForKey:@"ReserveDate" defaultValue:@""];
    [self setTypeWithString:ReserveDate];
    
    [self getOrderTypeAndOrderStateWith:[OrderInfo objectForKey:@"OrderStatus"]];
    _orderNo = [OrderInfo stringValueForKey:@"OrderNo" defaultValue:@""];
    _orderCost = [OrderInfo stringValueForKey:@"OrderCost" defaultValue:@""];
    _sumDetail = [OrderActualRunInfo stringValueForKey:@"CostDetail" defaultValue:@""];
        
    NSDictionary *OrderDriverInfo = [dict objectForKey:@"OrderDriverInfo"];
    [self setCarLevel:[OrderDriverInfo stringValueForKey:@"CarLevel" defaultValue:@"2"]];//车型默认舒适
    _carName = [OrderDriverInfo stringValueForKey:@"CarName" defaultValue:@""];
    _driverName = [OrderDriverInfo stringValueForKey:@"DriverName" defaultValue:@""];
    _driverPhone = [OrderDriverInfo stringValueForKey:@"DriverMobile" defaultValue:@""];
    _driverCarNo = [OrderDriverInfo stringValueForKey:@"LicenseNumber" defaultValue:@""];
        
    NSDictionary *OrderPassengerInfo = [[dict objectForKey:@"OrderPassengerInfo"] firstObject];

    _passengers = [OrderPassengerInfo stringValueForKey:@"PassengerName" defaultValue:@""];
    _passengerPhone = [OrderPassengerInfo stringValueForKey:@"PassengerMobile" defaultValue:@""];
    _expenseCenter = [OrderInfo stringValueForKey:@"CostCenter" defaultValue:@""];
    _startLocation = [OrderActualRunInfo stringValueForKey:@"StartAddress" defaultValue:@""];
    _orderId = [OrderInfo stringValueForKey:@"ThirdpartyOrderNo" defaultValue:@""];
    _destination = [OrderActualRunInfo stringValueForKey:@"EndAddress" defaultValue:@""];
    _reason = [OrderInfo stringValueForKey:@"RidingReasons" defaultValue:@""];
    if([OrderInfo intValueForKey:@"ServiceProvider" defaultValue:0] == 7 &&[OrderInfo intValueForKey:@"OrderType" defaultValue:0] == 2)
    {
        self.orderSourceType = BeCarOrderSourceTypePickup;
    }
    else if([OrderInfo intValueForKey:@"ServiceProvider" defaultValue:0] == 7 &&[OrderInfo intValueForKey:@"OrderType" defaultValue:0] == 3)
    {
        self.orderSourceType = BeCarOrderSourceTypeSeeOff;
    }
    else
    {
        self.orderSourceType = BeCarOrderSourceTypeCar;
    }
}
- (void)getOrderTypeAndOrderStateWith:(NSString *)string
{
    int status = [string intValue];
    if (status == 500)
    {
        _orderState = @"已完成";
        _isDriverInfoShow = YES;
        _isSumShow = YES;

    }
    else if (status == 200)
    {
        _orderState = @"待应答";
        _isDriverInfoShow = NO;
        _isSumShow = NO;

    }
    else if (status == 210)
    {
        _orderState = @"待服务";
        _isDriverInfoShow = YES;
        _isSumShow = NO;
    }
    else if (status == 220)
    {
        _orderState = @"服务中";
        _isDriverInfoShow = YES;
        _isSumShow = NO;
    }
    else if (status == 230)
    {
        _orderState = @"服务结束";
        _isDriverInfoShow = YES;
        _isSumShow = YES;


    }else if (status == 300)
    {
        _orderState = @"待确认";
        _isDriverInfoShow = YES;
        _isSumShow = YES;

    }
    else if (status == 310)
    {
        _orderState = @"待个人支付";
        _isDriverInfoShow = YES;
        _isSumShow = YES;

    }
    else if (status == 400 || status == 600 || status == 610)
    {
        _orderState = @"已取消";
        _isDriverInfoShow = NO;
        _isSumShow = NO;


    }
    else
    {
        _orderState = @"待确认";
        _isDriverInfoShow = YES;
        _isSumShow = YES;

    }
}
- (void)setCarLevel:(NSString *)carLevel
{
    if([carLevel intValue]==1)
    {
        _carLevel = @"经济车型";
    }
    else if([carLevel intValue]==2)
    {
        _carLevel = @"舒适车型";
    }else if([carLevel intValue]==3)
    {
        _carLevel = @"豪华车型";
    }else if([carLevel intValue]==4)
    {
        _carLevel = @"奢华车型";
    }else if([carLevel intValue]==5)
    {
        _carLevel = @"商务七座";
    }
    else
    {
        _carLevel = @"经济车型";
    }
}
- (void)setTypeWithString:(NSString *)string
{
    NSDate *dateA = [CommonMethod dateFromString:string WithParseStr:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *dateB = [CommonMethod dateFromString:_orderDate WithParseStr:@"yyyy/MM/dd HH:mm:ss"];
 /*   NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *dateBStr= [dateFormatter stringFromDate:[NSDate date]];
    NSDate *dateB = [CommonMethod dateFromString:dateBStr WithParseStr:@"yyyy/MM/dd HH:mm:ss"];*/

    if(string.length < 1)
    {
        dateA = dateB;
    }
    NSTimeInterval time=[dateA timeIntervalSinceDate:dateB];
    int minute = (int)time/60;
    if (minute <= 30) {
        _serviceType = @"立即叫车";
    }
    else
    {
        _serviceType = @"预约叫车";
    }
}
@end
