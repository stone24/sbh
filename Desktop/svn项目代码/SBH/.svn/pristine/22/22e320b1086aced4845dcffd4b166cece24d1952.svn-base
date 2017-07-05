//
//  BeHotleSearchItemTableViewCell.m
//  SideBenefit
//
//  Created by RobinLiu on 15/3/11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotleSearchItemTableViewCell.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"

@implementation BeHotleSearchItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeHotleSearchItemTableViewCell";
    BeHotleSearchItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[[NSBundle mainBundle] loadNibNamed:@"BeHotleSearchItemTableViewCell" owner:nil options:nil] firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if(self.selected == YES)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentLabel.textColor = [ColorConfigure globalBgColor];
    }
    else
    {
        if(self.unSelectBgColor)
        {
            self.contentView.backgroundColor = self.unSelectBgColor;
        }
        else
        {
            self.contentView.backgroundColor = [ColorUtility colorWithRed:215 green:215 blue:215];

        }
        self.contentLabel.textColor = [UIColor blackColor];
    }
}

@end
