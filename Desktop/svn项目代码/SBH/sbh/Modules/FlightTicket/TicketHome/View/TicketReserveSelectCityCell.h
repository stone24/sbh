//
//  YUdingTableViewCell.h
//  SBHAPP
//
//  Created by musmile on 14-6-22.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TicketOrderInfo;

@interface TicketReserveSelectCityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *chufachengshi;
@property (weak, nonatomic) IBOutlet UIButton *beijing;
@property (weak, nonatomic) IBOutlet UILabel *daodcsName;
@property (weak, nonatomic) IBOutlet UIButton *daodachengshi;
@property (weak, nonatomic) IBOutlet UIButton *exchangeBtnClick;

@property (weak, nonatomic) IBOutlet UIButton *chuchenBtn;
@property (weak, nonatomic) IBOutlet UIButton *daodaBtn;
+ (CGFloat)cellHeight;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setCellWith:(id)item;
- (void)addTarget:(id)target andDepartureAction:(SEL)departureAction andReachAction:(SEL)reachAction andOverturnAction:(SEL)overturnAction;
@end
