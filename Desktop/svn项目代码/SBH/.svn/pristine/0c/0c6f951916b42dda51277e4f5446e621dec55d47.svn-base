//
//  BeTrainTicketFilterConditionS.m
//  sbh
//
//  Created by RobinLiu on 15/6/16.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTrainTicketFilterConditions.h"

@implementation BeTrainTicketFilterConditions
- (id)initConfigure
{
    if(self = [super init])
    {
        _isOnlyStraight = NO;
        _trainTypeCondition = kUnlimitedCondition;
        _seatTypeCondition = kUnlimitedCondition;
        _startTimeArray = [[NSMutableArray alloc]initWithObjects:kUnlimitedCondition, nil];
        _arriveTimeArray = [[NSMutableArray alloc]initWithObjects:kUnlimitedCondition, nil];
    }
    return self;
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"%d,%@,%@,%@,%@",_isOnlyStraight,_trainTypeCondition,_seatTypeCondition,_startTimeArray,_arriveTimeArray];
}
@end
