//
//  BeTicketRuleReasonView.m
//  sbh
//
//  Created by RobinLiu on 16/3/15.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeTicketRuleReasonView.h"
#import "ColorUtility.h"
#import "ColorConfigure.h"
#import "BeHotelSearchContentCell.h"

@interface BeTicketRuleReasonView()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *ruleTableView;
    BeTicketRuleReasonViewBlock _block;
    NSMutableArray *dataArray;
}
@end
@implementation BeTicketRuleReasonView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
+ (BeTicketRuleReasonView *)sharedInstance
{
    static BeTicketRuleReasonView *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!_instance)
        {
            _instance = [[BeTicketRuleReasonView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
        }
    });
    return _instance;
}
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        dataArray = [[NSMutableArray alloc]init];
        [dataArray addObjectsFromArray:@[@"123",@"123",@"321",@"345"]];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedCancel)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        ruleTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 150, kScreenWidth, 150) style:UITableViewStylePlain];
        ruleTableView.delegate = self;
        ruleTableView.dataSource = self;
        [self addSubview:ruleTableView];
    }
    return self;
}

- (void)showViewWith:(NSArray *)reasonArray andBlock:(BeTicketRuleReasonViewBlock)block
{
    _block = block;
    [dataArray removeAllObjects];
    [dataArray addObjectsFromArray:reasonArray];
    if(42.0 * dataArray.count > 150)
    {
        ruleTableView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 150);
        
    }
    else
    {
        ruleTableView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 42.0 * dataArray.count) ;
    }
    [ruleTableView reloadData];
    [[[UIApplication sharedApplication]keyWindow]addSubview:self];
    [UIView animateWithDuration:0.25f animations:^
     {
         if(42.0 * dataArray.count > 150)
         {
             ruleTableView.frame = CGRectMake(0, kScreenHeight - 150, kScreenWidth, 150);
             
         }
         else
         {
             ruleTableView.frame = CGRectMake(0, kScreenHeight - 42.0 * dataArray.count, kScreenWidth, 42.0 * dataArray.count) ;
         }
     }completion:^(BOOL finished)
     {
     }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
    {
        return NO;
    }
    return YES;
}
- (void)tappedCancel
{
    [UIView animateWithDuration:0.15f delay:0.001 options:UIViewAnimationOptionCurveEaseIn animations:^
     {
         self.backgroundColor = [UIColor clearColor];
         [ruleTableView setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 150)];
     }completion:^(BOOL finished)
     {
         [self removeFromSuperview];
         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
     }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeHotelSearchContentCell *cell = [BeHotelSearchContentCell cellWithTableView:tableView];
    cell.canSelect = YES;
    cell.contentLabel.text = [dataArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeHotelSearchContentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.selected)
    {
        _block (cell.contentLabel.text);
        [self tappedCancel];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)viewDidLayoutSubviews
{
    if ([ruleTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [ruleTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([ruleTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [ruleTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

@end
