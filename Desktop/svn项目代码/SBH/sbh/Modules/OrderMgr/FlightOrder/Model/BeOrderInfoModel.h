//
//  BeOrderInfoModel.h
//  sbh
//
//  Created by SBH on 15/4/17.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeFlightModel.h"
#import "BePassengerModel.h"
#import "BeOrderContactModel.h"
#import "SBHLogModel.h"
#import "BeOrderWriteModel.h"

@interface BeOrderInsuranceType : NSObject
@property (nonatomic,copy) NSString *businesstype;
@property (nonatomic,copy) NSString *paidmoney;
@property (nonatomic,copy) NSString *insuranceneedcount;
@end

@interface BeOrderInfoModel : NSObject
@property (nonatomic, copy) NSString *orderno;
// 出行类型
@property (nonatomic, copy) NSString *officialorprivate;
// 支付状态
@property (nonatomic, copy) NSString *paymentst;
// 订单金额
@property (nonatomic, copy) NSString *accountreceivable;
// 票价
@property (nonatomic, copy) NSString *sellprice;
// 机建
@property (nonatomic, copy) NSString *fueltex;
// 燃油
@property (nonatomic, copy) NSString *airporttax;
// 保险
@property (nonatomic, copy) NSString *insurancepricetotal;
// 订单状态
@property (nonatomic, copy) NSString *orderst;
// 费用中心
@property (nonatomic, copy) NSString *expensecenter;
// 服务费
@property (nonatomic, copy) NSString *servicecharge;
// 改签描述
@property (nonatomic, copy) NSString *changeremark;
// 出行原因
@property (nonatomic, copy) NSString *isreasons;
// 航班
@property (nonatomic, strong) NSArray *airorderflights;

/**
 * 保险种类
 */
@property (nonatomic, strong) NSMutableArray *baoxianlist;
@property (nonatomic, strong) NSMutableArray *flightFrameArray;

// 乘机人
@property (nonatomic, strong) NSArray *passengers;
@property (nonatomic, strong) NSMutableArray *pasFrameArray;
// 联系人
@property (nonatomic, strong) NSArray *contact;
@property (nonatomic, strong) NSMutableArray *conFrameArray;
@property (nonatomic, strong) NSArray *stgpassengers;

// 日志
@property (nonatomic, strong) NSArray *orderlog;

// 订单创建时间
@property (nonatomic, copy) NSString *creattime;
// 审批
@property (nonatomic, copy) NSString *isAudit;

// 预订人
@property (nonatomic, copy) NSString *bookingman;

// 订单金额明细
@property (nonatomic, copy) NSString *sumDetailStr;
@property (nonatomic, copy) NSString *orderstStr;

//
@property (nonatomic,assign)BOOL isSelectBaoli;

//新审批数据
@property (nonatomic, strong)NSDictionary *newaudit;

/**
 * 获取的订单详情数据
 */
@property (nonatomic, strong)NSMutableDictionary *orderInfoDict;


@property (nonatomic,strong)NSString *TicketId;

/**
 * 项目审批的人的信息数组
 */
@property (nonatomic,strong)NSMutableArray *projectAuditPersonArray;

/**
 * 非项目的审批人的信息数组 或者 老审批数组
 */
@property (nonatomic,strong)NSMutableArray *otherAuditPersonArray;

/**
 * 网络获取的审批类型
 */
@property (nonatomic,assign)DispalyAuditType auditType;

/**
 * 选中的审批模式
 */
@property (nonatomic,assign)OrderSelectedAuditMode selectAudit;

/**
 * 选中的审批人数组
 */
@property (nonatomic,strong)NSMutableArray *selectedAuditPersonArray;

/**
 * 选中的项目
 */
@property (nonatomic,strong)BeAuditProjectModel *selectedProject;


/**
 * 项目的flowID
 */
@property (nonatomic,strong)NSString *projectFlowID;
/**
 * 获取价格详细
 */
- (void)setSumDetailStr;

- (void)getAuitDataWith:(NSDictionary *)dict withSourceType:(OrderFinishSourceType )sourceType;
/**
 * 封装项目审批的数据
 */
- (NSDictionary *)getAuditDict;
@end
