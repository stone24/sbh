//
//  BeSettingFooterView.m
//  SideBenefit
//
//  Created by RobinLiu on 15/3/6.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeSettingFooterView.h"
#import "ColorConfigure.h"

#define kFooterViewLabel @"如果您要关闭或开启推送功能，请在手机的设置“设置”-“通知中心”里面，找到修改"

@implementation BeSettingFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.footerViewLogOffButton.layer.cornerRadius = 4.0f;
    [self.footerViewLogOffButton setBackgroundColor:[ColorConfigure loginButtonColor]];
    self.footerViewLabel.text = kFooterViewLabel;
}
@end
