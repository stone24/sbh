//
//  BeHotelOrderTableViewController.m
//  SideBenefit
//
//  Created by SBH on 15-3-10.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelOrderController.h"
#import "BeHotelOrderCell.h"
#import "BeHotelOrderDetailController.h"
#import "BeHotelOrderModel.h"
#import "CommonMethod.h"
#import "MJRefresh.h"
#import "BaseViewController.h"
#import "ServerConfigure.h"
#import "SBHHttp.h"
#import "ServerFactory.h"
#import "BeHotelOrderServer.h"
#import "NSDictionary+Additions.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "BeHotelDetailController.h"
#import "BeHotelOrderPayViewController.h"
#import "BeHotelCityManager.h"
#import "NSDate+WQCalendarLogic.h"
#import "SBHAuditCoverView.h"

@interface BeHotelOrderController ()<HotelOrderListDelegate>
{
    NSString *cancelReason;
    NSIndexPath *cancelIndexPath;
}
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, assign) int curPage;
@property (nonatomic, strong) SBHAuditCoverView *cancelReasonView;
@property (nonatomic,strong)UIView *dimView;

@end

@implementation BeHotelOrderController

- (NSMutableArray *)listArray
{
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewValueChanged) name:UITextViewTextDidChangeNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"酒店订单";
    cancelReason = [[NSString alloc]init];
    cancelIndexPath = [[NSIndexPath alloc]init];
    [self addCancelReasonView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestNextPage)];
    [self refreshData];
}

//刷新数据
-(void)refreshData
{
    self.curPage = 1;
    [self setupHotelListRequest:self.curPage];
}
//下一页
-(void)requestNextPage
{
    self.curPage = self.curPage + 1;
    [self setupHotelListRequest:self.curPage];
}

- (void)setupHotelListRequest:(int)indexPage
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,kHotelOrderListUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageindex"] = [NSString stringWithFormat:@"%d",indexPage];
    params[@"pagesize"] = @"10";
    params[@"usertoken"] = [GlobalData getSharedInstance].token;
    [[SBHHttp sharedInstance]postPath:urlStr withParameters:params showHud:YES success:^(NSDictionary *responseObject)
    {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if(indexPage == 1)
        {
            [self.listArray removeAllObjects];
        }
        NSArray *array = [responseObject objectForKey:@"ho"];
        for (NSDictionary *dict in array) {
            BeHotelOrderModel *model = [[BeHotelOrderModel alloc]init];
            [model setOrderListItemWithDict:[dict objectForKey:@"Order"]];
            [self.listArray addObject:model];
        }
        [self.tableView reloadData];
    }failure:^(NSError *error)
    {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *codeStr = [error.userInfo objectForKey:@"code"];
        [self handleResuetCode:codeStr];
    }];
}
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9.0f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return [BeHotelOrderListStatusCell cellHeight];
    }
    else if (indexPath.row == 1)
    {
        return [BeHotelOrderListContentCell cellHeight];
    }
    else if (indexPath.row == 2)
    {
        return [BeHotelOrderCell cellHeight];
    }
    return 0.001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0)
    {
        BeHotelOrderListStatusCell *cell = [BeHotelOrderListStatusCell cellWithTableView:tableView];
        cell.listModel = [self.listArray objectAtIndex:indexPath.section];
        return cell;
    }
    else if (indexPath.row == 1)
    {
        BeHotelOrderListContentCell *cell = [BeHotelOrderListContentCell cellWithTableView:tableView];
        cell.listModel = [self.listArray objectAtIndex:indexPath.section];
        return cell;
    }
    else if (indexPath.row == 2)
    {
        BeHotelOrderCell *cell = [BeHotelOrderCell cellWithTableView:tableView];
        cell.listModel = [self.listArray objectAtIndex:indexPath.section];
        cell.delegate = self;
        cell.indexPath = indexPath;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeHotelOrderModel *hotModel = [self.listArray objectAtIndex:indexPath.section];
    BeHotelOrderDetailController *detVc = [[BeHotelOrderDetailController alloc] init];
    detVc.cancelBlock = ^
    {
        [self refreshData];
    };
    detVc.hotModel = hotModel;
    [self.navigationController pushViewController:detVc animated:YES];
}
- (void)auditWithIndex:(NSIndexPath *)indexPath
{
    //去审批
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}
- (void)payWithIndex:(NSIndexPath *)indexPath
{
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    return;
    [MBProgressHUD showMessage:nil];
    BeHotelOrderModel *hotModel = [self.listArray objectAtIndex:indexPath.section];
    [[ServerFactory getServerInstance:@"BeHotelOrderServer"]doGetHotelOrderDetailWith:hotModel andSuccessCallback:^(NSDictionary *callback)
     {
         [MBProgressHUD hideHUD];
         BeHotelOrderWriteModel *writerModel = [[BeHotelOrderWriteModel alloc]init];
         [writerModel setupDataWithHotelOrderData:callback];
         BeHotelOrderPayViewController *payVC = [[BeHotelOrderPayViewController alloc]init];
         payVC.sourceType = HotelOrderPaySourceTypeOrderList;
         payVC.writeModel = writerModel;
         [self.navigationController pushViewController:payVC animated:YES];
     }andFailureCallback:^(NSString *failure)
     {
         [MBProgressHUD hideHUD];
         [self handleResuetCode:failure];
     }];
}
- (void)cancelWithIndex:(NSIndexPath *)indexPath
{
    cancelIndexPath = indexPath;
    self.dimView.hidden = NO;
    self.cancelReasonView.hidden = NO;
    self.cancelReasonView.contentTextView.text = @"取消原因";
}
- (void)bookWithIndex:(NSIndexPath *)indexPath
{
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    return;
    [MBProgressHUD showMessage:nil];
    BeHotelOrderModel *hotModel = [self.listArray objectAtIndex:indexPath.section];
    [[ServerFactory getServerInstance:@"BeHotelOrderServer"]doGetHotelOrderDetailWith:hotModel andSuccessCallback:^(NSDictionary *callback)
     {
         [MBProgressHUD hideHUD];
         BeHotelListItem *listItem = [[BeHotelListItem alloc]init];
         listItem.hotelId = [NSString stringWithFormat:@"%@",[[callback objectForKey:@"Order"]objectForKey:@"HotelId"]];
         NSDate *startDate = [[NSDate date]dateByAddingTimeInterval:3600*24*1];
         listItem.CheckInDate = [startDate stringFromDate:startDate];
         NSDate *leaveDate = [startDate dateByAddingTimeInterval:3600*24*1];
         listItem.CheckOutDate = [leaveDate stringFromDate:leaveDate];
         NSString *cityName = [[callback objectForKey:@"Order"]objectForKey:@"CityName"];
         
         [[BeHotelCityManager sharedInstance]getCityDataWithCityName:cityName andCallback:^(CityData *cityData)
          {
              listItem.cityId = cityData.cityId;
              listItem.cityName = cityName;
              BeHotelDetailController *detailVC = [[BeHotelDetailController alloc]init];
              detailVC.item = listItem;
              detailVC.sourceType = HotelDetailSourceTypeOrderList;
              [self.navigationController pushViewController:detailVC animated:YES];
          }];
     }andFailureCallback:^(NSString *failure)
     {
         [MBProgressHUD hideHUD];
         [self handleResuetCode:failure];
     }];
}
- (void)addCancelReasonView
{
    self.dimView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.dimView.backgroundColor = [UIColor blackColor];
    self.dimView.alpha = 0.2;
    [[UIApplication sharedApplication].keyWindow addSubview:self.dimView];
    self.cancelReasonView = [[[NSBundle mainBundle] loadNibNamed:@"SBHAuditCoverView" owner:nil options:nil] firstObject];
    self.cancelReasonView.width = self.view.width - 20;
    self.cancelReasonView.height = 345;
    self.cancelReasonView.x = 10 ;
    self.cancelReasonView.y = (kScreenHeight - self.cancelReasonView.height) * 0.2;
    //    auditView.backgroundColor = [UIColor redColor];
    [self.cancelReasonView.closeCoverBtn addTarget:self action:@selector(auditCloseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelReasonView.doneBtn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:self.cancelReasonView];
    self.dimView.hidden = YES;
    self.cancelReasonView.hidden = YES;
}
- (void)textViewValueChanged
{
    cancelReason = self.cancelReasonView.contentTextView.text;
}
- (void)auditCloseButtonClick:(UIButton *)sender
{
    self.dimView.hidden = YES;
    self.cancelReasonView.hidden = YES;
}
- (void)doneBtnClick:(UIButton *)sender
{
    if (cancelReason.length == 0 || [cancelReason isEqualToString:@"取消原因"]) {
        [MBProgressHUD showError:@"请填写取消原因"];
    } else {
        self.dimView.hidden = YES;
        self.cancelReasonView.hidden = YES;
        BeHotelOrderModel *hotModel = [self.listArray objectAtIndex:cancelIndexPath.section];
        [MBProgressHUD showMessage:nil];
        [[ServerFactory getServerInstance:@"BeHotelOrderServer"]doCancelOrderWith:hotModel andReason:cancelReason andSuccess:^(NSString *success)
         {
             [MBProgressHUD hideHUD];
             [MBProgressHUD showSuccess:@"订单取消成功"];
             [self refreshData];
         }andFailure:^(NSString *failure)
         {
             [MBProgressHUD hideHUD];
             [MBProgressHUD showError:failure];
         }];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
