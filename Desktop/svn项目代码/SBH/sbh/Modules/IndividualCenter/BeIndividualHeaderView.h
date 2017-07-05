//
//  BeIndividualHeaderView.h
//  SideBenefit
//
//  Created by RobinLiu on 15/3/5.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBHUserModel.h"
@protocol BeIndividualHeaderViewDelegate <NSObject>
- (void)detailButtonDidClick;
@end
@interface BeIndividualHeaderView : UIView
@property (nonatomic,weak)id<BeIndividualHeaderViewDelegate>delegate;

@property (nonatomic,retain)SBHUserModel *accountInfo;
@end
