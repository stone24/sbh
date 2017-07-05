//
//  BeCarOrderListModel.h
//  sbh
//
//  Created by RobinLiu on 15/7/13.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, BeCarOrderType)
{
    BeCarOrderTypeFinished = 0,//已完成
    BeCarOrderTypeCanceled = 1,//已取消
    BeCarOrderTypeWaitReply = 2,//待应答
    BeCarOrderTypeWaitService = 3,//待服务
    BeCarOrderTypeWaitIndividualPay = 4,//待个人支付
    BeCarOrderTypeWaitConfirm = 5,//待确认
    BeCarOrderTypeServiceFinished = 6,//服务结束
    BeCarOrderTypeInService = 7,//服务中
};
@interface BeCarOrderListModel : NSObject
@property (nonatomic,assign)BeCarOrderType orderType;
@property (nonatomic,strong)NSString *EndAddress;
@property (nonatomic,strong)NSString *OrderNo;
@property (nonatomic,strong)NSString *OrderStatus;
@property (nonatomic,strong)NSString *RidingDate;
@property (nonatomic,strong)NSString *StartAddress;
@property (nonatomic,strong)NSString *rid;
@property (nonatomic,strong)NSString *OrderCreateDate;
- (id)initWithDict:(NSDictionary *)dict;
+ (UIColor *)colorWithType:(BeCarOrderType )type;
+ (UIColor *)colorWithString:(NSString *)string;
@end
