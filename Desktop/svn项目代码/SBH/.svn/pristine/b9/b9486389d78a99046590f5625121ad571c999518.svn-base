//
//  BeAlteRetView.m
//  sbh
//
//  Created by SBH on 15/4/21.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeAlteRetView.h"
#import "BeFlightModel.h"

@interface BeAlteRetView ()
@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, weak) UIScrollView *backView;

@end

@implementation BeAlteRetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *backView = [[UIScrollView alloc] init];
        backView.backgroundColor = [UIColor blackColor];
        [self addSubview:backView];
        backView.layer.cornerRadius = 4.0f;
        self.backView = backView;
        
        UILabel *contentView = [[UILabel alloc] init];
        contentView.textColor = [UIColor whiteColor];
        contentView.font = [UIFont systemFontOfSize:13];
        contentView.numberOfLines = 0;
        contentView.contentMode = UIViewContentModeTop;
        [backView addSubview:contentView];
        self.contentLabel = contentView;
        
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewTapG)];
        [self addGestureRecognizer:tapG];
    }
    return self;
    
    
}

- (void)coverViewTapG
{
    [self removeFromSuperview];
}

- (id)initWithTitle:(NSString *)title
{
    self = [super init];
    if(self)
    {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        self.contentLabel.text = title;
    }
    return self;
}

// 设置控件的坐标
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backView.x = 10;
    self.backView.y = 80;
    self.backView.width = SBHScreenW - 20;
    
    CGSize contentSize = [self.contentLabel.text boundingRectWithSize:CGSizeMake(self.backView.width - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    if ((contentSize.height + self.backView.y + 30) >= kBeScreenH) {
        self.backView.height = kBeScreenH - self.backView.y - 20;
    } else {
        self.backView.height = contentSize.height + 10;
    }
    self.backView.contentSize = CGSizeMake(self.backView.width, contentSize.height + 10);
    
    self.contentLabel.x = 5;
    self.contentLabel.y = 5;
    self.contentLabel.width = self.backView.width - 10;
    self.contentLabel.height = contentSize.height;
}

- (void)show
{
    [[[UIApplication sharedApplication]keyWindow] addSubview:self];
    
}


@end
