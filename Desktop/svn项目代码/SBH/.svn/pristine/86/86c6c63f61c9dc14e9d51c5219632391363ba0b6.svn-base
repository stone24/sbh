//
//  BeTicketQueryPickerView.h
//  sbh
//
//  Created by RobinLiu on 15/4/15.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeTicketQueryListData.h"

@class BeTicketQueryDataSource;
typedef void(^TicketQueryPickerBlock) (void);
@interface BeTicketQueryPickerView : UIView

+ (BeTicketQueryPickerView *)sharedInstance;
@property (nonatomic,assign)BOOL hideTakeOff;
@property (nonatomic,assign)BOOL hideAirport;
@property (nonatomic,assign)BOOL hideCabin;
@property (nonatomic,assign)BOOL hideAirCompany;
@property (nonatomic,assign)BeTicketQueryListData *ticketQueryInfo;
- (void)showPickerViewWithBlock:(TicketQueryPickerBlock )blockObj;
- (void)addAllConditions;
@end
