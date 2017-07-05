//
//  BeSpeCallCarModel.m
//  sbh
//
//  Created by SBH on 15/7/16.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeSpeCallCarPramaModel.h"
#import "selectPerson.h"

@implementation BeSpeCallCarPramaModel
- (instancetype)init
{
    if (self = [super init]) {
        _passenger_name = @" ";
        _callNum = @"";
        _passenger_phone = @" ";
        _start_address = @"";
        _end_address = @"";
        _order_id = @"";
        _require_level = @"";
    }
    return self;
}

- (void)setCallNum:(NSString *)callNum
{
    if (callNum.length == 0) {
        _callNum = @"0";
    } else {
        _callNum = callNum;
    }
}

@end
