
//
//  BeHotelFilterViewController.m
//  sbh
//  
//  Created by RobinLiu on 15/12/10.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelFilterViewController.h"
#import "BeHotleSearchItemTableViewCell.h"
#import "BeHotelSearchContentCell.h"
#import "ColorUtility.h"
#import "BeHotelCityManager.h"
#import "CommonDefine.h"
#import "FMDatabase.h"
#import "BeBrandModel.h"
#import "BeHotelConditionHeader.h"

@interface BeHotelFilterViewController ()
{
    NSMutableDictionary *dataDict;
    NSArray *titleArray;
    UITableView *searchItemTable;

    NSMutableArray *selectDistrictArray;
    NSMutableArray *selectBusinessArray;
    NSMutableArray *selectBrandArray;
    NSMutableArray *selectFacilityArray;
}

@end

@implementation BeHotelFilterViewController
@synthesize cityId;
- (id)init
{
    if(self = [super init])
    {
        dataDict = [[NSMutableDictionary alloc]init];
        titleArray = @[kBusinessCircleTitle,kDistrictTitle,kBrandTitle,kFacilityTitle];
        selectDistrictArray = [[NSMutableArray alloc]initWithArray:@[KUnlimitedTitle]];
        selectBusinessArray = [[NSMutableArray alloc]initWithArray:@[KUnlimitedTitle]];
        selectBrandArray = [[NSMutableArray alloc]initWithArray:@[KUnlimitedTitle]];
        selectFacilityArray = [[NSMutableArray alloc]initWithArray:@[KUnlimitedTitle]];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.sourceType == HotelFilterSourceTypeFilter)
    {
        self.title = @"筛选";
        titleArray = @[kBrandTitle,kFacilityTitle];
    }
    else
    {
        self.title = @"区域位置";
        titleArray = @[kBusinessCircleTitle,kDistrictTitle];
    }
    searchItemTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    searchItemTable.frame = CGRectMake(0,0,65,kScreenHeight-64-48);
    searchItemTable.backgroundColor = [ColorUtility colorWithRed:215 green:215 blue:215];
    searchItemTable.delegate = self;
    searchItemTable.dataSource = self;
    [self.view addSubview:searchItemTable];
    
    self.tableView.frame = CGRectMake(65, 0, CGRectGetWidth(self.view.bounds)-65, kScreenHeight-64-48);
    self.tableView.backgroundColor = [ColorUtility colorFromHex:0xf6f4f5];
    [self initData];
    [self setConfirmButton];
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
    if(self.filterBlock)
    {
        self.filterBlock(selectBrandArray,selectFacilityArray);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if(self.locationBlock)
    {
        self.locationBlock(selectDistrictArray,selectBusinessArray);
        [self dismissViewControllerAnimated:YES completion:nil];
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
        if([cell.contentLabel.text isEqualToString:kFacilityTitle])
        {
            [self.dataArray addObjectsFromArray:[dataDict objectForKey:kFacilityTitle]];
        }
        [self.tableView reloadData];
    }
    else if(tableView == self.tableView)
    {
        BeHotleSearchItemTableViewCell *searchItemCell = (BeHotleSearchItemTableViewCell *)[searchItemTable cellForRowAtIndexPath:[searchItemTable indexPathForSelectedRow]];
        NSString *titleString = searchItemCell.contentLabel.text;
        
        BeHotelSearchContentCell *cell = (BeHotelSearchContentCell *)[tableView cellForRowAtIndexPath:indexPath];
        NSString *contentLabelText = cell.contentLabel.text;
        if([titleString isEqualToString:kBusinessCircleTitle])
        {
            id object = [self.dataArray objectAtIndex:indexPath.row];
            if([selectBusinessArray count]==1 && [selectBusinessArray containsObject:object])
            {
                return;
            }
            else if([contentLabelText isEqualToString:KUnlimitedTitle])
            {
                [selectBusinessArray removeAllObjects];
                [selectBusinessArray addObject:object];
            }
            else
            {
                if([selectBusinessArray containsObject:KUnlimitedTitle])
                {
                    [selectBusinessArray removeObject:KUnlimitedTitle];
                }
                if([selectBusinessArray containsObject:object])
                {
                    [selectBusinessArray removeObject:object];
                }
                else
                {
                    [selectBusinessArray addObject:object];
                }
            }
        }
        else if([titleString isEqualToString:kDistrictTitle])
        {
            id object = [self.dataArray objectAtIndex:indexPath.row];
            
            if([selectDistrictArray count]==1 && [selectDistrictArray containsObject:object])
            {
                return;
            }
            else if([contentLabelText isEqualToString:KUnlimitedTitle])
            {
                [selectDistrictArray removeAllObjects];
                [selectDistrictArray addObject:object];
            }
            else
            {
                if([selectDistrictArray containsObject:KUnlimitedTitle])
                {
                    [selectDistrictArray removeObject:KUnlimitedTitle];
                }
                if([selectDistrictArray containsObject:object])
                {
                    [selectDistrictArray removeObject:object];
                }
                else
                {
                    [selectDistrictArray addObject:object];
                }
            }
        }
        else if([titleString isEqualToString:kBrandTitle])
        {
            id object = [self.dataArray objectAtIndex:indexPath.row];
            
            if([selectBrandArray count]==1 && [selectBrandArray containsObject:object])
            {
                return;
            }
            else if([contentLabelText isEqualToString:KUnlimitedTitle])
            {
                [selectBrandArray removeAllObjects];
                [selectBrandArray addObject:object];
            }
            else
            {
                if([selectBrandArray containsObject:KUnlimitedTitle])
                {
                    [selectBrandArray removeObject:KUnlimitedTitle];
                }
                if([selectBrandArray containsObject:object])
                {
                    [selectBrandArray removeObject:object];
                }
                else
                {
                    [selectBrandArray addObject:object];
                }
            }
        }
        else if([titleString isEqualToString:kFacilityTitle])
        {
            id object = [self.dataArray objectAtIndex:indexPath.row];
            
            if([selectFacilityArray count]==1 && [selectFacilityArray containsObject:object])
            {
                return;
            }
            else if([contentLabelText isEqualToString:KUnlimitedTitle])
            {
                [selectFacilityArray removeAllObjects];
                [selectFacilityArray addObject:object];
            }
            else
            {
                if([selectFacilityArray containsObject:KUnlimitedTitle])
                {
                    [selectFacilityArray removeObject:KUnlimitedTitle];
                }
                if([selectFacilityArray containsObject:object])
                {
                    [selectFacilityArray removeObject:object];
                }
                else
                {
                    [selectFacilityArray addObject:object];
                }
            }
        }
        [self.tableView reloadData];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == searchItemTable)
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
    if(tableView == searchItemTable)
    {
        static NSString *identifier = @"searchItemTable";
        BeHotleSearchItemTableViewCell *cell = [searchItemTable dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"BeHotleSearchItemTableViewCell" owner:self options:nil] lastObject];
        }
        cell.contentLabel.text = [titleArray objectAtIndex:indexPath.row];
        // cell.unSelectBgColor = [ColorUtility colorFromHex:0xfafafa];
        return cell;
    }
    else if (tableView == self.tableView)
    {
        BeHotleSearchItemTableViewCell *searchItemCell = (BeHotleSearchItemTableViewCell *)[searchItemTable cellForRowAtIndexPath:[searchItemTable indexPathForSelectedRow]];
        NSString *titleString = searchItemCell.contentLabel.text;
        
        BeHotelSearchContentCell *cell = [BeHotelSearchContentCell cellWithTableView:tableView];
        cell.canSelect = NO;
        BOOL selectStatus = NO;
        BOOL isSingleSeletion = NO;
        if([titleString isEqualToString:kBusinessCircleTitle])
        {
            id object = [self.dataArray objectAtIndex:indexPath.row];
            if ([object isKindOfClass:[NSString class]]) {
                cell.contentLabel.text = object;
            }
            else if ([object isKindOfClass:[CityData class]])
            {
                CityData *model =(CityData *)object;
                cell.contentLabel.text = model.businessName;
            }
            for(id member in selectBusinessArray)
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
                    if([cell.contentLabel.text isEqualToString:model.businessName])
                    {
                        selectStatus = YES;
                        break;
                    }
                }
            }
        }
        else if([titleString isEqualToString:kDistrictTitle])
        {
            id object = [self.dataArray objectAtIndex:indexPath.row];
            if ([object isKindOfClass:[NSString class]]) {
                cell.contentLabel.text = object;
            }
            else if ([object isKindOfClass:[CityData class]])
            {
                CityData *model =(CityData *)object;
                cell.contentLabel.text = model.districtName;
            }
            for(id member in selectDistrictArray)
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
                    if([cell.contentLabel.text isEqualToString:model.districtName])
                    {
                        selectStatus = YES;
                        break;
                    }
                }
            }
        }
        else if([titleString isEqualToString:kBrandTitle])
        {
            id object = [self.dataArray objectAtIndex:indexPath.row];
            if ([object isKindOfClass:[NSString class]]) {
                cell.contentLabel.text = object;
            }
            else if ([object isKindOfClass:[BeBrandModel class]])
            {
                BeBrandModel *model =(BeBrandModel *)object;
                cell.contentLabel.text = model.brandName;
            }
            for(id member in selectBrandArray)
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
        }
        else if([titleString isEqualToString:kFacilityTitle])
        {
            id object = [self.dataArray objectAtIndex:indexPath.row];
            if ([object isKindOfClass:[NSString class]]) {
                cell.contentLabel.text = object;
            }
            for(id member in selectFacilityArray)
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
                    else
                    {
                        if([cell.contentLabel.text isEqualToString:member])
                        {
                            selectStatus = YES;
                            break;
                        }
                    }
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
    
    [dataDict setObject:@[KUnlimitedTitle,kFacilityCondition1,kFacilityCondition2,kFacilityCondition3,kFacilityCondition4,kFacilityCondition5] forKey:kFacilityTitle];
    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [searchItemTable selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self tableView:searchItemTable didSelectRowAtIndexPath:firstPath];
}
- (void)updateUIWithDistrict:(NSMutableArray *)selectDistrictA andBussiness:(NSMutableArray *)selectBussinessA
{
    if(selectDistrictA !=nil && selectDistrictA.count > 0)
    {
        [selectDistrictArray removeAllObjects];
        [selectDistrictArray addObjectsFromArray:selectDistrictA];
    }
    if(selectBussinessA !=nil && selectBussinessA.count > 0)
    {
        [selectBusinessArray removeAllObjects];
        [selectBusinessArray addObjectsFromArray:selectBussinessA];
    }
}
- (void)updateUIWithBrand:(NSMutableArray *)selectBrand andFacility:(NSMutableArray *)selectFacility
{
    if(selectBrand !=nil && selectBrand.count > 0)
    {
        [selectBrandArray removeAllObjects];
        [selectBrandArray addObjectsFromArray:selectBrand];
    }
    if(selectFacility !=nil && selectFacility.count > 0)
    {
        [selectFacilityArray removeAllObjects];
        [selectFacilityArray addObjectsFromArray:selectFacility];
    }
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
