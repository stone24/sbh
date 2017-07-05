//
//  BePassengerModel.m
//  sbh
//
//  Created by SBH on 15/4/14.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BePassengerModel.h"

@implementation BePassengerModel
- (NSMutableArray *)airtickets
{
    if (_airtickets == nil) {
        _airtickets = [NSMutableArray array];
    }
    return _airtickets;
}

@end
