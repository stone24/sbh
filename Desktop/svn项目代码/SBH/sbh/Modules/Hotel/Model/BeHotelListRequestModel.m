//
//  BeHotelListRequestModel.m
//  SideBenefit
//
//  Created by RobinLiu on 15/3/14.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelListRequestModel.h"
#import "ServerFactory.h"
#import "BeHotelServer.h"
#import "NSDate+WQCalendarLogic.h"
#import "BeHotelConditionHeader.h"

#define kDefaultStayNights 1//默认住一晚

static BeHotelListRequestModel *_instance = nil;

@implementation BeHotelListRequestModel

+ (BeHotelListRequestModel *)sharedInstance
{
    if (!_instance) {
        @synchronized(self)
        {
            if(!_instance)
            {
                _instance = [[self alloc]init];
                [_instance initConfigure];
            }
        }
    }
    return _instance;
}
- (void)initConfigure
{
    _priceArrayCondition = [[NSMutableArray alloc]init];
    _starArrayCondition = [[NSMutableArray alloc]init];
    _cityItem = [[CityData alloc]init];
    _bussinessArray = [[NSMutableArray alloc]init];
    _districtArray = [[NSMutableArray alloc]init];
    _brandArray = [[NSMutableArray alloc]init];
    _facilityArray = [[NSMutableArray alloc]init];
    [self clearAllConditions];
}
- (void)clearAllConditions
{
    self.reason = kTravelReasonOnBussinessText;
    self.guid = @"";
    NSDate *date = [NSDate date];
    NSDate *localeDate = [date dateFromString:[date stringFromDate:date]];
    self.sdate = localeDate;//将当前日期的时间确定为0分0时0秒，便于与离开日期相减
    self.edate = [self automaticGetLeaveDateWith:localeDate];
    self.pagenum = 1;
    self.pagesize = 10;
    self.keyName = @"";
    self.hasMore = YES;
    self.hasFresh = YES;
    self.totals = @"0";
    self.pageCount = @"1";
    
    //默认价格由低到高
    self.sortCondition = @"";
    
    self.cityItem.iCityName = @"北京";
    self.cityItem.cityId = @"1";
    self.cityItem.provinceId = @"1";
    
    [self clearKeywordCondition];
}
- (void)updateCityWith:(CityData *)city
{
    self.cityItem.iCityName = city.iCityName;
    self.cityItem.cityId = city.cityId;
    self.cityItem.provinceId = city.provinceId;
}
- (BOOL)isCanFilterWithBrandArray:(NSMutableArray *)selectBrandA andFacilityArray:(NSMutableArray *)selectFacilityA
{
    BOOL canFilter = NO;
    NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", selectBrandA];
    NSArray *unableBrandArray = [self.brandArray filteredArrayUsingPredicate:thePredicate];
    thePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", self.brandArray];
    NSArray *filterArray = [selectBrandA filteredArrayUsingPredicate:thePredicate];
    
    if(unableBrandArray.count > 0 || filterArray.count > 0)
    {
        canFilter = YES;
        return canFilter;
    }
    thePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", selectFacilityA];
    NSArray *unableFacilityArray = [self.facilityArray filteredArrayUsingPredicate:thePredicate];
    
    thePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", self.facilityArray];
    filterArray = [selectFacilityA filteredArrayUsingPredicate:thePredicate];
    
    if(unableFacilityArray.count > 0 || filterArray.count > 0)
    {
        canFilter = YES;
        return canFilter;
    }
    return canFilter;
}
- (BOOL)isCanFilterWithPriceArray:(NSMutableArray *)selectPriceA andStarArray:(NSMutableArray *)selectStarA
{
    BOOL canFilter = NO;
    NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", selectPriceA];
    NSArray *unablePriceArray = [self.priceArrayCondition filteredArrayUsingPredicate:thePredicate];
    thePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", self.priceArrayCondition];
    NSArray *filterArray = [selectPriceA filteredArrayUsingPredicate:thePredicate];
    if(unablePriceArray.count > 0 || filterArray.count > 0)
    {
        canFilter = YES;
        return canFilter;
    }
    thePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", selectStarA];
    NSArray *unablestarArray = [self.starArrayCondition filteredArrayUsingPredicate:thePredicate];
    thePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", self.starArrayCondition];
    filterArray = [selectStarA filteredArrayUsingPredicate:thePredicate];
    if(unablestarArray.count > 0 || filterArray.count > 0)
    {
        canFilter = YES;
        return canFilter;
    }
    return canFilter;
}
- (BOOL)isCanFilterWithDistrictArray:(NSMutableArray *)selectDistrictA andBussinessArray:(NSMutableArray *)selectBussinessA
{
    BOOL canFilter = NO;
    NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", selectDistrictA];
    NSArray *unableDistrictArray = [self.districtArray filteredArrayUsingPredicate:thePredicate];
    thePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", self.districtArray];
    NSArray *filterArray = [selectDistrictA filteredArrayUsingPredicate:thePredicate];
    
    if(unableDistrictArray.count > 0 || filterArray.count > 0)
    {
        canFilter = YES;
        return canFilter;
    }
    thePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", selectBussinessA];
    NSArray *unablesbussinessArray = [self.bussinessArray filteredArrayUsingPredicate:thePredicate];
    thePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", self.bussinessArray];
    filterArray = [selectBussinessA filteredArrayUsingPredicate:thePredicate];
    
    if(unablesbussinessArray.count > 0 || filterArray.count > 0)
    {
        canFilter = YES;
        return canFilter;
    }
    return canFilter;
}
- (void)LoadDataWithType:(LoadDataType)type andRequestObject:(BeHotelListRequestModel *)model andBlock:(LoadDataBlock)block
{
    if(type == LoadDataTypeFresh)
    {
        model.pagenum = 1;
    }
    if(type == LoadDataTypeMore)
    {
        
    }
    [[ServerFactory getServerInstance:@"BeHotelServer"]doGetHotelListWith:model andCallback:^(NSMutableDictionary *callback)
     {
         block(callback);
     }failureCallback:^(NSString *callback)
     {
         block(callback);
     }];
}
- (void)updateRequestModelWith:(BeHotelListModel *)model
{
    self.pagenum = model.pageNum;
    self.pageCount = [NSString stringWithFormat:@"%lu",(unsigned long)model.pageCount];
    if(self.pagenum == model.pageCount)
    {
        self.hasMore = NO;
    }
    if (self.pagenum < model.pageCount)
    {
        self.hasMore = YES;
    }
}

- (void)setSdate:(NSDate *)sdate
{
    _sdate = sdate;
    NSTimeInterval time=[self.edate timeIntervalSinceDate:self.sdate];
    if(((int)time)/(3600*24)<kDefaultStayNights)
    {
        self.edate = [self automaticGetLeaveDateWith:sdate];
    };
}
- (NSDate *)automaticGetLeaveDateWith:(NSDate *)startDate
{
    return [startDate dateByAddingTimeInterval:3600*24*kDefaultStayNights];
}
- (void)updateKeywordWithBussiness:(NSArray *)bussinessA andDistrict:(NSArray *)districtA andBrand:(NSArray *)brandA andKeyword:(NSString *)keyword
{
    [self clearKeywordCondition];
    [_bussinessArray addObjectsFromArray:bussinessA];

    [_districtArray addObjectsFromArray:districtA];
    
    [_brandArray addObjectsFromArray:brandA];
    
    _keyName = keyword;
}
- (void)clearKeywordCondition
{
    [_priceArrayCondition removeAllObjects];
    [_starArrayCondition removeAllObjects];
    [_facilityArray removeAllObjects];

    [_bussinessArray removeAllObjects];
    
    [_districtArray removeAllObjects];
    
    [_brandArray removeAllObjects];
    
    _keyName = @"";
}
@end
