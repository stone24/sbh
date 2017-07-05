//
//  chaxunjipiaoTableViewCell.h
//  SBHAPP
//
//  Created by musmile on 14-7-1.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeTicketQueryResultModel.h"
#import "BeFlightTicketListViewController.h"
#define kTicketReserveListHeight 75

@interface BeTicketQueryTableViewCell : UITableViewCell
// 判断是否是改签
@property (nonatomic,assign) QueryControllerSourceType querySourceType;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
// 出发时间
@property (weak, nonatomic) IBOutlet UILabel *chufashijian;
// 到达时间
@property (weak, nonatomic) IBOutlet UILabel *daodashijian;
// 经停
@property (weak, nonatomic) IBOutlet UILabel *jingting;
// 航班号
@property (weak, nonatomic) IBOutlet UILabel *iNo;
@property (weak, nonatomic) IBOutlet UILabel *chufajichang;
@property (weak, nonatomic) IBOutlet UILabel *daodajichang;
@property (weak, nonatomic) IBOutlet UILabel *jiage;
@property (weak, nonatomic) IBOutlet UILabel *mark;

// 机票剩余数
@property (weak, nonatomic) IBOutlet UILabel *shengyu;
@property (weak, nonatomic) IBOutlet UILabel *yupiao;
@property (weak, nonatomic) IBOutlet UILabel *luan;
@property (weak, nonatomic) IBOutlet UIImageView *biaozhiIcon;
- (void)setCellWithItem:(BeTicketQueryResultModel *)item;
+ (CGFloat)cellHight;
@end
