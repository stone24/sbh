//
//  kuanTableViewCell.m
//  SBHAPP
//
//  Created by musmile on 14-6-27.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "TicketReserveSelectDateCell.h"
#import "CommonMethod.h"
#import "NSDate+WQCalendarLogic.h"

@interface TicketReserveSelectDateCell()
{
    id _target;
    SEL _selectDepartureAction;
    SEL _selectReachAction;
}
@end
@implementation TicketReserveSelectDateCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"TicketReserveSelectDateIdentifier";
    TicketReserveSelectDateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[[NSBundle mainBundle] loadNibNamed:@"TicketReserveSelectDateCell" owner:nil options:nil] firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    return cell;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [_iLeftButton addTarget:self action:@selector(selectStartTime)
               forControlEvents:UIControlEventTouchUpInside];
    [_iRightButton addTarget:self action:@selector(selectArriveTime)
                forControlEvents:UIControlEventTouchUpInside];
}
- (void)selectStartTime
{
    [_target performSelector:_selectDepartureAction withObject:nil afterDelay:0];
}
- (void)selectArriveTime
{
     [_target performSelector:_selectReachAction withObject:nil afterDelay:0];
}
- (void)addTarget:(id)thisTarget andDepartureDateAction:(SEL)thisDepartureAction andReachDateAction:(SEL)thisReachAction
{
    _target = thisTarget;
    _selectDepartureAction = thisDepartureAction;
    _selectReachAction = thisReachAction;
}

- (void)setCellWith:(TicketOrderInfo *)item
{
    _iStartWeek.text = [item.iStartDate compareIfTodayWithDate];
    if([_iStartWeek.text isEqualToString:@"今天"]||[_iStartWeek.text isEqualToString:@"明天"]||[_iStartWeek.text isEqualToString:@"后天"])
    {
        _iStartWeek.textColor = [UIColor orangeColor];
    }
    [_iStartDate setText:[self getConfigureFormatWith:item.iStartDate]];
    
    _iArriveWeek.text = [item.iEndDate compareIfTodayWithDate];
    if([_iArriveWeek.text isEqualToString:@"今天"]||[_iArriveWeek.text isEqualToString:@"明天"]||[_iArriveWeek.text isEqualToString:@"后天"])
    {
        _iArriveWeek.textColor = [UIColor orangeColor];
    }
    [_iArriveDate setText:[self getConfigureFormatWith:item.iEndDate]];
    if(item.ticketBookType == kOneWayTicketType)
    {
        [self setEndModulesHideWith:YES];
    }
    else if (item.ticketBookType == kRoundTripTicketType)
    {
        [self setEndModulesHideWith:NO];
    }
}
- (void)setEndModulesHideWith:(BOOL)isHidden
{
    _iRightLabel.hidden = isHidden;
    _iRightButton.hidden = isHidden;
    _iArriveWeek.hidden = isHidden;
    _iArriveDate.hidden = isHidden;
}
- (NSString *)getConfigureFormatWith:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
@end
