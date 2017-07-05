//
//  GlobalData.m
//  SBHAPP
//
//  Created by musmile on 14-6-3.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "GlobalData.h"
#import <CommonCrypto/CommonDigest.h>
#import "FMDatabase.h"
#import "SBHUserModel.h"

@implementation GlobalData

@synthesize iTiketOrderInfo;
@synthesize queryTiketDate;


#pragma mark MD5用于字符串

+ (NSString *)md5ToString:(NSString *)aFromString
{
    const char *cStr = [aFromString UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (int)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

+ (NSString *)md5ToData:(NSData *)aData
{
    const char *cStr = [aData bytes];
    unsigned char result[16];
    CC_MD5( cStr, (int)[aData length], result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

static GlobalData * instance;

-(id)init
{
    self = [super init];
    if (self)
    {
        self.chooseFlightArray = [NSMutableArray array];
        self.isfirst = @"first";
        self.GOW = @"";
        self.GOWw = @"";
        self.POWw = @"";
        self.UDIDd = @"";
        self.FLIGHTNORTt = @"";
        self.token = @"";
        self.ForcedInsurance = @"";
        self.userModel = [[SBHUserModel alloc]init];
        self.storedCommitInfo = [[NSMutableDictionary alloc]init];
        self.goremark = @"";
        self.backremark= @"";
    }
    return self;
}
+ (GlobalData*)getSharedInstance
{
    if(!instance)
    {
        @synchronized (self)
        {
            if(!instance)
            {
                instance = [[GlobalData alloc]init];
            }
        }
    }
    return instance;
}

//获取错误编码
+ (NSString*)getErrMsg:(NSString*)aCode
{
    NSString * stringmsg = @"";
    if([aCode isEqualToString:@"10003"])
    {
        stringmsg = @"登录失效，请重新登录！";
    }
    else if([aCode isEqualToString:@"10006"])
    {
        stringmsg = @"您已在其他设备登录，请重新登录！";
    }
    else if([aCode isEqualToString:@"20020"])
    {
        stringmsg = @"申请提交成功";
    }
    else if([aCode isEqualToString:@"50001"])
    {
        stringmsg = [NSString stringWithFormat:@"系统错误！"];
    }
    else if([aCode isEqualToString:@"10001"])
    {
        stringmsg = @"登录成功";
    }
    else if([aCode isEqualToString:@"10002"])
    {
        stringmsg = @"用户名或密码错误";
    }
    else if([aCode isEqualToString:@"10004"])
    {
        stringmsg = @"没有开通权限";
    }
    else if([aCode isEqualToString:@"10005"])
    {
        stringmsg = @"用户退出失败";
    }
    else if([aCode isEqualToString:@"10006"])
    {
        stringmsg = @"用户已在其他设备登录";
    }
    else if([aCode isEqualToString:@"10007"])
    {
        stringmsg = @"用户绑定成功";
    }
    else if([aCode isEqualToString:@"10008"])
    {
        stringmsg = @"用户绑定失败";
    }
    else if([aCode isEqualToString:@"10009"])
    {
        stringmsg = @"有效用户";
    }
    else if([aCode isEqualToString:@"20001"])
    {
        stringmsg = @"错误请求";
    }
    else if([aCode isEqualToString:@"20002"])
    {
        stringmsg = @"无效请求参数,未获取到请求参数";
    }
    else if([aCode isEqualToString:@"20003"])
    {
        stringmsg = @"没有航班记录";
    }
    else if([aCode isEqualToString:@"20004"])
    {
        stringmsg = @"乘机日期错误";
    }
    else if([aCode isEqualToString:@"20005"])
    {
        stringmsg = @"没有航班记录";
    }
    else if([aCode isEqualToString:@"20006"])
    {
        stringmsg = @"查询航班号和航班查询guid不能为空";
    }
    else if([aCode isEqualToString:@"20007"])
    {
        stringmsg = @"没有航班更多价格记录";
    }
    else if([aCode isEqualToString:@"20008"])
    {
        stringmsg = @"所选航班价格有变,请重新选择";
    }
    else if([aCode isEqualToString:@"20009"])
    {
        stringmsg = @"查询失败，请重新查询";
    }
    else if([aCode isEqualToString:@"20010"])
    {
        stringmsg = @"乘机人已经预定同一航班,请到订单列表查看";
    }
    else if([aCode isEqualToString:@"20011"])
    {
        stringmsg = @"订单生成成功";
    }
    else if([aCode isEqualToString:@"20012"])
    {
        stringmsg = @"机票查询超时";
    }
    else if([aCode isEqualToString:@"20013"])
    {
        stringmsg = @"提交订单出错";
    }
    else if([aCode isEqualToString:@"20014"])
    {
        stringmsg = @"航程信息有误";
    }
    else if([aCode isEqualToString:@"20015"])
    {
        stringmsg = @"无数据";
    }
    else if([aCode isEqualToString:@"20016"])
    {
        stringmsg = @"订单号不能为空";
    }
    else if([aCode isEqualToString:@"20017"])
    {
        stringmsg = @"非法订单请求，订单不属于该企业";
    }
    else if([aCode isEqualToString:@"20018"])
    {
        stringmsg = @"参数错误";
    }
    else if([aCode isEqualToString:@"20019"])
    {
        stringmsg = @"页码请求必须为非负整数";
    }
    else if([aCode isEqualToString:@"20020"])
    {
        stringmsg = @"申请提交完成";
    }
    else if([aCode isEqualToString:@"20021"])
    {
        stringmsg = @"乘机人已做过退改签";
    }
    else if([aCode isEqualToString:@"20022"])
    {
        stringmsg = @"您的座位已超出航空公司预留时限，已取消。";
    }
    else if([aCode isEqualToString:@"20023"])
    {
        stringmsg = @"支付订单失败";
    }
    else if([aCode isEqualToString:@"20024"])
    {
        stringmsg = @"支付订单成功";
    }
    else if([aCode isEqualToString:@"20025"])
    {
        stringmsg = @"取消订单成功";
    }
    else if([aCode isEqualToString:@"20026"])
    {
        stringmsg = @"取消订单失败";
    }
    else if([aCode isEqualToString:@"20027"])
    {
        stringmsg = @"操作成功";
    }
    else if([aCode isEqualToString:@"20028"])
    {
        stringmsg = @"审核处理失败";
    }
    else if([aCode isEqualToString:@"20030"])
    {
        stringmsg = @"";
    }
    else if([aCode isEqualToString:@"60001"])
    {
        stringmsg = @"无效代码";
    }
    else if([aCode isEqualToString:@"60002"])
    {
        stringmsg = @"回复代码正确，但出现审核失败";
    }
    else if([aCode isEqualToString:@"60003"])
    {
        stringmsg = @"审核未通过";
    }
    else if([aCode isEqualToString:@"60004"])
    {
        stringmsg = @"对联系人发送审核通过";
    }
    else if([aCode isEqualToString:@"60005"])
    {
        stringmsg = @"取消订单审核";
    }
    else
    {
        stringmsg = [NSString stringWithFormat:@"网络不给力"];
    }
    return stringmsg;
}
- (void)logOff
{
    self.token = @"";
}

@end
