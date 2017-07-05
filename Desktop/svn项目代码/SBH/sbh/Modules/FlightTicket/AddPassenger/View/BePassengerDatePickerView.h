//
//  BePassengerDatePickerView.h
//  sbh
//
//  Created by RobinLiu on 15/11/18.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DatePickerBlock)(id selectData);
@interface BePassengerDatePickerView : UIView
+ (BePassengerDatePickerView *)sharedInstance;
- (void)showPickerViewWithSelectDate:(NSString *)dateString andBlock:(DatePickerBlock)block;
@end
