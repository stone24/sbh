//
//  BeHotelTravelPolicyViewController.h
//  sbh
//
//  Created by RobinLiu on 16/4/14.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeBaseTableViewController.h"
#import "BeHotelOrderWriteModel.h"

@interface BeHotelTravelPolicyViewController : BeBaseTableViewController
@property (nonatomic,strong)NSDictionary *ruleDict;
@property (nonatomic, strong)BeHotelOrderWriteModel *writeModel;
@end