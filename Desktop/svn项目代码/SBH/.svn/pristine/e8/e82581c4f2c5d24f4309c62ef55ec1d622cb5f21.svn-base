//
//  BeLoginServer.h
//  sbh
//
//  Created by RobinLiu on 15/5/11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeLoginServer : NSObject
/**
 * 企业用户登录接口
 */
- (void)doEnterpriseUserLoginWith:(id)loginObject byCallback:(void (^)(NSMutableDictionary *))callback failureCallback:(void (^)(NSString *))failureCallback;

/**
 * 退出登录接口
 */
- (void)doLogOffWith:(id)logOffObject byCallback:(void (^)(NSMutableDictionary *))callback failureCallback:(void(^)(NSString *))failureCallback;
@end
