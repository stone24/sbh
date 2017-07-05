//
//  BeMeetingOrderListViewController.m
//  sbh
//
//  Created by RobinLiu on 16/6/22.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeMeetingOrderListViewController.h"
#import "BeMeetingOrderDetailViewController.h"

#import "MJRefresh.h"
#import "SBHHttp.h"
#import "ServerConfigure.h"

#import "BeMeetingOrderModel.h"

#import "BeMeetingOrderListTableViewCell.h"


@interface BeMeetingOrderListViewController ()
{
    int indexPage;
    int pageCount;
}

@end

@implementation BeMeetingOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会议订单";
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
    if(indexPage >= pageCount)
    {
        [MBProgressHUD showError:@"数据已全部加载"];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    indexPage ++;
    [self getDataWithIndex:indexPage];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [BeMeetingOrderListTableViewCell cellHeight];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeMeetingOrderListTableViewCell *cell = [BeMeetingOrderListTableViewCell cellWithTableView:tableView];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BeMeetingOrderModel *model = [self.dataArray objectAtIndex:indexPath.row];
    BeMeetingOrderDetailViewController *detailVC = [[BeMeetingOrderDetailViewController alloc]init];
    detailVC.orderNo = model.Meeting_OrderNo;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)getDataWithIndex:(int)index
{
    NSDictionary *dict = @{@"pageindex":[NSString stringWithFormat:@"%d",index],@"pagesize":@"20",@"usertoken":[GlobalData getSharedInstance].token};
    [[SBHHttp sharedInstance]postPath:[NSString stringWithFormat:@"%@%@",kServerHost,@"Meeting/MeetingList"] withParameters:dict showHud:YES success:^(NSDictionary *result)
     {
         
         /*
          {
          code = 20020;
          meetingList =     {
          BackInfo =         {
          listT =             (
          {
          "Demand_AccountId" = 108997;
          "Demand_EntId" = 401139;
          "Demand_LoginName" = cs13;
          Id = 4018;
          "Meeting_Budget" = 0;
          "Meeting_CityName" = "\U5317\U4eac";
          "Meeting_CreateDate" = "2016-06-22";
          "Meeting_Demand" = "\U673a\U7968";
          "Meeting_EMail" = "";
          "Meeting_EndDate" = "2016-06-24";
          "Meeting_LastUpdateDate" = "2016-06-22";
          "Meeting_LinkMan" = Test;
          "Meeting_LinkTelephone" = 18690909876;
          "Meeting_Mins" = 0;
          "Meeting_Number" = 2;
          "Meeting_OrderNo" = M16062200000001;
          "Meeting_OrderStatus" = 101;
          "Meeting_OtherDemand" = "";
          "Meeting_StrDate" = "2016-06-23";
          "Process_LoginName" = "";
          }
          );
          pageCount = 1;
          pageIndex = 1;
          pageSize = 20;
          recordCount = 1;
          };
          ErrorMsg = "";
          ErrorNo = 1;
          };
          status = true;
          }
          */
         NSLog(@"result = %@",result);
         pageCount = [[[[result objectForKey:@"meetingList"] objectForKey:@"BackInfo"] objectForKey:@"pageCount"] intValue];
         if(index == 1)
         {
             [self.dataArray removeAllObjects];
         }
         for (NSDictionary *dict in [[[result objectForKey:@"meetingList"] objectForKey:@"BackInfo"] objectForKey:@"listT"]) {
             BeMeetingOrderModel *model = [BeMeetingOrderModel mj_objectWithKeyValues:dict];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
