//
//  BeTrainTicketListModel.h
//  sbh
//
//  Created by RobinLiu on 15/6/16.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//
/*
 G/D 动车/高铁：依次优先显示 二等座 → 一等座 → 商务坐—软卧----无座
 C 城际：依次优先显示 二等座 → 一等座 → 特等座
 Z．T其他车次依次优先显示 硬卧 → 软卧 → 高级软卧 → 软座 → 硬座  → 无座
 */
#import <Foundation/Foundation.h>

@interface BeTrainSeatModel : NSObject
@property (nonatomic,assign)float seatPrice;
@property (nonatomic,strong)NSString *seatName;
@property (nonatomic,strong)NSString *seatCode;
@property (nonatomic,strong)NSString *seatCount;
@property (nonatomic,assign)BOOL canDisplay;
@end
@interface BeTrainTicketListModel : NSObject
/**
 * 进行筛选时的展示数据
 */
@property (nonatomic,retain)BeTrainSeatModel *displayModel;

/**
 * 原始的展示数据
 */
@property (nonatomic,retain)BeTrainSeatModel *originDisplayModel;

/**
 * 硬座
 */
@property (nonatomic,strong)BeTrainSeatModel *YzSeat;
/**
 * 硬卧
 */
@property (nonatomic,strong)BeTrainSeatModel *YwSeat;
/**
 * 软卧
 */
@property (nonatomic,strong)BeTrainSeatModel *RwSeat;

/**
 * 软座
 */
@property (nonatomic,strong)BeTrainSeatModel *RzSeat;
/**
 * 二等座
 */
@property (nonatomic,strong)BeTrainSeatModel *Rz2Seat;
/**
 * 一等座
 */
@property (nonatomic,strong)BeTrainSeatModel *Rz1Seat;
/**
 * 商务座
 */
@property (nonatomic,strong)BeTrainSeatModel *SwzSeat;

/**
 * 特等座
 */
@property (nonatomic,strong)BeTrainSeatModel *TdzSeat;

/**
 * 高级软卧
 */
@property (nonatomic,strong)BeTrainSeatModel *GrwSeat;

/**
 * 无座
 */
@property (nonatomic,strong)BeTrainSeatModel *WzSeat;

/**
 * 当前是否可以预订
 */
@property (nonatomic,assign)BOOL canBuyNow;

/**
 * 列车车次
 */
@property (nonatomic,retain)NSString *TrainCode;

/**
 * 出发车站
 */
@property (nonatomic,retain)NSString *StartCity;
/**
 * 出发车站三字码
 */
@property (nonatomic,retain)NSString *startStationCode;
/**
 * 到达车站
 */
@property (nonatomic,retain)NSString *EndCity;
/**
 * 到达车站三字码
 */
@property (nonatomic,retain)NSString *endStationCode;
/**
 * 座位类型参数
 */
@property (nonatomic,retain)NSString *SeatCode;

/**
 * 运行时间
 */
@property (nonatomic,retain)NSString *CostTime;
/**
 * 出发时间
 */
@property (nonatomic,retain)NSString *StartTime;
/**
 * 到达时间
 */
@property (nonatomic,retain)NSString *EndTime;
/**
 * 列车等级
 */
@property (nonatomic,retain)NSString *TrainType;

/**
 * 出发日期
 */
@property (nonatomic,retain)NSString *SDate;
/**
 * 始发站
 */
@property (nonatomic,retain)NSString *SFZ;
/**
 * 终点站
 */
@property (nonatomic,retain)NSString *ZDZ;

/**
 * 根据servertime来判断是否可以订票
 */
@property (nonatomic,retain)NSString *serverTime;
/**
 * 是否是始发
 */
@property (nonatomic,assign)BOOL isNonstop;
/**
 * 是否是G/D/C（区分高铁和普通快车）
 */
@property (nonatomic,assign)BOOL isHighSpeed;
/**
 * 进行筛选时的出发时间
 */
@property (nonatomic,assign)int startInt;
/**
 * 进行筛选时的到达时间
 */
@property (nonatomic,assign)int arriveInt;
/**
 * 判断是否所有价钱为0，如果为0，不展示
 */
@property (nonatomic,assign)BOOL isPriceZero;
/**
 * 允许预订的时间
 */
@property (nonatomic,strong)NSString *note;
/**
 * 初始化数据
 */
- (id)initWithDict:(NSDictionary *)dict;
/**
 * 根据筛选条件筛选
 */
- (BOOL)isHaveDataAfterSortedWithConditions:(NSString *)condition;
/**
 * 当坐席类型是不限时筛选
 */
- (void)sortBykUnlimitedCondition;
@end
