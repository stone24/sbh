//
//  BeOrderWriteInsuranceCell.h
//  sbh
//
//  Created by RobinLiu on 15/10/23.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeOrderWriteModel.h"

@interface BeOrderWriteInsuranceCell : UITableViewCell
@property (nonatomic,strong) UIButton *plusButton;
@property (nonatomic,strong) UIButton *reduceButton;
@property (nonatomic,strong) UIButton *nameButton;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)addTarget:(id)target WithPlusAction:(SEL)plusAction andReduceAction:(SEL)reduceAction andShowInsurance:(SEL)show1Action;
- (void)setCellWithName:(NSString *)name andCount:(int)count andPrice:(int)price andMax:(int)max andMin:(int)min andIsButtonHidden:(BOOL)hidden;
@end
