//
//  kuanTableViewCell.h
//  SBHAPP
//
//  Created by musmile on 14-6-27.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketReserveSelectDateCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel * iStartWeek;
@property(nonatomic,weak)IBOutlet UILabel * iStartDate;
@property(nonatomic,weak)IBOutlet UILabel * iArriveWeek;
@property(nonatomic,weak)IBOutlet UILabel * iArriveDate;
@property(nonatomic,weak)IBOutlet UIButton* iLeftButton;
@property(nonatomic,weak)IBOutlet UIButton* iRightButton;
@property (weak, nonatomic) IBOutlet UILabel *iRightLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setCellWith:(TicketOrderInfo *)item;
- (void)addTarget:(id)target andDepartureDateAction:(SEL)departureAction andReachDateAction:(SEL)reachAction;
@end
