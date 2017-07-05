//
//  BeHotelMapTableHeaderView.m
//  sbh
//
//  Created by RobinLiu on 16/3/31.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeHotelMapTableHeaderView.h"
#import "ColorUtility.h"
#import "ColorConfigure.h"
@interface BeHotelMapTableHeaderView  ()
{
    UILabel *startTipLabel;
    BOOL isShow;
}
@end
@implementation BeHotelMapTableHeaderView

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
        self.backgroundColor = [ColorUtility colorFromHex:0xe5e6ea];
        startTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        startTipLabel.textColor = [UIColor darkGrayColor];
        startTipLabel.textAlignment = NSTextAlignmentCenter;
        startTipLabel.font = [UIFont systemFontOfSize:13];
        startTipLabel.text = @"附近酒店 ∧";
        [self addSubview:startTipLabel];
        self.layer.borderWidth = .4f;
        self.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeShowStatus)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)changeShowStatus
{
    isShow = !isShow;
    if(isShow)
    {
        startTipLabel.text = @"附近酒店 ∨";
        if(self.delegate)
        {
            [self.delegate showTableView];
        }
    }
    else
    {
        startTipLabel.text = @"附近酒店 ∧";
        if(self.delegate)
        {
            [self.delegate hideTableView];
        }
    }
}

@end
