//
//  BeHomeView.m
//  sbh
//
//  Created by RobinLiu on 2017/7/4.
//  Copyright © 2017年 shenbianhui. All rights reserved.
//

#import "BeHomeFooterView.h"
#import "BeCommonUI.h"
#import "ColorUtility.h"

#define kSpace 15.0f
#define kTitleKey @"kTitleKey"
#define kContentKey @"kContentKey"
#define kImageKey @"kImageKey"

@implementation BeHomeFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (CGRect )footerViewFrameWithHeaderHeight:(CGFloat)headerHeight
{
    float height;
    if(kIs_iPhone4||kIs_iPhone5)
    {
        height = 568  - 49 - headerHeight;
    }
    else
    {
        height = kScreenHeight - 49 - headerHeight;
    }
    return CGRectMake(0, 0, kScreenWidth, height);
}
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(kSpace, kSpace, frame.size.width - kSpace * 2.0, frame.size.height - kSpace * 2.0)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        bgView.layer.shadowOpacity = 0.8f;
        bgView.layer.shadowRadius = 4.f;
        bgView.layer.shadowOffset = CGSizeMake(0,0);

        NSArray *lineFrameArray = @[NSStringFromCGRect(CGRectMake(0, bgView.height/3.0, bgView.width, 0.8)),NSStringFromCGRect(CGRectMake(0, bgView.height/3.0 * 2.0, bgView.width, 0.8)),NSStringFromCGRect(CGRectMake(bgView.width/2.0, 0, 0.8, bgView.height))];
        for(int i = 0;i < lineFrameArray.count;i++)
        {
            UIView *line = [[UIView alloc]initWithFrame:CGRectFromString(lineFrameArray[i])];
            line.backgroundColor = [ColorUtility colorWithRed:225 green:225 blue:225];
            [bgView addSubview:line];
        }
        
        NSArray *contentArray = @[@{kTitleKey:@"机票",kContentKey:@"预订航班服务",kImageKey:@"123"},@{kTitleKey:@"火车票",kContentKey:@"预订您的火车票",kImageKey:@"123"},@{kTitleKey:@"酒店",kContentKey:@"预约住宿服务",kImageKey:@"123"},@{kTitleKey:@"用车",kContentKey:@"在线约车服务",kImageKey:@"123"},@{kTitleKey:@"签证",kContentKey:@"快捷签证服务",kImageKey:@"123"},@{kTitleKey:@"会议&团建",kContentKey:@"提供会议与团建场所",kImageKey:@"123"},];
        
        NSArray *pointArray = @[NSStringFromCGPoint(CGPointMake(bgView.width/4.0, bgView.height/6.0)),NSStringFromCGPoint(CGPointMake(bgView.width/4.0 * 3.0, bgView.height/6.0)),NSStringFromCGPoint(CGPointMake(bgView.width/4.0,  bgView.height/6.0 * 3.0)),NSStringFromCGPoint(CGPointMake(bgView.width/4.0 * 3.0, bgView.height/6.0 * 3.0)),NSStringFromCGPoint(CGPointMake(bgView.width/4.0, bgView.height/6.0 * 5.0)),NSStringFromCGPoint(CGPointMake(bgView.width/4.0 * 3.0, bgView.height/6.0 * 5.0))];
        for(int i = 0;i < contentArray.count;i++)
        {
            NSDictionary *member = contentArray[i];
            CGPoint point = CGPointFromString(pointArray[i]);
            UILabel *titleLabel = [BeCommonUI labelWithFrame:CGRectMake(0, 0, bgView.width/2.0, 20) andTitle:member[kTitleKey] andFont:[UIFont systemFontOfSize:14] andColor:[UIColor darkGrayColor]];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.centerY = point.y + 15;
            [bgView addSubview:titleLabel];
            
            UILabel *contentLabel = [BeCommonUI labelWithFrame:CGRectMake(0, 0, bgView.width/2.0, 20) andTitle:member[kContentKey] andFont:[UIFont systemFontOfSize:10] andColor:[UIColor lightGrayColor]];
            contentLabel.textAlignment = NSTextAlignmentCenter;
            contentLabel.centerY = point.y + 36;
            [bgView addSubview:contentLabel];

            UIImage *image = [UIImage imageNamed:@"hoteldetail_cancelBtn_normal"];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            imageView.centerY = point.y - image.size.height/2.0 - 10;
            [bgView addSubview:imageView];

            titleLabel.centerX = contentLabel.centerX = imageView.centerX = point.x;

            UIButton *button = [BeCommonUI buttonWithFrame:CGRectMake(0, 0, bgView.width/2.0, bgView.height/3.0) andTitle:@"" andFont:[UIFont systemFontOfSize:12] andTarget:self andAction:@selector(buttonClick:)];
            button.center = point;
            button.tag = i;
            [bgView addSubview:button];
            for(UIView *subview in [self subviews])
            {
                subview.userInteractionEnabled = YES;
            }
        }
        
    }
    return self;
}
- (void)buttonClick:(UIButton *)sender
{
    if(self.delegate)
    {
        [self.delegate homeFooterViewClick:(int)sender.tag];
    }
}
@end
