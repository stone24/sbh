//
//  BeTicketPriceRuleModel.h
//  sbh
//
//  Created by RobinLiu on 16/3/10.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeTicketDetailModel.h"
#import "BeTicketQueryResultModel.h"

typedef NS_ENUM(NSInteger,TravelPolicyType) {
    TravelPolicyTypeForce = 1,//IsForced=1强制差旅政策
    TravelPolicyTypeNoForce = 0,//IsForced=0不强制
};
@interface BeTicketPriceRuleModel : NSObject

/**
 * 判断差旅政策页面是否显示
 */
@property (nonatomic,assign)BOOL isTPDisplay;
/**
 * 0老审批1新审批
 */
@property (nonatomic,strong)NSString *isnewaudit;

@property (nonatomic,assign)TravelPolicyType policyType;
/**
 * 推荐的航班
 */
@property (nonatomic,strong)BeTicketDetailModel *recommendFlight;

/**
 * 推荐的机场
 */
@property (nonatomic,strong)BeTicketQueryResultModel *recommendAirport;

/**
 * 选中的航班
 */
@property (nonatomic,strong)BeTicketDetailModel *selectedFlight;

/**
 * 选中的机场
 */
@property (nonatomic,strong)BeTicketQueryResultModel *selectedAirport;

/**
 * 理由
 */
@property (nonatomic,strong)NSMutableArray *reasonArray;

@property (nonatomic,strong)NSString *selectedReason;
- (id)initWithDict:(NSDictionary *)dict;
@end
