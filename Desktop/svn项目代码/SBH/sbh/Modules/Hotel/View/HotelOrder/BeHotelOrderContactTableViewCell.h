//
//  BeHotelOrderContactTableViewCell.h
//  sbh
//
//  Created by RobinLiu on 15/12/15.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeHotelOrderContactTableViewCell : UITableViewCell
@property (nonatomic,strong) UITextField *contactNameTF;
@property (nonatomic,strong) UITextField *contactTelephoneTF;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *telephoneLabel;

@property (nonatomic,strong)UIButton *selectButton;
+ (CGFloat)cellHeight;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
