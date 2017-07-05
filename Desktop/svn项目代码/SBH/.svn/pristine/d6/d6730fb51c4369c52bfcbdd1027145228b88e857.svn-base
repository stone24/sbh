//
//  BeFlightAuditTableViewCell.m
//  sbh
//
//  Created by RobinLiu on 16/2/24.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeFlightAuditSegTableViewCell.h"
@implementation BeFlightAuditSegTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeFlightAuditTableViewCellIdentifier";
    BeFlightAuditSegTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeFlightAuditSegTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _segControl = [[UISegmentedControl alloc]initWithItems:@[@"部门",@"项目"]];
        _segControl.selectedSegmentIndex = 0;
        _segControl.frame = CGRectMake(10, 4, kScreenWidth - 20, 32);
        _segControl.tintColor = [ColorConfigure globalBgColor];
        _segControl.backgroundColor = [UIColor whiteColor];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:  [UIFont systemFontOfSize:16.f],NSFontAttributeName,nil];
        [_segControl setTitleTextAttributes:dic forState:UIControlStateNormal];
        [self addSubview:_segControl];
    }
    return self;
}
@end
