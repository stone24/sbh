//
//  GlobalData.h
//  SBHAPP
//
//  Created by musmile on 14-6-3.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityData.h"
#import "UMMobClick/MobClick.h"
#import "TicketOrderInfo.h"
#import "selectPerson.h"
#import "SBHUserModel.h"

typedef NS_ENUM(NSInteger,IsNeedTravelPolicy) {
    IsNeedTravelPolicyYes = 1,
    IsNeedTravelPolicyNo  = 0,
};
@interface GlobalData : NSObject
{
    //机票预定信息
    TicketOrderInfo * iTiketOrderInfo;
    NSDate * queryTiketDate;
}
@property (nonatomic, copy) NSString *iphoneUdid;

@property (nonatomic, strong) SBHUserModel *userModel;
/**
 * 机票最多可预订几张票（记录剩几张票）
 */
@property (nonatomic, strong) NSString *seatTicketNum;

@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSArray *array;

@property(nonatomic,strong)NSString *UDID;
@property(nonatomic,strong)NSString *UDIDd;
@property(nonatomic,strong)NSString *FLIGHTNORT;
@property(nonatomic,strong)NSString *FLIGHTNORTt;
// 航班到达时间
@property(nonatomic,strong)NSString *airReachTime;

@property(nonatomic,strong)NSString *GOW;
@property(nonatomic,strong)NSString *GOWw;
@property(nonatomic,strong)NSString *POW;
@property(nonatomic,strong)NSString *POWw;

@property(nonatomic,strong)TicketOrderInfo * iTiketOrderInfo;
@property (nonatomic,assign)int insquantity;
@property(nonatomic,strong)NSString *DANSHUAN;
@property(nonatomic,strong)NSString *DepartureDate;

@property(nonatomic,strong) NSMutableArray *chooseFlightArray;

//强制保险
@property (nonatomic,strong)NSString *ForcedInsurance;
@property(nonatomic,strong)NSString *iSdancheng;
@property(nonatomic,strong)NSString *isfirst;

@property(nonatomic,strong)NSDate * queryTiketDate;

/**
 * 0老审批1新审批
 */
@property(nonatomic,strong)NSString *isnewaudit;

/**
 * 选中的差旅政策
 */
@property(nonatomic,strong)NSString *overproreasons;

/**
 * 去程差旅政策
 */
@property (nonatomic,strong)NSString *goremark;

/**
 * 返程差旅政策
 */
@property (nonatomic,strong)NSString *backremark;


// 去程回程日期
@property (nonatomic, strong) NSString *quchengDate;
@property (nonatomic, strong) NSString *huichengDate;
/**
 * 首次提交的数据
 */
@property (nonatomic,strong)NSMutableDictionary *storedCommitInfo;
-(id)init;

+ (NSString *)md5ToString:(NSString *)aFromString;

/** 以单例模式运行，便于共享*/
+(GlobalData*)getSharedInstance;

//获取错误编码
+(NSString*)getErrMsg:(NSString*)aCode;

- (void)logOff;
@end
