//
//  SBHManageModel.m
//  sbh
//
//  Created by SBH on 14-12-27.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "SBHManageModel.h"
@implementation SBHManageModel

- (void)setAirline:(NSString *)airline
{
    _airline = airline;
    airline = [airline stringByReplacingOccurrencesOfString:@"(" withString:@")"];
    NSArray *airArray = [airline componentsSeparatedByString:@")"];
    if (airArray.count >= 3) {
        self.comeCity = [airArray objectAtIndex:1];
        self.reachCity = [airArray objectAtIndex:3];
    }
}

@end
