//
//  BeHotelPriceSelectView.m
//  sbh
//
//  Created by RobinLiu on 15/11/9.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelPriceSelectView.h"
#import "BeHotelConditionHeader.h"
#import "ColorUtility.h"
#import "BeHotelListRequestModel.h"

#define kButtonPriceTag 9999
#define kButtonStarTag 99999

@interface BeHotelPriceSelectView()<UIGestureRecognizerDelegate>
{
    UIView *priceBgView;
    NSArray *button1Array;
    NSArray *button2Array;
    HotelPriceSelectBlock privateBlock;
    NSMutableArray *priceSelectArray;
    NSMutableArray *starSelectArray;
}
@end
static BeHotelPriceSelectView *instance = nil;
@implementation BeHotelPriceSelectView
+ (BeHotelPriceSelectView *)sharedInstance
{
    if(!instance)
    {
        @synchronized(self)
        {
            if(!instance)
            {
                instance = [[self alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
            }
        }
    }
    return instance;
}
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        priceSelectArray = [[NSMutableArray alloc]init];
        starSelectArray = [[NSMutableArray alloc]init];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedCancel)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        priceBgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, kHotelPriceSelectViewHeight)];
        priceBgView.backgroundColor = [ColorUtility colorFromHex:0xf6f4f5];
        [self addSubview:priceBgView];
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 194)];
        bgView.backgroundColor = [UIColor whiteColor];
        [priceBgView addSubview:bgView];
        NSArray *titleArray = @[kPriceTitle,kStarTitle];
        button1Array = @[KUnlimitedTitle,kLessThanTwoHundred,kTwoHundredToFourHundred,kFourHundredToSixHundred,kMoreThanSixHundred];
        button2Array = @[KUnlimitedTitle,kLuxuryTitle,kTopGradeTitle,kComfortTitle,kEconomyTitle];
        for(int i = 0;i< titleArray.count;i++)
        {
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 5 + i * 90, 100, 21)];
            titleLabel.text = [titleArray objectAtIndex:i];
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.textColor = [UIColor lightGrayColor];
            [bgView addSubview:titleLabel];
            CGFloat horizontalSpace = 3.0;
            CGFloat verticalSpace = 6.0f;
            CGFloat startx = 13.0;
            CGFloat buttonHeight = 25.0f;
            if(i == 0)
            {
                int number = 4;
                CGFloat buttonWidth = (kScreenWidth - startx * 2.0 - (number - 1.0)*horizontalSpace)/number;
                CGFloat startY = 30.0f;
                for(int j = 0;j< button1Array.count;j++)
                {
                    
                    UIButton *conditionButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    [conditionButton setTitle:[button1Array objectAtIndex:j] forState:UIControlStateNormal];
                    conditionButton.layer.borderColor = [[UIColor lightGrayColor]CGColor];
                    conditionButton.layer.borderWidth = .3;
                    conditionButton.layer.cornerRadius = 2.0f;
                    [conditionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [conditionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                    conditionButton.titleLabel.font = [UIFont systemFontOfSize:12];
                    conditionButton.tag = kButtonPriceTag +j;
                    [conditionButton addTarget:self action:@selector(priceConditionAction:) forControlEvents:UIControlEventTouchUpInside];
                    conditionButton.frame = CGRectMake(startx + (j%number)*(buttonWidth + horizontalSpace), startY + (j/number)*(buttonHeight + verticalSpace), buttonWidth, buttonHeight);
                    [bgView addSubview:conditionButton];
                }
            }
            else
            {
                int number = 3;
                CGFloat buttonWidth = (kScreenWidth - startx * 2.0 - (number - 1.0)*horizontalSpace)/number;
                CGFloat startY = 120.0f;
                for(int j = 0;j< button2Array.count;j++)
                {
                    UIButton *conditionButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    [conditionButton setTitle:[button2Array objectAtIndex:j] forState:UIControlStateNormal];
                    conditionButton.layer.borderColor = [[UIColor lightGrayColor]CGColor];
                    conditionButton.layer.borderWidth = .3;
                    conditionButton.layer.cornerRadius = 2.0f;
                    [conditionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [conditionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                    conditionButton.titleLabel.font = [UIFont systemFontOfSize:12];
                    conditionButton.frame = CGRectMake(startx + (j%number)*(buttonWidth + horizontalSpace), startY + (j/number)*(buttonHeight + verticalSpace), buttonWidth, buttonHeight);
                    conditionButton.tag = kButtonStarTag +j;
                    [conditionButton addTarget:self action:@selector(starConditionAction:) forControlEvents:UIControlEventTouchUpInside];
                    [bgView addSubview:conditionButton];
                }
            }
        }
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setBackgroundColor:[ColorConfigure loginButtonColor]];
        [confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
        confirmButton.frame = CGRectMake(13, 198, kScreenWidth - 26, 32);
        confirmButton.layer.cornerRadius = 3.0f;
        [priceBgView addSubview:confirmButton];
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
    privateBlock(priceSelectArray,starSelectArray);
    [self tappedCancel];
}
- (void)tappedCancel
{
    [UIView animateWithDuration:0.15 animations:^
     {
         self.backgroundColor = [UIColor clearColor];
         [priceBgView setFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds), self.frame.size.width, kHotelPriceSelectViewHeight)];
     }completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
}
- (void)showViewWithPriceArray:(NSArray *)priceA andStarArray:(NSArray *)starA andBlock:(HotelPriceSelectBlock)block
{
    privateBlock = block;
    [priceSelectArray removeAllObjects];
    [starSelectArray removeAllObjects];
    if(priceA != nil && priceA.count > 0)
    {
        [priceSelectArray addObjectsFromArray:priceA];
    }
    else
    {
        [priceSelectArray addObject:KUnlimitedTitle];
    }
    if(starA !=nil && starA.count> 0)
    {
        [starSelectArray addObjectsFromArray:starA];
    }
    else
    {
        [starSelectArray addObject:KUnlimitedTitle];
    }
    [self setSubviewDisplay];
    [[[UIApplication sharedApplication]keyWindow]addSubview:self];
    [UIView animateWithDuration:0.25f animations:^
     {
         [priceBgView setFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds) - kHotelPriceSelectViewHeight, self.frame.size.width, kHotelPriceSelectViewHeight)];
         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
     }completion:^(BOOL finished)
     {
         
     }];
}
- (void)setSubviewDisplay
{
    for(int i = 0;i < button1Array.count;i++)
    {
        UIButton *button = [self viewWithTag:kButtonPriceTag + i];
        button.selected = NO;
        if([button isKindOfClass:[UIButton class]])
        {
            for(NSString *member in priceSelectArray)
            {
                if([button.currentTitle isEqualToString:member])
                {
                    button.selected = YES;
                }
            }
            [self setButtonDisplayWithButton:button];
        }
    }
    for(int i = 0;i < button2Array.count;i++)
    {
        UIButton *button = [self viewWithTag:kButtonStarTag + i];
        button.selected = NO;
        if([button isKindOfClass:[UIButton class]])
        {
            for(NSString *member in starSelectArray)
            {
                if([button.currentTitle isEqualToString:member])
                {
                    button.selected = YES;
                }
            }
            [self setButtonDisplayWithButton:button];
        }
    }
}
- (void)setButtonDisplayWithButton:(UIButton *)sender
{
    if(sender.selected)
    {
        [sender setBackgroundColor:[ColorConfigure globalBgColor]];
    }
    else
    {
        [sender setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)priceConditionAction:(UIButton *)sender
{
    if(priceSelectArray.count == 1 && [priceSelectArray containsObject:sender.currentTitle])
    {
        return;
    }
    if([sender.currentTitle isEqualToString:KUnlimitedTitle])
    {
        [priceSelectArray removeAllObjects];
        [priceSelectArray addObject:KUnlimitedTitle];
    }
    else
    {
        if([priceSelectArray containsObject:KUnlimitedTitle])
        {
            [priceSelectArray removeObject:KUnlimitedTitle];
        }
        
        if ([priceSelectArray containsObject:sender.currentTitle])
        {
            [priceSelectArray removeObject:sender.currentTitle];
        }
        else
        {
            [priceSelectArray addObject:sender.currentTitle];
        }
    }
    [self setSubviewDisplay];
}
- (void)starConditionAction:(UIButton *)sender
{
    if(starSelectArray.count == 1 && [starSelectArray containsObject:sender.currentTitle])
    {
        return;
    }
    if([sender.currentTitle isEqualToString:KUnlimitedTitle])
    {
        [starSelectArray removeAllObjects];
        [starSelectArray addObject:KUnlimitedTitle];
    }
    else
    {
        if([starSelectArray containsObject:KUnlimitedTitle])
        {
            [starSelectArray removeObject:KUnlimitedTitle];
        }
        if ([starSelectArray containsObject:sender.currentTitle])
        {
            [starSelectArray removeObject:sender.currentTitle];
        }
        else
        {
            [starSelectArray addObject:sender.currentTitle];
        }
    }
    [self setSubviewDisplay];
}
@end
