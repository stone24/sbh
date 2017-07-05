//
//  BeSpecialSubController.h
//  sbh
//
//  Created by SBH on 15/7/9.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeBaseTableViewController.h"
#import "BeSpeCarConfigure.h"

@class BeAddressModel;
@class BeSpeInfoModel;

typedef NS_ENUM(NSInteger,SpecialSubControllerType) {
    SpecialSubControllerTypeCar = 0,//立即用车
    SpecialSubControllerTypePickUp = 1,//接机
    SpecialSubControllerTypeSeeOff = 2,//送机
};

@interface BeSpecialSubController : BeBaseTableViewController
@property (nonatomic, assign) SpecialSubControllerType sourceType;
@property (nonatomic, strong) NSMutableArray *cityListArray;
@property (nonatomic, strong) NSArray *reasonTitleArray;
@property (nonatomic, strong) NSMutableArray *carLevArray;
@property (nonatomic, strong) BeSpeInfoModel *infoModel;
@property (nonatomic, strong) selectPerson *personModel;
// 从企业联系人列表，选择的乘车人信息
@property (nonatomic, strong) selectPerson *selPassengerModel;
@property (nonatomic, strong) BeAddressModel *destinationModel;
@property (nonatomic, strong) BeAddressModel *startAddressModel;

@property (nonatomic, copy) NSString *centerStr;
@property (nonatomic, copy) NSString *reasonStr;

//选中的出发城市
@property (nonatomic,strong)BeSpeCityModel *selectCityModel;

//当前定位的城市
@property (nonatomic,strong)BeSpeCityModel *currentLocationCity;

//手机时间是否相等
@property (nonatomic,assign)BOOL isCorrectDate;

//当前时间
@property (nonatomic,strong)NSDate *currentDate;

//接机的航班
@property (nonatomic,strong)BeSpeCarFlightModel *pickupFlightModel;
//接机的时间
@property (nonatomic,strong)BeSpeInfoModel *pickupDateModel;
//接机的机场
@property (nonatomic,strong)BeSpeCarAirportModel *pickupAirportModel;
//接机的目的地
@property (nonatomic,strong)BeAddressModel *pickupDestinationModel;
//接机的车型列表
@property (nonatomic, strong) NSMutableArray *pickupCarLevArray;

//送机的时间
@property (nonatomic,strong)BeSpeInfoModel *seeOffDateModel;
//送机的目的机场
@property (nonatomic,strong)BeSpeCarAirportModel *seeOffAirportModel;
//送机的起始地
@property (nonatomic,strong)BeAddressModel *seeOffStartAddressModel;
//送机的车型列表
@property (nonatomic, strong) NSMutableArray *seeOffCarLevArray;

@end
