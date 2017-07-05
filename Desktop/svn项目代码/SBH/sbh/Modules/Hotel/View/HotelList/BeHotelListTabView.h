//
//  BeHotelListTabView.h
//  SideBenefit
//
//  Created by RobinLiu on 15/3/11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeHotelListTabView : UIView
- (void)addTarget:(id)target andAreaAction:(SEL)areaAction andPriceAction:(SEL)priceAction andSortAction:(SEL)sortAction andFilterAction:(SEL)filterAction;
- (void)updateSortUIWith:(NSString *)item;
- (void)updateFilterUIWith:(NSString *)item;
- (void)updatePriceUIWith:(NSString *)item;
- (void)updateAreaUIWith:(NSString *)item;
@end
