//
//  BeHotelListViewController.h
//  SideBenefit
//
//  Created by RobinLiu on 15/3/11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeBaseTableViewController.h"

@class BeHotelListRequestModel;
typedef void(^DismissListBlock)(void);
@interface BeHotelListViewController : BeBaseTableViewController
@property (nonatomic,retain)BeHotelListRequestModel *requestModel;
@property (nonatomic,copy)DismissListBlock block;
@end
