//
//  gongsilianxirenTableViewCell.h
//  SBHAPP
//
//  Created by musmile on 14-7-2.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "selectContact.h"

@interface gongsilianxirenTableViewCell : UITableViewCell
{
    selectContact * iSupContact;
}

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *sepImageView;

@property (weak, nonatomic) IBOutlet UIButton *email;
@property (weak, nonatomic) IBOutlet UIButton *message;

- (IBAction)message:(id)sender;
- (IBAction)email:(id)sender;
//设置数据进去
-(void)setContact:(selectContact*)aselectContact;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIButton *delLianxrBtn;
@property (weak, nonatomic) IBOutlet UIButton *rotDel00Btn;
@property (weak, nonatomic) IBOutlet UIButton *rotDel00Btn00;

@end
