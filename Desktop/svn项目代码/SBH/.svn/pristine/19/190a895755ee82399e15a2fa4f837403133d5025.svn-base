//
//  BeTrainFilterPickerView.m
//  sbh
//
//  Created by RobinLiu on 15/6/16.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTrainFilterPickerView.h"


@implementation BeTrainFilterPickerView

+ (BeTrainFilterPickerView *)sharedInstance
{
    static BeTrainFilterPickerView *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!_instance)
        {
            _instance = [[BeTrainFilterPickerView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
        }
    });
    return _instance;
}
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        filterView = [[BeTrainFilterTableView alloc]initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, kFilterViewHeight)];
        [filterView addTarget:self andCancelAction:@selector(tappedCancel) andConfirmAction:@selector(filterConfirm:)];
        [self addSubview:filterView];
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedCancel)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)showPickerViewWithConditions:(BeTrainTicketFilterConditions *)condition andBlock:(TrainFilterBlock )blockObj
{
    _block = blockObj;
    filterView.externalCondition = condition;
    [[[UIApplication sharedApplication]keyWindow]addSubview:self];
    [UIView animateWithDuration:0.25f animations:^
     {
         [filterView setFrame:CGRectMake(0, self.frame.size.height-kFilterViewHeight, self.frame.size.width, kFilterViewHeight)];
     }completion:^(BOOL finished)
     {
     }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
    {
        return NO;
    }
    return YES;
}

- (void)tappedCancel
{
    [UIView animateWithDuration:0.25 animations:^
     {
         self.backgroundColor = [UIColor clearColor];
         [filterView setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, kFilterViewHeight)];
     }completion:^(BOOL finished)
     {
         [self removeFromSuperview];
         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
     }];
}
- (void)filterConfirm:(id)object
{
    _block(object);
    [self tappedCancel];
}
@end
