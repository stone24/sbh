 //
//  SBHDingdanCommonCell.m
//  sbh
//
//  Created by SBH on 14-12-22.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "SBHDingdanCommonCell.h"

@implementation SBHDingdanCommonCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"SBHDingdanCommonCell";
    SBHDingdanCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SBHDingdanCommonCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

-(void)setProject:(projectObj*)aprojectObj
{
    isupprojectObj = aprojectObj;
    
}

@end
