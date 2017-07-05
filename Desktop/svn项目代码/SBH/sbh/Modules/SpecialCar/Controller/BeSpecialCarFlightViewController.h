//
//  BeSpecialCarFlightViewController.h
//  sbh
//
//  Created by RobinLiu on 2016/12/15.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeBaseTableViewController.h"
#import "BeSpeCarFlightModel.h"

typedef NS_ENUM(NSInteger,SpecialCarFlightVCType) {
    SpecialCarFlightVCTypeFlightNumber,
    SpecialCarFlightVCTypeAirport,
};
typedef void(^SpecialCarFlightVCBlock) (id selectData);
@interface BeSpecialCarFlightViewController : BeBaseTableViewController
@property (nonatomic,assign)SpecialCarFlightVCType sourceType;
@property (nonatomic,copy)SpecialCarFlightVCBlock block;
@property (nonatomic,strong)NSString *cityName;
@property (nonatomic,strong)BeSpeCarFlightModel *selectFlight;
@end
