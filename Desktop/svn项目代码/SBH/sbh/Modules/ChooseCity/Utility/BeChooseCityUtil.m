//
//  BeChooseCityUtil.m
//  sbh
//
//  Created by RobinLiu on 15/4/28.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeChooseCityUtil.h"
#import "CityData.h"
#import "FMDatabase.h"

@implementation BeChooseCityUtil
+ (BeChooseCityUtil *)sharedInstance
{
    static BeChooseCityUtil *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!_instance)
        {
            _instance = [[BeChooseCityUtil alloc]init];
        }
    });
    return _instance;
}
- (id)init
{
    if(self = [super init])
    {
        _ticketDict = [[NSMutableDictionary alloc]init];
        _ticketDictKeyArray = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)getHotelCityFromDB
{
    [_ticketDict removeAllObjects];
    [_ticketDictKeyArray removeAllObjects];
    NSString *filepath = [[NSBundle mainBundle]pathForResource:@"xUtils" ofType:@"db"];

    FMDatabase *db= [FMDatabase databaseWithPath:filepath];
    if ([db open])
    {
        NSArray *titleArray = @[@"热门",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
        for(NSString *title in titleArray)
        {
            NSMutableArray *dataArray = [[NSMutableArray alloc]init];
            NSString *sql = [[NSString alloc]initWithFormat:@"select * from B_Code_CityInfo where City_Initial = '%@' and City_IsOpen is 'TRUE' ORDER BY id ASC",title];
            if([title isEqualToString:@"热门"])
            {
                sql = @"select * from B_Code_CityInfo where City_IsHot is 'TRUE' and City_IsOpen is 'TRUE' ORDER BY id ASC";
            }
            FMResultSet *rs = [db executeQuery:sql];
            while ([rs next])
            {
                CityData *city = [[CityData alloc]init];
                city.iCityName = [rs stringForColumn:@"City_Name"];
                city.iCityPinyin = [rs stringForColumn:@"City_PinYin"];
                city.cityHot = [rs boolForColumn:@"City_IsHot"];
                city.cityId = [rs stringForColumn:@"City_Code"];
                city.provinceId = [rs stringForColumn:@"Pvc_Code"];
                [dataArray addObject:city];
            }
            if(dataArray.count > 0)
            {
                [_ticketDict addEntriesFromDictionary:@{title:dataArray}];
                [_ticketDictKeyArray addObject:title];
            }
        }
    }
    [db close];
}
- (void)getCityDataWithType:(ChooseCitySourceType)type andCallbackData:(CityBlockData)block
{
    if(type == kTicketDepartureType ||
       type == kTicketReachType)
    {
        [self getTicketCityFromDB];
    }
    else if(type == kHotelStayType)
    {
        [self getHotelCityFromDB];
    }
    else if (type == kTrainDepartureType ||type == kTrainArriveType)
    {
        [self getTrainCityFromDB];
    }
    BeChooseCityListItem *callback = [[BeChooseCityListItem alloc]init];
    callback.cityDict = _ticketDict;
    callback.titleArray = _ticketDictKeyArray;
    block(callback);
}
- (void)getTrainCityFromDB
{
    [_ticketDict removeAllObjects];
    [_ticketDictKeyArray removeAllObjects];
    NSArray *titleArray = @[@"热门",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    for(int i = 0;i<titleArray.count;i++)
    {
        if([[titleArray objectAtIndex:i]isEqualToString:@"热门"])
        {
            NSString *sqReq = @"select * from TrainStationTable where IsHot is 'True' ORDER BY ID ASC";
            NSMutableArray *hotCityArray = [self getTrainDataWithSQL:sqReq];
            [_ticketDict setObject:hotCityArray forKey:[titleArray objectAtIndex:i]];
            [_ticketDictKeyArray addObject:[titleArray objectAtIndex:i]];
        }
        else
        {
            NSString *titleSql = [[NSString alloc]initWithFormat:@"select * from TrainStationTable where Spell like '%@%%' ORDER BY ID ASC",[titleArray objectAtIndex:i]];
            NSMutableArray *resultArray = [self getTrainDataWithSQL:titleSql];
            if(resultArray.count>0)
            {
                [_ticketDict setObject:resultArray forKey:[titleArray objectAtIndex:i]];
                [_ticketDictKeyArray addObject:[titleArray objectAtIndex:i]];
            }
        }
    }
}
- (void)getTicketCityFromDB
{
    [_ticketDict removeAllObjects];
    [_ticketDictKeyArray removeAllObjects];
    NSArray *titleArray = @[@"热门",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    for(int i = 0;i<titleArray.count;i++)
    {
        if([[titleArray objectAtIndex:i]isEqualToString:@"热门"])
        {
            NSString *sqReq = @"select * from com_sbhapp_entities_CityEntity where Hot > 0 ORDER BY Hot ASC";
            NSMutableArray *hotCityArray = [self selectCityDataWithSQL:sqReq];
            [_ticketDict setObject:hotCityArray forKey:[titleArray objectAtIndex:i]];
            [_ticketDictKeyArray addObject:[titleArray objectAtIndex:i]];
        }
        else
        {
            NSString *titleSql = [[NSString alloc]initWithFormat:@"select * from com_sbhapp_entities_CityEntity where PinYin like '%@%%'",[titleArray objectAtIndex:i]];
            NSMutableArray *resultArray = [self selectCityDataWithSQL:titleSql];
            if(resultArray.count>0)
            {
                [_ticketDict setObject:resultArray forKey:[titleArray objectAtIndex:i]];
                [_ticketDictKeyArray addObject:[titleArray objectAtIndex:i]];
            }
        }
    }
}
- (NSMutableArray *)getTrainDataWithSQL:(NSString *)SQL
{
    NSMutableArray *cityArray = [[NSMutableArray alloc]init];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"xUtils" ofType:@"db"];
    FMDatabase *db= [FMDatabase databaseWithPath:filePath];
    if ([db open])
    {
        FMResultSet *rs = [db executeQuery:SQL];
        while ([rs next])
        {
            CityData *city = [[CityData alloc] init];
            city.iCityName = [rs stringForColumn:@"CityNameCN"];
            city.iCityPinyin = [rs stringForColumn:@"Spell"];
            city.iCityCode = [rs stringForColumn:@"CityCode"];
            [cityArray addObject:city];
        }
    }
    [db close];
    return cityArray;
}
- (void)getTicketCityWithName:(NSString *)cityName andCallbackData:(void (^)(CityData *))cityBlock
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"xUtils" ofType:@"db"];
    FMDatabase *db= [FMDatabase databaseWithPath:filePath];
    CityData *city = [[CityData alloc] init];
    city.iCityName = cityName;
    if ([db open])
    {
        NSString *sql = [NSString stringWithFormat:@"select * from com_sbhapp_entities_CityEntity where Name = '%@'",cityName];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next])
        {
            city.iCityCode = [rs stringForColumn:@"Code"];
            city.iCityAbbr = [rs stringForColumn:@"Abbr"];
            city.iCityPinyin = [rs stringForColumn:@"PinYin"];
            city.cityHot = [[rs stringForColumn:@"Hot"] intValue];
            if(city.iCityCode)
            {
                NSString *airpotReq = [[NSString alloc]initWithFormat:@"select * from com_sbhapp_entities_AirPortEntity where CityCode = '%@' ORDER BY CityCode ASC",city.iCityCode];
                FMResultSet *airpotrs = [db executeQuery:airpotReq];
                while ([airpotrs next])
                {
                    city.iAirportCode =[airpotrs stringForColumn:@"Code"];
                    break;
                }
            
            }
        }
    }
    cityBlock (city);
    [db close];
}
- (void)getTrainStationWithName:(NSString *)cityName andCallbackData:(void (^)(CityData *))cityBlock
{
    NSString *titleSql = [[NSString alloc]initWithFormat:@"select * from TrainStationTable where CityNameCN = '%@' ORDER BY Spell ASC",cityName];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"xUtils" ofType:@"db"];
    FMDatabase *db= [FMDatabase databaseWithPath:filePath];
    CityData *city = [[CityData alloc] init];
    city.iCityName = cityName;
    if ([db open])
    {
        FMResultSet *rs = [db executeQuery:titleSql];
        while ([rs next])
        {
            city.iCityName = [rs stringForColumn:@"CityNameCN"];
            city.iCityPinyin = [rs stringForColumn:@"Spell"];
            city.iCityCode = [rs stringForColumn:@"CityCode"];
            break;
        }
    }
    cityBlock(city);
    [db close];
}
- (NSMutableArray *)selectCityDataWithSQL:(NSString *)SQL
{
    NSMutableArray *cityArray = [[NSMutableArray alloc]init];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"xUtils" ofType:@"db"];
    FMDatabase *db= [FMDatabase databaseWithPath:filePath];
    if ([db open])
    {
        FMResultSet *rs = [db executeQuery:SQL];
        while ([rs next])
        {
            CityData *city = [[CityData alloc] init];
            city.iCityName = [rs stringForColumn:@"Name"];
            city.iCityCode = [rs stringForColumn:@"Code"];
            city.iCityAbbr = [rs stringForColumn:@"Abbr"];
            city.iCityPinyin = [rs stringForColumn:@"PinYin"];
            city.cityHot = [[rs stringForColumn:@"Hot"] intValue];
            if(city.iCityCode)
            {
                NSString *airpotReq = [[NSString alloc]initWithFormat:@"select * from com_sbhapp_entities_AirPortEntity where CityCode = '%@' ORDER BY CityCode ASC",city.iCityCode];
                FMResultSet *airpotrs = [db executeQuery:airpotReq];
                while ([airpotrs next])
                {
                    city.iAirportCode =[airpotrs stringForColumn:@"Code"];
                    break;
                }
            }
            if(city.iAirportCode!=nil)
            {
                [cityArray addObject:city];
            }
        }
    }
    [db close];
    return cityArray;
}
@end
