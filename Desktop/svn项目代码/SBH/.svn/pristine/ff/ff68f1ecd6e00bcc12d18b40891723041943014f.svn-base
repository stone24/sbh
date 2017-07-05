//
//  BeHotelServer.h
//  SideBenefit
//
//  Created by RobinLiu on 15/3/14.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeHotelListRequestModel.h"
#import "BeHotelOrderWriteModel.h"

@interface BeHotelServer : NSObject

/**
 * 获取酒店列表接口
 */
- (void)doGetHotelListWith:(BeHotelListRequestModel *)object andCallback:(void (^)(NSMutableDictionary *))callback failureCallback:(void (^)(NSString *))failureCallback;

/**
 * 酒店详情接口
 */
- (void)getHotelDetailWith:(BeHotelListItem *)item andFlag:(NSString *)flag byCallback:(void (^)(NSMutableDictionary *))callback failureCallback:(void (^)(NSString *))failureCallback;

/**
 * 获取酒店预订页面的价格列表
 */
- (void)getHotelOrderPriceListWith:(BeHotelOrderWriteModel *)writeModel byCallback:(void (^)(NSDictionary *))callback failureCallback:(void (^)(NSError *))failureCallback;
/**
 * 亿阳查询费用中心
 */
- (void)checkYiyangOrderWith:(BeHotelOrderWriteModel *)model byCallback:(void (^)(NSDictionary *))successBack failureCallback:(void (^)(NSError *))failureCallback;

/**
 * 订单提交
 */
- (void)commitOrderWith:(BeHotelOrderWriteModel *)model byCallback:(void (^)(NSDictionary *))successBack failureCallback:(void (^)(NSError *))failureCallback;

/**
 * 订单确认
 */
- (void)confirmOrderWith:(BeHotelOrderWriteModel *)orderModel byCallback:(void (^)(NSDictionary *))successBack failureCallback:(void (^)(NSError *))failureCallback;

/**
 * 根据酒店坐标获取周边酒店
 */
- (void)getNearByHotelWith:(BeHotelListItem *)model byCallback:(void (^)(NSMutableArray *))successBack failureCallback:(void (^)(NSError *))failureCallback;

/**
 * 酒店搜索接口
 */
- (void)searchHotelWith:(NSString *)cityCode andKeyword:(NSString *)keyword byCallback:(void (^)(NSMutableArray *))successBack failureCallback:(void (^)(NSError *))failureCallback;
/**
 * 到付获取审批信息
 */
- (void)getHotelAuditWith:(BeHotelOrderWriteModel *)model byCallback:(void (^)(NSDictionary *))successBack failureCallback:(void (^)(NSError *))failureCallback;
@end
