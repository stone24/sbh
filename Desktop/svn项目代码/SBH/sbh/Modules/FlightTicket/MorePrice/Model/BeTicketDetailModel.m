//
//  BeTicketDetailModel.m
//  sbh
//
//  Created by RobinLiu on 15/10/22.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BeTicketDetailModel.h"
#import "NSDictionary+Additions.h"

@implementation BeTicketDetailModel
- (id)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        _infoDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
        _ClassCodeType = [dict stringValueForKey:@"ClassCodeType" defaultValue:@""];
        _Code = [dict stringValueForKey:@"Code" defaultValue:@""];
        _EI = [dict stringValueForKey:@"EI" defaultValue:@""];
        _Endorsement = [dict stringValueForKey:@"Endorsement" defaultValue:@""];
        _Rebate = [dict stringValueForKey:@"Rebate" defaultValue:@""];
        _Refund = [dict stringValueForKey:@"Refund" defaultValue:@""];
        NSArray *seatArray = [[dict stringValueForKey:@"Seat" defaultValue:@""] componentsSeparatedByString:@"剩"];
        if(seatArray.count > 1)
        {
            NSArray *secondArray = [[seatArray lastObject] componentsSeparatedByString:@"张"];
            _Seat = [secondArray firstObject];
        }
        else
        {
            _Seat = @"99";
        }
        [_infoDict setValue:[_Seat mutableCopy] forKey:@"Seat"];
        _guid = [dict stringValueForKey:@"guid" defaultValue:@""];
        NSArray *priceArray = [[dict stringValueForKey:@"price" defaultValue:@""] componentsSeparatedByString:@"|"];
        _price = [priceArray firstObject];
        if(priceArray.count > 1)
        {
            _priceType = [[priceArray objectAtIndex:1] intValue];
        }
        else if([[dict stringValueForKey:@"Type" defaultValue:@"0"] intValue] > 0)
        {
            _priceType = [[dict stringValueForKey:@"Type" defaultValue:@"0"] intValue];
        }
        else
        {
            _priceType = TicketTravelPriceType;
        }
        _ForcedInsurance = [dict stringValueForKey:@"ForcedInsurance" defaultValue:@""];
    }
    return self;
}
@end
