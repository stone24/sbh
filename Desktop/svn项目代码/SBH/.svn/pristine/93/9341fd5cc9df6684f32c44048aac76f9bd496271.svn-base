//
//  BeTrainSelectDateCell.m
//  sbh
//
//  Created by RobinLiu on 15/6/15.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTrainSelectDateCell.h"
#import "ColorUtility.h"
#import "ColorConfigure.h"
#import "NSDate+WQCalendarLogic.h"
#import "CommonDefine.h"

@implementation BeTrainSelectDateCell
+ (CGFloat)cellheight
{
    return 60.0f;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeTrainSelectDateCellIdentifier";
    BeTrainSelectDateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeTrainSelectDateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    [cell setCellSubViews];
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}
- (void)setCellSubViews
{
    UILabel *startLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 20)];
    startLabel.centerY = 60.0/2.0f;
    startLabel.font = [UIFont systemFontOfSize:17];
    startLabel.text = @"出发日期";
    startLabel.textColor = [ColorUtility colorWithRed:100 green:100 blue:100];
    [self addSubview:startLabel];
    
    dateLabel  = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 100, 25)];
    dateLabel.font = [UIFont systemFontOfSize:22];
    dateLabel.centerY = 60.0/2.0f;
    dateLabel.text = @"17/6";
    dateLabel.textColor = [ColorUtility colorWithRed:100 green:100 blue:100];
    [self addSubview:dateLabel];
    
    detailLabel  = [[UILabel alloc]initWithFrame:CGRectMake(180, 0, 100, 20)];
    detailLabel.centerY = 60.0/2.0f;
    detailLabel.font = [UIFont systemFontOfSize:17];
    detailLabel.text = @"明天";
    detailLabel.textColor = [ColorConfigure loginButtonColor];
    [self addSubview:detailLabel];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCellWith:(NSDate *)date
{
    NSString *weekString = [date compareIfTodayWithDate];
    if ([weekString isEqualToString:@"今天"]||[weekString isEqualToString:@"明天"]||[weekString isEqualToString:@"后天"]) {
        detailLabel.text = weekString;
        detailLabel.textColor = [ColorConfigure loginButtonColor];
        dateLabel.text = [self getDayStringWith:date];
    }
    else
    {
        dateLabel.text = [self getDayStringWith:date];
        detailLabel.textColor = [UIColor blackColor];
        detailLabel.text = [NSString stringWithFormat:@"星期%@",[CommonMethod getWeekDayFromDate:date]];
    }
}
- (NSString *)getDayStringWith:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
- (int)getStayDaysWith:(NSDate *)startDate andLeaveDate:(NSDate *)leaveDate
{
    NSTimeInterval time=[leaveDate timeIntervalSinceDate:startDate];
    int days = ((int)time)/(3600*24);
    return days;
}
@end
