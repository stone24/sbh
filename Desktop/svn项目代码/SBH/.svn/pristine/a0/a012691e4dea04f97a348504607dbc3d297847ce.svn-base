//
//  BeCarOrderDetailDriverInfoCell.m
//  sbh
//
//  Created by RobinLiu on 15/7/13.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeCarOrderDetailDriverInfoCell.h"
#import "CommonDefine.h"
#import "ColorUtility.h"

@implementation BeCarOrderDetailDriverInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeCarOrderDetailDriverInfoCellIdentifier";
    BeCarOrderDetailDriverInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeCarOrderDetailDriverInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
+ (CGFloat)cellHeight
{
    return 176.0/2.0 + 25.0;
}
- (void)setCellWithModel:(BeCarOrderDetailModel *)model
{
    NSArray *titlesArray = @[@"司机姓名：",@"司机电话：",@"车      型：",@"车牌尾号："];
    for(int i = 0;i < titlesArray.count;i++)
    {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.textColor = kAirTicketDetailTitleColor;
        titleLabel.font = kAirTicketDetailContentFont;
        titleLabel.frame = CGRectMake(kAirTicketDetailInset, kAirTicketDetailInset +(kAirTicketDetailInset+kAirTicketDetailTitleH)*i , kAirTicketDetailTitleW+10, kAirTicketDetailTitleH);
        titleLabel.text = [titlesArray objectAtIndex:i];
        [self addSubview:titleLabel];
        
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.x+titleLabel.width + kAirTicketDetailInset/2.0, kAirTicketDetailInset +(kAirTicketDetailInset+kAirTicketDetailTitleH)*i , kScreenWidth - titleLabel.x-titleLabel.width - kAirTicketDetailInset -kAirTicketDetailInset/2.0, kAirTicketDetailTitleH)];
        detailLabel.text = [self getDetailTextWith:i andModel:model];
        //detailLabel.textAlignment = NSTextAlignmentRight;
        detailLabel.textColor = kAirTicketDetailContentColor;
        detailLabel.font = kAirTicketDetailContentFont;
        [self addSubview:detailLabel];
    }
}
- (NSString *)getDetailTextWith:(int)index andModel:(BeCarOrderDetailModel *)model
{
    switch (index) {
        case 0:
        {
            NSString *detailText = [model.driverName copy];
            return detailText;
        }
            break;
        case 1:
        {
            NSString *detailText = [model.driverPhone copy];
            return detailText;
        }
            break;
        case 2:
        {
            NSString *detailText = [model.carName copy];
            return detailText;
        }
            break;
        case 3:
        {
            NSString *detailText = [model.driverCarNo copy];
            return detailText;
        }
            break;
        default:
            break;
    }
    return @"";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
