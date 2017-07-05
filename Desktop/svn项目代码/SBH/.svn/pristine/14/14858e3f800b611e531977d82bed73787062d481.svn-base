//
//  xuanzechengjirenViewController.h
//  SBHAPP
//
//  Created by musmile on 14-7-6.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "BaseViewController.h"
#import "selectPerson.h"

typedef NS_ENUM(NSInteger,BeChoosePersonType)
{
    BeChoosePersonTypeAirFlight = 0,
    BeChoosePersonTypeTrain = 1,
    BeChoosePersonTypeHotel= 2,
    BeChoosePersonTypeCar = 3,
};

typedef void(^SelectPassengerBlock) (NSMutableArray *selectedArray);

@interface xuanzechengjirenViewController : BaseViewController
@property (nonatomic,assign)BeChoosePersonType enType;
@property (nonatomic,copy)SelectPassengerBlock block;
@property (nonatomic,strong)NSMutableArray *selectArray;
@property (nonatomic,assign)BOOL isSpecialCompany;
@property (nonatomic,assign)int maxCount;
@end
