//
//  BeTicketQueryListData.h
//  sbh
//
//  Created by RobinLiu on 15/4/17.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeTicketQueryDataSource.h"
#import "BeFlightTicketListViewController.h"
@interface BeTicketQueryListData : NSObject
@property (nonatomic,retain)NSMutableArray *listArray;
@property (nonatomic,retain)NSMutableArray *filterArray;
@property (nonatomic,retain)NSString *guid;
@property (nonatomic,assign)BOOL timeUp;
@property (nonatomic,assign)BOOL priceUp;
@property (nonatomic,assign)BOOL isFilter;
@property (nonatomic,retain)NSMutableArray *aircompayArray;
@property (nonatomic,retain)NSMutableArray *departureAirportArray;
@property (nonatomic,retain)NSMutableArray *arriveAirportArray;
@property (nonatomic,assign)BOOL isDataException;
@property (nonatomic,assign)AircraftCabinType cabinType;
@property (nonatomic,retain)NSString *departCityName;
@property (nonatomic,retain)NSString *arriveCityName;
- (void)setDataWithDict:(NSDictionary *)dict WithCabinType:(AircraftCabinType)cabinType andFlightNo:(NSString *)flightNo and:(QueryControllerSourceType )sourceType;
- (void)filterWithItem:(BeTicketQueryDataSource *)item;
- (void)sortTimeWithIsUp:(BOOL)isUp;
- (void)sortPriceIsUp:(BOOL)isUp;
- (void)clearAllData;
- (void)clearAllFilterConditions;
@end
