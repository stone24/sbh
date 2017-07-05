//
//  BeRoomRow00Cell.h
//  SideBenefit
//
//  Created by SBH on 15-3-11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeHotelDetailSectionModel.h"

@interface BeHotelDetailPolicyView : UIView

+ (BeHotelDetailPolicyView *)sharedInstance;
- (void)showViewWithData:(BeHotelRegulationModel *)object;
@end
