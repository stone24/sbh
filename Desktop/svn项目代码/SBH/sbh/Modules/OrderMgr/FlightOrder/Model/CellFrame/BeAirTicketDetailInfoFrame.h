//
//  BeAirTicketDetailInfoFrame.h
//  sbh
//
//  Created by SBH on 15/4/29.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeOrderInfoModel.h"

@interface BeAirTicketDetailInfoFrame : NSObject
/** 订单号内容 */
@property (nonatomic, assign) CGRect orderNoContentFrame;
/** 订单金额内容 */
@property (nonatomic, assign) CGRect orderSumContentFrame;
/** 金额明细 */
@property (nonatomic, assign) CGRect sumDetailContentFrame;
/** 订单状态 */
@property (nonatomic, assign) CGRect orderStatusContentFrame;
/** 创建时间  */
@property (nonatomic, assign) CGRect creatDateContentFrame;
/** 预订人  */
@property (nonatomic, assign) CGRect bookerContentFrame;

/** 自己的高度 */
@property (nonatomic, assign) CGFloat height;

/** 订单详情总数据 */
@property (nonatomic, strong) BeOrderInfoModel *infoModel;

// 是否展示明细
@property (nonatomic, assign) BOOL showSumDetail;

@property (nonatomic, assign) BOOL isTrainType;
@end
