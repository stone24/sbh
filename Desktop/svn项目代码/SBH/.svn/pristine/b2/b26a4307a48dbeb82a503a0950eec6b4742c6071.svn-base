//
//  BeOrderWriteAirlistModel.m
//  sbh
//
//  Created by SBH on 15/5/11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeOrderWriteAirlistModel.h"

@implementation BeOrderWriteAirlistModel
- (void)setDeparturetime:(NSString *)departuretime
{
    _departuretime = departuretime;
    NSMutableString *timeStrM = [NSMutableString stringWithString:departuretime];
    [timeStrM insertString:@":" atIndex:2];
    self.fltimeStr = timeStrM;
}

- (void)setArrivaltime:(NSString *)arrivaltime
{
    _arrivaltime = arrivaltime;
    NSMutableString *timeStrM = [NSMutableString stringWithString:arrivaltime];
    [timeStrM insertString:@":" atIndex:2];
    self.arrivaltimeStr = timeStrM;
}
@end
