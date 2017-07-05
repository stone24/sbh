//
//  BeHotelDetailDescriptionView.h
//  sbh
//
//  Created by RobinLiu on 15/12/11.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeHotelDetailSectionModel.h"

typedef void(^BookBlock)(void);
@interface BeHotelDetailDescriptionView : UIView
+(BeHotelDetailDescriptionView *)sharedInstance;
- (void)showViewWithData:(BeHotelDetailRoomListModel *)object andCheckInDate:(NSString *)checkinDate andBlock:(BookBlock)block;
@end
