//
//  SBHHttp.m
//  sbh
//
//  Created by SBH on 14-12-5.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "SBHHttp.h"
#import "CommonDefine.h"
#import "NSDictionary+Additions.h"
#import <zlib.h>

@implementation SBHHttp
+ (SBHHttp *)sharedInstance
{
    static dispatch_once_t onceToken;
    static SBHHttp *_instance;
    dispatch_once(&onceToken, ^{
        _instance = [[SBHHttp alloc]init];
    });
    return _instance;
}

- (void)getPath:(NSString *)urlStr withParameters:(NSDictionary *)parmrs success:(ResponseBlock)success failure:(void (^)(NSError *error))failure;
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithDictionary:parmrs];
    if([paraDict objectForKey:@"format"]==nil)
    {
        paraDict[@"format"] = @"json";
    }
    if([paraDict objectForKey:@"platform"]==nil)
    {
        paraDict[@"platform"] = @"ios";
    }
    [manager GET:urlStr parameters:paraDict progress:^(NSProgress * _Nonnull uploadProgress)
     {
         
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if([[responseObject stringValueForKey:@"status"] isEqualToString:@"true"])
         {
             success (responseObject);
         }
         else
         {
             NSError *err = [self formatError:responseObject atPath:urlStr];
             failure(err);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         [MBProgressHUD hideHUD];
         failure(error);
     }];
}
- (void)postPath:(NSString *)urlStr withParameters:(NSDictionary *)parmrs showHud:(BOOL)isShow success:(ResponseBlock)success failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/x-gzip",@"text/html",@"charset=utf-8",nil];
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithDictionary:parmrs];
    if([paraDict objectForKey:@"format"]==nil)
    {
        paraDict[@"format"] = @"json";
    }
    if([paraDict objectForKey:@"platform"]==nil)
    {
        paraDict[@"platform"] = @"ios";
    }
    if([GlobalData getSharedInstance].userModel.isLogin && [paraDict objectForKey:@"usertoken"]==nil)
    {
        paraDict[@"usertoken"] = [GlobalData getSharedInstance].token;
    }
    if(isShow)
    {
        [MBProgressHUD showMessage:@""];
    }
    [mgr POST:urlStr parameters:paraDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseData)
     {
         if(isShow)
         {
             [MBProgressHUD hideHUD];
         }
         NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
         if(![responseObject isKindOfClass:[NSDictionary class]])
         {
             NSData *data = [self unCompressZippedData:responseData];
             responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
         }
         if([responseObject objectForKey:@"status"]!=nil || [responseObject objectForKey:@"state"]!=nil)
         {
             if([[responseObject stringValueForKey:@"status" defaultValue:@""] isEqualToString:@"true"]||[[responseObject stringValueForKey:@"state"] isEqualToString:@"true"]||[[responseObject stringValueForKey:@"status" defaultValue:@""] isEqualToString:@"ture"])
             {
                 success(responseObject);
             }
             else
             {
                 NSError *err = [self formatError:responseObject atPath:urlStr];
                 failure(err);
             }
         }
         else
         {
             success(responseObject);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if(isShow)
         {
             [MBProgressHUD hideHUD];
         }
         failure(error);
     }];
}
#pragma mark - 解压数据
- (NSData *)unCompressZippedData:(NSData *)compressedData
{
    if ([compressedData length] == 0) return compressedData;
    unsigned full_length = (unsigned)[compressedData length];
    unsigned half_length = (unsigned)[compressedData length] / 2;
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    z_stream strm;
    strm.next_in = (Bytef *)[compressedData bytes];
    strm.avail_in = (int)[compressedData length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy: half_length];
        }
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = (int)([decompressed length] - strm.total_out);
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        } else if (status != Z_OK) {
            break;
        }
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    // Set real length.
    if (done) {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    } else {
        return nil;
    }
}
- (NSError*)formatError:(NSDictionary*)responseObject atPath:(NSString*)path
{
    return [NSError errorWithDomain:path
                               code:[responseObject intValueForKey:@"code"]
                           userInfo:responseObject];
}
@end
