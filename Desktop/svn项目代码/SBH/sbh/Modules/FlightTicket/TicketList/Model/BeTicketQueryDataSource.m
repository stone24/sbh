//
//  BeTicketQueryDataSource.m
//  sbh
//
//  Created by RobinLiu on 15/4/16.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTicketQueryDataSource.h"

@implementation BeTicketQueryDataSource
+ (BeTicketQueryDataSource *)sharedInstance
{
    static BeTicketQueryDataSource *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [[BeTicketQueryDataSource alloc]init];
        }
    });
    return _instance;
}
- (id)init
{
    if(self = [super init])
    {
        _itemTitleArray = [[NSMutableArray alloc]init];
        _cabinConditionArray = [[NSMutableArray alloc]initWithArray:@[kFilterConditionCabin0,kFilterConditionCabin2]];
        _takeOffTimeConditionArray = [[NSMutableArray alloc]init];
        _airlineCompanyConditionArray = [[NSMutableArray alloc]init];
        _departureAirportArray = [[NSMutableArray alloc]init];
        _arriveAirportArray = [[NSMutableArray alloc]init];
        _selectItemTitle = [[NSString alloc]init];
        
        _selectedDepartureAirportArray = [[NSMutableArray alloc]init];
        _selectedArriveAirportArray = [[NSMutableArray alloc]init];
        _selectedAirCompanyArray = [[NSMutableArray alloc]init];
        _selectedDateArray = [[NSMutableArray alloc]init];
        _selectedCabin = [[NSString alloc]init];
        _departCity = [[NSString alloc]init];
        _arriveCity = [[NSString alloc]init];
        
        [self initConfigureCondition];

    }
    return self;
}
- (void)initConfigureCondition
{
    _selectItemTitle = kFilterTakeOffTimeTitle;
    _selectNonstopType = kTicketQueryNonstopUnlimited;
    
    [_selectedDateArray removeAllObjects];
    [_selectedDateArray addObject: kFilterConditionUnlimited];
    
    [_selectedDepartureAirportArray removeAllObjects];
    [_selectedDepartureAirportArray addObject: kFilterConditionUnlimited];
    
    [_selectedArriveAirportArray removeAllObjects];
    [_selectedArriveAirportArray addObject: kFilterConditionUnlimited];
   
    [_selectedAirCompanyArray removeAllObjects];
    [_selectedAirCompanyArray addObject: kFilterConditionUnlimited];
    
    [_takeOffTimeConditionArray removeAllObjects];
    [_takeOffTimeConditionArray addObjectsFromArray:@[kFilterConditionUnlimited,kFilterConditionDate1,kFilterConditionDate2,kFilterConditionDate3,kFilterConditionDate4]];
    [self itemArrayAddAllConditions];
}
- (void)itemArrayAddAllConditions
{
    [_itemTitleArray removeAllObjects];
    [_itemTitleArray addObjectsFromArray:@[ kFilterTakeOffTimeTitle,kFilterAirportTitle,kFilterCabinTitle, kFilterAirlineCompanyTitle]];
}
- (void)removeItemArrayCondition:(NSString *)title
{
    if([_itemTitleArray containsObject:title])
    {
        [_itemTitleArray removeObject:title];
    }
}
- (void)setItemTitleArray:(NSMutableArray *)itemTitleArray
{
    _itemTitleArray = itemTitleArray;
}
@end
