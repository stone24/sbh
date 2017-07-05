
//
//  BeTrainTicketListModel.m
//  sbh
//
//  Created by RobinLiu on 15/6/16.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTrainTicketListModel.h"
#import "NSDictionary+Additions.h"
#import "BeTrainDefines.h"

@implementation BeTrainSeatModel
- (id)init
{
    if(self = [super init])
    {
        _seatPrice = -1;
        _seatName = @"-1";
        _seatCode = @"-1";
        _seatCount = @"-1";
        _canDisplay = NO;
    }
    return self;
}

@end
@implementation BeTrainTicketListModel
- (id)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        _isPriceZero = NO;
        _note = [dict stringValueForKey:@"note" defaultValue:@""];
        //train
        if([[[dict stringValueForKey:@"can_buy_now" defaultValue:@"n"] lowercaseString]isEqualToString:@"y"])
        {
            _canBuyNow = YES;
        }
        else
        {
            _canBuyNow = NO;

        }
        _SDate = [dict stringValueForKey:@"train_date" defaultValue:@""];
        _TrainCode = [dict stringValueForKey:@"train_code" defaultValue:@""];//列车车次
        _StartCity = [dict stringValueForKey:@"from_station_name" defaultValue:@""];//出发城市
        _startStationCode = [dict stringValueForKey:@"from_station_code" defaultValue:@""];
        _SeatCode = [dict stringValueForKey:@"SeatCode" defaultValue:@""];
        _StartTime = [dict stringValueForKey:@"start_time" defaultValue:@""];//出发时间
        _EndTime = [dict stringValueForKey:@"arrive_time" defaultValue:@""];//到达时间
        _EndCity = [dict stringValueForKey:@"to_station_name" defaultValue:@""];//到达城市
        _endStationCode = [dict stringValueForKey:@"to_station_code" defaultValue:@""];

        _CostTime = [dict stringValueForKey:@"run_time" defaultValue:@""];//运行时间
        _TrainType = [dict stringValueForKey:@"train_type" defaultValue:@""];//列车等级
        
        _SFZ = [dict stringValueForKey:@"start_station_name" defaultValue:@""];// = 始发站,
        _ZDZ = [dict stringValueForKey:@"end_station_name" defaultValue:@""];// //终点站
        
        _YzSeat = [[BeTrainSeatModel alloc]init];
        _YwSeat = [[BeTrainSeatModel alloc]init];
        _RwSeat = [[BeTrainSeatModel alloc]init];
        _RzSeat = [[BeTrainSeatModel alloc]init];
        _Rz2Seat = [[BeTrainSeatModel alloc]init];
        _Rz1Seat = [[BeTrainSeatModel alloc]init];
        _SwzSeat = [[BeTrainSeatModel alloc]init];
        _TdzSeat = [[BeTrainSeatModel alloc]init];
        _GrwSeat = [[BeTrainSeatModel alloc]init];
        _WzSeat = [[BeTrainSeatModel alloc]init];
        
        for(NSDictionary *member in [dict arrayValueForKey:@"seat_list"])
        {
            NSString *seatCode = [member stringValueForKey:@"seat_code" defaultValue:@""];
            NSString *seatCount = [member stringValueForKey:@"seat_num" defaultValue:@""];
            float seatPrice = [[member stringValueForKey:@"seat_price" defaultValue:@""] floatValue];

            if([seatCode isEqualToString:kWZCode])
            {
               /* _WzSeat.seatCount = seatCount;
                _WzSeat.seatName = kWZCondition;
                _WzSeat.seatPrice = seatPrice;
                _WzSeat.seatCode = kWZCode;
                _WzSeat.canDisplay = YES;*/
            }
            else if ([seatCode isEqualToString:kHardSeatCode])
            {
                _YzSeat.seatCount = seatCount;
                _YzSeat.seatName = kHardSeatCondition;
                _YzSeat.seatPrice = seatPrice;
                _YzSeat.seatCode = kHardSeatCode;
                _YzSeat.canDisplay = YES;
            }
            else if ([seatCode isEqualToString:kRZCode])
            {
                _RzSeat.seatCount = seatCount;
                _RzSeat.seatName = kRZCondition;
                _RzSeat.seatPrice = seatPrice;
                _RzSeat.seatCode = kRZCode;
                _RzSeat.canDisplay = YES;

            }
            else if ([seatCode isEqualToString:kHardSleeperCode])
            {
                _YwSeat.seatCount = seatCount;
                _YwSeat.seatName = kHardSleeperCondition;
                _YwSeat.seatPrice = seatPrice;
                _YwSeat.seatCode = kHardSleeperCode;
                _YwSeat.canDisplay = YES;
            }
            else if ([seatCode isEqualToString:kRWCode])
            {
                _RwSeat.seatCount = seatCount;
                _RwSeat.seatName = kRWCondition;
                _RwSeat.seatPrice = seatPrice;
                _RwSeat.seatCode = kRWCode;
                _RwSeat.canDisplay = YES;
            }
            else if ([seatCode isEqualToString:kGJRWCode])
            {
                _GrwSeat.seatCount = seatCount;
                _GrwSeat.seatName = kGJRWCondition;
                _GrwSeat.seatPrice = seatPrice;
                _GrwSeat.seatCode = kGJRWCode;
                _GrwSeat.canDisplay = YES;

            }
            else if ([seatCode isEqualToString:kSWZCode])
            {
                _SwzSeat.seatCount = seatCount;
                _SwzSeat.seatName = kSWZCondition;
                _SwzSeat.seatPrice = seatPrice;
                _SwzSeat.seatCode = kSWZCode;
                _SwzSeat.canDisplay = YES;
            }
            else if ([seatCode isEqualToString:kSecondClassCode])
            {
                _Rz2Seat.seatCount = seatCount;
                _Rz2Seat.seatName = kSecondClassCondition;
                _Rz2Seat.seatPrice = seatPrice;
                _Rz2Seat.seatCode = kSecondClassCode;
                _Rz2Seat.canDisplay = YES;
            }
            else if ([seatCode isEqualToString:kHighestClassCode])
            {
                _Rz1Seat.seatCount = seatCount;
                _Rz1Seat.seatName = kHighestClassCondition;
                _Rz1Seat.seatPrice = seatPrice;
                _Rz1Seat.seatCode = kHighestClassCode;
                _Rz1Seat.canDisplay = YES;
            }
            else if ([seatCode isEqualToString:kTDZCode])
            {
                _TdzSeat.seatCount = seatCount;
                _TdzSeat.seatName = kTDZCondition;
                _TdzSeat.seatPrice = seatPrice;
                _TdzSeat.seatCode = kTDZCode;
                _TdzSeat.canDisplay = YES;
            }
        }
        [self setFilterData];
        [self setDisplayDatas];
    }
    return self;
}
- (void)setFilterData
{
    if([_SFZ isEqualToString:_StartCity])
    {
        _isNonstop = YES;
    }
    else
    {
        _isNonstop = NO;
    }
    if([_TrainCode hasPrefix:@"G"]||[_TrainCode hasPrefix:@"D"]||[_TrainCode hasPrefix:@"C"])
    {
        _isHighSpeed = YES;
    }
    else
    {
        _isHighSpeed = NO;
    }
    NSArray *startTimeArray = [_StartTime componentsSeparatedByString:@":"];
    _startInt = [[startTimeArray firstObject] intValue]*100 + [[startTimeArray objectAtIndex:1]intValue];
    NSArray *arriveTimeArray = [_EndTime componentsSeparatedByString:@":"];
    _arriveInt = [[arriveTimeArray firstObject] intValue]*100 + [[arriveTimeArray objectAtIndex:1]intValue];
}
- (void)setDisplayDatas
{
    /*
     动车组列车：一等座、二等座、部分列车有商务座
     还有部分夜间运行的动车组列车有软卧
     城际动车组列车：一等座、二等座
     高速列车：一等座、二等座、商务座
     直达特快列车：以软卧为主，部分列车挂有硬卧和硬座或高级软卧
     特快列车：硬座、硬卧、软卧、部分有高级软卧或软座
     快速列车：硬座、硬卧、软卧，很少一部分有软座
     临时旅客列车、普通列车与快速列车基本相同
     */
    _originDisplayModel = [[BeTrainSeatModel alloc]init];
    _displayModel = [[BeTrainSeatModel alloc]init];
    if([_TrainCode hasPrefix:@"G"]||[_TrainCode hasPrefix:@"D"])
    {
        //G/D 动车/高铁：依次优先显示 二等座 → 一等座 → 商务座—软卧----无座
        //G 商务座=特等座、一等座、二等座。
        if(_Rz2Seat.canDisplay && [_Rz2Seat.seatCount intValue] > 0)
        {
            _originDisplayModel.seatPrice = _Rz2Seat.seatPrice;
            _originDisplayModel.seatName = [_Rz2Seat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_Rz2Seat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_Rz2Seat.seatCode mutableCopy];
        }
        else if (_Rz1Seat.canDisplay && [_Rz1Seat.seatCount intValue] > 0)
        {
            _originDisplayModel.seatPrice = _Rz1Seat.seatPrice;
            _originDisplayModel.seatName = [_Rz1Seat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_Rz1Seat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_Rz1Seat.seatCode mutableCopy];
        }
        else if (_SwzSeat.canDisplay && [_SwzSeat.seatCount intValue] > 0)
        {
            _originDisplayModel.seatPrice = _SwzSeat.seatPrice;
            _originDisplayModel.seatName = [_SwzSeat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_SwzSeat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_SwzSeat.seatCode mutableCopy];
        }
        else if (_TdzSeat.canDisplay && [_TdzSeat.seatCount intValue]> 0)
        {
            _originDisplayModel.seatPrice = _TdzSeat.seatPrice;
            _originDisplayModel.seatName = [_TdzSeat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_TdzSeat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_TdzSeat.seatCode mutableCopy];
        }
        else if (_RwSeat.canDisplay && [_RwSeat.seatCount intValue]> 0)
        {
            _originDisplayModel.seatPrice = _RwSeat.seatPrice;
            _originDisplayModel.seatName = [_RwSeat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_RwSeat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_RwSeat.seatCode mutableCopy];
        }
        else if(_WzSeat.canDisplay && [_WzSeat.seatCount intValue] > 0)
        {
            _originDisplayModel.seatPrice = _WzSeat.seatPrice;
            _originDisplayModel.seatName = [_WzSeat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_WzSeat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_WzSeat.seatCode mutableCopy];
        }
        else if(_Rz2Seat.canDisplay)
        {
            _originDisplayModel.seatPrice = _Rz2Seat.seatPrice;
            _originDisplayModel.seatName = [_Rz2Seat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_Rz2Seat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_Rz2Seat.seatCode mutableCopy];
        }
        else if (_Rz1Seat.canDisplay)
        {
            _originDisplayModel.seatPrice = _Rz1Seat.seatPrice;
            _originDisplayModel.seatName = [_Rz1Seat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_Rz1Seat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_Rz1Seat.seatCode mutableCopy];
        }
        else if (_SwzSeat.canDisplay)
        {
            _originDisplayModel.seatPrice = _SwzSeat.seatPrice;
            _originDisplayModel.seatName = [_SwzSeat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_SwzSeat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_SwzSeat.seatCode mutableCopy];
        }
        else if (_TdzSeat.canDisplay)
        {
            _originDisplayModel.seatPrice = _TdzSeat.seatPrice;
            _originDisplayModel.seatName = [_TdzSeat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_TdzSeat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_TdzSeat.seatCode mutableCopy];
        }
        else if (_RwSeat.canDisplay)
        {
            _originDisplayModel.seatPrice = _RwSeat.seatPrice;
            _originDisplayModel.seatName = [_RwSeat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_RwSeat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_RwSeat.seatCode mutableCopy];
        }
        else if(_WzSeat.canDisplay)
        {
            _originDisplayModel.seatPrice = _WzSeat.seatPrice;
            _originDisplayModel.seatName = [_WzSeat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_WzSeat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_WzSeat.seatCode mutableCopy];
        }
        else
        {
            _isPriceZero = YES;
        }
    }
    else if ([_TrainCode hasPrefix:@"C"])
    {
        //C 城际：依次优先显示 二等座 → 一等座 → 特等座
        if(_Rz2Seat.canDisplay && [_Rz2Seat.seatCount intValue] > 0)
        {
            _originDisplayModel.seatPrice = _Rz2Seat.seatPrice;
            _originDisplayModel.seatName = [_Rz2Seat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_Rz2Seat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_Rz2Seat.seatCode mutableCopy];
        }
        else if (_Rz1Seat.canDisplay && [_Rz1Seat.seatCount intValue] > 0)
        {
            _originDisplayModel.seatPrice = _Rz1Seat.seatPrice;
            _originDisplayModel.seatName = [_Rz1Seat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_Rz1Seat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_Rz1Seat.seatCode mutableCopy];
        }
        else if (_TdzSeat.canDisplay && [_TdzSeat.seatCount intValue] > 0)
        {
            _originDisplayModel.seatPrice = _TdzSeat.seatPrice;
            _originDisplayModel.seatName = [_TdzSeat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_TdzSeat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_TdzSeat.seatCode mutableCopy];
        }
        else if (_WzSeat.canDisplay && [_WzSeat.seatCount intValue] > 0)
        {
            _originDisplayModel.seatPrice = _WzSeat.seatPrice;
            _originDisplayModel.seatName = [_WzSeat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_WzSeat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_WzSeat.seatCode mutableCopy];
        }
        else if(_Rz2Seat.canDisplay)
        {
            _originDisplayModel.seatPrice = _Rz2Seat.seatPrice;
            _originDisplayModel.seatName = [_Rz2Seat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_Rz2Seat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_Rz2Seat.seatCode mutableCopy];
        }
        else if (_Rz1Seat.canDisplay)
        {
            _originDisplayModel.seatPrice = _Rz1Seat.seatPrice;
            _originDisplayModel.seatName = [_Rz1Seat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_Rz1Seat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_Rz1Seat.seatCode mutableCopy];
        }
        else if (_TdzSeat.canDisplay)
        {
            _originDisplayModel.seatPrice = _TdzSeat.seatPrice;
            _originDisplayModel.seatName = [_TdzSeat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_TdzSeat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_TdzSeat.seatCode mutableCopy];
        }
        else if (_WzSeat.canDisplay)
        {
            _originDisplayModel.seatPrice = _WzSeat.seatPrice;
            _originDisplayModel.seatName = [_WzSeat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_WzSeat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_WzSeat.seatCode mutableCopy];
        }

        else
        {
            _isPriceZero = YES;
        }
    }
    else
    {
       // Z．T其他车次依次优先显示 硬卧 → 软卧 → 高级软卧 → 软座 → 硬座  → 无座
        if(_YwSeat.canDisplay && [_YwSeat.seatCount intValue] > 0)
        {
            _originDisplayModel.seatPrice = _YwSeat.seatPrice;
            _originDisplayModel.seatName = [_YwSeat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_YwSeat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_YwSeat.seatCode mutableCopy];
        }
        else if (_RwSeat.canDisplay  && [_RwSeat.seatCount intValue] > 0)
        {
            _originDisplayModel.seatPrice = _RwSeat.seatPrice;
            _originDisplayModel.seatName = [_RwSeat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_RwSeat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_RwSeat.seatCode mutableCopy];
        }
        else if (_GrwSeat.canDisplay && [_GrwSeat.seatCount intValue] > 0)
        {
            _originDisplayModel.seatPrice = _GrwSeat.seatPrice;
            _originDisplayModel.seatName = [_GrwSeat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_GrwSeat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_GrwSeat.seatCode mutableCopy];
        }
        else if (_RzSeat.canDisplay && [_RzSeat.seatCount intValue] > 0)
        {
            _originDisplayModel.seatPrice = _RzSeat.seatPrice;
            _originDisplayModel.seatName = [_RzSeat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_RzSeat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_RzSeat.seatCode mutableCopy];
        }
        else if (_YzSeat.canDisplay && [_YzSeat.seatCount intValue] > 0)
        {
            _originDisplayModel.seatPrice = _YzSeat.seatPrice;
            _originDisplayModel.seatName = [_YzSeat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_YzSeat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_YzSeat.seatCode mutableCopy];
        }
        else if(_WzSeat.canDisplay && [_WzSeat.seatCount intValue] > 0)
        {
            _originDisplayModel.seatPrice = _WzSeat.seatPrice;
            _originDisplayModel.seatName = [_WzSeat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_WzSeat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_WzSeat.seatCode mutableCopy];
        }
        else if(_YwSeat.canDisplay)
        {
            _originDisplayModel.seatPrice = _YwSeat.seatPrice;
            _originDisplayModel.seatName = [_YwSeat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_YwSeat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_YwSeat.seatCode mutableCopy];
        }
        else if (_RwSeat.canDisplay)
        {
            _originDisplayModel.seatPrice = _RwSeat.seatPrice;
            _originDisplayModel.seatName = [_RwSeat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_RwSeat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_RwSeat.seatCode mutableCopy];
        }
        else if (_GrwSeat.canDisplay)
        {
            _originDisplayModel.seatPrice = _GrwSeat.seatPrice;
            _originDisplayModel.seatName = [_GrwSeat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_GrwSeat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_GrwSeat.seatCode mutableCopy];
        }
        else if (_RzSeat.canDisplay)
        {
            _originDisplayModel.seatPrice = _RzSeat.seatPrice;
            _originDisplayModel.seatName = [_RzSeat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_RzSeat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_RzSeat.seatCode mutableCopy];
        }
        else if (_YzSeat.canDisplay)
        {
            _originDisplayModel.seatPrice = _YzSeat.seatPrice;
            _originDisplayModel.seatName = [_YzSeat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_YzSeat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_YzSeat.seatCode mutableCopy];
        }
        else if(_WzSeat.canDisplay)
        {
            _originDisplayModel.seatPrice = _WzSeat.seatPrice;
            _originDisplayModel.seatName = [_WzSeat.seatName mutableCopy];
            _originDisplayModel.seatCount = [_WzSeat.seatCount mutableCopy];
            _originDisplayModel.seatCode = [_WzSeat.seatCode mutableCopy];
        }else
        {
            _isPriceZero = YES;
        }
    }
    [self sortBykUnlimitedCondition];
}
- (void)sortBykUnlimitedCondition
{
    _displayModel.seatPrice = _originDisplayModel.seatPrice;
    _displayModel.seatName = [_originDisplayModel.seatName mutableCopy];
    _displayModel.seatCount = [_originDisplayModel.seatCount mutableCopy];
    _displayModel.seatCode = [_originDisplayModel.seatCode mutableCopy];
}
- (BOOL)isHaveDataAfterSortedWithConditions:(NSString *)condition
{
    if ([condition isEqualToString:kUnlimitedCondition]) {
        [self sortBykUnlimitedCondition];
        return YES;
    }
    else if([condition isEqualToString:kHighestClassCondition])
    {
        if(_isHighSpeed == NO)
        {
            return NO;
        }
        else
        {
            if(!_Rz1Seat.canDisplay)
            {
                return NO;
            }
            _displayModel.seatPrice = _Rz1Seat.seatPrice;
            _displayModel.seatName = [_Rz1Seat.seatName mutableCopy];
            _displayModel.seatCount = [_Rz1Seat.seatCount mutableCopy];
            _displayModel.seatCode = [_Rz1Seat.seatCode mutableCopy];
            return YES;
        }
    }
    else if([condition isEqualToString:kSecondClassCondition])
    {
        if(_isHighSpeed == NO)
        {
            return NO;
        }
        else
        {
            if(!_Rz2Seat.canDisplay)
            {
                return NO;
            }
            _displayModel.seatPrice = _Rz2Seat.seatPrice;
            _displayModel.seatName = [_Rz2Seat.seatName mutableCopy];
            _displayModel.seatCount = [_Rz2Seat.seatCount mutableCopy];
            _displayModel.seatCode = [_Rz2Seat.seatCode mutableCopy];
            return YES;
        }
    }
    else if([condition isEqualToString:kHardSleeperCondition])
    {
        if(_isHighSpeed == YES)
        {
            return NO;
        }
        else
        {
            if(!_YwSeat.canDisplay)
            {
                return NO;
            }
            _displayModel.seatPrice = _YwSeat.seatPrice;
            _displayModel.seatName = [_YwSeat.seatName mutableCopy];
            _displayModel.seatCount = [_YwSeat.seatCount mutableCopy];
            _displayModel.seatCode = [_YwSeat.seatCode mutableCopy];
            return YES;
        }
    }
    else if([condition isEqualToString:kHardSeatCondition])
    {
        if(_isHighSpeed == YES)
        {
            return NO;
        }
        else
        {
            if(!_YzSeat.canDisplay)
            {
                return NO;
            }
            _displayModel.seatPrice = _YzSeat.seatPrice;
            _displayModel.seatName = [_YzSeat.seatName mutableCopy];
            _displayModel.seatCount = [_YzSeat.seatCount mutableCopy];
            _displayModel.seatCode = [_YzSeat.seatCode mutableCopy];
            return YES;
        }
    }
    else if([condition isEqualToString:kRWCondition])
    {
        if(!_RwSeat.canDisplay)
        {
            return NO;
        }
        _displayModel.seatPrice = _RwSeat.seatPrice;
        _displayModel.seatName = [_RwSeat.seatName mutableCopy];
        _displayModel.seatCount = [_RwSeat.seatCount mutableCopy];
        _displayModel.seatCode = [_RwSeat.seatCode mutableCopy];
        return YES;
    }
    else if([condition isEqualToString:kGJRWCondition])
    {
        if(!_GrwSeat.canDisplay)
        {
            return NO;
        }
        _displayModel.seatPrice = _GrwSeat.seatPrice;
        _displayModel.seatName = [_GrwSeat.seatName mutableCopy];
        _displayModel.seatCount = [_GrwSeat.seatCount mutableCopy];
        _displayModel.seatCode = [_GrwSeat.seatCode mutableCopy];
        return YES;
    }
    else if([condition isEqualToString:kRZCondition])
    {
        if(!_RzSeat.canDisplay)
        {
            return NO;
        }
        _displayModel.seatPrice = _RzSeat.seatPrice;
        _displayModel.seatName = [_RzSeat.seatName mutableCopy];
        _displayModel.seatCount = [_RzSeat.seatCount mutableCopy];
        _displayModel.seatCode = [_RzSeat.seatCode mutableCopy];
        return YES;
    }
    else if([condition isEqualToString:kSWZCondition])
    {
        if(!_SwzSeat.canDisplay)
        {
            return NO;
        }
        _displayModel.seatPrice = _SwzSeat.seatPrice;
        _displayModel.seatName = [_SwzSeat.seatName mutableCopy];
        _displayModel.seatCount = [_SwzSeat.seatCount mutableCopy];
        _displayModel.seatCode = [_SwzSeat.seatCode mutableCopy];
        return YES;
    }
    else if([condition isEqualToString:kTDZCondition])
    {
        if(!_TdzSeat.canDisplay)
        {
            return NO;
        }
        _displayModel.seatPrice = _TdzSeat.seatPrice;
        _displayModel.seatName = [_TdzSeat.seatName mutableCopy];
        _displayModel.seatCount = [_TdzSeat.seatCount mutableCopy];
        _displayModel.seatCode = [_TdzSeat.seatCode mutableCopy];
        return YES;
    }
    else if([condition isEqualToString:kWZCondition])
    {
        if(!_WzSeat.canDisplay)
        {
            return NO;
        }
        _displayModel.seatPrice = _WzSeat.seatPrice;
        _displayModel.seatName = [_WzSeat.seatName mutableCopy];
        _displayModel.seatCount = [_WzSeat.seatCount mutableCopy];
        _displayModel.seatCode = [_WzSeat.seatCode mutableCopy];
        return YES;
    }
    return NO;
}

@end
