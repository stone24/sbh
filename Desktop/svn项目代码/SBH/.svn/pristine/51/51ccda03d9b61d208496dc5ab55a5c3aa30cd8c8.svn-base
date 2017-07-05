//
//  BeRoomDetailModel.h
//  SideBenefit
//
//  Created by SBH on 15-3-11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, HotelDetailRoomState)
{
    HotelDetailRoomStateCanBeBooked = 0,
    HotelDetailRoomStateFullBooked = 1,
};
@interface BeRoomDetailModel : NSObject
// 企业id
@property (nonatomic, copy) NSString *SpENT;
@property (nonatomic, copy) NSString *ImageURL;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy) NSString *IsNoStop;
@property (nonatomic, copy) NSString *SalePrice;
@property (nonatomic, copy) NSString *RoomArea;
@property (nonatomic, copy) NSString *BroadnetAccess; //0没有 1免费无线 2免费有线 3收费有线 4收费无线
// 取消
@property (nonatomic, copy) NSString *CancelDes;
@property (nonatomic, copy) NSString *CancelState;
@property (nonatomic, copy) NSString *RoomName;
// 小括号
@property (nonatomic, copy) NSString *PolicyName;
// 价格政策
@property (nonatomic, copy) NSString *PolicyId;
@property (nonatomic, copy) NSString *HotelName;
@property (nonatomic, copy) NSString *HotelId;
@property (nonatomic, copy) NSString *RoomCode;
@property (nonatomic, copy) NSString *BedType;
@property (nonatomic, copy) NSString *priceguid;
@property (nonatomic, copy) NSString *JoinRoomId;
@property (nonatomic, copy) NSString *Facilities;
@property (nonatomic,copy)NSString *PolicyRemark;
@property (nonatomic, strong)NSString *broudbandStatus;
@property (nonatomic,assign)BOOL showNoStop;
@property (nonatomic,assign)BOOL showProtocal;
@property (nonatomic,assign)HotelDetailRoomState roomBookState;
@property (nonatomic,retain)NSString *bedWidthDescription;
// 将描述信息拆分存放数组
@property (nonatomic, strong) NSArray *desArray;
- (void)setModelDataWithDict:(NSDictionary *)dict;
@end
