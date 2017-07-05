//
//  BeSpeCarAirportModel.m
//  sbh
//
//  Created by RobinLiu on 2016/12/15.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeSpeCarAirportModel.h"
#import "NSDictionary+Additions.h"

@implementation BeSpeCarAirportModel
- (id)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        _location = [dict stringValueForKey:@"location"];
        _airportCode = [dict stringValueForKey:@"airportCode"];
        _latitude = [dict stringValueForKey:@"latitude"];
        _longitude = [dict stringValueForKey:@"longitude"];
        _airportName = [dict stringValueForKey:@"airportName"];
        _airportId = [dict stringValueForKey:@"airportId"];
    }
    return self;
}
@end
