//
//  BeMeetingModel.m
//  sbh
//
//  Created by RobinLiu on 16/6/20.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeMeetingModel.h"
#import "AppDelegate.h"
@implementation BeMeetingModel
- (id)init
{
    if(self = [super init])
    {
        NSDate *date = [NSDate date];
        _startDate = [date dateByAddingTimeInterval:3600*24];
        _leaveDate = [date dateByAddingTimeInterval:3600*48];
        _budget = @"";
        _number = @"";
        _demand = @"";
        _contactPerson = @"";
        _contactPhone = @"";
        AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        if(delegate.cityName.length > 0 && ![delegate.cityName isEqualToString:@"正在定位"])
        {
            _cityName = delegate.cityName;
        }
        else
        {
            _cityName = @"北京";
        }
    }
    return self;
}
@end
