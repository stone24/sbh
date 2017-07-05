//
//  BeSpeCarFinishTableViewCell.h
//  sbh
//
//  Created by RobinLiu on 2016/12/22.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorUtility.h"
#import "BeSpeCallCarPramaModel.h"
#import "BeSpeCallCarResultModel.h"

#define kPlaceLabelColor [ColorUtility colorFromHex:0x666666]
#define kBeSpeCarFinishTableViewCellTitleHeight 70.0
#define kBeSpeCarFinishTableViewCellOrderContentHeight 150.0
#define kBeSpeCarFinishTableViewCellTimerHeight 90.0

@interface BeSpeCarFinishTitleTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setTitle:(NSString *)title andContent:(NSString *)content;
@end

@interface BeSpeCarFinishTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)BeSpeCallCarPramaModel *carModel;
@end

@interface BeSpeCarFinishTimerTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setCellWithMinute:(int)minute andSecond:(int)second andCarNum:(int)carNum;
@end

@interface BeSpeCarFinishDriverTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)UIButton *phoneButton;
@property (nonatomic,strong)BeSpeCallCarResultModel *driverModel;
@end
