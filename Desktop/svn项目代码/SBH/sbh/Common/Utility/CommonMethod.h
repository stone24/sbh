//
//  CommonMethod.h
//  sbh
//
//  Created by RobinLiu on 2017/7/3.
//  Copyright © 2017年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kFormatYYYYMMDDHHMMSS   @"yyyy-MM-dd HH:mm:ss"
#define kFormatYYYYMMDD         @"yyyy-MM-dd"

@interface CommonMethod : NSObject

/**
 提示信息

 @param nssMesg
 */
+ (void)showMessage:(NSString *)nssMesg;

/**
 处理网络错误

 @param error
 */
+ (void)handleErrorWith:(NSError *)error;

/**
 字符串转换成NSDate类型

 @param dateString 时间字符串
 @param paseStr 时间格式
 @return NSDate
 */
+ (NSDate *)dateFromString:(NSString *)dateString WithParseStr:(NSString*)paseStr;

/**
 NSDate转换成字符串类型

 @param date 时间
 @param paseStr 格式
 @return 字符串
 */
+ (NSString *)stringFromDate:(NSDate *)date WithParseStr:(NSString*)paseStr;

/**
 获取星期几

 @param date 日期
 @return 周几
 */
+ (NSString*)getWeekDayFromDate:(NSDate *)date;

/**
 获取前一天

 @param adate 当前日期
 @return 前一天的日期
 */
+ (NSDate*)getTheDayBefore:(NSDate*)adate;

/**
 获取后一天

 @param adate 当前日期
 @return 后一天的日期
 */
+ (NSDate*)getTheDayAfter:(NSDate*)adate;

@end
