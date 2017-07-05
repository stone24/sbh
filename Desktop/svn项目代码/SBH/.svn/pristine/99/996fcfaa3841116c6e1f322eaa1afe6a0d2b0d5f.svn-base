//
//  BeHotelFilterViewController.h
//  sbh
//  酒店列表点击筛选跟位置区域的时候
//  Created by RobinLiu on 15/12/10.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BeBaseTableViewController.h"

#define kBusinessCircleTitle    @"商圈"
#define kDistrictTitle          @"行政区"
#define kBrandTitle             @"品牌"
#define kFacilityTitle          @"设施"

typedef void(^HotelFilterBlock)(NSMutableArray *selectBrandA,NSMutableArray *selectFacilityA);

typedef void(^HotelLocationBlock)(NSMutableArray *selectDistrictA,NSMutableArray *selectBussinessA);


typedef NS_ENUM(NSInteger,HotelFilterSourceType) {
    HotelFilterSourceTypeFilter = 0,
    HotelFilterSourceTypeLocation = 1,
};
@interface BeHotelFilterViewController : BeBaseTableViewController

@property (nonatomic,retain)NSString *cityId;
@property (nonatomic,assign)HotelFilterSourceType sourceType;

- (void)updateUIWithDistrict:(NSMutableArray *)selectDistrictA andBussiness:(NSMutableArray *)selectBussinessA;
- (void)updateUIWithBrand:(NSMutableArray *)selectBrand andFacility:(NSMutableArray *)selectFacilityA;

@property (nonatomic,copy)HotelFilterBlock filterBlock;
@property (nonatomic,copy)HotelLocationBlock locationBlock;
@end
