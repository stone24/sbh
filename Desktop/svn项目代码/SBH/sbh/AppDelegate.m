//
//  AppDelegate.m
//  SBHAPP
//
//  Created by musmile on 14-6-3.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "AppDelegate.h"
#import "SBHNavigationController.h"
#import "SHBTabbarController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AppDelegate+Additions.h"
#import "AppDelegate+JPush.h"

@interface AppDelegate () <CLLocationManagerDelegate>
@end

@implementation AppDelegate

- (CLLocationManager *)manager{
    if (!_manager) {
        _manager = [[CLLocationManager alloc]init];
        self.manager.delegate = self;
        if(iOS8) {
            [self.manager requestWhenInUseAuthorization];
        }
    }
    return _manager;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *locat = locations.firstObject;
    CLLocationCoordinate2D coordinate = locat.coordinate;
    self.coordinate = coordinate;
    [self getCityName];
    [self.manager stopUpdatingLocation];
}

- (void)startLocating
{
    if ([CLLocationManager locationServicesEnabled])
    {
        [self.manager startUpdatingLocation];
        self.manager.distanceFilter = kCLHeadingFilterNone;
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    else
    {
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    SHBTabbarController *tabVC = [[SHBTabbarController alloc]init];
    SBHNavigationController *nav = [[SBHNavigationController alloc] initWithRootViewController:tabVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [self setUpJPushWith:launchOptions];
    [self automaticLogin];
    [self setupUmeng];
    [self tencentMapConfigure];
    [self commonConfigure];
    [self configureAPIKey];
    
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    return YES;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *str = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    SBHLog(@"udid---%@",str);
    [GlobalData getSharedInstance].iphoneUdid = str;
    [JPUSHService registerDeviceToken:deviceToken];
}

// 点击推送消息后，调用的方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [self receiveNotificationWith:application and:userInfo];
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self startLocating];
    [self checkVersion];
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setJPushTag:(NSString *)aTag
{
    [self setupJPushTag:aTag];
}
- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif
{
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}
#pragma mark - getCurrentDisplayViewController
- (UIViewController *)getCurrentDisplayViewController
{
    return [self topViewControllerWithRootViewController:self.window.rootViewController];
}
- (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController
{
    if([rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    }else if ([rootViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    }
    else if (rootViewController.presentedViewController)
    {
        UIViewController *presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    }
    else
    {
        return rootViewController;
    }
}
+ (AppDelegate *)appdelegate
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}
@end
