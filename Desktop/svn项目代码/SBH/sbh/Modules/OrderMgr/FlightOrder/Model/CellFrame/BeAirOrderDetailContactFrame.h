//
//  BeAirOrderDetailContact.h
//  sbh
//
//  Created by SBH on 15/4/30.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeOrderContactModel.h"

@interface BeAirOrderDetailContactFrame : NSObject
/** 乘机人 */
@property (nonatomic, assign) CGRect nameFrame;
/** 手机号 */
@property (nonatomic, assign) CGRect phoneFrame;
/** 自己的高度 */
@property (nonatomic, assign) CGFloat height;
/** 乘机人信息 */
@property (nonatomic, strong) BeOrderContactModel *conM;
@end
