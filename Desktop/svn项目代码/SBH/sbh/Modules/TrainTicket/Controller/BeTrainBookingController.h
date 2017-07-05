//
//  BeTrainBookingController.h
//  sbh
//
//  Created by SBH on 15/6/16.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeBaseTableViewController.h"
@class BeTrainBookModel;
typedef NS_ENUM(NSInteger,TrainBookSourceType)
{
    TrainBookSourceTypeGenerate = 0,
    TrainBookSourceTypeConfirm = 1,
};
@interface BeTrainBookingController : BeBaseTableViewController
@property (nonatomic,strong)BeTrainBookModel *bookModel;
@property (nonatomic,assign)TrainBookSourceType sourceType;
@end
