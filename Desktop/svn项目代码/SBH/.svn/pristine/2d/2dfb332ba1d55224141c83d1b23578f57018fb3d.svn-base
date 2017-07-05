//
//  BeHotelListViewController.m
//  SideBenefit
//
//  Created by RobinLiu on 15/3/11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelListViewController.h"
#import "BeHotelListTableViewCell.h"
#import "BeHotelListTabView.h"
#import "BeHotelServer.h"
#import "BeHotelDetailController.h"
#import "BeHotelListRequestModel.h"
#import "BeHotelListModel.h"
#import "BeHotelListItem.h"
#import "MJRefresh.h"
#import "ServerFactory.h"
#import "BeHotelCityManager.h"
#import "BeHotelFilterViewController.h"
#import "BeHotelPriceSelectView.h"
#import "BeHotelSortPickView.h"
#import "BeHotelConditionHeader.h"

#define kHotelPlaceHolder @"关键字/位置/酒店名"

@interface BeHotelListViewController ()<UISearchBarDelegate>
{
    UISearchBar *hotelSearchBar;
    BeHotelListTabView *listTabView;
    BOOL isFilter;//是否正在筛选
    NSMutableArray *filterData;
}
@property (nonatomic,retain)BeHotelListModel *listData;
@end

@implementation BeHotelListViewController
@synthesize requestModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isFilter = NO;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"top_right_index"] style:UIBarButtonItemStylePlain target:self action:@selector(backMainBtn)];
    }
    return self;
}

- (void)backMainBtn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)leftMenuClick
{
    self.block();
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HotelClearAllCondition" object:nil];
    [super leftMenuClick];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 友盟统计
    [MobClick beginEvent:@"H0002"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"酒店列表";
    filterData = [[NSMutableArray alloc]init];
    
    float height = CGRectGetHeight(self.view.bounds)-CGRectGetHeight(self.navigationController.navigationBar.frame)-CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)-CGRectGetHeight(self.navigationController.tabBarController.tabBar.frame);
    listTabView = [[BeHotelListTabView alloc]initWithFrame:CGRectMake(0,height, CGRectGetWidth(self.view.bounds),CGRectGetHeight(self.navigationController.tabBarController.tabBar.frame))];
    [self.view addSubview:listTabView];
    [listTabView addTarget:self andAreaAction:@selector(selectArea) andPriceAction:@selector(selectPrice) andSortAction:@selector(selectSort) andFilterAction:@selector(filterAction)];
    CGRect frame = self.tableView.frame;
    frame.size.height = height;
    self.tableView.frame = frame;
    
    hotelSearchBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
    hotelSearchBar.delegate = self;
    hotelSearchBar.placeholder = kHotelPlaceHolder;
    [hotelSearchBar sizeToFit];
    self.tableView.tableHeaderView = hotelSearchBar;
    self.listData = [[BeHotelListModel alloc]initConfigure];
    self.requestModel.pagenum = 1;
    [self getDataFromServer];
}
- (void)selectArea
{
    BeHotelFilterViewController *filterVC = [[BeHotelFilterViewController alloc]init];
    filterVC.cityId = self.requestModel.cityItem.cityId;
    filterVC.sourceType = HotelFilterSourceTypeLocation;
    [filterVC updateUIWithDistrict:self.requestModel.districtArray andBussiness:self.requestModel.bussinessArray];
    filterVC.locationBlock = ^(NSMutableArray *selectDistrictA,NSMutableArray *selectBussinessA)
    {
        if([self.requestModel isCanFilterWithDistrictArray:selectDistrictA andBussinessArray:selectBussinessA])
        {
            [self.requestModel.districtArray removeAllObjects];
            [self.requestModel.districtArray addObjectsFromArray:selectDistrictA];
            [self.requestModel.bussinessArray removeAllObjects];
            [self.requestModel.bussinessArray addObjectsFromArray:selectBussinessA];
            [self refreshAction];
        }
        else
        {
            return ;
        }
    };
    SBHNavigationController *filterNC = [[SBHNavigationController alloc]initWithRootViewController:filterVC];
    [self.navigationController presentViewController:filterNC animated:YES completion:nil];
}
- (void)selectPrice
{
    [[BeHotelPriceSelectView sharedInstance]showViewWithPriceArray:self.requestModel.priceArrayCondition andStarArray:self.requestModel.starArrayCondition andBlock:^(NSMutableArray *selectPriceA,NSMutableArray *selectStarA){
        if([self.requestModel isCanFilterWithPriceArray:selectPriceA andStarArray:selectStarA])
        {
            [self.requestModel.priceArrayCondition removeAllObjects];
            [self.requestModel.priceArrayCondition addObjectsFromArray:selectPriceA];
            
            [self.requestModel.starArrayCondition removeAllObjects];
            [self.requestModel.starArrayCondition addObjectsFromArray:selectStarA];
            [self refreshAction];
        }
        else
        {
            return ;
        }
    }];
}
- (void)selectSort
{
    [[BeHotelSortPickView sharedInstance]showViewWithCondition:self.requestModel.sortCondition andBlock:^(NSString *selectCondition)
    {
        if([self.requestModel.sortCondition isEqualToString: selectCondition])
        {
            return;
        }
        self.requestModel.sortCondition = selectCondition;
        [self refreshAction];
    }];
}
- (void)filterAction
{
    BeHotelFilterViewController *filterVC = [[BeHotelFilterViewController alloc]init];
    filterVC.cityId = self.requestModel.cityItem.cityId;
    filterVC.sourceType = HotelFilterSourceTypeFilter;
    [filterVC updateUIWithBrand:self.requestModel.brandArray andFacility:self.requestModel.facilityArray];
    filterVC.filterBlock = ^(NSMutableArray *selectBrandA,NSMutableArray *selectFacilityA)
    {
        if([self.requestModel isCanFilterWithBrandArray:selectBrandA andFacilityArray:selectFacilityA] == YES)
        {
            [self.requestModel.brandArray removeAllObjects];
            [self.requestModel.brandArray addObjectsFromArray:selectBrandA];
            [self.requestModel.facilityArray removeAllObjects];
            [self.requestModel.facilityArray addObjectsFromArray:selectFacilityA];
            [self refreshAction];
        }
        else
        {
            return;
        }
    };
    SBHNavigationController *filterNC = [[SBHNavigationController alloc]initWithRootViewController:filterVC];
    [self.navigationController presentViewController:filterNC animated:YES completion:nil];
}
#pragma mark - TableViewDelegate&&Datasource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     BeHotelDetailController *detailVC = [[BeHotelDetailController alloc]init];
    if(isFilter == YES)
    {
        BeHotelListItem *item = [filterData objectAtIndex:indexPath.row];
       /**
        * 搜索的类型  关键字接口 1名称 2商圈 3品牌
        */
        if([item.SearchType isEqualToString:@"2"])
        {
            [self.requestModel.bussinessArray removeAllObjects];
            CityData *zoneModel = [[CityData alloc]init];
            zoneModel.businessId = [item.hotelId mutableCopy];
            [self.requestModel.bussinessArray addObject:zoneModel];

            [self refreshAction];
            return;
        }
        else if ([item.SearchType isEqualToString:@"3"])
        {
            [self.requestModel.brandArray removeAllObjects];
            BeBrandModel *brandModel = [[BeBrandModel alloc]init];
            brandModel.brandCode = [item.hotelId mutableCopy];
            [self.requestModel.brandArray addObject:brandModel];
            [hotelSearchBar resignFirstResponder];
            [self refreshAction];
            return;
        }
        else
        {
            detailVC.item = [filterData objectAtIndex:indexPath.row];
            detailVC.item.cityId = [self.requestModel.cityItem.cityId mutableCopy];
            NSString *checkInDateString = [CommonMethod stringFromDate:self.requestModel.sdate WithParseStr:kFormatYYYYMMDD];
            NSString *checkOutDateString = [CommonMethod stringFromDate:self.requestModel.edate WithParseStr:kFormatYYYYMMDD];
            detailVC.item.CheckInDate = checkInDateString;
            detailVC.item.CheckOutDate = checkOutDateString;
            detailVC.item.cityName = [self.requestModel.cityItem.iCityName mutableCopy];
        }
    }
    else
    {
        detailVC.item = [self.listData.dataArray objectAtIndex:indexPath.row];
    }
    detailVC.sourceType = HotelDetailSourceTypeHotelList;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isFilter == YES)
    {
        /*NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(hotelName CONTAINS[cd] %@) OR (hotelAddress CONTAINS[cd] %@) OR (addressAdditional CONTAINS[cd] %@) OR (cityName CONTAINS[cd] %@) ",searchDC.searchBar.text,searchDC.searchBar.text,searchDC.searchBar.text,searchDC.searchBar.text];
        [filterData removeAllObjects];
        [filterData addObjectsFromArray: [self.listData.dataArray filteredArrayUsingPredicate:predicate]];*/
        return filterData.count;
    }
    return self.listData.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(isFilter == YES)
    {
        return 0.001;
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 5)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isFilter == YES)
    {
        return 44.0;
    }
    return [BeHotelListTableViewCell cellHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isFilter == YES)
    {
        BeHotelListItem *item = [filterData objectAtIndex:indexPath.row];

       /* BeHotelListTableViewCell *cell = [BeHotelListTableViewCell cellWithTableView:tableView];
        [cell setCellWith:item];*/
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.text = item.hotelName;
        if([item.SearchType isEqualToString:@"2"])
        {
            //商圈
            cell.detailTextLabel.text = @"商圈";

        }
        else if([item.SearchType isEqualToString:@"3"])
        {
            //品牌
            cell.detailTextLabel.text = @"品牌";
        }
        else
        {
            cell.detailTextLabel.text = @"";
        }
        return cell;
    }
    else
    {
        BeHotelListTableViewCell *cell = [BeHotelListTableViewCell cellWithTableView:tableView];
        BeHotelListItem *item = [self.listData.dataArray objectAtIndex:indexPath.row];
        [cell setCellWith:item];
        return cell;
    }
    return nil;
}
#pragma mark - GetData
- (void)getDataFromServer
{
   [[ServerFactory getServerInstance:@"BeHotelServer"]doGetHotelListWith:self.requestModel andCallback:^(NSMutableDictionary *callback)
     {
         [self endRefresh];
         NSString *checkInDateString = [CommonMethod stringFromDate:self.requestModel.sdate WithParseStr:kFormatYYYYMMDD];
         NSString *checkOutDateString = [CommonMethod stringFromDate:self.requestModel.edate WithParseStr:kFormatYYYYMMDD];

         [self.listData setListModelWithDict:callback andCityName:self.requestModel.cityItem.iCityName andCheckInDate:checkInDateString andCheckOutDate:checkOutDateString];
         [self.requestModel updateRequestModelWith:self.listData];
         self.title = [NSString stringWithFormat:@"%@酒店（%zd家）",self.requestModel.cityItem.iCityName,self.listData.totalCount];
         [self searchBarCancelButtonClicked:hotelSearchBar];
     }failureCallback:^(NSString *error)
     {
         [self handleResuetCode:error];
         [self endRefresh];
     }];
}
- (void)endRefresh
{
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
}
- (void)addMoreAction
{
    if(self.requestModel.hasMore == YES)
    {
        self.requestModel.pagenum ++;
        [self getDataFromServer];
    }
    else
    {
        [self endRefresh];
    }
}
- (void)refreshAction
{
    self.requestModel.pagenum = 1;
    self.requestModel.pageCount = @"1";
    [self getDataFromServer];
}
#pragma mark - 搜索
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    [searchBar setShowsCancelButton:NO animated:YES];
   // searchBar.text = @"";
    isFilter = NO;
    [filterData removeAllObjects];
    [self.tableView reloadData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMoreAction)];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.tableView.mj_header removeFromSuperview];
    [self.tableView.mj_footer removeFromSuperview];
    [searchBar setShowsCancelButton:YES animated:YES];
    isFilter = YES;
    if(searchBar.text == 0)
    {
        return;
    }
    [[ServerFactory getServerInstance:@"BeHotelServer"]searchHotelWith:self.requestModel.cityItem.cityId andKeyword:searchBar.text byCallback:^(NSMutableArray *callback)
     {
         [filterData removeAllObjects];
         [filterData addObjectsFromArray:callback];
         [self.tableView reloadData];
     }failureCallback:^(NSError *failure)
     {
        // [self handleResuetCode:callback];
         //[self endRefresh];
     }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
