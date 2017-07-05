//
//  BeTrainInfoCell.m
//  sbh
//
//  Created by SBH on 15/6/17.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTrainInfoCell.h"

@interface BeTrainInfoCell ()

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

@implementation BeTrainInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BeTrainInfoCell";
    BeTrainInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BeTrainInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) { // 初始化子控件
        
        UILabel *flightnoLabel = [[UILabel alloc] init];
        flightnoLabel.text = @"车次:";
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
        goDateLabel.text = @"发车时间:";
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
        reachDateLabel.text = @"到达时间:";
        reachDateLabel.textAlignment = NSTextAlignmentRight;
        reachDateLabel.textColor = kAirTicketDetailTitleColor;
        reachDateLabel.font = kAirTicketDetailContentFont;
        [self addSubview:reachDateLabel];
        self.reachDateLabel = reachDateLabel;
        
        UILabel *airportContentLabel = [[UILabel alloc] init];
        airportContentLabel.textColor = kAirTicketDetailContentColor;
        airportContentLabel.font = kAirTicketDetailContentFont;
        [self addSubview:airportContentLabel];
        self.airportContentLabel = airportContentLabel;
        
        
        UILabel *airportLabel = [[UILabel alloc] init];
        airportLabel.text = @"始发车站:";
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
        viaportLabel.text = @"到达车站:";
        viaportLabel.textAlignment = NSTextAlignmentRight;
        viaportLabel.textColor = kAirTicketDetailTitleColor;
        viaportLabel.font = kAirTicketDetailContentFont;
        [self addSubview:viaportLabel];
        self.viaportLabel = viaportLabel;
        
        UIButton *ruleBtn = [[UIButton alloc] init];
       // [ruleBtn setTitle:@"退改规则" forState:UIControlStateNormal];
        ruleBtn.titleLabel.font = kAirTicketDetailContentFont;
        [ruleBtn setTitleColor:kBlueColor forState:UIControlStateNormal];
        [self addSubview:ruleBtn];
        self.ruleBtn = ruleBtn;
        self.ruleBtn.userInteractionEnabled = NO;
        
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
    CGFloat commonW = SBHScreenW - kAirTicketDetailInset - kAirTicketDetailTitleW;
    
    self.flightnoLabel.frame = CGRectMake(kAirTicketDetailInset, kAirTicketDetailInset, kAirTicketDetailTitleW, kAirTicketDetailTitleH);
    self.flightnoContentLabel.frame = CGRectMake(kAirTicketDetailContentX , kAirTicketDetailInset, commonW, kAirTicketDetailTitleH);
    self.flightnoContentLabel.text = self.trainModel.trainno;
    
    self.goDateLabel.frame = CGRectMake(kAirTicketDetailInset, CGRectGetMaxY(self.flightnoContentLabel.frame) + kAirTicketDetailInset, kAirTicketDetailTitleW, kAirTicketDetailTitleH);
    self.goDateContentLabel.frame = CGRectMake(kAirTicketDetailContentX , self.goDateLabel.y, commonW, kAirTicketDetailTitleH);
    self.goDateContentLabel.text = [NSString stringWithFormat:@"%@ %@", self.trainModel.departdate, self.trainModel.departtime];

    self.reachDateLabel.frame = CGRectMake(kAirTicketDetailInset, CGRectGetMaxY(self.goDateLabel.frame) + kAirTicketDetailInset, kAirTicketDetailTitleW, kAirTicketDetailTitleH);
    self.reachDateContentLabel.frame = CGRectMake(kAirTicketDetailContentX , self.reachDateLabel.y, commonW, kAirTicketDetailTitleH);
    self.reachDateContentLabel.text = [NSString stringWithFormat:@"%@ %@", self.trainModel.arrivaldate, self.trainModel.arrivatime];

    self.airportLabel.frame = CGRectMake(kAirTicketDetailInset, CGRectGetMaxY(self.reachDateLabel.frame) + kAirTicketDetailInset, kAirTicketDetailTitleW, kAirTicketDetailTitleH);
    self.airportContentLabel.frame = CGRectMake(kAirTicketDetailContentX , self.airportLabel.y, commonW, kAirTicketDetailTitleH);
    self.airportContentLabel.text = self.trainModel.boardpointname;
    
    self.viaportLabel.frame = CGRectMake(kAirTicketDetailInset, CGRectGetMaxY(self.airportLabel.frame) + kAirTicketDetailInset, kAirTicketDetailTitleW, kAirTicketDetailTitleH);
    self.viaportContentLabel.frame = CGRectMake(kAirTicketDetailContentX , self.viaportLabel.y, commonW, kAirTicketDetailTitleH);
    self.viaportContentLabel.text = self.trainModel.offpointname;

    self.ruleBtn.frame = CGRectMake(kAirTicketDetailInset, CGRectGetMaxY(self.viaportLabel.frame) + kAirTicketDetailInset, kAirTicketDetailTitleW, kAirTicketDetailTitleH);
    
    self.line.frame = CGRectMake(0, CGRectGetMaxY(self.ruleBtn.frame) + kAirTicketDetailInset, SBHScreenW, 1);
}

@end
