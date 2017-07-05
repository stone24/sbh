//
//  BeSpecialCarHttp.m
//  sbh
//
//  Created by SBH on 15/7/28.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeSpecialCarHttp.h"
#define KErrorCode @"msg"
@implementation BeSpecialCarHttp
//get请求
+ (void)getPath:(NSString *)urlStr success:(ResponseBlock)success failure:(void (^)(NSError *error))failure
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [request setHTTPMethod:@"Get"];
    NSData *data = [@"sbh:sbhzuche123" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *headerStr = [NSString stringWithFormat:@"Basic %@", [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn]];
    NSLog(@"headerStr = %@",headerStr);
    [request setValue:headerStr forHTTPHeaderField:@"Authorization"];
  //  [MBProgressHUD showMessage:@""];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
   //     [MBProgressHUD hideHUD];
        if (connectionError == nil)
        {
            id callback = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if([callback isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dict = (NSDictionary *)callback;
                if ([[dict objectForKey:@"code"] intValue] == 200)
                {
                    success(dict);
                }
                else
                {
                    NSError *error = [[NSError alloc] initWithDomain:KErrorCode code:1 userInfo:dict];
                    failure(error);
                }
            }
            else
            {
                success(callback);
            }
        } else {
            failure(connectionError);
        }
    }];
}
//post请求
+ (void)postPath:(NSString *)urlStr withParameters:(NSString *)bodyStr success:(ResponseBlock)success failure:(void (^)(NSError *error))failure
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    NSData *data = [@"sbh:sbhzuche123" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *headerStr = [NSString stringWithFormat:@"Basic %@", [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn]];
    [request setValue:headerStr forHTTPHeaderField:@"Authorization"];
    NSData *postData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [request setHTTPBody:postData];
    //  [MBProgressHUD showMessage:@""];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //  [MBProgressHUD hideHUD];
        if (connectionError == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if([dict objectForKey:@"result"] !=nil)
            {
                success(dict);
            }
            else if ([[dict objectForKey:@"code"] intValue] == 200) {
                success(dict);
            } else {
                NSError *error = [[NSError alloc] initWithDomain:KErrorCode code:1 userInfo:dict];
                failure(error);
            }
            
        } else {
            failure(connectionError);
        }
    }];
}
@end
