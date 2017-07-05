//
//  BeLogUtility.m
//  SideBenefit
//
//  Created by RobinLiu on 15/3/4.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeLogUtility.h"
#import "BeLoginManager.h"
#import<QuartzCore/QuartzCore.h>

@implementation BeLogUtility

+ (void)doLogOn
{
    [[BeLoginManager sharedInstance]startLogin];
}
@end
