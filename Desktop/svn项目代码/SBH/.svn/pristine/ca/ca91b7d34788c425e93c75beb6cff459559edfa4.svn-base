//
//  BeAirOrderDetailPassengerFrame.m
//  sbh
//
//  Created by SBH on 15/4/30.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeAirOrderDetailPassengerFrame.h"

@implementation BeAirOrderDetailPassengerFrame

- (void)setPasM:(BePassengerModel *)pasM
{
    _pasM = pasM;
    // 1. 乘机人
    CGFloat nameX = kAirTicketDetailContentX;
    CGFloat nameY = kAirTicketDetailInset;
    CGSize nameSize = [pasM.psgname sizeWithAttributes:@{NSFontAttributeName:kAirTicketDetailContentFont}];
    self.nameFrame = (CGRect){{nameX, nameY}, nameSize};
    
    // 2.证件
    CGFloat cardX = kAirTicketDetailContentX;
    CGFloat cardY = CGRectGetMaxY(self.nameFrame) + kAirTicketDetailInset;
    NSString *cardStr = [NSString stringWithFormat:@"%@:%@", pasM.cardtypename, pasM.cardno];
    _pasM.cardStr = cardStr;
    CGSize cardSize = [cardStr sizeWithAttributes:@{NSFontAttributeName:kAirTicketDetailContentFont}];
    self.cardFrame = (CGRect){{cardX, cardY}, cardSize};
    
    // 3. 手机号
    CGFloat phoneX = kAirTicketDetailContentX;
    CGFloat phoneY = CGRectGetMaxY(self.cardFrame) + kAirTicketDetailInset;
    NSString *phoneStr = @"";
    if (pasM.mobilephone.length != 0) {
        phoneStr = [NSString stringWithFormat:@"手机号:%@", pasM.mobilephone];
    }
    _pasM.phoneStr = phoneStr;
    CGSize phoneSize = [phoneStr sizeWithAttributes:@{NSFontAttributeName:kAirTicketDetailContentFont}];
    self.phoneFrame = (CGRect){{phoneX, phoneY}, phoneSize};
    
    // 4. 票号
    CGFloat ticketNoX = kAirTicketDetailContentX;
 
    CGFloat ticketNoY = 0;
    if (pasM.mobilephone.length != 0) {
       ticketNoY = CGRectGetMaxY(self.phoneFrame) + kAirTicketDetailInset;
    } else {
       ticketNoY = CGRectGetMaxY(self.cardFrame) + kAirTicketDetailInset;
    }
    
    BeAirticketModel *goTicketM = pasM.airtickets.firstObject;
    NSString *ticketNoStr = @"";
    CGSize ticketNoSize = CGSizeMake(0, 0);
    if (goTicketM.tktno.length != 0) {
        NSString *backTicStr = @"";
        if (pasM.airtickets.count > 1) {
            BeAirticketModel *backTicketM = pasM.airtickets.lastObject;
            backTicStr = backTicketM.tktno;
        }
        if (backTicStr.length != 0) {
            ticketNoStr = [NSString stringWithFormat:@"票号:%@/%@", goTicketM.tktno, backTicStr];
        } else {
            ticketNoStr = [NSString stringWithFormat:@"票号:%@", goTicketM.tktno];
        }
       ticketNoSize = [ticketNoStr boundingRectWithSize:CGSizeMake(SBHScreenW - ticketNoX - kAirTicketDetailInset, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kAirTicketDetailContentFont} context:nil].size;
    }
    _pasM.ticketNoStr = ticketNoStr;
    self.ticketNoFrame = (CGRect){{ticketNoX, ticketNoY}, ticketNoSize};
    
    // 自己
    if (ticketNoSize.height == 0) {
        self.height = CGRectGetMaxY(self.ticketNoFrame);
    } else {
        self.height = CGRectGetMaxY(self.ticketNoFrame) + kAirTicketDetailInset;
    }
    
}
@end
