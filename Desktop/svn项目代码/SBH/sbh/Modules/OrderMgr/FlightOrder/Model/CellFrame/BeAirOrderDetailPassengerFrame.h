//
//  BeAirOrderDetailPassengerFrame.h
//  sbh
//
//  Created by SBH on 15/4/30.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BePassengerModel.h"

@interface BeAirOrderDetailPassengerFrame : NSObject
/** 乘机人 */
@property (nonatomic, assign) CGRect nameFrame;
/** 证件 */
@property (nonatomic, assign) CGRect cardFrame;
/** 手机号 */
@property (nonatomic, assign) CGRect phoneFrame;
/** 票号 */
@property (nonatomic, assign) CGRect ticketNoFrame;

/** 自己的高度 */
@property (nonatomic, assign) CGFloat height;

/** 乘机人信息 */
@property (nonatomic, strong) BePassengerModel *pasM;
@end
