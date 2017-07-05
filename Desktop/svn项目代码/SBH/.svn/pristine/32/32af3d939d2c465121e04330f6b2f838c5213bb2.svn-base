//
//  BeOrderTitleTableViewCell.m
//  sbh
//
//  Created by RobinLiu on 16/7/12.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeOrderTitleTableViewCell.h"

@implementation BeOrderTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeOrderTitleTableViewCellIdentifier";
    BeOrderTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[BeOrderTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
        self.titleLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:self.titleLabel];
        self.bookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bookButton.frame = CGRectMake(kScreenWidth - 85, 7, 72, 23);
        self.bookButton.layer.cornerRadius = 3.0f;
        [self.bookButton setBackgroundColor:[ColorConfigure globalBgColor]];
        self.bookButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.bookButton];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
