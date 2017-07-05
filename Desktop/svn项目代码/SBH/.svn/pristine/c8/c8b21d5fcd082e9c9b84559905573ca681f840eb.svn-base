//
//  BeAuditProjectViewController.h
//  sbh
//
//  Created by RobinLiu on 16/2/18.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeBaseSearchViewController.h"
#import "BeOrderWriteModel.h"
#import "BeAirTicketOrderWriteTool.h"
typedef void(^ProjectBlock) (NSMutableArray *projectArray,BeAuditProjectModel *projectModel,NSString *flowID);
@interface BeAuditProjectViewController : BeBaseSearchViewController
@property (nonatomic,strong)NSString *TicketId;
@property (nonatomic,copy)ProjectBlock block;
@property (nonatomic,strong)NSArray *passengerArray;
@property (nonatomic,strong)NSString *priceAmount;
@property (nonatomic,assign)AuditNewType projectSourceType;
@end
