//
//  BeHotelCityManager.m
//  SideBenefit
//
//  Created by RobinLiu on 15/3/12.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelCityManager.h"
#import "FMDatabase.h"
#import "CityData.h"
#import "NSString+Additions.h"

@interface BeHotelCityManager ()
{
    NSMutableDictionary *dataDict;
    NSMutableArray *dataArray;
}
@end
static BeHotelCityManager *manager = nil;
@implementation BeHotelCityManager
- (id)init
{
    if(self = [super init])
    {
        dataDict = [[NSMutableDictionary alloc]init];;
        dataArray = [[NSMutableArray alloc]init];
    }
    return self;
}
+ (BeHotelCityManager *)sharedInstance
{
    if(manager == nil)
    {
        @synchronized(self)
        {
            if(!manager)
            {
                manager = [[BeHotelCityManager alloc]init];
            }
        }
    }
    return manager;
}
- (void)getBusinessCircleWithCityId:(NSString *)cityId andCallback:(getArrayBlock)arrayBlock
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"hotel" ofType:@"db"];
    FMDatabase *db= [FMDatabase databaseWithPath:filePath];
    NSMutableArray *cityArray = [[NSMutableArray alloc]init];
    if ([db open])
    {
        NSString * sqReq = [NSString stringWithFormat: @"select * from T_Code_BusinessAreaInfo where CityId = '%@' order by BusinessId ASC",cityId];
        FMResultSet *rs = [db executeQuery:sqReq];
        while ([rs next])
        {
            CityData *city = [[CityData alloc]init];
            city.businessId = [rs stringForColumn:@"BusinessId"];
            city.cityId = [rs stringForColumn:@"CityId"];
            city.businessName = [rs stringForColumn:@"BusinessName"];
            [cityArray addObject:city];
        }
    }
    arrayBlock(cityArray);
}
- (void)getBrandWithCityId:(NSString *)cityId andCallback:(getArrayBlock)arrayBlock
{
    
}
- (void)getDistrictDataWithCityId:(NSString *)cityId andCallback:(getArrayBlock)arrayBlock
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"xUtils" ofType:@"db"];
    FMDatabase *db= [FMDatabase databaseWithPath:filePath];
    NSMutableArray *cityArray = [[NSMutableArray alloc]init];
    if ([db open])
    {
        NSString * sqReq = [NSString stringWithFormat:@"select * from B_Code_DistrictInfo where City_Code = '%@'  order by Dis_Code ASC",cityId];
        FMResultSet *rs = [db executeQuery:sqReq];
        while ([rs next])
        {
            CityData *city = [[CityData alloc]init];
            city.districtName = [rs stringForColumn:@"DistrictName"];
            city.districtId = [rs stringForColumn:@"DistrictId"];
            city.cityId = [rs stringForColumn:@"CityId"];
            [cityArray addObject:city];
        }
    }
    arrayBlock(cityArray);

}

- (void)getDistrictNameWithCityId:(NSString *)cityId andDistrictId:(NSString *)districtId Callback:(getDataBlock )arrayBlock
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"hotel" ofType:@"db"];
    FMDatabase *db= [FMDatabase databaseWithPath:filePath];
    if ([db open])
    {
        NSString * sqReq = [NSString stringWithFormat:@"select * from T_Code_DistrictInfo where CityId = '%@' and DistrictId = '%@'",cityId,districtId];
        FMResultSet *rs = [db executeQuery:sqReq];
        while ([rs next])
        {
            arrayBlock([rs stringForColumn:@"DistrictName"]);
            return;
        }
    }
    
}
- (void)getBusinessNameWithCityId:(NSString *)cityId andBusinessId:(NSString *)businessId andCallback:(getDataBlock)callback
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"hotel" ofType:@"db"];
    FMDatabase *db= [FMDatabase databaseWithPath:filePath];
    if ([db open])
    {
        NSString * sqReq = [NSString stringWithFormat: @"select * from T_Code_BusinessAreaInfo where CityId = '%@' and BusinessId = '%@'",cityId,businessId];
        FMResultSet *rs = [db executeQuery:sqReq];
        while ([rs next])
        {
            callback([rs stringForColumn:@"BusinessName"]);
            return;
        }
    }
}
- (void)getCityDataWithCityName:(NSString *)cityName andCallback:(getDataBlock)callback
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"xUtils" ofType:@"db"];
    FMDatabase *db= [FMDatabase databaseWithPath:filePath];
    CityData *city = [[CityData alloc]init];
    city.iCityName = cityName;
    if ([db open])
    {
        NSString * sqReq = [NSString stringWithFormat:@"select * from B_Code_CityInfo where City_Name = '%@'",cityName];
        FMResultSet *rs = [db executeQuery:sqReq];
        while ([rs next])
        {
            city.cityId = [rs stringForColumn:@"City_Code"];
            city.provinceId = [rs stringForColumn:@"Pvc_Code"];
            break;
        }
    }
    callback(city);
    [db close];
}
@end
