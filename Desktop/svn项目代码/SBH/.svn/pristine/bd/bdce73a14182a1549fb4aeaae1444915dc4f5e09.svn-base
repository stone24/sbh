//
//  yuding2TableViewCell.m
//  SBHAPP
//
//  Created by musmile on 14-7-2.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "BeAirTicketMorePriceTableViewCell.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"

@interface BeAirTicketMorePriceTableViewCell ()
{
    UILabel *buttonTitleLabel;
    UILabel *availabelLabel;
    UILabel *priceLabel;
    UILabel *titleLabel;
    
    UIImageView *priceTypeImageView;
    UILabel *refundLabel;
    UIButton *bookButton;
    
    id thisTarget;
    SEL thisBookAction;
    SEL thisRefundAction;
    NSIndexPath *thisIndexPath;
}
@end
@implementation BeAirTicketMorePriceTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"yuding2TableViewCellIdentifier";
    BeAirTicketMorePriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeAirTicketMorePriceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (void)setCellWithModel:(BeTicketDetailModel *)model
{
    NSString *discountString = model.Rebate;
    if(discountString.length > 0)
    {
        NSScanner* scan = [NSScanner scannerWithString:discountString];
        float val;
        if([scan scanFloat:&val] && [scan isAtEnd])
        {
            //浮点型 四舍五入
            float disValue = [discountString floatValue];
            discountString = [NSString stringWithFormat:@"%.1f折",round(disValue*100)/100];
        }
    }
    NSString *titleText = [NSString stringWithFormat:@"%@%@",discountString,model.ClassCodeType];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:paragraphStyle};
    CGRect dest = [titleText boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, dest.size.width + 5, 20)];
    titleLabel.textColor = [ColorUtility colorWithRed:91 green:91 blue:91];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = titleText;
    [self addSubview:titleLabel];
    
    NSString *imageName = [NSString string];
    if(model.priceType == TicketTravelPriceType)
    {
        imageName = @"gdjg_shanglvjiaIcon";
    }
    else if(model.priceType == TicketSharePriceType)
    {
        imageName = @"gdjg_hongxiangjiaIcon";
    }
    else if(model.priceType == TicketOfficialWebsitePriceType)
    {
        //改期等待时间较长
        imageName = @"train_officialWebsitePrice_image";
    }
    else if(model.priceType == TicketLargeCustomerPriceType)
    {
        imageName = @"train_ agreementPrice_image";
    }
    else
    {
        imageName = @"train_ agreementPrice_image";
    }
    priceTypeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    priceTypeImageView.x = titleLabel.x + titleLabel.width;
    priceTypeImageView.centerY = titleLabel.centerY;
    [priceTypeImageView sizeToFit];
    [self addSubview:priceTypeImageView];
    
    refundLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, [BeAirTicketMorePriceTableViewCell cellHeight] - 30, 200, 15)];
    refundLabel.textColor = [ColorConfigure globalBgColor];
    refundLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:refundLabel];
    if(model.priceType == TicketOfficialWebsitePriceType)
    {
        NSString *refundStr1 = @"退改规则";
        NSString *refundStr2 = @"（改期等待时间较长）";
        NSString *refundAllString = [NSString stringWithFormat:@"%@%@",refundStr1,refundStr2];
        NSMutableAttributedString *refundStr = [[NSMutableAttributedString alloc] initWithString:refundAllString];
        [refundStr addAttribute:NSForegroundColorAttributeName value:titleLabel.textColor range:NSMakeRange([refundStr1 length],[refundStr2 length])];
        refundLabel.attributedText = refundStr;
    }
    else
    {
        refundLabel.text = @"退改规则";
    }

    bookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bookButton.layer.cornerRadius = 4.0f;
    bookButton.layer.borderWidth = .8f;
    bookButton.titleLabel.font = [UIFont systemFontOfSize:15];
    bookButton.layer.borderColor = [[ColorConfigure loginButtonColor] CGColor];
    bookButton.frame = CGRectMake(kScreenWidth - 65, 0, 55, 35);
    bookButton.centerY = [BeAirTicketMorePriceTableViewCell cellHeight]/2.0;
    [bookButton addTarget:self action:@selector(bookAction) forControlEvents:UIControlEventTouchUpInside];
    if([model.Seat intValue] > 10)
    {
        [bookButton setBackgroundColor:[ColorConfigure loginButtonColor]];
        [bookButton setTitle:@"预订" forState:UIControlStateNormal];
    }
    else if([model.Seat intValue] > 0 && [model.Seat intValue] < 11)
    {
        [bookButton setBackgroundColor:[UIColor whiteColor]];
        [bookButton setTitle:@"" forState:UIControlStateNormal];
        CGFloat label1Height = bookButton.height * 0.6;
        buttonTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, bookButton.width, label1Height)];
        buttonTitleLabel.textAlignment = NSTextAlignmentCenter;
        buttonTitleLabel.backgroundColor = [ColorConfigure loginButtonColor];
        buttonTitleLabel.textColor = [UIColor whiteColor];
        buttonTitleLabel.font = [UIFont systemFontOfSize:15];
        buttonTitleLabel.text = @"预订";
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:buttonTitleLabel.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = buttonTitleLabel.bounds;
        maskLayer.path = maskPath.CGPath;
        buttonTitleLabel.layer.mask = maskLayer;
        [bookButton addSubview:buttonTitleLabel];
        
        availabelLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, label1Height, bookButton.width, bookButton.height - label1Height)];
        availabelLabel.textAlignment = NSTextAlignmentCenter;
        availabelLabel.textColor = [ColorConfigure loginButtonColor];
        availabelLabel.backgroundColor = [UIColor whiteColor];
        availabelLabel.font = [UIFont systemFontOfSize:11];
        availabelLabel.text = [NSString stringWithFormat:@"剩%@张",model.Seat];
        [bookButton addSubview:availabelLabel];
    }
    else
    {
        [bookButton setBackgroundColor:[UIColor lightGrayColor]];
        [bookButton setTitle:@"售罄" forState:UIControlStateNormal];
        [bookButton removeTarget:self action:@selector(bookAction) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:bookButton];
    
    //价钱
    NSString *str1 = @"30";
    NSString *str2 = @"保险+";
    if(model.ForcedInsurance.length < 1 || [model.ForcedInsurance intValue]==0)
    {
        str1 = @"";
        str2 = @"";
    }
    else
    {
        str1 = [model.ForcedInsurance copy];
        str2 = @"保险+";
    }
    NSString *str3 = @"￥";
    NSString *str4 = model.price;
    NSString *allString = [NSString stringWithFormat:@"%@%@%@%@",str1,str2,str3,str4];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allString];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0,[str length] - [str4 length])];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange([str1 length] + [str2 length] + [str3 length],[str4 length])];
    [str addAttribute:NSForegroundColorAttributeName value:[ColorConfigure loginButtonColor] range:NSMakeRange(0,[str1 length])];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange([str1 length],[str2 length])];
    [str addAttribute:NSForegroundColorAttributeName value:[ColorConfigure loginButtonColor] range:NSMakeRange([str1 length] + [str2 length],[str length]-[str1 length]-[str2 length])];

    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,  kScreenWidth - bookButton.width -20, 27)];
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.attributedText = str;
    priceLabel.centerY = [BeAirTicketMorePriceTableViewCell cellHeight]/2.0;
    [self addSubview:priceLabel];
}
- (void)hideBookButton
{
    bookButton.hidden = YES;
    priceLabel.width = kScreenWidth - 20;
}
- (void)refundAction
{
    [thisTarget performSelector:thisRefundAction withObject:thisIndexPath afterDelay:0.01];
}
- (void)bookAction
{
    [thisTarget performSelector:thisBookAction withObject:thisIndexPath afterDelay:0.01];
}
+ (CGFloat)cellHeight
{
    return 65.0f;
}
- (void)addTarget:(id)target andBookAction:(SEL)bAction andRefundAction:(SEL)rAction WithIndexPath:(NSIndexPath *)indexPath
{
    thisBookAction = bAction;
    thisRefundAction = rAction;
    thisIndexPath = indexPath;
    thisTarget = target;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
