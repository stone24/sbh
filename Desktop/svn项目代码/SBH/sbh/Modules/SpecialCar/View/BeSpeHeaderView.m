//
//  BeSpeHeaderView.m
//  sbh
//
//  Created by RobinLiu on 2016/12/12.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeSpeHeaderView.h"
#import "ColorConfigure.h"
@interface BeSpeHeaderView()
{
    UIView *bottomView;
}
@end
@implementation BeSpeHeaderView

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
        self.backgroundColor = [UIColor whiteColor];
        NSArray *titles = @[@"立即用车",@"接机",@"送机"];
        bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 1, 60, 1)];
        bottomView.backgroundColor = [ColorConfigure globalBgColor];
        [self addSubview:bottomView];
        for(int i = 0;i < titles.count;i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i + 100;
            button.frame = CGRectMake(frame.size.width/titles.count * i, 0,frame.size.width/titles.count, frame.size.height);
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [button setTitleColor:[ColorConfigure globalBgColor] forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(skipAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            if(i == 0)
            {
                bottomView.centerX = button.centerX;
            }
        }
    }
    return self;
}
- (void)skipAction:(UIButton *)sender
{
    for(UIButton *subview in [self subviews])
    {
        if(subview.tag == sender.tag && [subview isKindOfClass:[UIButton class]])
        {
            subview.selected = YES;
            [UIView animateWithDuration:0.1f animations:^
             {
                 bottomView.centerX = subview.centerX;
             }completion:nil];
        }
        else if([subview isKindOfClass:[UIButton class]])
        {
            subview.selected = NO;
        }
    }
    if(self.delegate)
    {
        [self.delegate speHeaderViewDidClickWith:sender.tag-100];
    }
}
@end
