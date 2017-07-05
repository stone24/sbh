//
//  SBHMyCell.h
//  sbh
//
//  Created by SBH on 15-1-20.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBHMyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *myIcon;
@property (weak, nonatomic) IBOutlet UILabel *myTitle;
@property (weak, nonatomic) IBOutlet UIButton *numTagIcon;
@property (weak, nonatomic) IBOutlet UIButton *rightArrow;
@property (weak, nonatomic) IBOutlet UIImageView *sepImageView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
