//
//  BeCarOrderListModel.m
//  sbh
//
//  Created by RobinLiu on 15/7/13.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeCarOrderListModel.h"
#import "NSDictionary+Additions.h"
#import "ColorUtility.h"

@implementation BeCarOrderListModel
- (id)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        _EndAddress = [dict stringValueForKey:@"EndAddress" defaultValue:@""];
        _OrderNo = [dict stringValueForKey:@"OrderNo" defaultValue:@""];
        _OrderStatus = [dict stringValueForKey:@"OrderStatus" defaultValue:@""];
        _RidingDate = [dict stringValueForKey:@"RidingDate" defaultValue:@""];
        _StartAddress = [dict stringValueForKey:@"StartAddress" defaultValue:@""];
        _rid = [dict stringValueForKey:@"rid" defaultValue:@""];
        _OrderCreateDate = [dict stringValueForKey:@"OrderCreateDate" defaultValue:@""];
    }
    return self;
}
+ (UIColor *)colorWithString:(NSString *)string
{
    if([string isEqualToString:@"已完成"])
    {
        return [UIColor orangeColor];
    }
    else if([string isEqualToString:@"已取消"])
    {
       return [ColorUtility colorWithRed:230 green:91 blue:95];
    }
    else if([string isEqualToString:@"待应答"]||[string isEqualToString:@"待答应"])
    {
        return [ColorUtility colorWithRed:79 green:164 blue:221];
    }
    else if([string isEqualToString:@"待服务"])
    {
        return [ColorUtility colorWithRed:230 green:91 blue:95];
    }
    else if([string isEqualToString:@"待个人支付"])
    {
         return [ColorUtility colorWithRed:79 green:164 blue:221];
    }
    else if([string isEqualToString:@"待确认"])
    {
         return [UIColor lightGrayColor];
    }
    else if([string isEqualToString:@"服务结束"])
    {
        return [UIColor grayColor];
            
    }
    else if([string isEqualToString:@"服务中"])
    {
        return [ColorUtility colorWithRed:82 green:193 blue:80];
    }
    return [UIColor lightGrayColor];
}
+ (UIColor *)colorWithType:(BeCarOrderType)type
{
    /* = 0,//已完成
     = 1,//已取消
     = 2,//待应答
     = 3,//待服务
     = 4,//待个人支付
     = 5,//待确认
     = 6,//服务结束
     = 7 //服务中*/
    switch (type) {
        case BeCarOrderTypeFinished:
        {
            return [UIColor yellowColor];
        }
            break;
        case BeCarOrderTypeCanceled:
        {
            return [ColorUtility colorWithRed:230 green:91 blue:95];
        }
            break;
        case BeCarOrderTypeWaitReply:
        {
            return [ColorUtility colorWithRed:79 green:164 blue:221];
        }
            break;
        case BeCarOrderTypeWaitService:
        {
            return [ColorUtility colorWithRed:230 green:91 blue:95];

        }
            break;
        case BeCarOrderTypeWaitIndividualPay:
        {
            return [ColorUtility colorWithRed:79 green:164 blue:221];

        }
            break;
        case BeCarOrderTypeWaitConfirm:
        {
            return [UIColor lightGrayColor];

        }
            break;
        case BeCarOrderTypeServiceFinished:
        {
            return [UIColor grayColor];

        }
            break;
        case BeCarOrderTypeInService:
        {
            return [ColorUtility colorWithRed:82 green:193 blue:80];
        }
            break;
        default:
            break;
    }
    return [UIColor lightGrayColor];
}
@end
