//
//  SBHPayHeaderView.m
//  sbh
//
//  Created by SBH on 14-12-27.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "BeFlightOrderPaymentHeaderView.h"
#import "NSDate+WQCalendarLogic.h"
#import "ColorUtility.h"
#import "BeCommonUI.h"

#define kHeaderViewX 10
#define kVerticalSpace 10

@interface BeFlightOrderPaymentHeaderView ()
{
    UILabel *titleLabel;
    id _target;
    SEL _action1;
    SEL _action2;
}
@end

@implementation BeFlightOrderPaymentHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [ColorUtility colorWithRed:240 green:240 blue:240];
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kHeaderViewX, 10, kScreenWidth - kHeaderViewX * 2.0, 50)];
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = [ColorUtility colorWithRed:153 green:153 blue:153];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:titleLabel];
        
        UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(0, 70, kScreenWidth, 0.6)];
        sepLine.backgroundColor = [ColorUtility colorWithRed:205 green:205 blue:205];
        [self addSubview:sepLine];
    }
    return self;
}
- (void)setModel:(BeOrderInfoModel *)model
{
    _model = model;
    
    //起始地、目的地
    UILabel *citysLabel = [BeCommonUI labelWithFrame:CGRectMake(kHeaderViewX, 87, kScreenWidth - kHeaderViewX, 20) andTitle:@"" andFont:[UIFont boldSystemFontOfSize:16] andColor:[ColorUtility colorWithRed:35 green:35 blue:35]];
    BeFlightModel *flightModel = self.model.airorderflights.firstObject;
    NSString *str1 = [NSString stringWithFormat:@"%@ ",flightModel.boardcityname];
    NSString *str2 = [NSString stringWithFormat:@" %@",flightModel.offcityname];
    NSMutableAttributedString *attibutedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = self.model.airorderflights.count > 1 ?[UIImage imageNamed:@"ddlb_wangfanJiantouIcon"]: [UIImage imageNamed:@"ddlb_jiantouIcon"];
    attach.bounds = CGRectMake(0, 1.5, attach.image.size.width, attach.image.size.height);
    NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
    [attibutedString insertAttributedString:attachString atIndex:[str1 length]];
    citysLabel.attributedText = attibutedString;
    [self addSubview:citysLabel];

    //订单号
    UILabel *orderNoLabel = [BeCommonUI labelWithFrame:CGRectMake(0, citysLabel.y, kScreenWidth - kHeaderViewX, 20) andTitle:[NSString stringWithFormat:@"订单号:%@", self.model.orderno] andFont:[UIFont systemFontOfSize:14] andColor:[ColorUtility colorWithRed:19 green:142 blue:234]];
    orderNoLabel.centerY = citysLabel.centerY;
    orderNoLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:orderNoLabel];
    
    CGFloat maxY = CGRectGetMaxY(citysLabel.frame) + kVerticalSpace;
    
    for(int i = 0;i <self.model.airorderflights.count;i++)
    {
        BeFlightModel *flightModel = self.model.airorderflights[i];
        NSMutableString *flightNumString = [[NSMutableString alloc]initWithString:flightModel.flightno];
        if(flightModel.aircraftcode != nil && flightModel.aircraftcode.length > 0)
        {
            [flightNumString insertString:[NSString stringWithFormat:@" | %@",flightModel.aircraftcode] atIndex:[flightModel.flightno length]];
        }
        if(self.model.airorderflights.count > 1)
        {
            if(i == 0)
            {
                [flightNumString insertString:@"去程:" atIndex:0];
            }
            else
            {
                [flightNumString insertString:@"返程:" atIndex:0];
            }
        }
        
        NSDate *goDate = [[NSDate date] dateFromString:flightModel.fltdate];
        NSString *dateString = [NSString stringWithFormat:@"%@ 星期%@", flightModel.fltdate, [CommonMethod getWeekDayFromDate:goDate]];

        UILabel *flightLabel = [BeCommonUI labelWithFrame:CGRectMake(kHeaderViewX, maxY, kScreenWidth, 20) andTitle:flightNumString andFont:[UIFont systemFontOfSize:14] andColor:citysLabel.textColor];
        [self addSubview:flightLabel];

        UILabel *dateLabel = [BeCommonUI labelWithFrame:CGRectMake(0, 0, kScreenWidth - kHeaderViewX, 20) andTitle:dateString andFont:[UIFont systemFontOfSize:14] andColor:[ColorUtility colorWithRed:91 green:91 blue:91]];
        dateLabel.centerY = flightLabel.centerY;
        dateLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:dateLabel];
        
        maxY = CGRectGetMaxY(flightLabel.frame) + kVerticalSpace;
        
        UIButton *button = [BeCommonUI buttonWithFrame:CGRectMake(10, maxY, 100, 15) andTitle:@"退改规则" andFont:[UIFont systemFontOfSize:13] andTarget:self andAction:@selector(ruleAction:)];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitleColor:[ColorConfigure globalBgColor] forState:UIControlStateNormal];
        button.tag = i;
        [self addSubview:button];
        maxY = CGRectGetMaxY(button.frame) + kVerticalSpace;
    }
    UILabel *priceDetail = [BeCommonUI labelWithFrame:CGRectMake(kHeaderViewX, maxY, kScreenWidth - kHeaderViewX, 20) andTitle:self.model.sumDetailStr andFont:kAirTicketPriceDetailFont andColor:SBHYellowColor];
    [self addSubview:priceDetail];
    
    maxY = CGRectGetMaxY(priceDetail.frame) + kVerticalSpace;
    self.height = maxY;
}
- (void)ruleAction:(UIButton *)sender
{
    if(sender.tag == 0)
    {
        [_target performSelector:_action1 withObject:nil afterDelay:0.001];
    }
    else
    {
        [_target performSelector:_action2 withObject:nil afterDelay:0.001];
    }
}
- (void)addTarget:(id)target andQuchengRuleAction:(SEL)action1 andFanchengRule:(SEL)action2
{
    _target = target;
    _action1 = action1;
    _action2 = action2;
}
- (void)setCountDownLabelWithMinute:(NSString *)minute andSecond:(NSString *)second
{
    NSString *string = [NSString stringWithFormat:@"为确保出票,请在%@:%@内完成支付,逾期将自动取消订单。以免机票售完或价格变化,给您的出行带来不便。", minute, second];
    NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:string];
    [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange(8, 5)];
    [attrib addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:19] range:NSMakeRange(8, 5)];
    titleLabel.attributedText = attrib;
}
@end
