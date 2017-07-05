//
//  BeOrderWriteAuditInfoModel.h
//  sbh
//
//  Created by SBH on 15/5/13.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeOrderWriteAuditInfoModel : NSObject
// 审批人姓名
@property (nonatomic, copy) NSString *Name;
// 审批人手机号
@property (nonatomic, copy) NSString *Mobile;
// 审批人邮箱
@property (nonatomic, copy) NSString *Email;

@property (nonatomic, copy) NSString *FlowType;

@property (nonatomic, copy) NSString *PerType;

@property (nonatomic, copy) NSString *Tel;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, strong)NSMutableDictionary *responseDict;
/**
 * 显示的等级
 */
@property (nonatomic, copy) NSString *displayLevel;
- (id)initWithDict:(NSDictionary *)dict;
@end
