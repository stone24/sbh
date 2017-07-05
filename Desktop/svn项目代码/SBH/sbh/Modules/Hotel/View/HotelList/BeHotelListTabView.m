//
//  BeHotelListTabView.m
//  SideBenefit
//
//  Created by RobinLiu on 15/3/11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelListTabView.h"
#import "ColorUtility.h"
#define kFilterTitle @"筛选"
#define kLocationTitle @"位置区域"
#define kPriceTitle @"星级价格"
#define kSortTitle @"排序"
@interface BeHotelListTabView ()
{
    id _target;
    SEL _priceAction;
    SEL _areaAction;
    SEL _sortAction;
    SEL _filterAciton;
    UILabel *filterLabel;
    UILabel *locationLabel;
    UILabel *priceLabel;
    UILabel *sortLabel;
}
@end

@implementation BeHotelListTabView

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
        
        self.backgroundColor = [ColorUtility colorFromHex:0xf8f8f8];
        NSArray *nameLabelArray = @[kFilterTitle,kLocationTitle,kPriceTitle ,kSortTitle];
        NSArray *imageNameArray = @[@"hotellist_tab_filter",@"hotellist_tab_location",@"hotellist_tab_pricestar",@"hotellist_tab_sort"];
        for (int i = 0; i<nameLabelArray.count; i++) {
            UIImage *image = [UIImage imageNamed:imageNameArray[i]];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            imageView.size = image.size;
            CGPoint center = {frame.size.width/(nameLabelArray.count *2) + (i * frame.size.width/nameLabelArray.count),15};
            imageView.center = center;
            [self addSubview:imageView];
            UILabel *nameLabel = [[UILabel alloc]init];
            nameLabel.text = nameLabelArray[i];
            nameLabel.textColor = [ColorUtility colorWithRed:153 green:153 blue:153];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            nameLabel.frame = CGRectMake(i * frame.size.width/nameLabelArray.count, 25, frame.size.width/nameLabelArray.count, 20);
            nameLabel.font = [UIFont systemFontOfSize:13];
            [self addSubview:nameLabel];
            if(i == 0)
            {
                filterLabel = nameLabel;
            }
            else if (i == 1)
            {
                locationLabel = nameLabel;
            }
            else if (i == 2)
            {
                priceLabel = nameLabel;
            }
            else if (i == 3)
            {
                sortLabel = nameLabel;
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i* frame.size.width/(nameLabelArray.count), 0, frame.size.width/nameLabelArray.count, frame.size.height);
            button.tag = i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
        UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.3)];
        sepLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:sepLine];
    }
    return self;
}
- (void)buttonClick:(UIButton *)sender
{
    if(sender.tag == 0)
    {
        [_target performSelector:_filterAciton withObject:nil afterDelay:0];
    }
    else if(sender.tag == 1)
    {
        [_target performSelector:_areaAction withObject:nil afterDelay:0];
    }
    else if(sender.tag == 2)
    {
        [_target performSelector:_priceAction withObject:nil afterDelay:0];
    }
    else if (sender.tag == 3)
    {
        [_target performSelector:_sortAction withObject:nil afterDelay:0];
    }
}
- (void)addTarget:(id)target andAreaAction:(SEL)areaAction andPriceAction:(SEL)priceAction andSortAction:(SEL)sortAction andFilterAction:(SEL)filterAction
{
    _target = target;
    _areaAction = areaAction;
    _priceAction = priceAction;
    _sortAction = sortAction;
    _filterAciton = filterAction;
}
- (void)updateSortUIWith:(NSString *)item
{
    sortLabel.text = item;
}
- (void)updateFilterUIWith:(NSString *)item
{
    filterLabel.text = item;
}
- (void)updatePriceUIWith:(NSString *)item
{
    priceLabel.text = item;
}
- (void)updateAreaUIWith:(NSString *)item
{
    locationLabel.text = item;
}
@end
