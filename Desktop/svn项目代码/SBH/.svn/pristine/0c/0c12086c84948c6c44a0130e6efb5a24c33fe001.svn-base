//
//  BeHotelListIterm.h
//  SideBenefit
//
//  Created by RobinLiu on 15/3/14.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeHotelListItem : NSObject

@property (nonatomic,retain)NSString *guid;

@property (nonatomic,retain)NSString *hotelId;
@property (nonatomic,retain)NSString *hotelName;
@property (nonatomic,retain)NSString *hotelAddress;
@property (nonatomic,retain)NSString *googleLat;
@property (nonatomic,retain)NSString *googleLon;
@property (nonatomic,retain)NSString *price;
@property (nonatomic,strong)NSString *addressAdditional;
@property (nonatomic,retain)NSString *reviewScore;//评分

@property (nonatomic,strong)NSString *Hotel_SBHStar;//准星级
@property (nonatomic,strong)NSString *Hotel_Star;//星级
@property (nonatomic,retain)NSDictionary *facilities;//设施列表
@property (nonatomic,retain)NSString *hotelImageUrl;

@property (nonatomic,retain)NSString *cityId;
@property (nonatomic,strong)NSString *cityName;
@property (nonatomic,strong)NSString *Hotel_Introduce;
@property (nonatomic,strong)NSString *CheckInDate;
@property (nonatomic,strong)NSString *CheckOutDate;
@property (nonatomic,strong)NSString *TravelType;
@property (nonatomic,assign)BOOL isOnBusiness;//是否是因公

@property (nonatomic,assign)double distance;

/**
 * 搜索的类型  关键字接口 1名称 2商圈 3品牌
 */
@property (nonatomic,strong)NSString *SearchType;

/**
 * 是否支付预订
 */
@property (nonatomic,assign)BOOL canBook;
/**
 * 参数赋值
 */
- (void)setItemWithDict:(NSDictionary *)dict;
/**
 * 获取酒店设施的图片
 */
- (UIView *)getFacilitiesImageView;
@end
