//
//  BeSpeCarAirportModel.h
//  sbh
//
//  Created by RobinLiu on 2016/12/15.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeSpeCarAirportModel : NSObject
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *airportCode;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *airportName;
@property (nonatomic, strong) NSString *airportId;
- (id)initWithDict:(NSDictionary *)dict;
@end
