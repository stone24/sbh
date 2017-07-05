//
//  BeSpeCarFlightModel.m
//  sbh
//
//  Created by RobinLiu on 2016/12/19.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeSpeCarFlightModel.h"
#import "NSDictionary+Additions.h"

@implementation BeSpeCarFlightModel

-  (id)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        _state = [dict stringValueForKey:@"state"];// = 2,
        _airportName = [dict stringValueForKey:@"airportName"];//南京禄口国际机场T2航站楼,
        _arrDate = [dict stringValueForKey:@"arrDate"];//2016-12-19 12:55:00,
        _locationLo = [dict stringValueForKey:@"locationLo"];//118.87,
        _returnCode = [dict stringValueForKey:@"returnCode"];//0,
        _location = [dict stringValueForKey:@"location"];//118.87,31.73,
        _locationLa = [dict stringValueForKey:@"locationLa"];//31.73,
        _planDate = [dict stringValueForKey:@"planDate"];//2016-12-19 08:20:00,
        _arrCode = [dict stringValueForKey:@"arrCode"];//NKG,
        _airportId = [dict stringValueForKey:@"airportId"];//114,
        _depCode = [dict stringValueForKey:@"depCode"];//NKG,
        _hTerminal = [dict stringValueForKey:@"hTerminal"];//T2
    }
    return self;
}
@end
