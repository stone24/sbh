//
//  BeAlertView.m
//  sbh
//
//  Created by SBH on 15/4/23.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeAlertView.h"
#import "ColorConfigure.h"

@interface BeAlertView ()
@property (nonatomic, weak) id delegate;
@property (nonatomic, weak) UIView *backView;
@property (nonatomic, weak) UILabel *labelTitle;
@property (nonatomic, weak) UILabel *secondLabel;
@property (nonatomic, weak) UILabel *thirdLabel;
@property (nonatomic, weak) UIButton *leftBtn;
@property (nonatomic, weak) UIButton *rightBtn;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@end

@implementation BeAlertView

- (NSMutableArray *)buttonArray
{
    if (_buttonArray != nil) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        self.backView = backView;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alterView_icon"]];
        [backView addSubview:imageView];
        self.imageView = imageView;
        
        UILabel *labelTitle= [[UILabel alloc] init];
        labelTitle.textColor = [UIColor blackColor];
        labelTitle.font = kAirTicketDetailContentFont;
        [backView addSubview:labelTitle];
        labelTitle.numberOfLines = 2;
        self.labelTitle = labelTitle;
        
        UILabel *secondLabel= [[UILabel alloc] init];
        secondLabel.textColor = kBlueColor;
        secondLabel.font = kAirTicketDetailContentFont;
        [backView addSubview:secondLabel];
        self.secondLabel = secondLabel;
        
        UILabel *thirdLabel= [[UILabel alloc] init];
        thirdLabel.textColor = kBlueColor;
        thirdLabel.font = kAirTicketPriceDetailFont;
        [backView addSubview:thirdLabel];
        self.thirdLabel = thirdLabel;
        
        UIButton *leftBtn = [[UIButton alloc] init];
        [leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setTitleColor:kBlueColor forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [leftBtn setBackgroundImage:[UIImage imageNamed:@"alterView_leftBtn"] forState:UIControlStateNormal];
        CALayer *leftBtnLayer = [leftBtn layer];
        [leftBtnLayer setMasksToBounds:YES];
        [leftBtnLayer setBorderWidth:1.0];
        [leftBtnLayer setBorderColor:[[ColorConfigure lineGrayColor] CGColor]];
        [backView addSubview:leftBtn];
        self.leftBtn = leftBtn;
        
        
        UIButton *rightBtn = [[UIButton alloc] init];
        [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setTitleColor:kBlueColor forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [leftBtn setBackgroundImage:[UIImage imageNamed:@"alterView_rightBtn"] forState:UIControlStateNormal];
        CALayer *rightBtnLayer = [rightBtn layer];
        [rightBtnLayer setMasksToBounds:YES];
        [rightBtnLayer setBorderWidth:1.0];
        [rightBtnLayer setBorderColor:[[ColorConfigure lineGrayColor] CGColor]];
        [backView addSubview:rightBtn];
        self.rightBtn = rightBtn;
        
//        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewTapG)];
//        [self addGestureRecognizer:tapG];
    }
    return self;
    
}

-(id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles,...
{
    self = [super init];
    if(self)
    {
        _delegate = delegate;
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.userInteractionEnabled = YES;
        self.labelTitle.text = title;
        self.secondLabel.text = @"是否需要为您推荐酒店";
        self.thirdLabel.text = @"如需要我们将在10分钟内联系您";
        [self.leftBtn setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [self.rightBtn setTitle:otherButtonTitles forState:UIControlStateNormal];
//        _buttonArray = [[NSMutableArray alloc] init];
//        [_buttonArray addObject:cancelButtonTitle];
//        va_list args;
//        va_start(args, otherButtonTitles);
//        for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args,NSString*)) {
//            [_buttonArray addObject:str];
//        }
//        va_end(args);
//        self.alertView = [[[NSBundle mainBundle]loadNibNamed:@"XDView" owner:self options:nil]lastObject];
//        float height = [self.alertView heightOfViewValuesWithTitle:title AndContent:message AndButtonArray:_buttonArray];
//        self.alertView.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height-height)/2, 320, height);
//        self.alertView.userInteractionEnabled = YES;
//        [self addSubview:self.alertView];
//        [self makeButtonAction];
    }
    return self;
}

- (void)leftBtnAction:(UIButton *)btn
{
    
    if ([self.delegate respondsToSelector:@selector(beAlertViewClickedButtonAtIndex:)]) {
        
        [self.delegate beAlertViewClickedButtonAtIndex:0];
        [self removeFromSuperview];
    }
}

- (void)rightBtnAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(beAlertViewClickedButtonAtIndex:)]) {
        [self.delegate beAlertViewClickedButtonAtIndex:1];
        [self removeFromSuperview];
    }
}

// 设置控件的坐标
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat backViewH = 150;
    CGFloat backViewX = 10;
    CGFloat backViewY = (kBeScreenH - backViewH) * 0.5;
    CGFloat backViewW = SBHScreenW - 20;
    self.backView.frame = CGRectMake(backViewX, backViewY, backViewW, backViewH);
    
    self.imageView.x = 15;
    self.imageView.y = 20;
    
    CGFloat labelTitleX = CGRectGetMaxX(self.imageView.frame) + 10;
    CGFloat labelTitleY = self.imageView.y;
    CGFloat labelTitleW = backViewW - labelTitleX - 5;
    CGSize airportSize = [self.labelTitle.text boundingRectWithSize:CGSizeMake(labelTitleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kAirTicketDetailContentFont} context:nil].size;
    self.labelTitle.frame = CGRectMake(labelTitleX, labelTitleY, labelTitleW, airportSize.height);
    
    CGFloat secondLabelX = labelTitleX;
    CGFloat secondLabelY = CGRectGetMaxY(self.labelTitle.frame) + 6;
    CGFloat secondLabelW = labelTitleW;
    CGFloat secondLabelH = 16;
    self.secondLabel.frame = CGRectMake(secondLabelX, secondLabelY, secondLabelW, secondLabelH);
    
    CGFloat thirdLabelX = labelTitleX;
    CGFloat thirdLabelY = CGRectGetMaxY(self.secondLabel.frame) + 10;;
    CGFloat thirdLabelW = labelTitleW;
    CGFloat thirdLabelH = 13;
    self.thirdLabel.frame = CGRectMake(thirdLabelX, thirdLabelY, thirdLabelW, thirdLabelH);
    
    CGFloat leftBtnW = backViewW * 0.5;
    CGFloat leftBtnH = 35;
    CGFloat leftBtnX = 0;
    CGFloat leftBtnY = backViewH - leftBtnH;
    self.leftBtn.frame = CGRectMake(leftBtnX, leftBtnY, leftBtnW, leftBtnH);
    
    CGFloat rightBtnW = backViewW * 0.5;
    CGFloat rightBtnH = leftBtnH;
    CGFloat rightBtnX = rightBtnW;
    CGFloat rightBtnY = leftBtnY;
    self.rightBtn.frame = CGRectMake(rightBtnX, rightBtnY, rightBtnW, rightBtnH);
}


-(void)show
{
    [[[UIApplication sharedApplication]keyWindow] addSubview:self];

}
@end
