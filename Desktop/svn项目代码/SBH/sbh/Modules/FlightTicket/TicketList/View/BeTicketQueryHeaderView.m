//
//  BeTicketQueryHeaderView.m
//  sbh
//
//  Created by RobinLiu on 15/4/17.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTicketQueryHeaderView.h"
#import "ColorUtility.h"
#import "NSDate+WQCalendarLogic.h"

#define kTicketQueryHeaderBgColor [ColorUtility colorWithRed:242 green:242 blue:242]
#define kTicketQueryHeaderImageLeft @"hblb_qhrq_zuo"
#define kTicketQueryHeaderImageRight @"hblb_qhrq_you"
#define kTicketQueryHeaderButtonWidth 50

#define kTicketQueryHeaderUnableLeftImage @"unableLeft_image"
#define kTicketQueryHeaderUnableRightImage @"unableRight_image"

@interface BeTicketQueryHeaderView()
{
    id _target;
    SEL _beforeAction;
    SEL _afterAction;
    UIImageView *beforeImage;
    UIButton *beforeButton;
    UIImageView *afterImage;
    UIButton *afterButton;
}
@end
@implementation BeTicketQueryHeaderView

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
        self.backgroundColor = kTicketQueryHeaderBgColor;
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        beforeImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:kTicketQueryHeaderImageLeft]];
        beforeImage.center = CGPointMake(15, kTicketQueryHeaderHeight/2);
        [self addSubview:beforeImage];
        beforeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [beforeButton addTarget:self action:@selector(clickBefore) forControlEvents:UIControlEventTouchUpInside];
        beforeButton.frame = CGRectMake(0, 0, kTicketQueryHeaderButtonWidth, frame.size.height);
        [self addSubview:beforeButton];
        
        afterImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:kTicketQueryHeaderImageRight]];
        afterImage.center = CGPointMake(frame.size.width - 15, kTicketQueryHeaderHeight/2);
        [self addSubview:afterImage];
        afterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [afterButton addTarget:self action:@selector(clickAfter) forControlEvents:UIControlEventTouchUpInside];
        afterButton.frame = CGRectMake(frame.size.width - kTicketQueryHeaderButtonWidth, 0,kTicketQueryHeaderButtonWidth, frame.size.height);
        [self addSubview:afterButton];
    }
    return self;
}
- (void)clickBefore
{
    [_target performSelector:_beforeAction withObject:nil afterDelay:0];
}
- (void)clickAfter
{
    [_target performSelector:_afterAction withObject:nil afterDelay:0];
}
- (void)addTarget:(id)target andBeforeAction:(SEL)beforeAction andAfterAction:(SEL)afterAction
{
    _target = target;
    _beforeAction = beforeAction;
    _afterAction = afterAction;
}
- (void)updateUIWithItem:(id)thisItem
{
    if([thisItem isKindOfClass:[TicketOrderInfo class]])
    {
        TicketOrderInfo *item = (TicketOrderInfo *)thisItem;
        if([[item.iStartDate compareIfTodayWithDate] isEqualToString:@"今天"])
        {
            beforeButton.userInteractionEnabled = NO;
            beforeImage.image = [UIImage imageNamed:kTicketQueryHeaderUnableLeftImage];
        }
        else
        {
            beforeButton.userInteractionEnabled = YES;
            beforeImage.image = [UIImage imageNamed:kTicketQueryHeaderImageLeft];
        }
        if(item.tripType == kAirTripTypeGoing)
        {
            _titleLabel.text = [NSString stringWithFormat:@"%@ 星期%@",item.iStartTime,[CommonMethod getWeekDayFromDate:item.iStartDate]];
        }
        else if(item.tripType == kAirTripTypeReturn)
        {
            _titleLabel.text = [NSString stringWithFormat:@"%@ 星期%@",item.iEndTime,[CommonMethod getWeekDayFromDate:item.iEndDate]];
        }
    }
    if([thisItem isKindOfClass:[BeTrainTicketInquireItem class]])
    {
        BeTrainTicketInquireItem *item = (BeTrainTicketInquireItem *)thisItem;
        if([self isRightButtonEnableWithItem:item])
        {
            afterImage.image = [UIImage imageNamed:kTicketQueryHeaderImageRight];
            afterButton.enabled = YES;
        }
        else
        {
            afterImage.image = [UIImage imageNamed:kTicketQueryHeaderUnableRightImage];
            afterButton.enabled = NO;
        };
        if([[[CommonMethod dateFromString:item.startDateStr WithParseStr:@"yyyy-MM-dd"] compareIfTodayWithDate] isEqualToString:@"今天"])
        {
            beforeButton.userInteractionEnabled = NO;
            beforeImage.image = [UIImage imageNamed:kTicketQueryHeaderUnableLeftImage];
        }
        else
        {
            beforeButton.userInteractionEnabled = YES;
            beforeImage.image = [UIImage imageNamed:kTicketQueryHeaderImageLeft];
        }
        NSDate *weekDate =[CommonMethod dateFromString:item.startDateStr WithParseStr:@"yyyy-MM-dd"];
        _titleLabel.text = [NSString stringWithFormat:@"%@ 星期%@",item.startDateStr,[CommonMethod getWeekDayFromDate:weekDate]];
    }
}
- (BOOL)isRightButtonEnableWithItem:(BeTrainTicketInquireItem *)item
{
    NSTimeInterval time=[item.startDate timeIntervalSinceDate:[NSDate date]];
    int days = ((int)time)/(3600*24);
    if(days < 58)
    {
        return YES;
    }
    return NO;
}
@end
