//
//  BeSpecialCarCityViewController.h
//  sbh
//
//  Created by RobinLiu on 16/1/5.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeBaseSearchViewController.h"
#import "BeSpeCityModel.h"

typedef void(^SpecialCityBlock) (BeSpeCityModel *cityObject);

@interface BeSpecialCarCityViewController : BeBaseSearchViewController
/**
 * 当前城市的model
 */
@property (nonatomic,strong)BeSpeCityModel *currentCityModel;
@property (nonatomic,copy)SpecialCityBlock block;
@property (nonatomic,strong)NSMutableArray *cityListArray;
@end
