//
//  BeTicketQueryFilterView.h
//  sbh
//
//  Created by RobinLiu on 15/4/15.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeTicketQueryDataSource.h"

#define kFilterViewHeight 290

@interface BeTicketQueryFilterView : UIView
@property (nonatomic,retain)BeTicketQueryDataSource *queryData;
- (void)addTarget:(id)target andCancelAction:(SEL)cancelAction andConfirmAction:(SEL)confirmAction;
@end
