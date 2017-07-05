//
//  BeOrdeSearchHeaderView.m
//  sbh
//
//  Created by RobinLiu on 16/7/7.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeOrdeSearchHeaderView.h"
#import "ColorUtility.h"
#define kTFTag 999999999
@implementation BeOrdeSearchHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [ColorUtility colorWithRed:222 green:225 blue:223];
        self.textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, frame.size.width - 20, frame.size.height - 20)];
        self.textField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"xzlxr_sousuoBg"]];
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textField.font = [UIFont systemFontOfSize:16];
        self.textField.borderStyle =  UITextBorderStyleRoundedRect;
        self.textField.returnKeyType = UIReturnKeySearch;
        self.textField.tag = kTFTag;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xzlxr_sousuoIcon"]];
        imageView.contentMode = UIViewContentModeRight;
        imageView.width = 25;
        self.textField.leftView = imageView;
        self.textField.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:self.textField];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textfieldAAAValueBegin:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = CGRectMake(kScreenWidth - 40, 8, 40, frame.size.height - 16);
        [self.cancelButton setTitleColor:[ColorUtility colorWithRed:19 green:142 blue:234] forState:UIControlStateNormal];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(headerViewCancelAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelButton];
        self.cancelButton.hidden = YES;
    }
    return self;
}
- (void)textfieldAAAValueBegin:(NSNotification *)noti
{
    [UIView animateWithDuration:0.3 animations:^{
        self.textField.width = self.frame.size.width - 30 - 20;
    } completion:^(BOOL finished) {
        self.cancelButton.hidden = NO;
    }];
}
- (void)headerViewCancelAction
{
    [UIView animateWithDuration:0.25 animations:^{
        self.textField.width = self.frame.size.width - 20;
        self.cancelButton.hidden = YES;
    }];
    [self endEditing:YES];
    if(self.delegate)
    {
        [self.delegate searchViewCancelButtonClick];
    }
}
@end

