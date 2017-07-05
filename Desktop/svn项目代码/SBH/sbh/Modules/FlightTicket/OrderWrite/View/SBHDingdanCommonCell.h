//
//  SBHDingdanCommonCell.h
//  sbh
//
//  Created by SBH on 14-12-22.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "projectObj.h"

@interface SBHDingdanCommonCell : UITableViewCell
{
    projectObj *isupprojectObj;
}
@property (weak, nonatomic) IBOutlet UIImageView *sepImageView;
@property (weak, nonatomic) IBOutlet UILabel *xingming;
@property (weak, nonatomic) IBOutlet UITextField *commonTextField;
-(void)setProject:(projectObj*)aprojectObj;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
