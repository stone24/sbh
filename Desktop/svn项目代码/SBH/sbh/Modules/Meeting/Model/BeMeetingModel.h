//
//  BeMeetingModel.h
//  sbh
//
//  Created by RobinLiu on 16/6/20.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeMeetingModel : NSObject

/**
 * 城市
 */
@property (nonatomic,strong)NSString *cityName;
/**
 * 开始时间
 */
@property (nonatomic,strong)NSDate *startDate;
/**
 * 结束时间
 */
@property (nonatomic,strong)NSDate *leaveDate;
/**
 * 预算
 */
@property (nonatomic,strong)NSString *budget;
/**
 * 人数
 */
@property (nonatomic,strong)NSString *number;
/**
 * 会议需求
 */
@property (nonatomic,strong)NSString *demand;
/**
 * 联系人
 */
@property (nonatomic,strong)NSString *contactPerson;
/**
 * 联系电话
 */
@property (nonatomic,strong)NSString *contactPhone;

@end
