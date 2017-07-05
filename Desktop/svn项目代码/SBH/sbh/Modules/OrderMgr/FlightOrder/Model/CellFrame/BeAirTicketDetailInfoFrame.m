//
//  BeAirTicketDetailInfoFrame.m
//  sbh
//
//  Created by SBH on 15/4/29.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeAirTicketDetailInfoFrame.h"

//#define kAirTicketDetailInset 10
//#define kAirTicketDetailContentX 73
//#define kAirTicketDetailContentFont [UIFont systemFontOfSize:14]

@implementation BeAirTicketDetailInfoFrame

- (void)setInfoModel:(BeOrderInfoModel *)infoModel
{
    _infoModel = infoModel;
    // 1 订单号内容 
    CGFloat orderNoX = kAirTicketDetailContentX;
    CGFloat orderNoY = kAirTicketDetailInset;
    CGSize orderNoSize = [infoModel.orderno sizeWithAttributes:@{NSFontAttributeName:kAirTicketDetailContentFont}];
    self.orderNoContentFrame = (CGRect){{orderNoX, orderNoY}, orderNoSize};
    
    // 2.订单金额内容
    CGFloat orderSumX = orderNoX;
    CGFloat orderSumY = CGRectGetMaxY(self.orderNoContentFrame) + kAirTicketDetailInset;
    NSString *sumStr = nil;
    float sum = [infoModel.accountreceivable floatValue]+
    [infoModel.servicecharge floatValue];
    if([[NSString stringWithFormat:@"%.0f", sum] intValue]== sum)
    {
        sumStr = [NSString stringWithFormat:@"￥%.0f", sum];
    }
    else
    {
        sumStr = [NSString stringWithFormat:@"￥%.1f", sum];
    }
    CGSize orderSumSize = [sumStr sizeWithAttributes:@{NSFontAttributeName:kAirTicketDetailContentFont}];
    self.orderSumContentFrame = (CGRect){{orderSumX, orderSumY}, orderSumSize};
    
    CGRect tempRect = self.orderSumContentFrame;
    // 3.金额明细
    if (self.showSumDetail) {
        CGFloat sumDetailX = kAirTicketDetailInset + 10;
        CGFloat sumDetailY = CGRectGetMaxY(self.orderSumContentFrame) + kAirTicketDetailInset;
        
        NSString *sumDetailStr = [NSString stringWithFormat:@"票面￥%@/机建￥%@/燃油￥%@/保险￥%@/服务费￥%d",infoModel.sellprice,infoModel.airporttax,infoModel.fueltex,infoModel.insurancepricetotal, [infoModel.servicecharge intValue]];
        if (_isTrainType)
        {
            NSString *ticketString = [NSString string];
            if([infoModel.sellprice floatValue]==[infoModel.sellprice intValue])
            {
                ticketString = [NSString stringWithFormat:@"%d",[infoModel.sellprice intValue]];
            }
            else
            {
                ticketString = [NSString stringWithFormat:@"%.1f", [infoModel.sellprice floatValue]];
            }
            float servicePrice = [infoModel.accountreceivable floatValue] - [infoModel.sellprice floatValue];
            _infoModel.sumDetailStr = [NSString stringWithFormat:@"票面￥%@/服务费￥%.0f",ticketString,servicePrice];
        }
        else
        {
            _infoModel.sumDetailStr = sumDetailStr;
        }
        CGSize sumDetailSize = [sumDetailStr sizeWithAttributes:@{NSFontAttributeName:kAirTicketPriceDetailFont}];
        self.sumDetailContentFrame = (CGRect){{sumDetailX, sumDetailY}, sumDetailSize};
        tempRect = self.sumDetailContentFrame;
    }
    
    // 4.订单状态
    CGFloat orderStatusX = orderNoX;
    CGFloat orderStatusY = CGRectGetMaxY(tempRect) + kAirTicketDetailInset;
    NSString *orderStatusStr = infoModel.orderst;
    if ([orderStatusStr isEqualToString:@"已订座"]) {
            orderStatusStr = [NSString stringWithFormat:@"%@ 待支付", infoModel.orderst];
    }
    if (infoModel.changeremark.length != 0){
        orderStatusStr = [NSString stringWithFormat:@"%@(%@)", orderStatusStr,infoModel.changeremark];
    }
    _infoModel.orderstStr = orderStatusStr;
    CGSize airportSize = [orderStatusStr boundingRectWithSize:CGSizeMake(SBHScreenW - orderStatusX, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kAirTicketDetailContentFont} context:nil].size;
//    CGSize orderStatusSize = [orderStatusStr sizeWithAttributes:@{NSFontAttributeName:kAirTicketDetailContentFont}];
    self.orderStatusContentFrame = (CGRect){{orderStatusX, orderStatusY}, airportSize};
    
    // 5.创建时间 
    CGFloat creatDateX = orderNoX;
    CGFloat creatDateY = CGRectGetMaxY(self.orderStatusContentFrame) + kAirTicketDetailInset;
    CGSize creatDateSize = [infoModel.creattime sizeWithAttributes:@{NSFontAttributeName:kAirTicketDetailContentFont}];
    self.creatDateContentFrame = (CGRect){{creatDateX, creatDateY}, creatDateSize};
    
    // 6. 预订人
    CGFloat bookerX = orderNoX;
    CGFloat bookerY = CGRectGetMaxY(self.creatDateContentFrame) + kAirTicketDetailInset;
    CGSize bookerSize = [infoModel.bookingman sizeWithAttributes:@{NSFontAttributeName:kAirTicketDetailContentFont}];
    self.bookerContentFrame = (CGRect){{bookerX, bookerY}, bookerSize};
    
    // 自己
    self.height = CGRectGetMaxY(self.bookerContentFrame) + kAirTicketDetailInset;
}
@end
