//
//  BeHotelOrderServer.m
//  SideBenefit
//
//  Created by RobinLiu on 15/3/19.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelOrderServer.h"
#import "ServerConfigure.h"
#import "BeHotelOrderModel.h"
#import "SBHHttp.h"

@implementation BeHotelOrderServer
- (void)doGetHotelOrderDetailWith:(id)object andSuccessCallback:(void (^)(NSDictionary *))callback andFailureCallback:(void (^)(NSString *))failure
{
    BeHotelOrderModel *hotelModel = (BeHotelOrderModel *)object;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderno"] = hotelModel.OrderNo;
    params[@"hotelid"] = hotelModel.HotelId;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,kHotelOrderDetailUrl];
    [[SBHHttp sharedInstance]postPath:urlStr withParameters:params showHud:NO success:^(NSDictionary *responseObject)
     {
         callback(responseObject);
     } failure:^(NSError * error) {
         failure(@"失败");
     }];
}
- (void)doCancelOrderWith:(id)object andReason:(NSString *)reason andSuccess:(void (^)(NSString *))callback andFailure:(void (^)(NSString *))failure
{
    BeHotelOrderModel *hotelModel = (BeHotelOrderModel *)object;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,kCancelHotelOrderUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cancelcomments"] = reason;
    params[@"orderno"] = hotelModel.OrderNo;
    params[@"hotelid"] = hotelModel.HotelId;
    [[SBHHttp sharedInstance]postPath:urlStr withParameters:params showHud:NO success:^(NSDictionary *responseObject)
     {
         callback(@"success");
     } failure:^(NSError * error) {
         failure(@"失败");
     }];
}
@end
