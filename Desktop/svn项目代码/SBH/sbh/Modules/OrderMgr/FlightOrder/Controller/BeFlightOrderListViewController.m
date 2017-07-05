//
//  BeAirTicketOrderListViewController.m
//  SBHAPP
//
//  Created by musmile on 14-6-30.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "BeFlightOrderListViewController.h"
#import "BeFlightOrderPaymentController.h"
#import "BeFlightOrderDetailController.h"
#import "BeOrderManagerViewController.h"

#import "SBHHttp.h"
#import "ServerFactory.h"

#import "quanbudingdanTableViewCell.h"
#import "BeOrdeSearchHeaderView.h"

#import "SBHManageModel.h"
#import "ColorConfigure.h"

#define REQ_PAGESTART 1
#define QEP_PAGENUM   20
@interface BeFlightOrderListViewController () <UITextFieldDelegate,SearchViewCancelClick>
{
    BeOrdeSearchHeaderView *headerView;
    int iCurPageStart;
    int iCurPageNum;
}
@end

@implementation BeFlightOrderListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    headerView = [[BeOrdeSearchHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kBeOrdeSearchHeaderViewHeight)];
    headerView.delegate = self;
    [self.view addSubview:headerView];
    self.tableView.y = headerView.height;
    self.tableView.height = self.tableView.height - headerView.height;
    headerView.textField.delegate = self;
    headerView.textField.placeholder = @"请输入员工姓名/航班号";
    iCurPageStart = REQ_PAGESTART;
    iCurPageNum   = QEP_PAGENUM;
    [self addHeader];
	[self addFooter];
    [self refreshData];
}
- (void)searchViewCancelButtonClick
{
    headerView.textField.text = @"";
    [self refreshData];
}
- (void)addFooter
{
    iCurPageStart = REQ_PAGESTART;
    iCurPageNum   = QEP_PAGENUM;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestNextPage)];
}

- (void)addHeader
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
}
-(void)refreshData
{
    iCurPageStart = 1;
    [self requestOrderList:iCurPageStart WithPageNum:iCurPageNum];
}
-(void)requestNextPage
{
    iCurPageStart = iCurPageStart + 1;
    [self requestOrderList:iCurPageStart WithPageNum:iCurPageNum];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *hangban = [[self.dataArray objectAtIndex:indexPath.row] fltdate];
    NSRange sepRange  = [hangban rangeOfString:SepMark];
    if(sepRange.length > 0)
    {
        return 95;
    }
    return 83;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        quanbudingdanTableViewCell *cell = nil;
        if (!cell)
        {
            if (self.dataArray.count != 0){
            SBHManageModel *model = [self.dataArray objectAtIndex:indexPath.row];
            NSString *flightDate = model.fltdate;
            NSRange sepRange  = [flightDate rangeOfString:SepMark];
            if(sepRange.length>0)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"quanbudingdanTableViewCell2" owner:self options:nil] objectAtIndex:0];
                NSString * goDate  = [[flightDate substringToIndex:sepRange.location] substringFromIndex:2];
                goDate = [goDate stringByReplacingOccurrencesOfString:@"|" withString:@" "];
                NSString * backDate= [[flightDate substringFromIndex:sepRange.location+sepRange.length] substringFromIndex:2];
                backDate = [backDate stringByReplacingOccurrencesOfString:@"|" withString:@" "];
                NSArray *airArray = [model.flightno componentsSeparatedByString:@","];
                cell.hangbanriqi.text = [NSString stringWithFormat:@"%@ %@",airArray.firstObject,goDate];
                cell.hangbanriqi2.text= [NSString stringWithFormat:@"%@ %@",airArray.lastObject,backDate];
                model.flightno = airArray.firstObject;
                model.backflightno = airArray.lastObject;
                model.comeDate = goDate;
                model.backDate = backDate;
                cell.typeIcon.image = [UIImage imageNamed:@"ddlb_wangfanJiantouIcon"];
                model.travelType = YES;
            }
            else
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"quanbudingdanTableViewCell" owner:self options:nil] objectAtIndex:0];
                flightDate = [flightDate stringByReplacingOccurrencesOfString:@"|" withString:@" "];
                cell.hangbanriqi.text = [NSString stringWithFormat:@"%@ %@",model.flightno,flightDate];
                model.comeDate = flightDate;
                cell.typeIcon.image = [UIImage imageNamed:@"ddlb_jiantouIcon"];
                 model.travelType = NO;
            }
            cell.xingming.text = [model.psgname stringByReplacingOccurrencesOfString:@"," withString:@"/"];
            cell.comeCity.text = model.comeCity;
            cell.reachCity.text = model.reachCity;
                NSString *priceStr = [NSString stringWithFormat:@"￥%d",[model.accountreceivable intValue]+[model.servicecharge intValue]];
            cell.jine.text = priceStr;
            cell.zhuangtai1.text = model.orderst;
               
            if ([model.orderst isEqualToString:@"已订座"]) {
                if ([model.isaudit isEqualToString:@"1"] && [model.officialorprivate isEqualToString:@"因公"]) {
                    if ([model.issend isEqualToString:@"1"]) {
                        [cell.payStats setImage:nil forState:UIControlStateNormal];
                        [cell.payStats setImage:nil forState:UIControlStateHighlighted];
                        [cell.payStats setTitle:model.paymentst forState:UIControlStateNormal];
                        cell.payStats.enabled = NO;
                    } else {
                        [cell.payStats setImage:[UIImage imageNamed:@"OrderList_audit"] forState:UIControlStateNormal];
                        [cell.payStats setTitle:@"" forState:UIControlStateNormal];
                        cell.payStats.enabled = YES;
                        cell.payStats.tag = indexPath.row;
                        [cell.payStats addTarget:self action:@selector(gotoPayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    }
                } else {
                    [cell.payStats setImage:[UIImage imageNamed:@"ddlb_quzhifuIcon"] forState:UIControlStateNormal];
                    [cell.payStats setImage:[UIImage imageNamed:@"ddlb_quzhifuIconA"] forState:UIControlStateHighlighted];
                    [cell.payStats setTitle:@"" forState:UIControlStateNormal];
                    cell.payStats.enabled = YES;
                    cell.payStats.tag = indexPath.row;
                    [cell.payStats addTarget:self action:@selector(gotoPayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            else
            {
                [cell.payStats setImage:nil forState:UIControlStateNormal];
                [cell.payStats setImage:nil forState:UIControlStateHighlighted];
                [cell.payStats setTitle:model.paymentst forState:UIControlStateNormal];
                cell.payStats.enabled = NO;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType  = UITableViewCellAccessoryNone;
            cell.zhuangtai2.hidden = NO;
            cell.zhuangtai1.hidden = NO;
            cell.payStats.hidden = NO;
            cell.shenpiBtn.hidden = YES;
          }
        }
    if ([cell class] == nil) {
        return [[UITableViewCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SBHManageModel *manageModel = [self.dataArray objectAtIndex:indexPath.row];
    BeFlightOrderDetailController *xinxi = [[BeFlightOrderDetailController alloc] init];
    xinxi.mangaeModel = manageModel;
    [self.navigationController pushViewController:xinxi animated:YES];
}

#pragma mark - 请求数据
- (void)requestOrderList:(int)start WithPageNum:(int)pagenum
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"Order/OrderList"];
    NSMutableDictionary *para = [[NSMutableDictionary alloc]init];
    para[@"usertoken"]= [GlobalData getSharedInstance].token;
    para[@"platform"]= @"ios";
    para[@"strokesel"]= @"";        //因公，因私
    para[@"orderstatussel"]= @"";   //订单状态
    para[@"paytypesel"]= @"";       //支付方式
    para[@"ticketno"]= @"";         //订单号
    para[@"passengername"]= @"";    //旅客姓名
    para[@"tktstartdatesel"]= @"";  //销售开始时间
    para[@"tktenddatesel"]= @"";    //销售结束时间
    para[@"fltstartdate"]= @"";     //航班开始时间
    para[@"fltenddate"]= @"";       //航班结束时间
    para[@"flightno"]= headerView.textField.text;
    para[@"pagesize"]= [NSString stringWithFormat:@"%d",pagenum];
    para[@"pageindex"]= [NSString stringWithFormat:@"%d",start];
    para[@"passengername"]= @"";
    para[@"format"]= @"json";
    [[ServerFactory getServerInstance:@"SBHHttp"]postPath:urlStr withParameters:para showHud:YES success:^(NSDictionary *callback)
    {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if(start == 1)
        {
            [self.dataArray removeAllObjects];
        }
        for (int i=0; i<[[callback objectForKey:@"orderlist"] count]; i++)
        {
            SBHManageModel *model = [SBHManageModel mj_objectWithKeyValues:[[callback objectForKey:@"orderlist"] objectAtIndex:i]];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
        NSString *status = [callback objectForKey:@"status"];
        if (![status isEqualToString:@"true"]) {
            NSString * code = [callback objectForKey:@"code"];
            if([code isEqualToString:@"20015"]||[code isEqualToString:@"70001"]) {
                
            } else {
                [self handleResuetCode:code];
            }
        }
    }failure:^(NSError *error)
    {
        [CommonMethod showMessage:kNetworkAbnormal];
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    iCurPageStart = REQ_PAGESTART;
    iCurPageNum   = QEP_PAGENUM;
    [self refreshData];
    return YES;
}
#pragma mark - 支付
- (void)gotoPayBtnClick:(UIButton *)btn
{
    SBHManageModel *manageModel = [self.dataArray objectAtIndex:btn.tag];
    BeFlightOrderPaymentController *payVc = [[BeFlightOrderPaymentController alloc] initWith:manageModel.orderno];
    payVc.sourceType = OrderFinishSourceTypeOrderDetail;
    [self.navigationController pushViewController:payVc animated:YES];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
