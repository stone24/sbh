//
//  BeSpeFinishController.h
//  sbh
//
//  Created by SBH on 15/7/15.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeBaseTableViewController.h"
@class BeSpeCallCarPramaModel;

typedef NS_ENUM(NSInteger,SpecialCarFinishControllerType) {
    SpecialCarFinishControllerTypeCar = 0,//立即用车
    SpecialCarFinishControllerTypePickUp = 1,//接机
    SpecialCarFinishControllerTypeSeeOff = 2,//送机
};

@interface BeSpeFinishController : BeBaseTableViewController
@property (nonatomic, assign) SpecialCarFinishControllerType sourceType;
@property (nonatomic, strong) BeSpeCallCarPramaModel *callModel;
@property (nonatomic, strong) NSArray *carLevArray;
@end
