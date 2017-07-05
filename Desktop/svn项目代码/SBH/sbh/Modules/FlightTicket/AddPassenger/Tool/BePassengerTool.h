//
//  BePassengerTool.h
//  sbh
//
//  Created by RobinLiu on 15/11/18.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BePassengerTool : NSObject
/**
 * 酒店获取最近入住人
 */
- (void)getRecentHotelListWith:(NSString *)name andDepartId:(NSString *)departmentid bySuccess:(void (^)(NSMutableArray *))callback failure:(void (^)(NSError *))failure;

/**
 * 用车页面获取最近出行列表
 */
- (void)getCarRecentListWith:(NSString *)name bySuccess:(void (^)(NSMutableArray *))callback failure:(void (^)(NSError *))failure;

/**
 * 获取企业员工列表
 */
- (void)getEmployeeListWith:(NSDictionary *)parameters bySuccess:(void (^)(NSString *currentPage,NSString *pageCount,NSString *totalCount,NSArray *listArray))callback failure:(void (^)(NSError *))failure;

@end
