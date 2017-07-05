//
//  BeHotelAnnotationView.h
//  sbh
//
//  Created by RobinLiu on 16/3/30.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutView.h"
#define kHotelAnnotationNotification @"HotelAnnotationNotification"
@interface BeHotelAnnotationView : MAAnnotationView
@property (nonatomic, strong) UIView *calloutView;
@end
