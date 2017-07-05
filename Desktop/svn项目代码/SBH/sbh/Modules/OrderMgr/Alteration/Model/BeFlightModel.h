//
//  BeFlightModel.h
//  sbh
//
//  Created by SBH on 15/4/14.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeFlightModel : NSObject
// 航班号
@property (nonatomic, copy) NSString *flightno;
// 机型
@property (nonatomic, copy) NSString *aircraftcode;
// 起飞日期
@property (nonatomic, copy) NSString *fltdate;
// 起飞时间
@property (nonatomic, copy) NSString *flttime;
// 到达日期
@property (nonatomic, copy) NSString *arrivaldate;
// 到达时间
@property (nonatomic, copy) NSString *arrivaltime;
// 起飞机场
@property (nonatomic, copy) NSString *boardname;
@property (nonatomic, copy) NSString *boardpointat;
// 到达机场
@property (nonatomic, copy) NSString *offname;
@property (nonatomic, copy) NSString *offpointat;
// 航空公司
@property (nonatomic, copy) NSString *carriername;
// 出发城市
@property (nonatomic, copy) NSString *boardcityname;
// 到达城市
@property (nonatomic, copy) NSString *offcityname;
// 仓位
@property (nonatomic, copy) NSString *classcode;
// 改签条件
@property (nonatomic, copy) NSString *ei;
@property (nonatomic, copy) NSString *endorsement;
@property (nonatomic, copy) NSString *refundmemo;
// 经停
@property (nonatomic, copy) NSString *viaport;


// 区分是日期还是航班号
@property (nonatomic, copy) NSString *dateOrNo;
// 处理数据，要显示的字段
@property (nonatomic, copy) NSString *flightTilteStr;
@property (nonatomic, copy) NSString *flightValueStr;

@property (nonatomic, copy) NSString *flightNoStr;
//@property (nonatomic, copy) NSString *phoneStr;
@property (nonatomic, copy) NSString *goDateStr;
@property (nonatomic, copy) NSString *fltimeStr;
@property (nonatomic, copy) NSString *arrivaltimeStr;
@property (nonatomic, copy) NSString *reachDateStr;
@property (nonatomic, copy) NSString *airportStr;
// 经停
@property (nonatomic, copy) NSString *viaportStr;
@end
