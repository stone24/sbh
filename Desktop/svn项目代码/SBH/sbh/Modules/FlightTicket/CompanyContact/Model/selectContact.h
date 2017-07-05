//
//  selectContact.h
//  sbh
//
//  Created by musmile on 14-7-21.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface selectContact : NSObject
{
    NSString * iName;       //乘机人姓名
    NSString * iType;       //乘机人类别
    NSString * iMobile;     //手机
    NSString * iMesgType;   //消息类别
    NSString * iResturnState;//审核返回状态
    NSString * iIndex;      //发送序列
    NSString * iPhone;      //座机
    NSString * iEmail;      //邮箱
    NSString * iFromType;   //如果从员工则为1，如果从常用联系人则为2
    BOOL isOpenPhone; //是否打开短信
    BOOL isOpenEmail; //是否打开邮箱
}

@property(nonatomic,strong)NSString *iName;       //乘机人姓名
@property(nonatomic,strong)NSString *iType;       //乘机人类别
@property(nonatomic,strong)NSString *iMobile;     //手机
@property(nonatomic,strong)NSString *iMesgType;   //消息类别
@property(nonatomic,strong)NSString *iResturnState;//审核返回状态
@property(nonatomic,strong)NSString *iIndex;      //发送序列
@property(nonatomic,strong)NSString *iPhone;      //座机
@property(nonatomic,strong)NSString *iEmail;
@property(nonatomic,strong)NSString *contactsloginname; //邮箱
@property(nonatomic,strong)NSString *belongfunction; //邮箱

@property(nonatomic,readwrite)BOOL isOpenPhone;
@property(nonatomic,readwrite)BOOL isOpenEmail;

@property (nonatomic, assign) BOOL isChange;

@property(nonatomic,strong) NSString *phone;
@property(nonatomic,strong) NSString *pername;
@property(nonatomic,strong) NSString *sendemail;

// 火车票联系人
@property(nonatomic,strong) NSString *PerType;
@property(nonatomic,strong) NSString *FlowType;
@property(nonatomic,strong) NSString *LoginName;
@end
