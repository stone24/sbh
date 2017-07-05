//
//  BeDynamicModel.m
//  SideBenefit
//
//  Created by SBH on 15-3-6.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeDynamicModel.h"

@implementation BeDynamicModel
- (void)setFlightDeptimePlanDate:(NSString *)FlightDeptimePlanDate
{
    _FlightDeptimePlanDate = FlightDeptimePlanDate;
    if (FlightDeptimePlanDate.length != 0) {
     _FlightDeptimePlanDate = [FlightDeptimePlanDate substringWithRange:NSMakeRange(0, 10)];
     _FlightDeptimePlanTime = [FlightDeptimePlanDate substringWithRange:NSMakeRange(11, 5)];
    }
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    
//    [dateFormatter setDateFormat:@"hh:mm"];
//    
//    NSDate *date = [dateFormatter dateFromString:FlightDeptimePlanDate];
//    _FlightDeptimePlanDate = [dateFormatter stringFromDate:date];
}

- (void)setFlightArrtimePlanDate:(NSString *)FlightArrtimePlanDate
{
    _FlightArrtimePlanDate = FlightArrtimePlanDate;
    if (FlightArrtimePlanDate.length != 0) {
        _FlightArrtimePlanDate = [FlightArrtimePlanDate substringWithRange:NSMakeRange(0, 10)];
        _FlightArrtimePlanTime = [FlightArrtimePlanDate substringWithRange:NSMakeRange(11, 5)];
    }
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    
//    [dateFormatter setDateFormat:@"hh:mm"];
//    
//    NSDate *date = [dateFormatter dateFromString:FlightArrtimePlanDate];
//    _FlightArrtimePlanDate = [dateFormatter stringFromDate:date];
}

- (void)setFlightState:(NSString *)FlightState
{
    if ([FlightState isEqualToString:@"备降"]) {
        _FlightState = @"zhuangtai_beijiang";
    } else if ([FlightState isEqualToString:@"返航"]){
        _FlightState = @"zhuangtai_fanhang";
    }else if ([FlightState isEqualToString:@"到达"]){
        _FlightState = @"zhuangtai_daoda";
    }else if ([FlightState isEqualToString:@"起飞"]){
        _FlightState = @"zhuangtai_qifei";
    }else if ([FlightState isEqualToString:@"取消"]){
        _FlightState = @"zhuangtai_quxiao";
    }else if ([FlightState isEqualToString:@"延误"]){
        _FlightState = @"zhuangtai_yanwu";
    }else if ([FlightState isEqualToString:@"计划"]){
        _FlightState = @"zhuangtai_zhangchang";
    }
}
@end
