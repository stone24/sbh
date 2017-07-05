//
//  CalendarHomeViewController.m
//  Calendar
//
//  Created by 张凡 on 14-6-23.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

#import "CalendarHomeViewController.h"
#import "NSDate+WQCalendarLogic.h"
@interface CalendarHomeViewController ()
{
    int daynumber;//天数
    int optiondaynumber;//选择日期数量
}

@end

@implementation CalendarHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"选择日期";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"commonBackArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(leftMenuClick)];
}
- (void)leftMenuClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - 设置方法

- (void)setCalendarType:(DayTipsType)selectAirType andSelectDate:(NSDate *)selectDate andStartDate:(NSDate *)startDate
{
    optiondaynumber = 1;//选择一个后返回数据对象
    super.selectType = selectAirType;
    super.selectDate = selectDate;
    super.calendarMonth = [self getMonthArrayWithStartDate:[startDate stringFromDate:startDate] selectDate:[selectDate stringFromDate:selectDate]];
    [super.collectionView reloadData];
}

#pragma mark - 逻辑代码初始化

//获取时间段内的天数数组
-(NSMutableArray *)getMonthArrayWithStartDate:(NSString *)startDate selectDate:(NSString *)todate
{
    NSDate *date = [NSDate date];
    if(startDate)
    {
        date = [date dateFromString:startDate];
    }
    NSDate *selectdate  = [NSDate date];
    if (todate) {
        selectdate = [selectdate dateFromString:todate];
    }
    super.Logic = [[CalendarLogic alloc]init];
    return [super.Logic reloadCalendarView:date selectDate:selectdate withType:super.selectType];
}
@end
