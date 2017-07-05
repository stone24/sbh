//
//  TiketOrderInfo.m
//  sbh
//
//  Created by musmile on 14-7-7.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "TicketOrderInfo.h"
#import "CommonMethod.h"
#import "CalendarDayModel.h"
#import "SBHHttp.h"
#import "ServerConfigure.h"
#import "JSONKit.h"
#import "ServerFactory.h"

@implementation TicketOrderInfo

-(id)init
{
    self = [super init];
    if(self)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([[defaults objectForKey:kReachCityName] length] != 0) {
            _iFromCityName = [defaults objectForKey:kStartCityName];
            _iFromCityCode = [defaults objectForKey:kStartCityCode];
            _iToCityName   = [defaults objectForKey:kReachCityName];
            _iToCityCode   = [defaults objectForKey:kReachCityCode];
        } else {
            _iFromCityName = @"北京";
            _iFromCityCode = @"PEK";
            _iToCityName   = @"深圳";
            _iToCityCode   = @"SZX";
        }
        _departureCity = [[CityData alloc]init];
        _departureCity.iCityCode = _iFromCityCode;
        _departureCity.iCityName = _iFromCityName;
        _arriveCity = [[CityData alloc]init];
        _arriveCity.iCityCode = _iToCityCode;
        _arriveCity.iCityName = _iToCityName;
        _iFromAirportCode = [_iFromCityCode copy];
        _iToAirportCode  = [_iToCityCode copy];
        _queryTicketDate = [[NSString alloc]init];
        NSDate *date = [NSDate date];
        date = [date dateByAddingTimeInterval:kStartIntervalDate*3600*24];
        _iStartTime = [CommonMethod stringFromDate:date WithParseStr:kFormatYYYYMMDD];
        _iStartDate = date;
        date = [date dateByAddingTimeInterval:kReturnIntervalDate*3600*24];
        _iEndDate = date;
        _iEndTime = [CommonMethod stringFromDate:date WithParseStr:kFormatYYYYMMDD];
        _iShippingspace= @"";
        _iTravelType   = @"";
        _iAirCompany   = @"";
        _iAirCompanyCode=@"";
        _isSingle      = YES;
        [self setCabinType:kAllClassType];
        [self setTravelReason:kTravelReasonTypeOnBusiness];
        _ticketBookType = kOneWayTicketType;
        _tripType = kAirTripTypeGoing;
    }
    return self;
}
- (void)changeDateStartDateAndEndDate:(NSDate *)date
{
    if (_tripType == kAirTripTypeGoing)
    {
        [self setIStartDate:date];
    }
    else
    {
        [self setIEndDate:date];
    }
}
- (void)setIStartDate:(NSDate *)iStartDate
{
    _iStartDate = iStartDate;
    _iStartTime = [CommonMethod stringFromDate:iStartDate WithParseStr:kFormatYYYYMMDD];
}
- (void)setIEndDate:(NSDate *)iEndDate
{
    _iEndDate = iEndDate;
    _iEndTime = [CommonMethod stringFromDate:iEndDate WithParseStr:kFormatYYYYMMDD];
}
+ (TicketOrderInfo *)sharedInstance
{
    static dispatch_once_t onceToken;
    static TicketOrderInfo *_instance;
    dispatch_once(&onceToken, ^{
        if(_instance == nil)
        {
            _instance = [[TicketOrderInfo alloc]init];
        }
    });
    return _instance;
}
- (void)setCabinType:(AircraftCabinType)cabinType
{
    _cabinType = cabinType;
    switch (cabinType) {
        case kAllClassType:
        {
            _aircraftCabin = kAllClassText;
        }
            break;
        case kBussinessClassType:
        {
            _aircraftCabin = kBussinessClassText;
        }
            break;
        case kEconomyClassType:
        {
            _aircraftCabin = kEconomyClassText;
        }
            break;
        default:
            break;
    }
}
- (void)setTravelReason:(TravelReasons)travelReason
{
    _travelReason = travelReason;
    switch (travelReason) {
        case kTravelReasonTypeOnBusiness:
        {
            _travelReasonString = kTravelReasonOnBussinessText;
        }
            break;
        case kTravelReasonTypePrivate:
        {
            _travelReasonString = kTravelReasonPrivateText;
        }
            break;
        default:
            break;
    }
}
- (void)updateDepartureCityWith:(CityData *)acity
{
    _iFromCityName = acity.iCityName;
    _iFromCityCode = acity.iCityCode;
    _iFromAirportCode = acity.iAirportCode;
    _departureCity = acity;
}
- (void)updateReachCityWith:(CityData *)acity
{
    _iToCityName = acity.iCityName;
    _iToCityCode = acity.iCityCode;
    _iToAirportCode = acity.iAirportCode;
    _arriveCity = acity;
}
- (void)exchangeCity
{
    NSString *tmcityName = _iFromCityName;
    _iFromCityName = _iToCityName;
    _iToCityName = tmcityName;
    
    NSString *tmcityCode = _iFromCityCode;
    _iFromCityCode = _iToCityCode;
    _iToCityCode = tmcityCode;
    
    NSString *tmairportcode = _iFromAirportCode;
    _iFromAirportCode = _iToAirportCode;
    _iToAirportCode = tmairportcode;
}
- (void)updateStartTimeWith:(CalendarDayModel *)model
{
    _iStartTime = [model toString];
    _iStartDate = [model date];
    NSDate *returnDate = [[model date] dateByAddingTimeInterval:kReturnIntervalDate*3600*24];
    _iEndDate = returnDate;
    _iEndTime = [CommonMethod stringFromDate:returnDate WithParseStr:kFormatYYYYMMDD];
}
- (void)updateEndTimeWith:(CalendarDayModel *)model
{
    _iEndTime = [model toString];
    _iEndDate = [model date];
}
- (void)verifyInquiryWithBlock:(VerifyInformationBlock)block
{
    if ([_iFromCityName isEqualToString:_iToCityName])
    {
        block(kErrorCityOfTheTameName);
        return;
    }
    if([_iAirCompany length] == 0)
    {
        block(kErrorAirCompanyIsNull);
        return;
    }
    if([_iFromCityName length] == 0)
    {
        block(kErrorFromCityNameIsNull);
        return;
    }
    if([_iToCityName length] == 0)
    {
        block(kErrorToCityNameIsNull);
        return;
    }
    if([_iStartTime length] == 0)
    {
        block(kErrorStartTimeIsNull);
        return;
    }
    if(_ticketBookType == kRoundTripTicketType
           && _iEndTime.length == 0)
    {
        block(kErrorEndTimeIsNull);
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_iFromCityName forKey:kStartCityName];
    [defaults setObject:_iToCityName forKey:kReachCityName];
    [defaults setObject:_iFromCityCode forKey:kStartCityCode];
    [defaults setObject:_iToCityCode forKey:kReachCityCode];
    block(@"");
    return;
}
- (void)queryAirListWithBlock:(ResultBlock)returnBlock
{
    NSMutableDictionary *objectDict = [NSMutableDictionary dictionary];
    [self queryAllClassListWithBlock:^(NSDictionary *block)
     {
         if([[block stringValueForKey:@"guid"] length] != 0)
         {
             {
                 [objectDict setObject:[block objectForKey:@"guid"] forKey:@"guid"];
                 NSMutableDictionary *allClass = [block objectForKey:@"item"];
                 [objectDict setObject:allClass forKey:[NSNumber numberWithInt:kAllClassType]];
                 [self queryFirstClassListWithGuid:[block objectForKey:@"guid"] andBlock:^(NSDictionary *dictBlock)
                  {
                      if([[block stringValueForKey:@"guid"] length] != 0)
                      {
                          NSMutableDictionary *firstClass = [dictBlock objectForKey:@"item"];
                          [objectDict setObject:firstClass forKey:[NSNumber numberWithInt:kBussinessClassType]];
                          returnBlock(objectDict);
                      }
                      else
                      {
                          [objectDict addEntriesFromDictionary:dictBlock];
                          returnBlock(objectDict);
                      }
                  }];
             }
         }
         else
         {
             [objectDict addEntriesFromDictionary:block];
             returnBlock(objectDict);
         }
    }];
}

- (void)queryAllClassListWithBlock:(ResultBlock)block
{
    // 判断是否是saas4
    NSString *requestUrl = @"";
    if ([[GlobalData getSharedInstance].userModel.saas isEqualToString:@"3"] || [GlobalData getSharedInstance].userModel.isLogin == NO) {
        requestUrl = kSearchAirFlightListSaas4Url;
    } else {
        requestUrl = kSearchAirFlightListUrl;
    }
    NSString *path = [NSString stringWithFormat:@"%@%@",kServerHost, requestUrl];
    NSDate *iCurrentDate = [NSDate date];
    NSArray *dateArray = [NSArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    switch (_tripType) {
        case kAirTripTypeGoing:
        {
            [dict setObject:_iFromCityCode forKey:@"depairports"];
            [dict setObject:_iToCityCode forKey:@"arrairport"];
            iCurrentDate = [CommonMethod dateFromString:[GlobalData getSharedInstance].iTiketOrderInfo.iStartTime WithParseStr:@"yyyy-MM-dd"];
            dateArray = [[CommonMethod stringFromDate:iCurrentDate WithParseStr:kFormatYYYYMMDD] componentsSeparatedByString:@"-" ];
        }  
            break;
        case kAirTripTypeReturn:
        {
            [dict setObject:_iToCityCode forKey:@"depairports"];
            [dict setObject:_iFromCityCode forKey:@"arrairport"];
            iCurrentDate = [CommonMethod dateFromString:[GlobalData getSharedInstance].iTiketOrderInfo.iEndTime WithParseStr:@"yyyy-MM-dd"];
            dateArray = [[CommonMethod stringFromDate:iCurrentDate WithParseStr:kFormatYYYYMMDD] componentsSeparatedByString:@"-"];
        }
            break;
        default:
            break;
    }
    
    NSString *tokenStr = @"";
    if ([GlobalData getSharedInstance].token.length != 0) {
        tokenStr = [GlobalData getSharedInstance].token;
    }
    [dict setObject:tokenStr forKey:@"usertoken"];
    [dict setObject:dateArray[0] forKey:@"depyear"];
    [dict setObject:dateArray[1] forKey:@"depmonth"];
    [dict setObject:dateArray[2] forKey:@"depday"];
    [dict setObject:_iAirCompanyCode forKey:@"carriercode"];
     NSString *classCode = [NSString stringWithFormat:@"%ld",(long)kAllClassType];
    [dict setObject:classCode forKey:@"classRating"];
    [dict setObject:[NSString stringWithFormat:@"%ld", (long)[GlobalData getSharedInstance].iTiketOrderInfo.travelReason] forKey:@"op"];
    [[ServerFactory getServerInstance:@"SBHHttp"]postPath:path withParameters:dict showHud:NO success:^(NSDictionary *responseDict)
    {
        block(responseDict);
    }failure:^(NSError *error)
    {
        block(@{@"code":kNetworkAbnormal});
    }];
}


- (void)queryFirstClassListWithGuid:(NSString *)guid andBlock:(ResultBlock)block
{
    // 判断是否是saas4
    NSString *requestUrl = @"";
    if ([[GlobalData getSharedInstance].userModel.saas isEqualToString:@"3"] || [GlobalData getSharedInstance].userModel.isLogin == NO) {
        requestUrl = kSearchAirFlightListSaas4Url;
    } else {
        requestUrl = kSearchAirFlightListUrl;
    }
    NSString *path = [NSString stringWithFormat:@"%@%@",kServerHost,requestUrl];
    NSDate *iCurrentDate = [NSDate date];
    NSArray *dateArray = [NSArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    switch (_tripType) {
        case kAirTripTypeGoing:
        {
            [dict setObject:_iFromCityCode forKey:@"depairports"];
            [dict setObject:_iToCityCode forKey:@"arrairport"];
            iCurrentDate = [CommonMethod dateFromString:[GlobalData getSharedInstance].iTiketOrderInfo.iStartTime WithParseStr:@"yyyy-MM-dd"];
            dateArray = [[CommonMethod stringFromDate:iCurrentDate WithParseStr:kFormatYYYYMMDD] componentsSeparatedByString:@"-"];
        }
            break;
        case kAirTripTypeReturn:
        {
            [dict setObject:_iToCityCode forKey:@"depairports"];
            [dict setObject:_iFromCityCode forKey:@"arrairport"];
            iCurrentDate = [CommonMethod dateFromString:[GlobalData getSharedInstance].iTiketOrderInfo.iEndTime WithParseStr:@"yyyy-MM-dd"];
            dateArray = [[CommonMethod stringFromDate:iCurrentDate WithParseStr:kFormatYYYYMMDD] componentsSeparatedByString:@"-"];
        }
            break;
        default:
            break;
    }
    if(guid.length!=0)
    {
        [dict setObject:guid forKey:@"guidow"];
    }    
    NSString *tokenStr = @"";
    if ([GlobalData getSharedInstance].token.length != 0) {
        tokenStr = [GlobalData getSharedInstance].token;
    }
    [dict setObject:tokenStr forKey:@"usertoken"];
    [dict setObject:dateArray[0] forKey:@"depyear"];
    [dict setObject:dateArray[1] forKey:@"depmonth"];
    [dict setObject:dateArray[2] forKey:@"depday"];
    [dict setObject:_iAirCompanyCode forKey:@"carriercode"];
    NSString *classCode = [NSString stringWithFormat:@"%ld",(long)kBussinessClassType];
    [dict setObject:classCode forKey:@"classRating"];
    [dict setObject:@"json" forKey:@"format"];
    [dict setObject:@"ios" forKey:@"platform"];
    [dict setObject:[NSString stringWithFormat:@"%ld", (long)[GlobalData getSharedInstance].iTiketOrderInfo.travelReason] forKey:@"op"];
    [[ServerFactory getServerInstance:@"SBHHttp"]postPath:path withParameters:dict showHud:NO success:^(NSDictionary *responseDict)
     {
         block(responseDict);
     }failure:^(NSError *error)
     {
         block(@{@"code":kNetworkAbnormal});
     }];
}
@end
