//
//  BeHotelBookView.h
//  SideBenefit
//
//  Created by RobinLiu on 15/3/10.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeHotelListRequestModel.h"
#import "BeBrandModel.h"

//名称
@interface BeHotelBookCityNameCell : UITableViewCell
@property (nonatomic,strong)UILabel *cityNameLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

//入住日期
@interface BeHotelBookStayCell : UITableViewCell
@property (nonatomic,strong)BeHotelListRequestModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)addTarget:(id)target WithStartAction:(SEL)startAction andLeaveAction:(SEL)leaveAction;
@end


//关键字、商圈、行政区
@interface BeHotelBookKeywordCell : UITableViewCell
@property (nonatomic,strong)BeHotelListRequestModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)addTarget:(id)target andDeleteKeyword:(SEL)deleteAction;
@end

//价格、星级
@interface BeHotelBookPriceStarCell : UITableViewCell
@property (nonatomic,strong)BeHotelListRequestModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)addTarget:(id)target andDeletePrice:(SEL)deleteAction;
@end


//因公、因私
@interface BeHotelBookReasonCell : UITableViewCell
@property (nonatomic,strong)BeHotelListRequestModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end