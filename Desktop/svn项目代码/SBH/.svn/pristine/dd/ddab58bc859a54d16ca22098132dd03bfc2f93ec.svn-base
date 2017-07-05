//
//  BeTrainDetailTableViewCell.h
//  sbh
//
//  Created by RobinLiu on 15/6/23.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeTrainTicketListModel.h"
@protocol BeTrainDetailDelegate;
@interface BeTrainDetailTableViewCell : UITableViewCell
@property (nonatomic,assign)id<BeTrainDetailDelegate>delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeight;
- (void)showDetailWith:(BeTrainSeatModel *)seatType andIndexPath:(NSIndexPath *)path andModel:(BeTrainTicketListModel *)model;
@end
@protocol BeTrainDetailDelegate <NSObject>
- (void)bookButtonDidClickWithIndexPath:(NSIndexPath *)indexPath;
@end