//
//  BeMorePriceTool.h
//  sbh
//
//  Created by RobinLiu on 16/3/15.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeTicketDetailModel.h"

@interface BeMorePriceTool : NSObject
/**
 * 获取更多价格页面获取价格列表
 */
- (void)getMorePriceDataWith:(NSString *)flightNo and:(NSString *)listId bySuccess:(void (^)(NSDictionary *))callback failure:(void (^)(NSString *))failure;
/**
 * 保存选中的机票模型
 */
- (void)addSelectdTicketWith:(BeTicketDetailModel *)model;
@end
