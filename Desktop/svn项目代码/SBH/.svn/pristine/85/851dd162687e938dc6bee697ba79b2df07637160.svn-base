//
//  BeHotelPriceSelectView.h
//  sbh
//
//  Created by RobinLiu on 15/11/9.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHotelPriceSelectViewHeight 233.0f
typedef void(^HotelPriceSelectBlock)(NSMutableArray *selectPriceA,NSMutableArray *selectStarA);

@interface BeHotelPriceSelectView : UIView
+ (BeHotelPriceSelectView *)sharedInstance;
- (void)showViewWithPriceArray:(NSArray *)priceA andStarArray:(NSArray *)starA andBlock:(HotelPriceSelectBlock)block;
@end
