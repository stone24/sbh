//
//  BeAirTicketOrderWriteTool.h
//  sbh
//
//  Created by RobinLiu on 15/11/13.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//  注：中新融创的订票规则:费用中心需要从服务器获取，每次只能订一张。

#import <Foundation/Foundation.h>
#import "BeOrderWriteModel.h"

typedef NS_ENUM(NSInteger,AuditNewType)
{
    AuditNewTypeTicket = 0,
    AuditNewTypeHotel = 1,
};
@interface BeAirTicketOrderWriteTool : NSObject
/**
 * 获取订单填写的数据
 */
- (void)getOrderWriteDataBySuccess:(void (^)(NSDictionary *))callback failure:(void (^)(NSError *))failure;
/**
 * 获取订单填写页面的公司联系人
 */
- (void)getOrderWriteContactListBySuccess:(void (^)(NSArray *contactList,NSString *belongfunction))callback failure:(void (^)(NSString *))failure;
/**
 * 获取中新融创的费用中心
 */
- (void)getSpecilCompanyExpenseCenterWith:(NSString *)userName BySuccess:(void (^)(NSString *))callback failure:(void (^)(NSString *))failure;

/**
 * 获取保险规则
 */
- (void)getInsuranceDataBySuccess:(void (^)(NSString *info1, NSString * price1,NSString *info2, NSString * price2,NSString *info3, NSString * price3,NSArray *successArray))callback failure:(void (^)(NSString *))failure;

/**
 * 获取项目的审批人数组
 */
- (void)getProjectAuditPersonsWith:(BeAuditProjectModel *)model andPassengers:(NSArray *)pArray andTicketId:(NSString *)ticketId andType:(AuditNewType)type BySuccess:(void (^)(NSDictionary *))callback failure:(void (^)(NSString *))failure;

/**
 * 切换审批方式的时候
 */
- (void)changeAuditTypeWith:(NSString *)porjectNo And:(NSString *)projectName andTicketId:(NSString *)ticketId andType:(AuditNewType)type andTripMans:(NSArray *)passengerArray andIsExceed:(NSString *)isExceed andOrderNo:(NSString *)orderNo BySuccess:(void (^)(NSDictionary *))callback failure:(void (^)(NSString *))failure;

/**
 * 下单
 */
- (void)commitFlightOrderWith:(BeOrderWriteModel *)writeModel  BySuccess:(void (^)(NSDictionary *))callback failure:(void (^)(id ))failure;

/**
 * 继续预订的时候下单
 */
+ (void)commmitFlightOrderServerWith:(NSMutableDictionary *)dict BySuccess:(void (^)(NSDictionary *))callback failure:(void (^)(NSError *))failure;

/**
 * 提交新审批
 */
- (void)commitNewAuditWith:(NSDictionary *)paramsDict andType:(AuditNewType)type BySuccess:(void (^)(NSDictionary *))callback failure:(void (^)(NSError *))failure;

/**
 * 查询亿阳的费用中心
 */
- (void)checkYiyangFlightOrderWith:(BeOrderWriteModel *)model byCallback:(void (^)(NSDictionary *))successBack failureCallback:(void (^)(NSError *))failureCallback;
@end
