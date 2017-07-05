//
//  BeMorePriceTool.m
//  sbh
//
//  Created by RobinLiu on 16/3/15.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeMorePriceTool.h"
#import "SBHHttp.h"
#import "JSONKit.h"
#import "ServerFactory.h"

@implementation BeMorePriceTool
- (void)getMorePriceDataWith:(NSString *)flightNo and:(NSString *)listId bySuccess:(void (^)(NSDictionary *))callback failure:(void (^)(NSString *))failure
{
    NSString *requestUrl = @"";
    if ([GlobalData getSharedInstance].userModel.isLogin == NO) {
        //未登录
        requestUrl = kAirFlightSearchMoreSaas4Url;
    }
    else
    {
        //企业登录
        requestUrl = kAirFlightSearchMoreUrl;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,requestUrl];
    [[ServerFactory getServerInstance:@"SBHHttp"]postPath:urlStr withParameters:@{@"listguid":listId,@"flightno":flightNo} showHud:NO success:^(NSDictionary *dic)
     {
         callback(dic);
     }failure:^(NSError *error)
     {
         
     }];
}
- (void)addSelectdTicketWith:(BeTicketDetailModel *)detailModel
{
}
@end
