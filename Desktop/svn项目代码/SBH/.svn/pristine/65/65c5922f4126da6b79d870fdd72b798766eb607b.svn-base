//
//  BePassengerDatePickerView.m
//  sbh
//
//  Created by RobinLiu on 15/11/18.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BePassengerDatePickerView.h"
#import "ColorConfigure.h"
#import "CommonMethod.h"

#define kBgViewHeight 197
@interface BePassengerDatePickerView ()<UIGestureRecognizerDelegate>
{
    DatePickerBlock privateBlock;
    UIView *bgView;
    NSDate *selectedDate;
    UIDatePicker *datePicker;
}
@end
@implementation BePassengerDatePickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (BePassengerDatePickerView *)sharedInstance
{
    static dispatch_once_t onceToken;
    static BePassengerDatePickerView *_instance;
    dispatch_once(&onceToken, ^{
        _instance = [[BePassengerDatePickerView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    });
    return _instance;
}
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, kBgViewHeight)];
        [self addSubview:bgView];
        bgView.backgroundColor = [UIColor whiteColor];
        datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, kBgViewHeight - 162, frame.size.width, 162)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.minuteInterval = 1;
        [datePicker addTarget:self action:@selector(datePickerAction:) forControlEvents:UIControlEventValueChanged];
        [bgView addSubview:datePicker];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedCancel)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        NSArray *titleArray = @[@"取消",@"确定"];
        for (int i = 0; i < titleArray.count; i++) {
            UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            titleButton.frame = CGRectMake(i*(frame.size.width - 46), 0, 46, 30);
            [bgView addSubview:titleButton];
            [titleButton setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
            [titleButton setTitleColor:[ColorConfigure globalBgColor] forState:UIControlStateNormal];
            titleButton.tag = i;
            [titleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [bgView addSubview:titleButton];
        }
    }
    return self;
}
- (void)datePickerAction:(UIDatePicker *)sender
{
    selectedDate = sender.date;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
- (void)buttonClick:(UIButton *)sender
{
    if(sender.tag == 0)
    {
        [self tappedCancel];
    }
    else
    {
        [self confirmAction];
    }
}
- (void)tappedCancel
{
    [UIView animateWithDuration:0.15 animations:^
     {
         self.backgroundColor = [UIColor clearColor];
        [bgView setFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds), self.frame.size.width, kBgViewHeight)];
     }completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
}
- (void)confirmAction
{
    privateBlock(selectedDate);
    [self tappedCancel];
}

- (void)showPickerViewWithSelectDate:(NSString *)dateString andBlock:(DatePickerBlock)block
{
    [[[UIApplication sharedApplication]keyWindow]addSubview:self];
    [UIView animateWithDuration:0.25f animations:^
     {
         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
         [bgView setFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds)-kBgViewHeight, CGRectGetWidth([UIScreen mainScreen].bounds), kBgViewHeight)];
     }completion:^(BOOL finished)
     {
         datePicker.maximumDate = [NSDate date];
         if(dateString.length > 0&& dateString!=nil)
         {
             [datePicker setDate:[CommonMethod dateFromString:dateString WithParseStr:kFormatYYYYMMDD] animated:YES];
             selectedDate = [CommonMethod dateFromString:dateString  WithParseStr:kFormatYYYYMMDD];
         }
         else
         {
             [datePicker setDate:[NSDate date] animated:YES];
             selectedDate = [NSDate date];
         }
         privateBlock = block;
     }];
}
@end
