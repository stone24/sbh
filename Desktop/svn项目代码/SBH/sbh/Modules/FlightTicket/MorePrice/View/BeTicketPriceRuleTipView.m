//
//  BeTicketPriceRuleTipView.m
//  sbh
//
//  Created by RobinLiu on 16/3/10.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeTicketPriceRuleTipView.h"
#import "ColorUtility.h"

@implementation BeTicketPriceRuleTipView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [ColorUtility colorFromHex:0xffda93];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20,  frame.size.height)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = @"根据公司的差旅政策，您选择的时间点2小时前后，身边惠商旅版为您推荐价格更优惠的航班。";
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = [UIColor brownColor];
        [self addSubview:titleLabel];
    }
    return self;
}
@end
