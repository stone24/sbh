//
//  BeBaseSearchViewController.m
//  sbh
//
//  Created by RobinLiu on 15-4-29.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "BeBaseSearchViewController.h"
#import "CommonDefine.h"
#import "BeBaseModel.h"
#import "BeResultTableController.h"

@interface BeBaseSearchViewController ()<UISearchBarDelegate,UISearchControllerDelegate,UISearchDisplayDelegate,UISearchResultsUpdating>

@end

@implementation BeBaseSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isSearchBarFixed = YES;
        _searchResultArray = [[NSMutableArray alloc]init];
        _tableTitleArray = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)setSearchPlaceHolder:(NSString *)searchPlaceHolder
{
    self.searchBar.placeholder = searchPlaceHolder;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
    _searchBar.delegate = self;
    [_searchBar sizeToFit];
    _searchDisplayVC = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    _searchDisplayVC.delegate = self;
    _searchDisplayVC.searchResultsDataSource = self;
    _searchDisplayVC.searchResultsDelegate = self;
    if(_isSearchBarFixed)
    {
        [self.view addSubview:_searchBar];
        self.tableView.y = _searchBar.height;
        self.tableView.height = self.tableView.height - _searchBar.height;
    }
    else
    {
        self.tableView.tableHeaderView = _searchBar;
    }
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _searchDisplayVC.searchResultsTableView)
    {
        return self.searchResultArray.count;
    }
    if(tableView == self.tableView)
    {
        return self.tableTitleArray.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
