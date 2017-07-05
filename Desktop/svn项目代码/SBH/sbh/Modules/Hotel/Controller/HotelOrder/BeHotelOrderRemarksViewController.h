//
//  BeHotelOrderRemarksViewController.h
//  sbh
//
//  Created by RobinLiu on 15/12/14.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BeBaseTableViewController.h"
typedef void(^RemarksBlock)(NSString *selectString);

@interface BeHotelOrderRemarksViewController : BeBaseTableViewController
@property (nonatomic,copy)RemarksBlock block;
@end
