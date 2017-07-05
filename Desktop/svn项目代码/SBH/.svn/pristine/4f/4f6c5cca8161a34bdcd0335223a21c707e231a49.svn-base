//
//  BeTrainServer.h
//  sbh
//
//  Created by RobinLiu on 15/6/17.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeTrainTicketInquireItem.h"
#import "BeTrainBookModel.h"

@interface BeTrainServer : NSObject
/**
 * 获取火车票列表
 */
- (void)getDataWithItem:(BeTrainTicketInquireItem *)item andSuccess:(void(^)(NSDictionary *))success andFailure:(void (^)(NSError *))err;

/**
 * 获取火车票订单填写页面数据
 */
- (void)getTrainOrderWriteData:(BeTrainBookModel *)item andSuccess:(void (^)(NSDictionary *))success andFailure:(void (^)(NSError *))err;

/**
 * 提交火车票订单
 */
- (void)commitTrainOrderWithData:(BeTrainBookModel *)item andPture:(NSString *)ptrue andSuccess:(void (^)(NSDictionary *))success andFailure:(void (^)(NSError *))error;
/**
 * 获取火车票订单信息
 */
- (void)getTrainOrderStatusWith:(NSString *)orderno andSuccess:(void (^)(NSDictionary *))success andFailure:(void (^)(NSError *))error;
/**
 * 火车票支付接口
 */
- (void)payTrainOrderWith:(NSString *)orderno andSuccess:(void (^)(NSDictionary *))success andFailure:(void (^)(NSError *))error;

/**
 * 获取亿阳费用中心
 */
- (void)checkYiyangTrainOrderWith:(BeTrainBookModel *)model byCallback:(void (^)(NSDictionary *))successBack failureCallback:(void (^)(NSError *))failureCallback;
@end
