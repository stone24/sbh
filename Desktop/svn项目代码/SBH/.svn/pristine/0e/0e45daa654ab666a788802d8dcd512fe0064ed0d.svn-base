//
//  BeTicketQueryDataSource.h
//  sbh
//
//  Created by RobinLiu on 15/4/16.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityData.h"

#define kFilterNonstopFlightTitle @"仅看直飞"
#define kFilterTakeOffTimeTitle @"起飞时间"
#define kFilterAirportTitle @"机场"
#define kFilterCabinTitle @"舱位"
#define kFilterAirlineCompanyTitle @"航空公司"

#define kFilterConditionUnlimited @"不限"

#define kFilterConditionDate1 @"00:00-6:00"
#define kFilterConditionDate2 @"6:00-12:00"
#define kFilterConditionDate3 @"12:00-18:00"
#define kFilterConditionDate4 @"18:00-00:00"

#define kFilterConditionCabin0 @"所有"
#define kFilterConditionCabin1 @"经济舱"
#define kFilterConditionCabin2 @"公务舱/头等舱"

typedef NS_ENUM(NSInteger, TicketQueryNonstopType)
{
    kTicketQueryNonstopUnlimited = 1,//不限
    kTicketQueryNonstopYes = 0,//直飞
};

@interface BeTicketQueryDataSource : NSObject
+ (BeTicketQueryDataSource *)sharedInstance;
@property (nonatomic,assign)TicketQueryNonstopType selectNonstopType;
@property (nonatomic,retain)NSString *selectItemTitle;
@property (nonatomic,retain)NSString *departCity;
@property (nonatomic,retain)NSString *arriveCity;

@property (nonatomic,retain)NSMutableArray *selectedDateArray;
@property (nonatomic,retain)NSString *selectedCabin;
@property (nonatomic,retain)NSMutableArray *selectedDepartureAirportArray;
@property (nonatomic,retain)NSMutableArray *selectedArriveAirportArray;
@property (nonatomic,retain)NSMutableArray *selectedAirCompanyArray;

@property (nonatomic,retain)NSMutableArray *itemTitleArray;
@property (nonatomic,retain)NSMutableArray *departureAirportArray;
@property (nonatomic,retain)NSMutableArray *arriveAirportArray;
@property (nonatomic,retain)NSMutableArray *cabinConditionArray;
@property (nonatomic,retain)NSMutableArray *takeOffTimeConditionArray;
@property (nonatomic,retain)NSMutableArray *airlineCompanyConditionArray;
- (void)initConfigureCondition;
- (void)removeItemArrayCondition:(NSString *)condition;
- (void)itemArrayAddAllConditions;
@end
