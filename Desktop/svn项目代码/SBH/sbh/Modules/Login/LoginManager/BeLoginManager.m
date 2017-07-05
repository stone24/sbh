//
//  BeLoginManager.m
//  SideBenefit
//
//  Created by RobinLiu on 15/2/27.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeLoginManager.h"
#import "BeLogUtility.h"
#import "AppDelegate.h"
#import "BeLoginViewController.h"
#import "ServerFactory.h"
#import "BeLoginServer.h"
#import "CommonDefine.h"
#import "NSDictionary+Additions.h"
#import <CommonCrypto/CommonDigest.h>
#import "DateFormatterConfig.h"
#import "SBHUserModel.h"
#import "ColorUtility.h"
#import "CommonDefine.h"
#import "SBHNavigationController.h"

#define kWelComeLabelHeight 20.0f
#define kAppearWelcomeDuration 1.0f
#define kDiappearWelcomeDuration 3.0f
#define kWelcomeEntUserText @"尊敬的企业用户，你好"
#define kWelcomeVIPUserText @"尊敬的会员，你好"

static BeLoginManager *loginManager = nil;
@interface BeLoginManager()
@property (nonatomic,strong)UIViewController *loginRootController;

@end
@implementation BeLoginManager
- (id)init
{
    if(self = [super init])
    {
    }
    return self;
}
+ (BeLoginManager *)sharedInstance
{
    @synchronized(self)
    {
        if(!loginManager)
        {
            loginManager = [[BeLoginManager alloc]init];
        }
    }
    return loginManager;
}
- (void)cancelLogin
{
    if(self.loginRootController)
    {
        [self.loginRootController dismissViewControllerAnimated:YES completion:^{
            self.loginRootController = nil;
            if (self.cancelBlock) {
                self.cancelBlock();
            }
        }];
    }
}
- (void)startLogin
{
    __weak typeof(self) wself = self;
    if(!self.cancelBlock)
    {
        self.cancelBlock = ^{
            wself.loginRootController = nil;
        };
    }
    UIViewController *topViewController = [[AppDelegate appdelegate]getCurrentDisplayViewController];
    BeLoginViewController *loginVC = [[BeLoginViewController alloc]init];
    SBHNavigationController *nav = [[SBHNavigationController alloc]initWithRootViewController:loginVC];
    [topViewController presentViewController:nav animated:YES completion:^{
        
    }];
    self.loginRootController = topViewController;
}
- (void)doLoginWithStoredData
{
    [[GlobalData getSharedInstance].userModel initConfigure];
    if([GlobalData getSharedInstance].userModel.isLogin == YES &&[GlobalData getSharedInstance].userModel.isEnterpriseUser == YES)
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"password":[GlobalData getSharedInstance].userModel.password,@"loginname":[GlobalData getSharedInstance].userModel.loginname}];
        [self enterpriseLoginWithObject:dict andSuccessBlock:^(NSString *success)
        {
                 
        }andFailBlock:^(NSString *failure)
        {
                 
        }];
    }
    else if ([GlobalData getSharedInstance].userModel.isLogin == YES &&[GlobalData getSharedInstance].userModel.isEnterpriseUser == NO)
    {
        //因私的不能登录
        [self loginManagerLogOff];      
    }
}
- (void)enterpriseLoginWithObject:(id)loginObject andSuccessBlock:(loginHandleBlock)successBlock andFailBlock:(loginHandleBlock)block
{
    NSString *originalPassword = [loginObject objectForKey:@"password"];
    NSString *pwTranscoding = [self transCode:[NSString stringWithFormat:@"%@shenbianhui^@(>MHGUsuiji4802Mm&7",[[GlobalData md5ToString:originalPassword] lowercaseString]]];
    [loginObject removeObjectForKey:@"password"];
    [loginObject setObject:pwTranscoding forKey:@"password"];

    if ([GlobalData getSharedInstance].iphoneUdid.length == 0) {
        NSString *str = [[UIDevice currentDevice] identifierForVendor].UUIDString;
        str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [GlobalData getSharedInstance].iphoneUdid = str;
    }
    [loginObject setValue:[GlobalData getSharedInstance].iphoneUdid forKey:@"devicetoken"];
    [loginObject setValue:@"ios" forKey:@"platform"];
    [loginObject setValue:@"json" forKey:@"format"];
    NSLog(@"enterprise自动登录的时候：：：：%@", loginObject);
    [[ServerFactory getServerInstance:@"BeLoginServer"]doEnterpriseUserLoginWith:loginObject byCallback:^(NSMutableDictionary *callBack){
        NSLog(@"%@", callBack);
        if([[callBack stringValueForKey:@"status"]isEqualToString:@"true"])
        {
            //登录成功
            [GlobalData getSharedInstance].userModel.isLogin = YES;
            [[GlobalData getSharedInstance]userModel].isEnterpriseUser = YES;
            [GlobalData getSharedInstance].userModel.deviceToken =
            [GlobalData getSharedInstance].iphoneUdid;
            
            [[GlobalData getSharedInstance].userModel setDataWithDic:callBack andIsEntType:YES];

            NSString *token = [callBack objectForKey:@"token"];
            [GlobalData getSharedInstance].token = token;
            [GlobalData getSharedInstance].userModel.password = originalPassword;
            
            [self successLoginActionController];
            [self setJpushAndBadgeNumWithIsSuccessLogin:YES];
            successBlock(@"登录成功");
        }
        if([[callBack stringValueForKey:@"status"]isEqualToString:@"false"])
        {
            //登录失败
            [self loginManagerLogOff];
            block([callBack stringValueForKey:@"code"]);
        }
    }failureCallback:^(NSString *callBack){
        [self loginManagerLogOff];
        block(@"登录失败");
    }];

}
- (void)startLogOffWithSuccessBlock:(loginHandleBlock)successBlock andFailureBlock:(loginHandleBlock)failureblock
{
    NSMutableDictionary *logOffDict = [NSMutableDictionary dictionary];
    [logOffDict setValue:[GlobalData getSharedInstance].userModel.userToken forKey:@"usertoken"];
    [logOffDict setValue:@"json" forKey:@"format"];
    [MBProgressHUD showMessage:@""];
    [[ServerFactory getServerInstance:@"BeLoginServer"]doLogOffWith:logOffDict byCallback:^(NSMutableDictionary *callback)
     {
         [MBProgressHUD hideHUD];
         if([[callback objectForKey:@"status"]isEqualToString:@"true"])
         {
             [self loginManagerLogOff];
             successBlock(@"退出登录成功");
         }
         else
         {
             failureblock(@"退出登录失败");
         }
     }failureCallback:^(NSString *failureCallback){
         [MBProgressHUD hideHUD];
         failureblock(@"退出登录失败");
     }];
}
- (void)successLoginActionController
{
    [[GlobalData getSharedInstance].userModel recordLatestLoginUserAccount];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationLoginSuccess object:nil];
    if(self.loginRootController !=nil)
    {
        [self.loginRootController dismissViewControllerAnimated:YES completion:^{
            self.loginRootController = nil;
        }];
    }
}
#pragma mark - privateMethod
- (void)loginManagerLogOff
{
    [[[GlobalData getSharedInstance]userModel]logOff];
    [[GlobalData getSharedInstance]logOff];
    [self setJpushAndBadgeNumWithIsSuccessLogin:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationLogOffSuccess object:nil];
}
/**
 * 根据登录状态来配置极光
 */
- (void)setJpushAndBadgeNumWithIsSuccessLogin:(BOOL)loginState
{
    if(loginState)
    {
        [[AppDelegate appdelegate] setJPushTag:[GlobalData getSharedInstance].iphoneUdid];
    }
    else
    {
        [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    }
}

- (NSString *)transCode:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}
@end
