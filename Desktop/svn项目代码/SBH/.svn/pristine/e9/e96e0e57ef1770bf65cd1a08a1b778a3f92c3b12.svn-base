//
//  BeTrainOrderListModel.m
//  sbh
//
//  Created by SBH on 15/6/18.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTrainOrderListModel.h"
#import "NSDictionary+Additions.h"

@implementation BeTrainOrderListModel
- (id)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        _dict = dict;
        _orderno = [dict stringValueForKey:@"OrderNo" defaultValue:@""];
        _ename = [dict stringValueForKey:@"TrainNO" defaultValue:@""];
        _boardpointline = [dict stringValueForKey:@"BoardPointName" defaultValue:@""];
        _offpointline = [dict stringValueForKey:@"OffPointName" defaultValue:@""];
        NSString *allPassengerName = [NSString string];
        for(NSDictionary *member in [[dict dictValueForKey:@"Passengers"] arrayValueForKey:@"Passenger"])
        {
            allPassengerName = [allPassengerName stringByAppendingString:[member stringValueForKey:@"PsgName" defaultValue:@""]];
            if(![[[[dict dictValueForKey:@"Passengers"] arrayValueForKey:@"Passenger"] lastObject]isEqual:member])
            {
                allPassengerName = [allPassengerName stringByAppendingString:@"/"];
            }
        }
        _psgname = allPassengerName;
        _accountreceivable = [dict stringValueForKey:@"AccountReceivable" defaultValue:@""];
        _departdate = [NSString stringWithFormat:@"%@ %@",[dict stringValueForKey:@"DepartDate" defaultValue:@""],[dict stringValueForKey:@"DepartTime" defaultValue:@""]];
        _officialorprivate = [dict stringValueForKey:@"OrderNo" defaultValue:@""];
        _orderst = [dict stringValueForKey:@"OrderSt" defaultValue:@""];
        _lockst = [dict stringValueForKey:@"OrderNo" defaultValue:@""];
    }
    return self;
}
@end
