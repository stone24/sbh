//
//  BeTicketQueryListData.m
//  sbh
//
//  Created by RobinLiu on 15/4/17.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTicketQueryListData.h"
#import "BeTicketQueryResultModel.h"

@implementation BeTicketQueryListData
- (id)init
{
    if(self = [super init])
    {
        _listArray = [[NSMutableArray alloc]init];
        _filterArray = [[NSMutableArray alloc]init];
        _guid = [[NSString alloc]init];
        _aircompayArray = [[NSMutableArray alloc]init];
        _timeUp = NO;
        _priceUp = NO;
        _isFilter = NO;
        _isDataException = NO;
        _departureAirportArray = [[NSMutableArray alloc]init];
        _arriveAirportArray = [[NSMutableArray alloc]init];
        _departCityName = [[NSString alloc]init];
        _arriveCityName = [[NSString alloc]init];
    }
    return self;
}
- (void)setDataWithDict:(NSDictionary *)dict WithCabinType:(AircraftCabinType)cabinType andFlightNo:(NSString *)flightNo and:(QueryControllerSourceType )sourceType
{
    [self clearAllData];
    _isDataException = NO;
    _cabinType = cabinType;
    for(NSDictionary *member in [dict objectForKey:[NSNumber numberWithInt: kBussinessClassType]])
    {
        BeTicketQueryResultModel *objcModel = [[BeTicketQueryResultModel alloc]init];
        [objcModel setModelWith:member];
        objcModel.cabinType = kBussinessClassType;
        if(sourceType == kQueryControllerSourceAlteSeveral)
        {
            NSString *airlineCode = [flightNo substringToIndex:2];
            NSString *modelAirLineCode = [objcModel.FlightNo substringToIndex:2];
            if([[modelAirLineCode lowercaseString] isEqualToString:[airlineCode lowercaseString]])
            {
                [self listArrayAddModel:objcModel andType:cabinType];
            }
            
        }
        else
        {
            [self listArrayAddModel:objcModel andType:cabinType];
        }
    }
    for(NSDictionary *member in [dict objectForKey:[NSNumber numberWithInt: kAllClassType]])
    {
        BeTicketQueryResultModel *objcModel = [[BeTicketQueryResultModel alloc]init];
        objcModel.cabinType = kAllClassType;
        [objcModel setModelWith:member];
        if(sourceType == kQueryControllerSourceAlteSeveral)
        {
            NSString *airlineCode = [flightNo substringToIndex:2];
            NSString *modelAirLineCode = [objcModel.FlightNo substringToIndex:2];
            if([[modelAirLineCode lowercaseString] isEqualToString:[airlineCode lowercaseString]])
            {
                [self listArrayAddModel:objcModel andType:cabinType];
            }
        }
        else
        {
            [self listArrayAddModel:objcModel andType:cabinType];
        }
    }
    _guid = [dict stringValueForKey:@"guid" defaultValue:@""];
}
- (void)listArrayAddModel:(BeTicketQueryResultModel *)objcModel andType:(AircraftCabinType)cabinType
{
    [_listArray addObject:objcModel];
    if(objcModel.cabinType == cabinType)
    {
        [_filterArray addObject:objcModel];
    }
    if(![_aircompayArray containsObject:objcModel.CarrierSName]&& objcModel.CarrierSName.length!=0)
    {
        [_aircompayArray addObject:objcModel.CarrierSName];
    }
    if(![_departureAirportArray containsObject:objcModel.DepAirportName]&& objcModel.DepAirportName.length!=0)
    {
        [_departureAirportArray addObject:objcModel.DepAirportName];
    }
    if(![_arriveAirportArray containsObject:objcModel.ArrAirportName]&& objcModel.ArrAirportName.length!=0)
    {
        [_arriveAirportArray addObject:objcModel.ArrAirportName];
    }
}
- (void)filterWithItem:(BeTicketQueryDataSource *)item
{
    _isFilter = YES;
    [_filterArray removeAllObjects];
    [_filterArray addObjectsFromArray:_listArray];
    NSString *predicate = [[NSString alloc]init];
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    NSPredicate *pre = nil;
    if(item.selectNonstopType == kTicketQueryNonstopUnlimited)
    {
        
    }
    else if (item.selectNonstopType == kTicketQueryNonstopYes)
    {
        predicate =@"ViaPort == '0' ";
        pre = [NSPredicate predicateWithFormat:predicate];
        [tempArray addObjectsFromArray: [_filterArray filteredArrayUsingPredicate:pre]];
        [_filterArray removeAllObjects];
        [_filterArray addObjectsFromArray:tempArray];
    }
    [tempArray removeAllObjects];
    if ([item.selectedDateArray containsObject:kFilterConditionUnlimited])
    {
        
    }
    else
    {
        NSString *timeString = [[NSString alloc]init];
        for (int i = 0; i < item.selectedDateArray.count; i++)
        {
            NSString *memberString = [item.selectedDateArray objectAtIndex:i];
            if([memberString isEqualToString:kFilterConditionDate1])
            {
                timeString = [timeString stringByAppendingString:@"departureInt BETWEEN {0,600} "];
            }
            else if([memberString isEqualToString:kFilterConditionDate2])
            {
                timeString = [timeString stringByAppendingString:@"departureInt BETWEEN { 600, 1200 }"];
            }
            else if([memberString isEqualToString:kFilterConditionDate3])
            {
                timeString = [timeString stringByAppendingString:@"departureInt BETWEEN { 1200, 1800 }"];
            }
            else if([memberString isEqualToString:kFilterConditionDate4])
            {
                timeString = [timeString stringByAppendingString:@"departureInt BETWEEN { 1800, 2359 }"];
            }

            if(item.selectedDateArray.count - 1 > i)
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
    
    if([item.selectedCabin isEqualToString:kFilterConditionCabin0])
    {
        NSPredicate *cabinPre = [NSPredicate predicateWithFormat:@"cabinType == 0"];
        [tempArray addObjectsFromArray: [_filterArray filteredArrayUsingPredicate:cabinPre]];
        [_filterArray removeAllObjects];
        [_filterArray addObjectsFromArray:tempArray];
    }
    else if([item.selectedCabin isEqualToString:kFilterConditionCabin1])
    {
        NSPredicate *cabinPre = [NSPredicate predicateWithFormat:@"cabinType == 1"];
        [tempArray addObjectsFromArray: [_filterArray filteredArrayUsingPredicate:cabinPre]];
        [_filterArray removeAllObjects];
        [_filterArray addObjectsFromArray:tempArray];
    }
    else if([item.selectedCabin isEqualToString:kFilterConditionCabin2])
    {
        NSPredicate *cabinPre = [NSPredicate predicateWithFormat:@"cabinType == 2"];
        [tempArray addObjectsFromArray: [_filterArray filteredArrayUsingPredicate:cabinPre]];
        [_filterArray removeAllObjects];
        [_filterArray addObjectsFromArray:tempArray];
    }
    [tempArray removeAllObjects];
    if ([item.selectedDepartureAirportArray containsObject: kFilterConditionUnlimited])
    {
    }
    else
    {
        NSString *departString = [[NSString alloc]init];
        for (int i = 0; i < item.selectedDepartureAirportArray.count; i++)
        {
            departString = [departString stringByAppendingFormat:@"DepAirportName == '%@'",[item.selectedDepartureAirportArray objectAtIndex:i]];
            if(item.selectedDepartureAirportArray.count - 1 > i)
            {
                departString = [departString stringByAppendingString:@" OR "];
            }
        }
        NSPredicate *DeAPPre = [NSPredicate predicateWithFormat:departString];
        [tempArray addObjectsFromArray: [_filterArray filteredArrayUsingPredicate:DeAPPre]];
        [_filterArray removeAllObjects];
        [_filterArray addObjectsFromArray:tempArray];
        
    }
    [tempArray removeAllObjects];
    if ([item.selectedArriveAirportArray containsObject: kFilterConditionUnlimited])
    {
    }
    else
    {
        NSString *arriveString = [[NSString alloc]init];
        for (int i = 0; i < item.selectedArriveAirportArray.count; i++)
        {
            arriveString = [arriveString stringByAppendingFormat:@"ArrAirportName == '%@'",[item.selectedArriveAirportArray objectAtIndex:i]];
            if(item.selectedArriveAirportArray.count - 1 > i)
            {
                arriveString = [arriveString stringByAppendingString:@" OR "];
            }
        }
        NSPredicate *DeAPPre = [NSPredicate predicateWithFormat:arriveString];
        [tempArray addObjectsFromArray: [_filterArray filteredArrayUsingPredicate:DeAPPre]];
        [_filterArray removeAllObjects];
        [_filterArray addObjectsFromArray:tempArray];
        
    }
    [tempArray removeAllObjects];
    if ([item.selectedAirCompanyArray containsObject: kFilterConditionUnlimited])
    {
    }
    else
    {
        NSString *airString = [[NSString alloc]init];
        for (int i = 0; i < item.selectedAirCompanyArray.count; i++)
        {
            airString = [airString stringByAppendingFormat:@"CarrierSName == '%@'",[item.selectedAirCompanyArray objectAtIndex:i]];
            if(item.selectedAirCompanyArray.count - 1 > i)
            {
                airString = [airString stringByAppendingString:@" OR "];
            }
        }
        NSPredicate *DeAPPre = [NSPredicate predicateWithFormat:airString];
        [tempArray addObjectsFromArray: [_filterArray filteredArrayUsingPredicate:DeAPPre]];
        [_filterArray removeAllObjects];
        [_filterArray addObjectsFromArray:tempArray];
    }
    [tempArray removeAllObjects];
}
- (void)sortTimeWithIsUp:(BOOL)isUp
{
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"DepartureTime" ascending:isUp];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    NSArray *sortedArray = [_filterArray sortedArrayUsingDescriptors:sortDescriptors];
    [_filterArray removeAllObjects];
    [_filterArray addObjectsFromArray:sortedArray];
}
- (void)sortPriceIsUp:(BOOL)isUp
{
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ticketPrice" ascending:isUp];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    NSArray *sortedArray = [_filterArray sortedArrayUsingDescriptors:sortDescriptors];
    [_filterArray removeAllObjects];
    [_filterArray addObjectsFromArray:sortedArray];
}
- (void)clearAllData
{
    [_listArray removeAllObjects];
    [_filterArray removeAllObjects];
    [_aircompayArray removeAllObjects];
    [_departureAirportArray removeAllObjects];
    [_arriveAirportArray removeAllObjects];
}
- (void)clearAllFilterConditions
{
    [_filterArray removeAllObjects];
    [_filterArray addObjectsFromArray:_listArray];
}
@end
