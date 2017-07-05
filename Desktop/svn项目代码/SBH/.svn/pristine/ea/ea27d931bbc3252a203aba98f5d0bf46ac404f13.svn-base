//
//  BeHotelRoomListFrame.m
//  sbh
//
//  Created by RobinLiu on 16/9/20.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeHotelRoomListFrame.h"

@implementation BeHotelRoomListFrame
- (void)setDisplayModel:(BeHotelRoomListDisplayModel *)displayModel
{
    _displayModel = displayModel;
    
    _bookFrame = CGRectMake(kScreenWidth - 54, 0, 40, 22);
    CGFloat verMargin = 6;
    CGSize priceSize = [displayModel.priceString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:17]} context:nil].size;
    _priceFrame = CGRectMake(kScreenWidth - 14 - _bookFrame.size.width - priceSize.width - 5, 0, priceSize.width, 22);

    _guaranteeFrame = CGRectZero;

    CGFloat nameY = verMargin;

    if(displayModel.guaranteeString.length > 0)
    {
        CGSize guaSize = [displayModel.guaranteeString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        _guaranteeFrame = CGRectMake( _priceFrame.origin.x - guaSize.width - 3, nameY, guaSize.width, guaSize.height);
    }
    
    CGFloat nameX = 14;

    CGFloat nameWidth = _priceFrame.origin.x - nameX -1 - _guaranteeFrame.size.width;
    
    CGSize nameSize = [displayModel.HotelName boundingRectWithSize:CGSizeMake(nameWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    _HotelNameFrame = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    
    if(_HotelNameFrame.size.width < nameWidth && displayModel.guaranteeString.length > 0 )
    {
        _guaranteeFrame.origin.x = CGRectGetMaxX(_HotelNameFrame) + 1;
    }
    
    CGSize paySize = [displayModel.payString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;

    _payFrame = CGRectMake(nameX, CGRectGetMaxY(_HotelNameFrame) + verMargin, paySize.width, paySize.height);
    
    CGSize cancelSize = [displayModel.cancelString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    
    _cancelFrame = CGRectMake(CGRectGetMaxX(_payFrame), _payFrame.origin.y, cancelSize.width, cancelSize.height);
    
    _cellHeight = CGRectGetMaxY(_payFrame) + verMargin;
    
    _bookFrame.origin.y = _cellHeight/2.0 - _bookFrame.size.height/2.0;
    _priceFrame.origin.y = _cellHeight/2.0 - _priceFrame.size.height/2.0;
}
@end

@implementation BeHotelRoomListDisplayModel

- (void)setListModel:(BeHotelDetailRoomListModel *)listModel
{
    _listModel = listModel;
    int breakFast = [listModel.Rp_Breakfast intValue];
    NSString *breakFastString = @"无早";
    switch (breakFast) {
        case 0:
            breakFastString = @"无早";
            break;
        case 1:
            breakFastString = @"单早";
            break;
        case 2:
            breakFastString = @"双早";
            break;
        case 3:
            breakFastString = @"三早";
            break;
        case 4:
            breakFastString = @"四早";
            break;
        case 100:
            breakFastString = @"含早";
            break;
        default:
            breakFastString = @"无早";
            break;
    }
    if([listModel.Rp_Description rangeOfString:breakFastString].location != NSNotFound)
    {
        _HotelName = listModel.Rp_Description;
    }
    else
    {
        _HotelName = [NSString stringWithFormat:@"%@ %@",listModel.Rp_Description,breakFastString];
    }    
    int payType = [listModel.Rp_Type intValue];
    if(payType == 501||payType == 502||payType == 806)
    {
        _payString = [NSString stringWithFormat:@"预付    "];
        _guaranteeString = @"";
    }
    else
    {//14、16、805
        _payString = [NSString stringWithFormat:@"到店现付    "];
        
        if([listModel.Rp_Guarantee isEqualToString:@"0"])
        {
            _guaranteeString = @"";
        }
        else
        {
            _guaranteeString = @"担保";
        }
    }
    
    if([listModel.Rp_ChancelStatus intValue] == 2)
    {
        _cancelString = @"限时取消";
    }
    else
    {
        _cancelString = @"不可取消";
    }
    
    if([listModel.Dr_SellStatus isEqualToString:@"0"])
    {
        _bookString = @"满房";
    }
    else
    {
        _bookString = @"预订";
    }
    _priceString = [NSString stringWithFormat:@"¥%@",listModel.Dr_Amount];
}

@end
