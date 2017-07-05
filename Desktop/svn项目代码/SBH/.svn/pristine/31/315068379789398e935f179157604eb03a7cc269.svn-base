//
//  BeHotelListTableViewCell.m
//  SideBenefit
//
//  Created by RobinLiu on 15/3/11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "BeHotelCityManager.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "ServerConfigure.h"
#import "CommonDefine.h"

#define kHotelListCellPlaceHolderImage @"hotellist_cell_placeHolderImage"
@interface BeHotelListTableViewCell ()
{
    UIImageView *hotelImageView;
    UILabel *hotelNameLabel;
    UILabel *starLabel;
    UILabel *districtLabel;
    UILabel *priceLabel;
    UILabel *distanceLabel;
}
@end
@implementation BeHotelListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}
+ (CGFloat)cellHeight
{
    return 82.0f;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeHotelListTableViewCellIdentifier";
    BeHotelListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeHotelListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        hotelImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 82, 82)];
        hotelImageView.clipsToBounds = YES;
        [self addSubview:hotelImageView];
        
        hotelNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(hotelImageView.frame) + 10, 5, kScreenWidth - CGRectGetMaxX(hotelImageView.frame) - 15, 20)];
        hotelNameLabel.textColor = [UIColor darkGrayColor];
        hotelNameLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:hotelNameLabel];
        
        starLabel = [[UILabel alloc]initWithFrame:CGRectMake(hotelNameLabel.x, CGRectGetMaxY(hotelNameLabel.frame) , kScreenWidth - hotelNameLabel.x, 20)];
        [self addSubview:starLabel];
        
        districtLabel = [[UILabel alloc]initWithFrame:CGRectMake(hotelNameLabel.x,82-18, kScreenWidth - 70 - hotelNameLabel.x, 13)];
        districtLabel.font = [UIFont systemFontOfSize:11];
        districtLabel.textColor = [UIColor grayColor];
        [self addSubview:districtLabel];
        
        priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 100,0,90,20)];
        priceLabel.centerY = 41;
        priceLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:priceLabel];
        
        distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 100,districtLabel.y,90,13)];
        distanceLabel.textAlignment = NSTextAlignmentCenter;
        distanceLabel.textColor = [ColorUtility colorWithRed:153 green:153 blue:153];
        distanceLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:distanceLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCellWith:(BeHotelListItem *)item
{
    hotelNameLabel.text = item.hotelName;
    if(item.addressAdditional.length < 1)
    {
        districtLabel.text = item.hotelAddress;
    }
    else
    {
        districtLabel.text = item.addressAdditional;
    }
    [hotelImageView sd_setImageWithURL:[NSURL URLWithString:item.hotelImageUrl] placeholderImage:[UIImage imageNamed:kHotelListCellPlaceHolderImage]];
    hotelImageView.contentMode = UIViewContentModeScaleAspectFill;
    UIView *view =  [item getFacilitiesImageView];
    view.frame = CGRectMake(hotelNameLabel.x, 45, 100, 20);
    [self addSubview:view];
    
    int starRate = 0;
    NSString *starString = [NSString string];
    if(item.Hotel_Star.length > 0)
    {
        starRate = [item.Hotel_Star intValue];
        switch (starRate) {
            case 7:
                starString = @"七星";
                break;
            case 6:
                starString = @"六星";
                break;
            case 5:
                starString = @"五星";
                break;
            case 4:
                starString = @"四星";
                break;
            case 3:
                starString = @"三星";
                break;
            default:
                starString = @"两星及以下";
                break;
        }
    }
    else if(item.Hotel_SBHStar.length > 0)
    {
        starRate = [item.Hotel_SBHStar intValue];
        switch (starRate) {
            case 7:
                starString = @"豪华";
                break;
            case 6:
                starString = @"豪华";
                break;
            case 5:
                starString = @"豪华";
                break;
            case 4:
                starString = @"高档";
                break;
            case 3:
                starString = @"舒适";
                break;
            default:
                starString = @"经济";
                break;
        }
    }
    else
    {
        starString = @"两星及以下/经济";
    }
    
    starString = [starString stringByAppendingString:@""];
    NSString *scoreString = item.reviewScore;
    NSString *scoreTitle = @"分";
    NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",starString,scoreString,scoreTitle]];
    [attrib setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(0,[starString length])];
    [attrib setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:15]} range:NSMakeRange([starString length],[scoreString length])];
    [attrib setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange([starString length]+[scoreString length],[scoreTitle length])];
    [attrib addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, starString.length)];
    [attrib addAttribute:NSForegroundColorAttributeName value:[ColorConfigure globalBgColor] range:NSMakeRange(starString.length, scoreString.length + scoreTitle.length)];
    starLabel.attributedText = attrib;
    
    NSString *priceIcon = @"￥";
    NSString *priceString = item.price;
    NSString *priceTitle = @" 起";
    NSMutableAttributedString *priceAttrib = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",priceIcon,priceString,priceTitle]];
    [priceAttrib setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(0,[priceIcon length])];
    [priceAttrib setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:17]} range:NSMakeRange([priceIcon length],[priceString length])];
    [priceAttrib setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange([priceIcon length]+[priceString length],[priceTitle length])];
    [priceAttrib addAttribute:NSForegroundColorAttributeName value:[ColorConfigure loginButtonColor] range:NSMakeRange(0, priceIcon.length + priceString.length)];
    [priceAttrib addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(priceIcon.length + priceString.length,priceTitle.length)];
    priceLabel.attributedText = priceAttrib;
    distanceLabel.text = @"";

   /* if(item.distance == 0)
    {
        distanceLabel.text = @"";
    }
    else if(item.distance < 5001 && item.distance > 0)
    {
        distanceLabel.text = [NSString stringWithFormat:@"距您%.0f米",item.distance];
    }
    else if(item.distance >= 5001 && item.distance < 100000)
    {
        distanceLabel.text = [NSString stringWithFormat:@"距您%.0f千米",item.distance/1000.0];
    }
    else
    {
        distanceLabel.text = @"距您>100千米";
    }*/
}
@end
