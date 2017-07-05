//
//  chaxunjipiaoViewController.h
//  SBHAPP
//
//  Created by musmile on 14-7-1.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "BeBaseTableViewController.h"
@class BeTicketQueryResultModel;

typedef NS_ENUM(NSInteger, QueryControllerSourceType)
{
    kQueryControllerSourceDeparture,
    kQueryControllerSourceReturn,
    kQueryControllerSourceAlter,  // F C没有仓位选择
    kQueryControllerSourceAlteSeveral,  // 非F C没有仓位和机场选择, 只能选择改签同一航空公司
};

@interface BeFlightTicketListViewController : BeBaseTableViewController

@property (nonatomic, copy) void(^flightModelBlock)(BeTicketQueryResultModel *);
@property (nonatomic, copy) NSString *originalFlightNo;
@property (nonatomic,assign)QueryControllerSourceType querySourceType;
@property (nonatomic, copy) NSString *GcomeTime;
@property (nonatomic, copy) NSString *GreachTime;

@end
