//
//  BeHotelOrderModel.m
//  SideBenefit
//
//  Created by SBH on 15-3-10.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelOrderModel.h"
#import "NSDictionary+Additions.h"
#import "CommonMethod.h"
#import "ColorUtility.h"


@implementation BeHotelOrderModel
//新单 200 0
- (void)setOrderListItemWithDict:(NSDictionary *)dict
{
    int OrderStatusNum = [[dict stringValueForKey:@"OrderStatus" defaultValue:@""] intValue];
    _PayStatusNum = [[dict stringValueForKey:@"PayStatus" defaultValue:@""] intValue];
    _ExamineStatus = [[dict stringValueForKey:@"ExamineStatus" defaultValue:@""] intValue];
    int payMethod = [[dict stringValueForKey:@"PayMethod" defaultValue:@""] intValue];

    if(OrderStatusNum == 110){
        _OrderStatus = kStatusYiquxiao;
        _statusColor = kColorYiquxiao;
    }else if(OrderStatusNum == 102){
        _OrderStatus = kStatusYiqueren;
        _statusColor = kColorYiqueren;
    }else if(OrderStatusNum == 109){
        _OrderStatus = kStatusYituiding;
        _statusColor = kColorYituiding;
    }else if(OrderStatusNum == 101){
        _OrderStatus = kStatusDaiqueren;
        _statusColor = kColorDaiqueren;
    }
    else if(OrderStatusNum == 200)
    {
        _OrderStatus = kStatusApply;
        _statusColor = kColorDaizhifu;
        if(_PayStatusNum == 0 && _ExamineStatus == 0)
        {
            _OrderStatus = kStatusToAudit;
            _statusColor = kColorDaizhifu;
        }
    }
    else if(OrderStatusNum == 112 ||OrderStatusNum == 111){
        _OrderStatus = kStatusChulizhong;
        _statusColor = kColorChulizhong;
    }
    else if(OrderStatusNum == 100 && _PayStatusNum == 0&& payMethod == 3){
        _OrderStatus = kStatusDaizhifu;
        _statusColor = kColorDaizhifu;
    }
    else{
        _OrderStatus = kStatusDaiqueren;
        _statusColor = kColorDaiqueren;
    }
    if(_ExamineStatus == 0)
    {
        _OrderStatus = kStatusToAudit;
        _statusColor = kColorDaiqueren;
    }
    if(_ExamineStatus == 1)
    {
        _OrderStatus = kStatusHaveAudit;
        _statusColor = kColorDaiqueren;
    }
    self.OrderNo = [dict stringValueForKey:@"OrderNo" defaultValue:@""];
    self.CheckOutDate = [dict stringValueForKey:@"CheckOutDate" defaultValue:@""];
    self.RoomCount = [dict stringValueForKey:@"RoomCount" defaultValue:@""];
    self.CheckInDate = [dict stringValueForKey:@"CheckInDate" defaultValue:@""];
    self.RoomName = [dict stringValueForKey:@"RoomName" defaultValue:@""];
    self.Address = [dict stringValueForKey:@"Address" defaultValue:@""];
    self.PolicyName = [dict stringValueForKey:@"PolicyName" defaultValue:@""];
    self.HotelName = [dict stringValueForKey:@"HotelName" defaultValue:@""];
    self.OrderSumFee = [dict stringValueForKey:@"OrderSumFee" defaultValue:@""];
    self.HotelId = [dict stringValueForKey:@"HotelId" defaultValue:@""];
    self.CreateTime = [dict stringValueForKey:@"CreateTime" defaultValue:@""];
    self.PayStatus = [dict stringValueForKey:@"PayStatus" defaultValue:@""];
    self.cancelPolicy = [dict stringValueForKey:@"PolicyRemark"];
}

- (void)setCheckInDate:(NSString *)CheckInDate
{
    NSArray *array = [CheckInDate componentsSeparatedByString:@"T"];
    _CheckInDate = array.firstObject;
}

- (void)setCheckOutDate:(NSString *)CheckOutDate
{
    NSArray *array = [CheckOutDate componentsSeparatedByString:@"T"];
    _CheckOutDate = array.firstObject;
}

-(void)setCreateTime:(NSString *)CreateTime
{
    NSArray *array = [CreateTime componentsSeparatedByString:@"T"];
    NSString *str = [array.lastObject substringToIndex:5];
    _CreateTime = [NSString stringWithFormat:@"%@ %@",array.firstObject,str];
}

- (void)setStarRate:(NSString *)starRate
{
    if([starRate intValue]==5)
    {
        _starRate = @"五星";
        _starDescription = [NSString stringWithFormat:@"（%@）",_starRate];
    }
    else if([starRate intValue]==4)
    {
        _starRate = @"四星";
        _starDescription = [NSString stringWithFormat:@"（%@）",_starRate];
    }
    else if ([starRate intValue]==3)
    {
        _starRate = @"三星";
        _starDescription = [NSString stringWithFormat:@"（%@）",_starRate];
    }
    else if ([starRate intValue]==2||[starRate intValue]==1)
    {
        _starRate = @"二星及以下";
        _starDescription = [NSString stringWithFormat:@"（%@）",_starRate];
    }
    else
    {
        _starRate = @"";
        _starDescription = @"";
    }
}
- (void)setDetailDataWithDict:(NSDictionary *)dict
{
    self.starRate = [[[dict arrayValueForKey:@"Hotel"] firstObject] stringValueForKey:@"StarRate"];
    
    self.contanctArray = [dict arrayValueForKey:@"Contacts"];
    self.personArray = [dict arrayValueForKey:@"Persons"];
    NSDictionary *orderDict = [dict dictValueForKey:@"Order"];
    [self setOrderListItemWithDict:orderDict];
    NSDate * startDate = [CommonMethod dateFromString:self.CheckInDate WithParseStr:@"yyyy-MM-dd"];
    NSDate * leaveDate = [CommonMethod dateFromString:self.CheckOutDate WithParseStr:@"yyyy-MM-dd"];
    int dayInt = [leaveDate timeIntervalSinceDate:startDate]/86400;
    self.exDays = dayInt;
    self.exRoomType = [NSString stringWithFormat:@"%@",self.RoomName];
}
@end
