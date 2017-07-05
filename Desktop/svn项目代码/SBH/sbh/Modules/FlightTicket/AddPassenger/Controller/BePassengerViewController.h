//
//  tianjiaxinchengjirenViewController.h
//  sbh
//
//  Created by musmile on 14-7-7.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "selectPerson.h"
#import "BeBaseTableViewController.h"

typedef NS_ENUM(NSInteger,AddPassengerSourceType) {
    AddPassengerSourceTypeAirTicket = 0,
    AddPassengerSourceTypeTrain = 1,
    AddPassengerSourceTypeHotel = 2,
    AddPassengerSourceTypeCar = 3,
};
typedef void(^EditPassengerBlock) (selectPerson *editModel);
@interface BePassengerViewController : BeBaseTableViewController
@property (nonatomic,assign)BOOL canEdit;
@property (nonatomic,copy)EditPassengerBlock block;
@property (nonatomic,assign)AddPassengerSourceType sourceType;
-(id)init:(selectPerson*)aSelePerson;

@end
