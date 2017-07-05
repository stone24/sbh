//
//  BeBaseSearchViewController.h
//  sbh
//
//  Created by RobinLiu on 15-4-29.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "BeBaseTableViewController.h"
#import "BeResultTableController.h"
#import <Foundation/Foundation.h>
@protocol BeSearchControllerDelegate;
@interface BeBaseSearchViewController : BeBaseTableViewController
@property (nonatomic,retain)UISearchBar *searchBar;
@property (nonatomic,retain)UISearchDisplayController *searchDisplayVC;
@property (nonatomic,retain)UISearchController *baseSearchController;
@property (nonatomic,retain)NSString *searchPlaceHolder;
@property (nonatomic,retain)NSMutableArray *tableTitleArray;
@property (nonatomic,retain)NSMutableArray *searchResultArray;
@property (nonatomic,retain)BeResultTableController *resultTableController;
@property (nonatomic,assign)BOOL isSearchBarFixed;//是否让searchBar在顶部固定住
@end