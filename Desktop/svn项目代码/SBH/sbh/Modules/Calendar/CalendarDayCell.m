//
//  CalendarDayCell.m
//  tttttt
//
//  Created by 张凡 on 14-8-20.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CalendarDayCell.h"
#import "ColorUtility.h"

@implementation CalendarDayCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    
    //选中时显示的图片
    imgview = [[UIImageView alloc]initWithFrame:CGRectMake(5, 2, self.bounds.size.width-10, self.bounds.size.width-10)];
    [self addSubview:imgview];
    
    //日期
    day_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, self.bounds.size.width, self.bounds.size.width-10)];
    day_lab.textAlignment = NSTextAlignmentCenter;
    day_lab.font = [UIFont systemFontOfSize:14];
    [self addSubview:day_lab];

    //显示离店进店或者机票的日期
    day_title = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-13, self.bounds.size.width, 13)];
    day_title.font = [UIFont boldSystemFontOfSize:10];
    day_title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:day_title];
    
}


- (void)setModel:(CalendarDayModel *)model
{
    switch (model.style) {
        case CellDayTypeEmpty://不显示
        {
            self.backgroundColor = [UIColor clearColor];
            [self hidden_YES];
        }
            break;
            
        case CellDayTypePast://过去的日期
        {
            [self hidden_NO];
            self.backgroundColor = [UIColor clearColor];

            if (model.holiday)
            {
                day_lab.text = model.holiday;
            }
            else if (model.specialDay)
            {
                day_lab.text = model.specialDay;
            }
            else
            {
                day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            }
            day_lab.textColor = [UIColor lightGrayColor];
            day_title.text = @"";
            imgview.hidden = YES;
        }
            break;
            
        case CellDayTypeFutur://将来的日期
        { [self hidden_NO];
            self.backgroundColor = [UIColor clearColor];

            if (model.holiday) {
                day_lab.text = model.holiday;
                day_lab.textColor = [ColorConfigure globalBgColor];
            }else if (model.specialDay)
            {
                day_lab.text = model.specialDay;
                day_lab.textColor = [UIColor blackColor];
            }else{
                day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
                day_lab.textColor = [UIColor blackColor];
            }
            day_title.text = @"";
            imgview.hidden = YES;}
            break;
            
        case CellDayTypeWeek://周末
        {  [self hidden_NO];
            self.backgroundColor = [UIColor clearColor];

            if (model.holiday) {
                day_lab.text = model.holiday;
                day_lab.textColor = [ColorConfigure globalBgColor];
            }else if (model.specialDay)
            {
                day_lab.text = model.specialDay;
                day_lab.textColor = [UIColor blackColor];
            }else{
                day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
                day_lab.textColor = [UIColor blackColor];
            }
            day_title.text = @"";
            imgview.hidden = YES;
        }
            break;
            
        case CellDayTypeClick://被点击的日期
        {
            [self hidden_NO];
            if (model.holiday) {
                day_lab.text = model.holiday;
                
            }else if (model.specialDay)
            {
                day_lab.text = model.specialDay;
            }else{
                day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            }
            day_lab.textColor = [UIColor whiteColor];
            day_title.textColor = [UIColor whiteColor];
            self.backgroundColor = [ColorConfigure globalBgColor];
            imgview.hidden = YES;
            switch (model.modelType)
            {
                case DayTipsTypeAirStart:
                {
                    day_title.text = @"出发";
                }
                    break;
                case DayTipsTypeAirReturn:
                {
                    day_title.text = @"返回";
                }
                    break;
                case DayTipsTypeHotelStart:
                {
                    day_title.text = @"入住";
                }
                    break;
                case DayTipsTypeHotelLeave:
                {
                    day_title.text = @"离店";
                }
                    break;
                case DayTipsTypeTrainStart:
                {
                    day_title.text = @"出发";
                }
                    break;
                case DayTipsTypeMeetingStart:
                {
                    day_title.text = @"开始";
                }
                    break;
                case DayTipsTypeMeetingLeave:
                {
                    day_title.text = @"结束";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

- (void)hidden_YES
{
    day_lab.hidden = YES;
    day_title.hidden = YES;
    imgview.hidden = YES;
}
- (void)hidden_NO
{
    day_lab.hidden = NO;
    day_title.hidden = NO;
}
@end
