//
//  BeMapCustomAddressCell.h
//  sbh
//
//  Created by RobinLiu on 16/1/8.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeAddressModel.h"
typedef NS_ENUM(NSInteger,BeMapCustomAddressShowType)
{
    BeMapCustomAddressShowTypeHome = 0,
    BeMapCustomAddressShowTypeCompany = 1,
};
@interface BeMapCustomAddressCell : UITableViewCell
- (void)setAddressModel:(BeAddressModel *)model andType:(BeMapCustomAddressShowType)showType;
@property (nonatomic,strong)UIButton *modifyButton;
+ (CGFloat)cellHeight;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
