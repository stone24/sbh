//
//  MessageListModel.m
//  sbh
//
//  Created by RobinLiu on 15/1/27.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "MessageListModel.h"
#import "NSDictionary+Additions.h"

@implementation MessageListModel
- (id)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        self.isSelectButton = NO;
        self.userID = [[NSString alloc]initWithString:[dict stringValueForKey:@"id"]];
        self.accountID = [[NSString alloc]initWithString:[dict stringValueForKey:@"AccountID"]];
        self.msgTitle = [[NSString alloc]initWithString:[dict stringValueForKey:@"Title"]];
        self.msgContent = [[NSString alloc]initWithString:[dict stringValueForKey:@"content"]];
        self.createTime = [[NSString alloc]initWithString:[dict stringValueForKey:@"CreateTime"] ];
        self.orderNO = [[NSString alloc]initWithString:[dict stringValueForKey:@"OrderNO"]];
        self.msgType = [dict intValueForKey:@"MsgType"];
        if([dict intValueForKey:@"IsShow"]==1)
        {
            self.isShowed = NO;
        }
        if([dict intValueForKey:@"IsShow"]==2)
        {
            self.isShowed = YES;
        } 
        self.showTime = [[NSString alloc]initWithString:[dict stringValueForKey:@"ShowTime"]];
        if([[[dict stringValueForKey:@"Orderst"] lowercaseString] hasPrefix:@"hotel"])
        {
            self.itemId =[[dict stringValueForKey:@"Orderst"]substringFromIndex:5];
            self.messageType = 2;
        }
        else if([[[dict stringValueForKey:@"Orderst"] lowercaseString] hasPrefix:@"djp"]){
            self.messageType = 3;
        }else if([[[dict stringValueForKey:@"Orderst"] lowercaseString] hasPrefix:@"jp"] || [[[dict stringValueForKey:@"Orderst"] lowercaseString] hasPrefix:@"btg"]){
            self.messageType = 1;
        }else if([[[dict stringValueForKey:@"Orderst"] lowercaseString] hasPrefix:@"hbdt"]){
            self.messageType = 4;
        } else if([[[dict stringValueForKey:@"Orderst"] lowercaseString] hasPrefix:@"hc"]){
            self.messageType = 5;
        } else if([[[dict stringValueForKey:@"Orderst"] lowercaseString] hasPrefix:@"zuche"]){
            self.messageType = 6;
        }
        else{
            self.messageType = 1;
        }
    }
    return self;
}
+ (MessageListModel *)objectWithDict:(NSDictionary *)dict
{
    MessageListModel *model = [[MessageListModel alloc]initWithDict:dict];
    return model;
}
@end
/*
 {
 code = 20027;
 currentpage = 1;
 msglist =     (
 {
 AccountID = 63967;
 CreateTime = "2015/1/28 17:42:00";
 IsShow = 1;
 MsgType = 1;
 OrderNO = HTND1501281742;
 ShowTime = "";
 Title = "\U8ba2\U5355\U5ba1\U6279\U4fe1\U606f";
 content = "\U674e\U6653\U96e8,2015-03-12\U65e5\U5317\U4eac\U81f3\U4e0a\U6d77\U5355\U7a0b\U8ba2\U5355\Uff0c\U8bf7\U5ba1\U6279";
 id = 6;
 },
 {
 AccountID = 63967;
 CreateTime = "2015/1/28 17:35:00";
 IsShow = 1;
 MsgType = 1;
 OrderNO = HTNM1501281459;
 ShowTime = "";
 Title = "\U8ba2\U5355\U5ba1\U6279\U4fe1\U606f";
 content = sfsdfsd;
 id = 5;
 }
 );
 pagecount = 1;
 pagesize = 10;
 status = true;
 totalcount = 2;
 }
 */