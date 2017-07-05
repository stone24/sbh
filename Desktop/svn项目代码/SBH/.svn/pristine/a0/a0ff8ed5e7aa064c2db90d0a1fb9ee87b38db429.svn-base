//
//  BaseViewController.h
//  hanyu
//
//  Created by musmile on 13-12-3.
//  Copyright (c) 2013年 hanyuhangkong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonMethod.h"
#import "JSONKit.h"

@interface BaseViewController : UIViewController<UIAlertViewDelegate,UIActionSheetDelegate>

/** 一些通用的方法*/
-(void)savePreference:(NSString*)key withValue:(NSString*)value;

/**
 函数功能 获取保存的key值
 输入参数 (NSString*)key保存的key值
 */
-(NSString*)getPreference:(NSString*)key;


/**
 函数功能:获取堆栈中的viewcontroller
 */
-(UIViewController*)getNavigationHistoryVC:(Class) aVcClass;

-(void)handleResuetCode:(NSString*)aCode;

- (void)leftMenuClick;
- (void)backToRootViewController;

// 请求不成功情况统一处理
- (void)requestFlase:(NSError *)error;
@end
