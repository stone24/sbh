//
//  BeCarOrderListTableViewCell.h
//  sbh
//
//  Created by RobinLiu on 15/7/13.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeCarOrderListModel.h"

@interface BeCarOrderListTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeight;
@property (nonatomic,retain)BeCarOrderListModel *model;

@end
