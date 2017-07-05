//
//  gongsilianxirenTableViewCell.m
//  SBHAPP
//
//  Created by musmile on 14-7-2.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "gongsilianxirenTableViewCell.h"

@implementation gongsilianxirenTableViewCell
{
    BOOL  MESSAGE;
    BOOL  EMAIL;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    gongsilianxirenTableViewCell *cell = nil;
    static NSString *cell1 = @"cell1";
    cell = [tableView dequeueReusableCellWithIdentifier:cell1];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"gongsilianxirenTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    return cell;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//设置数据进去
-(void)setContact:(selectContact*)aselectContact
{
    iSupContact = aselectContact;
    MESSAGE = aselectContact.isOpenPhone;
    EMAIL   = aselectContact.isOpenEmail;
    self.message.selected = !aselectContact.isOpenPhone;
    self.email.selected = !aselectContact.isOpenEmail;
}


- (IBAction)message:(UIButton *)sender {
     sender.selected = !sender.selected;
//    MESSAGE = !MESSAGE;
    if (sender.selected) {
//        [self.message setBackgroundImage:[UIImage imageNamed:@"tianxiexinxi_tb_6"] forState:UIControlStateNormal];
        iSupContact.isOpenPhone = NO;
    }
    else{
//        [self.message setBackgroundImage:[UIImage imageNamed:@"tianxiexinxi_tb_4"] forState:UIControlStateNormal];
        iSupContact.isOpenPhone = YES;
    }
}

- (IBAction)email:(UIButton *)sender {
    sender.selected = !sender.selected;
//    EMAIL = !EMAIL;
    if (sender.selected) {
//        [self.email setBackgroundImage:[UIImage imageNamed:@"tianxiexinxi_tb_6"] forState:UIControlStateNormal];
        iSupContact.isOpenEmail = NO;
    }
    else{
//        [self.email setBackgroundImage:[UIImage imageNamed:@"tianxiexinxi_tb_4"] forState:UIControlStateNormal];
        iSupContact.isOpenEmail = YES;
    }
}
@end
