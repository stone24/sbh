//
//  BeCarOrderDetailModel.h
//  sbh
//
//  Created by RobinLiu on 15/7/15.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeCarOrderListModel.h"
typedef NS_ENUM(NSInteger, BeCarOrderSourceType)
{
    BeCarOrderSourceTypeCar = 0,
    BeCarOrderSourceTypePickup = 1,
    BeCarOrderSourceTypeSeeOff = 2,
};
@interface BeCarOrderDetailModel:NSObject
@property (nonatomic,assign)BeCarOrderSourceType orderSourceType;

@property (nonatomic,strong)NSString *AccountId;
@property (nonatomic,strong)NSString *orderState;
@property (nonatomic,strong)NSString *orderDate;/**<用车时间*/
@property (nonatomic,strong)NSString *createOrderDate;/**<下单时间*/
@property (nonatomic,strong)NSString *serviceType;
@property (nonatomic,strong)NSString *orderNo;
@property (nonatomic,strong)NSString *carLevel;
@property (nonatomic,strong)NSString *carName;
@property (nonatomic,strong)NSString *EstimatedCost;
@property (nonatomic,strong)NSString *orderCost;
@property (nonatomic,strong)NSString *sumDetail;

@property (nonatomic,strong)NSString *driverName;
@property (nonatomic,strong)NSString *driverPhone;
@property (nonatomic,strong)NSString *driverCarNo;

@property (nonatomic,strong)NSString *passengers;
@property (nonatomic,strong)NSString *reason;
@property (nonatomic,strong)NSString *passengerPhone;
@property (nonatomic,strong)NSString *expenseCenter;
@property (nonatomic,strong)NSString *startLocation;
@property (nonatomic,strong)NSString *destination;
@property (nonatomic,strong)NSString *orderId;
@property (nonatomic,assign)BOOL isDriverInfoShow;
@property (nonatomic,assign)BOOL isSumShow;
- (void)setDataWith:(NSDictionary *)dict;

@end
