//
//  BeSpecialSubController+Addition.h
//  sbh
//
//  Created by RobinLiu on 16/1/7.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeSpecialSubController.h"
@interface BeSpecialSubController (Addition)
/**
 * 初始化数据
 */
- (void)initializationData;
/**
 * 获取用车城市列表数据
 */
- (void)getCityList;


/**
 * 当前定位的城市赋值
 */
- (void)currentCityGetDataFrom:(BeSpeCityModel *)model;

/**
 * 获取接送机的城市id
 */
- (void)getCityIdWithSuccess:(void (^)(void))callback andFailure:(void(^)(void))failureCallback;
/**
 * 获取接送机的车型列表
 */
- (void)getAirportTransferCarList;

/**
 * 获取接送机的费用预估
 */
- (void)getAirportTransferFee;
/**
 * 判断下单的参数是否填写完整
 */
- (void)checkOrderParamsIsComplete;
/**
 * 下单
 */
- (void)specialCarOrderSubmit;
@end
