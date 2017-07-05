//
//  SBHUserModel.m
//  sbh
//
//  Created by SBH on 14-12-30.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "SBHUserModel.h"
#import "CommonDefine.h"
#import "NSDictionary+Additions.h"
#import "ServerConfigure.h"

@implementation SBHUserModel

static SBHUserModel *instance = nil;
+(SBHUserModel*)getSharedInstance
{
    if(instance ==nil){
        @synchronized (self)
        {
            if(!instance)
            {
                instance = [[SBHUserModel alloc] init];
            }
        }
    }
    return instance;
}
- (id)init
{
    if(self = [super init])
    {
        
    }
    return self;
}
- (void)setDataWithDic:(NSDictionary *)dict andIsEntType:(BOOL)isEntType
{
    NSDictionary *userinfo = [dict objectForKey:@"userinfo"];
    _TrainAPP = [userinfo stringValueForKey:@"TrainAPP" defaultValue:@""];
    [self setLoginname:[userinfo stringValueForKey:@"loginname" defaultValue:@""]];
    _EntName = [userinfo stringValueForKey:@"EntName" defaultValue:@""];
    _DptName = [userinfo stringValueForKey:@"DptName" defaultValue:@""];
    _staffname = [userinfo stringValueForKey:@"staffname" defaultValue:@""];
    _cardType = [userinfo stringValueForKey:@"cardType" defaultValue:@""];
    _PID = [userinfo stringValueForKey:@"PID" defaultValue:@""];
    _certificatenumber = [userinfo stringValueForKey:@"certificatenumber" defaultValue:@""];
    _roleid = [userinfo stringValueForKey:@"roleid" defaultValue:@""];
    _isyqs = [userinfo stringValueForKey:@"isyqs" defaultValue:@"0"];
    [self setGender:[userinfo stringValueForKey:@"Gender" defaultValue:@""]];
    _BirthDay = [userinfo stringValueForKey:@"BirthDay" defaultValue:@""];
    _MobilePhone = [userinfo stringValueForKey:@"MobilePhone" defaultValue:@""];
    _TypeCode = [userinfo stringValueForKey:@"TypeCode" defaultValue:@""];
    _AccountID = [userinfo stringValueForKey:@"AccountID" defaultValue:@""];
    _saas = [userinfo stringValueForKey:@"saas" defaultValue:@""];
    _phoneNum = [dict stringValueForKey:@"kftel" defaultValue:@""];
    _Balance = [userinfo stringValueForKey:@"Balance" defaultValue:@""];
    _SigningDate = [userinfo stringValueForKey:@"SigningDate" defaultValue:@""];
    _SigningEndDate = [userinfo stringValueForKey:@"SigningEndDate" defaultValue:@""];
    
    _isaudit = [userinfo stringValueForKey:@"isaudit" defaultValue:@""];
    _levelcode = [userinfo stringValueForKey:@"levelcode" defaultValue:@""];
    _entId = [userinfo stringValueForKey:@"EntID" defaultValue:@""];
    _IsTrain = [userinfo stringValueForKey:@"IsTrain" defaultValue:@""];
    _Version = [userinfo stringValueForKey:@"Version" defaultValue:@""];
    _userToken = [dict stringValueForKey:@"token" defaultValue:@""];
    _IsInternalAirTicket = [userinfo stringValueForKey:@"IsInternalAirTicket" defaultValue:@""];
    _IsInternalHotel = [userinfo stringValueForKey:@"IsInternalHotel" defaultValue:@""];
    _ismeeting = [userinfo stringValueForKey:@"ismeeting" defaultValue:@"0"];
    _StaffBaoLi = [userinfo stringValueForKey:@"StaffBaoLi" defaultValue:@"0"];
    if([[userinfo stringValueForKey:@"IsBooked" defaultValue:@"0"]isEqualToString:@"True"] ||[[userinfo stringValueForKey:@"IsBooked" defaultValue:@"0"] integerValue] == 1)
    {
        _IsBooked = YES;
    }
    else
    {
        _IsBooked = NO;
    }
    if ([[userinfo stringValueForKey:@"IsCar" defaultValue:@""] intValue]== 1) {
        _isCar = YES;
    }
    else
    {
        _isCar = NO;
    }
    _accountTypeString = [userinfo stringValueForKey:@"accounttype" defaultValue:@"0"];
    if(isEntType)
    {
        _accountType = (int)[_levelcode intValue];
    }
    else
    {
        if([_DptName isEqualToString:kAccountCondition])
        {
            _accountType = AccountTypeIndependentIndividual;
        }
        else
        {
            _accountType = AccountTypeEntIndividual;
        }
    }
    _isYPS = [[[userinfo stringValueForKey:@"YPS" defaultValue:@""] componentsSeparatedByString:@"|"]containsObject:_entId];
    if([kServerHost hasPrefix:@"http://192"])
    {
        //测试
        _isTianzhi = [_entId isEqualToString:@"401003"]?YES:NO;
    }
    else
    {
        _isTianzhi = [_entId isEqualToString:@"419204"]?YES:NO;
    }
    _isYiyang = NO;
    NSString *yiyangEntID = [[[userinfo stringValueForKey:@"dingzhi" defaultValue:@""]componentsSeparatedByString:@"|"] lastObject];
    if([yiyangEntID isEqualToString:_entId])
    {
        _isYiyang = YES;
    }
}
- (void)recordLatestLoginUserAccount
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithBool:_isEnterpriseUser] forKey:@"loginType"];
    [dict setObject:_loginname forKey:@"loginName"];
    [dict setObject:_password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults]setObject:dict forKey:kLatestLoginUserAccount];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (SBHUserModel *)latestLoginUserAccount
{
    NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:kLatestLoginUserAccount];
    SBHUserModel *model = [[SBHUserModel alloc]init];
    model.isEnterpriseUser = [[dict objectForKey:@"loginType"] boolValue];
    model.loginname = [dict objectForKey:@"loginName"];
    model.password = [dict objectForKey:@"password"];
    return model;
}
- (void)initConfigure
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.deviceToken = [ud objectForKey:@"deviceToken"];
    self.password = [ud objectForKey:@"password"];
    self.userToken = [ud objectForKey:@"userToken"];
    self.loginname = [ud objectForKey:@"loginname"];
    self.isEnterpriseUser = [[ud objectForKey:@"isEnterpriseUser"] boolValue];
    self.isLogin = [[ud objectForKey:@"isLogin"] boolValue];
}

- (void)logOff
{
    self.deviceToken = nil;
    self.isLogin = NO;
    self.password = nil;
    self.loginname = nil;
    self.userToken = nil;
}

#pragma mark - Set Method
- (void)setDeviceToken:(NSString *)deviceToken
{
    _deviceToken = deviceToken;
    [[NSUserDefaults standardUserDefaults]setObject:_deviceToken forKey:@"deviceToken"];
}
- (void)setPassword:(NSString *)password
{
    _password = password;
    [[NSUserDefaults standardUserDefaults]setObject:_password forKey:@"password"];
}

- (void)setUserToken:(NSString *)userToken
{
    _userToken = [userToken copy];
    [[NSUserDefaults standardUserDefaults]setObject:_userToken forKey:@"userToken"];
}
- (void)setLoginname:(NSString *)loginname
{
    _loginname = [loginname copy];
    [[NSUserDefaults standardUserDefaults]setObject:loginname forKey:@"loginname"];
}

- (void)setIsEnterpriseUser:(BOOL)isEnterpriseUser
{
    _isEnterpriseUser = isEnterpriseUser;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:_isEnterpriseUser] forKey:@"isEnterpriseUser"];
}
- (void)setGender:(NSString *)Gender
{
    if ([Gender isEqualToString:@"1"]) {
        _Gender = @"M";
    } else if([Gender isEqualToString:@"0"]){
        _Gender = @"F";
    }
    else
    {
        _Gender = Gender;
    }
}
- (void)setIsLogin:(BOOL)isLogin
{
    _isLogin = isLogin;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:_isLogin] forKey:@"isLogin"];
}
@end
