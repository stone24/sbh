//
//  BeActionSheetCustom.h
//  sbh
//
//  Created by SBH on 15/7/21.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeActionSheetCustom : UIView

@property (nonatomic, copy) void(^actionSheetCustomClickBlock)(int);
- (id)initWithTitle:(NSArray *)titleArray;
- (void)show;
@property (nonatomic, assign) int indexInt;
@end
