//
//  BeHotelOrderWriteCheckInView.h
//  sbh
//
//  Created by RobinLiu on 15/12/15.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CheckInBlock)(NSString *selectString);
@interface BeHotelOrderWriteCheckInView : UIView
+(BeHotelOrderWriteCheckInView *)sharedInstance;
- (void)showViewWithData:(NSString *)object andBlock:(CheckInBlock)block;
@end
