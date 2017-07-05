//
//  BeHotelOrderWriteModel.h
//  sbh
//
//  Created by RobinLiu on 15/12/15.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeHotelDetailSectionModel.h"
#import "BeHotelListItem.h"
#import "BeHotelOrderWriteModel.h"
#import "BeAuditProjectModel.h"

#define kExpenseCenter      @"ExpenseCenter"
#define kProjectName        @"ProjectName"
#define kProjectCode        @"ProjectCode"
#define kBusinessReasons    @"BusinessReasons"

#define kRoomCount          @"房间数"
#define kRoomPerson         @"入住人"
#define kCheckInTime        @"到店时间"
#define kRemark             @"备注"

typedef NS_ENUM(NSInteger,HotelAuditType) {
    HotelAuditTypeNone = 0,          //不需要审批
    HotelAuditTypeWithoutProject = 2, //非项目审批(新审批)
    HotelAuditTypeProjectAndEnt = 3,//公司和项目审批全有(新审批)
    HotelAuditTypeProjectAndDep = 4,//部门和项目审批全有(新审批)
    HotelAuditTypeProjectAndInd = 5,//个人和项目审批
    HotelAuditTypeOnlyProject = 6,   //只有项目审批(新审批)
};
typedef NS_ENUM(NSInteger,HotelOrderSelectedAuditMode) {
    HotelSelectedAuditModeOther = 0,//部门、公司选中时
    HotelSelectedAuditModeProject = 1,//项目选中时
};

@interface BeHotelOrderWriteModel : NSObject

@property (nonatomic,strong)NSString *City_Code;//(必填)
@property (nonatomic,strong)NSString *CityName;
@property (nonatomic,strong)NSString *RatePlanInfoId;
@property (nonatomic,strong)NSString *HotelId;
@property (nonatomic,strong)NSString *HotelName;
@property (nonatomic,strong)NSString *StarRate;//星级

@property (nonatomic,strong)NSString *Category;//准星级
@property (nonatomic,strong)NSString *GsType;//(必填)因公=1,因私=2 类型
@property (nonatomic,strong)NSString *RoomName;//(必填)
@property (nonatomic,strong)NSString *Address;//(必填)
@property (nonatomic,strong)NSString *RoomCount;//(必填)房间数
@property (nonatomic,strong)NSString *PayType;//(必填)支付方式：到付=1，预付=2
@property (nonatomic,strong)NSString *Rp_ChancelStatus;//限时取消（开始时间：2016-6-3 18:00:00-结束时间：2016-6-4 0:00:00）
@property (nonatomic,strong)NSString *PayMethod;//(必填)酒店支付方式：快钱支付=1，预付卡支付=2，保理系统支付=3 ,前台现付=4 易宝支付=6
@property (nonatomic,strong)NSString *ServiceFee;//(没有填0)
@property (nonatomic,strong)NSString *AddBreakfastFee;//(没有填0)
@property (nonatomic,strong)NSString *AddBedFee;//(没有填0)
@property (nonatomic,strong)NSString *BroadbandFee;//(没有填0)
@property (nonatomic,strong)NSString *OtherFee;//(没有填0)
@property (nonatomic,strong)NSString *OrderNote;//备注
@property (nonatomic,strong)NSString *CheckInDate;//2015-12-9(必填)
@property (nonatomic,strong)NSString *CheckOutDate;//2015-12-12(必填)
@property (nonatomic,strong)NSString *PolicyRemark;//入住前1天中午12:00之前可变更或取消，如未入住将扣除全额房费", //(必填)
@property (nonatomic,strong)NSString *PolicyName;//": "内宾/预付",// 这个字段为酒店详情里面的RoomInfo。RatePlanInfo。Rp_Name这个地段
@property (nonatomic,strong)NSString *ReservedTime;//保留时间

@property (nonatomic,strong)NSString *ExpenseCenter;//费用中心
@property (nonatomic,strong)NSString *ProjectName;//项目名称
@property (nonatomic,strong)NSString *ProjectCode;//项目编号
@property (nonatomic,strong)NSString *BusinessReasons;//出差原因

@property (nonatomic,strong)NSMutableArray *Persons;//"必填
@property (nonatomic,strong)NSMutableArray *Contacts;//必填
@property (nonatomic,strong)NSMutableArray *Ticket;//选填
@property (nonatomic,strong)NSMutableArray *priceArray;
@property (nonatomic,strong)NSString *roomPrice;
@property (nonatomic,strong)NSString *flag;

@property (nonatomic,strong)NSString *orderNo;

@property (nonatomic,strong)NSString *CreateTime;
@property (nonatomic,strong)NSString *TicketId;

@property (nonatomic,strong)NSString *VerifypriceID;

@property (nonatomic,strong)NSString *errorNo;

@property (nonatomic,strong)NSString *belongfunction;
/**
 *  首次提交判断超标0 首次提交 1原因提交
 */
@property (nonatomic,strong)NSString *isExceed;
/**
 *  差旅政策超标原因
 */
@property (nonatomic,strong)NSString *PolicyReason;

/**
 * 页面展示需要
 */
@property (nonatomic,strong)NSMutableArray *expenseDisplayArray;
@property (nonatomic,strong)NSMutableArray *roomSectionDisplayArray;
@property (nonatomic,strong)NSString *payTypeString;

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
@property (nonatomic,assign)HotelAuditType auditType;

/**
 * 选中的审批模式
 */
@property (nonatomic,assign)HotelOrderSelectedAuditMode selectAudit;

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

@property (nonatomic,strong)NSDictionary *auditDict;
- (void)setDataWith:(BeHotelListItem *)listItem and:(BeHotelDetailSectionModel *)hotelSectionModel and:(BeHotelDetailRoomListModel *)roomModel;
- (void)updateExpenseDisplayWith:(NSDictionary *)dict;

- (void)checkInfoIsCorrectWithBlock:(void (^)(BOOL isCanBook,NSString *status))callback;
/**
 * 酒店订单详情点击支付
 */
- (void)setupDataWithHotelOrderData:(NSDictionary *)parameters;

/**
 * 获取酒店订单审批
 */
- (void)getHotelAuditWith:(NSDictionary *)dict;
- (NSDictionary *)getAuditDict;
@end
