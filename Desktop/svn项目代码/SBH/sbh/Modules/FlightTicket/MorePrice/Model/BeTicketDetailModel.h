//
//  BeTicketDetailModel.h
//  sbh
//
//  Created by RobinLiu on 15/10/22.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,TicketPriceType)
{
    TicketTravelPriceType = 1,//1为商旅价
    TicketSharePriceType = 2,//2 为共享价
    TicketOfficialWebsitePriceType = 5,//5为官网价
    TicketLargeCustomerPriceType = 4,//4为大客户、公司协议价
};
@interface BeTicketDetailModel : NSObject

/** 仓位等级 */
@property (nonatomic,strong)NSString *ClassCodeType;

/** 仓位 */
@property (nonatomic,strong)NSString *Code;

/** 签转条件 */
@property (nonatomic,strong)NSString *EI;

/** 改期规定 */
@property (nonatomic,strong)NSString *Endorsement;

/** 折扣 */
@property (nonatomic,strong)NSString *Rebate;

/** 退票规定 */
@property (nonatomic,strong)NSString *Refund;

/** 座位情况 */
@property (nonatomic,strong)NSString *Seat;

/** 价格来源 */
@property (nonatomic,assign)TicketPriceType priceType;

/** 航班仓位GUID */
@property (nonatomic,strong)NSString *guid;

/** 价格 */
@property (nonatomic,strong)NSString *price;

/** 强制保险价格 */
@property (nonatomic,strong)NSString *ForcedInsurance;

@property (nonatomic,strong)NSMutableDictionary *infoDict;
- (id)initWithDict:(NSDictionary *)dict;
@end
