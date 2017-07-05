//
//  BeOrderWriteFlightInfoModel.h
//  sbh
//
//  Created by SBH on 15/5/8.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeOrderWriteAirlistModel.h"
#import "BeOrderWriteAuditInfoModel.h"
#import "BeAuditProjectModel.h"
#import "MJExtension.h"

//空格因为要对齐
#define kInsuranceTitleA        @"航班意外险(A款)     "
#define kInsuranceTitleB        @"航空意外险(B款)     "
#define kInsuranceTitleDelay    @"航班延误险              "

#ifdef DEBUG
#define kZhongxinrongchuangEntID @"400887"
#else
#define kZhongxinrongchuangEntID @"401419"
#endif
typedef NS_ENUM(NSInteger,OrderInsuranceType) {
    InsuranceTypeNotShow = 1,       //不显示保险
    InsuranceTypeForced = 2,        //强制保险
    InsuranceTypeOptional = 3,      //可选保险
};
typedef NS_ENUM(NSInteger,DispalyAuditType) {
    AuditTypeNone = 0,              //不需要审批
    AuditTypeOld = 1,               //老审批
    AuditTypeWithoutProject = 2,    //非项目审批(新审批)
    AuditTypeProjectAndEnt = 3,     //公司和项目审批全有(新审批)
    AuditTypeProjectAndDep = 4,     //部门和项目审批全有(新审批)
    AuditTypeProjectAndInd = 5,     //个人和项目审批
    AuditTypeOnlyProject = 6,       //只有项目审批(新审批)
};
typedef NS_ENUM(NSInteger,OrderSelectedAuditMode) {
    SelectedAuditModeOther = 0,     //部门、公司选中时
    SelectedAuditModeProject = 1,   //项目选中时
};
typedef NS_ENUM(NSInteger,OrderFinishSourceType) {
    OrderFinishSourceTypeWriteOrder = 0,
    OrderFinishSourceTypeOrderList = 1,
    OrderFinishSourceTypeOrderDetail = 2,
};

//保险模型
@interface BeOrderInsuranceModel : NSObject
/**
 * 保险名称
 */
@property (nonatomic, copy) NSString *insuranceName;
/**
 * 描述
 */
@property (nonatomic, copy) NSString *insuranceDescription;
/**
 * 金额
 */
@property (nonatomic, copy) NSString *insurancePrice;
/**
 * 数量
 */
@property (nonatomic, assign) int insuranceCount;
/**
 * 大额保险设置类型  1不显示保险  2 强制保险 3 可选保险
 */
@property (nonatomic, assign) OrderInsuranceType insuranceType;

/**
 * 可选的最大份数
 */
@property (nonatomic, assign) int maxCount;
@end

@interface BeOrderWriteModel : NSObject

/**
 * 选择的乘机人的最多人数 如果系统没有保存，就是9个
 */
@property (nonatomic,assign)int maxPassengerCount;
// 是否客户定制 费用中心
@property (nonatomic, copy) NSString *iscustomized;
// 是否显示项目编码
@property (nonatomic, copy) NSString *isprojectno;
// 是否显示项目名称
@property (nonatomic, copy) NSString *isprojectname;
// 请求返回值状态
@property (nonatomic, copy) NSString *status;
// 请求返回值编码
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong)NSString *belongfunction;
/**
 *  提交的保险数组
 */
@property (nonatomic,strong)NSMutableArray *insuranceArray;
/**
 *  所有的保险价格
 */
@property (nonatomic,strong)NSMutableDictionary *insuranceDict;

/**
 *  航班信息列表
 */
@property (nonatomic, strong) NSArray *airlist;

/**
 *  老审批人的列表（第一个数据为展示的审批人）
 */
@property (nonatomic, strong) NSArray *contactList;

/**
 *  定制企业的企业ID
 */
@property (nonatomic,strong)NSString *dingzhi;
/**
 *  是否是中新融创
 */
@property (nonatomic,assign)BOOL isSpecialCompany;


@property (nonatomic,strong)NSString *TicketId;
/**
 * verifypassengers
 0不验证
 其他任意值验证
 */
@property (nonatomic,strong)NSString *verifypassengers;
/**
 *  联系人是否可以编辑 员工账号  判断"IsBooked": "True"   是True的话不能为其他人预定     非True的话可以为其他人预定
 */
@property (nonatomic,assign)BOOL isContactCanEdit;
/**
 *  项目审批的人的信息数组
 */
@property (nonatomic,strong)NSMutableArray *projectAuditPersonArray;

/**
 *  非项目的审批人的信息数组 或者 老审批数组
 */
@property (nonatomic,strong)NSMutableArray *otherAuditPersonArray;

/**
 *  网络获取的审批类型
 */
@property (nonatomic,assign)DispalyAuditType auditType;

/**
 *  选中的审批模式
 */
@property (nonatomic,assign)OrderSelectedAuditMode selectAudit;

/**
 *  选中的审批人数组
 */
@property (nonatomic,strong)NSMutableArray *selectedAuditPersonArray;

/**
 *  选中的项目
 */
@property (nonatomic,strong)BeAuditProjectModel *selectedProject;

/**
 *  选择的乘机人
 */
@property (nonatomic,strong)NSMutableArray *selectPassArr;
/**
 *  公司联系人
 */
@property (nonatomic,strong)NSMutableArray *companyContactArray;

/**
 *  判断是否显示项目编码，项目描述
 */
@property (nonatomic, assign) BOOL showProjectReasons;

/**
 *  项目编码，项目描述数组
 */
@property (nonatomic,strong)NSMutableArray *projectArray;

/**
 *  封装数据
 */
- (void)setupDataWithDict:(NSDictionary *)dict;

/**
 *  获取审批人的信息
 */
+ (NSMutableArray *)setupAuditArrayWith:(NSArray *)array;

/**
 *  订单详情审批信息
 */
- (void)getAuitDataWith:(NSDictionary *)dict withSourceType:(OrderFinishSourceType )sourceType;

/**
 *  获取总额
 */
- (int)getAllPrice;
@end
