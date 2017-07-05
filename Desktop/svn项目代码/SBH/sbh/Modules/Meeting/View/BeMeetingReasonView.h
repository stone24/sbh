//
//  BeMeetingReasonView.h
//  sbh
//
//  Created by RobinLiu on 16/6/20.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MeetingReasonBlock)(NSString *selectString);
@interface BeMeetingReasonView : UIView
+ (BeMeetingReasonView *)sharedInstance;
- (void)showViewWithData:(NSArray *)data andSelectString:(NSString *)reasons andIsSingle:(BOOL)isSingle andBlock:(MeetingReasonBlock)block;
@end
