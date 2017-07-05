//
//  selectContact.m
//  sbh
//
//  Created by musmile on 14-7-21.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "selectContact.h"

@implementation selectContact
@synthesize  iName ;       //乘机人姓名
@synthesize  iType;       //乘机人类别
@synthesize  iMobile;     //手机
@synthesize  iMesgType;   //消息类别
@synthesize  iResturnState;//审核返回状态
@synthesize  iIndex;      //发送序列
@synthesize  iPhone;      //座机
@synthesize  iEmail;   //邮箱
@synthesize  contactsloginname;
@synthesize isOpenEmail;
@synthesize isOpenPhone;
@synthesize isChange;

-(id)init
{
    self = [super init];
    if (self)
    {
        iName = @"";       //乘机人姓名
        iType = @"";       //乘机人类别
        iMobile = @"";     //手机
        iMesgType = @"";   //消息类别
        iResturnState = @"";//审核返回状态
        iIndex = @"";      //发送序列
        iPhone = @"";      //座机
        iEmail = @"";      //邮箱
        contactsloginname = @"";
        isOpenPhone = YES; //默认都打开
        isOpenEmail = YES; //默认都打开
        isChange = NO;
        
        _FlowType = @"";
        _PerType = @"";
        _LoginName = @"";
        _belongfunction = @"";
    }
    return self;
}

- (void)setIName:(NSString *)name
{
    if (![iName isEqualToString:@""]) {
        isChange = YES;
        contactsloginname = @"";
    }
    iName = name;
    
}

- (void)setPhone:(NSString *)phone
{
    _phone = [NSString stringWithFormat:@"电话:%@",phone];
}

- (void)setSendemail:(NSString *)sendemail
{
    if (sendemail.length != 0) {
        _sendemail = [NSString stringWithFormat:@"邮箱:%@",sendemail];
    } else{
        _sendemail = sendemail;
    }
    
}
@end
