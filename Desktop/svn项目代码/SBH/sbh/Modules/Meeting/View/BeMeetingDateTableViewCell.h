//
//  BeMeetingDateTableViewCell.h
//  sbh
//
//  Created by RobinLiu on 16/6/21.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeMeetingModel.h"

@interface BeMeetingDateTableViewCell : UITableViewCell
@property (nonatomic,strong)BeMeetingModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)addTarget:(id)target WithStartAction:(SEL)startAction andLeaveAction:(SEL)leaveAction;
@end
