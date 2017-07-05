//
//  selectPerson.h
//  sbh
//
//  Created by musmile on 14-7-21.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface selectPerson : NSObject
@property(nonatomic,strong) NSString *iId;         //乘机人编号
@property(nonatomic,strong) NSString *iType;       //乘机人类别
@property(nonatomic,strong) NSString *iGender;     //乘机人性别
@property(nonatomic,strong) NSString *iName;       //乘机人姓名
@property(nonatomic,strong) NSString *iCredtype;   //证件类型
@property(nonatomic,strong) NSString *iCredNumber; //证件号码
@property(nonatomic,strong) NSString *iMobile;     //手机
@property(nonatomic,strong) NSString *iInsquantity;//保险数量
@property(nonatomic,strong) NSString *iInsprice;   //保险价格
@property(nonatomic,strong) NSString *iOftencred;  //航空公司会员卡
@property(nonatomic,strong) NSString *iBirthday;   //乘机人生日
@property(nonatomic,strong) NSString *iFromType;//如果从员工则为1，如果从常用联系人则为2
@property(nonatomic,strong) NSString *rolename; // 部门
@property(nonatomic,strong) NSString *depid; // 部门id
@property(nonatomic,assign) BOOL isSelectItem;

@property (nonatomic, strong) NSMutableArray *array;


@property(nonatomic,strong) NSString *psgname;
@property(nonatomic,strong) NSString *cardtypename;
@property(nonatomic,strong) NSString *cardno;
@property(nonatomic,strong) NSString *mobilephone;
@property(nonatomic,strong) NSString *tktno;
@property (nonatomic,assign)BOOL isStop;

@property(nonatomic,strong) NSString *owcb;//去程的差旅政策
@property(nonatomic,strong) NSString *rtcb;//回程的差旅政策

// 用车最近乘车人信息
@property(nonatomic,copy) NSString *PassengerAccountId;
@property(nonatomic,copy) NSString *PassengerEntId;  
- (id)initWithDict:(NSDictionary *)dict andFromType:(NSString *)type;
@end
