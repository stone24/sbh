//
//  BeHotelDetailInfoTableViewCell.h
//  sbh
//
//  Created by RobinLiu on 15/12/10.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeHotelDetailInfoFrame.h"

@interface BeHotelDetailInfoTableViewCell : UITableViewCell
- (void)addTarget:(id)target WithMapAction:(SEL)mapAction andFacilityAction:(SEL)fAction andImageAction:(SEL)iAction;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)BeHotelDetailInfoFrame *infoFrame;
- (void)updateImageUIWith:(NSInteger)num;
@end
