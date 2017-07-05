//
//  dingdantianxieTableViewCell.m
//  SBHAPP
//
//  Created by musmile on 14-7-2.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "dingdantianxieTableViewCell.h"

@implementation dingdantianxieTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    dingdantianxieTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"dingdantianxieTableViewCell" owner:nil options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)endexit:(id)sender {
    isupprojectObj.projectValue = self.itextfield.text;
}

- (IBAction)changingValue:(id)sender {
    isupprojectObj.projectValue = self.itextfield.text;
}

-(void)setProject:(projectObj*)aprojectObj
{
    isupprojectObj = aprojectObj;
    
}
@end
