//
//  CalendarViewController.h
//  Calendar
//
//  Created by 张凡 on 14-8-21.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarLogic.h"
#import "CalendarDayModel.h"

typedef NS_ENUM(NSInteger,CalendarViewType)
{
    AirplaneCalendar,
    HotelCalendar,
};

typedef void (^CalendarViewBlock)(CalendarDayModel *model);


@interface CalendarViewController : UIViewController
@property(nonatomic ,strong) UICollectionView* collectionView;//网格视图
@property(nonatomic ,strong) NSMutableArray *calendarMonth;//每个月份的中的daymodel容器数组
@property(nonatomic ,strong) CalendarLogic *Logic;
@property (nonatomic, copy) CalendarViewBlock calendarblock;//回调
@property (nonatomic,assign)DayTipsType selectType;
@property (nonatomic,retain)NSDate *selectDate;
@end
