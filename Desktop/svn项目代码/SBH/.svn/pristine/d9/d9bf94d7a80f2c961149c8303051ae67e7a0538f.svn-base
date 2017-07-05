//
//  BeFlightModel.m
//  sbh
//
//  Created by SBH on 15/4/14.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeFlightModel.h"

@implementation BeFlightModel
- (void)setViaport:(NSString *)viaport
{
    _viaport = viaport;
    if ([viaport isEqualToString:@"1"]) {
        _viaportStr = @"有";
    } else {
        _viaportStr = @"无";
    }
}

- (void)setFlttime:(NSString *)flttime
{
    _flttime = flttime;
    NSMutableString *timeStrM = [NSMutableString stringWithString:flttime];
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
