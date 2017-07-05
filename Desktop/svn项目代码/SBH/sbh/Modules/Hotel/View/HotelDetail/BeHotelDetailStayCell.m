//
//  BeRoomRow01Cell.m
//  SideBenefit
//
//  Created by SBH on 15-3-11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelDetailStayCell.h"
#import "ColorConfigure.h"

@interface BeHotelDetailStayCell ()
{
    UILabel *checkInDateLabel;
    UILabel *checkOutDateLabel;
    UILabel *stayLabel;
}
@end
@implementation BeHotelDetailStayCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}
+ (CGFloat)cellHeight
{
    return 30.0;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeRoomRow01CellIdentifier";
    BeHotelDetailStayCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[BeHotelDetailStayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        checkInDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 0, kScreenWidth/3.0, 14)];
        checkInDateLabel.centerY = 15;
        checkInDateLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:checkInDateLabel];
        
        checkOutDateLabel  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(checkInDateLabel.frame) + 5, 0, kScreenWidth/3.0, 14)];
        checkOutDateLabel.centerY = 15;
        checkOutDateLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:checkOutDateLabel];

        stayLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 80, 0, 70, 14)];
        stayLabel.centerY = 15;
        stayLabel.textAlignment = NSTextAlignmentRight;
        stayLabel.textColor = [ColorConfigure globalBgColor];
        stayLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:stayLabel];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
        [self addSubview:imageView];
    }
    return self;
}
- (void)updateUIWithCheckIn:(NSString *)checkIn andCheckOut:(NSString *)checkOut
{
    checkInDateLabel.text = [NSString stringWithFormat:@"入住：%@",checkIn];
    checkOutDateLabel.text = [NSString stringWithFormat:@"离店：%@",checkOut];
    NSTimeInterval time=[[CommonMethod dateFromString:checkOut WithParseStr:@"yyyy-MM-dd"] timeIntervalSinceDate:[CommonMethod dateFromString:checkIn WithParseStr:@"yyyy-MM-dd"]];
    int days = ((int)time)/(3600*24);
    stayLabel.text = [NSString stringWithFormat:@"共%d晚",days];
}
- (void)addTarget:(id)target andCheckIn:(SEL)checkInAction andCheckOut:(SEL)checkOutAction
{
    for(UIView *subview in [self subviews])
    {
        subview.userInteractionEnabled = YES;
    }
    UITapGestureRecognizer *checkInGest = [[UITapGestureRecognizer alloc]initWithTarget:target action:checkInAction];
    [checkInDateLabel addGestureRecognizer:checkInGest];
    
    UITapGestureRecognizer *checkOutGest = [[UITapGestureRecognizer alloc]initWithTarget:target action:checkOutAction];
    [checkOutDateLabel addGestureRecognizer:checkOutGest];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
