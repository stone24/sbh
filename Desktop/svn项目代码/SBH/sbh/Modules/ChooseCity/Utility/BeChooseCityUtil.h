//
//  BeChooseCityUtil.h
//  sbh
//
//  Created by RobinLiu on 15/4/28.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeChooseCityListItem.h"

#define kTicketDepartTitle @"出发城市"
#define kTicketReachTitle @"到达城市"
#define kHotelStayTitle @"选择城市"

typedef NS_ENUM(NSInteger, ChooseCitySourceType)
{
    kTicketDepartureType = 0,
    kTicketReachType = 1,
    kHotelStayType = 2,
    kTrainDepartureType = 3,
    kTrainArriveType = 4,
};
typedef void (^CityBlockData)(BeChooseCityListItem *listItemData);
@interface BeChooseCityUtil : NSObject
+ (BeChooseCityUtil *)sharedInstance;
@property (nonatomic,retain)NSMutableDictionary *ticketDict;
@property (nonatomic,retain)NSMutableArray *ticketDictKeyArray;
- (void)getCityDataWithType:(ChooseCitySourceType)type andCallbackData:(CityBlockData)block;
- (void)getTicketCityWithName:(NSString *)name  andCallbackData:(void (^)(CityData *))cityBlock;
- (void)getTrainStationWithName:(NSString *)name andCallbackData:(void (^)(CityData *))cityBlock;
@end
