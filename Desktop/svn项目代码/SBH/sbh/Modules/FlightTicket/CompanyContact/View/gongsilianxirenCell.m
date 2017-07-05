//
//  gongsilianxirenCell.m
//  sbh
//
//  Created by musmile on 14-7-7.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "gongsilianxirenCell.h"

@implementation gongsilianxirenCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cell1 = @"cell1";
    gongsilianxirenCell *cell = [tableView dequeueReusableCellWithIdentifier:cell1];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"gongsilianxirenCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    return cell;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.lianxiren.textColor = [ColorConfigure globalBgColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)endOnExit:(id)sender {
}
@end
