//
//  BeAirTicketOrderInfoCellTableViewCell.m
//  sbh
//
//  Created by SBH on 15/4/29.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeAirTicketOrderInfoCell.h"

@interface BeAirTicketOrderInfoCell ()


@end

@implementation BeAirTicketOrderInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BeAirTicketOrderInfoCell";
    BeAirTicketOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BeAirTicketOrderInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) { // 初始化子控件
        UILabel *ordernoLabel = [[UILabel alloc] init];
        ordernoLabel.text = @"订单号:";
        ordernoLabel.textAlignment = NSTextAlignmentRight;
        ordernoLabel.textColor = kAirTicketDetailTitleColor;
        ordernoLabel.font = kAirTicketDetailContentFont;
        [self addSubview:ordernoLabel];
        self.ordernoLabel = ordernoLabel;
        
        UILabel *ordernoContentLabel = [[UILabel alloc] init];
        ordernoContentLabel.textColor = kAirTicketDetailContentColor;
        ordernoContentLabel.font = kAirTicketDetailContentFont;
        [self addSubview:ordernoContentLabel];
        self.ordernoContentLabel = ordernoContentLabel;
        
        UILabel *orderSumContentLabel = [[UILabel alloc] init];
        orderSumContentLabel.textColor = SBHYellowColor;
        orderSumContentLabel.font = kAirTicketDetailContentFont;
        [self addSubview:orderSumContentLabel];
        self.orderSumContentLabel = orderSumContentLabel;
        
        UILabel *detailBtn = [[UILabel alloc] init];
        detailBtn.text = @"明细";
        detailBtn.textColor = [ColorConfigure globalBgColor];
        detailBtn.font = kAirTicketPriceDetailFont;
        [self addSubview:detailBtn];
        self.detailBtn = detailBtn;
        
        UILabel *orderSumLabel = [[UILabel alloc] init];
        orderSumLabel.text = @"订单金额:";
        orderSumLabel.textAlignment = NSTextAlignmentRight;
        orderSumLabel.textColor = kAirTicketDetailTitleColor;
        orderSumLabel.font = kAirTicketDetailContentFont;
        [self addSubview:orderSumLabel];
        self.orderSumLabel = orderSumLabel;
        
        UILabel *sumDetailContentLabel = [[UILabel alloc] init];
        sumDetailContentLabel.textColor = SBHYellowColor;
        sumDetailContentLabel.font = kAirTicketPriceDetailFont;
        [self addSubview:sumDetailContentLabel];
        self.sumDetailContentLabel = sumDetailContentLabel;
        
        UILabel *orderStContentLabel = [[UILabel alloc] init];
        orderStContentLabel.textColor = kAirTicketDetailContentColor;
        orderStContentLabel.font = kAirTicketDetailContentFont;
        orderStContentLabel.numberOfLines = 0;
        [self addSubview:orderStContentLabel];
        self.orderStContentLabel = orderStContentLabel;
        
        UILabel *orderStLabel = [[UILabel alloc] init];
        orderStLabel.text = @"订单状态:";
        orderStLabel.textAlignment = NSTextAlignmentRight;
        orderStLabel.textColor = kAirTicketDetailTitleColor;
        orderStLabel.font = kAirTicketDetailContentFont;
        [self addSubview:orderStLabel];
        self.orderStLabel = orderStLabel;
        
        UILabel *creatDateContentLabel = [[UILabel alloc] init];
        creatDateContentLabel.textColor = kAirTicketDetailContentColor;
        creatDateContentLabel.font = kAirTicketDetailContentFont;
        [self addSubview:creatDateContentLabel];
        self.creatDateContentLabel = creatDateContentLabel;
        
        UILabel *creatDateLabel = [[UILabel alloc] init];
        creatDateLabel.text = @"创建时间:";
        creatDateLabel.textAlignment = NSTextAlignmentRight;
        creatDateLabel.textColor = kAirTicketDetailTitleColor;
        creatDateLabel.font = kAirTicketDetailContentFont;
        [self addSubview:creatDateLabel];
        self.creatDateLabel = creatDateLabel;
        
        UILabel *bookerContentLabel = [[UILabel alloc] init];
        bookerContentLabel.textColor = kAirTicketDetailContentColor;
        bookerContentLabel.font = kAirTicketDetailContentFont;
        [self addSubview:bookerContentLabel];
        self.bookerContentLabel = bookerContentLabel;
        
        UILabel *bookerLabel = [[UILabel alloc] init];
        bookerLabel.text = @"预订人:";
        bookerLabel.textAlignment = NSTextAlignmentRight;
        bookerLabel.textColor = kAirTicketDetailTitleColor;
        bookerLabel.font = kAirTicketDetailContentFont;
        [self addSubview:bookerLabel];
        self.bookerLabel = bookerLabel;
    }
    return self;
}

- (void)setInfoFrame:(BeAirTicketDetailInfoFrame *)infoFrame
{
    _infoFrame = infoFrame;
    self.ordernoLabel.frame = CGRectMake(kAirTicketDetailInset, kAirTicketDetailInset, kAirTicketDetailTitleW, kAirTicketDetailTitleH);
    
    self.ordernoContentLabel.frame = infoFrame.orderNoContentFrame;
    self.ordernoContentLabel.text = infoFrame.infoModel.orderno;
    
    self.orderSumContentLabel.frame = infoFrame.orderSumContentFrame;
    //self.orderSumContentLabel.text = [NSString stringWithFormat:@"￥%d", [infoFrame.infoModel.accountreceivable intValue]+[infoFrame.infoModel.servicecharge intValue]];
    float sum = [infoFrame.infoModel.accountreceivable floatValue]+
    [infoFrame.infoModel.servicecharge floatValue];
    if([[NSString stringWithFormat:@"%.0f", sum] intValue]== sum)
    {
        self.orderSumContentLabel.text = [NSString stringWithFormat:@"￥%.0f", sum];
    }
    else
    {
        self.orderSumContentLabel.text = [NSString stringWithFormat:@"￥%.1f", sum];
    }
    // 明细按钮
    self.detailBtn.frame = CGRectMake(CGRectGetMaxX(self.orderSumContentLabel.frame) + kAirTicketDetailInset, infoFrame.orderSumContentFrame.origin.y, 30, 16);
    
    self.orderSumLabel.frame = CGRectMake(kAirTicketDetailInset, infoFrame.orderSumContentFrame.origin.y, kAirTicketDetailTitleW, kAirTicketDetailTitleH);
    
    if (infoFrame.showSumDetail) {
        self.sumDetailContentLabel.frame = infoFrame.sumDetailContentFrame;
        self.sumDetailContentLabel.text = infoFrame.infoModel.sumDetailStr;
    } else {
        self.sumDetailContentLabel.text = @"";
    }

    self.orderStContentLabel.frame = infoFrame.orderStatusContentFrame;
    if ([infoFrame.infoModel.orderst isEqualToString:@"已订座"]) {
       // NSString *string = [NSString stringWithFormat:@"%@ 待支付", infoFrame.infoModel.orderst];
        NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:infoFrame.infoModel.orderstStr];
        [attrib addAttribute:NSForegroundColorAttributeName value:SBHColor(90, 181, 12) range:NSMakeRange(4, 3)];
        self.orderStContentLabel.attributedText = attrib;
    } else {
        self.orderStContentLabel.text = infoFrame.infoModel.orderstStr;
    }    
    self.orderStLabel.frame = CGRectMake(kAirTicketDetailInset, infoFrame.orderStatusContentFrame.origin.y, kAirTicketDetailTitleW, kAirTicketDetailTitleH);
    
    self.creatDateContentLabel.frame = infoFrame.creatDateContentFrame;
    self.creatDateContentLabel.text = infoFrame.infoModel.creattime;
    
    self.creatDateLabel.frame = CGRectMake(kAirTicketDetailInset, infoFrame.creatDateContentFrame.origin.y, kAirTicketDetailTitleW, kAirTicketDetailTitleH);
    
    self.bookerContentLabel.frame = infoFrame.bookerContentFrame;
    self.bookerContentLabel.text = infoFrame.infoModel.bookingman;
    
    self.bookerLabel.frame = CGRectMake(kAirTicketDetailInset, infoFrame.bookerContentFrame.origin.y, kAirTicketDetailTitleW, kAirTicketDetailTitleH);
}
@end