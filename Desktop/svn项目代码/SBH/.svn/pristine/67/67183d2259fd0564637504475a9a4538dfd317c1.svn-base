//
//  SBHResetpwController.m
//  sbh
//
//  Created by SBH on 14-12-5.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "SBHResetpwController.h"
#import "SBHHttp.h"
#import "ColorConfigure.h"
#import "ServerFactory.h"

@interface SBHResetpwController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *rePassword;
@property (weak, nonatomic) IBOutlet UITextField *ysPasswd;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)resetPasswordBtnClick;

@end

@implementation SBHResetpwController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.sureBtn.layer.cornerRadius = 4.0f;
    [self.sureBtn setBackgroundColor:[ColorConfigure loginButtonColor]];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = SBHColor(239, 239, 239);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"commonBackArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(leftMenuClick)];
    
    [self setupTextField:self.password];
    [self setupTextField:self.rePassword];
    [self setupTextField:self.ysPasswd];
}

- (void)setupTextField:(UITextField *)textField
{
    UIView *leftView = [[UIView alloc] init];
    leftView.width = 15;
    leftView.backgroundColor = [UIColor clearColor];
    
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)leftMenuClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)resetPasswordBtnClick
{
    if (self.password.text.length == 0 || self.rePassword.text.length == 0 || self.ysPasswd.text.length == 0) {
        [MBProgressHUD showError:@"密码不能为空"];
    } else if (![self.password.text isEqualToString:self.rePassword.text]) {
        [MBProgressHUD showError:@"密码输入不一致"];
    } else if (![[GlobalData getSharedInstance].userModel.password isEqualToString:self.ysPasswd.text])
    {
        [MBProgressHUD showError:@"原始密码不正确"];
    }
    else
    {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"Passport/SignUp"];
        NSMutableDictionary *para = [[NSMutableDictionary alloc]init];
        para[@"usertoken"]= [GlobalData getSharedInstance].token;
        para[@"password"]= self.password.text;
        [[ServerFactory getServerInstance:@"SBHHttp"]postPath:urlStr withParameters:para showHud:YES success:^(NSDictionary *callback)
         {
             [MBProgressHUD showSuccess:@"修改成功"];
             [self performSelector:@selector(leftMenuClick) withObject:nil afterDelay:1.0];
         }failure:^(NSError *error)
         {
             [MBProgressHUD showError:@"网络繁忙,稍候重试"];
         }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
