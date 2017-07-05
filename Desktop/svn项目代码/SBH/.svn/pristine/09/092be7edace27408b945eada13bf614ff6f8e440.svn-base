//
//  BeTrainTicketInquireItem.m
//  sbh
//
//  Created by RobinLiu on 15/6/15.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTrainTicketInquireItem.h"
#import "SBHHttp.h"
#import "ServerConfigure.h"
#import "FMDatabase.h"

@implementation BeTrainTicketInquireItem
+ (BeTrainTicketInquireItem *)sharedInstance
{
    static dispatch_once_t onceToken;
    static BeTrainTicketInquireItem *_instance;
    dispatch_once(&onceToken, ^{
        if(_instance == nil)
        {
            _instance = [[BeTrainTicketInquireItem alloc]init];
        }
    });
    return _instance;
}
- (id)init
{
    if(self = [super init])
    {
        _startDate = [NSDate date];
        _startDateStr = [CommonMethod stringFromDate:_startDate WithParseStr:kFormatYYYYMMDD];
        _fromTrainStation = @"北京";
        _toTrainStation = @"上海";
        _fromStationCode = @"BJP";
        _toStationCode = @"SHH";
        _journeytype = @"OW";
        _gs = @"1";
        _GuidSearch = @"";
        _orderKey = @"";
    }
    return self;
}
- (void)setStartDate:(NSDate *)startDate
{
    _startDate = startDate;
    _startDateStr = [CommonMethod stringFromDate:_startDate WithParseStr:kFormatYYYYMMDD];
}
@end
