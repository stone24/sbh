//
//  SBHAuditControllerViewController.m
//  sbh
//
//  Created by SBH on 15-1-26.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "SBHAuditControllerViewController.h"
#import "BeFlightOrderDetailController.h"
#import "quanbudingdanTableViewCell.h"
#import "MJRefresh.h"
#import "SBHManageModel.h"
#import "ServerFactory.h"
#import "SBHHttp.h"

@interface SBHAuditControllerViewController () <UITableViewDataSource, UITableViewDelegate>
{
    int iCurPageStart;
}
@property (weak, nonatomic) IBOutlet UITableView *itableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) NSString *isAudit;
@end

@implementation SBHAuditControllerViewController

- (NSMutableArray *)listArray
{
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {

    };
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self daishenBtnClick];
    self.segmentedControl.tintColor = [ColorConfigure globalBgColor];
    [self.segmentedControl setTitle:@"待审批" forSegmentAtIndex:0];
    [self.segmentedControl setTitle:@"已审批" forSegmentAtIndex:1];
    [self addFooter];
    [self addHeader];
//    self.isAudit = @"Y";
//    [self refreshData];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"serviceCenterViewController"];
    [self segmentControlAction:self.segmentedControl];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"serviceCenterViewController"];
}

//刷新
- (void)addFooter
{
    self.itableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestNextPage)];
}


- (void)addHeader
{
    self.itableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
}
//刷新数据
-(void)refreshData
{
    //    if(all)
    //    {
    iCurPageStart = 1;
    [self.listArray removeAllObjects];
    [self requestOrderList:iCurPageStart];
    
    //    }
}

//下一页
-(void)requestNextPage
{
    iCurPageStart = iCurPageStart + 1;
    [self requestOrderList:iCurPageStart];
    [self.itableView.mj_footer endRefreshing];
}

- (void)requestOrderList:(int)curIndex
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"Audit/AuditList"];
    [[ServerFactory getServerInstance:@"SBHHttp"]postPath:urlStr withParameters:@{@"pagesize":@"10",@"pageindex":[NSString stringWithFormat:@"%d",curIndex],@"auditst":self.isAudit} showHud:YES success:^(NSDictionary *callback)
    {
        NSMutableArray *array1 = [callback objectForKey:@"orderlist"];
        for (int i=0; i<[array1 count]; i++)
        {
            SBHManageModel *listModel = [SBHManageModel mj_objectWithKeyValues:[array1 objectAtIndex:i]];
            [self.listArray addObject:listModel];
        }
        [self.itableView reloadData];
        NSString *status = [callback objectForKey:@"status"];
        if ([status isEqualToString:@"true"]) {
        }
        else{
            NSString * code = [callback objectForKey:@"code"];
            if([code isEqualToString:@"20015"]||[code isEqualToString:@"70001"]) {
                
            } else {
                [self handleResuetCode:code];
            }
        }
    }failure:^(NSError *error)
    {
        
    }];
}

//tableview的委托函数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (self.listArray.count == 0) {
            return 0;
        } else{
            SBHManageModel *listModel = [self.listArray objectAtIndex:indexPath.row];
            NSString *hangban = listModel.fltdate;
            NSRange sepRange  = [hangban rangeOfString:SepMark];
            if(sepRange.length>0)
            {
                return 95;
            }
            else
            {
                return 83;
            }
        }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    quanbudingdanTableViewCell *cell = nil;
    
    if (!cell)
    {
        if (self.listArray.count != 0){
            SBHManageModel *orderModel = [self.listArray objectAtIndex:indexPath.row];
            NSString *flightDate = orderModel.fltdate;
            NSRange sepRange  = [flightDate rangeOfString:SepMark];
            
            if(sepRange.length>0)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"quanbudingdanTableViewCell2" owner:self options:nil] objectAtIndex:0];
                cell.zhuangtai2.hidden = YES;
                NSString * goDate  = [[flightDate substringToIndex:sepRange.location] substringFromIndex:2];
                goDate = [goDate stringByReplacingOccurrencesOfString:@"|" withString:@" "];
                NSString * backDate= [[flightDate substringFromIndex:sepRange.location+sepRange.length] substringFromIndex:2];
                backDate = [backDate stringByReplacingOccurrencesOfString:@"|" withString:@" "];
                NSArray *airArray = [orderModel.flightno componentsSeparatedByString:@","];
                cell.hangbanriqi.text = [NSString stringWithFormat:@"%@ %@",airArray.firstObject,goDate];
                cell.hangbanriqi2.text= [NSString stringWithFormat:@"%@ %@",airArray.lastObject,backDate];
                orderModel.flightno = airArray.firstObject;
                orderModel.backflightno = airArray.lastObject;
                orderModel.comeDate = goDate;
                orderModel.backDate = backDate;
                cell.typeIcon.image = [UIImage imageNamed:@"ddlb_wangfanJiantouIcon"];
                
                
            }
            else
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"quanbudingdanTableViewCell" owner:self options:nil] objectAtIndex:0];
                flightDate = [flightDate stringByReplacingOccurrencesOfString:@"|" withString:@" "];
                cell.hangbanriqi.text = [NSString stringWithFormat:@"%@ %@",orderModel.flightno,flightDate];
                orderModel.comeDate = flightDate;
                cell.typeIcon.image = [UIImage imageNamed:@"ddlb_jiantouIcon"];
            }
            
            cell.xingming.text = [orderModel.psgname stringByReplacingOccurrencesOfString:@"," withString:@"/"];
            cell.comeCity.text = orderModel.comeCity;
            cell.reachCity.text = orderModel.reachCity;
            cell.jine.text = [NSString stringWithFormat:@"￥%@",orderModel.accountreceivable];

            if (self.segmentedControl.selectedSegmentIndex == 1) {
                NSString *stateStr = nil;
                if (orderModel.Audit_Time.length == 0){
                    stateStr = @"超时";
                }
                else if ([orderModel.paymentst isEqualToString:@"已支付"]) {
                    stateStr = @"已同意";
                } else if ([orderModel.paymentst isEqualToString:@"未支付"]){
                    stateStr = @"已拒绝";
                }
                [cell.shenpiBtn setTitle:stateStr forState:UIControlStateNormal];
                [cell.shenpiBtn setTitleColor:SBHColor(153, 153, 153) forState:UIControlStateNormal];
//                cell.textLabel.font = [UIFont systemFontOfSize:8];
//                cell.shenpiBtn.backgroundColor = [UIColor redColor];
                [cell.shenpiBtn setImage:nil forState:UIControlStateNormal];
            } else {
                [cell.shenpiBtn addTarget:self action:@selector(shenpiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
//             [cell.shenpiBtn addTarget:self action:@selector(shenpiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.shenpiBtn.tag = indexPath.row;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType  = UITableViewCellAccessoryNone;
            cell.zhuangtai1.hidden = YES;
            cell.payStats.hidden = YES;
            cell.shenpiBtn.hidden = NO;
        }
    }
    if ([cell class] == nil) {
        return [[UITableViewCell alloc] init];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        SBHManageModel *auditM = [self.listArray objectAtIndex:indexPath.row];
        BeFlightOrderDetailController *dingxVc = [[BeFlightOrderDetailController alloc] init];
        auditM.detailType = @"SBHAuditDetail";
        auditM.orderst = @"审批浏览";
        dingxVc.mangaeModel = auditM;
        [self.navigationController pushViewController:dingxVc animated:YES];
    }
}

- (void)shenpiBtnClick:(UIButton *)btn
{
    SBHManageModel *auditM = [self.listArray objectAtIndex:btn.tag];
    auditM.detailType = @"SBHAuditDetail";
    BeFlightOrderDetailController *dingxVc = [[BeFlightOrderDetailController alloc] init];
    dingxVc.mangaeModel = auditM;
    [self.navigationController pushViewController:dingxVc animated:YES];
}


- (IBAction)segmentControlAction:(UISegmentedControl *)sender {
    [self.view endEditing:YES];
    if (sender.selectedSegmentIndex == 0) {

        self.isAudit = @"Y";
        [self refreshData];
    } else {

        self.isAudit = @"N";
        [self refreshData];
    }
    
}

@end
