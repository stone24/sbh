//
//  BeLoginTableViewCell.m
//  sbh
//
//  Created by RobinLiu on 15/7/13.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeLoginTableViewCell.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "BeRegularExpressionUtil.h"
#import "CommonDefine.h"

#define kEnterNamePlaceHolder @"请输入账号"
#define kEnterPasswordPlaceHolder @"请输入密码"

#define kUnableAlpha 0.5
@interface BeLoginTableViewCell()<UITextFieldDelegate>
{
    UITextField *loginNameTF;
    UITextField *passwordTF;
    UIButton *loginButton;
    NSString *enterPriseName;
    NSString *enterPrisePassword;
}

@end
@implementation BeLoginTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeLoginTableViewCellIdentifier";
    BeLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeLoginTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    [cell setCellSubViews];
    [cell initData];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)initData
{
    enterPriseName = [[NSString alloc]init];
    enterPrisePassword = [[NSString alloc]init];
}
- (void)setCellSubViews
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textfieldValueChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, kScreenWidth, 80)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    loginNameTF = [[UITextField alloc]initWithFrame:CGRectMake(20, 7, kScreenWidth-40, 30)];
    loginNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    loginNameTF.delegate = self;
    loginNameTF.placeholder = kEnterNamePlaceHolder;
    [bgView addSubview:loginNameTF];
    
    passwordTF = [[UITextField alloc]initWithFrame:CGRectMake(20, 47, kScreenWidth-40, 30)];
    passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTF.delegate = self;
    passwordTF.placeholder = kEnterPasswordPlaceHolder;
    passwordTF.secureTextEntry = YES;
    [bgView addSubview:passwordTF];
    
    for(int i = 0;i < 2;i++)
    {
        UIImageView *sepImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39.5 +40*i, kScreenWidth, 0.5)];
        sepImageView.backgroundColor = [ColorUtility colorFromHex:0xe7e7e7];
        if(i == 0)
        {
            sepImageView.x = 13;
            sepImageView.width = kScreenWidth - 26;
        }
        [bgView addSubview:sepImageView];
    }
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
    loginButton.alpha = 0.50;
    loginButton.enabled = NO;
    [loginButton setBackgroundColor:[ColorConfigure loginButtonColor]];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 4.0f;
    loginButton.frame = CGRectMake(15, bgView.y+bgView.height +70, kScreenWidth-30,44);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginButton];
}
- (void)loginButtonAction
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:loginNameTF.text forKey:@"loginname"];
    [dict setValue:passwordTF.text forKey:@"password"];
    if(self.delegate && [self.delegate respondsToSelector:@selector(doLoginEnterpriseWith:)])
    {
        [self.delegate doLoginEnterpriseWith:dict];
    }
    // 友盟统计，
    [MobClick event:@"A0002"];
}

- (void)textfieldValueChange
{
    if(loginNameTF == nil)
    {
        return;
    }
    if(passwordTF == nil)
    {
        return;
    }
    if([loginNameTF.text length]==0 || [passwordTF.text length]==0)
    {
        loginButton.enabled = NO;
        loginButton.alpha = 0.50;
    }
    else
    {
        loginButton.enabled = YES;
        loginButton.alpha = 1;
    }
}
- (void)setLastestAccount:(SBHUserModel *)lastestAccount
{
    if(lastestAccount.isEnterpriseUser && [lastestAccount.loginname length]>0)
    {
        loginNameTF.text = lastestAccount.loginname;
        passwordTF.text = lastestAccount.password;
        enterPriseName = [loginNameTF.text copy];
        enterPrisePassword = [passwordTF.text copy];
    }

#if TARGET_IPHONE_SIMULATOR
    
#else
    passwordTF.keyboardType = UIKeyboardTypeDefault;
    loginNameTF.keyboardType = UIKeyboardTypeDefault;
#endif
    passwordTF.secureTextEntry = YES;
    passwordTF.width = kScreenWidth-40;
    loginNameTF.placeholder = kEnterNamePlaceHolder;
    passwordTF.placeholder = kEnterPasswordPlaceHolder;
    if(![passwordTF.text isEqualToString:enterPrisePassword])
    {
        passwordTF.text = enterPrisePassword;
    }
    if(![loginNameTF.text isEqualToString:enterPriseName])
    {
        loginNameTF.text = enterPriseName;
    }
    [self textfieldValueChange];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newValue = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(textField == loginNameTF)
    {
        enterPriseName = [newValue copy];
    }
    else if (textField == passwordTF)
    {
        enterPrisePassword = [newValue copy];
    }
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [passwordTF resignFirstResponder];
    [loginNameTF resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
@end

