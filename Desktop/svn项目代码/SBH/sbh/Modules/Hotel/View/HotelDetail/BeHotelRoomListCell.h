//
//  BeRoomRow03Cell.h
//  SideBenefit
//
//  Created by SBH on 15-3-11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeHotelRoomListFrame.h"

@protocol BeHotelRoomListCellDelegate;
@interface BeHotelRoomListCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)BeHotelRoomListFrame *listFrame;
@property (nonatomic,weak)id<BeHotelRoomListCellDelegate>delegate;
@property (nonatomic,strong)NSIndexPath *indexPath;
@end

@protocol BeHotelRoomListCellDelegate <NSObject>

- (void)bookWithIndexPath:(NSIndexPath *)index;
@end
