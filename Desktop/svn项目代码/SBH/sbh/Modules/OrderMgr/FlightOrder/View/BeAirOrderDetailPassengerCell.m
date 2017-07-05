//
//  BeAirOrderDetailPassengerCell.m
//  sbh
//
//  Created by SBH on 15/4/30.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeAirOrderDetailPassengerCell.h"

@interface BeAirOrderDetailPassengerCell ()
/** 乘机人 */;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *nameLabel;
/** 证件 */
@property (nonatomic, weak) UILabel *cardLabel;

/** 手机号 */
@property (nonatomic, weak) UILabel *phoneLabel;

/** 票号 */
@property (nonatomic, weak) UILabel *ticketLabel;

/** 线 */
@property (nonatomic, weak) UILabel *line;
@end

@implementation BeAirOrderDetailPassengerCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BeAirOrderDetailPassengerCell";
    BeAirOrderDetailPassengerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BeAirOrderDetailPassengerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    { // 初始化子控件
        UILabel *titleLabel = [[UILabel alloc] init];
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
        
        UILabel *cardLabel = [[UILabel alloc] init];
        cardLabel.textColor = kAirTicketDetailContentColor;
        cardLabel.font = kAirTicketDetailContentFont;
        [self addSubview:cardLabel];
        self.cardLabel = cardLabel;
        
        UILabel *phoneLabel = [[UILabel alloc] init];
        phoneLabel.textColor = kAirTicketDetailContentColor;
        phoneLabel.font = kAirTicketDetailContentFont;
        [self addSubview:phoneLabel];
        self.phoneLabel = phoneLabel;
        
        UILabel *ticketLabel = [[UILabel alloc] init];
        ticketLabel.textColor = kAirTicketDetailContentColor;
        ticketLabel.font = kAirTicketDetailContentFont;
        ticketLabel.numberOfLines = 0;
        [self addSubview:ticketLabel];
        self.ticketLabel = ticketLabel;
        
//        UILabel *line = [[UILabel alloc] init];
//        line.backgroundColor = SBHLineColor;
//        [self addSubview:line];
//        self.line = line;
    }
    return self;
}

// 设置控件的坐标
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(kAirTicketDetailInset, kAirTicketDetailInset, kAirTicketDetailTitleW, kAirTicketDetailTitleH);
    self.titleLabel.text = self.titleStr;
    
    self.nameLabel.frame = _pasF.nameFrame;
    self.nameLabel.text = _pasF.pasM.psgname;
    
    self.cardLabel.frame = _pasF.cardFrame;
    self.cardLabel.text = _pasF.pasM.cardStr;
    
    self.phoneLabel.frame = _pasF.phoneFrame;
    self.phoneLabel.text = _pasF.pasM.phoneStr;
    
    self.ticketLabel.frame = _pasF.ticketNoFrame;
    self.ticketLabel.text = _pasF.pasM.ticketNoStr;
}

@end
