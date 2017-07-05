//
//  BeCarOrderDetailOrderHeaderCell.m
//  sbh
//
//  Created by RobinLiu on 15/7/13.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeCarOrderDetailOrderHeaderCell.h"
#import "CommonDefine.h"
#import "ColorUtility.h"
#import "BeCarOrderListModel.h"
#import "ColorConfigure.h"

@implementation BeCarOrderDetailOrderHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeCarOrderDetailOrderHeaderCellIdentifier";
    BeCarOrderDetailOrderHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeCarOrderDetailOrderHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)setCellWithModel:(BeCarOrderDetailModel *)model andIsSpread:(BOOL)isSpread
{
    isDetailShow = isSpread;
    for(UIView *v in [self subviews])
    {
        if ([v isKindOfClass:[UILabel class]]||[v isKindOfClass:[UIButton class]]) {
            [v removeFromSuperview];
        }
    }
    NSMutableArray *titlesArray = [NSMutableArray arrayWithArray:@[@"订单状态：",@"订单号：",@"下单时间：",@"用车时间：",@"服务类型：",@"车辆级别：",@"预估金额：",@"实付金额："]];
    if(model.isSumShow == NO)
    {
        [titlesArray removeObject:@"实付金额："];
    }
    for(int i = 0;i < titlesArray.count;i++)
    {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = [titlesArray objectAtIndex:i];
        [self addSubview:titleLabel];
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.textColor = kAirTicketDetailTitleColor;
        titleLabel.font = kAirTicketDetailContentFont;
        titleLabel.frame = CGRectMake(kAirTicketDetailInset, kAirTicketDetailInset +(kAirTicketDetailInset+kAirTicketDetailTitleH)*i , kAirTicketDetailTitleW+10, kAirTicketDetailTitleH);

        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.x+titleLabel.width + kAirTicketDetailInset/2.0, kAirTicketDetailInset +(kAirTicketDetailInset+kAirTicketDetailTitleH)*i , kScreenWidth - titleLabel.x-titleLabel.width - kAirTicketDetailInset -kAirTicketDetailInset/2.0 , kAirTicketDetailTitleH)];
        detailLabel.textColor = kAirTicketDetailContentColor;
        detailLabel.font = kAirTicketDetailContentFont;
        detailLabel.text = [self getDetailTextWith:[titlesArray objectAtIndex:i] andModel:model];
        if (i == 0) {
            detailLabel.textColor = [BeCarOrderListModel colorWithString:detailLabel.text];
        }
        if([titleLabel.text isEqualToString:@"实付金额："])
        {
            detailLabel.font = [UIFont systemFontOfSize:16];
            detailLabel.textColor = [UIColor orangeColor];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            NSDictionary * attributes = @{NSFontAttributeName : kAirTicketDetailContentFont};
            CGRect sumRect = [detailLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
            button.frame = CGRectMake(detailLabel.x + sumRect.size.width +2, detailLabel.y, 50, 18);
            [self addSubview:button];
            [button setTitle:@"明细" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button setTitleColor:[ColorConfigure globalBgColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(spreadAction) forControlEvents:UIControlEventTouchUpInside];
            button.centerY = detailLabel.centerY;
            if(isSpread)
            {
                UILabel *sumLabel = [[UILabel alloc]init];
                sumLabel.text = [NSString stringWithFormat:@"订单总额%@/服务费￥0",detailLabel.text];
                [self addSubview:sumLabel];
                sumLabel.textColor = detailLabel.textColor;
                sumLabel.font = [UIFont systemFontOfSize:13];
                sumLabel.frame = CGRectMake(20, button.y+button.height + 3, kScreenWidth - 20,20);
            }
        }
        [self addSubview:detailLabel];
    }
}
- (void)spreadAction
{
    isDetailShow = !isDetailShow;
    BOOL isShow = isDetailShow;
    if(self.delegate)
    {
        [self.delegate isShowDetailWithBool:isShow];
    }
}
- (NSString *)getDetailTextWith:(NSString *)title andModel:(BeCarOrderDetailModel *)model
{
    if([title isEqualToString:@"订单状态："])
    {
        NSString *detailText = [model.orderState copy];
        return detailText;
    }
    else if([title isEqualToString:@"订单号："])
    {
        NSString *detailText = [model.orderNo copy];
        return detailText;
    }
    else if([title isEqualToString:@"下单时间："])
    {
        NSString *detailText = [model.createOrderDate copy];
        return detailText;
    }
    else if([title isEqualToString:@"用车时间："])
    {
        NSString *detailText = [model.orderDate copy];
        return detailText;
    }
    else if([title isEqualToString:@"服务类型："])
    {
        NSString *detailText = [model.serviceType copy];
        return detailText;
    }
    else if([title isEqualToString:@"车辆级别："])
    {
        NSString *detailText = [model.carLevel copy];
        return detailText;
    }
    else if([title isEqualToString:@"预估金额："])
    {
        NSString *detailText = nil;
        float sum = [model.EstimatedCost floatValue];
        if([[NSString stringWithFormat:@"%0.0f", sum] intValue]== sum)
        {
            detailText = [NSString stringWithFormat:@"￥%0.0f", sum];
        }
        else
        {
            detailText = [NSString stringWithFormat:@"￥%0.1f", sum];
        }
        return detailText;
    }
    else if ([title isEqualToString:@"实付金额："])
    {
        NSString *detailText = [model.orderCost mutableCopy];
        return detailText;
    }
    return @"";
}
+ (CGFloat)cellHeightWithModel:(BeCarOrderDetailModel *)model andIsSpread:(BOOL)isSpread
{
    if(model.isSumShow)
    {
        if(isSpread)
        {
            return 281/2.0 + 25 + 25 + 25+ 25;
        }
        return 281/2.0 + 25 + 25+ 25;
    }
    return 281/2.0-28.0 + 25+ 25+ 25;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
