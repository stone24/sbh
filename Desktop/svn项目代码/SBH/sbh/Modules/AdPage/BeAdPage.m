//
//  BeAdPage.m
//  sbh
//
//  Created by RobinLiu on 16/1/8.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeAdPage.h"
#import "ColorUtility.h"
#import "UIImageView+WebCache.h"
#define SCREEN_BOUNDS ([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface BeAdPage ()
@property (nonatomic, strong) UIImageView	*bgImage;
@property (nonatomic, strong) UIImageView	*iconImage;
@property (nonatomic, strong) UIImageView	*launchimage;
@property (nonatomic, strong) UIView		*dumy;
@property (nonatomic, strong) UIButton      *skipButton;
@property (nonatomic, strong)NSDictionary * data;
@end

@implementation BeAdPage

- (void)loadLaunchImage:(NSDictionary *)imagedata {
    _data = imagedata;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _dumy = [[UIView alloc] initWithFrame:SCREEN_BOUNDS];
    _dumy.backgroundColor = [UIColor blackColor];
    
    [UIView animateWithDuration:0.1 animations:^{
        _dumy.alpha = 0;
    } completion:^(BOOL finished) {
        [_dumy removeFromSuperview];
    }];
    
   // _launchimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"adPageDemo"]];
    //_launchimage.frame = SCREEN_BOUNDS;
    _launchimage = [[UIImageView alloc] initWithFrame:SCREEN_BOUNDS];
    [window addSubview:_launchimage];
    [window addSubview:_dumy];
    [_launchimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kServerHost,[_data objectForKey:@"img"]]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        UIButton *urlButton = [UIButton buttonWithType:UIButtonTypeCustom];
        urlButton.frame = window.bounds;
        [_launchimage addSubview:urlButton];
        [urlButton addTarget:self action:@selector(openUrlWith:) forControlEvents:UIControlEventTouchUpInside];
        
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipButton.frame = CGRectMake(kScreenWidth - 80, 20, 60, 30);
        _skipButton.backgroundColor = [UIColor blackColor];
        _skipButton.alpha = 0.6;
        _skipButton.layer.cornerRadius = 4.0f;
        [_skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_skipButton setTitle:@"跳过>" forState:UIControlStateNormal];
        [_skipButton addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
        [window addSubview:_skipButton];
    }];
    for(UIView *subview in [window subviews])
    {
        subview.userInteractionEnabled = YES;
    }
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self imageDismiss];
    });
}
- (void)skipAction
{
    [self imageDismiss];
    //[self removefromWindowView];
}
- (void)openUrlWith:(UIButton *)sender
{
    [MobClick event:@"A0011"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_data objectForKey:@"url"]]];
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://mobile.emei8.com"]];
}
- (void)imageDismiss {
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _skipButton.alpha = 0.0f;
                         _launchimage.alpha = 0.0f;
                         _launchimage.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1);
                     }
                     completion:^(BOOL finished) {
                         [self removefromWindowView];

                     }];
   /* [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _launchimage.alpha = 0.0f;
                         _skipButton.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [self removefromWindowView];
                     }];*/
}
- (void)removefromWindowView
{
    [_launchimage removeFromSuperview];
    [_skipButton removeFromSuperview];
}
- (void)loadLaunchImage2:(NSString *)imageName iconName:(NSString *)icon{
    
    // 0. keyWindow
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // 1. 背景图
    _dumy = [[UIView alloc] initWithFrame:SCREEN_BOUNDS];
    _dumy.backgroundColor = [UIColor blackColor];
    
    // 2.
    _bgImage = [[UIImageView alloc] initWithFrame:SCREEN_BOUNDS];
    _bgImage.image = [UIImage imageNamed:imageName];
    _bgImage.alpha = 0.0;
    
    [UIView animateWithDuration:1.0 animations:^{
        _bgImage.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    
    // 3. icon
    _iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_coding_top"]];
    _iconImage.frame = CGRectMake((SCREEN_WIDTH - 213) * 0.5, 80, 213, 54);
    [window addSubview:_dumy];
    [window addSubview:_bgImage];
    [window addSubview:_iconImage];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissAll:JRDisApperaStyleLeft];
    });
}

- (void)imageDismiss2 {
    [self.dumy removeFromSuperview];
    [self.bgImage removeFromSuperview];
    [self.iconImage removeFromSuperview];
}

- (void)loadLaunchImage:(NSString *)imgName
               iconName:(NSString*)iconName
            appearStyle:(JRApperaStyle)style
                bgImage:(NSString *)bgName
              disappear:(JRDisApperaStyle)disappear
         descriptionStr:(NSString *)des {
    
    // 1. 背景
    if (bgName.length != 0) {
        self.bgImage = [[UIImageView alloc] initWithFrame:SCREEN_BOUNDS];
        self.bgImage.image = [UIImage imageNamed:bgName];
    }
    
    // 2. 加载图
    if (imgName.length != 0) {
        self.launchimage = [[UIImageView alloc] initWithFrame:SCREEN_BOUNDS];
        self.launchimage.image = [UIImage imageNamed:imgName];
    }
    
    // 3. icon
    if (iconName.length != 0) {
        self.iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
        self.iconImage.frame = self.iconFrame;
    }
    
    // 4. label
    if (des.length != 0) {
        self.desLabel = [[UILabel alloc] init];
        self.desLabel.textAlignment = NSTextAlignmentCenter;
        self.desLabel.frame = self.desLabelFreme;
        self.desLabel.text = des;
        [self.launchimage addSubview:_desLabel];
    }
    
    [self appera:style];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissAll:disappear];
    });
}


- (void)appera:(JRApperaStyle)style {
    
    // 0. keywindow
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (style == JRApperaStyleNone) {
        [window addSubview:_bgImage];
        [window addSubview:_launchimage];
        [window addSubview:_iconImage];
    } else if (style == JRApperaStyleOne) {
        
        [window addSubview:_bgImage];
        [window addSubview:_launchimage];
        [window addSubview:_iconImage];
        _launchimage.alpha = 0.0;
        
        [UIView animateWithDuration:1.0 animations:^{
            _launchimage.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)dismissAll:(JRDisApperaStyle)style {
    
    if (style == JRDisApperaStyleOne) {
        
        _bgImage.alpha = 0.0f;
        [UIView animateWithDuration:1.5f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _iconImage.alpha = 0.0f;
                             _launchimage.alpha = 0.0f;
                             _launchimage.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1);
                         }
                         completion:^(BOOL finished) {
                             [_bgImage removeFromSuperview];
                             [_launchimage removeFromSuperview];
                             [_iconImage removeFromSuperview];
                         }];
        
        return;
    } else if (style == JRDisApperaStyleTwo) {
        _bgImage.alpha = 0.0f;
        [UIView animateWithDuration:1.5f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _iconImage.alpha = 0.0f;
                             _launchimage.alpha = 0.0f;
                         }
                         completion:^(BOOL finished) {
                             [_bgImage removeFromSuperview];
                             [_launchimage removeFromSuperview];
                             [_iconImage removeFromSuperview];
                         }];
        return;
    } else if (style == JRDisApperaStyleLeft) {
        
        _bgImage.alpha = 0.0;
        [UIView animateWithDuration:1.0f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _iconImage.alpha = 0.0f;
                             _launchimage.alpha = 0.0f;
                             CGRect frame = _launchimage.frame;
                             frame.origin.x = -SCREEN_WIDTH;
                             _launchimage.frame = frame;
                             
                             frame = _iconImage.frame;
                             frame.origin.x = -SCREEN_WIDTH;
                             _iconImage.frame = frame;
                             
                             frame = _bgImage.frame;
                             frame.origin.x = -SCREEN_WIDTH;
                             _bgImage.frame = frame;
                             
                             frame = _desLabel.frame;
                             frame.origin.x = -SCREEN_WIDTH;
                             _desLabel.frame = frame;
                             
                             frame = _dumy.frame;
                             frame.origin.x = -SCREEN_WIDTH;
                             _dumy.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             [_bgImage removeFromSuperview];
                             [_launchimage removeFromSuperview];
                             [_iconImage removeFromSuperview];
                             [_desLabel removeFromSuperview];
                             
                             [_dumy removeFromSuperview];
                         }];
        return;
    } else if (style == JRDisApperaStyleRight) {
        
        [UIView animateWithDuration:1.0f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _iconImage.alpha = 0.0f;
                             _launchimage.alpha = 0.0f;
                             CGRect frame = _launchimage.frame;
                             frame.origin.x += SCREEN_WIDTH;
                             _launchimage.frame = frame;
                             
                             frame = _iconImage.frame;
                             frame.origin.x += SCREEN_WIDTH;
                             _iconImage.frame = frame;
                             
                             frame = _bgImage.frame;
                             frame.origin.x += SCREEN_WIDTH;
                             _bgImage.frame = frame;
                             
                             frame = _desLabel.frame;
                             frame.origin.x += SCREEN_WIDTH;
                             _desLabel.frame = frame;
                             
                             frame = _dumy.frame;
                             frame.origin.x += SCREEN_WIDTH;
                             _dumy.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             [_bgImage removeFromSuperview];
                             [_launchimage removeFromSuperview];
                             [_iconImage removeFromSuperview];
                             [_desLabel removeFromSuperview];
                             
                             [_dumy removeFromSuperview];
                         }];
        return;
    } else if (style == JRDisApperaStyleBottom) {
        
        [UIView animateWithDuration:1.0f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _iconImage.alpha = 0.0f;
                             _launchimage.alpha = 0.0f;
                             CGRect frame = _launchimage.frame;
                             frame.origin.y += SCREEN_HEIGHT;
                             _launchimage.frame = frame;
                             
                             frame = _iconImage.frame;
                             frame.origin.y += SCREEN_HEIGHT;
                             _iconImage.frame = frame;
                             
                             frame = _bgImage.frame;
                             frame.origin.y += SCREEN_HEIGHT;
                             _bgImage.frame = frame;
                             
                             frame = _desLabel.frame;
                             frame.origin.y += SCREEN_HEIGHT;
                             _desLabel.frame = frame;
                             
                             frame = _dumy.frame;
                             frame.origin.y += SCREEN_HEIGHT;
                             _dumy.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             [_bgImage removeFromSuperview];
                             [_launchimage removeFromSuperview];
                             [_iconImage removeFromSuperview];
                             [_desLabel removeFromSuperview];
                             
                             [_dumy removeFromSuperview];
                         }];
        return;
    } else if (style == JRDisApperaStyleTop) {
        
        [UIView animateWithDuration:1.0f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _iconImage.alpha = 0.0f;
                             _launchimage.alpha = 0.0f;
                             CGRect frame = _launchimage.frame;
                             frame.origin.y = -SCREEN_HEIGHT;
                             _launchimage.frame = frame;
                             
                             frame = _iconImage.frame;
                             frame.origin.y = -SCREEN_HEIGHT;
                             _iconImage.frame = frame;
                             
                             frame = _bgImage.frame;
                             frame.origin.y = -SCREEN_HEIGHT;
                             _bgImage.frame = frame;
                             
                             frame = _desLabel.frame;
                             frame.origin.y = -SCREEN_HEIGHT;
                             _desLabel.frame = frame;
                             
                             frame = _dumy.frame;
                             frame.origin.y = -SCREEN_HEIGHT;
                             _dumy.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             [_bgImage removeFromSuperview];
                             [_launchimage removeFromSuperview];
                             [_iconImage removeFromSuperview];
                             [_desLabel removeFromSuperview];
                             
                             [_dumy removeFromSuperview];
                         }];
        return;
    }
    [_desLabel removeFromSuperview];
    [_bgImage removeFromSuperview];
    [_launchimage removeFromSuperview];
    [_iconImage removeFromSuperview];
}


@end
