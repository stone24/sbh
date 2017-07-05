//
//  BeAlertView.h
//  sbh
//
//  Created by SBH on 15/4/23.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BeAlertViewDelegate
- (void)beAlertViewClickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface BeAlertView : UIView
-(id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;//otherButton最多有两个
-(void)show;
@end
