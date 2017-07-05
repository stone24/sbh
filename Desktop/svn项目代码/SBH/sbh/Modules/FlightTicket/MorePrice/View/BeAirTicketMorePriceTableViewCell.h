//
//  yuding2TableViewCell.h
//  SBHAPP
//
//  Created by musmile on 14-7-2.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeTicketDetailModel.h"

@interface BeAirTicketMorePriceTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setCellWithModel:(BeTicketDetailModel *)model;
+ (CGFloat)cellHeight;
- (void)addTarget:(id)target andBookAction:(SEL)bookAction andRefundAction:(SEL)refundAction WithIndexPath:(NSIndexPath *)indexPath;
/**
 * 隐藏预订按钮
 */
- (void)hideBookButton;
@end
