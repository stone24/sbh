//
//  BeHotelOrderFooterView.h
//  sbh
//
//  Created by RobinLiu on 15/12/14.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeHotelOrderWriteModel.h"

#define kHotelOrderFooterViewHeight 49.0f

@interface BeHotelOrderFooterView : UIView
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UIButton *detailButton;
@property (nonatomic,strong)UIButton *payButton;
- (void)updatePriceUIWith:(BeHotelOrderWriteModel *)model;
- (void)addTarget:(id)target andPayAction:(SEL)payAciton andDetailAction:(SEL)detailAction;
@end
