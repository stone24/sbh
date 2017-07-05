//
//  BeTicketPriceRuleModel.m
//  sbh
//
//  Created by RobinLiu on 16/3/10.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeTicketPriceRuleModel.h"
#import "NSDictionary+Additions.h"

@implementation BeTicketPriceRuleModel
- (id)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        _isTPDisplay = NO;
        _selectedReason = @"";
        _policyType = [[dict stringValueForKey:@"IsForced" defaultValue:@"0"] intValue];
        _isnewaudit = [dict stringValueForKey:@"isnewaudit" defaultValue:@"0"];
        _reasonArray = [[NSMutableArray alloc]init];
        if([dict dictValueForKey:@"clzcyy"]!=nil)
        {
            if([[dict dictValueForKey:@"clzcyy"]isKindOfClass:[NSDictionary class]])
            {
                if([[dict dictValueForKey:@"clzcyy"] arrayValueForKey:@"Reasons"] !=nil)
                {
                    for(NSString *member in [[dict dictValueForKey:@"clzcyy"] arrayValueForKey:@"Reasons"] )
                    {
                        [_reasonArray addObject:member];
                    }
                }
            }
        }

        if([dict dictValueForKey:@"clzc"]!=nil)
        {
            NSDictionary *clzc = [dict dictValueForKey:@"clzc"];
            if([[clzc allKeys] count] > 0)
            {
                _isTPDisplay = YES;
            }
            if([clzc objectForKey:@"ClassInfo"]!=nil)
            {
                NSArray *ClassInfo = [clzc arrayValueForKey:@"ClassInfo"];
                NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]initWithDictionary:[ClassInfo firstObject]];
                NSString *price = [[infoDict objectForKey:@"AirPriceInfo"]stringValueForKey:@"SellPrice"];
                NSString *guid = [infoDict stringValueForKey:@"GuidInfo"];
                NSString *AgentName = [infoDict objectForKey:@"AgentName"];
                /*
                 qunar 共享价
                 bigcustomer 大客户价
                 shenbianhui 商旅价
                 ota 官网价
                 */
                
                /* {
                 TicketTravelPriceType = 1,//1为商旅价
                 TicketSharePriceType = 2,//2 为共享价
                 TicketOfficialWebsitePriceType = 5,//5为官网价
                 TicketLargeCustomerPriceType = 4,//4为大客户、公司协议价
                 };*/
                
                if([AgentName isEqualToString:@"qunar"])
                {
                    price = [price stringByAppendingString:@"|2"];
                }
                else if([AgentName isEqualToString:@"bigcustomer"])
                {
                    price = [price stringByAppendingString:@"|4"];
                }
                else if([AgentName isEqualToString:@"shenbianhui"])
                {
                    price = [price stringByAppendingString:@"|1"];
                }
                else if([AgentName isEqualToString:@"ota"])
                {
                    price = [price stringByAppendingString:@"|5"];
                }
                else
                {
                    price = [price stringByAppendingString:@"|1"];
                }
                [infoDict setObject:[NSString stringWithFormat:@"%@",price] forKey:@"price"];
                [infoDict setObject:[NSString stringWithFormat:@"%@",guid] forKey:@"guid"];
                _recommendFlight = [[BeTicketDetailModel alloc]initWithDict:infoDict];
                _recommendAirport = [[BeTicketQueryResultModel alloc]init];
                [_recommendAirport setModelWith:clzc];
            }
        }
    }
    return self;
}
@end
