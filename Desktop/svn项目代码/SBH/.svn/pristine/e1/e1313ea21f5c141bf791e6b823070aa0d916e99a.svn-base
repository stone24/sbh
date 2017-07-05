//
//  BeAirOrderDetailContactCell.m
//  sbh
//
//  Created by SBH on 15/4/30.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeAirOrderDetailContactCell.h"

@interface BeAirOrderDetailContactCell ()
/** 乘机人 */;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *nameLabel;

/** 手机号 */
@property (nonatomic, weak) UILabel *phoneLabel;

/** 线 */
@property (nonatomic, weak) UILabel *line;

@end

@implementation BeAirOrderDetailContactCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BeAirOrderDetailContactCell";
    BeAirOrderDetailContactCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BeAirOrderDetailContactCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) { // 初始化子控件
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"联系人:";
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.textColor = kAirTicketDetailTitleColor;
        titleLabel.font = kAirTicketDetailContentFont;
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = kAirTicketDetailContentColor;
        nameLabel.font = kAirTicketDetailContentFont;
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UILabel *phoneLabel = [[UILabel alloc] init];
        phoneLabel.textColor = kAirTicketDetailContentColor;
        phoneLabel.font = kAirTicketDetailContentFont;
        [self addSubview:phoneLabel];
        self.phoneLabel = phoneLabel;
        
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = SBHLineColor;
        [self addSubview:line];
        self.line = line;
    }
    return self;
}

// 设置控件的坐标
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(kAirTicketDetailInset, kAirTicketDetailInset, kAirTicketDetailTitleW, kAirTicketDetailTitleH);
    self.titleLabel.text = self.titleStr;
    
    self.nameLabel.frame = _conF.nameFrame;
    self.nameLabel.text = _conF.conM.pername;
    
    self.phoneLabel.frame = _conF.phoneFrame;
    self.phoneLabel.text = _conF.conM.phoneStr;
    
    if (self.titleStr.length != 0) {
        self.line.frame = CGRectMake(0, 0, SBHScreenW, 1);
    }
}

@end
