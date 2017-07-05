//
//  BeSpeCarLevelModel.m
//  sbh
//
//  Created by SBH on 15/7/15.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeSpeCarLevelModel.h"

@implementation BeSpeCarLevelModel
- (void)setStart_price:(NSString *)start_price
{
    if (start_price.length == 0) {
        start_price = @"";
    }
//    if (start_price.intValue == 0) {
//        start_price = @"10";
//    }
    _start_price = start_price;
    _startPriceInt = [start_price intValue];
}

- (void)setFee_per_kilometer:(NSString *)fee_per_kilometer
{
    NSString *str = [NSString stringWithFormat:@"%d", [fee_per_kilometer intValue]/100];
    _fee_per_kilometer = str;
    _normal_unit_price = str;
}

- (void)setName:(NSString *)name
{
//    if ([name isEqualToString:@"Tesla车型"]) {
//        _name = @"新能源型";
//    } else
    if([name hasPrefix:@"快车"]){
        _name = @"经济型";
    } else if([name hasPrefix:@"商务"]){
        _name = @"商务7座";
    } else {
        _name = [name stringByReplacingOccurrencesOfString:@"车" withString:@""];
    }
}
@end
