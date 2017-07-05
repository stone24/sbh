//
//  BeHotelCityManager.h
//  SideBenefit
//
//  Created by RobinLiu on 15/3/12.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^getDictBlock)(NSMutableDictionary *dict);
typedef void (^getArrayBlock)(NSMutableArray *array);
typedef void (^getDataBlock)(id data);
@interface BeHotelCityManager : NSObject
+ (BeHotelCityManager *)sharedInstance;

/**
 *
 */
- (void)getDistrictDataWithCityId:(NSString *)cityId andCallback:(getArrayBlock)arrayBlock;//行政区
- (void)getBusinessCircleWithCityId:(NSString *)cityId andCallback:(getArrayBlock)arrayBlock;//商圈
- (void)getCityDataWithCityName:(NSString *)cityName andCallback:(getDataBlock)callback;//城市名称

- (void)getDistrictNameWithCityId:(NSString *)cityId andDistrictId:(NSString *)districtId Callback:(getDataBlock )arrayBlock;
- (void)getBusinessNameWithCityId:(NSString *)cityId andBusinessId:(NSString *)businessId andCallback:(getDataBlock)callback;
@end
