//
//  BeTrainSelectDateCell.h
//  sbh
//
//  Created by RobinLiu on 15/6/15.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeTrainSelectDateCell : UITableViewCell
{
    UILabel *dateLabel;
    UILabel *detailLabel;
}
+ (CGFloat)cellheight;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setCellWith:(NSDate *)date;
@end
