//
//  BeAddressModel.h
//  sbh
//
//  Created by RobinLiu on 15/7/14.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BeAddressModel : NSObject
@property (nonatomic,strong)NSString *addressId;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *address;
@property (nonatomic,strong)NSString *category;
@property (nonatomic,assign)CLLocationCoordinate2D location;
@property (nonatomic,strong)NSString *distance;
@property (nonatomic,strong)NSString *nation;
@property (nonatomic,strong)NSString *province;
@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *district;

- (id)initWithDict:(NSDictionary *)dict;

@property (nonatomic, copy) NSString *addressParam;
@property (nonatomic, copy) NSString *titleParam;
@end
