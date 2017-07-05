//
//  BeCarOrderListViewController.m
//  sbh
//
//  Created by RobinLiu on 15/7/13.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeCarOrderListViewController.h"
#import "MJRefresh.h"
#import "BeCarOrderListModel.h"
#import "BeCarOrderDetailViewController.h"
#import "BeCarOrderListTableViewCell.h"
#import "SBHHttp.h"
#import "ServerConfigure.h"
#import "BeCarOrderDetailViewController.h"

@interface BeCarOrderListViewController ()
{
    int indexPage;
}

@end

@implementation BeCarOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"行程";
    // Do any additional setup after loading the view.
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreDataAction)];
    indexPage = 1;
    [self getDataWithIndex:indexPage];
}
- (void)refreshAction
{
    indexPage = 1;
    [self getDataWithIndex:indexPage];
}
- (void)getMoreDataAction
{
    indexPage ++;
    [self getDataWithIndex:indexPage];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [BeCarOrderListTableViewCell cellHeight];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeCarOrderListTableViewCell *cell = [BeCarOrderListTableViewCell cellWithTableView:tableView];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BeCarOrderListModel *model = [self.dataArray objectAtIndex:indexPath.row];
    BeCarOrderDetailViewController *detailVC = [[BeCarOrderDetailViewController alloc]init];
    detailVC.orderNo = model.OrderNo;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)getDataWithIndex:(int)index
{
    NSDictionary *dict = @{@"pageindex":[NSString stringWithFormat:@"%d",index],@"pagesize":@"20",@"totalcount":@"0",@"pagecount":@"0",@"usertoken":[GlobalData getSharedInstance].token};
    [[SBHHttp sharedInstance]postPath:[NSString stringWithFormat:@"%@%@",kServerHost,kCarOrderListUrl] withParameters:dict showHud:YES success:^(NSDictionary *result)
    {
        if(index == 1)
        {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dict in [result objectForKey:@"ol"]) {
            BeCarOrderListModel *model = [[BeCarOrderListModel alloc]initWithDict:dict];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }failure:^(NSError *error)
    {
        [self requestFlase:error];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
