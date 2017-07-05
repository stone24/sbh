//
//  BeMapSearchViewController.h
//  sbh
//
//  Created by RobinLiu on 15/7/14.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeBaseTableViewController.h"
#import "BeAddressModel.h"
#import "BeSpeCityModel.h"

//上海121.46687   31.226794
//佛山113.125728  23.05193
//北京116.461547 39.906184
#define kSimulatorLat 39.906184
#define kSimulatorLng 116.461547
#define kSimulatorCityName @"北京"

typedef NS_ENUM(NSInteger, MapViewControllerSourceType)
{
    MapViewSourceTypeStart = 0,
    MapViewSourceTypeDestination = 1,
    MapViewSourceTypeCustomHomeAddress = 2,
    MapViewSourceTypeCustomCompanyAddress = 3,
};
@protocol BeMapAddressProtocol;
@interface BeMapSearchViewController : BeBaseTableViewController

@property (nonatomic, weak)id<BeMapAddressProtocol>delegate;
@property (nonatomic, assign)MapViewControllerSourceType sourceType;
@property (nonatomic, strong)BeSpeCityModel *locationCity;

@end
@protocol BeMapAddressProtocol <NSObject>
@optional
- (void)selectStartAddressWith:(BeAddressModel *)item;
- (void)selectDestinationWith:(BeAddressModel *)item;
@end
