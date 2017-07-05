//
//  SBHPayHeaderView.h
//  sbh
//
//  Created by SBH on 14-12-27.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeOrderInfoModel.h"

@interface BeFlightOrderPaymentHeaderView : UIView
@property (nonatomic,strong)BeOrderInfoModel *model;
- (void)setCountDownLabelWithMinute:(NSString *)minute andSecond:(NSString *)second;
- (void)addTarget:(id)target andQuchengRuleAction:(SEL)action1 andFanchengRule:(SEL)action2;
@end
