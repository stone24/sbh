//
//  BeHotelOrderModel.h
//  SideBenefit
//
//  Created by SBH on 15-3-10.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kStatusYiqueren         @"已确认"
#define kStatusYituiding        @"已退订"
#define kStatusYiquxiao         @"已取消"
#define kStatusDaiqueren        @"待确认"
#define kStatusChulizhong       @"处理中"
#define kStatusDaizhifu         @"待支付"
#define kStatusToAudit          @"待审批"
#define kStatusHaveAudit        @"待审批(已提交审批，等待审批通过)"
#define kStatusApply            @"申请单"

#define kColorYiqueren          [ColorUtility colorFromHex:0xbababa]
#define kColorYituiding         [ColorUtility colorFromHex:0xbababa]
#define kColorYiquxiao          [ColorUtility colorFromHex:0xbababa]
#define kColorDaiqueren         [ColorUtility colorFromHex:0xfd9c14]
#define kColorChulizhong        [ColorUtility colorFromHex:0xfc7876]
#define kColorDaizhifu          [ColorUtility colorFromHex:0xa2dd74]

@interface BeHotelOrderModel : NSObject
@property (nonatomic, strong) NSString *OrderNo;
@property (nonatomic, strong) NSString *CheckOutDate;
@property (nonatomic, strong) NSString *RoomCount;
@property (nonatomic, strong) NSString *CheckInDate;
@property (nonatomic, strong) NSString *OrderStatus;
@property (nonatomic, strong) NSString *RoomName;
@property (nonatomic, strong) NSString *Address;
// 小括号
@property (nonatomic, strong) NSString *PolicyName;
@property (nonatomic, strong) NSString *HotelName;
@property (nonatomic, strong) NSString *OrderSumFee;
@property (nonatomic, strong) NSString *HotelId;
@property (nonatomic, strong) NSString *CreateTime;

@property (nonatomic, strong) NSString *exRoomType;
@property (nonatomic,strong) NSString *PayStatus;
@property (nonatomic, assign) int exDays;
//// 是否被关注
//@property (nonatomic, assign) BOOL careBtnSelect;
@property (nonatomic,retain)UIColor *statusColor;
@property (nonatomic,retain)NSString *cancelPolicy;
@property (nonatomic,retain)NSArray *personArray;//入住人
@property (nonatomic,retain)NSArray *contanctArray;//联系人
@property (nonatomic,retain)NSString *starRate;
@property (nonatomic,retain)NSString *starDescription;
@property (nonatomic,assign)int PayStatusNum;
@property (nonatomic,assign)int ExamineStatus;
- (void)setOrderListItemWithDict:(NSDictionary *)dict;
- (void)setDetailDataWithDict:(NSDictionary *)dict;

@end
