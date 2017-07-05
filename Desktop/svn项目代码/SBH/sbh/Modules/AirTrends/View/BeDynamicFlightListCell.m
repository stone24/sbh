//
//  BeDynamicFlightListCell.m
//  SideBenefit
//
//  Created by SBH on 15-3-6.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeDynamicFlightListCell.h"

@implementation BeDynamicFlightListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"Tie";
    
    BeDynamicFlightListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BeDynamicFlightListCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
        cell.backgroundColor = SBHColor(249, 249, 249);
        [cell.careBtn setTitle:@"我要关注" forState:UIControlStateNormal];
        [cell.careBtn setTitle:@"取消关注" forState:UIControlStateSelected];
        [cell.careBtn setTitleColor:SBHColor(82, 177, 0) forState:UIControlStateNormal];
        [cell.careBtn setTitleColor:SBHColor(235, 159, 28) forState:UIControlStateSelected];
        
        [cell.careBtn setBackgroundColor:[UIColor clearColor]];
    }
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
