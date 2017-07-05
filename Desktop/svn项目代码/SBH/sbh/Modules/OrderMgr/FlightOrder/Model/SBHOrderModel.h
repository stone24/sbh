//
//  SBHOrderModel.h
//  sbh
//
//  Created by SBH on 14-12-26.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBHOrderModel : NSObject
@property (nonatomic, strong) NSString *flightNum;
@property (nonatomic, strong) NSString *backflightNum;
@property (nonatomic, strong) NSString *dateTime;
@property (nonatomic, strong) NSString *backdate;
@property (nonatomic, strong) NSString *goTime;
@property (nonatomic, strong) NSString *reachTime;
@property (nonatomic, strong) NSString *goBoardName;
@property (nonatomic, strong) NSString *reachBoardName;
@property (nonatomic, strong) NSString *orderNum;
@property (nonatomic, strong) NSString *ticketPrice;
@property (nonatomic, strong) NSString *flightTpye;
@property (nonatomic, strong) NSString *comeCity;
@property (nonatomic, strong) NSString *reachCity;
@property (nonatomic, strong) NSString *danjitingStr;
@property (nonatomic, strong) NSString *wangjitingStr;
@property (nonatomic, assign) BOOL travelType;

@property (nonatomic, strong) NSString *minuStr;
@property (nonatomic, strong) NSString *sconStr;

@property (nonatomic, assign) BOOL isorderDetil;

@property (assign, nonatomic) double orderCreatTime;





@end
