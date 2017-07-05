//
//  BeHomeView.h
//  sbh
//
//  Created by RobinLiu on 2017/7/4.
//  Copyright © 2017年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BeHomeFooterViewDelegate<NSObject>
- (void)homeFooterViewClick:(int)tag;
@end
@interface BeHomeFooterView : UIView
@property (nonatomic,assign)id<BeHomeFooterViewDelegate>delegate;
+ (CGRect )footerViewFrameWithHeaderHeight:(CGFloat)headerHeight;
@end
