 //
//  AppDelegate+JPush.m
//  sbh
//
//  Created by RobinLiu on 15/7/16.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "AppDelegate+JPush.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SHBTabbarController.h"

@implementation AppDelegate (JPush)

- (void)setUpJPushWith:(NSDictionary *)launchOptions
{
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    // 极光推送
    /*NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidSetup:) name:kJPFNetworkDidSetupNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidClose:) name:kJPFNetworkDidCloseNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidRegister:) name:kJPFNetworkDidRegisterNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];*/
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
#else
    //categories 必须为nil
    [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
#endif
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    BOOL isProduction = YES;
#ifdef DEBUG
    isProduction = NO;
#endif
    [JPUSHService setupWithOption:launchOptions appKey:@"d2ad27eb36c24fff84b37753"
                          channel:@"Publish channel"
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
}
- (void)networkDidSetup:(NSNotification *)notification {
    
    //NSLog(@"已连接 = %@",notification);
}

- (void)networkDidClose:(NSNotification *)notification {
    
    //NSLog(@"未连接。。。");
}

- (void)networkDidRegister:(NSNotification *)notification {
    
    //NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    
    //NSLog(@"已登录");
}
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    [self handleReceiveMessage:[notification userInfo]];
}
-(void)handleReceiveMessage:(NSDictionary*)auserInfo
{
    NSDictionary * userInfo = auserInfo;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *content = [[userInfo valueForKey:@"aps"] objectForKey:@"alert"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * title = [CommonMethod stringFromDate:[NSDate date]WithParseStr:kFormatYYYYMMDD];
    [self showPustStatus:title WithContent:content WithDic:auserInfo];
}

-(void)showPustStatus:(NSString*)aTitle WithContent:(NSString*)aContent WithDic:(NSDictionary*)extras
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if(notification!=nil)
    {
        NSDate *now = [NSDate date];
        notification.fireDate=[now dateByAddingTimeInterval:0];
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.alertBody=aContent;
        notification.soundName= UILocalNotificationDefaultSoundName;
        notification.alertAction=NSLocalizedString(aTitle, nil);
        notification.applicationIconBadgeNumber = 0;
        [notification setUserInfo:extras];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}
-(void)setupJPushTag:(NSString*)aTag
{
    [JPUSHService setTags:[NSSet setWithObjects:aTag,nil] alias:aTag callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:nil];
}

#pragma mark- JPUSHRegisterDelegate
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    [self receiveNotificationWith:[UIApplication sharedApplication] and:userInfo];
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}
#endif

- (void)receiveNotificationWith:(UIApplication *)application and:(NSDictionary *)userInfo
{
    application.applicationIconBadgeNumber = 0;
}
static SystemSoundID shake_sound_male_id = 0;
- (void)playSound
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"sound" ofType:@"caf"];
    if (path) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
    }
    AudioServicesPlaySystemSound(shake_sound_male_id);
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    //NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
@end
