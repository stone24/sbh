//
//  BeCarOrderListTableViewCell.m
//  sbh
//
//  Created by RobinLiu on 15/7/13.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeCarOrderListTableViewCell.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "CommonDefine.h"
#import "DateFormatterConfig.h"

@interface BeCarOrderListTableViewCell()
{
    UILabel *dateLabel;
    UILabel *startLocationLabel;
    UILabel *destinationLabel;
    UILabel *serviceTipsLabel;
}
@end
@implementation BeCarOrderListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeCarOrderListTableViewCellIdentifier";
    BeCarOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeCarOrderListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor whiteColor];
    [cell setCellSubViews];
    return cell;
}
+ (CGFloat)cellHeight
{
    return 80;
}
- (void)setCellSubViews
{
    dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 5, kScreenWidth -100, 20)];
    dateLabel.font = [UIFont systemFontOfSize:13];
    dateLabel.textColor = [UIColor darkGrayColor];
    dateLabel.text = @"2015-11-11";
    [self addSubview:dateLabel];
    
    UILabel *startTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 32, 15, 15)];
    startTipLabel.textColor = [UIColor whiteColor];
    startTipLabel.textAlignment = NSTextAlignmentCenter;
    startTipLabel.font = [UIFont systemFontOfSize:12];
    startTipLabel.text = @"始";
    startTipLabel.backgroundColor = [ColorUtility colorWithRed:61 green:132 blue:230];
    [self addSubview:startTipLabel];
    
    UILabel *destTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 55, 15, 15)];
    destTipLabel.font = [UIFont systemFontOfSize:12];
    destTipLabel.textColor = [UIColor whiteColor];
    destTipLabel.text = @"终";
    destTipLabel.textAlignment = NSTextAlignmentCenter;
    destTipLabel.backgroundColor =[ColorUtility colorFromHex:0xfa7473];
    [self addSubview:destTipLabel];
    
    startLocationLabel = [[UILabel alloc]initWithFrame:CGRectMake(startTipLabel.x + startTipLabel.width +4, 0, kScreenWidth- startTipLabel.x - startTipLabel.width -50, 20)];
    startLocationLabel.text = @"北京市朝阳区建国路乙118";
    startLocationLabel.centerY = startTipLabel.centerY;
    startLocationLabel.font = kAirTicketDetailContentFont;
    startLocationLabel.textColor = kAirTicketDetailContentColor;
    [self addSubview:startLocationLabel];
    
    destinationLabel = [[UILabel alloc]initWithFrame:CGRectMake(destTipLabel.x + destTipLabel.width +4, 0, kScreenWidth- destTipLabel.x - destTipLabel.width -50, 20)];
    destinationLabel.centerY = destTipLabel.centerY;
    destinationLabel.text = @"通州区陈列馆路106号xx大厦";
    destinationLabel.font = kAirTicketDetailContentFont;
    destinationLabel.textColor = kAirTicketDetailContentColor;
    [self addSubview:destinationLabel];
    
    serviceTipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 200, 0, 186, 20)];
    serviceTipsLabel.centerY = dateLabel.centerY;
    serviceTipsLabel.text = @"服务中";
    serviceTipsLabel.textAlignment = NSTextAlignmentRight;
    serviceTipsLabel.font = kAirTicketDetailContentFont;
    serviceTipsLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:serviceTipsLabel];
}
- (void)setModel:(BeCarOrderListModel *)model
{
    //dateLabel.text = model.RidingDate;
    startLocationLabel.text = model.StartAddress;
    destinationLabel.text = model.EndAddress;
    serviceTipsLabel.text = model.OrderStatus;
    serviceTipsLabel.textColor = [BeCarOrderListModel colorWithString:model.OrderStatus];
    dateLabel.text = [DateFormatterConfig dateStringFromDateString:model.OrderCreateDate];
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if(highlighted)
    {
        self.backgroundColor = [ColorUtility       colorWithRed:240 green:240 blue:240];
    } else
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    [super setHighlighted:highlighted animated:animated];
}
@end
