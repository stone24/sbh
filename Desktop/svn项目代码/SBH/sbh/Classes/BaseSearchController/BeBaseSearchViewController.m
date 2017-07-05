//
//  BeBaseSearchViewController.m
//  sbh
//
//  Created by liuxiaodan on 15-4-29.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "BeBaseSearchViewController.h"
#import "CommonDefine.h"
#import "BeBaseModel.h"
#import "BeResultTableController.h"

@interface BeBaseSearchViewController ()<UISearchBarDelegate,UISearchControllerDelegate,UISearchDisplayDelegate,UISearchResultsUpdating>
{
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayVC;
    UISearchController *baseSearchController;
}

@end

@implementation BeBaseSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isSearchBarFixed = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (kIs_iOS7)
    {
        searchBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
        searchBar.delegate = self;
        [searchBar sizeToFit];
        searchDisplayVC = [[UISearchDisplayController alloc]initWithSearchBar:searchBar contentsController:self];
        searchDisplayVC.delegate = self;
        searchDisplayVC.searchResultsDataSource = self;
        searchDisplayVC.searchResultsDelegate = self;
        if(_isSearchBarFixed)
        {
            [self.view addSubview:searchBar];
            self.tableView.y = searchBar.height;
            self.tableView.height = self.tableView.height - searchBar.height;
        }
        else
        {
            self.tableView.tableHeaderView = searchBar;
        }
    }
    else
    {
        BeResultTableController *resultVC = [[BeResultTableController alloc]init];
        baseSearchController = [[UISearchController alloc]initWithSearchResultsController:resultVC];
        baseSearchController.dimsBackgroundDuringPresentation = NO;
        [baseSearchController.searchBar sizeToFit];
        baseSearchController.searchResultsUpdater = self;
        if(_isSearchBarFixed)
        {
            [self.view addSubview:baseSearchController.searchBar];
            self.tableView.y = baseSearchController.searchBar.height;
            self.tableView.height = self.tableView.height - baseSearchController.searchBar.height;
        }
        else
        {
            self.tableView.tableHeaderView = baseSearchController.searchBar;
        }
    }
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(searchControllerUpdateCondition:)])
    {
        [self.delegate searchControllerUpdateCondition:searchController.searchBar.text];
    }
    BeResultTableController *tableController = (BeResultTableController *)searchController.searchResultsController;
    tableController.filteredArray = self.searchResultArray;
    [tableController.tableView reloadData];
}
- (void)updateSelectionConditions
{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == searchDisplayVC.searchResultsTableView)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(searchControllerUpdateCondition:)])
        {
            [self.delegate searchControllerUpdateCondition:searchBar.text];
        }
        return self.searchResultArray.count;
    }
    if(tableView == self.tableView)
    {
        return self.tableArray.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if(tableView == self.tableView)
    {
        BeBaseModel *cellModel = [self.tableArray objectAtIndex:indexPath.row];
        cell.textLabel.text = cellModel.titleDescription;
    }
    else if (tableView == searchDisplayVC.searchResultsTableView)
    {
        BeBaseModel *cellModel = [self.searchResultArray objectAtIndex:indexPath.row];
        cell.textLabel.text = cellModel.titleDescription;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
