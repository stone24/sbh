//
//  CommonMethod.m
//  sbh
//
//  Created by RobinLiu on 2017/7/3.
//  Copyright © 2017年 shenbianhui. All rights reserved.
//

#import "CommonMethod.h"
#import "AppDelegate.h"

@implementation CommonMethod

+ (void)showMessage:(NSString *)nssMesg
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:nssMesg preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [[[AppDelegate appdelegate]getCurrentDisplayViewController]presentViewController:alertController animated:YES completion:nil];
}
+ (void)handleErrorWith:(NSError *)error
{
    if (error.code == 10003 || error.code == 10006)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"登录失效，请重新登录！" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [BeLogUtility doLogOn];
        }]];
        [[[AppDelegate appdelegate]getCurrentDisplayViewController]presentViewController:alertController animated:YES completion:nil];
        return;
    }
    else if (error.code == kHttpRequestCancelledError || error.code == kErrCodeNetWorkUnavaible)
    {
        [self showMessage:kNetworkAbnormal];
    }
    else if (error.code == 20013 || error.code == 20031)
    {
        [self showMessage:@"企业额度不够,或是合同已到期，请验证后，再提交"];
    }
    else
    {
        [self showMessage:[GlobalData getErrMsg:[NSString stringWithFormat:@"%ld",(long)error.code]]];
    }
}

+ (NSDate *)dateFromString:(NSString *)dateString WithParseStr:(NSString*)paseStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: paseStr];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}
+ (NSString *)stringFromDate:(NSDate *)date WithParseStr:(NSString*)paseStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:paseStr];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+ (NSString*)getWeekDayFromDate:(NSDate *)date
{
    int weekDay= [self weekDayFromDate:date];
    if(weekDay<1 || weekDay>7)
        return @"";
    switch (weekDay)
    {
        case 1:
            return @"日";
            break;
        case 2:
            return @"一";
            break;
        case 3:
            return @"二";
            break;
        case 4:
            return @"三";
            break;
        case 5:
            return @"四";
            break;
        case 6:
            return @"五";
            break;
        case 7:
            return @"六";
            break;
        default:
            return @"";
            break;
    }
}

+ (NSDate*)getTheDayBefore:(NSDate*)adate
{
    NSDate *newDate = [[NSDate alloc]
                       initWithTimeIntervalSinceReferenceDate:
                       ([adate timeIntervalSinceReferenceDate] - 24*3600)];
    return newDate;
}

+ (NSDate*)getTheDayAfter:(NSDate*)adate
{
    NSDate *newDate = [[NSDate alloc]
                       initWithTimeIntervalSinceReferenceDate:
                       ([adate timeIntervalSinceReferenceDate] + 24*3600)];
    return newDate;
}
#pragma mark - private method
+ (int)weekDayFromDate:(NSDate*)aDate
{
    int weekday =0;
    if(aDate == nil)
    {
        weekday = 0;
    }
    else
    {
        NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar]
                                       components:NSCalendarUnitWeekday fromDate:aDate];
        weekday = (int)[componets weekday];
    }
    
    return weekday;
}
@end
