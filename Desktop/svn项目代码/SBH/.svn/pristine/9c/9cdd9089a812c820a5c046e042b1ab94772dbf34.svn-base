//
//  MessageListModel.h
//  sbh
//
//  Created by RobinLiu on 15/1/27.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, MessageType)
{
    kMessageTypeTicketOrder = 1,
    kMessageTypeHotelOrder = 2,
    kMessageTypeAudit = 3,
    kMessageTypeAirDynamic = 4,
    kMessageTypeDelay = 999,
};
@interface MessageListModel : NSObject
// 消息的类型
@property (nonatomic,retain)NSString *orderst;
@property (nonatomic,retain)NSString *userID;
@property (nonatomic,retain)NSString *accountID;
@property (nonatomic,retain)NSString *msgTitle;
@property (nonatomic,retain)NSString *msgContent;
@property (nonatomic,retain)NSString *createTime;
@property (nonatomic,retain)NSString *orderNO;
@property (nonatomic,assign)NSInteger msgType;
@property (nonatomic,assign)BOOL isShowed;
@property (nonatomic,retain)NSString *showTime;
@property (nonatomic,assign)BOOL isSelectButton;
@property (nonatomic,assign)NSInteger messageType;//1为机票订单，2为酒店订单
@property (nonatomic,retain)NSString *itemId;
- (id)initWithDict:(NSDictionary *)dict;
+ (MessageListModel *)objectWithDict:(NSDictionary *)dict;
@end
