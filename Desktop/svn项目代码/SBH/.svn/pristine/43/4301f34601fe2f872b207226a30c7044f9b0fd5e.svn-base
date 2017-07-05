//
//  BeAirTicketOrderFlightFrame.m
//  sbh
//
//  Created by SBH on 15/4/29.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeAirTicketOrderFlightFrame.h"

@implementation BeAirTicketOrderFlightFrame

- (void)setFlightModel:(BeFlightModel *)flightModel
{
    _flightModel = flightModel;
    
    // 1. 航班号
    CGFloat flightNoX = kAirTicketDetailContentX;
    CGFloat flightNoY = kAirTicketDetailInset + 23;
    NSString *flightNoStr = [NSString stringWithFormat:@"%@(%@)", flightModel.flightno, flightModel.aircraftcode];
    _flightModel.flightNoStr = flightNoStr;
    CGSize flightNoSize = [flightNoStr sizeWithAttributes:@{NSFontAttributeName:kAirTicketDetailContentFont}];
    self.flightNoFrame = (CGRect){{flightNoX, flightNoY}, flightNoSize};
    
    // 2.起飞日期
    CGFloat goDateX = kAirTicketDetailContentX;
    CGFloat goDateY = CGRectGetMaxY(self.flightNoFrame) + kAirTicketDetailInset;
    NSMutableString *timeStrM = [NSMutableString stringWithString:flightModel.flttime];
    [timeStrM insertString:@":" atIndex:2];
    NSString *goDateStr = [NSString stringWithFormat:@"%@ %@", flightModel.fltdate, timeStrM];
    _flightModel.goDateStr = goDateStr;
    CGSize goDateSize = [goDateStr sizeWithAttributes:@{NSFontAttributeName:kAirTicketDetailContentFont}];
    self.goDateFrame = (CGRect){{goDateX, goDateY}, goDateSize};
    
    // 3. 到达时间
    CGFloat reachDateX = kAirTicketDetailContentX;
    CGFloat reachDateY = CGRectGetMaxY(self.goDateFrame) + kAirTicketDetailInset;
    NSMutableString *reachTimeStrM = [NSMutableString stringWithString:flightModel.arrivaltime];
    [reachTimeStrM insertString:@":" atIndex:2];
    NSString *reachDateStr = [NSString stringWithFormat:@"%@ %@", flightModel.arrivaldate, reachTimeStrM];
    _flightModel.reachDateStr = reachDateStr;
    CGSize reachDateSize = [reachDateStr sizeWithAttributes:@{NSFontAttributeName:kAirTicketDetailContentFont}];
    self.reachDateFrame = (CGRect){{reachDateX, reachDateY}, reachDateSize};
    
    // 4. 直降机场
    CGFloat airportX = kAirTicketDetailContentX;
    CGFloat airportY = CGRectGetMaxY(self.reachDateFrame) + kAirTicketDetailInset;
    NSString *upStr =[NSString stringWithFormat:@"%@%@", flightModel.boardname, flightModel.boardpointat];
    NSString *dropStr =[NSString stringWithFormat:@"%@%@", flightModel.offname, flightModel.offpointat];
    NSString *airportStr = [NSString stringWithFormat:@"%@\n%@", upStr, dropStr];
    _flightModel.airportStr = airportStr;
    CGSize airportSize = [airportStr boundingRectWithSize:CGSizeMake(SBHScreenW - airportX - kAirTicketDetailInset, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kAirTicketDetailContentFont} context:nil].size;
    self.AirportFrame = (CGRect){{airportX, airportY}, airportSize};
    
    // 5.经停
    CGFloat viaportX = kAirTicketDetailContentX;
    CGFloat viaportY = CGRectGetMaxY(self.AirportFrame) + kAirTicketDetailInset;
    CGSize viaportSize = [flightModel.viaportStr sizeWithAttributes:@{NSFontAttributeName:kAirTicketDetailContentFont}];
    self.viaportFrame = (CGRect){{viaportX, viaportY}, viaportSize};
    
    self.ruleY = CGRectGetMaxY(self.viaportFrame) + kAirTicketDetailInset;
    // 自己
    self.height = viaportSize.height + self.ruleY + kAirTicketDetailInset;
}
@end
