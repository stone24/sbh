//
//  BeHotelSortPickView.h
//  SideBenefit
//
//  Created by RobinLiu on 15/3/11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kHotelSortSelectViewHeight 200.0f

typedef void(^HotelSortSelectBlock)(NSString *selectCondition);

@interface BeHotelSortPickView : UIView
+ (BeHotelSortPickView *)sharedInstance;
- (void)showViewWithCondition:(NSString *)condition andBlock:(HotelSortSelectBlock)block;
@end