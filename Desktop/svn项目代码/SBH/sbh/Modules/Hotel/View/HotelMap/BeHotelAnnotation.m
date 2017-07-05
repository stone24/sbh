//
//  BeHotelAnnotation.m
//  sbh
//
//  Created by RobinLiu on 16/4/5.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeHotelAnnotation.h"

@implementation BeHotelAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init])
    {
        self.coordinate = coordinate;
    }
    return self;
}
@end
