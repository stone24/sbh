//
//  SBHDingdtxHeaterCell.h
//  sbh
//
//  Created by SBH on 14-12-18.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeOrderWriteAirlistModel.h"

@interface SBHDingdtxHeaterCell : UITableViewCell
@property (strong,nonatomic)UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *goDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *comeTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *reachTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromjcLabel;
@property (weak, nonatomic) IBOutlet UILabel *tojcLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiranhunLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowTypeImage;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) BeOrderWriteAirlistModel *airListM;
@property (nonatomic, copy) void(^orderWriteAltRetRuleCell)();

@end
