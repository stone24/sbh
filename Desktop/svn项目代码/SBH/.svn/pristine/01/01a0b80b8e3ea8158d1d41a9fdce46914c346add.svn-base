//
//  tianjiaxinTableViewCell.m
//  sbh
//
//  Created by musmile on 14-7-8.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "BePassengerDetailTableViewCell.h"
#import "CommonDefine.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"

@implementation BePassengerDetailTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    BePassengerDetailTableViewCell *cell = nil;
    static NSString *cellIdentifier2 = @"cell1";
    cell = [[BePassengerDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    [cell setupSubviews];
    return cell;
}
- (void)setupSubviews
{
    self.lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 100, 20)];
    self.lab.font = [UIFont systemFontOfSize:17];
    self.lab.textColor = [ColorConfigure globalBgColor];
    [self addSubview:self.lab];
    
    self.textfield = [[UITextField alloc]initWithFrame:CGRectMake(106, 12, kScreenWidth - 106 - 35, 18)];
    self.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:self.textfield];
    
    self.assistIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    self.assistIcon.frame = CGRectMake(kScreenWidth - 33, 11, 17, 17);
    [self.assistIcon setImage:[UIImage imageNamed:@"common_icon_arrow"] forState:UIControlStateNormal];
    [self addSubview:self.assistIcon];
}
@end
