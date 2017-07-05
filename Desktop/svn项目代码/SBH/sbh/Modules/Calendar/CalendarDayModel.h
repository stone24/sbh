//
//  WQCalendarDay.h
//  WQCalendar
//
//  Created by Jason Lee on 14-3-4.
//  Copyright (c) 2014年 Jason Lee. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com


#define CAN_SHOW 1    //可以被点击
#define CANNOT_SHOW 0//不能被点击


#import <Foundation/Foundation.h>
#import "NSDate+WQCalendarLogic.h"



typedef NS_ENUM(NSInteger,CollectionViewCellDayType) {
    CellDayTypeEmpty,   //不显示
    CellDayTypePast,    //过去的日期
    CellDayTypeFutur,   //将来的日期
    CellDayTypeWeek,    //周末
    CellDayTypeClick    //被点击的日期

};
typedef NS_ENUM(NSInteger,DayTipsType)
{
    DayTipsTypeAirStart,        //机票出发日期
    DayTipsTypeAirReturn,       //机票返回日期
    DayTipsTypeHotelStart,      //酒店入住日期
    DayTipsTypeHotelLeave,      //酒店离店日期
    DayTipsTypeTrainStart,      //火车票出发日期
    DayTipsTypeMeetingStart,    //会议开始日期
    DayTipsTypeMeetingLeave     //会议结束日期
};
@interface CalendarDayModel : NSObject

@property (assign, nonatomic) CollectionViewCellDayType style;//显示的样式
@property (assign, nonatomic) DayTipsType modelType;//底下的标签显示的样式
@property (nonatomic, assign) NSUInteger day;//天
@property (nonatomic, assign) NSUInteger month;//月
@property (nonatomic, assign) NSUInteger year;//年
@property (nonatomic, assign) NSUInteger week;//周

@property (nonatomic, strong) NSString *Chinese_calendar;//农历
@property (nonatomic, strong) NSString *holiday;//节日
@property (nonatomic, strong) NSString *specialDay;//显示今天，明天，后天
+ (CalendarDayModel *)calendarDayWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;
- (NSDate *)date;//返回当前天的NSDate对象
- (NSString *)toString;//返回当前天的NSString对象
- (NSString *)getWeek; //返回星期

//- (BOOL)isEqualTo:(CalendarDayModel *)day;//判断是不是同一天


@end
