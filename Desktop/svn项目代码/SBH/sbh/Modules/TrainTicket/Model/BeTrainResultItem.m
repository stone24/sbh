//
//  BeTrainResultItem.m
//  sbh
//
//  Created by RobinLiu on 15/6/15.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTrainResultItem.h"
#import "NSDictionary+Additions.h"

@implementation BeTrainResultItem
- (id)init
{
    if(self = [super init])
    {
        _listArray = [[NSMutableArray alloc]init];;
        _filterArray = [[NSMutableArray alloc]init];
        _guid = [[NSString alloc]init];
        _timeUp = NO;
        _priceUp = NO;
        _isFilter = NO;
        _isDuration = NO;
        _isDataException = NO;
    }
    return self;
}
- (void)setDataWithDict:(NSDictionary *)dict
{
    [_listArray removeAllObjects];
    [_filterArray removeAllObjects];
    for(NSDictionary *objDict in [dict arrayValueForKey:@"TrainSearchList"])
    {
        BeTrainTicketListModel *item = [[BeTrainTicketListModel alloc]initWithDict:objDict];
        item.serverTime = [dict stringValueForKey:@"servicetime" defaultValue:@""];
        if([self canDisplayWith:item]&& [self isNotExistWith:item])
        {
            [_listArray addObject:item];
        }
    }
    [_filterArray addObjectsFromArray:_listArray];
}
- (BOOL)isNotExistWith:(BeTrainTicketListModel *)item
{
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    NSPredicate *timePre = [NSPredicate predicateWithFormat:@"TrainCode CONTAINS %@",item.TrainCode];
    [tempArray addObjectsFromArray: [_listArray filteredArrayUsingPredicate:timePre]];
    if(tempArray.count>0)
    {
        return NO;
    }
    return YES;
}
- (BOOL)canDisplayWith:(BeTrainTicketListModel *)item
{
    if(item.isPriceZero == YES)
    {
        return NO;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *startTime = [NSString stringWithFormat:@"%@ %@:00",item.SDate,item.StartTime];
    NSDate *date1 = [formatter dateFromString:startTime];
    NSDate *date2 = [formatter dateFromString:item.serverTime];
    NSTimeInterval aTimer = [date1 timeIntervalSinceDate:date2];
    if(aTimer >= 90*60)
    {
        return YES;
    }
    return NO;
}
- (void)filterWithItem:(BeTrainTicketFilterConditions *)item{
    _isFilter = YES;
    _timeUp = NO;
    _priceUp = NO;
    _isDuration = NO;
    [_filterArray removeAllObjects];
    [_filterArray addObjectsFromArray:_listArray];
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];

    //是否始发
    if(item.isOnlyStraight)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isNonstop == 1"];
        NSArray *sortedArray = [_filterArray filteredArrayUsingPredicate:predicate];
        [_filterArray removeAllObjects];
        [_filterArray addObjectsFromArray:sortedArray];
    }
    else
    {
        
    }
    
    //发车时间
    if ([item.startTimeArray containsObject:kUnlimitedCondition])
    {
        
    }
    else
    {
        NSString *timeString = [[NSString alloc]init];
        for (int i = 0; i < item.startTimeArray.count; i++)
        {
            NSString *memberString = [item.startTimeArray objectAtIndex:i];
            if([memberString isEqualToString:kTrainTimeCondition1])
            {
                timeString = [timeString stringByAppendingString:@"startInt BETWEEN {0000,0600} "];
            }
            else if([memberString isEqualToString:kTrainTimeCondition2])
            {
                timeString = [timeString stringByAppendingString:@"startInt BETWEEN { 0600, 1200 }"];
            }
            else if([memberString isEqualToString:kTrainTimeCondition3])
            {
                timeString = [timeString stringByAppendingString:@"startInt BETWEEN { 1200, 1800 }"];
            }
            else if([memberString isEqualToString:kTrainTimeCondition4])
            {
                timeString = [timeString stringByAppendingString:@"startInt BETWEEN { 1800, 2359 }"];
            }
            if(item.startTimeArray.count - 1 > i)
            {
                timeString = [timeString stringByAppendingString:@" OR "];
            }
        }
        NSPredicate *timePre = [NSPredicate predicateWithFormat:timeString];
        [tempArray addObjectsFromArray: [_filterArray filteredArrayUsingPredicate:timePre]];
        [_filterArray removeAllObjects];
        [_filterArray addObjectsFromArray:tempArray];
    }
    [tempArray removeAllObjects];
    
    //到达时间 arriveInt;
    if ([item.arriveTimeArray containsObject:kUnlimitedCondition])
    {
        
    }
    else
    {
        NSString *timeString = [[NSString alloc]init];
        for (int i = 0; i < item.arriveTimeArray.count; i++)
        {
            NSString *memberString = [item.arriveTimeArray objectAtIndex:i];
            if([memberString isEqualToString:kTrainTimeCondition1])
            {
                timeString = [timeString stringByAppendingString:@"arriveInt BETWEEN {0000,0600} "];
            }
            else if([memberString isEqualToString:kTrainTimeCondition2])
            {
                timeString = [timeString stringByAppendingString:@"arriveInt BETWEEN { 0600, 1200 }"];
            }
            else if([memberString isEqualToString:kTrainTimeCondition3])
            {
                timeString = [timeString stringByAppendingString:@"arriveInt BETWEEN { 1200, 1800 }"];
            }
            else if([memberString isEqualToString:kTrainTimeCondition4])
            {
                timeString = [timeString stringByAppendingString:@"arriveInt BETWEEN { 1800, 2359 }"];
            }
            if(item.arriveTimeArray.count - 1 > i)
            {
                timeString = [timeString stringByAppendingString:@" OR "];
            }
        }
        NSPredicate *timePre = [NSPredicate predicateWithFormat:timeString];
        [tempArray addObjectsFromArray: [_filterArray filteredArrayUsingPredicate:timePre]];
        [_filterArray removeAllObjects];
        [_filterArray addObjectsFromArray:tempArray];
    }
    [tempArray removeAllObjects];
    
    //车次类型
    if([item.trainTypeCondition isEqualToString:kUnlimitedCondition])
    {
       
    }
    else if([item.trainTypeCondition isEqualToString:kHighSpeedRailCondition])
    {
        NSPredicate *timePre = [NSPredicate predicateWithFormat:@"isHighSpeed == 1"];
        [tempArray addObjectsFromArray: [_filterArray filteredArrayUsingPredicate:timePre]];
        [_filterArray removeAllObjects];
        [_filterArray addObjectsFromArray:tempArray];
    }
    else if([item.trainTypeCondition isEqualToString:kRegularTrainCondition])
    {
        NSPredicate *timePre = [NSPredicate predicateWithFormat:@"isHighSpeed == 0"];
        [tempArray addObjectsFromArray: [_filterArray filteredArrayUsingPredicate:timePre]];
        [_filterArray removeAllObjects];
        [_filterArray addObjectsFromArray:tempArray];
    }
    [tempArray removeAllObjects];
    
    //坐席类型
    if(![item.seatTypeCondition isEqualToString:kUnlimitedCondition])
    {
        for(BeTrainTicketListModel *model in _filterArray)
        {
            if([model isHaveDataAfterSortedWithConditions:item.seatTypeCondition])
            {
                [tempArray addObject:model];
            }
        }
        [_filterArray removeAllObjects];
        [_filterArray addObjectsFromArray:tempArray];
        [tempArray removeAllObjects];
    }
    else
    {
        for(BeTrainTicketListModel *model in _filterArray)
        {
            [model sortBykUnlimitedCondition];
            [tempArray addObject:model];
        }
        [_filterArray removeAllObjects];
        [_filterArray addObjectsFromArray:tempArray];
        [tempArray removeAllObjects];
    }
}
- (void)sortTime
{
    _timeUp = !_timeUp;
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"StartTime" ascending:_timeUp];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    NSArray *sortedArray = [_filterArray sortedArrayUsingDescriptors:sortDescriptors];
    [_filterArray removeAllObjects];
    [_filterArray addObjectsFromArray:sortedArray];
}
- (void)sortPrice
{
    _priceUp = !_priceUp;
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayModel.seatPrice" ascending:_priceUp];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    NSArray *sortedArray = [_filterArray sortedArrayUsingDescriptors:sortDescriptors];
    [_filterArray removeAllObjects];
    [_filterArray addObjectsFromArray:sortedArray];
}
- (void)sortDuration
{
    _isDuration = !_isDuration;
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"CostTime" ascending:_isDuration];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    NSArray *sortedArray = [_filterArray sortedArrayUsingDescriptors:sortDescriptors];
    [_filterArray removeAllObjects];
    [_filterArray addObjectsFromArray:sortedArray];
}
- (void)clearAllData
{
    [_listArray removeAllObjects];
    [_filterArray removeAllObjects];
    _timeUp = NO;
    _priceUp = NO;
    _isFilter = NO;
    _isDuration = NO;
    _isDataException = NO;
}
- (void)clearAllFilterConditions
{
    
}

@end
