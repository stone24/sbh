//
//  BeHotelOrderWriteRoomCountView.m
//  sbh
//
//  Created by RobinLiu on 15/12/15.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelOrderWriteRoomCountView.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "CommonDefine.h"

@interface BeHotelOrderWriteRoomCountView()<UIGestureRecognizerDelegate, UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIView *detailView;
    BookBlock privateBlock;
    NSString *selectString;
}
@property (nonatomic,strong)UIPickerView *roomPickerView;
@end
static BeHotelOrderWriteRoomCountView *_instance = nil;
@implementation BeHotelOrderWriteRoomCountView
+ (BeHotelOrderWriteRoomCountView *)sharedInstance
{
    if(_instance == nil)
    {
        @synchronized(self)
        {
            if(!_instance)
            {
                _instance = [[self alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
            }
        }
    }
    return _instance;
}
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
        detailView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 200 )];
        detailView.backgroundColor = [UIColor whiteColor];
        [self addSubview:detailView];
        
        self.roomPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 38, kScreenWidth, 162)];
        self.roomPickerView.delegate = self;
        self.roomPickerView.dataSource = self;
        self.roomPickerView.backgroundColor = [UIColor whiteColor];
        [detailView addSubview:self.roomPickerView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedCancel)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(kScreenWidth - 60, 0, 60, 38);
        confirmButton.backgroundColor = [UIColor whiteColor];
        [confirmButton setTitleColor:[ColorConfigure globalBgColor] forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [detailView addSubview:confirmButton];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, 0, 60, 38);
        cancelButton.backgroundColor = [UIColor whiteColor];
        [cancelButton setTitleColor:[ColorConfigure globalBgColor] forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];

        [detailView addSubview:cancelButton];
        selectString = [[NSString alloc]init];
    }
    return self;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
- (void)confirmAction
{
    privateBlock(selectString);
    [self tappedCancel];
}

- (void)tappedCancel
{
    [UIView animateWithDuration:0.15 animations:^
     {
         self.backgroundColor = [UIColor clearColor];
         [detailView setFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds), self.frame.size.width, 200)];
     }completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
}
- (void)showViewWithData:(NSString *)object andBlock:(BookBlock)block
{
    privateBlock = block;
    selectString = object;
    [self.roomPickerView selectRow:[selectString intValue]-1 inComponent:0 animated:YES];
    [[[UIApplication sharedApplication]keyWindow]addSubview:self];
    [UIView animateWithDuration:0.25f animations:^
     {
         [detailView setFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds) -200, self.frame.size.width, 200)];
         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
     }completion:^(BOOL finished)
     {
         
     }];
}
#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 9;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%d间房", (int)row+1];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectString = [NSString stringWithFormat:@"%d",(int)row + 1];
}
@end
