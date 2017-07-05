//
//  BeTrainOrderInfoModel.h
//  sbh
//
//  Created by SBH on 15/6/17.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeTrainPassengerModel.h"
#import "BeTrainInfoModel.h"

@interface BeTrainOrderInfoModel : NSObject
@property (nonatomic, copy) NSString *officialorprivate;
@property (nonatomic, copy) NSString *orderno;
@property (nonatomic, copy) NSString *mobilephone;
@property (nonatomic, copy) NSString *expensecenter;
@property (nonatomic, copy) NSString *creatdate;
@property (nonatomic, copy) NSString *entname;
@property (nonatomic, copy) NSString *ticketpricetotal;
// 小括号
@property (nonatomic, copy) NSString *linkman;
@property (nonatomic, copy) NSString *projectname;
@property (nonatomic, copy) NSString *changeremark;
@property (nonatomic, copy) NSString *orderst;
@property (nonatomic, copy) NSString *accountreceivable;

@property (nonatomic, copy) NSString *bookingman;
@property (nonatomic, copy) NSString *insurancepricetotal;

@property (nonatomic, strong) NSArray *traininfolist;
@property (nonatomic, strong) NSArray *gqsqlist;
@property (nonatomic,strong) NSArray *tpsqlist;
@property (nonatomic,strong) NSArray *psglist;
@property (nonatomic,strong)NSArray *contactList;
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic, strong) NSMutableArray *pasFrameArray;
@property (nonatomic, strong) NSMutableArray *conFrameArray;
- (id)initWithDict:(NSDictionary *)dict;
@end
