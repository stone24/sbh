//
//  BeTicketQueryFilterView.m
//  sbh
//
//  Created by RobinLiu on 15/4/15.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTicketQueryFilterView.h"
#import "BeHotelSearchContentCell.h"
#import "BeHotleSearchItemTableViewCell.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"

#define kTitleBarHeight 35
#define kTitleButtonWidth 44
#define kTicketBarWidth (CGRectGetWidth([UIApplication sharedApplication].keyWindow.bounds))
#define kTicketItemTableWidth 67
#define kTicketSepLineHeight 1

@interface BeTicketQueryFilterView ()<UITableViewDataSource,UITableViewDelegate>
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
}
@end
@implementation BeTicketQueryFilterView

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
        _queryData = [[BeTicketQueryDataSource alloc]init];
        [self customView];
    }
    return self;
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
    contentTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kTicketBarWidth - kTicketItemTableWidth, 0.5)];
    contentTable.tableFooterView.backgroundColor = [UIColor clearColor];
    [self addSubview:contentTable];
    
    nostopView = [[UIView alloc]initWithFrame:CGRectMake(0, kTitleBarHeight + kTicketSepLineHeight, kTicketBarWidth, kItemTableViewCellHeight)];
    nostopView.backgroundColor = [ColorUtility colorWithRed:215 green:215 blue:215];
    [self addSubview:nostopView];
    
    UIImageView *nostopViewSepLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, kItemTableViewCellHeight-kTicketSepLineHeight*0.7, kTicketBarWidth, kTicketSepLineHeight*0.6)];
    nostopViewSepLine.backgroundColor = [ColorUtility colorWithRed:188 green:186 blue:193];
    [nostopView addSubview:nostopViewSepLine];
    
    UILabel *nostopLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kTicketItemTableWidth, kItemTableViewCellHeight)];
    nostopLabel.text = kFilterNonstopFlightTitle;
    nostopLabel.textAlignment = NSTextAlignmentCenter;
    nostopLabel.font = [UIFont systemFontOfSize:14];
    [nostopView addSubview:nostopLabel];

    filterSwitch = [[UISwitch alloc]init];
    filterSwitch.y = 5;
    filterSwitch.x = kTicketBarWidth - 65;
    filterSwitch.onTintColor = [ColorConfigure globalBgColor];
    [filterSwitch addTarget:self action:@selector(filterSwitchAction:) forControlEvents:UIControlEventValueChanged];
    [nostopView addSubview:filterSwitch];
    
    [self viewDidLayoutSubviews];
}
- (void)setQueryData:(BeTicketQueryDataSource *)queryData
{
    _queryData.selectNonstopType = queryData.selectNonstopType;
    _queryData.selectItemTitle = [queryData.selectItemTitle mutableCopy];
    _queryData.departCity = [queryData.departCity mutableCopy];
    _queryData.arriveCity = [queryData.arriveCity mutableCopy];
    
    _queryData.selectedDateArray = [queryData.selectedDateArray mutableCopy];
    _queryData.selectedCabin = [queryData.selectedCabin mutableCopy];
    _queryData.selectedDepartureAirportArray = [queryData.selectedDepartureAirportArray mutableCopy];
    _queryData.selectedArriveAirportArray = [queryData.selectedArriveAirportArray mutableCopy];
    _queryData.selectedAirCompanyArray = [queryData.selectedAirCompanyArray mutableCopy];
    
    _queryData.itemTitleArray = [queryData.itemTitleArray mutableCopy];
    _queryData.departureAirportArray = [queryData.departureAirportArray mutableCopy];
    _queryData.arriveAirportArray = [queryData.arriveAirportArray mutableCopy];
    _queryData.cabinConditionArray = [queryData.cabinConditionArray mutableCopy];
    _queryData.takeOffTimeConditionArray = [queryData.takeOffTimeConditionArray mutableCopy];
    _queryData.airlineCompanyConditionArray = [queryData.airlineCompanyConditionArray mutableCopy];
    
    filterSwitch.on =(_queryData.selectNonstopType == kTicketQueryNonstopUnlimited)? NO:YES;

    [itemTable reloadData];

    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:[_queryData.itemTitleArray indexOfObject:_queryData.selectItemTitle] inSection:0];
    [itemTable selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    [contentTable reloadData];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if([_queryData.selectItemTitle isEqualToString:kFilterAirportTitle] && tableView == contentTable)
    {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kTicketBarWidth-kTicketItemTableWidth, 30)];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *headerTitle = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 100, 20)];
        headerTitle.font = [UIFont systemFontOfSize:12];
        headerTitle.textColor = [UIColor grayColor];
        [headerView addSubview:headerTitle];
        if(section == 0)
        {
            headerTitle.text = [NSString stringWithFormat:@"%@起飞",_queryData.departCity];
        }
        else
        {
            headerTitle.text = [NSString stringWithFormat:@"%@降落",_queryData.arriveCity];
        }
        UIImageView *sep = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30-1, kTicketBarWidth-kTicketItemTableWidth, 1)];
        sep.backgroundColor = [UIColor lightGrayColor];
        [headerView addSubview:sep];
        return headerView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([_queryData.selectItemTitle isEqualToString:kFilterAirportTitle] && tableView == contentTable)
    {
        return 30.0f;
    }
    return 0.01;
}
- (void)filterSwitchAction:(UISwitch *)sender
{
    if(sender.on == YES)
    {
        _queryData.selectNonstopType = kTicketQueryNonstopYes;
    }
    if(sender.on == NO)
    {
        _queryData.selectNonstopType = kTicketQueryNonstopUnlimited;
    }
}
- (void)filterCancelAction
{
    [filterTarget performSelector:filterCancelAction withObject:nil afterDelay:0];
}
- (void)filterConfirmAction
{
    [filterTarget performSelector:filterConfirmAction withObject:_queryData afterDelay:0];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == contentTable && [_queryData.selectItemTitle isEqualToString:kFilterAirportTitle])
    {
        return 2;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == itemTable)
    {
        return _queryData.itemTitleArray.count;
    }
    if(tableView == contentTable)
    {
        if([_queryData.selectItemTitle isEqualToString:kFilterTakeOffTimeTitle])
        {
            return _queryData.takeOffTimeConditionArray.count;
        }
        else if([_queryData.selectItemTitle isEqualToString:kFilterAirportTitle])
        {
            if(section == 0)
            {
                return _queryData.departureAirportArray.count;
            }
            if(section == 1)
            {
                return _queryData.arriveAirportArray.count;
            }

        }
        else if([_queryData.selectItemTitle isEqualToString:kFilterCabinTitle])
        {
            return _queryData.cabinConditionArray.count;
        }
        else if([_queryData.selectItemTitle isEqualToString:kFilterAirlineCompanyTitle])
        {
            return _queryData.airlineCompanyConditionArray.count;
        }
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
        [cell setCellWithTicketQuery:_queryData andIndex:indexPath];
        return cell;
    }
    if(tableView == itemTable)
    {
        BeHotleSearchItemTableViewCell *cell = [BeHotleSearchItemTableViewCell cellWithTableView:tableView];
        cell.contentLabel.text = [_queryData.itemTitleArray objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == itemTable)
    {
        if([_queryData.selectItemTitle isEqualToString:[_queryData.itemTitleArray objectAtIndex:indexPath.row]])
        {
            return;
        }
        _queryData.selectItemTitle = [_queryData.itemTitleArray objectAtIndex:indexPath.row];
        [contentTable reloadData];
    }
    else if(tableView == contentTable)
    {
        if([_queryData.selectItemTitle isEqualToString:kFilterTakeOffTimeTitle])
        {
            BeHotelSearchContentCell *cell =  (BeHotelSearchContentCell *)[tableView cellForRowAtIndexPath:indexPath];
            if(_queryData.selectedDateArray.count == 1 && [[_queryData.selectedDateArray lastObject] isEqualToString:cell.contentLabel.text])
            {
                return;
            }
            if([cell.contentLabel.text isEqualToString:kFilterConditionUnlimited])
            {
                [_queryData.selectedDateArray removeAllObjects];
                [_queryData.selectedDateArray addObject: cell.contentLabel.text];
            }
            else
            {
                if([_queryData.selectedDateArray containsObject:kFilterConditionUnlimited])
                {
                    [_queryData.selectedDateArray removeObject: kFilterConditionUnlimited];
                }

                if([_queryData.selectedDateArray containsObject:cell.contentLabel.text])
                {
                    [_queryData.selectedDateArray removeObject: cell.contentLabel.text];
                }
                else
                {
                    [_queryData.selectedDateArray addObject: cell.contentLabel.text];
                }
            }
        }
        else if([_queryData.selectItemTitle isEqualToString:kFilterAirportTitle])
        {
            if(indexPath.section == 0)
            {
                if(_queryData.selectedDepartureAirportArray.count == 1 && [[_queryData.selectedDepartureAirportArray lastObject]isEqualToString:[_queryData.departureAirportArray objectAtIndex:indexPath.row]])
                {
                    return;
                }
                if([[_queryData.departureAirportArray objectAtIndex:indexPath.row] isEqualToString:kFilterConditionUnlimited])
                {
                    [_queryData.selectedDepartureAirportArray removeAllObjects];
                    [_queryData.selectedDepartureAirportArray addObject:[_queryData.departureAirportArray objectAtIndex:indexPath.row]];
                }
                else
                {
                    if([_queryData.selectedDepartureAirportArray containsObject:kFilterConditionUnlimited])
                    {
                        [_queryData.selectedDepartureAirportArray removeObject: kFilterConditionUnlimited];
                    }
                    if([_queryData.selectedDepartureAirportArray containsObject: [_queryData.departureAirportArray objectAtIndex:indexPath.row]])
                    {
                        [_queryData.selectedDepartureAirportArray removeObject: [_queryData.departureAirportArray objectAtIndex:indexPath.row]];
                    }
                    else
                    {
                        [_queryData.selectedDepartureAirportArray addObject: [_queryData.departureAirportArray objectAtIndex:indexPath.row]];
                    }
                }

            }
            if(indexPath.section == 1)
            {
                if(_queryData.selectedArriveAirportArray.count == 1 && [[_queryData.selectedArriveAirportArray lastObject]isEqualToString:[_queryData.arriveAirportArray objectAtIndex:indexPath.row]])
                {
                    return;
                }
                if([[_queryData.departureAirportArray objectAtIndex:indexPath.row] isEqualToString:kFilterConditionUnlimited])
                {
                    [_queryData.selectedArriveAirportArray removeAllObjects];
                    [_queryData.selectedArriveAirportArray addObject:[_queryData.arriveAirportArray objectAtIndex:indexPath.row]];
                }
                else
                {
                    if([_queryData.selectedArriveAirportArray containsObject:kFilterConditionUnlimited])
                    {
                        [_queryData.selectedArriveAirportArray removeObject: kFilterConditionUnlimited];
                    }
                    if([_queryData.selectedArriveAirportArray containsObject: [_queryData.arriveAirportArray objectAtIndex:indexPath.row]])
                    {
                        [_queryData.selectedArriveAirportArray removeObject: [_queryData.arriveAirportArray objectAtIndex:indexPath.row]];
                    }
                    else
                    {
                        [_queryData.selectedArriveAirportArray addObject: [_queryData.arriveAirportArray objectAtIndex:indexPath.row]];
                    }
                }
            }
        }
        else if([_queryData.selectItemTitle isEqualToString:kFilterCabinTitle])
        {
            BeHotelSearchContentCell *cell = (BeHotelSearchContentCell *)[tableView cellForRowAtIndexPath:indexPath];
            _queryData.selectedCabin = cell.contentLabel.text;
        }
        else if([_queryData.selectItemTitle isEqualToString:kFilterAirlineCompanyTitle])
        {
            if(_queryData.selectedAirCompanyArray.count == 1 && [[_queryData.selectedAirCompanyArray lastObject]isEqualToString:[_queryData.airlineCompanyConditionArray objectAtIndex:indexPath.row]])
            {
                return;
            }
            if([[_queryData.airlineCompanyConditionArray objectAtIndex:indexPath.row] isEqualToString:kFilterConditionUnlimited])
            {
                [_queryData.selectedAirCompanyArray removeAllObjects];
                [_queryData.selectedAirCompanyArray addObject:[_queryData.airlineCompanyConditionArray objectAtIndex:indexPath.row]];
            }
            else
            {
                if([_queryData.selectedAirCompanyArray containsObject:kFilterConditionUnlimited])
                {
                    [_queryData.selectedAirCompanyArray removeObject: kFilterConditionUnlimited];
                }
                if([_queryData.selectedAirCompanyArray containsObject: [_queryData.airlineCompanyConditionArray objectAtIndex:indexPath.row]])
                {
                    [_queryData.selectedAirCompanyArray removeObject: [_queryData.airlineCompanyConditionArray objectAtIndex:indexPath.row]];
                }
                else
                {
                    [_queryData.selectedAirCompanyArray addObject: [_queryData.airlineCompanyConditionArray objectAtIndex:indexPath.row]];
                }
            }
        }
        [contentTable reloadData];
    }
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
