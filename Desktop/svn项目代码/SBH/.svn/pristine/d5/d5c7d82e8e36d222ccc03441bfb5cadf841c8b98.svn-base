//
//  BeTrainFilterPickerView.h
//  sbh
//
//  Created by RobinLiu on 15/6/16.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeTrainTicketFilterConditions.h"
#import "BeTrainFilterTableView.h"

typedef void(^TrainFilterBlock) (BeTrainTicketFilterConditions *blockObjc);

@interface BeTrainFilterPickerView : UIView<UIGestureRecognizerDelegate>
{
    BeTrainFilterTableView *filterView;
    TrainFilterBlock _block;
}
+ (BeTrainFilterPickerView *)sharedInstance;
- (void)showPickerViewWithConditions:(BeTrainTicketFilterConditions *)condition andBlock:(TrainFilterBlock )blockObj;

@end
