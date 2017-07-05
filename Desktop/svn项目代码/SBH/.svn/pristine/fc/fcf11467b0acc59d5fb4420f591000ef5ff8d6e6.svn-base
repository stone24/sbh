//
//  AppDelegate.h
//  SBHAPP
//
//  Created by musmile on 14-6-3.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMMobClick/MobClick.h"
#import <CoreLocation/CoreLocation.h>
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong,nonatomic) UIWindow *window;
@property (nonatomic,strong) CLLocationManager *manager;
@property (nonatomic,strong) NSString *cityName;
/**
 * 获取到的经纬度
 */
@property (nonatomic,assign)CLLocationCoordinate2D coordinate;

/**
 * 函数功能：设置极光
 */
-(void)setJPushTag:(NSString*)aTag;

/**
 * 获取当前显示的ViewController
 */
- (UIViewController *)getCurrentDisplayViewController;


+ (AppDelegate *)appdelegate;

@end
