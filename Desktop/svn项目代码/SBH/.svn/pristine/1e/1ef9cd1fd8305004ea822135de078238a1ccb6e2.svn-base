//
//  BeMapServer.h
//  sbh
//
//  Created by RobinLiu on 15/7/14.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeAddressModel.h"
#import "BeSpeCityModel.h"

@interface BeMapServer : NSObject
/**
 * 地址联想
 */
- (void)doInquireSuggestAddressWithCity:(BeSpeCityModel *)city andText:(NSString *)text byCallBack:(void (^)(NSMutableArray *))callback failureCallback:(void (^)(NSString *))failureCallback;

/**
 * 获取城市接口
 */
- (void)getSpecialCarCityWithCallback:(void (^)(NSMutableArray *))callback andFailure:(void (^)(NSError *))error;

/**
 * 获取历史记录
 */
- (void)getSearchHistoryWithCityName:(NSString *)CityName SuccessCallback:(void (^)(NSMutableArray *searchArray,BeAddressModel *homeModel,BeAddressModel *companyModel))callback andFailure:(void (^)(NSMutableArray *searchArray,BeAddressModel *homeModel,BeAddressModel *companyModel,NSError *error))failure;
/**
 * 更新家或者公司地址
 */
- (void)modifyAddressWithFlag:(NSString *)flag andModel:(BeAddressModel *)model Callback:(void (^)(void))callback andFailure:(void (^)(NSError *))failure;
@end
