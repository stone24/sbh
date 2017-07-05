//
//  BeTrainFilterTableView.h
//  sbh
//
//  Created by RobinLiu on 15/6/16.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeHotelSearchContentCell.h"
#import "BeHotleSearchItemTableViewCell.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "BeTrainDefines.h"
#import "BeTrainTicketFilterConditions.h"

#define kFilterViewHeight 290

@interface BeTrainFilterTableView : UIView
@property (nonatomic,retain)BeTrainTicketFilterConditions *externalCondition;
- (void)addTarget:(id)target andCancelAction:(SEL)cancelAction andConfirmAction:(SEL)confirmAction;
@end
