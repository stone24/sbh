//
//  BeTicketQuerySelectHeaderView.h
//  sbh
//
//  Created by RobinLiu on 15/4/20.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TicketOrderInfo.h"
#define kBeTicketQuerySelectHeaderHeight 58
@interface BeTicketQuerySelectHeaderView : UIView
@property (nonatomic,retain)TicketOrderInfo *item;
@property (nonatomic,retain)UILabel *dateLabel;
@property (nonatomic,retain)UILabel *flightNOLabel;
@property (nonatomic,retain)UILabel *flightDurationLabel;
@end
