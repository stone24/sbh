//
//  BeHotelSortPickView.m
//  SideBenefit
//
//  Created by RobinLiu on 15/3/11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelSortPickView.h"
#import "BeHotelSearchContentCell.h"
#import "ColorConfigure.h"
#import "BeHotelConditionHeader.h"

#define kUnselectionImage @"cell_unselect"
#define kSingleSelectionImage @"cell_single_selection"

@interface BeHotelSortPickView()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray *dataArray;
    UITableView *sortTableView;
    HotelSortSelectBlock privateBlock;
    NSString *selectCondition;
}
@end

static BeHotelSortPickView *instance = nil;
@implementation BeHotelSortPickView
+ (BeHotelSortPickView *)sharedInstance
{
    if(!instance)
    {
        @synchronized(self)
        {
            if(!instance)
            {
                instance = [[self alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
            }
        }
    }
    return instance;
}
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
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedCancel)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        sortTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, frame.size.height, frame.size.width,kHotelSortSelectViewHeight) style:UITableViewStyleGrouped];
        [self addSubview:sortTableView];
        sortTableView.delegate = self;
        sortTableView.dataSource = self;
        sortTableView.scrollEnabled = NO;
        dataArray = [[NSMutableArray alloc]initWithObjects:kPriceAscCondition,kPriceDescCondition,kStarAscCondition,kStarDescCondition, kScoreDescCondition,nil];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [sortTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"searchItemTable";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    for(UIView * subview in [cell subviews])
    {
        if([subview isKindOfClass:[UILabel class]] || [subview isKindOfClass:[UIImageView class]])
        {
            [subview removeFromSuperview];
        }
    }
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.textColor = [UIColor darkGrayColor];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.text = [dataArray objectAtIndex:indexPath.row];
    [cell addSubview:contentLabel];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 9, 6.5)];
    if([contentLabel.text isEqualToString:selectCondition])
    {
        imageView.image = [UIImage imageNamed:kSingleSelectionImage];
    }
    else
    {
        imageView.image = [UIImage imageNamed:kUnselectionImage];
    }
    imageView.centerY = 20.0f;
    imageView.x = 20.0f;
    [cell addSubview:imageView];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectCondition = [dataArray objectAtIndex:indexPath.row];
    [sortTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        privateBlock(selectCondition);
        [self tappedCancel];
    });
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

- (void)tappedCancel
{
    [UIView animateWithDuration:0.15 animations:^
     {
         self.backgroundColor = [UIColor clearColor];
         [sortTableView setFrame:CGRectMake(0,kScreenHeight, kScreenWidth, kHotelSortSelectViewHeight)];
     }completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
}
- (void)showViewWithCondition:(NSString *)condition andBlock:(HotelSortSelectBlock)block
{
    privateBlock = block;
    selectCondition = condition;
    
    [[[UIApplication sharedApplication]keyWindow]addSubview:self];
    [UIView animateWithDuration:0.25f animations:^
     {
        [sortTableView setFrame:CGRectMake(0,kScreenHeight-kHotelSortSelectViewHeight, kScreenWidth, kHotelSortSelectViewHeight)];
         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
     }completion:^(BOOL finished)
     {
         [sortTableView reloadData];
     }];
}
@end
