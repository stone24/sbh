//
//  MessageServer.h
//  sbh
//
//  Created by RobinLiu on 15/1/28.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageServer : NSObject
/**
 * 消息页面查询消息的接口
 */
- (void)doInquireMessageWithDict:(int )currentPage byCallBack:(void (^)(NSDictionary *))callback failureCallback:(void (^)(NSError *))failureCallback;
/**
 * 消息删除，批量删除及批量变更
 */
- (void)doDeleteMessageWithDict:(NSDictionary *)dict byCallBack:(void (^)(NSDictionary *))callback failureCallback:(void (^)(NSError *))failureCallback;
/**
 * 未查看的消息数量
 */
- (void)doGetUnreadMessageCountByCallback:(void(^)(NSDictionary *))callback failureCallback:(void (^)(NSError *))failureCallback;
@end
