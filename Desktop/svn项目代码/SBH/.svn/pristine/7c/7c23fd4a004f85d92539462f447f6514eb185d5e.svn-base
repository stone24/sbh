//
//  BeHotelOrderCell.h
//  SideBenefit
//
//  Created by SBH on 15-3-10.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeHotelOrderModel.h"

@interface BeHotelOrderListStatusCell : UITableViewCell
+ (CGFloat)cellHeight;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)BeHotelOrderModel *listModel;
@end

@interface BeHotelOrderListContentCell : UITableViewCell
+ (CGFloat)cellHeight;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)BeHotelOrderModel *listModel;
@end
@protocol HotelOrderListDelegate;
@interface BeHotelOrderCell : UITableViewCell
@property (nonatomic,weak)id<HotelOrderListDelegate>delegate;
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,strong)BeHotelOrderModel *listModel;
+ (CGFloat)cellHeight;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
@protocol HotelOrderListDelegate <NSObject>

- (void)payWithIndex:(NSIndexPath *)indexPath;
- (void)cancelWithIndex:(NSIndexPath *)indexPath;
- (void)bookWithIndex:(NSIndexPath *)indexPath;
- (void)auditWithIndex:(NSIndexPath *)indexPath;
@end