//
//  BeAirOrderDetailContact.m
//  sbh
//
//  Created by SBH on 15/4/30.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeAirOrderDetailContactFrame.h"

@implementation BeAirOrderDetailContactFrame

-(void)setConM:(BeOrderContactModel *)conM
{
    _conM = conM;
    
    // 1.名字
    CGFloat nameX = kAirTicketDetailContentX;
    CGFloat nameY = kAirTicketDetailInset;
    CGSize nameSize = [conM.pername sizeWithAttributes:@{NSFontAttributeName:kAirTicketDetailContentFont}];
    self.nameFrame = (CGRect){{nameX, nameY}, nameSize};
    
    // 2. 手机号
    CGFloat phoneX = kAirTicketDetailContentX;
    CGFloat phoneY = CGRectGetMaxY(self.nameFrame) + kAirTicketDetailInset;
    NSString *phoneStr = [NSString stringWithFormat:@"手机号:%@", conM.phone];
    _conM.phoneStr = phoneStr;
    CGSize phoneSize = [phoneStr sizeWithAttributes:@{NSFontAttributeName:kAirTicketDetailContentFont}];
    self.phoneFrame = (CGRect){{phoneX, phoneY}, phoneSize};
    
    // 自己
    self.height = CGRectGetMaxY(self.phoneFrame) + kAirTicketDetailInset;
}
@end
