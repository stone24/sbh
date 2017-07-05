//
//  BeHotelListModel.h
//  SideBenefit
//
//  Created by RobinLiu on 15/3/14.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeHotelListModel : NSObject

@property (nonatomic,retain)NSMutableArray *dataArray;
@property (nonatomic,assign)NSUInteger code;
@property (nonatomic,retain)NSString *status;
@property (nonatomic,assign)NSUInteger totalCount;
@property (nonatomic,assign)NSUInteger pageCount;
@property (nonatomic,assign)NSUInteger pageNum;
@property (nonatomic,assign)NSUInteger pageSize;

//@property (nonatomic,retain)NSString *guid;

@property (nonatomic,retain)NSString *sortbyport;
- (id)initConfigure;
- (void)setListModelWithDict:(NSDictionary *)dict andCityName:(NSString *)cityName andCheckInDate:(NSString *)checkInDateString andCheckOutDate:(NSString *)checkOutDateString;

@end
