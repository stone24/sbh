//
//  BeHotelOrderFooterView.m
//  sbh
//
//  Created by RobinLiu on 15/12/14.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelOrderFooterView.h"
#import "ColorUtility.h"
#import "ColorConfigure.h"
#import "CommonDefine.h"
#import "BePriceListModel.h"

@implementation BeHotelOrderFooterView

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
        self.backgroundColor = [ColorUtility colorWithRed:251 green:136 blue:18];
        
        self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 0, kScreenWidth - 93 - 40 - 14, 20)];
        self.priceLabel.textColor = [UIColor whiteColor];
        self.priceLabel.centerY = kHotelOrderFooterViewHeight/2.0;
        [self addSubview:self.priceLabel];
        
        self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.payButton.frame = CGRectMake(kScreenWidth - 93, 0, 93, kHotelOrderFooterViewHeight);
        [self.payButton setBackgroundColor:[ColorUtility colorWithRed:253 green:104 blue:17]];
        [self.payButton setTitle:@"预订" forState:UIControlStateNormal];
        [self addSubview:self.payButton];
        
        self.detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.detailButton.frame = CGRectMake(kScreenWidth - 93 - 60, 0, 60, kHotelOrderFooterViewHeight);
        [self.detailButton setBackgroundColor:[UIColor clearColor]];
        self.detailButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.detailButton setTitle:@"明细>" forState:UIControlStateNormal];
        [self addSubview:self.detailButton];
    }
    return self;
}
- (void)addTarget:(id)target andPayAction:(SEL)payAciton andDetailAction:(SEL)detailAction
{
    [self.detailButton addTarget:target action:detailAction forControlEvents:UIControlEventTouchUpInside];
    [self.payButton addTarget:target action:payAciton forControlEvents:UIControlEventTouchUpInside];
}
- (void)updatePriceUIWith:(BeHotelOrderWriteModel *)model
{
    double totalPrice = 0;
    double discount = 0;
    double totalPrice2 = 0;
    for(BePriceListModel *prModel in model.priceArray)
    {
        totalPrice = totalPrice + (int)model.Persons.count * [prModel.SalePrice doubleValue];
        discount = discount + (int)model.Persons.count * [prModel.Dr_MinPrice doubleValue];
    }
    totalPrice2 = totalPrice - discount;
    
    self.priceLabel.attributedText = nil;
    NSString *str1 = @"合计：￥";
    NSString *priceString = [NSString stringWithFormat:@"%.2lf",totalPrice2];
    NSString *allString = [NSString stringWithFormat:@"%@%@",str1,priceString];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allString];
    [str setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(0,[str1 length])];
    [str setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange([str1 length],[priceString length])];
    self.priceLabel.attributedText = str;
}
@end
