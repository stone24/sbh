//
//  BeTrainBookModel.h
//  sbh
//
//  Created by RobinLiu on 15/6/23.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeTrainTicketListModel.h"
#import "BeTrainOrderInfoModel.h"
#import "BeTrainInfoModel.h"

@interface BeTrainBookModel : NSObject

@property (nonatomic,strong)NSString *TrainCode;// = D311,//列车车次
@property (nonatomic,strong)NSString *StartCity;//出发城市
@property (nonatomic,strong)NSString *EndTime;// = 08:58,//到达时间
@property (nonatomic,strong)NSString *EndCity;// = 上海,//到达城市
@property (nonatomic,strong)NSString *CostTime;// = 11:42,//运行时间
@property (nonatomic,strong)NSString *StartTime ;//= 21:16,//出发时间
@property (nonatomic,strong)NSString *TrainType;// = 动车,//列车等级
@property (nonatomic,strong)NSString *SDate;//日期//出发日期
@property (nonatomic,strong)NSString *selectSeat;//选中的坐席
@property (nonatomic,strong)NSString *selectSeatCode;//选中的code
@property (nonatomic,strong)NSString *selectPrice;//选中的价钱
@property (nonatomic,strong)NSString *selectCount;//选中的剩余几张票
@property (nonatomic,strong)NSString *guidSearch;
@property (nonatomic,strong)NSMutableArray *projectArray;
@property (nonatomic,strong)NSMutableArray *contactArray;
@property (nonatomic,strong)NSMutableArray *passengerArray;
@property (nonatomic,strong)NSString *toStationCode;
@property (nonatomic,strong)NSString *fromStationCode;
@property (nonatomic,strong)NSString *orderNo;
/**
 * 服务费
 */
@property (nonatomic,strong)NSString *servicemoney;
- (void)configureTrainInfoWithModel:(BeTrainTicketListModel *)model;
- (void)configureTrainInfoWithOrderModel:(BeTrainOrderInfoModel *)model;
- (void)clearCache;
@end
