//
//  BeTrainListTableViewCell.m
//  sbh
//
//  Created by RobinLiu on 15/6/15.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTrainListTableViewCell.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "CommonDefine.h"

#define kTrainListOrangeColor [ColorUtility colorWithRed:253 green:134 blue:40]
#define kTrainListBlueColor [ColorUtility colorWithRed:61 green:132 blue:230]

@interface BeTrainListTableViewCell()
{
    UILabel *ticketNumberLabel;
    UILabel *durationLabel;
    UILabel *startMarkLabel;
    UILabel *destMarkLabel;
    UILabel *startTimeLabel;
    UILabel *destTimeLabel;
    UILabel *fromCityLabel;
    UILabel *toCityLabel;
    UILabel *priceLabel;
    UILabel *seatLabel;
    UILabel *availableTicketLabel;
    UILabel *priceMarkLabel;
}
@end
@implementation BeTrainListTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeTrainListTableViewCellIdentifier";
    BeTrainListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeTrainListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    [cell setLabels];
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (CGFloat)cellHeight
{
    return 70;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLabels
{
    ticketNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 80, 20)];
    ticketNumberLabel.font = [UIFont systemFontOfSize:17];
    ticketNumberLabel.text = @"G6666";
    ticketNumberLabel.textColor = [UIColor blackColor];
    [self addSubview:ticketNumberLabel];
    
    durationLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 100, 20)];
    durationLabel.font = [UIFont systemFontOfSize:14];
    durationLabel.text = @"99时99分";
    durationLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:durationLabel];
    
    startMarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2.0 - 80, 18, 14, 14)];
    startMarkLabel.backgroundColor = kTrainListBlueColor;
    startMarkLabel.textAlignment = NSTextAlignmentCenter;
    startMarkLabel.font = [UIFont systemFontOfSize:11];
    startMarkLabel.text = @"始";
    startMarkLabel.textColor = [UIColor whiteColor];
    [self addSubview:startMarkLabel];
    
    destMarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2.0 - 80, 42, 14, 14)];
    destMarkLabel.textAlignment = NSTextAlignmentCenter;
    destMarkLabel.font = [UIFont systemFontOfSize:11];
    destMarkLabel.backgroundColor = kTrainListOrangeColor;
    destMarkLabel.text = @"过";
    destMarkLabel.textColor = [UIColor whiteColor];
    [self addSubview:destMarkLabel];
    
    startTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-57, 14, 55, 20)];
    startTimeLabel.font = [UIFont systemFontOfSize:14];
    startTimeLabel.text = @"06:10";
    startTimeLabel.textColor = [UIColor blackColor];
    [self addSubview:startTimeLabel];
    
    destTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-57, 39, 70, 20)];
    destTimeLabel.font = [UIFont systemFontOfSize:14];
    destTimeLabel.text = @"09:10";
    destTimeLabel.textColor = [UIColor blackColor];
    [self addSubview:destTimeLabel];
    
    fromCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2.0+10, 14, 100, 20)];
    fromCityLabel.font = [UIFont systemFontOfSize:14];
    fromCityLabel.text = @"最长的火车站";
    fromCityLabel.textColor = [UIColor blackColor];
    [self addSubview:fromCityLabel];
    
    toCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2.0+10,39, 100, 20)];
    toCityLabel.font = [UIFont systemFontOfSize:14];
    toCityLabel.text = @"最长的火车站";
    toCityLabel.textColor = [UIColor blackColor];
    [self addSubview:toCityLabel];
    
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-110, 7, 100, 20)];
    priceLabel.font = [UIFont systemFontOfSize:16];
    priceLabel.textColor = kTrainListOrangeColor;
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.text = @"";
    [self addSubview:priceLabel];
    
    priceMarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-72, 10, 15, 15)];
    priceMarkLabel.text = @"￥";
    priceMarkLabel.textColor = kTrainListOrangeColor;
    priceMarkLabel.font = [UIFont systemFontOfSize:12];
    //[self addSubview:priceMarkLabel];
    
    seatLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-110, 26, 100, 20)];
    seatLabel.textAlignment = NSTextAlignmentRight;
    seatLabel.font = [UIFont systemFontOfSize:13];
    seatLabel.text = @"";
    seatLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:seatLabel];
    
    availableTicketLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-160, 47, 150, 20)];
    availableTicketLabel.font = [UIFont systemFontOfSize:12];
    availableTicketLabel.textAlignment = NSTextAlignmentRight;
    availableTicketLabel.text = @"";
    availableTicketLabel.textColor = [UIColor blackColor];
    [self addSubview:availableTicketLabel];
}
- (void)setListModel:(BeTrainTicketListModel *)listModel
{
    ticketNumberLabel.text = listModel.TrainCode;
    NSArray *costArray = [listModel.CostTime componentsSeparatedByString:@":"];
    durationLabel.text = [NSString stringWithFormat:@"%d时%d分",[[costArray firstObject] intValue],[[costArray objectAtIndex:1]intValue]];
    
    if([listModel.StartCity isEqualToString:listModel.SFZ])
    {
        startMarkLabel.text = @"始";
        startMarkLabel.backgroundColor = [ColorConfigure globalBgColor];
    }
    else
    {
        startMarkLabel.text = @"过";
        startMarkLabel.backgroundColor = kTrainListOrangeColor;
    }
    
    if([listModel.EndCity isEqualToString:listModel.ZDZ])
    {
        destMarkLabel.text = @"终";
        destMarkLabel.backgroundColor = [ColorConfigure globalBgColor];
    }
    else
    {
        destMarkLabel.text = @"过";
        destMarkLabel.backgroundColor = kTrainListOrangeColor;
    }
    
    startTimeLabel.text = listModel.StartTime;
    //计算
    NSArray *startArray = [listModel.StartTime componentsSeparatedByString:@":"];
    int days = ([[costArray firstObject] intValue]*60 + [[costArray objectAtIndex:1] intValue] + [[startArray firstObject] intValue]*60 + [[startArray objectAtIndex:1] intValue])/1440;
    if(days > 0)
    {
        destTimeLabel.text = [NSString stringWithFormat:@"%@ +%d",listModel.EndTime,days];
    }
    else{
         destTimeLabel.text = listModel.EndTime;
    }
    fromCityLabel.text = listModel.StartCity;
    toCityLabel.text = listModel.EndCity;
    seatLabel.text = listModel.displayModel.seatName;

    NSString *displayPrice = [NSString stringWithFormat:@"%.1f",listModel.displayModel.seatPrice];
    if([displayPrice intValue] == [displayPrice floatValue])
    {
        priceLabel.text = [NSString stringWithFormat:@"￥%.0f",listModel.displayModel.seatPrice];
    }
    else
    {
         priceLabel.text = [NSString stringWithFormat:@"￥%.1f",listModel.displayModel.seatPrice];
    }
    if([listModel.displayModel.seatCount hasPrefix:@"*"])
    {
        availableTicketLabel.text = listModel.note;
        availableTicketLabel.font = [UIFont systemFontOfSize:10];
        availableTicketLabel.textColor = [UIColor darkGrayColor];
    }
    else if([listModel.displayModel.seatCount intValue] > 0 && [listModel.displayModel.seatCount intValue] < 10)
    {
        availableTicketLabel.text = [NSString stringWithFormat:@"仅剩%@张",listModel.displayModel.seatCount];
        availableTicketLabel.font = [UIFont systemFontOfSize:12];

        availableTicketLabel.textColor = [UIColor redColor];
    }
    else if([listModel.displayModel.seatCount intValue] < 1)
    {
        availableTicketLabel.text = @"无票";
        availableTicketLabel.font = [UIFont systemFontOfSize:12];

        availableTicketLabel.textColor = [UIColor darkGrayColor];
    }
    else
    {
        availableTicketLabel.text = [NSString stringWithFormat:@"%@张",listModel.displayModel.seatCount];
        availableTicketLabel.font = [UIFont systemFontOfSize:12];

        availableTicketLabel.textColor = [UIColor darkGrayColor];
    }
}
@end
