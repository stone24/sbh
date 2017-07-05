//
//  BeAirOrderDetailPassengerCell.h
//  sbh
//
//  Created by SBH on 15/4/30.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeAirOrderDetailPassengerFrame.h"

@interface BeAirOrderDetailPassengerCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) BeAirOrderDetailPassengerFrame *pasF;

// 标题
@property (nonatomic, copy) NSString *titleStr;
@end
