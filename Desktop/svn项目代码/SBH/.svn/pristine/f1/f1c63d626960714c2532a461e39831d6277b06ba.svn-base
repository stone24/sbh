//
//  BeWriteItemHeaderView.m
//  SideBenefit
//
//  Created by SBH on 15-3-12.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelOrderDescriptionView.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "CommonDefine.h"

@implementation BeHotelOrderDescriptionView
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(8, 8, kScreenWidth - 16, frame.size.height -16)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        bgView.layer.borderWidth = 0.5;
        bgView.layer.cornerRadius = 2.0f;
        [self addSubview:bgView];
        
        self.HotelDescriptionTV = [[UITextView alloc]initWithFrame:CGRectMake(2, 2, bgView.width - 4, bgView.height - 4)];
        self.HotelDescriptionTV.font = [UIFont systemFontOfSize:12];
        self.HotelDescriptionTV.textColor = [ColorUtility colorFromHex:0x1d1d1d];
        [bgView addSubview:self.HotelDescriptionTV];
    }
    return self;
}
@end