//
//  AppDelegate+JPush.h
//  sbh
//
//  Created by RobinLiu on 15/7/16.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"

@interface AppDelegate (JPush)<JPUSHRegisterDelegate>
/**
 * 极光推送
 */
- (void)setUpJPushWith:(NSDictionary *)launchOptions;
/**
 * 设置极光的tag
 */
-(void)setupJPushTag:(NSString*)aTag;
/**
 * 本地处理极光推送
 */
- (void)receiveNotificationWith:(UIApplication *)application and:(NSDictionary *)userInfo;
@end
