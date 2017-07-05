//
//  BeMapSelectView.m
//  sbh
//
//  Created by RobinLiu on 15/7/14.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeMapSelectView.h"
@interface BeMapSelectView()
{
    UIImageView *selectImageView;
}
@end
@implementation BeMapSelectView

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
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews
{
    selectImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"spe_location_select"]];
    selectImageView.y = 10;
    selectImageView.centerX = self.width/2.0;
    [self addSubview:selectImageView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 3, 2)];
    imageView.backgroundColor = [UIColor blackColor];
    imageView.centerX = self.width/2.0;
    imageView.y = self.height - 2.3;
    [self addSubview:imageView];
}
- (void)bounceActionWithBlock:(void(^)(void))block
{
    [UIView animateWithDuration:0.45 animations:^{
        selectImageView.y = 0;
    }completion:^(BOOL finished)
     {
         selectImageView.y = 10;
         block();
     }];
}
@end
