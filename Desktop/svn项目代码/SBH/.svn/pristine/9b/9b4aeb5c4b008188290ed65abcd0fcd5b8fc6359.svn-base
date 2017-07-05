//
//  BeTrainOrderListController.m
//  sbh
//
//  Created by SBH on 15/6/18.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTrainOrderListController.h"
#import "quanbudingdanTableViewCell.h"
#import "MJRefresh.h"
#import "SBHHttp.h"
#import "BeTrainOrderListModel.h"
#import "BeTrainOrderDetailController.h"
#import "BeOrdeSearchHeaderView.h"

@interface BeTrainOrderListController () <UITextFieldDelegate,SearchViewCancelClick>
{
    BeOrdeSearchHeaderView *headerView;
}

@property (nonatomic, assign) int currentPage; // 当前页数
@property (nonatomic, assign) int pageCount; // 分页的总页数
@end

@implementation BeTrainOrderListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    headerView = [[BeOrdeSearchHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kBeOrdeSearchHeaderViewHeight)];
    headerView.delegate = self;
    [self.view addSubview:headerView];
    self.tableView.y = headerView.height;
    self.tableView.height = self.tableView.height - headerView.height;
    headerView.textField.delegate = self;
    headerView.textField.placeholder = @"请输入员工姓名";
    self.tableView.backgroundColor = kbgColor;
    self.view.backgroundColor = kbgColor;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self refreshNewData];
}
- (void)searchViewCancelButtonClick
{
    headerView.textField.text = @"";
    [self refreshNewData];
}

- (void)refreshNewData
{
    _currentPage = 1;
    [self loadMoreDataWithPage:_currentPage];
}

- (void)loadMoreData
{
    if(_currentPage >= _pageCount)
    {
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    _currentPage ++;
    [self loadMoreDataWithPage:_currentPage];
}

- (void)loadMoreDataWithPage:(int)indexPage
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kTrainHost,@"Order/SearchOrderList"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pagesize"] = @"20";
    params[@"pageindex"] = [NSString stringWithFormat:@"%d", indexPage];
    params[@"passengername"] = headerView.textField.text;  // 查询参数
    params[@"usertoken"] = [GlobalData getSharedInstance].token;
    NSLog(@"params=%@",params);
    [[SBHHttp sharedInstance] postPath:urlStr withParameters:params showHud:YES success:^(id responseObj) {
        NSLog(@"responseObj=%@",responseObj);
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        self.pageCount = [[responseObj stringValueForKey:@"pagecount"] intValue];
        self.currentPage = [[responseObj stringValueForKey:@"currentpage"] intValue];
        NSArray *array = [responseObj objectForKey:@"OrderList"];
        if(indexPage == 1)
        {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dict in array) {
            BeTrainOrderListModel *listM = [[BeTrainOrderListModel alloc]initWithDict:dict];
            [self.dataArray addObject:listM];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self requestFlase:error];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 83;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    quanbudingdanTableViewCell *cell = [quanbudingdanTableViewCell cellWithTableView:tableView];
    cell.trainM = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeTrainOrderListModel *listM = [self.dataArray objectAtIndex:indexPath.row];
    BeTrainOrderDetailController *detVc = [[BeTrainOrderDetailController alloc] init];
    detVc.orderno = listM.orderno;
    detVc.title = @"订单详情";
    [self.navigationController pushViewController:detVc animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self refreshNewData];
    return YES;
}
@end
