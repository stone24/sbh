//
//  SBHUserModel.h
//  sbh
//
//  Created by SBH on 14-12-30.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, AccountType)
{
    AccountTypeIndependentIndividual = 0,//个人散客
    AccountTypeEnterprise = 1,//企业
    AccountTypeEntDepartment = 2,//企业部门
    AccountTypeEntIndividual = 3,//企业个人
    AccountTypeOther = 4,//其他
};
@interface SBHUserModel : NSObject
@property (nonatomic, strong) NSString *loginname;
@property (nonatomic, strong) NSString *EntName;
@property (nonatomic, strong) NSString *DptName;
@property (nonatomic, strong) NSString *staffname;
@property (nonatomic, strong) NSString *cardType;
@property (nonatomic, strong) NSString *certificatenumber;
@property (nonatomic, strong) NSString *roleid;
@property (nonatomic, strong) NSString *Gender;
@property (nonatomic, strong) NSString *BirthDay;
@property (nonatomic, strong) NSString *MobilePhone;
@property (nonatomic, strong) NSString *TypeCode;
@property (nonatomic, strong) NSString *password;
// 用支付宝所需参数
@property (nonatomic, strong) NSString *AccountID;
// 区分saas几 3是saas4
@property (nonatomic, strong) NSString *saas;
// 客服电话
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSString *Balance;
@property (nonatomic, strong) NSString *SigningDate;
@property (nonatomic, strong) NSString *SigningEndDate;
@property (nonatomic, strong) NSString *isaudit;
@property (nonatomic, strong) NSString *levelcode;
@property (nonatomic, strong) NSString *entId;
@property (nonatomic, strong) NSString *TrainAPP;

/**
 * 是否是益普索
 */
@property (nonatomic,assign)BOOL isYPS;

/**
 * 是否是天职
 */
@property (nonatomic,assign)BOOL isTianzhi;

/**
 * 员工账号有值
 */
@property (nonatomic,strong)NSString *PID;
@property (nonatomic,retain)NSString *IsTrain;//"IsTrain":"1" 是否开通高铁 0未开通 1开通
@property (nonatomic,retain)NSString *IsInternalAirTicket;//是否开通机票 0未开通 1开通
@property (nonatomic,retain)NSString *IsInternalHotel;//是否开通机票 0未开通 1开通
@property (nonatomic,strong)NSString *ismeeting;//是否开通会议 0未开通 1开通

@property (nonatomic,retain)NSString *Version;//版本号
@property (nonatomic,strong)NSString *userToken;
@property (nonatomic,assign)BOOL isLogin;//是否登录
@property (nonatomic,assign)BOOL isEnterpriseUser;//是否是企业用户
@property (nonatomic,assign)BOOL isCar;
@property (nonatomic,strong)NSString *deviceToken;///<设备Token
@property (nonatomic,assign)AccountType accountType;///<用户的类型
@property (nonatomic,strong)NSString *accountTypeString;///<1保理 2余额
@property (nonatomic,strong)NSString *StaffBaoLi;
@property (nonatomic,strong)NSString *isyqs;
/**
 * 是否是亿阳企业
 */
@property (nonatomic,assign)BOOL isYiyang;
@property (nonatomic,assign)BOOL IsBooked;
+(SBHUserModel*)getSharedInstance;

- (void)setDataWithDic:(NSDictionary *)dict andIsEntType:(BOOL)isEntType;

//配置
- (void)initConfigure;

//退出登录
- (void)logOff;

//记录最近登录用户的信息
- (void)recordLatestLoginUserAccount;

//获取最近登录用户的信息
- (SBHUserModel *)latestLoginUserAccount;
@end
