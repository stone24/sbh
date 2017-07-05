//
//  BeTicketInqueryTabbar.m
//  sbh
//
//  Created by RobinLiu on 15/4/15.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTicketQueryTabbar.h"

#define kTicketQueryFilterTitle @"筛选"
#define kTicketQueryTimeTitle @"时间"
#define kTicketQueryPriceTitle @"价格"

#define kTicketQueryFilterNormalImage @"chaxun_tb_4"
#define kTicketQueryFilterHighlightImage @"chaxun_tb_5"
#define kTicketQueryDownHighlightImage @"chaxun_tb_6"
#define kTicketQueryUpHighlightImage @"chaxun_tb_6up"
#define kTicketQueryDownNormalImage @"chaxun_tb_7"
#define kTicketQueryUpNormalImage @"chaxun_tb_7up"
#define kTicketQueryWidth (CGRectGetWidth([UIApplication sharedApplication].keyWindow.bounds))
#define kTicketQueryFont 15
#define kTicketQuerySpace 2

@interface BeTicketQueryTabbar()
{
    id _target;
    SEL _filterAction;
    SEL _timeAction;
    SEL _priceAction;
    UIButton *filterButton;
    UIButton *timeButton;
    UIButton *priceButton;
    UILabel *filterLabel;
    UILabel *timeLabel;
    UILabel *priceLabel;
    UIImageView *filterImageView;
    UIImageView *timeImageView;
    UIImageView *priceImageView;
}
@end
@implementation BeTicketQueryTabbar

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
        [self customView];
    }
    return self;
}
- (void)customView
{
    UIImage *filterImage = [UIImage imageNamed:kTicketQueryFilterNormalImage];
    UIImage *timeImage = [UIImage imageNamed:kTicketQueryDownNormalImage];
    UIImage *priceImage = [UIImage imageNamed:kTicketQueryDownNormalImage];
    
    CGFloat filterLabelWidth = [self getTextWidth:kTicketQueryFilterTitle];
    CGFloat filterLabelOriginX = (kTicketQueryWidth/3 - filterLabelWidth - filterImage.size.width - kTicketQuerySpace)/2;
    
    filterLabel = [[UILabel alloc]initWithFrame:CGRectMake(filterLabelOriginX, 0, filterLabelWidth, kTicketQueryTabbarHeight)];
    filterLabel.text = kTicketQueryFilterTitle;
    filterLabel.font = [UIFont systemFontOfSize:kTicketQueryFont];
    filterLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:filterLabel];
    
    filterImageView = [[UIImageView alloc]initWithImage:filterImage];
    filterImageView.size = filterImage.size;
    filterImageView.frame = CGRectMake(filterLabelOriginX + filterLabelWidth + kTicketQuerySpace, 0, filterImage.size.width, filterImage.size.height);
    filterImageView.centerY = kTicketQueryTabbarHeight/2;
    [self addSubview:filterImageView];
    
    CGFloat timeLabelWidth = [self getTextWidth:kTicketQueryTimeTitle];
    CGFloat timeLabelOriginX = (kTicketQueryWidth/3 - timeLabelWidth - timeImage.size.width - kTicketQuerySpace)/2 + kTicketQueryWidth/3;
    
    timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    timeLabel.text = kTicketQueryTimeTitle;
    timeLabel.font = [UIFont systemFontOfSize:kTicketQueryFont];
    timeLabel.frame = CGRectMake( timeLabelOriginX,0, timeLabelWidth, kTicketQueryTabbarHeight);
    [self addSubview:timeLabel];
    
    timeImageView = [[UIImageView alloc]initWithImage:timeImage];
    timeImageView.frame = CGRectMake(timeLabelOriginX + timeLabelWidth + kTicketQuerySpace, 0, timeImage.size.width, timeImage.size.height);
    timeImageView.size = timeImage.size;
    timeImageView.centerY = kTicketQueryTabbarHeight/2;
    [self addSubview:timeImageView];
    
    CGFloat priceLabelWidth = [self getTextWidth:kTicketQueryPriceTitle];
    CGFloat priceLabelOriginX = (kTicketQueryWidth/3 - priceLabelWidth - priceImage.size.width - kTicketQuerySpace)/2 + (kTicketQueryWidth/3)*2;
    
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(priceLabelOriginX, 0, priceLabelWidth, kTicketQueryTabbarHeight)];
    priceLabel.text = kTicketQueryPriceTitle;
    priceLabel.font = [UIFont systemFontOfSize:kTicketQueryFont];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:priceLabel];
    
    priceImageView = [[UIImageView alloc]initWithImage:priceImage];
    priceImageView.size = priceImage.size;
    priceImageView.frame = CGRectMake(priceLabelOriginX + priceLabelWidth + kTicketQuerySpace, 0, priceImage.size.width, priceImage.size.height);
    priceImageView.centerY = kTicketQueryTabbarHeight/2;
    [self addSubview:priceImageView];
    
    filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame = CGRectMake(0, 0, kTicketQueryWidth/3, kTicketQueryTabbarHeight);
    [filterButton addTarget:_target action:@selector(ticketQueryFilter) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:filterButton];
    
    timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    timeButton.frame = CGRectMake(kTicketQueryWidth/3, 0, kTicketQueryWidth/3, kTicketQueryTabbarHeight);
    [timeButton addTarget:_target action:@selector(ticketQueryTime) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:timeButton];
    
    priceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    priceButton.frame = CGRectMake(kTicketQueryWidth - kTicketQueryWidth/3, 0, kTicketQueryWidth/3, kTicketQueryTabbarHeight);
    [priceButton addTarget:_target action:@selector(ticketQueryPrice) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:priceButton];
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
- (void)addTarget:(id)target andFilterAction:(SEL)filterAction andTimeAction:(SEL)timeAction andPriceAction:(SEL)priceAction
{
    _target = target;
    _filterAction = filterAction;
    _timeAction = timeAction;
    _priceAction = priceAction;
}
- (CGFloat)getTextWidth:(NSString *)text
{
    CGRect textSize = [text boundingRectWithSize:CGSizeMake(kTicketQueryWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kTicketQueryFont]} context:nil];
    return textSize.size.width + kTicketQueryFont;
}
- (void)updateTimeUIWith:(BeTicketQueryListData *)item
{
    priceImageView.image = [UIImage imageNamed:kTicketQueryDownNormalImage];
    if(item.timeUp)
    {
        timeImageView.image = [UIImage imageNamed:kTicketQueryUpHighlightImage];
    }
    else
    {
        timeImageView.image = [UIImage imageNamed:kTicketQueryDownHighlightImage];
    }
}
- (void)updatePriceUIWith:(BeTicketQueryListData *)item
{
    timeImageView.image = [UIImage imageNamed:kTicketQueryDownNormalImage];
    if (item.priceUp) {
        priceImageView.image = [UIImage imageNamed:kTicketQueryUpHighlightImage];
    }
    else
    {
        priceImageView.image = [UIImage imageNamed:kTicketQueryDownHighlightImage];
    }
}
- (void)updateFilterUIWith:(BeTicketQueryListData *)item
{
    if(item.isFilter)
    {
        filterImageView.image = [UIImage imageNamed:kTicketQueryFilterHighlightImage];
    }
    else
    {
        filterImageView.image = [UIImage imageNamed:kTicketQueryFilterNormalImage];
    }
}
@end
