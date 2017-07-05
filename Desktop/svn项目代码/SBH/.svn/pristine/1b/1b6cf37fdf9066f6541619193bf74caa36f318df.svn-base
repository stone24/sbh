//
//  chooseCityViewController.m
//  SBHAPP
//
//  Created by musmile on 14-6-10.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "BeChooseCityViewController.h"
#import "CityData.h"
#import "NSString+Additions.h"
#import "BeRegularExpressionUtil.h"
#import "BeHotelCityManager.h"
#import "AppDelegate.h"

@interface BeChooseCityViewController ()
{
    NSMutableArray *titleArray;
    NSMutableDictionary *dataDict;
    BOOL currentCityEnableSelect;
}
@end
@implementation BeChooseCityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        titleArray = [[NSMutableArray alloc]init];
        dataDict = [[NSMutableDictionary alloc]init];
        _sourceType = kTicketDepartureType;
        currentCityEnableSelect = NO;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    switch (self.sourceType) {
        case kTicketDepartureType:
        {
            self.title = kTicketDepartTitle;
            self.searchPlaceHolder = @"北京/bj/beijing";
        }
            break;
          case kTicketReachType:
        {
            self.title = kTicketReachTitle;
            self.searchPlaceHolder = @"北京/bj/beijing";
        }
            break;
        case kHotelStayType:
        {
            self.title = kHotelStayTitle;
            self.searchPlaceHolder = @"北京/beijing";
        }
            break;
        case kTrainDepartureType:
        {
            self.title = @"出发";
            self.searchPlaceHolder = @"北京/bj/beijing";
        }
            break;
        case kTrainArriveType:
        {
            self.title = @"到达";
            self.searchPlaceHolder = @"北京/bj/beijing";
        }
            break;
        default:
            break;
    }
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [[BeChooseCityUtil sharedInstance]getCityDataWithType:self.sourceType andCallbackData:^(BeChooseCityListItem *listData){
        [dataDict addEntriesFromDictionary:listData.cityDict];
        [titleArray addObjectsFromArray:listData.titleArray];
        [self getCityName];
        [self.tableView reloadData];
    }];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self updateFilterCondition:searchController.searchBar.text];
    BeResultTableController *resultController = (BeResultTableController *)self.baseSearchController.searchResultsController;
    resultController.filteredArray = self.searchResultArray;
    [resultController.tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == self.tableView)
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 22.0)];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, CGRectGetWidth(self.view.bounds), 22.0)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = [titleArray objectAtIndex:section];
        if([[titleArray objectAtIndex:section] isEqualToString:@"当前"])
        {
            titleLabel.text = @"当前城市";
        }
        [view addSubview:titleLabel];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    return nil;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(tableView == self.tableView)
    {
        return titleArray;
    }
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if(tableView == self.tableView)
    {
        return index;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tableView)
    {
        NSString *rowKey = [titleArray objectAtIndex:section];
        NSArray *rowArray = [dataDict objectForKey:rowKey];
        return rowArray.count;
    }
    else if(tableView == self.searchDisplayVC.searchResultsTableView)
    {
        [self updateFilterCondition:self.searchBar.text];
        return self.searchResultArray.count;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView == self.tableView)
    {
        return titleArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    for(UIView *v in [cell subviews])
    {
        if([v isKindOfClass:[UIActivityIndicatorView class]])
        {
            [v removeFromSuperview];
        }
    }
    if(tableView == self.tableView)
    {
        NSString *rowKey = [titleArray objectAtIndex:indexPath.section];
        NSArray *rowArray = [dataDict objectForKey:rowKey];
        CityData * aCity = [rowArray objectAtIndex:indexPath.row];
        cell.textLabel.text = aCity.iCityName;
        if([aCity.iCityName isEqualToString:@"正在定位"])
        {
            UIActivityIndicatorView* activityIndicatorView = [[ UIActivityIndicatorView alloc ]initWithFrame:CGRectMake(100,12.0,20.0,20.0)];
            activityIndicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
            [activityIndicatorView startAnimating];
            [cell addSubview:activityIndicatorView];
        }
        return cell;
    }
   else if(tableView == self.searchDisplayVC.searchResultsTableView)
   {
       CityData * aCity = [self.searchResultArray objectAtIndex:indexPath.row];
       cell.textLabel.text = aCity.iCityName;
       return cell;
   }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableView)
    {
        NSString *sectionTitle = [titleArray  objectAtIndex:section];
        return sectionTitle;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == self.tableView)
    {
        return 22.0;
    }
    return 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CityData * acity = nil;
    if(tableView == self.tableView)
    {
        if(currentCityEnableSelect == NO && indexPath.section == 0)
        {
            return;
        }
        NSString *currentKey = [titleArray objectAtIndex:indexPath.section];
        NSArray *currentCityArray = [dataDict objectForKey:currentKey];
        acity = [currentCityArray objectAtIndex:indexPath.row];
    }
    else if(tableView == self.searchDisplayVC.searchResultsTableView)
    {
        acity = [self.searchResultArray objectAtIndex:indexPath.row];
    }
    if(self.cityBlock)
    {
        self.cityBlock (acity);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)updateFilterCondition:(NSString *)condition
{
    [self.searchResultArray removeAllObjects];
    if([BeRegularExpressionUtil verifyIsChinese:condition])
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"iCityName CONTAINS %@",condition];
        [self filterArrayWithPredicate:predicate];
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"iCityAbbr  BEGINSWITH[cd] %@",condition];
        [self filterArrayWithPredicate:predicate];
        if(self.searchResultArray.count == 0)
        {
            predicate = [NSPredicate predicateWithFormat:@"iCityPinyin BEGINSWITH[cd] %@",condition];
            [self filterArrayWithPredicate:predicate];
        }
        if(self.searchResultArray.count == 0)
        {
            predicate = [NSPredicate predicateWithFormat:@"iCityCode BEGINSWITH[cd] %@",condition];
            [self filterArrayWithPredicate:predicate];
        }
    }
}
- (void)filterArrayWithPredicate:(NSPredicate *)predicate
{
    for(NSString *rowKey in titleArray)
    {
        if(!([rowKey isEqualToString:@"当前"]||[rowKey isEqualToString:@"热门"]))
        {
            NSArray *rowArray = [dataDict objectForKey:rowKey];
            [self.searchResultArray addObjectsFromArray:[rowArray filteredArrayUsingPredicate:predicate]];
        }
    }
}
- (void)getCityName
{
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self addCurrentCityWith:delegate.cityName];
}
- (void)addCurrentCityWith:(NSString *)cityName
{
    if(self.sourceType == kHotelStayType && cityName!=nil &&cityName.length > 0)
    {
        [[BeHotelCityManager sharedInstance]getCityDataWithCityName:cityName andCallback:^(CityData *cityData)
         {
             [dataDict addEntriesFromDictionary:@{@"当前":@[cityData]}];
             [titleArray insertObject:@"当前" atIndex:0];
             currentCityEnableSelect = YES;
         }];
    }
    else if((self.sourceType == kTicketDepartureType|| self.sourceType == kTicketReachType) && cityName!=nil &&cityName.length > 0)
    {
        [[BeChooseCityUtil sharedInstance]getTicketCityWithName:cityName andCallbackData:^(CityData *cityData)
         {
             [dataDict addEntriesFromDictionary:@{@"当前":@[cityData]}];
             [titleArray insertObject:@"当前" atIndex:0];
             currentCityEnableSelect = YES;
         }];
    }
    else if((self.sourceType ==kTrainDepartureType || self.sourceType == kTrainArriveType) && cityName!=nil &&cityName.length > 0)
    {
        [[BeChooseCityUtil sharedInstance]getTrainStationWithName:cityName andCallbackData:^(CityData *cityData)
         {
             [dataDict addEntriesFromDictionary:@{@"当前":@[cityData]}];
             [titleArray insertObject:@"当前" atIndex:0];
             currentCityEnableSelect = YES;
         }];
    }
    else
    {
        CityData *thisCity = [[CityData alloc]init];
        thisCity.iCityName = @"定位失败";
        [dataDict addEntriesFromDictionary:@{@"当前":@[thisCity]}];
        [titleArray insertObject:@"当前" atIndex:0];
        currentCityEnableSelect = NO;
    }
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
