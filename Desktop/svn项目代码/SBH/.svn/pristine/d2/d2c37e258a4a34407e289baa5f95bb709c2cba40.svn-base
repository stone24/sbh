//
//  MsgEditView.m
//  sbh
//
//  Created by RobinLiu on 15/1/29.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "MsgEditView.h"
#import "ColorUtility.h"
#import "ColorConfigure.h"
#import "FontConfigure.h"

@implementation MsgEditView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
        line.backgroundColor =  [ColorConfigure cellContentColor];
        [self addSubview:line];
        self.backgroundColor = [ColorUtility colorWithRed:245 green:245 blue:245];
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton addTarget:self action:@selector(allButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.frame = CGRectMake(7, 7, (frame.size.width-28)/2, frame.size.height-14);
        [_leftButton setTitleColor:[ColorConfigure cellContentColor] forState:UIControlStateNormal];
        _leftButton.backgroundColor = [UIColor whiteColor];
        _leftButton.tag = 0;
        _leftButton.titleLabel.font = [FontConfigure cellContentFont];
        CALayer * downButtonLayer = [_leftButton layer];
        [downButtonLayer setMasksToBounds:YES];
        [downButtonLayer setCornerRadius:4.0];
        [downButtonLayer setBorderWidth:1.0];
        [downButtonLayer setBorderColor:[[ColorConfigure cellContentColor] CGColor]];
        [self addSubview:_leftButton];
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton addTarget:self action:@selector(allButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.frame = CGRectMake(CGRectGetMaxX(_leftButton.frame)+14, 7, CGRectGetWidth(_leftButton.frame), CGRectGetHeight(_leftButton.frame));
        _rightButton.backgroundColor = [UIColor whiteColor];
        [_rightButton setTitleColor:[ColorConfigure cellContentColor] forState:UIControlStateNormal];
        [_rightButton setTitle:@"标为已读" forState:UIControlStateNormal];
        _rightButton.tag = 1;
        _rightButton.titleLabel.font = [FontConfigure cellContentFont];

        CALayer * rightButtonLayer = [_rightButton layer];
        [rightButtonLayer setMasksToBounds:YES];
        [rightButtonLayer setCornerRadius:4.0];
        [rightButtonLayer setBorderWidth:1.0];
        [rightButtonLayer setBorderColor:[[ColorConfigure cellContentColor] CGColor]];
        [self addSubview:_rightButton];
    }
    return self;
}
- (void)setDeleteTitle:(NSString *)deleteTitle
{
    [_leftButton setTitle:deleteTitle forState:UIControlStateNormal];
}

- (void)allButtonClick:(UIButton *)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(msgEditViewButtonDidClick:)])
    {
        if(sender.tag == 0)
        {
           [self.delegate msgEditViewButtonDidClick:EditViewClickDelete];
        }
        if(sender.tag ==1)
        {
            [self.delegate msgEditViewButtonDidClick:EditViewClickRead];
        }
        
    }
}
@end
