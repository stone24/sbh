//
//  BeTrainTicketListViewController.h
//  sbh
//
//  Created by RobinLiu on 15/6/15.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeBaseTableViewController.h"
#import "BeTrainTicketInquireItem.h"
@class BeTrainTicketListModel;

typedef NS_ENUM(NSInteger, TrainTicketListSourceType)
{
    kTrainTicketListSourceDefault,
    kTrainTicketListSourceAlte, // 改签
};

@interface BeTrainTicketListViewController : BeBaseTableViewController
@property (nonatomic, copy) void(^trainTicketListModelBlock)(BeTrainTicketListModel *);
@property (nonatomic,assign) TrainTicketListSourceType sourceType;
@end
