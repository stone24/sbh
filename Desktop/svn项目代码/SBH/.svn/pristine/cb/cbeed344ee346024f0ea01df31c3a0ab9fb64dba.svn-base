//
//  BeCarOrderDetailOrderHeaderCell.h
//  sbh
//
//  Created by RobinLiu on 15/7/13.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeCarOrderDetailModel.h"
@protocol CarOrderDetailOrderHeaderCellDelegate;
@interface BeCarOrderDetailOrderHeaderCell : UITableViewCell
{
    BOOL isDetailShow;
}
@property (nonatomic,weak)id<CarOrderDetailOrderHeaderCellDelegate>delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setCellWithModel:(BeCarOrderDetailModel *)model andIsSpread:(BOOL)isSpread;
+ (CGFloat)cellHeightWithModel:(BeCarOrderDetailModel *)model andIsSpread:(BOOL)isSpread;
@end
@protocol CarOrderDetailOrderHeaderCellDelegate <NSObject>

- (void)isShowDetailWithBool:(BOOL)isShow;

@end