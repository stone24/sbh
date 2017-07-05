//
//  BeWriteContactCell.h
//  SideBenefit
//
//  Created by SBH on 15-3-12.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeHotelOrderWriteCell : UITableViewCell
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UITextField *contentTF;
@property (nonatomic, strong)UIButton *keywordDeleteButton;
@property (nonatomic, strong)UIImageView *arrowImageView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeight;
- (void)addTarget:(id)target andDeleteKeyword:(SEL)deleteAction;
@end

//选择入住人
@interface BeHotelOrderWriteChooseCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)addTarget:(id)target andChooseAction:(SEL)chooseAction;
@end