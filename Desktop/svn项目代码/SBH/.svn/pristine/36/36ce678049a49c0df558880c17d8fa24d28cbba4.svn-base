//
//  BeHotelRoomListFrame.h
//  sbh
//
//  Created by RobinLiu on 16/9/20.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeHotelDetailSectionModel.h"
@class BeHotelRoomListDisplayModel;
@interface BeHotelRoomListFrame : NSObject

@property (nonatomic,strong)BeHotelRoomListDisplayModel *displayModel;
@property (nonatomic,assign,readonly)CGRect HotelNameFrame;
@property (nonatomic,assign,readonly)CGRect guaranteeFrame;
@property (nonatomic,assign,readonly)CGRect priceFrame;
@property (nonatomic,assign,readonly)CGRect payFrame;
@property (nonatomic,assign,readonly)CGRect cancelFrame;
@property (nonatomic,assign,readonly)CGRect bookFrame;
@property (nonatomic,assign,readonly)CGFloat cellHeight;

@end


@interface BeHotelRoomListDisplayModel : NSObject
@property (nonatomic,strong)BeHotelDetailRoomListModel *listModel;
@property (nonatomic,strong,readonly)NSString *HotelName;
@property (nonatomic,strong,readonly)NSString *priceString;
@property (nonatomic,strong,readonly)NSString *payString;
@property (nonatomic,strong,readonly)NSString *cancelString;
@property (nonatomic,strong,readonly)NSString *bookString;
@property (nonatomic,strong,readonly)NSString *guaranteeString;
@end
