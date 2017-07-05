//
//  SBHMyCell.m
//  sbh
//
//  Created by SBH on 15-1-20.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "SBHMyCell.h"

@implementation SBHMyCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"SBHMyCell";
    
    SBHMyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SBHMyCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType  = UITableViewCellAccessoryNone;
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
