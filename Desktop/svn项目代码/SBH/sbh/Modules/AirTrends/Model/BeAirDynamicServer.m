//
//  BeAirDynamicServer.m
//  SideBenefit
//
//  Created by RobinLiu on 15/3/18.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeAirDynamicServer.h"
#import "BeDynamicModel.h"
#import "ServerConfigure.h"
#import "SBHHttp.h"

@implementation BeAirDynamicServer

- (void)getRequestCareFlightWithSuccessCallback:(BeAirBlock)successblock andFailureCallback:(BeAirBlock)failblock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"AirFlight/FlightDynamicList"];
    [[SBHHttp sharedInstance]postPath:urlStr withParameters:@{} showHud:NO success:^(NSDictionary *responseObject)
     {
         NSMutableArray *careListArray = [[NSMutableArray alloc]init];
         NSMutableArray *tempArray = [[NSMutableArray alloc]init];
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"true"]) {
             NSMutableArray *array = nil;
             array = [responseObject objectForKey:@"dt"];
             for (NSDictionary *dict in array) {
                 BeDynamicModel *dyModel = [BeDynamicModel mj_objectWithKeyValues:dict];
                 dyModel.careBtnSelect = YES;
                 [tempArray addObject:dyModel];
             }
             NSArray *gzArray = [responseObject objectForKey:@"gz"];
             if (gzArray.count != tempArray.count) {
                 for (NSDictionary *dict in gzArray) {
                     NSString *dynTimeStr = [dict objectForKey:@"flightdate"];
                     NSArray *strArray = [dynTimeStr componentsSeparatedByString:@" "];
                     NSString *dateStr = @"";
                     if (strArray.count >= 1) {
                         dateStr = strArray.firstObject;
                     }
                     
                     dateStr = [dateStr stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
                     NSDate *dynDate = [CommonMethod dateFromString:dateStr WithParseStr:kFormatYYYYMMDD];
                     for (BeDynamicModel *dyModel in tempArray) {
                         BOOL sameDate = [dynDate isEqualToDate:[CommonMethod dateFromString:dyModel.FlightDeptimePlanDate WithParseStr:kFormatYYYYMMDD]];
                         if ([dyModel.FlightArrcode isEqualToString:[dict objectForKey:@"arrcode"]]&&[dyModel.FlightDepcode isEqualToString:[dict objectForKey:@"depcode"]]&&
                             [dyModel.FlightNo isEqualToString:[dict objectForKey:@"flightno"]]&& sameDate) {
                             [careListArray addObject:dyModel];
                             break;
                         }
                     }
                 }
                 successblock(careListArray);
             } else {
                 successblock(tempArray);
             }
             
         } else {
             failblock (@"请求失败");
         }

     } failure:^(NSError * error)
    {
         failblock (@"请求失败");
    }];
}
- (void)cancelCareFlightWith:(id)object andSuccessCallback:(BeAirBlock)successblock andFailureCallback:(BeAirBlock)failblock
{
    BeDynamicModel *dyModel = (BeDynamicModel *)object;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"AirFlight/CancelFlightDynamic"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"flightdate"] = dyModel.FlightDeptimePlanDate;
    params[@"flightno"] = dyModel.FlightNo;
    params[@"arrcode"] = dyModel.FlightArrcode;
    params[@"depcode"] = dyModel.FlightDepcode;
    [[SBHHttp sharedInstance]postPath:urlStr withParameters:params showHud:NO success:^(NSDictionary *responseObject)
     {
          if ([[responseObject objectForKey:@"status"] isEqualToString:@"true"]) {
              successblock(@"Yes");
          }
          else
          {
              failblock(@"失败");
          }
      }
      failure:^(NSError * error) {
          failblock(@"失败");
      }];
}
@end
