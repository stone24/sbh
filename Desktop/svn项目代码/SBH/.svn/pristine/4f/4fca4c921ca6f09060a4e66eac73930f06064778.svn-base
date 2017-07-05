//
//  BeOrderWriteAuditInfoModel.m
//  sbh
//
//  Created by SBH on 15/5/13.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeOrderWriteAuditInfoModel.h"
#import "NSDictionary+Additions.h"

@implementation BeOrderWriteAuditInfoModel
- (id)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        _Name = [dict stringValueForKey:@"name" defaultValue:@""];
        _Mobile = [dict stringValueForKey:@"mobile" defaultValue:@""];
        _Email = [dict stringValueForKey:@"email" defaultValue:@""];
        _level = [dict stringValueForKey:@"level" defaultValue:@""];
        _responseDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    }
    return self;
}
@end
