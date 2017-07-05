//
//  BeHotelListTableViewCell.h
//  SideBenefit
//
//  Created by RobinLiu on 15/3/11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeHotelListItem.h"

@interface BeHotelListTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeight;
- (void)setCellWith:(BeHotelListItem *)item;
@end
