//
//  SBHOrderListModel.m
//  sbh
//
//  Created by SBH on 15-1-26.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "SBHOrderListModel.h"

@implementation SBHOrderListModel

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

- (void)setAccountreceivable:(NSString *)accountreceivable
{
    _accountreceivable = [NSString stringWithFormat:@"￥%@",accountreceivable];
}
@end
