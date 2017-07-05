//
//  BeSpecialCarCityViewController.m
//  sbh
//
//  Created by RobinLiu on 16/1/5.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeSpecialCarCityViewController.h"
#import "ServerFactory.h"
#import "BeMapServer.h"
#import "NSString+Additions.h"
#import "BeRegularExpressionUtil.h"
#import "ChineseToPinyin.h"

@interface BeSpecialCarCityViewController ()
{
    NSMutableDictionary *cityDict;
}

@end

@implementation BeSpecialCarCityViewController
- (void)setCityListArray:(NSMutableArray *)cityListArray
{
    _cityListArray = [[NSMutableArray alloc]init];
    [_cityListArray addObjectsFromArray:cityListArray];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    cityDict = [[NSMutableDictionary alloc]init];
    if(self.currentCityModel != nil)
    {
        [self.tableTitleArray addObject:@"当前"];
        [cityDict setObject:@[self.currentCityModel]forKey:@"当前"];
    }
    self.title = @"出发城市";
    self.searchPlaceHolder = @"北京/bj/beijing";
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self getCityData];
    // Do any additional setup after loading the view.
}
- (void)getCityData
{
    NSArray *titleCharacterArray = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    
    for(NSString *titleString in titleCharacterArray)
    {
        NSMutableArray *memberArray = [NSMutableArray array];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pinyin  BEGINSWITH[cd] %@",titleString];
        [memberArray addObjectsFromArray:[self.cityListArray filteredArrayUsingPredicate:predicate]];
        if(memberArray.count > 0)
        {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pinyin" ascending:YES];
            [memberArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            [cityDict setObject:memberArray forKey:titleString];
            [self.tableTitleArray addObject:titleString];
        }
    }
    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self.tableView)
    {
        return self.tableTitleArray.count;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tableView)
    {
        return [[cityDict objectForKey:[self.tableTitleArray objectAtIndex:section]] count];
    }
    else if (tableView == self.searchDisplayVC.searchResultsTableView)
    {
        [self updateFilterCondition:self.searchBar.text];
        return self.searchResultArray.count;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if(tableView == self.tableView)
    {
        NSArray *sectionArray = [cityDict objectForKey:[self.tableTitleArray objectAtIndex:indexPath.section]];
        BeSpeCityModel *model = [sectionArray objectAtIndex:indexPath.row];
        cell.textLabel.text = model.cityName;
    }
    else if(tableView == self.searchDisplayVC.searchResultsTableView)
    {
        BeSpeCityModel *model = [self.searchResultArray objectAtIndex:indexPath.row];
        cell.textLabel.text = model.cityName;
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == self.tableView)
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 22.0)];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, CGRectGetWidth(self.view.bounds), 22.0)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = [self.tableTitleArray objectAtIndex:section];
        [view addSubview:titleLabel];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableView)
    {
        NSString *sectionTitle = [self.tableTitleArray  objectAtIndex:section];
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(![cell.textLabel.text isEqualToString:@"定位失败"])
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@",self.currentCityModel.cityName];
        if ([predicate evaluateWithObject:cell.textLabel.text]) {
           //选择的是当前的城市
            if(self.block)
            {
                self.block(self.currentCityModel);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            if(tableView == self.tableView)
            {
                if(self.block)
                {
                    self.block([[cityDict objectForKey:[self.tableTitleArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]);
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            else if (tableView == self.searchDisplayVC.searchResultsTableView)
            {
                if(self.block)
                {
                    self.block([self.searchResultArray objectAtIndex:indexPath.row]);
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
    }
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(tableView == self.tableView)
    {
        return self.tableTitleArray;
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
- (void)updateFilterCondition:(NSString *)condition
{
    [self.searchResultArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityName CONTAINS %@ OR cityCode BEGINSWITH[cd] %@ OR pinyin  BEGINSWITH[cd] %@",condition,condition,condition];
    [self.searchResultArray addObjectsFromArray:[self.cityListArray filteredArrayUsingPredicate:predicate]];
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
