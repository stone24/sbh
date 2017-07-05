//
//  BeHotelOrderWriteCheckInView.m
//  sbh
//
//  Created by RobinLiu on 15/12/15.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelOrderWriteCheckInView.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "CommonDefine.h"

@interface BeHotelOrderWriteCheckInView()<UIGestureRecognizerDelegate, UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIView *detailView;
    CheckInBlock privateBlock;
    NSString *selectString;
}
@property (nonatomic,strong)UIPickerView *roomPickerView;
@property (nonatomic,strong)NSArray *dataArray;
@end
static BeHotelOrderWriteCheckInView *_instance = nil;
@implementation BeHotelOrderWriteCheckInView
+ (BeHotelOrderWriteCheckInView *)sharedInstance
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
        self.dataArray = @[@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00",@"24:00",];
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
- (void)showViewWithData:(NSString *)object andBlock:(CheckInBlock)block
{
    privateBlock = block;
    [[[UIApplication sharedApplication]keyWindow]addSubview:self];
    [UIView animateWithDuration:0.25f animations:^
     {
         [detailView setFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds) -200, self.frame.size.width, 200)];
         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
     }completion:^(BOOL finished)
     {
         NSUInteger index = 0;
         if([self.dataArray containsObject:object])
         {
             index = [self.dataArray indexOfObject:object];
         }
         [self.roomPickerView selectRow:index inComponent:0 animated:NO];
         [self pickerView:self.roomPickerView didSelectRow:index inComponent:0];
     }];
}
#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.dataArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectString = [self.dataArray objectAtIndex:row];
}
@end
