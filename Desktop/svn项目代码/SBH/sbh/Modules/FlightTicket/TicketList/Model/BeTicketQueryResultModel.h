//
//  BeTicketQueryResultModel.h
//  sbh
//
//  Created by RobinLiu on 15/4/16.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketOrderInfo.h"

@interface BeTicketQueryResultModel : NSObject

@property (nonatomic,retain)NSString *FlightNo;
@property (nonatomic,retain)NSString *DepartureDate;
@property (nonatomic,retain)NSString *ArrivalDate;
@property (nonatomic,retain)NSString *DepartureTime;
@property (nonatomic,assign)int departureInt;
@property (nonatomic,assign)int arrivalInt;
@property (nonatomic,retain)NSString *ArrivalTime;
@property (nonatomic,retain)NSString *DepAirport;
@property (nonatomic,retain)NSString *ArrAirport;
@property (nonatomic,retain)NSString *DepAirportName;
@property (nonatomic,retain)NSString *ArrAirportName;
@property (nonatomic,retain)NSString *BoardPointAT;
@property (nonatomic,retain)NSString *OffPointAT;
@property (nonatomic,retain)NSString *FlightTime;
@property (nonatomic,retain)NSString *Aircraft;
@property (nonatomic,retain)NSString *AircraftName ;
@property (nonatomic,retain)NSString *AircraftMode ;
@property (nonatomic,retain)NSString *Carrier ;
@property (nonatomic,retain)NSString *CarrierSName ;
@property (nonatomic,retain)NSString *AirportTaxa ;
@property (nonatomic,retain)NSString *FuelsurTaxa ;
@property (nonatomic,retain)NSString *guid
;//GOW
@property (nonatomic,retain)NSString *Seat ;
@property (nonatomic,retain)NSString *hfb ;
@property (nonatomic,retain)NSString *minprice ;//POW
@property (nonatomic,retain)NSArray *POW;
@property (nonatomic,assign)NSInteger ticketPrice;
@property (nonatomic,retain)NSString *op ;
@property (nonatomic,retain)NSString *ViaPort ;//0代表直飞，1代表经停
@property (nonatomic,retain)NSString *ClassCodeType;
@property (nonatomic,assign)BOOL isSoldOut;//是否售罄
@property (nonatomic,assign)AircraftCabinType cabinType;
- (void)setModelWith:(NSDictionary *)dict;
@end
