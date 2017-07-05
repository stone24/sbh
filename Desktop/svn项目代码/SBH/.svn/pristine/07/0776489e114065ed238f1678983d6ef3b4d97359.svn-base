//
//  BeTicketQueryPickerView.m
//  sbh
//
//  Created by RobinLiu on 15/4/15.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTicketQueryPickerView.h"
#import "BeTicketQueryDataSource.h"
#import "BeTicketQueryFilterView.h"

@interface BeTicketQueryPickerView ()<UIGestureRecognizerDelegate>
{
    BeTicketQueryFilterView *filterView;
    TicketQueryPickerBlock _block;
}
@end
@implementation BeTicketQueryPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (BeTicketQueryPickerView *)sharedInstance
{
    static BeTicketQueryPickerView *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!_instance)
        {
            _instance = [[BeTicketQueryPickerView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
        }
    });
    return _instance;
}
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        _hideAirCompany = NO;
        _hideTakeOff = NO;
        _hideAirport = NO;
        _hideCabin = NO;
        filterView = [[BeTicketQueryFilterView alloc]initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, kFilterViewHeight)];
        [filterView addTarget:self andCancelAction:@selector(tappedCancel) andConfirmAction:@selector(filterConfirm:)];
        [self addSubview:filterView];
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedCancel)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)setHideTakeOff:(BOOL)hideTakeOff
{
    if (hideTakeOff) {
        [[BeTicketQueryDataSource sharedInstance]removeItemArrayCondition:kFilterTakeOffTimeTitle];
    }
}
- (void)setHideAirport:(BOOL)hideAirport
{
    if (hideAirport) {
        [[BeTicketQueryDataSource sharedInstance]removeItemArrayCondition:kFilterAirportTitle];
    }
}
- (void)setHideCabin:(BOOL)hideCabin
{
    if (hideCabin) {
        [[BeTicketQueryDataSource sharedInstance]removeItemArrayCondition:kFilterCabinTitle];
    }
}
- (void)setHideAirCompany:(BOOL)hideAirCompany
{
    if (hideAirCompany) {
        [[BeTicketQueryDataSource sharedInstance]removeItemArrayCondition:kFilterAirlineCompanyTitle];
    }
}
- (void)addAllConditions
{
    [[BeTicketQueryDataSource sharedInstance]itemArrayAddAllConditions];
}
- (void)setTicketQueryInfo:(BeTicketQueryListData *)ticketQueryInfo
{
    [[BeTicketQueryDataSource sharedInstance]initConfigureCondition];
    [BeTicketQueryDataSource sharedInstance].departCity = ticketQueryInfo.departCityName;
    [BeTicketQueryDataSource sharedInstance].arriveCity = ticketQueryInfo.arriveCityName;
     switch (ticketQueryInfo.cabinType)
    {
        case kAllClassType:
        {
            [BeTicketQueryDataSource sharedInstance].selectedCabin = kFilterConditionCabin0;
        }
            break;
        case kBussinessClassType:
        {
            [BeTicketQueryDataSource sharedInstance].selectedCabin =kFilterConditionCabin2;
        }
            break;
        case kEconomyClassType:
        {
            [BeTicketQueryDataSource sharedInstance].selectedCabin = kFilterConditionCabin1;
        }
            break;
        default:
            break;
    }
    [[BeTicketQueryDataSource sharedInstance].departureAirportArray removeAllObjects];
    [[BeTicketQueryDataSource sharedInstance].departureAirportArray addObject:kFilterConditionUnlimited];
    [[BeTicketQueryDataSource sharedInstance].departureAirportArray addObjectsFromArray:ticketQueryInfo.departureAirportArray];

    [[BeTicketQueryDataSource sharedInstance].arriveAirportArray removeAllObjects];
    [[BeTicketQueryDataSource sharedInstance].arriveAirportArray addObject:kFilterConditionUnlimited];
    [[BeTicketQueryDataSource sharedInstance].arriveAirportArray addObjectsFromArray:ticketQueryInfo.arriveAirportArray];
    
    [[BeTicketQueryDataSource sharedInstance].airlineCompanyConditionArray removeAllObjects];
    [[BeTicketQueryDataSource sharedInstance].airlineCompanyConditionArray addObject:kFilterConditionUnlimited];
    [[BeTicketQueryDataSource sharedInstance].airlineCompanyConditionArray addObjectsFromArray:ticketQueryInfo.aircompayArray];
}

- (void)showPickerViewWithBlock:(TicketQueryPickerBlock )blockObj
{
    _block = blockObj;
    [BeTicketQueryDataSource sharedInstance].selectItemTitle = [[BeTicketQueryDataSource sharedInstance].itemTitleArray firstObject];
    filterView.queryData = [BeTicketQueryDataSource sharedInstance];
    [[[UIApplication sharedApplication]keyWindow]addSubview:self];
    [UIView animateWithDuration:0.2f delay:0.001 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
        [filterView setFrame:CGRectMake(0, self.frame.size.height-kFilterViewHeight, self.frame.size.width, kFilterViewHeight)];
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
        [filterView setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, kFilterViewHeight)];
    }completion:^(BOOL finished)
    {
        [self removeFromSuperview];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }];
}
- (void)filterConfirm:(BeTicketQueryDataSource *)queryData
{
    [BeTicketQueryDataSource sharedInstance].selectNonstopType = queryData.selectNonstopType;
    [BeTicketQueryDataSource sharedInstance].selectItemTitle = [queryData.selectItemTitle mutableCopy];
    [BeTicketQueryDataSource sharedInstance].departCity = [queryData.departCity mutableCopy];
    [BeTicketQueryDataSource sharedInstance].arriveCity = [queryData.arriveCity mutableCopy];
    
    [BeTicketQueryDataSource sharedInstance].selectedDateArray = [queryData.selectedDateArray mutableCopy];
    [BeTicketQueryDataSource sharedInstance].selectedCabin = [queryData.selectedCabin mutableCopy];
    [BeTicketQueryDataSource sharedInstance].selectedDepartureAirportArray = [queryData.selectedDepartureAirportArray mutableCopy];
    [BeTicketQueryDataSource sharedInstance].selectedArriveAirportArray = [queryData.selectedArriveAirportArray mutableCopy];
    [BeTicketQueryDataSource sharedInstance].selectedAirCompanyArray = [queryData.selectedAirCompanyArray mutableCopy];
    
    [BeTicketQueryDataSource sharedInstance].itemTitleArray = [queryData.itemTitleArray mutableCopy];
    [BeTicketQueryDataSource sharedInstance].departureAirportArray = [queryData.departureAirportArray mutableCopy];
    [BeTicketQueryDataSource sharedInstance].arriveAirportArray = [queryData.arriveAirportArray mutableCopy];
    [BeTicketQueryDataSource sharedInstance].cabinConditionArray = [queryData.cabinConditionArray mutableCopy];
    [BeTicketQueryDataSource sharedInstance].takeOffTimeConditionArray = [queryData.takeOffTimeConditionArray mutableCopy];
    [BeTicketQueryDataSource sharedInstance].airlineCompanyConditionArray = [queryData.airlineCompanyConditionArray mutableCopy];
    _block();
    [self tappedCancel];
}
@end