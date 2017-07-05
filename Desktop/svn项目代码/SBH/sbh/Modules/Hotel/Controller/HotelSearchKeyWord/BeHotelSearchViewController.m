//
//  BeHotelSearchViewController.m
//  SideBenefit
//
//  Created by RobinLiu on 15/3/11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelSearchViewController.h"
#import "BeHotleSearchItemTableViewCell.h"
#import "BeHotelSearchContentCell.h"
#import "ColorUtility.h"
#import "BeHotelCityManager.h"
#import "CommonDefine.h"
#import "FMDatabase.h"
#import "BeBrandModel.h"

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

@interface BeHotelSearchViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>
{
    UISearchBar *searchBar;
    UITableView *searchItemTable;
    NSMutableDictionary *dataDict;
    NSMutableArray *filterData;
    NSArray *titleArray;
    
    NSMutableArray *selectDistrictArray;
    NSMutableArray *selectBusinessArray;
    NSMutableArray *selectBrandArray;
    NSString *keyword;
    
    UITableView *searchResultTableView;
}

@end

@implementation BeHotelSearchViewController
@synthesize cityId;
- (id)init
{
    if(self = [super init])
    {
        filterData = [[NSMutableArray alloc]init];
        dataDict = [[NSMutableDictionary alloc]init];
        keyword = [[NSString alloc]init];
        titleArray = @[kBusinessCircleTitle,kDistrictTitle,kBrandTitle];
        selectDistrictArray = [[NSMutableArray alloc]initWithArray:@[KUnlimitedTitle]];
        selectBusinessArray = [[NSMutableArray alloc]initWithArray:@[KUnlimitedTitle]];
        selectBrandArray = [[NSMutableArray alloc]initWithArray:@[KUnlimitedTitle]];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关键字";
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
    searchBar.delegate = self;
    searchBar.placeholder = kHotelSearchPlaceHolder;
    [searchBar sizeToFit];
    [self.view addSubview:searchBar];

    searchItemTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    searchItemTable.frame = CGRectMake(0, CGRectGetHeight(searchBar.frame), 65, CGRectGetHeight(self.view.bounds));
    searchItemTable.backgroundColor = [ColorUtility colorWithRed:215 green:215 blue:215];
    searchItemTable.delegate = self;
    searchItemTable.dataSource = self;
    [self.view addSubview:searchItemTable];
    
    self.tableView.frame = CGRectMake(65, CGRectGetHeight(searchBar.frame), CGRectGetWidth(self.view.bounds)-65, CGRectGetHeight(self.view.bounds)-CGRectGetHeight(searchBar.frame)-CGRectGetHeight(self.navigationController.navigationBar.frame)-CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)-48);
    self.tableView.backgroundColor = [ColorUtility colorFromHex:0xf6f4f5];
    [self setConfirmButton];
    searchResultTableView = [[UITableView alloc]initWithFrame: CGRectMake(0, CGRectGetHeight(searchBar.frame), kScreenWidth, kScreenHeight-CGRectGetHeight(searchBar.frame)-64) style:UITableViewStylePlain];
    searchResultTableView.delegate = self;
    searchResultTableView.dataSource = self;
    [self.view addSubview:searchResultTableView];
    searchResultTableView.hidden = YES;
    [self initData];
}
- (void)setConfirmButton
{
    UIView *tabView = [[UIView alloc]initWithFrame:CGRectMake(0, self.tableView.height + self.tableView.y, kScreenWidth, 48)];
    tabView.backgroundColor = [ColorUtility colorFromHex:0xf6f4f5];
    [self.view addSubview:tabView];
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setBackgroundColor:[ColorConfigure loginButtonColor]];
    [confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
    confirmButton.frame = CGRectMake(13, 8, kScreenWidth - 26, 32);
    confirmButton.layer.cornerRadius = 3.0f;
    [tabView addSubview:confirmButton];
}
- (void)confirmAction
{
    if(self.searchBlock)
    {
        self.searchBlock(selectDistrictArray,selectBusinessArray,selectBrandArray,keyword);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - TableViewDelegate&&Datasource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == searchItemTable)
    {
        BeHotleSearchItemTableViewCell *cell = (BeHotleSearchItemTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self.dataArray removeAllObjects];
        if([cell.contentLabel.text isEqualToString:kBusinessCircleTitle])
        {
            [self.dataArray addObjectsFromArray:[dataDict objectForKey:kBusinessCircleTitle]];
        }
        if([cell.contentLabel.text isEqualToString:kDistrictTitle])
        {
            [self.dataArray addObjectsFromArray:[dataDict objectForKey:kDistrictTitle]];
        }
        if([cell.contentLabel.text isEqualToString:kBrandTitle])
        {
            [self.dataArray addObjectsFromArray:[dataDict objectForKey:kBrandTitle]];
        }
        [self.tableView reloadData];
    }
    else if(tableView == self.tableView)
    {
        BeHotelSearchContentCell *cell = (BeHotelSearchContentCell *)[tableView cellForRowAtIndexPath:indexPath];
         NSString *contentLabelText = cell.contentLabel.text;
        id model = [self.dataArray objectAtIndex:indexPath.row];
        BOOL isContain = NO;
        NSUInteger memberIndex = 0;
        NSMutableArray *tempArray;
        if([searchItemTable indexPathForSelectedRow].row == 0)
        {
            tempArray = selectBusinessArray;
        }
        else if ([searchItemTable indexPathForSelectedRow].row == 1)
        {
            tempArray = selectDistrictArray;
        }
        else if ([searchItemTable indexPathForSelectedRow].row == 2)
        {
            tempArray = selectBrandArray;
        }
        for(id member in tempArray)
        {
            if([member isKindOfClass:[NSString class]] && [model isKindOfClass:[NSString class]])
            {
                isContain = YES;
                break;
            }
            else if ([member isKindOfClass:[CityData class]]&& [model isKindOfClass:[CityData class]])
            {
                CityData *cityMember = (CityData *)member;
                CityData *cityModel = (CityData *)model;
                if(cityMember.businessName.length > 0 && cityModel.businessName.length > 0)
                {
                    if([cityMember.businessName isEqualToString:cityModel.businessName])
                       {
                           isContain = YES;
                           memberIndex = [tempArray indexOfObject:member];
                           break;
                       }
                }
                else if(cityMember.districtName.length > 0 && cityModel.districtName.length > 0)
                {
                    if([cityMember.districtName isEqualToString:cityModel.districtName])
                    {
                        isContain = YES;
                        memberIndex = [tempArray indexOfObject:member];
                        break;
                    }
                }
            }
            else if ([member isKindOfClass:[BeBrandModel class]]&& [model isKindOfClass:[BeBrandModel class]])
            {
                BeBrandModel *cityMember = (BeBrandModel *)member;
                BeBrandModel *cityModel = (BeBrandModel *)model;
                if([cityMember.brandName isEqualToString:cityModel.brandName])
                {
                    isContain = YES;
                    memberIndex = [tempArray indexOfObject:member];
                    break;
                }
            }
        }
        if([tempArray count]==1 && isContain)
        {
            return;
        }
        else if([contentLabelText isEqualToString:KUnlimitedTitle])
        {
            [tempArray removeAllObjects];
            [tempArray addObject:KUnlimitedTitle];
        }
        else
        {
            if([tempArray containsObject:KUnlimitedTitle])
            {
                [tempArray removeObject:KUnlimitedTitle];
            }
            if(isContain)
            {
                [tempArray removeObjectAtIndex:memberIndex];
            }
            else
            {
                [tempArray addObject:model];
            }
        }
        [self.tableView reloadData];
    }
    else if (tableView == searchResultTableView)
    {
        BeHotelListItem *item = [filterData objectAtIndex:indexPath.row];
        if([item.SearchType isEqualToString:@"2"])
        {
            //商圈
            if(self.searchBlock)
            {
                CityData *city = [[CityData alloc]init];
                city.businessId = [item.hotelId mutableCopy];
                city.cityId =[[BeHotelListRequestModel sharedInstance].cityItem.cityId mutableCopy];
                city.businessName = [item.hotelName mutableCopy];
                self.searchBlock((NSMutableArray *)@[],(NSMutableArray *)@[city],(NSMutableArray *)@[],@"");
                [self.navigationController popViewControllerAnimated:YES];
            }

        }
        else if([item.SearchType isEqualToString:@"3"])
        {
            //品牌
            if(self.searchBlock)
            {
                BeBrandModel *brand = [[BeBrandModel alloc]init];
                brand.brandCode = [item.hotelId mutableCopy];
                brand.brandName = [item.hotelName mutableCopy];
                self.searchBlock((NSMutableArray *)@[],(NSMutableArray *)@[],(NSMutableArray *)@[brand],@"");
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            //酒店
            BeHotelDetailController *detailVC = [[BeHotelDetailController alloc]init];
            detailVC.item = [filterData objectAtIndex:indexPath.row];
            detailVC.item.cityId = [[BeHotelListRequestModel sharedInstance].cityItem.cityId mutableCopy];
            NSString *checkInDateString = [CommonMethod stringFromDate:[BeHotelListRequestModel sharedInstance].sdate WithParseStr:kFormatYYYYMMDD];
            NSString *checkOutDateString = [CommonMethod stringFromDate:[BeHotelListRequestModel sharedInstance].edate WithParseStr:kFormatYYYYMMDD];
            detailVC.item.CheckInDate = checkInDateString;
            detailVC.item.CheckOutDate = checkOutDateString;
            detailVC.item.cityName = [[BeHotelListRequestModel sharedInstance].cityItem.iCityName mutableCopy];
            detailVC.sourceType = HotelDetailSourceTypeHotelList;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == searchResultTableView)
    {
        return filterData.count;
    }
    else if(tableView == searchItemTable)
    {
        return titleArray.count;
    }
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == searchResultTableView)
    {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        BeHotelListItem *item = [filterData objectAtIndex:indexPath.row];
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
    else if(tableView == searchItemTable)
    {
        BeHotleSearchItemTableViewCell *cell = [BeHotleSearchItemTableViewCell cellWithTableView:tableView];
        cell.contentLabel.text = [titleArray objectAtIndex:indexPath.row];
        return cell;
    }
    else if (tableView == self.tableView)
    {
        BeHotelSearchContentCell *cell = [BeHotelSearchContentCell cellWithTableView:tableView];
        id object = [self.dataArray objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[NSString class]]) {
            cell.contentLabel.text = object;
        }
        else if ([object isKindOfClass:[CityData class]])
        {
            CityData *model =(CityData *)object;
            if(model.businessName.length > 0)
            {
                cell.contentLabel.text = model.businessName;
            }
            else if (model.districtName.length > 0)
            {
                cell.contentLabel.text = model.districtName;
            }
        }
        else if ([object isKindOfClass:[BeBrandModel class]])
        {
            BeBrandModel *model =(BeBrandModel *)object;
            cell.contentLabel.text = model.brandName;
        }
        cell.canSelect = NO;
        BOOL selectStatus = NO;
        BOOL isSingleSeletion = NO;
        NSMutableArray *tempArray;
        if([searchItemTable indexPathForSelectedRow].row == 0)
        {
            tempArray = selectBusinessArray;
        }
        else if ([searchItemTable indexPathForSelectedRow].row == 1)
        {
            tempArray = selectDistrictArray;
        }
        else if ([searchItemTable indexPathForSelectedRow].row == 2)
        {
            tempArray = selectBrandArray;
        }
        for(id member in tempArray)
        {
            if([member isKindOfClass:[NSString class]])
            {
                if([member isEqualToString:KUnlimitedTitle])
                {
                    if([cell.contentLabel.text isEqualToString:KUnlimitedTitle])
                    {
                        selectStatus = YES;
                        isSingleSeletion = YES;
                        break;
                    }
                }
            }
            else if([member isKindOfClass:[CityData class]])
            {
                CityData *model =(CityData *)member;
                if([cell.contentLabel.text isEqualToString:model.businessName] && model.businessName.length > 0)
                {
                    selectStatus = YES;
                    break;
                }
                else if([cell.contentLabel.text isEqualToString:model.districtName] && model.districtName.length > 0)
                {
                    selectStatus = YES;
                    break;
                }
            }
            else if([member isKindOfClass:[BeBrandModel class]])
            {
                BeBrandModel *model =(BeBrandModel *)member;
                if([cell.contentLabel.text isEqualToString:model.brandName])
                {
                    selectStatus = YES;
                    break;
                }
            }
        }
        if(selectStatus == YES)
        {
            if(isSingleSeletion)
            {
                [cell setSingleSelectionImage];
            }
            else
            {
                [cell setCheckBoxImage];
            }
        }
        else
        {
            [cell setUnselectionImage];
        }
        return cell;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initData
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"xUtils" ofType:@"db"];
    FMDatabase *db= [FMDatabase databaseWithPath:filePath];
    if ([db open])
    {
        NSString * sqReq = [NSString stringWithFormat:@"select * from B_Code_DistrictInfo where City_Code = '%@'  order by Dis_Code ASC",cityId];
        FMResultSet *rs = [db executeQuery:sqReq];
        NSMutableArray *districtArray = [[NSMutableArray alloc]init];
        [districtArray addObject:KUnlimitedTitle];
        while ([rs next])
        {
            CityData *city = [[CityData alloc]init];
            city.districtName = [rs stringForColumn:@"Dis_Name"];
            city.districtId = [rs stringForColumn:@"Dis_Code"];
            city.cityId = [rs stringForColumn:@"City_Code"];
            [districtArray addObject:city];
        }
        [dataDict setObject:districtArray forKey:kDistrictTitle];

        sqReq = [NSString stringWithFormat:@"select * from B_Code_ZoneInfo where City_Code = '%@'  order by Zone_Code ASC",cityId];
        rs = [db executeQuery:sqReq];
        NSMutableArray *businessArray = [[NSMutableArray alloc]init];
        [businessArray addObject:KUnlimitedTitle];
        while ([rs next])
        {
             CityData *city = [[CityData alloc]init];
             city.businessId = [rs stringForColumn:@"Zone_Code"];
             city.cityId = [rs stringForColumn:@"City_Code"];
             city.businessName = [rs stringForColumn:@"Zone_Name"];
             [businessArray addObject:city];
        }
        [dataDict setObject:businessArray forKey:kBusinessCircleTitle];
        
        sqReq = @"select * from B_Code_BrandInfo order by Brand_Code ASC";
        rs = [db executeQuery:sqReq];
        NSMutableArray *brandArray = [[NSMutableArray alloc]init];
        [brandArray addObject:KUnlimitedTitle];
        while ([rs next])
        {
            BeBrandModel *brand = [[BeBrandModel alloc]init];
            brand.brandCode = [rs stringForColumn:@"Brand_Code"];
            brand.brandName = [rs stringForColumn:@"Brand_Name"];
            [brandArray addObject:brand];
        }
        [dataDict setObject:brandArray forKey:kBrandTitle];
    }
    [db close];
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[dataDict objectForKey:kBusinessCircleTitle]];
    [self.tableView reloadData];
    
    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [searchItemTable selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
}
- (void)updateWithDistrict:(NSMutableArray *)districtA andBussiness:(NSMutableArray *)bussinessA andBrand:(NSMutableArray *)brandA
{
    if(districtA !=nil && districtA.count > 0)
    {
        [selectDistrictArray removeAllObjects];
        [selectDistrictArray addObjectsFromArray:districtA];
    }
    if(bussinessA !=nil && bussinessA.count > 0)
    {
        [selectBusinessArray removeAllObjects];
        [selectBusinessArray addObjectsFromArray:bussinessA];
    }
    if(brandA !=nil && brandA.count > 0)
    {
        [selectBrandArray removeAllObjects];
        [selectBrandArray addObjectsFromArray:brandA];
    }
}
#pragma mark - 搜索
- (void)searchBarCancelButtonClicked:(UISearchBar *)beSearchBar
{
    [self.view endEditing:YES];
    [beSearchBar setShowsCancelButton:NO animated:YES];
    [filterData removeAllObjects];
    searchResultTableView.hidden = YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
}
- (void)searchBar:(UISearchBar *)beSearchBar textDidChange:(NSString *)searchText
{
    searchResultTableView.hidden = NO;
    [beSearchBar setShowsCancelButton:YES animated:YES];
    NSLog(@"searchBar = %@",searchBar.text);
    if(searchBar.text == 0)
    {
        return;
    }
    [[ServerFactory getServerInstance:@"BeHotelServer"]searchHotelWith:[BeHotelListRequestModel sharedInstance].cityItem.cityId andKeyword:searchBar.text byCallback:^(NSMutableArray *callback)
     {
         [filterData removeAllObjects];
         [filterData addObjectsFromArray:callback];
         [searchResultTableView reloadData];
     }failureCallback:^(NSError *failure)
     {
         // [self handleResuetCode:callback];
         //[self endRefresh];
     }];
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
