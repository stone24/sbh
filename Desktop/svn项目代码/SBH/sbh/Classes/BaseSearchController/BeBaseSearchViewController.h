//
//  BeBaseSearchViewController.h
//  sbh
//
//  Created by liuxiaodan on 15-4-29.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "BeBaseTableViewController.h"
#import "BeResultTableController.h"

@protocol BeSearchControllerDelegate;
@interface BeBaseSearchViewController : BeBaseTableViewController
@property (nonatomic,retain)NSMutableArray *tableArray;
@property (nonatomic,retain)NSMutableArray *searchResultArray;
@property (nonatomic,retain)BeResultTableController *resultTableController;
@property (nonatomic,assign)BOOL isSearchBarFixed;//是否让searchBar在顶部固定住
@property (nonatomic,assign)id<BeSearchControllerDelegate>delegate;
@end

@protocol BeSearchControllerDelegate <NSObject>
@optional
- (void)searchControllerDidBeginSearching;
- (void)searchControllerDidEndSearching;
- (void)searchControllerUpdateCondition:(NSString *)condition;
- (void)filterTableViewReload;

@end