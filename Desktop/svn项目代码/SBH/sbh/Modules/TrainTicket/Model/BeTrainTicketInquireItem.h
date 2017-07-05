//
//  BeTrainTicketInquireItem.h
//  sbh
//
//  Created by RobinLiu on 15/6/15.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityData.h"

@interface BeTrainTicketInquireItem : NSObject
+ (BeTrainTicketInquireItem *)sharedInstance;
@property (nonatomic,strong)NSDate *startDate;
@property (nonatomic,strong)NSString *startDateStr;
@property (nonatomic,strong)NSString *fromTrainStation;
@property (nonatomic,strong)NSString *toTrainStation;
@property (nonatomic,strong)NSString *fromStationCode;
@property (nonatomic,strong)NSString *toStationCode;
@property (nonatomic,strong)NSString *journeytype;
@property (nonatomic,strong)NSString *gs;
@property (nonatomic,strong)NSString *GuidSearch;
@property (nonatomic,strong)NSString *orderKey;
@end
