//
//  BeTrainTicketFilterConditionS.h
//  sbh
//
//  Created by RobinLiu on 15/6/16.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeTrainDefines.h"

@interface BeTrainTicketFilterConditions : NSObject
@property (nonatomic,assign)BOOL isOnlyStraight;
@property (nonatomic,retain)NSMutableArray *startTimeArray;
@property (nonatomic,retain)NSMutableArray *arriveTimeArray;
@property (nonatomic,retain)NSString *trainTypeCondition;
@property (nonatomic,retain)NSString *seatTypeCondition;
- (id)initConfigure;
@end
