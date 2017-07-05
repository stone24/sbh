//
//  BeTicketPriceCoverView.h
//  sbh
//
//  Created by RobinLiu on 16/3/14.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeTicketQueryResultModel.h"
#import "BeTicketDetailModel.h"
typedef void(^BeTicketPriceCoverViewBlock) (void);

@interface BeTicketPriceCoverView : UIView
+ (BeTicketPriceCoverView *)sharedInstance;
- (void)showViewWithDict:(NSDictionary *)dict andModel:(BeTicketQueryResultModel *)model andIsShowBookButton:(BOOL)isShow andBlock:(BeTicketPriceCoverViewBlock)block;
@end
