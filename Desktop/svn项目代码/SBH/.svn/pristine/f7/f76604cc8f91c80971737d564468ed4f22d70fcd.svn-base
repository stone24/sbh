//
//  BeTrainOrderInfoModel.m
//  sbh
//
//  Created by SBH on 15/6/17.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTrainOrderInfoModel.h"
#import "NSDictionary+Additions.h"
#import "BeOrderContactModel.h"

@implementation BeTrainOrderInfoModel

- (NSMutableArray *)pasFrameArray
{
    if (_pasFrameArray == nil) {
        _pasFrameArray = [NSMutableArray array];
    }
    return _pasFrameArray;
}

- (NSMutableArray *)conFrameArray
{
    if (_conFrameArray == nil) {
        _conFrameArray = [NSMutableArray array];
    }
    return _conFrameArray;
}
- (id)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        _dict = dict;
        _orderst = [dict stringValueForKey:@"OrderSt" defaultValue:@""];
        if([_orderst isEqualToString:@"YQX"]||[[dict stringValueForKey:@"IsCancel" defaultValue:@"N"]isEqualToString:@"Y"])
        {
            //[self.zhuangtai1 setTextColor:[UIColor lightGrayColor]];
            _orderst = @"已取消";
        }
        else if([_orderst isEqualToString:@"YDZ"]&&[[dict stringValueForKey:@"AppPayCode" defaultValue:@"0"]isEqualToString:@"1"])
        {
            //[self.zhuangtai1 setTextColor:[UIColor orangeColor]];
            _orderst = @"待支付";
        }
       /* else if([_orderst isEqualToString:@"YDZ"]&&[[dict stringValueForKey:@"AppPayCode" defaultValue:@"0"]isEqualToString:@"0"])
        {
            //[self.zhuangtai1 setTextColor:[UIColor orangeColor]];
            _orderst = @"待出票";
        }
        else if([_orderst isEqualToString:@"DCP"]||[_orderst isEqualToString:@"CPZ"]||[_orderst isEqualToString:@"YDZ"])
        {
           // [self.zhuangtai1 setTextColor:[UIColor orangeColor]];
            _orderst = @"待出票";
        }*/
        else if([_orderst isEqualToString:@"YCP"])
        {
            //[self.zhuangtai1 setTextColor:SBHYellowColor];
            _orderst = @"已出票";
        }
       /* else if([_orderst isEqualToString:@"TSQ"]||[_orderst isEqualToString:@"TSL"]||[_orderst isEqualToString:@"TPZ"])
        {
           // [self.zhuangtai1 setTextColor:kBlueColor];
            _orderst = @"退票中";
        }
        else if([_orderst isEqualToString:@"YTP"])
        {
           // [self.zhuangtai1 setTextColor:[UIColor grayColor]];
            _orderst = @"已退票";
        }*/
        else if([_orderst isEqualToString:@"YTJ"])
        {
            //[self.zhuangtai1 setTextColor:kBlueColor];
            _orderst = @"已提交";
        }
        else if([_orderst isEqualToString:@"YTP"])
        {
            //[self.zhuangtai1 setTextColor:kBlueColor];
            _orderst = @"已退票";
        }
        else if ([_orderst isEqualToString:@"TPZ"]||[_orderst isEqualToString:@"TSQ"]||[_orderst isEqualToString:@"TSL"])
        {
            _orderst = @"退票中";
        }
        else
        {
            //[self.zhuangtai1 setTextColor:SBHYellowColor];
            _orderst = @"待出票";
        }
        _orderno = [dict stringValueForKey:@"OrderNo" defaultValue:@""];
        _accountreceivable = [dict stringValueForKey:@"AccountReceivable" defaultValue:@""];
        _creatdate = [NSString stringWithFormat:@"%@ %@",[[[dict stringValueForKey:@"CreatDate" defaultValue:@""] componentsSeparatedByString:@"T"] firstObject],[[[dict stringValueForKey:@"CreatDate" defaultValue:@""] componentsSeparatedByString:@"T"] lastObject]];
        _bookingman = [dict stringValueForKey:@"BookingMan" defaultValue:@""];
        _ticketpricetotal = [dict stringValueForKey:@"TicketPrice" defaultValue:@""];
        _insurancepricetotal = [dict stringValueForKey:@"InsurancePriceTotal" defaultValue:@""];
        _expensecenter = [dict stringValueForKey:@"ExpenseCenter" defaultValue:@""];
        _linkman = [dict stringValueForKey:@"LinkMan" defaultValue:@""];
        NSMutableArray *passengerArray = [NSMutableArray array];
        for(NSDictionary *member in [dict arrayValueForKey:@"Passenger"])
        {
            BeTrainPassengerModel *model = [[BeTrainPassengerModel alloc]init];
            model.psgname = [member stringValueForKey:@"PsgName" defaultValue:@""];
            model.cardname = [member stringValueForKey:@"CardName" defaultValue:@""];
            model.cardno = [member stringValueForKey:@"CardNo" defaultValue:@""];
            model.ticketno = [member stringValueForKey:@"TicketNo" defaultValue:@""];
            model.ticketclassname = [member stringValueForKey:@"TicketClassName" defaultValue:@""];
            [passengerArray addObject:model];
        }
        _psglist = [[NSArray alloc]initWithArray:passengerArray];
        
        NSMutableArray *contactArray = [NSMutableArray array];
        for(NSDictionary *member in [dict arrayValueForKey:@"Linkmans"])
        {
            NSString *contactName = [member stringValueForKey:@"ContactsName" defaultValue:@""];
            NSString *contactPhone = [member stringValueForKey:@"ContactsPhone" defaultValue:@""];
            if([contactName length]<1 &&[contactPhone length] < 1)
            {
                continue;
            }
            BeOrderContactModel *model = [[BeOrderContactModel alloc]init];
            model.pername = contactName;
            model.phone = contactPhone;
            [contactArray addObject:model];
        }
        _contactList = [[NSArray alloc]initWithArray:contactArray];

        BeTrainInfoModel *model = [[BeTrainInfoModel alloc]init];
        model.arrivaldate = [dict stringValueForKey:@"ArrivalDate" defaultValue:@""];
        model.departdate = [dict stringValueForKey:@"DepartDate" defaultValue:@""];
        model.boardpointname = [dict stringValueForKey:@"BoardPointName" defaultValue:@""];
        model.orderno = [dict stringValueForKey:@"OrderNo" defaultValue:@""];
        model.departtime = [dict stringValueForKey:@"DepartTime" defaultValue:@""];
        model.arrivatime = [dict stringValueForKey:@"ArrivaTime" defaultValue:@""];
        model.trainno = [dict stringValueForKey:@"TrainNO" defaultValue:@""];
        model.offpointname = [dict stringValueForKey:@"OffPointName" defaultValue:@""];
        model.runTime = [dict stringValueForKey:@"RunTime" defaultValue:@""];
        _traininfolist = @[model];
    }
    return self;
}
@end
