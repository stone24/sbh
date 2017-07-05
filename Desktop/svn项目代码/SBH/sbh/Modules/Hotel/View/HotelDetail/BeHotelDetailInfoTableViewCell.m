
//
//  BeHotelDetailInfoTableViewCell.m
//  sbh
//
//  Created by RobinLiu on 15/12/10.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelDetailInfoTableViewCell.h"
#import "NSDate+WQCalendarLogic.h"
#import "ColorConfigure.h"
#import "CommonDefine.h"
#import "ColorUtility.h"
#import "UIImageView+WebCache.h"

#define kButtonTitleFont [UIFont systemFontOfSize:16]
#define kButtonLittleFont [UIFont systemFontOfSize:11]

#define kBookDarkColor [UIColor blackColor]
#define kBookLightColor [UIColor lightGrayColor]
@interface BeHotelDetailInfoTableViewCell ()
{
    UILabel *hotelNameLabel;
    UILabel *scoreLabel;
    UIImageView *hotelImageView;
    UIView *facilityView;
    UILabel *facilityLabel;
    UIImageView *addressImageView;
    UILabel *addressLabel;
    UILabel *mapLabel;
    UIView *sep1View;
    UIView *sep2View;
}
@end
@implementation BeHotelDetailInfoTableViewCell

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (void)awakeFromNib
{
    [super awakeFromNib];

}
- (void)addTarget:(id)target WithMapAction:(SEL)mapAction andFacilityAction:(SEL)fAction andImageAction:(SEL)iAction
{
    for(UIView *subView in [self subviews])
    {
        subView.userInteractionEnabled = YES;
    }
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:target action:mapAction];
    [mapLabel addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:target action:iAction];
    [hotelImageView addGestureRecognizer:tap2];

    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:target action:fAction];
    [facilityLabel addGestureRecognizer:tap3];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeHotelBookViewIdentifier";
    BeHotelDetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeHotelDetailInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        hotelNameLabel = [[UILabel alloc]init];
        hotelNameLabel.textColor = [UIColor darkGrayColor];
        hotelNameLabel.font = kHotelNameFont;
        hotelNameLabel.numberOfLines = 0;
        [self addSubview:hotelNameLabel];
        
        scoreLabel = [[UILabel alloc]init];
        [self addSubview:scoreLabel];
        
        hotelImageView = [[UIImageView alloc]init];
        [self addSubview:hotelImageView];
        
        facilityView = [[UIView alloc]init];
        [self addSubview:facilityView];
        
        facilityLabel  = [[UILabel alloc]init];
        facilityLabel.font = kHotelContentFont;
        facilityLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:facilityLabel];
        
        addressImageView = [[UIImageView alloc]init];
        [self addSubview:addressImageView];
        
        addressLabel  = [[UILabel alloc]init];
        addressLabel.textColor = [UIColor grayColor];
        addressLabel.font = kHotelContentFont;
        addressLabel.numberOfLines = 0;
        [self addSubview:addressLabel];
        
        mapLabel = [[UILabel alloc]init];
        mapLabel.font = kHotelContentFont;
        mapLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:mapLabel];
        
        sep1View = [[UIView alloc]init];
        sep1View.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:sep1View];
        
        sep2View = [[UIView alloc]init];
        sep2View.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:sep2View];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    hotelNameLabel.frame = _infoFrame.nameLabelframe;
    scoreLabel.frame = _infoFrame.scoreLabelframe;
    hotelImageView.frame = _infoFrame.hotelImageViewframe;
    facilityView.frame = _infoFrame.facilityViewframe;
    facilityLabel.frame = _infoFrame.facilityLabelframe;
    addressImageView.frame = _infoFrame.addressImageViewframe;
    addressLabel.frame = _infoFrame.addressLabelframe;
    mapLabel.frame = _infoFrame.mapLabelframe;
    sep1View.frame = _infoFrame.sepLine1frame;
    sep2View.frame = _infoFrame.sepLine2frame;
}
- (void)setInfoFrame:(BeHotelDetailInfoFrame *)infoFrame
{
    _infoFrame = infoFrame;
    hotelNameLabel.text = _infoFrame.listData.hotelName;
    [hotelImageView sd_setImageWithURL:[NSURL URLWithString:_infoFrame.listData.hotelImageUrl]placeholderImage:[UIImage imageNamed:@"hotellist_cell_placeHolderImage"]];
    hotelImageView.contentMode = UIViewContentModeScaleAspectFill;
    hotelImageView.clipsToBounds = YES;
    
    UIView *faciView = [ _infoFrame.listData getFacilitiesImageView];
    faciView.x = 0;
    faciView.y = (_infoFrame.facilityViewframe.size.height - faciView.height)/2.0;
    [facilityView addSubview:faciView];
    
    addressLabel.text = _infoFrame.listData.hotelAddress;
    
    int starRate = 0;
    NSString *starString = [NSString string];
    if(_infoFrame.listData.Hotel_Star.length > 0)
    {
        starRate = [_infoFrame.listData.Hotel_Star intValue];
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
    else if(_infoFrame.listData.Hotel_SBHStar.length > 0)
    {
        starRate = [_infoFrame.listData.Hotel_SBHStar intValue];
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
    NSString *scoreString = _infoFrame.listData.reviewScore;
    NSString *scoreTitle = @"分";
    NSString *canBook = _infoFrame.listData.canBook == YES?@"":@"暂不支持预订";
    NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@%@",starString,scoreString,scoreTitle,canBook]];
    [attrib setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(0,[starString length])];
    [attrib setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:15]} range:NSMakeRange([starString length],[scoreString length])];
    [attrib setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange([starString length]+[scoreString length],[scoreTitle length]+[canBook length])];
    [attrib addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, starString.length)];
    [attrib addAttribute:NSForegroundColorAttributeName value:[ColorConfigure globalBgColor] range:NSMakeRange(starString.length, scoreString.length + scoreTitle.length)];
    [attrib addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(attrib.length - canBook.length, canBook.length)];

    scoreLabel.attributedText = attrib;
    
    NSString *facilityText = @"设施详情>";
    NSMutableAttributedString *facilityattrib = [[NSMutableAttributedString alloc] initWithString:facilityText];
    [facilityattrib addAttribute:NSForegroundColorAttributeName value:[ColorConfigure globalBgColor] range:NSMakeRange(0, facilityText.length -1)];
    [facilityattrib addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(facilityText.length -1, 1)];
    facilityLabel.attributedText = facilityattrib;
    
    NSString *mapText = @"地图/周边>";
    NSMutableAttributedString *mapAttrib = [[NSMutableAttributedString alloc] initWithString:mapText];
    [mapAttrib addAttribute:NSForegroundColorAttributeName value:[ColorConfigure globalBgColor] range:NSMakeRange(0, mapText.length -1)];
    [mapAttrib addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(mapText.length -1, 1)];
    mapLabel.attributedText = mapAttrib;
    
    addressImageView.image = [UIImage imageNamed:kHotelDetailImageName];
}
- (void)updateImageUIWith:(NSInteger)num
{
    for(UIView *subview in [hotelImageView subviews])
    {
        [subview removeFromSuperview];
    }
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kImageItemWidth - 15, kImageItemWidth, 15)];
    titleLabel.font = [UIFont systemFontOfSize:10];
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = [NSString stringWithFormat:@"%d张   ",(int)num];
    titleLabel.backgroundColor = [ColorUtility colorWithRed:0 green:0 blue:0 alpha:0.5];
    [hotelImageView addSubview:titleLabel];
    UIImageView *cameraImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelDetailImageCamera"]];
    cameraImage.x = 4;
    cameraImage.centerY = titleLabel.height/2.0;
    [titleLabel addSubview:cameraImage];
}
@end
