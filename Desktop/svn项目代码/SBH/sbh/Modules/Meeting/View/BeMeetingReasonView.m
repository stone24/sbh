//
//  BeMeetingReasonView.m
//  sbh
//
//  Created by RobinLiu on 16/6/20.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeMeetingReasonView.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "CommonDefine.h"

#import "BeHotelSearchContentCell.h"

@interface BeMeetingReasonView()<UIGestureRecognizerDelegate, UITableViewDelegate,UITableViewDataSource>
{
    UIView *detailView;
    MeetingReasonBlock privateBlock;
    UITableView *reasonTableView;
    NSMutableArray *dataArray;
    NSMutableArray *selectArray;
    BOOL isSingleSelection;
}
@end

static BeMeetingReasonView *_instance = nil;

@implementation BeMeetingReasonView
+ (BeMeetingReasonView *)sharedInstance
{
    if(_instance == nil)
    {
        @synchronized(self)
        {
            if(!_instance)
            {
                _instance = [[self alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
            }
        }
    }
    return _instance;
}
- (void)showViewWithData:(NSArray *)data andSelectString:(NSString *)reasons andIsSingle:(BOOL)isSingle andBlock:(MeetingReasonBlock)block
{
    [selectArray removeAllObjects];
    [dataArray removeAllObjects];
    [dataArray addObjectsFromArray:data];
    isSingleSelection = isSingle;
    if(reasons.length > 0)
    {
        [selectArray addObjectsFromArray:[reasons componentsSeparatedByString:@","]];
    }
    privateBlock = block;
    [[[UIApplication sharedApplication]keyWindow]addSubview:self];
    [UIView animateWithDuration:0.25f animations:^
     {
         [detailView setFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds) - 38 - dataArray.count * 44.0, self.frame.size.width, 38 + dataArray.count * 44.0)];
         [reasonTableView setFrame:CGRectMake(0, 38, kScreenWidth, detailView.height - 38)];
         [reasonTableView reloadData];
         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
     }completion:^(BOOL finished)
     {
         
     }];
}
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        isSingleSelection = NO;
        dataArray = [[NSMutableArray alloc]init];
        selectArray = [[NSMutableArray alloc]init];
        self.userInteractionEnabled = YES;
        detailView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 38 + dataArray.count * 44.0)];
        detailView.backgroundColor = [ColorUtility colorWithRed:215 green:215 blue:215];
        [self addSubview:detailView];
        
        reasonTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 38, kScreenWidth, detailView.height - 38)];
        reasonTableView.delegate = self;
        reasonTableView.dataSource = self;
        reasonTableView.backgroundColor = [UIColor whiteColor];
        [detailView addSubview:reasonTableView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedCancel)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(kScreenWidth - 60, 0, 60, 38);
        confirmButton.backgroundColor = [UIColor clearColor];
        [confirmButton setTitleColor:[ColorConfigure globalBgColor] forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [detailView addSubview:confirmButton];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, 0, 60, 38);
        cancelButton.backgroundColor = [UIColor clearColor];
        [cancelButton setTitleColor:[ColorConfigure globalBgColor] forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];
        [detailView addSubview:cancelButton];
    }
    return self;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
- (void)confirmAction
{
    NSString *temp = [selectArray componentsJoinedByString:@","];
    privateBlock(temp);
    [self tappedCancel];
}

- (void)tappedCancel
{
    [UIView animateWithDuration:0.15 animations:^
     {
         self.backgroundColor = [UIColor clearColor];
         [detailView setFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds), self.frame.size.width, 200)];
     }completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeHotelSearchContentCell *cell = [BeHotelSearchContentCell cellWithTableView:tableView];
    cell.contentLabel.text = [dataArray objectAtIndex:indexPath.row];
    cell.canSelect = NO;
    if([selectArray containsObject:[dataArray objectAtIndex:indexPath.row]])
    {
        if(isSingleSelection == NO)
        {
            [cell setCheckBoxImage];
            
        }
        else
        {
            [cell setSingleSelectionImage];
        }
    }
    else
    {
        [cell setUnselectionImage];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [dataArray objectAtIndex:indexPath.row];
    if([selectArray containsObject:text])
    {
        [selectArray removeObject:text];
    }
    else
    {
        if(isSingleSelection == YES)
        {
            [selectArray removeAllObjects];
        }
        [selectArray addObject:text];
    }
    [tableView reloadData];
}
@end
