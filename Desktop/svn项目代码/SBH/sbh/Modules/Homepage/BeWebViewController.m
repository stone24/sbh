//
//  SBHYqsViewController.m
//  sbh
//
//  Created by SBH on 15-1-4.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeWebViewController.h"
#import "SBHUserModel.h"
#import "AppDelegate.h"

@interface BeWebViewController ()<UIWebViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic,retain)UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) NSString *urlToSave;
@end

@implementation BeWebViewController

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.indicatorView stopAnimating];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    self.webView.backgroundColor = self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.webView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"commonBackArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(leftMenuClick)];
    // Do any additional setup after loading the view from its nib.
    self.webView.delegate = self;
    self.indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.indicatorView.center = [UIApplication sharedApplication].keyWindow.center;
    self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [[UIApplication sharedApplication].keyWindow addSubview:self.indicatorView];

    if(self.webViewUrl !=nil)
    {
        if([self.webViewUrl hasPrefix:@"http://apptest.shenbianhui.cn/ystk.html"])
        {
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webViewUrl]];
            [self.webView loadRequest:request];
            self.webView.scalesPageToFit = YES;
            return;
        }
        NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@",self.webViewUrl];
        SBHUserModel *userModel = [GlobalData getSharedInstance].userModel;
        if (![urlString hasPrefix:@"http://jcfw.shenbianhui.cn/ordermanagement/RedirectTarget"]) {
 
            if(![urlString isEqualToString:@"http://jcfw.shenbianhui.cn/mailitem/index"])
            {
                [urlString appendFormat:@"?loginname=%@&entName=%@",userModel.loginname,userModel.EntName];
            }
        }
        urlString = (NSMutableString *)[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [self.webView loadRequest:request];
        
        UILongPressGestureRecognizer *gs = [[UILongPressGestureRecognizer alloc] init];
        gs.numberOfTapsRequired = 1;
        gs.minimumPressDuration = 2.0;
        gs.delegate = self;
        [self.webView addGestureRecognizer:gs];
    }
    else
    {
        SBHUserModel *userModel = [GlobalData getSharedInstance].userModel;
        NSString *urlStr = [NSString stringWithFormat:@"http://m.yqianshu.cn/home/homeindex?loginname=%@&entName=%@",userModel.loginname,userModel.EntName];
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [self.webView loadRequest:request];
    }
    
}
- (void)leftMenuClick
{
    if(self.webView.canGoBack)
    {
        [self.webView goBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.indicatorView stopAnimating];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.indicatorView stopAnimating];
    self.title = @"加载失败";
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.indicatorView startAnimating];
}
- (void)dealloc
{
    self.indicatorView = nil;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    //NSString *schemeString = [request.URL scheme];
   // NSString *schemeLower = [schemeString lowercaseString];//强制转换为小写；
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
    {
        CGPoint touchPoint = [touch locationInView:self.view];
        if([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortrait||[[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortraitUpsideDown)
        {
            NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
            NSString *urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:imgURL];
            if([urlToSave rangeOfString:@"erweima"].location!=NSNotFound)
            {
                self.urlToSave = urlToSave;
                if (urlToSave.length != 0)
                {
                    [self saveImageToPhotoLibrary];
                }
            }
        }
    }
    return YES;
}
- (void)saveImageToPhotoLibrary
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否将此图片存入相册" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL * imageURL = [NSURL URLWithString:self.urlToSave];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage * image = [UIImage imageWithData:imageData];
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
