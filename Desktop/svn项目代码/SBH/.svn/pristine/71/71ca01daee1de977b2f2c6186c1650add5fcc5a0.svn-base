//
//  BeTrainListTabbar.m
//  sbh
//
//  Created by RobinLiu on 15/6/15.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTrainListTabbar.h"
#import "CommonDefine.h"
#import "ColorUtility.h"
#import "ColorConfigure.h"

#define kTrainListFilterTitle @"筛选"
#define kTrainListTimeTitle @"时间"
#define kTrainListPriceTitle @"价格"
#define kTrainListDurationTitle @"历时"

#define kTrainListFilterNormalImage @"chaxun_tb_4"
#define kTrainListFilterHighlightImage @"chaxun_tb_5"
#define kTrainListDownHighlightImage @"chaxun_tb_6"
#define kTrainListUpHighlightImage @"chaxun_tb_6up"
#define kTrainListDownNormalImage @"chaxun_tb_7"
#define kTrainListUpNormalImage @"chaxun_tb_7up"

#define kTicketQueryFont 15
#define kTicketQuerySpace 2

@interface BeTrainListTabbar()
{
    id _target;
    SEL _filterAction;
    SEL _timeAction;
    SEL _priceAction;
    SEL _durationAction;
    UIButton *filterButton;
    UIButton *timeButton;
    UIButton *priceButton;
    UIButton *durationButton;
    UILabel *filterLabel;
    UILabel *timeLabel;
    UILabel *priceLabel;
    UILabel *durationLabel;
    UIImageView *filterImageView;
    UIImageView *timeImageView;
    UIImageView *priceImageView;
    UIImageView *durationImageView;
}
@end
@implementation BeTrainListTabbar

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self customView];
    }
    return self;
}
- (void)customView
{
    self.backgroundColor = [ColorUtility colorFromHex:0xe8edf1];
    UIImage *filterImage = [UIImage imageNamed:kTrainListFilterNormalImage];
    UIImage *otherImage = [UIImage imageNamed:kTrainListDownNormalImage];
    
    //filter
    filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame = CGRectMake(0, 0, kScreenWidth/4.0, kTrainListTabbarHeight);
    [filterButton addTarget:_target action:@selector(ticketQueryFilter) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:filterButton];
    filterImageView = [[UIImageView alloc]initWithImage:filterImage];
    [filterButton addSubview:filterImageView];
    filterImageView.centerX = filterButton.width/2+18;
    filterImageView.centerY = filterButton.height/2.0;
    filterLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    filterLabel.text = kTrainListFilterTitle;
    filterLabel.font = [UIFont systemFontOfSize:kTicketQueryFont];
    filterLabel.textColor = [UIColor grayColor];
    filterLabel.textAlignment = NSTextAlignmentCenter;
    [filterButton addSubview:filterLabel];
    filterLabel.centerX = filterButton.width/2-5;
    filterLabel.centerY = filterButton.height/2.0;
    
    //time
    timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    timeButton.frame = CGRectMake(kScreenWidth/4.0, 0, kScreenWidth/4.0, kTrainListTabbarHeight);
    [timeButton addTarget:_target action:@selector(ticketQueryTime) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:timeButton];
    timeImageView = [[UIImageView alloc]initWithImage:otherImage];
    [timeButton addSubview:timeImageView];
    timeImageView.centerX = timeButton.width/2+18;
    timeImageView.centerY = timeButton.height/2.0;
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    timeLabel.textColor = [UIColor grayColor];

    timeLabel.text = kTrainListTimeTitle;
    timeLabel.font = [UIFont systemFontOfSize:kTicketQueryFont];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [timeButton addSubview:timeLabel];
    timeLabel.centerX = timeButton.width/2-5;
    timeLabel.centerY = timeButton.height/2.0;
    
    //duration
    durationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    durationButton.frame = CGRectMake(kScreenWidth/2.0, 0, kScreenWidth/4.0, kTrainListTabbarHeight);
    [durationButton addTarget:_target action:@selector(ticketQueryDuration) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:durationButton];
    durationImageView = [[UIImageView alloc]initWithImage:otherImage];
    [durationButton addSubview:durationImageView];
    durationImageView.centerX = durationButton.width/2+18;
    durationImageView.centerY = durationButton.height/2.0;
    durationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    durationLabel.text = kTrainListDurationTitle;
    durationLabel.textColor = [UIColor grayColor];
    durationLabel.font = [UIFont systemFontOfSize:kTicketQueryFont];
    durationLabel.textAlignment = NSTextAlignmentCenter;
    [durationButton addSubview:durationLabel];
    durationLabel.centerX = durationButton.width/2-5;
    durationLabel.centerY = durationButton.height/2.0;
    
    //price
    priceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    priceButton.frame = CGRectMake(kScreenWidth * 0.75, 0, kScreenWidth/4.0, kTrainListTabbarHeight);
    [priceButton addTarget:_target action:@selector(ticketQueryPrice) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:priceButton];
    priceImageView = [[UIImageView alloc]initWithImage:otherImage];
    [priceButton addSubview:priceImageView];
    priceImageView.centerX = priceButton.width/2+18;
    priceImageView.centerY = priceButton.height/2.0;
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    priceLabel.text = kTrainListPriceTitle;
    priceLabel.font = [UIFont systemFontOfSize:kTicketQueryFont];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.textColor = [UIColor grayColor];

    [priceButton addSubview:priceLabel];
    priceLabel.centerX = priceButton.width/2-5;
    priceLabel.centerY = priceButton.height/2.0;
}
- (void)ticketQueryDuration
{
     [_target performSelector:_durationAction withObject:nil afterDelay:0];
}
- (void)ticketQueryFilter
{
    [_target performSelector:_filterAction withObject:nil afterDelay:0];
}
- (void)ticketQueryTime
{
    [_target performSelector:_timeAction withObject:nil afterDelay:0];
}
- (void)ticketQueryPrice
{
    [_target performSelector:_priceAction withObject:nil afterDelay:0];
}
- (void)addTarget:(id)target andFilterAction:(SEL)filterAction andTimeAction:(SEL)timeAction andPriceAction:(SEL)priceAction andDurationAction:(SEL)durationAction
{
    _target = target;
    _filterAction = filterAction;
    _timeAction = timeAction;
    _priceAction = priceAction;
    _durationAction = durationAction;
}

- (void)updateTimeUIWith:(BeTrainResultItem *)item
{
    if(item.timeUp)
    {
        timeImageView.image = [UIImage imageNamed:kTrainListUpHighlightImage];
        
    }
    else
    {
        timeImageView.image = [UIImage imageNamed:kTrainListDownHighlightImage];
    }
    filterLabel.textColor = [UIColor grayColor];
    timeLabel.textColor = [ColorConfigure globalBgColor];
    priceLabel.textColor = [UIColor grayColor];
    durationLabel.textColor = [UIColor grayColor];
    priceImageView.image = [UIImage imageNamed:kTrainListDownNormalImage];
    durationImageView.image = [UIImage imageNamed:kTrainListDownNormalImage];
}
- (void)updatePriceUIWith:(BeTrainResultItem *)item
{
    if(item.priceUp)
    {
        priceImageView.image = [UIImage imageNamed:kTrainListUpHighlightImage];
    }
    else
    {
        priceImageView.image = [UIImage imageNamed:kTrainListDownHighlightImage];
    }
    filterLabel.textColor = [UIColor grayColor];
    timeLabel.textColor = [UIColor grayColor];
    priceLabel.textColor = [ColorConfigure globalBgColor];
    durationLabel.textColor = [UIColor grayColor];
    timeImageView.image = [UIImage imageNamed:kTrainListDownNormalImage];
    durationImageView.image = [UIImage imageNamed:kTrainListDownNormalImage];
}
- (void)updateFilterUIWith:(BeTrainResultItem *)item
{
    if(item.isFilter)
    {
        filterImageView.image = [UIImage imageNamed:kTrainListFilterHighlightImage];
    }
    else
    {
        filterImageView.image = [UIImage imageNamed:kTrainListFilterNormalImage];
    }
    filterLabel.textColor = [ColorConfigure globalBgColor];
    timeLabel.textColor = [UIColor grayColor];
    priceLabel.textColor = [UIColor grayColor];
    durationLabel.textColor = [UIColor grayColor];
    timeImageView.image = [UIImage imageNamed:kTrainListDownNormalImage];
    durationImageView.image = [UIImage imageNamed:kTrainListDownNormalImage];
    priceImageView.image = [UIImage imageNamed:kTrainListDownNormalImage];
}
- (void)updateDurationUIWith:(BeTrainResultItem *)item
{
    durationLabel.textColor = [ColorConfigure globalBgColor];
    if(item.isDuration)
    {
        durationImageView.image = [UIImage imageNamed:kTrainListUpHighlightImage];
    }
    else
    {
        durationImageView.image = [UIImage imageNamed:kTrainListDownHighlightImage];
    }
    filterLabel.textColor = [UIColor grayColor];
    timeLabel.textColor = [UIColor grayColor];
    priceLabel.textColor = [UIColor grayColor];
    timeImageView.image = [UIImage imageNamed:kTrainListDownNormalImage];
    priceImageView.image = [UIImage imageNamed:kTrainListDownNormalImage];
}
@end