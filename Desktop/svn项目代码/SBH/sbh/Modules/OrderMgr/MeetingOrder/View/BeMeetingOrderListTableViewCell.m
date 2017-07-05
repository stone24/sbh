//
//  BeMeetingOrderListTableViewCell.m
//  sbh
//
//  Created by RobinLiu on 16/6/22.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeMeetingOrderListTableViewCell.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "CommonDefine.h"
#import "DateFormatterConfig.h"
#import "CommonMethod.h"
@interface BeMeetingOrderListTableViewCell()
{
    UILabel *titleLabel;
    UILabel *contentLabel;
    UILabel *tipLabel;
}
@end
@implementation BeMeetingOrderListTableViewCell

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
    static NSString *identifier = @"BeMeetingOrderListTableViewCellIdentifier";
    BeMeetingOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeMeetingOrderListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    [cell setCellSubViews];
    return cell;
}
+ (CGFloat)cellHeight
{
    return 60;
}
- (void)setCellSubViews
{
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, kScreenWidth - 115, 15)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:titleLabel];
    
    contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, [BeMeetingOrderListTableViewCell cellHeight] - 25, kScreenWidth - 115, 15)];
    contentLabel.textColor = [UIColor darkGrayColor];
    contentLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:contentLabel];
    
    tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 100, 0, 80, 15)];
    tipLabel.font = [UIFont systemFontOfSize:15];
    tipLabel.centerY = [BeMeetingOrderListTableViewCell cellHeight]/2.0;
    tipLabel.textColor = [UIColor darkGrayColor];
    tipLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:tipLabel];
}
- (void)setModel:(BeMeetingOrderModel *)model
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 = [formatter dateFromString:model.Meeting_StrDate];
    NSDate *date2 = [formatter dateFromString:model.Meeting_EndDate];
    [formatter setDateFormat:@"MM月dd日"];
    NSString *startString = [formatter stringFromDate:date1];
    NSString *endString = [formatter stringFromDate:date2];
    
    titleLabel.text = [NSString stringWithFormat:@"%@ %@-%@",model.Meeting_CityName,startString,endString];
    contentLabel.text = [NSString stringWithFormat:@"%@ %@",model.Meeting_LinkMan,model.Meeting_LinkTelephone];
    if([model.Meeting_OrderStatus intValue] == 101)
    {
        tipLabel.text = @"已提交";
    }
    else if([model.Meeting_OrderStatus intValue] == 110)
    {
        tipLabel.text = @"已确认";
    }
    else if([model.Meeting_OrderStatus intValue] == 120)
    {
        tipLabel.text = @"已取消";
    }
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
