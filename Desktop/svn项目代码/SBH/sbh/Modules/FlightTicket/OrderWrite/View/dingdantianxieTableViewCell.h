//
//  dingdantianxieTableViewCell.h
//  SBHAPP
//
//  Created by musmile on 14-7-2.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "projectObj.h"

@interface dingdantianxieTableViewCell : UITableViewCell
{
    projectObj * isupprojectObj;
}

@property (weak, nonatomic) IBOutlet UIImageView *sepImageView;
@property (weak, nonatomic) IBOutlet UILabel *xingming;
@property (weak, nonatomic) IBOutlet UITextField *itextfield;
- (IBAction)endexit:(id)sender;
- (IBAction)changingValue:(id)sender;

-(void)setProject:(projectObj*)aprojectObj;
@property (weak, nonatomic) IBOutlet UIButton *delChengjrBtn;
@property (weak, nonatomic) IBOutlet UIButton *rotDelBtn;
@property (weak, nonatomic) IBOutlet UIButton *rotDelBtn00;

@property (weak, nonatomic) IBOutlet UILabel *baoxianLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
