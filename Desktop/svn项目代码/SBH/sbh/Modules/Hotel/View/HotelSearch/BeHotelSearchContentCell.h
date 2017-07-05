//
//  BeHotelSearchContentCell.h
//  SideBenefit
//
//  Created by RobinLiu on 15/3/11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeTicketQueryDataSource.h"

#define kSelectImage @"hotel_cell_indicator_select"
#define kUnselectImage @"hotel_cell_indicator_unselect"

#define kUnselectionImage @"cell_unselect"
#define kCheckBoxImage @"cell_check_box"
#define kSingleSelectionImage @"cell_single_selection"

@interface BeHotelSearchContentCell : UITableViewCell
@property (strong, nonatomic) UIImageView *markImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic,assign)BOOL canSelect;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setCellWithTicketQuery:(BeTicketQueryDataSource *)item andIndex:(NSIndexPath *)indexPath;

- (void)setSingleSelectionImage;
- (void)setUnselectionImage;
- (void)setCheckBoxImage;
@end
