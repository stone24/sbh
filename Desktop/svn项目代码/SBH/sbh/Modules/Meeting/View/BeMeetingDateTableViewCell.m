
//
//  BeMeetingDateTableViewCell.m
//  sbh
//
//  Created by RobinLiu on 16/6/21.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeMeetingDateTableViewCell.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "CommonDefine.h"

@interface BeMeetingDateTableViewCell ()
@property (strong, nonatomic) UILabel *startDateLabel;
@property (strong, nonatomic) UILabel *startWeekLabel;
@property (strong, nonatomic) UILabel *stayDaysLabel;
@property (strong, nonatomic) UILabel *leaveDateLabel;
@property (strong, nonatomic) UILabel *leaveWeekLabel;
@end
@implementation BeMeetingDateTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeMeetingDateTableViewCellIdentifier";
    BeMeetingDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeMeetingDateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 62, 20)];
        nameLabel.centerY = 22.0;
        nameLabel.text = @"时间";
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textColor = [ColorUtility colorFromHex:0x1d1d1d];
        [self addSubview:nameLabel];
    
        NSArray *titleArray = @[@"开始",@"结束"];
        CGFloat leftX = 90;
        CGFloat rightX = (kScreenWidth - 90)/2.0 + 90;
        for(int i = 0;i < titleArray.count;i++)
        {
            UIImageView *arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotel_book_arrow"]];
            [self addSubview:arrowImageView];
            arrowImageView.centerX = i == 0?(rightX - 40):(kScreenWidth - 16);
            arrowImageView.centerY = 30;
            [self addSubview:arrowImageView];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, 80, 13)];
            titleLabel.textColor = [UIColor lightGrayColor];
            titleLabel.font = [UIFont systemFontOfSize:11];
            titleLabel.text = [titleArray objectAtIndex:i];
            titleLabel.x = i == 0?(leftX ):(rightX );
            [self addSubview:titleLabel];
            
            UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 18)];
            dateLabel.textColor = [UIColor blackColor];
            dateLabel.font = [UIFont systemFontOfSize:16];
            [self addSubview:dateLabel];
            dateLabel.centerY = arrowImageView.centerY;
            dateLabel.text = [titleArray objectAtIndex:i];
            dateLabel.x = titleLabel.x;
            if(i == 0)
            {
                self.startDateLabel = dateLabel;
            }
            else
            {
                self.leaveDateLabel = dateLabel;
            }
        }
    }
    return self;
}
- (void)setModel:(BeMeetingModel *)model
{
    _model = model;
    self.startDateLabel.text = [self getDayStringWith:model.startDate];
    self.leaveDateLabel.text = [self getDayStringWith:model.leaveDate];
}
- (NSString *)getDayStringWith:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
- (int)getStayDaysWith:(NSDate *)startDate andLeaveDate:(NSDate *)leaveDate
{
    NSTimeInterval time=[leaveDate timeIntervalSinceDate:startDate];
    int days = ((int)time)/(3600*24);
    return days;
}
- (void)addTarget:(id)target WithStartAction:(SEL)startAction andLeaveAction:(SEL)leaveAction
{
    for(UIView *subview in [self subviews])
    {
        subview.userInteractionEnabled = YES;
    }
    UITapGestureRecognizer *startTap = [[UITapGestureRecognizer alloc]initWithTarget:target action:startAction];
    [self.startDateLabel addGestureRecognizer:startTap];
    
    UITapGestureRecognizer *leaveTap = [[UITapGestureRecognizer alloc]initWithTarget:target action:leaveAction];
    [self.leaveDateLabel addGestureRecognizer:leaveTap];
}
@end
