//
//  BeOrderTitleTableViewCell.h
//  sbh
//
//  Created by RobinLiu on 16/7/12.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeOrderTitleTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *bookButton;
@end
