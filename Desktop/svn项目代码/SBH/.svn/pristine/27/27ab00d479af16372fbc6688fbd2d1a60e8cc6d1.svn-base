//
//  MessageServer.m
//  sbh
//
//  Created by RobinLiu on 15/1/28.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "MessageServer.h"
#import "ServerConfigure.h"
#import "MessageListModel.h"
#import "NSDictionary+Additions.h"
#import "SBHHttp.h"
#import "MessageListModel.h"

@implementation MessageServer
- (void)doInquireMessageWithDict:(int )currentPage byCallBack:(void (^)(NSDictionary *))callback failureCallback:(void (^)(NSError *))failureCallback;
{
    NSMutableDictionary *objectDict = [[NSMutableDictionary alloc]init];
    [objectDict setValue:[NSString stringWithFormat:@"%d",currentPage] forKey:@"pageindex"];
    [objectDict setValue:@"20" forKey:@"pagesize"];
    [[SBHHttp sharedInstance]postPath:[NSString stringWithFormat:@"%@%@",kServerHost,GetMessageListUrl] withParameters:objectDict showHud:NO success:^(id successCallBackData)
     {
         NSMutableDictionary *successData = [[NSMutableDictionary alloc]initWithDictionary:successCallBackData];
         NSMutableArray *returnArray = [[NSMutableArray alloc]init];
         if([successData arrayValueForKey:@"msglist"]!=nil)
         {
             for(NSDictionary *member in [successData arrayValueForKey:@"msglist"]){
                 MessageListModel *model = [[MessageListModel alloc]initWithDict:member];
                 [returnArray addObject:model];
             }
         }
         [successData removeObjectForKey:@"msglist"];
         [successData setObject:returnArray forKey:@"msglist"];
         callback(successData);
     }failure:^(NSError *error)
     {
         failureCallback(error);
     }];
}
- (void)doDeleteMessageWithDict:(NSDictionary *)dict byCallBack:(void (^)(NSDictionary *))callback failureCallback:(void (^)(NSError *))failureCallback
{
    [[SBHHttp sharedInstance]postPath:[NSString stringWithFormat:@"%@%@",kServerHost,DeleteMessageUrl] withParameters:dict showHud:NO success:^(id successData)
     {
         callback(successData);
     }failure:^(NSError *error)
     {
         failureCallback(error);
     }];
}
- (void)doGetUnreadMessageCountByCallback:(void(^)(NSDictionary *))callback failureCallback:(void (^)(NSError *))failureCallback
{
    NSMutableDictionary *objectDict = [[NSMutableDictionary alloc]init];
    [[SBHHttp sharedInstance]postPath:[NSString stringWithFormat:@"%@Message/MessageCount",kServerHost] withParameters:objectDict showHud:NO success:^(id successData)
     {
         callback(successData);
     }failure:^(NSError *error)
     {
         failureCallback(error);
     }];
}
@end
