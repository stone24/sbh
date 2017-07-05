//
//  BeTicketQueryResultModel.m
//  sbh
//
//  Created by RobinLiu on 15/4/16.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTicketQueryResultModel.h"
#import "NSDictionary+Additions.h"
#import "FMDatabase.h"

#define kTicketQueryDefaultValue @""
#define kTicketQueryAirportTaxaDefaultValue @"0"
@implementation BeTicketQueryResultModel
- (void)setModelWith:(NSDictionary *)dict
{
    _FlightNo = [dict stringValueForKey:@"FlightNo" defaultValue:kTicketQueryDefaultValue];
    _DepartureDate = [dict stringValueForKey:@"DepartureDate" defaultValue:kTicketQueryDefaultValue];
    _ArrivalDate = [[[dict stringValueForKey:@"ArrivalDate" defaultValue:kTicketQueryDefaultValue] componentsSeparatedByString:@"T"] firstObject];
    _DepartureTime = [dict stringValueForKey:@"DepartureTime" defaultValue:kTicketQueryDefaultValue];
    _ArrivalTime = [dict stringValueForKey:@"ArrivalTime" defaultValue:kTicketQueryDefaultValue];
    _departureInt = [_DepartureTime intValue];
    _arrivalInt = [_ArrivalTime intValue];
    _DepAirport = [dict stringValueForKey:@"DepAirport" defaultValue:kTicketQueryDefaultValue];
    _ArrAirport = [dict stringValueForKey:@"ArrAirport" defaultValue:kTicketQueryDefaultValue];
    _DepAirportName = [dict stringValueForKey:@"DepAirportName" defaultValue:kTicketQueryDefaultValue];
    _ArrAirportName = [dict stringValueForKey:@"ArrAirportName" defaultValue:kTicketQueryDefaultValue];
    _BoardPointAT = [dict stringValueForKey:@"BoardPointAT" defaultValue:kTicketQueryDefaultValue];
    _OffPointAT = [dict stringValueForKey:@"OffPointAT" defaultValue:kTicketQueryDefaultValue];
    _FlightTime = [dict stringValueForKey:@"FlightTime" defaultValue:kTicketQueryDefaultValue];
    _Aircraft = [dict stringValueForKey:@"Aircraft" defaultValue:kTicketQueryDefaultValue];
    _AircraftName = [dict stringValueForKey:@"AircraftName" defaultValue:kTicketQueryDefaultValue];
    _AircraftMode = [dict stringValueForKey:@"AircraftMode" defaultValue:kTicketQueryDefaultValue];
    _Carrier = [dict stringValueForKey:@"Carrier" defaultValue:kTicketQueryDefaultValue];
    _CarrierSName = [dict stringValueForKey:@"CarrierSName" defaultValue:kTicketQueryDefaultValue];
    if(_CarrierSName.length == 0)
    {
         _CarrierSName = [self getCarrierSNameWith:[_FlightNo substringToIndex:2]];
    }
    
    if([dict objectForKey:@"AirportTaxa"] != nil)
    {
        _AirportTaxa = [dict stringValueForKey:@"AirportTaxa" defaultValue:kTicketQueryAirportTaxaDefaultValue];
    }
    else if([dict objectForKey:@"AirportTaxA"] != nil)
    {
        _AirportTaxa = [dict stringValueForKey:@"AirportTaxA" defaultValue:kTicketQueryAirportTaxaDefaultValue];
    }
    else
    {
        _AirportTaxa = [dict stringValueForKey:@"AirportTaxa" defaultValue:kTicketQueryAirportTaxaDefaultValue];
    }
    
    if([dict objectForKey:@"FuelsurTaxa"] != nil)
    {
        _FuelsurTaxa = [dict stringValueForKey:@"FuelsurTaxa" defaultValue:kTicketQueryAirportTaxaDefaultValue];
    }
    else if([dict objectForKey:@"FuelsurTaxA"] != nil)
    {
        _FuelsurTaxa = [dict stringValueForKey:@"FuelsurTaxA" defaultValue:kTicketQueryAirportTaxaDefaultValue];
    }
    else
    {
        _FuelsurTaxa = [dict stringValueForKey:@"FuelsurTaxa" defaultValue:kTicketQueryAirportTaxaDefaultValue];

    }
    _guid = [dict stringValueForKey:@"guid" defaultValue:kTicketQueryDefaultValue];
    _Seat = [dict stringValueForKey:@"Seat" defaultValue:kTicketQueryDefaultValue];
    _hfb = [dict stringValueForKey:@"hfb" defaultValue:kTicketQueryDefaultValue];
    NSString *tempString = [dict stringValueForKey:@"minprice" defaultValue:kTicketQueryDefaultValue];
    NSArray *iarray = [tempString componentsSeparatedByString:@"|"];
    _POW = [[NSArray alloc]initWithArray:iarray];
    NSArray *istring = [[iarray firstObject]componentsSeparatedByString:@"."];
    _minprice =[istring firstObject];
    _ticketPrice = [_minprice intValue];
    _op = [dict stringValueForKey:@"op" defaultValue:kTicketQueryDefaultValue];
    _ViaPort = [dict stringValueForKey:@"ViaPort" defaultValue:kTicketQueryDefaultValue];
    _ClassCodeType = [dict stringValueForKey:@"ClassCodeType" defaultValue:kTicketQueryDefaultValue];
    if([_minprice isEqualToString:@"0"] || _minprice.length == 0 || [_minprice isEqualToString:@"--"])
    {
        _isSoldOut = YES;
    }
    else
    {
        _isSoldOut = NO;
    }
}
- (NSString *)getCarrierSNameWith:(NSString *)code
{
    NSString *CarrierSNameString = [NSString string];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"xUtils" ofType:@"db"];
    FMDatabase *db= [FMDatabase databaseWithPath:filePath];
    if ([db open])
    {
        NSString * sqReq = [NSString stringWithFormat: @"select * from com_sbhapp_entities_airconpany where Code = '%@'",code];
        FMResultSet *rs = [db executeQuery:sqReq];
        while ([rs next])
        {
            CarrierSNameString = [rs stringForColumn:@"Name"];
        }
    }
    [db close];
    return CarrierSNameString;
}
@end
