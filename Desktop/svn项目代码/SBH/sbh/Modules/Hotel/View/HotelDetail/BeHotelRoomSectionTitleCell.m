//
//  BeRoomRow02Cell.m
//  SideBenefit
//
//  Created by SBH on 15-3-11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelRoomSectionTitleCell.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "CommonDefine.h"
#import "UIImageView+WebCache.h"

@interface BeHotelRoomSectionTitleCell ()
{
    UIImageView *roomIcon;
    UILabel *roomType;
    UILabel *roomDer;
    
    UILabel *RoomPrice;
    UIImageView *updownIcon;
}
@end
@implementation BeHotelRoomSectionTitleCell
+ (CGFloat)cellHeight
{
    return kHotelRoomSectionViewHeight;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeHotelRoomSectionTitleCellIdentifier";
    BeHotelRoomSectionTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[BeHotelRoomSectionTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        roomIcon = [[UIImageView alloc]initWithFrame:CGRectMake(13, 0, 50, 50)];
        roomIcon.centerY = kHotelRoomSectionViewHeight/2.0;
        [self addSubview:roomIcon];
        
        roomType= [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(roomIcon.frame) + 13, 5, kScreenWidth - CGRectGetMaxX(roomIcon.frame) - 13, 20)];
        roomType.font = [UIFont systemFontOfSize:15];
        [self addSubview:roomType];
        
        roomDer= [[UILabel alloc]initWithFrame:CGRectMake(roomType.x, CGRectGetMaxY(roomType.frame) + 2, 100, 30)];
        roomDer.font = [UIFont systemFontOfSize:11];
        roomDer.textColor = [UIColor lightGrayColor];
        roomDer.numberOfLines = 0;
        [self addSubview:roomDer];
        
        RoomPrice= [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 140, 0, 100, 30)];
        RoomPrice.centerY = kHotelRoomSectionViewHeight/2.0;
        RoomPrice.textAlignment = NSTextAlignmentRight;
        [self addSubview:RoomPrice];
        
        updownIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhankai_a_icon"]];
        updownIcon.centerX = kScreenWidth - 21;
        updownIcon.centerY = kHotelRoomSectionViewHeight/2.0;
        [self addSubview:updownIcon];
        }
    return self;
}
- (void)setSectionModel:(BeHotelDetailSectionModel *)sectionModel
{
    _sectionModel = sectionModel;
    [roomIcon sd_setImageWithURL:[NSURL URLWithString:_sectionModel.Room_Image]placeholderImage:[UIImage imageNamed:@"hotellist_cell_placeHolderImage"]];
    roomIcon.contentMode = UIViewContentModeScaleAspectFill;
    roomIcon.clipsToBounds = YES;

    roomType.text = _sectionModel.Room_Name;
    
    NSString *priceIcon = @"￥";
    NSString *priceString = _sectionModel.Dr_Amount;
    NSString *priceTitle = @"  起";
    NSMutableAttributedString *priceAttrib = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",priceIcon,priceString,priceTitle]];
    [priceAttrib setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(0,[priceIcon length])];
    [priceAttrib setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:17]} range:NSMakeRange([priceIcon length],[priceString length])];
    [priceAttrib setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange([priceIcon length]+[priceString length],[priceTitle length])];
    [priceAttrib addAttribute:NSForegroundColorAttributeName value:[ColorConfigure loginButtonColor] range:NSMakeRange(0, priceIcon.length + priceString.length)];
    [priceAttrib addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(priceIcon.length + priceString.length,priceTitle.length)];
    RoomPrice.attributedText = priceAttrib;
    if(sectionModel.cellArray.count > 0)
    {
        BeHotelDetailRoomListModel *listModel = sectionModel.cellArray.firstObject;
        roomDer.text = [NSString stringWithFormat:@"%@m² %@\n%@",listModel.Room_Size,listModel.Room_BedName,listModel.RoomNetWorkChange];
    }
    if(sectionModel.isSread)
    {
        updownIcon.transform = CGAffineTransformRotate(updownIcon.transform, -M_PI);
    }
    else
    {
        updownIcon.transform = CGAffineTransformIdentity;
    }
}
@end
