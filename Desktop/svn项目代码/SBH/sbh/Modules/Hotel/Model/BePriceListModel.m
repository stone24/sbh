//
//  BePriceListModel.m
//  SideBenefit
//
//  Created by SBH on 15-3-18.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BePriceListModel.h"

@implementation BePriceListModel
- (void)setRoomDate:(NSString *)RoomDate
{
   _RoomDate = [[RoomDate componentsSeparatedByString:@"T"] firstObject];
}

// 实现copy
- (id)copyWithZone:(NSZone *)zone
{
    BePriceListModel *copy = [[[self class] allocWithZone:zone] init];
    copy->_RoomDate = [self.RoomDate copy];
    copy->_SalePrice = [self.SalePrice copy];
    return copy;
}

@end
