//
//  BeLoginTableViewCell.h
//  sbh
//
//  Created by RobinLiu on 15/7/13.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBHUserModel.h"

@protocol BeloginViewDelegate <NSObject>
@optional
- (void)doLoginEnterpriseWith:(NSDictionary *)dict;
@end
@interface BeLoginTableViewCell : UITableViewCell
@property (nonatomic,weak)id <BeloginViewDelegate> delegate;
@property (nonatomic,strong)SBHUserModel *lastestAccount;//获取上次登录的账号
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
