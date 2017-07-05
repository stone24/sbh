//
//  BeHotelOrderPriceListView.h
//  sbh
//
//  Created by RobinLiu on 15/12/15.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeHotelOrderWriteModel.h"
typedef NS_ENUM(NSInteger,BeHotelOrderPriceListViewType) {
    BeHotelOrderPriceListViewTypeWrite = 0,
    BeHotelOrderPriceListViewTypePay = 1,
};
@interface BeHotelOrderPriceListView : UIView
+ (BeHotelOrderPriceListView *)sharedInstance;
- (void)showViewWithData:(BeHotelOrderWriteModel *)object andType:(BeHotelOrderPriceListViewType)type;
@end
