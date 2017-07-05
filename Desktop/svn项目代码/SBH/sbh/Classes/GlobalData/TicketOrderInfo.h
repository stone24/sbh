//
//  TiketOrderInfo.h
//  sbh
//
//  Created by musmile on 14-7-7.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAllClassText @"所有舱位"
#define kBussinessClassText @"商务舱/头等舱"
#define kEconomyClassText @"经济舱"

#define kTravelReasonOnBussinessText @"因公"
#define kTravelReasonPrivateText @"因私"

#define kStartIntervalDate 1//默认是明天
#define kReturnIntervalDate 2//默认与出发间隔两天

#define kErrorCityOfTheTameName @"出发城市与到达城市不能为同一城市"
#define kErrorAirCompanyIsNull @"请选择航空公司！"
#define kErrorFromCityNameIsNull @"请选择出发城市！"
#define kErrorToCityNameIsNull @"请选择到达城市!"
#define kErrorStartTimeIsNull @"请选择出发日期！"
#define kErrorEndTimeIsNull @"请选择回程日期！"
#define kTicketErrorCode @"网络异常"
@class CalendarDayModel;

typedef void (^VerifyInformationBlock) (NSString *verifyBlock);
typedef void (^ResultBlock)(id block);
typedef NS_ENUM(NSInteger, AircraftCabinType)
{
    kAllClassType = 0,
    kBussinessClassType = 2,//商务舱
    kEconomyClassType = 1,
};
typedef NS_ENUM(NSInteger, TravelReasons)
{
    kTravelReasonTypePrivate = 0,
    kTravelReasonTypeOnBusiness = 1,
};
typedef NS_ENUM(NSInteger, AirTicketBookType)
{
    kOneWayTicketType = 1,
    kRoundTripTicketType = 2,
};
typedef NS_ENUM(NSInteger, AirTripType)
{
    kAirTripTypeGoing = 1,
    kAirTripTypeReturn = 2,
};
@interface TicketOrderInfo : NSObject

@property (nonatomic,assign)AircraftCabinType cabinType;//舱位类型
@property (nonatomic,assign)AirTripType tripType;//判断是去程还是回程
@property (nonatomic,strong)NSString *aircraftCabin;
@property (nonatomic,strong)NSString *travelReasonString;
@property (nonatomic,assign) TravelReasons travelReason;//出行事由
@property (nonatomic,assign) AirTicketBookType   ticketBookType;//是单程还是往返
@property(nonatomic,strong) NSString * iFromCityName;  //出发城市名称
@property(nonatomic,strong) NSString * iFromCityCode;  //出发城市编码
@property(nonatomic,strong) NSString * iFromAirportCode;//出发城市机场编码
@property(nonatomic,strong) NSString * iToCityName;    //到达城市名称
@property(nonatomic,strong) NSString * iToCityCode;    //到达城市编码
@property(nonatomic,strong) NSString * iToAirportCode;//出发城市机场编码
@property(nonatomic,strong) NSString * iStartTime;     //开始时间
@property(nonatomic,strong) NSDate *iStartDate;
@property(nonatomic,strong) NSDate *iEndDate;
@property(nonatomic,strong) NSString * iEndTime;       //结束时间
@property(nonatomic,strong) NSString * iShippingspace; //仓位
@property(nonatomic,strong) NSString * iTravelType;    //航程类型
@property(nonatomic,strong) NSString * iAirCompany;    //航空公司
@property(nonatomic,strong) NSString * iAirCompanyCode;//航空公司代码
@property(nonatomic,readwrite)BOOL isSingle; //是否是单程
@property (nonatomic,retain)CityData *departureCity;
@property (nonatomic,retain)CityData *arriveCity;
@property (nonatomic,retain)NSMutableArray *airCompanyArray;
@property (nonatomic,retain)NSString *queryTicketDate;
+ (TicketOrderInfo *)sharedInstance;
- (void)updateDepartureCityWith:(CityData *)city;
- (void)updateReachCityWith:(CityData *)city;
- (void)exchangeCity;
- (void)updateStartTimeWith:(CalendarDayModel *)model;
- (void)updateEndTimeWith:(CalendarDayModel *)model;
- (void)verifyInquiryWithBlock:(VerifyInformationBlock )block;
- (void)queryAirListWithBlock:(ResultBlock)block;
- (void)queryAllClassListWithBlock:(ResultBlock)block;
- (void)queryFirstClassListWithGuid:(NSString *)guid andBlock:(ResultBlock)block;
- (void)changeDateStartDateAndEndDate:(NSDate *)date;
@end
