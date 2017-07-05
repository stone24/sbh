//
//  SBHManageModel.h
//  sbh
//
//  Created by SBH on 14-12-27.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SBHOrderDetail,
    SBHAuditDetail
} SBHDetailType;

@interface SBHManageModel : NSObject
@property (nonatomic, strong) NSString *orderno;
// 是否补单
@property (nonatomic, strong) NSString *isresupplier;
// 出行类型
@property (nonatomic, strong) NSString *officialorprivate;
@property (nonatomic, strong) NSString *airline;
// 旅客
@property (nonatomic, strong) NSString *psgname;
// 订单金额
@property (nonatomic, strong) NSString *accountreceivable;
@property (nonatomic, strong) NSString *creatdate;
@property (nonatomic, strong) NSString *fltdate;
// 订单状态
@property (nonatomic, strong) NSString *orderst;
@property (nonatomic, strong) NSString *paytype;
@property (nonatomic, strong) NSString *flightno;
// 是否可以手机支付  // 是否是审批
@property (nonatomic, strong) NSString *isaudit;
@property (nonatomic, strong) NSString *Audit_Time;

@property (nonatomic, strong) NSString *backflightno;
@property (nonatomic, strong) NSString *backDate;
@property (nonatomic, strong) NSString *comeDate;
//@property (nonatomic, strong) NSString *orderStats;
// 是否支付
@property (nonatomic, strong) NSString *paymentst;
@property (nonatomic, strong) NSString *flightTpye;
//@property (nonatomic, strong) NSString *gobackCity;
@property (nonatomic, strong) NSString *comeCity;
@property (nonatomic, strong) NSString *reachCity;
@property (nonatomic, assign) BOOL travelType;

@property (nonatomic, strong) NSString *minuStr;
@property (nonatomic, strong) NSString *sconStr;

// 0未点击去审批 1点击过去审批
@property (nonatomic, strong) NSString *issend;
// 详情类型
@property (nonatomic, strong) NSString *detailType;
/**
 * 服务费
 */
@property (nonatomic, strong) NSString *servicecharge;
@end
