//
//  BeLoginServer.m
//  sbh
//
//  Created by RobinLiu on 15/5/11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeLoginServer.h"
#import "ServerConfigure.h"
#import "NSDictionary+Additions.h"
#import "BeLoginManager.h"
#import "SBHHttp.h"

@implementation BeLoginServer

- (void)doEnterpriseUserLoginWith:(id)loginObject byCallback:(void (^)(NSMutableDictionary *))callback failureCallback:(void (^)(NSString *))failureCallback
{
    NSLog(@"登录 = %@",loginObject);
    [[SBHHttp sharedInstance]postPath:[NSString stringWithFormat:@"%@%@",kServerHost,kVIPUserLoginUrl] withParameters:loginObject showHud:NO success:^(id successData)
     {
         callback(successData);
     }failure:^(NSError *error)
     {
         failureCallback([error.userInfo stringValueForKey:@"code"defaultValue:@""]);
     }];
}
- (void)doLogOffWith:(id)logOffObject byCallback:(void (^)(NSMutableDictionary *))callback failureCallback:(void(^)(NSString *))failureCallback
{
    [[SBHHttp sharedInstance]postPath:[NSString stringWithFormat:@"%@%@",kServerHost,kUserLogOffUrl] withParameters:logOffObject showHud:NO success:^(id successData)
     {
         callback(successData);
     }failure:^(NSError *error)
     {
         failureCallback([error.userInfo stringValueForKey:@"code"defaultValue:@""]);
     }];
}
@end
