//
//  BeTrainFilterTableView.m
//  sbh
//
//  Created by RobinLiu on 15/6/16.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTrainFilterTableView.h"

#define kTitleBarHeight 35
#define kTitleButtonWidth 44
#define kTicketBarWidth (CGRectGetWidth([UIApplication sharedApplication].keyWindow.bounds))
#define kTicketItemTableWidth 67
#define kTicketSepLineHeight 1

@interface BeTrainFilterTableView ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *cancelButton;
    UIButton *confirmButon;
    UIButton *clearFilterButton;
    UITableView *itemTable;
    UITableView *contentTable;
    id filterTarget;
    SEL filterCancelAction;
    SEL filterConfirmAction;
    UIView *nostopView;
    UISwitch *filterSwitch;
    NSString *selectTitle;
    NSMutableDictionary *dataDict;
    NSMutableArray *dataArray;
    BeTrainTicketFilterConditions *privateConditions;
}
@end
@implementation BeTrainFilterTableView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self customView];
        [self initData];
    }
    return self;
}
- (void)initData
{
    privateConditions = [[BeTrainTicketFilterConditions alloc]initConfigure];
    selectTitle = kDepartureTimeTitle;
    dataArray = [[NSMutableArray alloc]initWithArray:@[kDepartureTimeTitle,kArrivalTimeTitle,kTrainTypeTitle,kSeatTypeTitle]];
    dataDict = [[NSMutableDictionary alloc]init];
    [dataDict setObject:@[kUnlimitedCondition,kTrainTimeCondition1,kTrainTimeCondition2,kTrainTimeCondition3,kTrainTimeCondition4] forKey:kDepartureTimeTitle];
    [dataDict setObject:@[kUnlimitedCondition,kTrainTimeCondition1,kTrainTimeCondition2,kTrainTimeCondition3,kTrainTimeCondition4] forKey:kArrivalTimeTitle];
    [dataDict setObject:@[kUnlimitedCondition,kHighSpeedRailCondition,kRegularTrainCondition] forKey:kTrainTypeTitle];
    [dataDict setObject:@[kUnlimitedCondition,kHighestClassCondition,kSecondClassCondition,kHardSleeperCondition,kHardSeatCondition,kRWCondition,kGJRWCondition,kRZCondition,kSWZCondition,kTDZCondition ,kWZCondition] forKey:kSeatTypeTitle];
    [itemTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
   // [self setupAllconditions];
}
- (void)setExternalCondition:(BeTrainTicketFilterConditions *)externalCondition
{
    privateConditions = externalCondition;
    [self setupAllconditions];
}
- (void)setupAllconditions
{
    filterSwitch.on = privateConditions.isOnlyStraight;
    [contentTable reloadData];
}
- (void)customView
{
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, kTitleButtonWidth, kTitleBarHeight);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[ColorConfigure globalBgColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton addTarget:self action:@selector(filterCancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    
    confirmButon = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButon.frame = CGRectMake(kTicketBarWidth - kTitleButtonWidth, 0, kTitleButtonWidth, kTitleBarHeight);
    [confirmButon setTitle:@"确定" forState:UIControlStateNormal];
    confirmButon.titleLabel.font = [UIFont systemFontOfSize:15];
    [confirmButon setTitleColor:[ColorConfigure globalBgColor] forState:UIControlStateNormal];
    [confirmButon addTarget:self action:@selector(filterConfirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmButon];
    
    clearFilterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearFilterButton.frame = CGRectMake(kTitleButtonWidth+50, 0, kTicketBarWidth - (kTitleButtonWidth+50)*2, kTitleBarHeight);
    [clearFilterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clearFilterButton setTitle:@"筛选" forState:UIControlStateNormal];
    clearFilterButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [clearFilterButton addTarget:self action:@selector(filterClearAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clearFilterButton];
    
    UIImageView *sepLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, kTitleBarHeight, kTicketBarWidth, kTicketSepLineHeight)];
    sepLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:sepLine];
    
    itemTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kTitleBarHeight + kTicketSepLineHeight + kItemTableViewCellHeight, kTicketItemTableWidth, kFilterViewHeight - kTitleBarHeight - kTicketSepLineHeight - kItemTableViewCellHeight) style:UITableViewStylePlain];
    itemTable.scrollEnabled = NO;
    itemTable.delegate = self;
    itemTable.backgroundColor = [ColorUtility colorWithRed:215 green:215 blue:215];
    itemTable.dataSource = self;
    [self addSubview:itemTable];
    
    contentTable = [[UITableView alloc]initWithFrame:CGRectMake(kTicketItemTableWidth, kTitleBarHeight + kTicketSepLineHeight + kItemTableViewCellHeight, kTicketBarWidth - kTicketItemTableWidth, kFilterViewHeight - kTitleBarHeight - kTicketSepLineHeight - kItemTableViewCellHeight) style:UITableViewStylePlain];
    contentTable.delegate = self;
    contentTable.dataSource = self;
    contentTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, contentTable.width, 0.1)];
    [self addSubview:contentTable];
    
    nostopView = [[UIView alloc]initWithFrame:CGRectMake(0, kTitleBarHeight + kTicketSepLineHeight, kTicketBarWidth, kItemTableViewCellHeight)];
    nostopView.backgroundColor = [ColorUtility colorWithRed:215 green:215 blue:215];
    [self addSubview:nostopView];
    
    UIImageView *nostopViewSepLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, kItemTableViewCellHeight-kTicketSepLineHeight*0.7, kTicketBarWidth, kTicketSepLineHeight*0.6)];
    nostopViewSepLine.backgroundColor = [ColorUtility colorWithRed:188 green:186 blue:193];
    [nostopView addSubview:nostopViewSepLine];
    
    UILabel *nostopLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kTicketItemTableWidth, kItemTableViewCellHeight)];
    nostopLabel.text = kOnlyoriginatingTitel;
    nostopLabel.textAlignment = NSTextAlignmentCenter;
    nostopLabel.font = [UIFont systemFontOfSize:14];
    [nostopView addSubview:nostopLabel];
    
    filterSwitch = [[UISwitch alloc]init];
    filterSwitch.onTintColor = [ColorConfigure globalBgColor];
    filterSwitch.y = 5;
    filterSwitch.x = kTicketBarWidth - 65;
    [filterSwitch addTarget:self action:@selector(filterSwitchAction:) forControlEvents:UIControlEventValueChanged];
    [nostopView addSubview:filterSwitch];
    [self viewDidLayoutSubviews];
}

- (void)filterSwitchAction:(UISwitch *)sender
{
    privateConditions.isOnlyStraight = sender.on;
}
- (void)filterCancelAction
{
    [filterTarget performSelector:filterCancelAction withObject:nil afterDelay:0];
}
- (void)filterConfirmAction
{
    [filterTarget performSelector:filterConfirmAction withObject:privateConditions afterDelay:0];
}
- (void)filterClearAction
{
    
}
- (void)addTarget:(id)target andCancelAction:(SEL)cancelAction andConfirmAction:(SEL)confirmAction
{
    filterTarget = target;
    filterCancelAction = cancelAction;
    filterConfirmAction = confirmAction;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == itemTable)
    {
        return dataArray.count;
    }
    else if(tableView == contentTable)
    {
        NSArray *array = [dataDict objectForKey:selectTitle];
        return array.count;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kItemTableViewCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == contentTable)
    {
        BeHotelSearchContentCell *cell = [BeHotelSearchContentCell cellWithTableView:tableView];
        NSArray *array = [dataDict objectForKey:selectTitle];
        cell.contentLabel.text = [array objectAtIndex:indexPath.row];
        cell.canSelect = NO;
        if([selectTitle isEqualToString:kDepartureTimeTitle])
        {
            if ([privateConditions.startTimeArray containsObject:kUnlimitedCondition])
            {
                if([cell.contentLabel.text isEqualToString:kUnlimitedCondition])
                {
                    [cell setSingleSelectionImage];
                }
                else
                {
                    [cell setUnselectionImage];
                }
            }
            else
            {
                if([privateConditions.startTimeArray containsObject:cell.contentLabel.text])
                {
                    [cell setCheckBoxImage];
                }
                else
                {
                    [cell setUnselectionImage];
                }
            }
        }
        else if([selectTitle isEqualToString:kArrivalTimeTitle])
        {
            if ([privateConditions.arriveTimeArray containsObject:kUnlimitedCondition])
            {
                if([cell.contentLabel.text isEqualToString:kUnlimitedCondition])
                {
                    [cell setSingleSelectionImage];
                }
                else
                {
                    [cell setUnselectionImage];
                }
            }
            else
            {
                if([privateConditions.arriveTimeArray containsObject:cell.contentLabel.text])
                {
                    [cell setCheckBoxImage];
                }
                else
                {
                    [cell setUnselectionImage];
                }
            }
        }
        else if([selectTitle isEqualToString:kTrainTypeTitle])
        {
            if([privateConditions.trainTypeCondition isEqualToString:cell.contentLabel.text])
            {
                [cell setSingleSelectionImage];
            }
            else
            {
                [cell setUnselectionImage];
            }
        }
        else if([selectTitle isEqualToString:kSeatTypeTitle])
        {
            if([privateConditions.seatTypeCondition isEqualToString:cell.contentLabel.text])
            {
                [cell setSingleSelectionImage];
            }
            else
            {
                [cell setUnselectionImage];
            }
        }
        return cell;
    }
    if(tableView == itemTable)
    {
        BeHotleSearchItemTableViewCell *cell = [BeHotleSearchItemTableViewCell cellWithTableView:tableView];
        cell.contentLabel.text = [dataArray objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == itemTable)
    {
        BeHotleSearchItemTableViewCell *cell = (BeHotleSearchItemTableViewCell *)[itemTable cellForRowAtIndexPath:indexPath];
        selectTitle = cell.contentLabel.text;
        [contentTable reloadData];
    }
    else if(tableView == contentTable)
    {
        BeHotelSearchContentCell *cell = (BeHotelSearchContentCell *)[contentTable cellForRowAtIndexPath:indexPath];
        NSString *contentTitle = cell.contentLabel.text;
        [self setPrivateConditionWith:contentTitle];
    }
}
- (void)setPrivateConditionWith:(NSString *)condition
{
    if([selectTitle isEqualToString:kDepartureTimeTitle])
    {
        if([privateConditions.startTimeArray count]==1 && [privateConditions.startTimeArray containsObject:condition])
        {
            return;
        }
        else if([condition isEqualToString:kUnlimitedCondition])
        {
            [privateConditions.startTimeArray removeAllObjects];
            [privateConditions.startTimeArray addObject:kUnlimitedCondition];
        }
        else
        {
            if([privateConditions.startTimeArray containsObject:kUnlimitedCondition])
            {
                [privateConditions.startTimeArray removeObject:kUnlimitedCondition];
            }
            if([privateConditions.startTimeArray containsObject:condition])
            {
                [privateConditions.startTimeArray removeObject:condition];
            }
            else
            {
                [privateConditions.startTimeArray addObject:condition];
            }
        }
    }
    if([selectTitle isEqualToString:kArrivalTimeTitle])
    {
        if([privateConditions.arriveTimeArray count]==1 && [privateConditions.arriveTimeArray containsObject:condition])
        {
            return;
        }
        else if([condition isEqualToString:kUnlimitedCondition])
        {
            [privateConditions.arriveTimeArray removeAllObjects];
            [privateConditions.arriveTimeArray addObject:kUnlimitedCondition];
        }
        else
        {
            if([privateConditions.arriveTimeArray containsObject:kUnlimitedCondition])
            {
                [privateConditions.arriveTimeArray removeObject:kUnlimitedCondition];
            }
            if([privateConditions.arriveTimeArray containsObject:condition])
            {
                [privateConditions.arriveTimeArray removeObject:condition];
            }
            else
            {
                [privateConditions.arriveTimeArray addObject:condition];
            }
        }
    }
    if([selectTitle isEqualToString:kSeatTypeTitle])
    {
        privateConditions.seatTypeCondition = condition;
    }
    if([selectTitle isEqualToString:kTrainTypeTitle])
    {
        [dataDict removeObjectForKey:kSeatTypeTitle];
        if([condition isEqualToString:kUnlimitedCondition])
        {
            [dataDict setObject:@[kUnlimitedCondition,kHighestClassCondition,kSecondClassCondition,kHardSleeperCondition,kHardSeatCondition,kRWCondition,kGJRWCondition,kRZCondition,kSWZCondition,kTDZCondition ,kWZCondition] forKey:kSeatTypeTitle];
        }
        else if([condition isEqualToString:kHighSpeedRailCondition])
        {
            NSArray *array = @[kUnlimitedCondition,kHighestClassCondition,kSecondClassCondition,kRWCondition,kSWZCondition,kTDZCondition ,kWZCondition];
            [dataDict setObject:array forKey:kSeatTypeTitle];
            if(![array containsObject:privateConditions.seatTypeCondition])
            {
                privateConditions.seatTypeCondition = kUnlimitedCondition;
            }
        }
        else if([condition isEqualToString:kRegularTrainCondition])
        {
            NSArray *array = @[kUnlimitedCondition,kHardSleeperCondition,kHardSeatCondition,kRWCondition,kGJRWCondition,kRZCondition,kWZCondition];
            [dataDict setObject:array forKey:kSeatTypeTitle];
            if(![array containsObject:privateConditions.seatTypeCondition])
            {
                privateConditions.seatTypeCondition = kUnlimitedCondition;
            }
        }
        privateConditions.trainTypeCondition = condition;
    }
    [contentTable reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == itemTable)
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
}
- (void)viewDidLayoutSubviews
{
    if ([itemTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [itemTable setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([itemTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [itemTable setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

@end

