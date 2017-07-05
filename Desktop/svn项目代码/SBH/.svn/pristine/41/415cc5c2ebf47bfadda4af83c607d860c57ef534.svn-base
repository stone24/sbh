//
//  BeTicketQuerySelectHeaderView.m
//  sbh
//
//  Created by RobinLiu on 15/4/20.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTicketQuerySelectHeaderView.h"
#import "ColorUtility.h"

@interface BeTicketQuerySelectHeaderView()
{
    UILabel *hasSelectLabel;
    
}
@end
@implementation BeTicketQuerySelectHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        hasSelectLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 80, 20)];
        hasSelectLabel.text = @"已选去程";
        hasSelectLabel.font = [UIFont systemFontOfSize:16];
        hasSelectLabel.textColor = [ColorUtility colorWithRed:78 green:78 blue:78];
        [self addSubview:hasSelectLabel];
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 36, 150, 15)];
        _dateLabel.textColor = [ColorUtility colorWithRed:137 green:137 blue:137];
        _dateLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_dateLabel];
        _flightNOLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width-150-20, 10, 150, 20)];
        _flightNOLabel.textColor = [ColorUtility colorWithRed:78 green:78 blue:78];
        _flightNOLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_flightNOLabel];
        _flightDurationLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width-150-20, 36, 150, 15)];
        _flightDurationLabel.textColor = [ColorUtility colorWithRed:137 green:137 blue:137];
        _flightDurationLabel.font = [UIFont systemFontOfSize:13];;
        [self addSubview:_flightDurationLabel];
        UIImageView *sepIg = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, 1)];
        sepIg.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:sepIg];
    }
    return self;
}
- (void)setItem:(TicketOrderInfo *)item
{
   // flightDurationLabel.text = [NSString stringWithFormat:@"%@-%@",self.GcomeTime, self.GreachTime];
    NSString *dateStr = item.iStartTime;
    dateStr = [dateStr substringFromIndex:5];
    _dateLabel.text = dateStr;
    _flightNOLabel.text = [GlobalData getSharedInstance].FLIGHTNORT;
}
@end
