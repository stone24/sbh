//
//  YUdingTableViewCell.m
//  SBHAPP
//
//  Created by musmile on 14-6-22.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "TicketReserveSelectCityCell.h"
#import "TicketOrderInfo.h"
#import "BeTrainTicketInquireItem.h"

#define kTRSCityCellExchangeBtnNormalIg @"chengshiqiehuan"
#define kTRSCityCellExchangeBtnHighlightIg @"chengshiqiehuan_A"

@interface TicketReserveSelectCityCell()
{
    id _target;
    SEL _departureAction;
    SEL _reachAction;
    SEL _overturnAction;
    BOOL isOverTurned;
}
@end
@implementation TicketReserveSelectCityCell
+ (CGFloat)cellHeight
{
    return 84;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"YUdingTableViewCellIdentifier";
    TicketReserveSelectCityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[[NSBundle mainBundle] loadNibNamed:@"TicketReserveSelectCityCell" owner:nil options:nil] firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    return cell;
}
- (void)setCellWith:(id )item
{
    [self.exchangeBtnClick setBackgroundImage:[UIImage imageNamed:kTRSCityCellExchangeBtnHighlightIg] forState:UIControlStateHighlighted];
    [self.exchangeBtnClick setBackgroundImage:[UIImage imageNamed:kTRSCityCellExchangeBtnNormalIg] forState:UIControlStateNormal];
    [self.chuchenBtn addTarget:self action:@selector(beijingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.daodaBtn addTarget:self action:@selector(daodachengshiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.exchangeBtnClick addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];
    //TicketOrderInfo
    if([item isKindOfClass:[TicketOrderInfo class]])
    {
        TicketOrderInfo *ticketItem =(TicketOrderInfo *)item;
        [self.beijing setTitle:ticketItem.iFromCityName forState:UIControlStateNormal];
        [self.daodachengshi setTitle:ticketItem.iToCityName forState:UIControlStateNormal];
    }
    else if ([item isKindOfClass:[BeTrainTicketInquireItem class]])
    {
        BeTrainTicketInquireItem *ticketItem =(BeTrainTicketInquireItem *)item;
        [self.beijing setTitle:ticketItem.fromTrainStation forState:UIControlStateNormal];
        [self.daodachengshi setTitle:ticketItem.toTrainStation forState:UIControlStateNormal];
    }
}
- (void)beijingBtnClick
{
    [_target performSelector:_departureAction withObject:nil afterDelay:0];
}
- (void)daodachengshiBtnClick
{
    [_target performSelector:_reachAction withObject:nil afterDelay:0];
}
- (void)exchange
{
    [self overturnAnimation];
    [_target performSelector:_overturnAction withObject:nil afterDelay:0];
}
- (void)addTarget:(id)thisTarget andDepartureAction:(SEL)thisDepartureAction andReachAction:(SEL)thisReachAction andOverturnAction:(SEL)thisOverturnAction
{
    _target = thisTarget;
    _departureAction = thisDepartureAction;
    _reachAction = thisReachAction;
    _overturnAction = thisOverturnAction;
}
- (void)overturnAnimation
{
    [UIView beginAnimations:@"OverTurnAnimation" context:NULL];
    [UIView setAnimationDuration:0.45];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if(isOverTurned == NO)
    {
        self.beijing.x = kScreenWidth - 15 - self.beijing.width;
        self.daodachengshi.x = 15.0f;
        self.exchangeBtnClick.transform = CGAffineTransformMakeRotation(-M_PI);
    }
    else
    {
        self.daodachengshi.x = kScreenWidth - 15 - self.daodachengshi.width;
        self.beijing.x = 15.0f;
        self.exchangeBtnClick.transform = CGAffineTransformMakeRotation(0);
    }
    [UIView commitAnimations];
    isOverTurned = !isOverTurned;
}
@end
