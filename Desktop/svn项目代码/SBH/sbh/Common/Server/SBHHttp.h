//
//  SBHHttp.h
//  sbh
//
//  Created by SBH on 14-12-5.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef  void(^ResponseBlock)(id responseObj);
@interface SBHHttp : NSObject
+ (SBHHttp *)sharedInstance;
//get请求
- (void)getPath:(NSString *)urlStr withParameters:(NSDictionary *)parmrs success:(ResponseBlock)success failure:(void (^)(NSError *error))failure;

//post请求hud可选
- (void)postPath:(NSString *)urlStr withParameters:(NSDictionary *)parmrs showHud:(BOOL)isShow success:(ResponseBlock)success failure:(void (^)(NSError *error))failure;

@end
