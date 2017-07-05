//
//  BeLoginManager.h
//  sbh
//
//  Created by RobinLiu on 15/5/11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^loginCancelBlock)(void);
typedef void (^loginHandleBlock)(NSString * loginTips);
typedef void (^loginSuccBlock)(void);

@interface BeLoginManager : NSObject

@property (nonatomic,copy)loginSuccBlock successLoginBlock;
@property (nonatomic,copy)loginCancelBlock cancelBlock;
@property (nonatomic,copy)loginHandleBlock handleLoginBlock;

+ (BeLoginManager *)sharedInstance;

- (void)cancelLogin;

/**
 * 其他页面需要登录的操作
 */
- (void)startLogin;

/**
 * 应用启动时用之前存储的数据登录
 */
- (void)doLoginWithStoredData;

/**
 * 登录页面的操作
 */
- (void)enterpriseLoginWithObject:(id)loginObject andSuccessBlock:(loginHandleBlock)successBlock andFailBlock:(loginHandleBlock)block;

/**
 * 退出登录的操作
 */
- (void)startLogOffWithSuccessBlock:(loginHandleBlock)successBlock andFailureBlock:(loginHandleBlock)failureblock;
@end
