//
//  BePassengerTool.m
//  sbh
//
//  Created by RobinLiu on 15/11/18.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BePassengerTool.h"
#import "SBHHttp.h"
#import "NSDictionary+Additions.h"
#import "selectPerson.h"
#import "JSONKit.h"
#import "ServerFactory.h"

@implementation BePassengerTool

- (void)getRecentHotelListWith:(NSString *)name andDepartId:(NSString *)departmentid bySuccess:(void (^)(NSMutableArray *))callback failure:(void (^)(NSError *))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"Hotel/HotelOrder/ContactPerson"];
    NSDictionary *parameters = @{@"usertoken":[GlobalData getSharedInstance].token,@"name":name,@"depid":departmentid,@"format":@"json",@"platform":@"ios"};
    [[SBHHttp sharedInstance]postPath:urlStr withParameters:parameters showHud:NO success:^(NSDictionary *successData)
     {
         NSMutableArray *callbackArray = [[NSMutableArray alloc]init];
         for(NSDictionary *member in [successData arrayValueForKey:@"flightcontact"])
         {
             selectPerson * aSelPerson = [[selectPerson alloc] initWithDict:member andFromType:@"2"];
             [callbackArray addObject:aSelPerson];
         }
         callback (callbackArray);

     }failure:^(NSError *error)
     {
         failure (error);
     }];
}
- (void)getCarRecentListWith:(NSString *)name bySuccess:(void (^)(NSMutableArray *))callback failure:(void (^)(NSError *))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"ZuChe/CarPassenger"];
    NSDictionary *parameters = @{@"usertoken":[GlobalData getSharedInstance].token,@"username":name,@"pageindex":@"1",@"pagecount":@"0",@"zcount":@"0",@"pagesize":@"20"};
    [[SBHHttp sharedInstance]postPath:urlStr withParameters:parameters showHud:YES success:^(NSDictionary *successData)
     {
         NSMutableArray *callbackArray = [NSMutableArray array];
         for(NSDictionary *member in [successData arrayValueForKey:@"cp"])
         {
             selectPerson * aSelPerson = [[selectPerson alloc] init];
             id idObject = [member objectForKey:@"id"];
             if([idObject isKindOfClass:[NSString class]])
             {
                 aSelPerson.iId = idObject;
             }
             else if([idObject isKindOfClass:[NSNumber class]])
             {
                 NSString * idStri = [NSString stringWithFormat:@"%d",[(NSNumber*)idObject intValue]];
                 aSelPerson.iId  = idStri;
             }
             aSelPerson.iType = @"ADT";
             aSelPerson.iGender = @"男";
             aSelPerson.PassengerEntId =[member stringValueForKey:@"PassengerEntId"];
             aSelPerson.PassengerAccountId =[member stringValueForKey:@"PassengerAccountId"];
             aSelPerson.depid = [member stringValueForKey:@"PassengerDepId"];
             aSelPerson.iName = [member stringValueForKey:@"name"];
             aSelPerson.iMobile = [member stringValueForKey:@"mobilephone"];
             aSelPerson.rolename = [member stringValueForKey:@"Depname"];
             [callbackArray addObject:aSelPerson];
         }
       /*  NSString *currentPage = [successData stringValueForKey:@"currentpage"];
         NSString *pageCount = [successData stringValueForKey:@"pagecount"];
         NSString *totalCount = [successData stringValueForKey:@"totalcount"];
         callback (callbackArray);*/
     }failure:^(NSError *error)
     {
         failure (error);
     }];
}
- (void)getEmployeeListWith:(NSDictionary *)parameters bySuccess:(void (^)(NSString *currentPage,NSString *pageCount,NSString *totalCount,NSArray *listArray))callback failure:(void (^)(NSError *))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"Enterprise/GetEmployee"];
    [[SBHHttp sharedInstance]postPath:urlStr withParameters:parameters showHud:YES success:^(NSDictionary *successData)
     {
         if(successData != nil)
         {
             NSMutableArray *callbackArray = [NSMutableArray array];
             for(NSDictionary *member in [successData arrayValueForKey:@"list"])
             {
                 selectPerson * aSelPerson = [[selectPerson alloc] initWithDict:member andFromType:@"1"];
                 [callbackArray addObject:aSelPerson];
             }
             NSString *currentPage = [successData stringValueForKey:@"currentpage"];
             NSString *pageCount = [successData stringValueForKey:@"pagecount"];
             NSString *totalCount = [successData stringValueForKey:@"totalcount"];
             callback (currentPage,pageCount,totalCount,callbackArray);
         }
        else
        {
            callback(@"1",@"1",@"1",@[]);
        }
     }failure:^(NSError *error)
     {
         failure (error);
     }];
}
@end
