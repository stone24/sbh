//
//  BeAirOrderDetailFlightCell.m
//  sbh
//
//  Created by SBH on 15/4/29.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeAirOrderDetailFlightCell.h"


@interface BeAirOrderDetailFlightCell ()

/** 航班号 */
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *flightnoLabel;
@property (nonatomic, weak) UILabel *flightnoContentLabel;
/** 起飞时间 */
@property (nonatomic, weak) UILabel *goDateLabel;
@property (nonatomic, weak) UILabel *goDateContentLabel;

/** 到达日期 */
@property (nonatomic, weak) UILabel *reachDateLabel;
@property (nonatomic, weak) UILabel *reachDateContentLabel;

/** 起降机场 */
@property (nonatomic, weak) UILabel *airportLabel;
@property (nonatomic, weak) UILabel *airportContentLabel;
/** 经停 */
@property (nonatomic, weak) UILabel *viaportLabel;
@property (nonatomic, weak) UILabel *viaportContentLabel;
/** 退改规则 */
@property (nonatomic, weak) UIButton *ruleBtn;

/** 线 */
@property (nonatomic, weak) UILabel *line;
@end

@implementation BeAirOrderDetailFlightCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BeAirOrderDetailFlightCell";
    BeAirOrderDetailFlightCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BeAirOrderDetailFlightCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
        titleLabel.textColor = kAirTicketDetailTitleColor;
        titleLabel.font = kAirTicketDetailContentFont;
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *flightnoLabel = [[UILabel alloc] init];
        flightnoLabel.text = @"航班号:";
        flightnoLabel.textAlignment = NSTextAlignmentRight;
        flightnoLabel.textColor = kAirTicketDetailTitleColor;
        flightnoLabel.font = kAirTicketDetailContentFont;
        [self addSubview:flightnoLabel];
        self.flightnoLabel = flightnoLabel;
        
        UILabel *flightnoContentLabel = [[UILabel alloc] init];
        flightnoContentLabel.textColor = kAirTicketDetailContentColor;
        flightnoContentLabel.font = kAirTicketDetailContentFont;
        [self addSubview:flightnoContentLabel];
        self.flightnoContentLabel = flightnoContentLabel;
        
        UILabel *goDateContentLabel = [[UILabel alloc] init];
        goDateContentLabel.textColor = kAirTicketDetailContentColor;
        goDateContentLabel.font = kAirTicketDetailContentFont;
        [self addSubview:goDateContentLabel];
        self.goDateContentLabel = goDateContentLabel;
        
        UILabel *goDateLabel = [[UILabel alloc] init];
        goDateLabel.text = @"起飞日期:";
        goDateLabel.textAlignment = NSTextAlignmentRight;
        goDateLabel.textColor = kAirTicketDetailTitleColor;
        goDateLabel.font = kAirTicketDetailContentFont;
        [self addSubview:goDateLabel];
        self.goDateLabel = goDateLabel;
        
        UILabel *reachDateContentLabel = [[UILabel alloc] init];
        reachDateContentLabel.textColor = kAirTicketDetailContentColor;
        reachDateContentLabel.font = kAirTicketDetailContentFont;
        [self addSubview:reachDateContentLabel];
        self.reachDateContentLabel = reachDateContentLabel;
        
        UILabel *reachDateLabel = [[UILabel alloc] init];
        reachDateLabel.text = @"到达日期:";
        reachDateLabel.textAlignment = NSTextAlignmentRight;
        reachDateLabel.textColor = kAirTicketDetailTitleColor;
        reachDateLabel.font = kAirTicketDetailContentFont;
        [self addSubview:reachDateLabel];
        self.reachDateLabel = reachDateLabel;
        
        UILabel *airportContentLabel = [[UILabel alloc] init];
        airportContentLabel.textColor = kAirTicketDetailContentColor;
        airportContentLabel.font = kAirTicketDetailContentFont;
        airportContentLabel.numberOfLines = 2;
//        airportContentLabel.backgroundColor = [UIColor redColor];
        [self addSubview:airportContentLabel];
        self.airportContentLabel = airportContentLabel;
        
        
        UILabel *airportLabel = [[UILabel alloc] init];
        airportLabel.text = @"起降机场:";
        airportLabel.textAlignment = NSTextAlignmentRight;
        airportLabel.textColor = kAirTicketDetailTitleColor;
        airportLabel.font = kAirTicketDetailContentFont;
        [self addSubview:airportLabel];
        self.airportLabel = airportLabel;
        
        UILabel *viaportContentLabel = [[UILabel alloc] init];
        viaportContentLabel.textColor = kAirTicketDetailContentColor;
        viaportContentLabel.font = kAirTicketDetailContentFont;
        [self addSubview:viaportContentLabel];
        self.viaportContentLabel = viaportContentLabel;
        
        UILabel *viaportLabel = [[UILabel alloc] init];
        viaportLabel.text = @"经停:";
        viaportLabel.textAlignment = NSTextAlignmentRight;
        viaportLabel.textColor = kAirTicketDetailTitleColor;
        viaportLabel.font = kAirTicketDetailContentFont;
        [self addSubview:viaportLabel];
        self.viaportLabel = viaportLabel;
        
        UIButton *ruleBtn = [[UIButton alloc] init];
        ruleBtn.userInteractionEnabled = NO;
        [ruleBtn setTitle:@"退改规则" forState:UIControlStateNormal];
        ruleBtn.titleLabel.font = kAirTicketDetailContentFont;
        [ruleBtn setTitleColor:[ColorConfigure globalBgColor] forState:UIControlStateNormal];
        [self addSubview:ruleBtn];
        self.ruleBtn = ruleBtn;
        
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = SBHLineColor;
       // [self addSubview:line];
      //  self.line = line;
    }
    return self;
}

// 设置控件的坐标
- (void)layoutSubviews
{
    
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(kAirTicketDetailInset, kAirTicketDetailInset, kAirTicketDetailTitleW, kAirTicketDetailTitleH);
    self.titleLabel.text = self.titleStr;
    
    self.flightnoContentLabel.frame = _flightFrame.flightNoFrame;
    self.flightnoContentLabel.text = _flightFrame.flightModel.flightNoStr;
    
    self.flightnoLabel.frame = CGRectMake(kAirTicketDetailInset, _flightFrame.flightNoFrame.origin.y, kAirTicketDetailTitleW, kAirTicketDetailTitleH);
    
    self.goDateContentLabel.frame = _flightFrame.goDateFrame;
    self.goDateContentLabel.text = _flightFrame.flightModel.goDateStr;
    
    self.goDateLabel.frame = CGRectMake(kAirTicketDetailInset, _flightFrame.goDateFrame.origin.y, kAirTicketDetailTitleW, kAirTicketDetailTitleH);
    
    self.reachDateContentLabel.frame = _flightFrame.reachDateFrame;
    self.reachDateContentLabel.text = _flightFrame.flightModel.reachDateStr;
    
    self.reachDateLabel.frame = CGRectMake(kAirTicketDetailInset, _flightFrame.reachDateFrame.origin.y, kAirTicketDetailTitleW, kAirTicketDetailTitleH);
    
    self.airportContentLabel.frame = _flightFrame.AirportFrame;
    self.airportContentLabel.text = _flightFrame.flightModel.airportStr;
    
    self.airportLabel.frame = CGRectMake(kAirTicketDetailInset, _flightFrame.AirportFrame.origin.y, kAirTicketDetailTitleW, kAirTicketDetailTitleH);
    
    self.viaportContentLabel.frame = _flightFrame.viaportFrame;
    self.viaportContentLabel.text = _flightFrame.flightModel.viaportStr;
    
    self.viaportLabel.frame = CGRectMake(kAirTicketDetailInset, _flightFrame.viaportFrame.origin.y, kAirTicketDetailTitleW, kAirTicketDetailTitleH);
    
    self.ruleBtn.frame = CGRectMake(kAirTicketDetailInset, _flightFrame.ruleY, kAirTicketDetailTitleW, kAirTicketDetailTitleH);
    
    self.line.frame = CGRectMake(0, _flightFrame.height - 1, SBHScreenW, 1);
}

@end
