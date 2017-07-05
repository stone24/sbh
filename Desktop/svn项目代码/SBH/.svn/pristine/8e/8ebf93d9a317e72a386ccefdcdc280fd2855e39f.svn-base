//
//  MsgListCell.h
//  sbh
//
//  Created by RobinLiu on 15/1/29.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageListModel.h"

@protocol MsgCellDelegate;
@interface MsgListCell : UITableViewCell
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,assign)BOOL isSelect;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (nonatomic,weak) id<MsgCellDelegate> delegate;
#pragma clang diagnostic pop

@property (nonatomic,assign)BOOL isShowButton;
@property (nonatomic,retain)MessageListModel *listModel;
@property (nonatomic,retain)UIButton *selectButton;

@end

@protocol MsgCellDelegate <NSObject>

- (void)cellDidSelect:(MsgListCell *)cell;
- (void)cellDidDeselect:(MsgListCell *)cell;
@end
