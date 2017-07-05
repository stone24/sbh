//
//  BeAlterationFlightCell.h
//  sbh
//
//  Created by SBH on 15/4/14.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BeFlightModel, BeTrainInfoModel;

@interface BeAlterationFlightCell : UITableViewCell

// 数据传递
@property (nonatomic, strong) BeFlightModel *flightM;
@property (nonatomic, strong) BeTrainInfoModel *trainM;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
