//
//  BeHotelListRequestModel.h
//  SideBenefit
//
//  Created by RobinLiu on 15/3/14.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeHotelListModel.h"
#import "CityData.h"
#import "BeBrandModel.h"

typedef void(^LoadDataBlock)(id object);
typedef enum
{
    LoadDataTypeFresh,  //刷新
    LoadDataTypeMore,   //加载更多
}LoadDataType;

typedef NS_ENUM(NSInteger,OrderByMode)
{
    OrderByModeNone = 0, // 默认无
    OrderByModeGood = 1, // 好评
    OrderByModePrice = 2,// 价格
    OrderByModeStar = 3,// 星级
    OrderByModeBrand = 4,// 品牌
};
@interface BeHotelListRequestModel : NSObject

+ (BeHotelListRequestModel *)sharedInstance;

@property (nonatomic,retain)NSString *guid;


@property (nonatomic,retain)NSDate *sdate;
@property (nonatomic,retain)NSDate *edate;

@property (nonatomic,retain)CityData *cityItem;

@property (nonatomic,strong)NSString *reason;//因公 因私
@property (nonatomic,retain)NSString *keyName;

@property (nonatomic,strong)NSMutableArray *bussinessArray;
@property (nonatomic,strong)NSMutableArray *districtArray;
@property (nonatomic,strong)NSMutableArray *brandArray;
@property (nonatomic,strong)NSMutableArray *facilityArray;

@property (nonatomic,retain)NSMutableArray *priceArrayCondition;
@property (nonatomic,retain)NSMutableArray *starArrayCondition;

/**
 * 排序的条件
 */
@property (nonatomic,strong)NSString *sortCondition;

@property (nonatomic,assign)NSUInteger pagenum;
@property (nonatomic,assign)NSUInteger pagesize;
@property (nonatomic,strong)NSString *totals;
@property (nonatomic,strong)NSString *pageCount;
@property (nonatomic,assign)BOOL hasMore;
@property (nonatomic,assign)BOOL hasFresh;

/**
 * 配置
 */
- (void)initConfigure;
- (void)updateCityWith:(CityData *)city;
- (void)updateRequestModelWith:(BeHotelListModel *)model;
- (NSDate *)automaticGetLeaveDateWith:(NSDate *)startDate;

/**
 * 清除所有选项
 */
- (void)clearAllConditions;
/**
 * 清除关键字选项
 */
- (void)clearKeywordCondition;
/**
 * 更新酒店首页的关键字
 */
- (void)updateKeywordWithBussiness:(NSArray *)bussinessA andDistrict:(NSArray *)districtA andBrand:(NSArray *)brandA andKeyword:(NSString *)keyword;
/**
 * 酒店列表页面，选择完筛选条件之后，判断是否跟之前的条件相同，不同可以筛选
 */
- (BOOL)isCanFilterWithBrandArray:(NSMutableArray *)selectBrandA andFacilityArray:(NSMutableArray *)selectFacilityA;

/**
 * 酒店列表页面，选择完价格星级条件之后，判断是否跟之前的条件相同，不同可以筛选
 */
- (BOOL)isCanFilterWithPriceArray:(NSMutableArray *)selectPriceA andStarArray:(NSMutableArray *)selectStarA;

/**
 * 酒店列表页面，选择完位置条件之后，判断是否跟之前的条件相同，不同可以筛选
 */
- (BOOL)isCanFilterWithDistrictArray:(NSMutableArray *)selectDistrictA andBussinessArray:(NSMutableArray *)selectBussinessA;

@end
