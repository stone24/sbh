//
//  BeHotelOrderHeaderView.m
//  sbh
//
//  Created by RobinLiu on 15/12/14.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelOrderHeaderView.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "CommonDefine.h"
#import "UIImageView+WebCache.h"
#import "BePriceListModel.h"

@interface BeHotelOrderHeaderView ()
{
    UILabel *roomType;
    UILabel *roomName;
    UILabel *RoomPrice;
    UILabel *stayLabel;
}
@end

@implementation BeHotelOrderHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [ColorUtility colorFromHex:0xf3f3f3];
        self.sourceType = 0;
        roomName = [[UILabel alloc]initWithFrame:CGRectMake(14, 10, kScreenWidth, 20)];
        roomName.font = [UIFont systemFontOfSize:15];
        roomName.textColor = [ColorUtility colorFromHex:0x1d1d1d];
        roomName.numberOfLines = 0;
        [self addSubview:roomName];
        
        roomType = [[UILabel alloc]initWithFrame:CGRectMake(roomName.x, CGRectGetMaxY(roomName.frame)+2, kScreenWidth, 15)];
        roomType.font = [UIFont systemFontOfSize:12];
        roomType.textColor = [UIColor grayColor];
        roomType.numberOfLines = 0;
        [self addSubview:roomType];
        
        stayLabel = [[UILabel alloc]initWithFrame:CGRectMake(roomName.x, CGRectGetMaxY(roomType.frame)+2, kScreenWidth, 15)];
        stayLabel.font = [UIFont systemFontOfSize:12];
        stayLabel.textColor = [UIColor grayColor];
        stayLabel.numberOfLines = 0;
        [self addSubview:stayLabel];
        
        RoomPrice = [[UILabel alloc]initWithFrame:CGRectMake(roomName.x, CGRectGetMaxY(stayLabel.frame)+2, kScreenWidth, 15)];
        RoomPrice.font = [UIFont systemFontOfSize:12];
        RoomPrice.textColor = [UIColor grayColor];
        RoomPrice.numberOfLines = 0;
        [self addSubview:RoomPrice];
    }
    return self;
}
- (int)getStayDaysWith:(NSString *)startString andLeaveDate:(NSString *)leaveString
{
    startString = [startString stringByAppendingString:@" 00:00:00"];
    leaveString = [leaveString stringByAppendingString:@" 00:00:00"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate= [dateFormatter dateFromString:startString];
    NSDate *leaveDate = [dateFormatter dateFromString:leaveString];
    NSTimeInterval time=[leaveDate timeIntervalSinceDate:startDate];
    int days = ((int)time)/(3600*24);
    return days;
}
- (void)setWriteModel:(BeHotelOrderWriteModel *)writeModel
{
    _writeModel = writeModel;
    roomName.text = _writeModel.HotelName;
    roomType.text = _writeModel.RoomName;
    
    NSString *str1 = [NSString stringWithFormat:@"入住：%@      ",_writeModel.CheckInDate];
    NSString *str2 = [NSString stringWithFormat:@"离店：%@      ",_writeModel.CheckOutDate];
    NSString *str3 = [NSString stringWithFormat:@"共%d晚",[self getStayDaysWith:_writeModel.CheckInDate andLeaveDate:_writeModel.CheckOutDate]];
    NSMutableAttributedString *dateAttrib = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",str1,str2,str3]];
    [dateAttrib setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(0,[dateAttrib length])];
    [dateAttrib addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, str1.length + str2.length)];
    [dateAttrib addAttribute:NSForegroundColorAttributeName value:[ColorConfigure globalBgColor] range:NSMakeRange(str1.length + str2.length,str3.length)];
    stayLabel.attributedText = dateAttrib;
    
    //应付金额￥1175-优惠金额￥15=应付金额￥1170
    double totalPrice = 0;
    double discount = 0;
    double totalPrice2 = 0;
    
    for(BePriceListModel *prModel in writeModel.priceArray)
    {
        totalPrice = totalPrice + (int)writeModel.Persons.count * [prModel.SalePrice doubleValue];
        discount = discount + (int)writeModel.Persons.count * [prModel.Dr_MinPrice doubleValue];
    }
    totalPrice2 = totalPrice - discount;
    if(self.sourceType == 0)
    {
        NSString *priceStr1 = @"应付总额";
        NSString *priceStr2 = [NSString stringWithFormat:@"￥%.2lf",totalPrice2];
        NSString *priceStr3 = @"";//@" - 优惠金额";
        NSString *priceStr4 = @"";//[NSString stringWithFormat:@"￥%.2lf",discount];
        NSString *priceStr5 = @"";//@" = 应付金额";
        NSString *priceStr6 = @"";//[NSString stringWithFormat:@"￥%.2lf",totalPrice2];
        
        NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@%@",priceStr1,priceStr2,priceStr3,priceStr4,priceStr5,priceStr6];
        NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:str];
        [attrib addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, [priceStr1 length])];
        [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange([priceStr1 length], [priceStr2 length])];
        
        [attrib addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange([priceStr1 length]+ [priceStr2 length], [priceStr3 length])];
        [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange([priceStr1 length]+ [priceStr2 length]+[priceStr3 length], [priceStr4 length])];
        
        [attrib addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange([priceStr1 length]+ [priceStr2 length]+[priceStr3 length]+ [priceStr4 length], [priceStr5 length])];
        [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange([priceStr1 length]+ [priceStr2 length]+[priceStr3 length]+ [priceStr4 length]+[priceStr5 length], [priceStr6 length])];
        RoomPrice.attributedText = attrib;
    }
    else
    {
        NSString *priceStr1 = @"房费";
        NSString *priceStr2 = [NSString stringWithFormat:@"￥%.2f",totalPrice2];
        NSMutableAttributedString *priceAttrib = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",priceStr1,priceStr2]];
        [priceAttrib setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(0,[priceAttrib length])];
        [priceAttrib addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, priceStr1.length)];
        [priceAttrib addAttribute:NSForegroundColorAttributeName value:[ColorConfigure loginButtonColor] range:NSMakeRange(priceStr1.length,priceStr2.length)];
        RoomPrice.attributedText = priceAttrib;
    }
}
@end
