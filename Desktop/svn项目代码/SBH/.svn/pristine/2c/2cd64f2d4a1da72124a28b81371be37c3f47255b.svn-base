//
//  BeCarOderDetailBookInfoCell.m
//  sbh
//
//  Created by RobinLiu on 15/7/13.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeCarOrderDetailBookInfoCell.h"
#import "CommonDefine.h"
#import "ColorUtility.h"
#define kCarOrderDetailCellWidth (kScreenWidth -kAirTicketDetailTitleW-10 - kAirTicketDetailInset*3 + kAirTicketDetailInset/2.0)
@implementation BeCarOrderDetailBookInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}
- (void)setupSubviews
{
    
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeCarOderDetailBookInfoCellIdentifier";
    BeCarOrderDetailBookInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeCarOrderDetailBookInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
+ (CGFloat)cellHeightWithModel:(BeCarOrderDetailModel *)model
{
    CGFloat width = kCarOrderDetailCellWidth;
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary * attributes = @{NSFontAttributeName : kAirTicketDetailContentFont,NSParagraphStyleAttributeName:paragraphStyle};
    CGRect start = [model.startLocation boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
    CGRect dest = [model.destination boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
    if(start.size.height <= kAirTicketDetailTitleH)
    {
        start.size.height = kAirTicketDetailTitleH;
    }
    if(dest.size.height <= kAirTicketDetailTitleH)
    {
        dest.size.height = kAirTicketDetailTitleH;
    }
    return kAirTicketDetailInset*7 + kAirTicketDetailTitleH*4 + start.size.height+dest.size.height;
}

- (void)setCellWithModel:(BeCarOrderDetailModel *)model
{
    NSArray *titlesArray = @[@"乘车人：",@"联系电话：",@"费用中心：",@"用车原因：",@"上车地点：",@"下车地点："];
    CGFloat width = kCarOrderDetailCellWidth;
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary * attributes = @{NSFontAttributeName : kAirTicketDetailContentFont,NSParagraphStyleAttributeName:paragraphStyle};
    
    CGSize start = [model.startLocation boundingRectWithSize:CGSizeMake(width, MAXFLOAT)options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)attributes:attributes context:nil].size;
    CGRect dest = [model.destination boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
    CGFloat startHeight = 0.0f;
    for(int i = 0;i < titlesArray.count;i++)
    {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.textColor = kAirTicketDetailTitleColor;
        titleLabel.font = kAirTicketDetailContentFont;
        titleLabel.frame = CGRectMake(kAirTicketDetailInset, kAirTicketDetailInset +(kAirTicketDetailInset+kAirTicketDetailTitleH)*i , kAirTicketDetailTitleW+10, kAirTicketDetailTitleH);
        titleLabel.text = [titlesArray objectAtIndex:i];
        [self addSubview:titleLabel];
        
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.x+titleLabel.width + kAirTicketDetailInset/2.0, kAirTicketDetailInset +(kAirTicketDetailInset+kAirTicketDetailTitleH)*i , kCarOrderDetailCellWidth, kAirTicketDetailTitleH)];
        detailLabel.text = [self getDetailTextWith:i andModel:model];
        detailLabel.numberOfLines = 0;
        //detailLabel.textAlignment = NSTextAlignmentRight;
        detailLabel.textColor = kAirTicketDetailContentColor;
        detailLabel.font = kAirTicketDetailContentFont;
        [self addSubview:detailLabel];
        
        if([titleLabel.text isEqualToString:@"上车地点："])
        {
            detailLabel.height = start.height;
            startHeight = detailLabel.y +detailLabel.height + kAirTicketDetailInset;
            titleLabel.centerY = detailLabel.centerY;
        }
        if([titleLabel.text isEqualToString:@"下车地点："])
        {
            detailLabel.y = startHeight;
            detailLabel.height = dest.size.height;
            titleLabel.y = startHeight;
        }
    }
}
- (NSString *)getDetailTextWith:(int)index andModel:(BeCarOrderDetailModel *)model
{
    switch (index) {
        case 0:
        {
            NSString *detailText = [model.passengers copy];
            return detailText;
        }
            break;
        case 1:
        {
            NSString *detailText = [model.passengerPhone copy];
            return detailText;
        }
            break;
        case 2:
        {
            NSString *detailText = [model.expenseCenter copy];
            return detailText;
        }
            break;
        case 3:
        {
            NSString *detailText = [model.reason copy];
            return detailText;
        }
            break;
        case 4:
        {
            NSString *detailText = [model.startLocation copy];
            return detailText;
        }
            break;
            case 5:
        {
            NSString *detailText = [model.destination copy];
            return detailText;
        }
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
