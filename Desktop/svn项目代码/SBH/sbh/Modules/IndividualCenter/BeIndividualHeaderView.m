//
//  BeIndividualHeaderView.m
//  SideBenefit
//
//  Created by RobinLiu on 15/3/5.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeIndividualHeaderView.h"
#import "CommonDefine.h"

@interface BeIndividualHeaderView()
{
    UIImageView *iconImageView;
    UILabel *loginNameLabel;
    UILabel *loginDiscriptionLabel;
    UIImageView *rightIcon;
}
@end
@implementation BeIndividualHeaderView

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
        self.userInteractionEnabled = YES;
        UIImageView *backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"individual_cell_background"]];
        backImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:backImageView];
        backImageView.userInteractionEnabled = YES;
        iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"individual_cell_logo"]];
        iconImageView.frame = CGRectMake(0, 0, 70.0/320.0*kScreenWidth, 70.0/320.0*kScreenWidth);
        iconImageView.centerX = 50;
        iconImageView.centerY = frame.size.height/2.0;
        [self addSubview:iconImageView];
        iconImageView.userInteractionEnabled = YES;
        
        loginNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
        loginNameLabel.x = CGRectGetMaxX(iconImageView.frame) + 10;
        loginNameLabel.centerY = iconImageView.centerY - 10;
        loginNameLabel.font = [UIFont systemFontOfSize:17];
        loginNameLabel.textColor = [UIColor whiteColor];
        [self addSubview:loginNameLabel];
        loginNameLabel.userInteractionEnabled = YES;
        
        loginDiscriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
        loginDiscriptionLabel.x = loginNameLabel.x;
        loginDiscriptionLabel.centerY = iconImageView.centerY + 15;
        loginDiscriptionLabel.font = [UIFont systemFontOfSize:15];
        loginDiscriptionLabel.textColor = [UIColor whiteColor];
        [self addSubview:loginDiscriptionLabel];
        loginDiscriptionLabel.userInteractionEnabled = YES;

        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        detailButton.frame = CGRectMake(0, iconImageView.y, kScreenWidth, self.height - iconImageView.y);
        [detailButton addTarget:self action:@selector(doDetailAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:detailButton];
        
     /*   rightIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"individual_cell_info"]];
        rightIcon.centerY = loginNameLabel.centerY;
        rightIcon.x = kScreenWidth - 25;
        rightIcon.hidden = YES;
        [self addSubview:rightIcon];*/
    }
    return self;
}
- (void)setAccountInfo:(SBHUserModel *)accountInfo
{
    if(accountInfo.isLogin && accountInfo.isEnterpriseUser)
    {
        rightIcon.hidden = YES;

        if (accountInfo.staffname.length == 0)
        {
            loginNameLabel.text = accountInfo.DptName;
        } else
        {
            loginNameLabel.text = accountInfo.staffname;
        }
        if ([accountInfo.levelcode isEqualToString:@"1"])
        {
            double doub = [accountInfo.Balance doubleValue];
            loginNameLabel.text =[NSString stringWithFormat:@"剩余额度:%.2f",doub];
        }
        loginDiscriptionLabel.text = accountInfo.EntName;
    }
    else if (accountInfo.isLogin && accountInfo.isEnterpriseUser == NO)
    {
        rightIcon.hidden = NO;
        if((!accountInfo.staffname)||accountInfo.staffname.length <1)
        {
            loginNameLabel.text = @"尊敬的会员";
        }
        else
        {
            loginNameLabel.text = accountInfo.staffname;
        }
        loginDiscriptionLabel.text = @"您好";
    }
    else
    {
        rightIcon.hidden = YES;
        loginNameLabel.text = @"点击登录";
        loginDiscriptionLabel.text = @"登录后可查看更多信息";
    }
}
- (void)doDetailAction
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(detailButtonDidClick)])
    {
        [self.delegate detailButtonDidClick];
    }
}

@end
