//
//  BeHotelSearchViewController.h
//  SideBenefit
//
//  Created by RobinLiu on 15/3/11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeBaseTableViewController.h"
#import "BeHotelConditionHeader.h"

#define kBusinessCircleTitle @"商圈"
#define kDistrictTitle @"行政区"
#define kBrandTitle @"品牌"

typedef void(^SelectBlock)(NSMutableArray *selectDistrictA,NSMutableArray *selectBussinessA,NSMutableArray *selectBrandA,NSString *keyword);
@interface BeHotelSearchViewController : BeBaseTableViewController
@property (nonatomic,retain)NSMutableString *cityId;
@property (nonatomic,copy)SelectBlock searchBlock;
- (void)updateWithDistrict:(NSMutableArray *)selectDistrictA andBussiness:(NSMutableArray *)selectBussinessA andBrand:(NSMutableArray *)selectBrandA;
@end
