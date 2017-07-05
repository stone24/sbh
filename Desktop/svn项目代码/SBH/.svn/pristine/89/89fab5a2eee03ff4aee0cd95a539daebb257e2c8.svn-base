//
//  BeHotelAnnotationView.m
//  sbh
//
//  Created by RobinLiu on 16/3/30.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeHotelAnnotationView.h"
#import "CustomCalloutView.h"
#import "UIImageView+WebCache.h"
#import "BeHotelAnnotation.h"

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kCalloutWidth   200.0
#define kCalloutHeight  70.0
#define kHotelListCellPlaceHolderImage @"hotellist_cell_placeHolderImage"

@interface BeHotelAnnotationView ()
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *scoreLabel;
@property (nonatomic,strong)UILabel *typeLabel;
@property (nonatomic,strong)UILabel *priceLabel;
@end

@implementation BeHotelAnnotationView

@synthesize calloutView;
- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.image = [UIImage imageNamed:@"hotelAnnotation"];
    }
    return self;
}
- (void)setAnnotation:(id<MAAnnotation>)annotation
{
    [super setAnnotation:annotation];
}
- (void)updateImageView
{
    BeHotelAnnotation *hotelAnnotation = (BeHotelAnnotation *)self.annotation;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:hotelAnnotation.hotelModel.hotelImageUrl] placeholderImage:[UIImage imageNamed:kHotelListCellPlaceHolderImage]];

    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.nameLabel.text = hotelAnnotation.hotelModel.hotelName;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%@分",hotelAnnotation.hotelModel.reviewScore];
    NSString *starString = [NSString string];
    int starRate = 0;
    if(hotelAnnotation.hotelModel.Hotel_Star.length > 0)
    {
        starRate = [hotelAnnotation.hotelModel.Hotel_Star intValue];
        switch (starRate) {
            case 7:
                starString = @"七星";
                break;
            case 6:
                starString = @"六星";
                break;
            case 5:
                starString = @"五星";
                break;
            case 4:
                starString = @"四星";
                break;
            case 3:
                starString = @"三星";
                break;
            default:
                starString = @"两星及以下";
                break;
        }
    }
    else if(hotelAnnotation.hotelModel.Hotel_SBHStar.length > 0)
    {
        starRate = [hotelAnnotation.hotelModel.Hotel_SBHStar intValue];
        switch (starRate) {
            case 7:
                starString = @"豪华";
                break;
            case 6:
                starString = @"豪华";
                break;
            case 5:
                starString = @"豪华";
                break;
            case 4:
                starString = @"高档";
                break;
            case 3:
                starString = @"舒适";
                break;
            default:
                starString = @"经济";
                break;
        }
    }
    else
    {
        starString = @"两星及以下/经济";
    }
    starString = [starString stringByAppendingString:@">"];
    self.typeLabel.text = starString;
    
    NSString *priceIcon = @"￥";
    NSString *priceString = hotelAnnotation.hotelModel.price;
    NSString *priceTitle = @"起";
    NSMutableAttributedString *priceAttrib = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",priceIcon,priceString,priceTitle]];
    [priceAttrib setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(0,[priceIcon length])];
    [priceAttrib setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange([priceIcon length],[priceTitle length] + [priceString length])];
    [priceAttrib addAttribute:NSForegroundColorAttributeName value:[ColorConfigure loginButtonColor] range:NSMakeRange(0, priceIcon.length + priceString.length)];
    [priceAttrib addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(priceIcon.length + priceString.length,priceTitle.length)];
    self.priceLabel.attributedText = priceAttrib;
    
}
#pragma mark - Handle Action

- (void)btnAction
{
    BeHotelAnnotation *hotelAnnotation = (BeHotelAnnotation *)self.annotation;
    [[NSNotificationCenter defaultCenter]postNotificationName:kHotelAnnotationNotification object:nil userInfo:@{@"index":[NSNumber numberWithInteger:hotelAnnotation.index]}];    
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            /* Construct custom callout. */
            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y+5);
            self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(1, 1, 60.5, 60.5)];
            [self.calloutView addSubview:self.imageView];

            
            
            self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, kCalloutWidth - 65, 16)];
            self.nameLabel.textColor = [UIColor whiteColor];
            self.nameLabel.font = [UIFont systemFontOfSize:15];
            [self.calloutView addSubview:self.nameLabel];
            
            self.scoreLabel  = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.x, 0, 50, 15)];
            self.scoreLabel.centerY = self.imageView.centerY;
            self.scoreLabel.textColor = [UIColor whiteColor];
            self.scoreLabel.font = [UIFont systemFontOfSize:12];
            [self.calloutView addSubview:self.scoreLabel];
            
            self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(65+ 50, 0, kCalloutWidth - 65 - 50, 15)];
            self.typeLabel.centerY = self.imageView.centerY;
            self.typeLabel.textColor = [UIColor whiteColor];
            self.typeLabel.font = [UIFont systemFontOfSize:12];
            self.typeLabel.textAlignment = NSTextAlignmentRight;
            [self.calloutView addSubview:self.typeLabel];
            
            self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.x, CGRectGetMaxY(self.scoreLabel.frame) + 5, kCalloutWidth - self.nameLabel.x, 15)];
            self.priceLabel.textColor = [UIColor whiteColor];
            self.priceLabel.font = [UIFont systemFontOfSize:12];
            [self.calloutView addSubview:self.priceLabel];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = self.calloutView.bounds;
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
            [self.calloutView addSubview:btn];
            
            [self updateImageView];
        }
        
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}
@end
