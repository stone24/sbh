//
//  BeAddressModel.m
//  sbh
//
//  Created by RobinLiu on 15/7/14.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeAddressModel.h"
#import "NSDictionary+Additions.h"

@implementation BeAddressModel
- (id)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        _addressId = [dict stringValueForKey:@"id" defaultValue:@""];
        _title = [dict stringValueForKey:@"title" defaultValue:@""];
        _address = [dict stringValueForKey:@"address" defaultValue:@""];
        _category = [dict stringValueForKey:@"category" defaultValue:@""];
        NSDictionary *locaDict = [dict objectForKey:@"location"];
        _location = CLLocationCoordinate2DMake([[locaDict objectForKey:@"lat"] floatValue], [[locaDict objectForKey:@"lng"] floatValue]);
        _distance= [dict stringValueForKey:@"_distance" defaultValue:@""];
    }
    return self;
} 

- (void)setAddress:(NSString *)address
{
    _address = address;
    if([_address length]<1)
    {
        _address = [_title copy];
    }
    _addressParam = [_address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleParam = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
