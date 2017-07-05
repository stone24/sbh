//
//  BeTicketRuleReasonView.h
//  sbh
//
//  Created by RobinLiu on 16/3/15.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BeTicketRuleReasonViewBlock) (NSString *selectedReason);

@interface BeTicketRuleReasonView : UIView

+ (BeTicketRuleReasonView *)sharedInstance;
- (void)showViewWith:(NSArray *)reasonArray andBlock:(BeTicketRuleReasonViewBlock)block;
@end
