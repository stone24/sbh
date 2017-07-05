//
//  BeWriteItemHeaderView.h
//  SideBenefit
//
//  Created by SBH on 15-3-12.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeWriteItemHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *HotelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomPrice;
@property (weak, nonatomic) IBOutlet UILabel *checkInDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkOutDateLabel;

@end
