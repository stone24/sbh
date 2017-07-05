//
//  BeFlightOrderWriteRuleViewController.h
//  sbh
//
//  Created by RobinLiu on 16/3/15.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeBaseTableViewController.h"
#import "BeOrderWriteModel.h"

@interface BeFlightOrderWriteRuleViewController : BeBaseTableViewController
@property (nonatomic, strong)NSDictionary *ruleDict;
@property (nonatomic, strong)BeOrderWriteModel *writeModel;
@end
