//
//  BeTrainNumberTableViewCell.m
//  sbh
//
//  Created by RobinLiu on 15/6/23.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTrainNumberTableViewCell.h"
#import "CommonDefine.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"

@interface BeTrainNumberTableViewCell()
{
    UILabel *startTimeLabel;
    UILabel *startStationLabel;
    UILabel *arriveTimeLabel;
    UILabel *arriveStationLabel;
    UILabel *durationLabel;
    UIImageView *trainImageView;
}
@end
@implementation BeTrainNumberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeTrainNumberTableViewCellIdentifier";
    BeTrainNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeTrainNumberTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    [cell setCellSubViews];
    return cell;
}
+ (CGFloat)cellHeight
{
    return 70.0f;
}
- (void)setCellSubViews
{
    startTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 100, 20)];
    startTimeLabel.font = [UIFont systemFontOfSize:20];
    startTimeLabel.text = @"06:11";
    [self addSubview:startTimeLabel];
    
    startStationLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 100, 20)];
    startStationLabel.font = [UIFont systemFontOfSize:15];
    startStationLabel.text = @"最长的火车站";
    [self addSubview:startStationLabel];
    
    arriveTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-120, 15, 100, 20)];
    arriveTimeLabel.textAlignment = NSTextAlignmentRight;
    arriveTimeLabel.font = [UIFont systemFontOfSize:20];
    arriveTimeLabel.text = @"21:00";
    [self addSubview:arriveTimeLabel];
    
    arriveStationLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-120, 40, 100, 20)];
    arriveStationLabel.font = [UIFont systemFontOfSize:15];
    arriveStationLabel.textAlignment = NSTextAlignmentRight;
    arriveStationLabel.text = @"最长的火车站";
    [self addSubview:arriveStationLabel];
    
    durationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    durationLabel.font = [UIFont systemFontOfSize:12];
    durationLabel.text = @"99时99分";
    durationLabel.textAlignment = NSTextAlignmentCenter;
    durationLabel.textColor = [ColorConfigure globalBgColor];
    durationLabel.y = 70.0- 30;
    durationLabel.centerX = kScreenWidth/2.0f;
    [self addSubview:durationLabel];
    
    trainImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"trainDetail_Image"]];
    trainImageView.centerX = kScreenWidth/2.0f;
    trainImageView.y = 20;
    [self addSubview:trainImageView];
}
- (void)setModel:(BeTrainTicketListModel *)model
{
    startTimeLabel.text = model.StartTime;
    startStationLabel.text = model.StartCity;
    arriveTimeLabel.text = model.EndTime;
    arriveStationLabel.text = model.EndCity;
    NSArray *costArray = [model.CostTime componentsSeparatedByString:@":"];
    durationLabel.text = [NSString stringWithFormat:@"%d时%d分",[[costArray firstObject] intValue],[[costArray objectAtIndex:1]intValue]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
