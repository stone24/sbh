//
//  BeCarOderDetailBookInfoCell.h
//  sbh
//
//  Created by RobinLiu on 15/7/13.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeCarOrderDetailModel.h"

@interface BeCarOrderDetailBookInfoCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setCellWithModel:(BeCarOrderDetailModel *)model;
+ (CGFloat)cellHeightWithModel:(BeCarOrderDetailModel *)model;
@end
