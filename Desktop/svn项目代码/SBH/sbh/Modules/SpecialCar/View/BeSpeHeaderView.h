//
//  BeSpeHeaderView.h
//  sbh
//
//  Created by RobinLiu on 2016/12/12.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BeSpeHeaderViewDelegate <NSObject>
- (void)speHeaderViewDidClickWith:(NSInteger)index;
@end
#define BeSpeHeaderViewHeight 40.0f
@interface BeSpeHeaderView : UIView
@property (nonatomic,assign)id<BeSpeHeaderViewDelegate>delegate;
@end
