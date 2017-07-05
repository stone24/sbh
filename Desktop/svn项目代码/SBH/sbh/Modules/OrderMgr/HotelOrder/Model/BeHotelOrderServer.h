//
//  BeHotelOrderServer.h
//  SideBenefit
//
//  Created by RobinLiu on 15/3/19.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeHotelOrderServer : NSObject
/**
 * 获取酒店订单详情接口
 */
- (void)doGetHotelOrderDetailWith:(id)object andSuccessCallback:(void (^)(NSDictionary *))callback andFailureCallback:(void (^)(NSString *))failure;
/**
 * 取消订单接口
 */
- (void)doCancelOrderWith:(id)object andReason:(NSString *)reason andSuccess:(void (^)(NSString *))callback andFailure:(void (^)(NSString *))failure;
@end
