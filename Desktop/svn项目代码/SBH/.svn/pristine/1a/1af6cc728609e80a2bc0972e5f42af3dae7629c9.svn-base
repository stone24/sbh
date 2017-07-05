//
//  BeTicketReserveSelectTripCell.m
//  sbh
//
//  Created by RobinLiu on 15/4/14.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTicketReserveSelectTripCell.h"
#import "ColorUtility.h"
#import "TicketOrderInfo.h"
#import "ColorConfigure.h"

#define kTripCellSingleTripText @"单程"
#define kTripCellRoundTripText @"往返"
#define kTripCellSingleTripNormalImage @"dancheng"
#define kTripCellSingleTripSelectedImage @"dancheng_A"
#define kTripCellRoundTripNormalImage @"wangfan"
#define kTripCellRoundTripSelectedImage @"wangfan_A"

#define kTripCellBottomLineImage @"jpyuding_lanxian"

#define kTripCellAnimationDuration .15
#define kTripCellWidth (CGRectGetWidth([UIApplication sharedApplication].keyWindow.bounds))
#define kTripCellHeight 50.0f
#define kTripCellLineImageViewWidth 70
#define kTripCellLineImageViewHeight 2
#define kTripCellLabelSelectedColor [ColorConfigure globalBgColor]

#define kTripCellLabelNormalColor [ColorUtility colorWithRed:110 green:110 blue:110]
typedef NS_ENUM(NSInteger, TripCellLinePositionType)
{
    kTripCellLinePositionTypeLeft = 0,
    kTripCellLinePositionTypeRight = 1,
};
@interface BeTicketReserveSelectTripCell ()
{
    UIImageView *lineImageView;
    id _target;
    SEL _singleAction;
    SEL _roundAction;
    UIImageView *singleImageView;
    UIImageView *roundImageView;
    UILabel *singleLabel;
    UILabel *roundLabel;
    TripCellLinePositionType linePositionType;
}
@end
@implementation BeTicketReserveSelectTripCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"YUdingTableViewCellIdentifier";
    BeTicketReserveSelectTripCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeTicketReserveSelectTripCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];;
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    [cell setCellDisplay];
    return cell;
}
+ (CGFloat )cellHeight
{
    return kTripCellHeight;
}
- (void)addTarget:(id)thisTarget andOneWayAction:(SEL)thisSingleAction andRoundAction:(SEL)thisRoundAction
{
    _target = thisTarget;
    _singleAction = thisSingleAction;
    _roundAction = thisRoundAction;
}
- (void)setCellDisplay
{
    lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake((kTripCellWidth/2-kTripCellLineImageViewWidth)/2, kTripCellHeight-kTripCellLineImageViewHeight - 1, kTripCellLineImageViewWidth, kTripCellLineImageViewHeight)];
    lineImageView.backgroundColor = [ColorConfigure globalBgColor];
    [self.contentView addSubview:lineImageView];

    singleImageView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:kTripCellSingleTripNormalImage]];
    CGSize imageSize = [UIImage imageNamed:kTripCellSingleTripNormalImage].size;
    singleImageView.frame = CGRectMake((kTripCellWidth/2-kTripCellLineImageViewWidth)/2+8, kTripCellHeight/2-imageSize.height/2+2, imageSize.width, imageSize.height);
    [self.contentView addSubview:singleImageView];
    
    singleLabel = [[UILabel alloc]initWithFrame:CGRectMake(((kTripCellWidth/2-kTripCellLineImageViewWidth)/2+8 + imageSize.width)+ 5, kTripCellHeight/2-imageSize.height/2, 50, 17)];
    singleLabel.font = [UIFont systemFontOfSize:15];
    singleLabel.textColor = [ColorUtility colorWithRed:110 green:110 blue:110];
    singleLabel.text = kTripCellSingleTripText;
    [self.contentView addSubview:singleLabel];
    
    roundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:kTripCellRoundTripNormalImage]];
    imageSize = [UIImage imageNamed:kTripCellRoundTripNormalImage].size;
    roundImageView.frame = CGRectMake((kTripCellWidth/2-kTripCellLineImageViewWidth)/2 + kTripCellWidth/2 + 8,kTripCellHeight/2-imageSize.height/2+2, imageSize.width, imageSize.height);
    [self.contentView addSubview:roundImageView];
    
    roundLabel = [[UILabel alloc]initWithFrame:CGRectMake((kTripCellWidth/2-kTripCellLineImageViewWidth)/2+5 + imageSize.width+ 8 + kTripCellWidth/2, kTripCellHeight/2-imageSize.height/2, 50, 17)];
    roundLabel.font = [UIFont systemFontOfSize:15];
    roundLabel.textColor = [ColorUtility colorWithRed:110 green:110 blue:110];
    roundLabel.text = kTripCellRoundTripText;
    [self.contentView addSubview:roundLabel];
    
    UIButton *singleTripButton = [UIButton buttonWithType:UIButtonTypeCustom];
    singleTripButton.frame = CGRectMake(0, 0, kTripCellWidth/2, kTripCellHeight);
    [singleTripButton addTarget:self action:@selector(tripCellOneWayAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:singleTripButton];
    
    UIButton *roundTripButton = [UIButton buttonWithType:UIButtonTypeCustom];
    roundTripButton.frame = CGRectMake(kTripCellWidth/2, 0, kTripCellWidth/2, kTripCellHeight);
    [roundTripButton addTarget:self action:@selector(tripCellRoundTripAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:roundTripButton];
    
    UIImageView *bottomSepLine = [[UIImageView alloc]init];
    bottomSepLine.frame = CGRectMake(0, kTripCellHeight-1, kTripCellWidth, 1);
    bottomSepLine.backgroundColor = [ColorUtility colorWithRed:222 green:225 blue:223];
    [self.contentView addSubview:bottomSepLine];
}
- (void)setCellWithItem:(TicketOrderInfo *)item
{
    TripCellLinePositionType type;
    switch (item.ticketBookType) {
        case kOneWayTicketType :
        {
            type = kTripCellLinePositionTypeLeft;
        }
            break;
        case kRoundTripTicketType:
        {
            type = kTripCellLinePositionTypeRight;
        }
            break;
        default:
            break;
    }
    [self setLineImageViewPosition:type withAnimation:NO];
    [self setTripBackImageWith:type];
}
- (void)tripCellOneWayAction
{
    [self setLineImageViewPosition:kTripCellLinePositionTypeLeft withAnimation:YES];
    [_target performSelector:_singleAction withObject:nil afterDelay:kTripCellAnimationDuration];
}
- (void)tripCellRoundTripAction
{
    [self setLineImageViewPosition:kTripCellLinePositionTypeRight withAnimation:YES];
    [_target performSelector:_roundAction withObject:nil afterDelay:kTripCellAnimationDuration];
}
- (void)setLineImageViewPosition:(TripCellLinePositionType)positionType withAnimation:(BOOL)animation
{
    if(linePositionType == positionType)
    {
        return;
    }
    else
    {
        linePositionType = positionType;
    }
    if(animation)
    {
        [self setLineAnimationWithPosition:linePositionType];
    }
    else
    {
        if(linePositionType == kTripCellLinePositionTypeLeft)
        {
            lineImageView.x = (kTripCellWidth/2-kTripCellLineImageViewWidth)/2;
        }
        else if(linePositionType == kTripCellLinePositionTypeRight)
        {
            lineImageView.x = (kTripCellWidth/2-kTripCellLineImageViewWidth)/2 + kTripCellWidth/2;
        }
    }
}
- (void)setLineAnimationWithPosition:(TripCellLinePositionType)positionType
{
    [UIView beginAnimations:@"TransitionAnimation" context:NULL];
    [UIView setAnimationDuration:kTripCellAnimationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if(positionType == kTripCellLinePositionTypeRight)
    {
        lineImageView.x = (kTripCellWidth/2-kTripCellLineImageViewWidth)/2 + kTripCellWidth/2;
    }
    else if(positionType == kTripCellLinePositionTypeLeft)
    {
        lineImageView.x = (kTripCellWidth/2-kTripCellLineImageViewWidth)/2;
    }
    [UIView commitAnimations];
}
- (void)setTripBackImageWith:(TripCellLinePositionType)type
{
    switch (type) {
        case  kTripCellLinePositionTypeLeft:
        {
            singleImageView.image = [UIImage imageNamed:kTripCellSingleTripSelectedImage];
            roundImageView.image = [UIImage imageNamed:kTripCellRoundTripNormalImage];
            singleLabel.textColor = kTripCellLabelSelectedColor;
            roundLabel.textColor = kTripCellLabelNormalColor;
        }
            break;
        case  kTripCellLinePositionTypeRight:
        {
            singleImageView.image = [UIImage imageNamed:kTripCellSingleTripNormalImage];
            roundImageView.image = [UIImage imageNamed:kTripCellRoundTripSelectedImage];
            roundLabel.textColor = kTripCellLabelSelectedColor;
            singleLabel.textColor = kTripCellLabelNormalColor;
        }
            break;
        default:
            break;
    }
}
@end
