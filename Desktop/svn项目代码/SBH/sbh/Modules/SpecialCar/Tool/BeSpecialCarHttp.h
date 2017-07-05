//
//  BeSpecialCarHttp.h
//  sbh
//
//  Created by SBH on 15/7/28.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef  void(^ResponseBlock)(id responseObj);
@interface BeSpecialCarHttp : NSObject
//get请求
+ (void)getPath:(NSString *)urlStr success:(ResponseBlock)success failure:(void (^)(NSError *error))failure;
//post请求
+ (void)postPath:(NSString *)urlStr withParameters:(NSString *)bodyStr success:(ResponseBlock)success failure:(void (^)(NSError *error))failure;
@end
