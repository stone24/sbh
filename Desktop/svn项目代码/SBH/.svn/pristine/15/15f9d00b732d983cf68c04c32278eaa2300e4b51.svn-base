//
//  BeAirDynamicServer.h
//  SideBenefit
//
//  Created by RobinLiu on 15/3/18.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BeAirBlock)(id callback);
@interface BeAirDynamicServer : NSObject
/**
 *  获取用户关心的航班列表
 */
- (void)getRequestCareFlightWithSuccessCallback:(BeAirBlock)successblock andFailureCallback:(BeAirBlock)failblock;
- (void)cancelCareFlightWith:(id)object andSuccessCallback:(BeAirBlock)successblock andFailureCallback:(BeAirBlock)failblock;
@end
