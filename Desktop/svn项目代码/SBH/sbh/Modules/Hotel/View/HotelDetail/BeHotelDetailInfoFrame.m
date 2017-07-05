//
//  BeHotelDetailInfoFrame.m
//  sbh
//
//  Created by RobinLiu on 15/12/10.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelDetailInfoFrame.h"
#import "CommonDefine.h"

#define defaultMargin 10

@implementation BeHotelDetailInfoFrame
-(void)setListData:(BeHotelListItem *)listData
{
    _listData = listData;
    
    CGFloat nameX = kImageItemSpace;
    CGFloat nameY = kImageItemSpace;
    CGFloat nameW = kScreenWidth - kImageItemSpace * 3 - kImageItemWidth;
    
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    attribute[NSFontAttributeName] = kHotelNameFont;
    CGRect sumRect = [_listData.hotelName boundingRectWithSize:CGSizeMake(nameW, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attribute context:nil];
    /**
     * 酒店名称
     */
    _nameLabelframe = CGRectMake(nameX, nameY, nameW, sumRect.size.height);
    
    /**
     * 酒店图片
     */
    _hotelImageViewframe = CGRectMake(kScreenWidth -kImageItemSpace  - kImageItemWidth , kImageItemSpace, kImageItemWidth, kImageItemWidth);
    
    /**
     *  评分
     */
    _scoreLabelframe = CGRectMake(_nameLabelframe.origin.x ,CGRectGetMaxY(_nameLabelframe) + 5, 160, 20);
    
    /**
     *  分割线1
     */
    _sepLine1frame = CGRectMake(_nameLabelframe.origin.x ,CGRectGetMaxY(_scoreLabelframe) + 8, _nameLabelframe.size.width, 0.3);
    /**
     *  设施
     */
    _facilityViewframe = CGRectMake(_nameLabelframe.origin.x ,CGRectGetMaxY(_sepLine1frame), 120, 27);
    
    /**
     *  设施按钮
     */
    _facilityLabelframe = CGRectMake(kScreenWidth - kImageItemWidth - kImageItemSpace * 2 - 70 ,_facilityViewframe.origin.y, 70, 27);
    /**
     *  分割线2
     */
    _sepLine2frame = CGRectMake(0,CGRectGetMaxY(_facilityViewframe), kScreenWidth, 0.3);;
    
    /**
     *  地址图片
     */
    UIImage *image = [UIImage imageNamed:kHotelDetailImageName];
    _addressImageViewframe = CGRectMake(_nameLabelframe.origin.x ,CGRectGetMaxY(_sepLine2frame) + 9, image.size.width, image.size.height);
    
    /**
     *  地址
     */
    CGFloat addressX = CGRectGetMaxX(_addressImageViewframe) + 5;
    CGFloat addressW = kScreenWidth - addressX - 90.0f;
    sumRect = [_listData.hotelAddress boundingRectWithSize:CGSizeMake(nameW, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:kHotelContentFont} context:nil];
    _addressLabelframe = CGRectMake(addressX, CGRectGetMaxY(_sepLine2frame)+ 8, addressW, sumRect.size.height);
    
    /**
     *  地图
     */
    sumRect = [@"地图/周边>" boundingRectWithSize:CGSizeMake(nameW, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:kHotelContentFont} context:nil];
    _mapLabelframe = CGRectMake(kScreenWidth - 90, _addressLabelframe.origin.y, 90, sumRect.size.height);
    
    
    /**
     *  cell的高度
     */
    _cellHeight = CGRectGetMaxY(_addressLabelframe) + 10;
    
}
@end
