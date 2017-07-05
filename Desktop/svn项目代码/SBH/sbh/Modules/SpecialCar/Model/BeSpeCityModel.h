//
//  BeSpeCityModel.h
//  sbh
//
//  Created by SBH on 15/7/15.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeSpeCarLevelModel.h"

@interface BeSpeCityModel : NSObject

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *cityLat;
@property (nonatomic, strong) NSString *cityLng;
@property (nonatomic, strong) NSString *pinyin;
@property (nonatomic, strong) NSString *sqcityid;//接送机需要的参数
@property (nonatomic, strong) NSString *cityId;//接送机需要的参数
/**
 * 根据选择城市页面的数据初始化
 */
- (id)initWithCityDict:(NSDictionary *)dict;
@end
