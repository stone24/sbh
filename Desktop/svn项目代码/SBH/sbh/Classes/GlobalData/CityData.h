//
//  CityData.h
//  SBHAPP
//
//  Created by musmile on 14-7-6.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityData : NSObject
@property(nonatomic,strong)NSString * iCityName;
@property(nonatomic,strong)NSString * iCityCode;
@property(nonatomic,strong)NSString * iCityAbbr;
@property(nonatomic,strong)NSString * iCityPinyin;
@property(nonatomic,strong)NSString * iAirportCode;
@property (nonatomic,strong)NSString *cityId;
@property (nonatomic,strong)NSString *provinceId;
@property (nonatomic,assign)int cityHot;
@property (nonatomic,strong)NSString *districtName;
@property (nonatomic,strong)NSString *districtId;
@property (nonatomic,strong)NSString *businessId;
@property (nonatomic,strong)NSString *businessName;
@property (nonatomic,retain)NSString *firstChara;
@end
