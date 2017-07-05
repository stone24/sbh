//
//  MsgEditView.h
//  sbh
//
//  Created by RobinLiu on 15/1/29.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, EditViewClickType) {
    EditViewClickDelete = 0,
    EditViewClickRead = 1,
};
@protocol MsgEditViewDelegate;

@interface MsgEditView : UIView
{
    UIButton *_leftButton;
    UIButton *_rightButton;
}

@property (nonatomic,retain)NSString *deleteTitle;
@property (nonatomic,assign)id <MsgEditViewDelegate>delegate;

@end

@protocol MsgEditViewDelegate <NSObject>

- (void)msgEditViewButtonDidClick:(EditViewClickType)type;

@end
