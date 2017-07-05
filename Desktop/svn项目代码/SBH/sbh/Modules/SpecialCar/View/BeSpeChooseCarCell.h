//
//  BeSpeChooseCarCell.h
//  sbh
//
//  Created by SBH on 15/7/10.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BeSpeCarLevelModel, BeSpeYDCarLevel;

@interface BeSpeChooseCarCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) NSArray *carlevArray;

@property (nonatomic, strong) BeSpeCarLevelModel *selCarModel;
@property (nonatomic, strong) BeSpeYDCarLevel *selCarYDModel;
@end
