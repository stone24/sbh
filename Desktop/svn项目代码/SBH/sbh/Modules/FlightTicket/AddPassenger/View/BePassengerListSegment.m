//
//  BePassengerListSegment.m
//  sbh
//
//  Created by RobinLiu on 15/11/20.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BePassengerListSegment.h"
#import "ColorConfigure.h"

@interface BePassengerListSegment ()
{
}
@end
@implementation BePassengerListSegment

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
        self.segmentedControl = [[UISegmentedControl alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 29)];
        self.segmentedControl.centerY = kSegmentViewHeight/2.0f;
        self.segmentedControl.tintColor = [ColorConfigure globalBgColor];
        self.segmentedControl.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.segmentedControl];
    }
    return self;
}
@end
