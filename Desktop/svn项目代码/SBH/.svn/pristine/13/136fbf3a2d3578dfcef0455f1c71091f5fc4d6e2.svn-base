//
//  BeTrainDetailViewController.m
//  sbh
//
//  Created by SBH on 15/6/17.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTrainOrderDetailController.h"
#import "BeTrainAlterationController.h"
#import "BeWebViewController.h"
#import "BeTrainBookingController.h"

#import "SBHHttp.h"
#import "BeTrainOrderInfoModel.h"
#import "BeTrainBookModel.h"
#import "NSDictionary+Additions.h"
#import "ServerFactory.h"
#import "BeTrainServer.h"

#import "SBHDingxxFooterView.h"
#import "SBHAuditCoverView.h"
#import "gongsilianxirenCell.h"
#import "BeAirTicketOrderInfoCell.h"
#import "BeAirOrderDetailPassengerCell.h"
#import "BeAirOrderDetailContactCell.h"
#import "SBHDingxxHeaderCell.h"
#import "BeTrainInfoCell.h"
#import "BeAlteRetView.h"

#define kTrainRuleUrl @"train.html"

@interface BeTrainOrderDetailController ()
@property (nonatomic, strong) UIView *covertgaiView;
@property (nonatomic, strong) BeTrainOrderInfoModel *orderInfoModel;

@property (nonatomic, strong) BeAirTicketDetailInfoFrame *orderInfoF;
@property (nonatomic, strong) NSMutableArray *chengjirBtns;
@property (nonatomic, strong) UIButton *lastBtn;
@property (nonatomic, strong) UIButton *doneFinishBtn;
@end

@implementation BeTrainOrderDetailController

- (NSMutableArray *)chengjirBtns
{
    if (_chengjirBtns == nil) {
        _chengjirBtns = [[NSMutableArray alloc] init];
    }
    return _chengjirBtns;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"火车票订单";
    self.tableView.hidden = YES;
    [self setupRequestData];
}

- (void)setupFooterView
{
    if([self.orderInfoModel.orderst isEqualToString:@"待支付"]/*||[self.orderInfoModel.orderst isEqualToString:@"已出票"]||[self.orderInfoModel.orderst isEqualToString:@"已提交"]||||[self.orderInfoModel.orderst isEqualToString:@"待出票"]*/)
    {
        BeTrainInfoModel *trainModel = self.orderInfoModel.traininfolist.firstObject;
    
        NSString *startDateStr = [NSString stringWithFormat:@"%@ %@:00", trainModel.departdate, trainModel.departtime];
        NSDate *stratDate = [CommonMethod dateFromString:startDateStr WithParseStr:@"yyyy-MM-dd HH:mm:ss"];
    //取消订单 已订座 已提交"
    //退票 已出票
        if(!([stratDate compare:[NSDate date]] == NSOrderedAscending))
        {
            UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
            self.tableView.tableFooterView = footerView;
            if([self.orderInfoModel.orderst isEqualToString:@"待支付"])
            {
                NSArray *titleArray = @[@"取消",@"支付"];
                for(int i = 0;i<titleArray.count;i++)
                {
                    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    cancelButton.frame = CGRectMake(15 + ((kScreenWidth - 45)/2.0+15)*i, 10, (kScreenWidth - 45)/2.0, 35);
                    [footerView addSubview:cancelButton];
                    //cancelButton.layer.borderColor = [[UIColor darkGrayColor] CGColor];
                    //cancelButton.layer.borderWidth = 1.0f;
                    cancelButton.layer.cornerRadius = 4.0f;
                    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [cancelButton setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
                    if(i == 0)
                    {
                        cancelButton.backgroundColor = [UIColor lightGrayColor];

                        [cancelButton addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
                    }
                    else
                    {
                        cancelButton.backgroundColor = [ColorConfigure loginButtonColor];

                        [cancelButton addTarget:self action:@selector(toPay) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
            }
            else
            {
                   UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
                   cancelButton.frame = CGRectMake(15, 10, kScreenWidth - 30, 35);
                    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
                   [footerView addSubview:cancelButton];
                  // cancelButton.layer.borderColor = [[UIColor darkGrayColor] CGColor];
                  // cancelButton.layer.borderWidth = 1.0f;
                  cancelButton.layer.cornerRadius = 4.0f;
                   [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                   cancelButton.backgroundColor = [UIColor lightGrayColor];
                  /* if([self.orderInfoModel.orderst isEqualToString:@"已出票"])
                   {
                       [cancelButton addTarget:self action:@selector(refundTicket) forControlEvents:UIControlEventTouchUpInside];
                       [cancelButton setTitle:@"退票" forState:UIControlStateNormal];

                   }
                   else
                   {*/
                       [cancelButton addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
                       [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
                  // }
            }
        }
    }
}

- (void)setupRequestData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kTrainHost,@"Order/GetOrderDetail"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"OrderNo"] = self.orderno;
    params[@"usertoken"] = [GlobalData getSharedInstance].token;
    [[SBHHttp sharedInstance] postPath:urlStr withParameters:params showHud:YES success:^(id responseObj) {
        self.tableView.hidden = NO;
        self.orderInfoModel = [[BeTrainOrderInfoModel alloc]initWithDict:[responseObj objectForKey:@"Order"]];
        
        // 订单信息
        BeAirTicketDetailInfoFrame *orderInfoF = [[BeAirTicketDetailInfoFrame alloc] init];
        BeOrderInfoModel *orderModel = [[BeOrderInfoModel alloc] init];
        orderModel.orderst = self.orderInfoModel.orderst;
        orderModel.orderno = self.orderInfoModel.orderno;
        orderModel.accountreceivable = self.orderInfoModel.accountreceivable;
        orderModel.creattime = self.orderInfoModel.creatdate;
        orderModel.bookingman = self.orderInfoModel.bookingman;
        orderModel.sellprice = self.orderInfoModel.ticketpricetotal;// 票面价
        orderModel.insurancepricetotal = self.orderInfoModel.insurancepricetotal;
        orderInfoF.infoModel = orderModel;
        orderInfoF.isTrainType = YES;
        self.orderInfoF = orderInfoF;
        
        // 乘机人frame化
        for (BeTrainPassengerModel *pasM in self.orderInfoModel.psglist) {
            BePassengerModel *frameModel = [[BePassengerModel alloc] init];
            frameModel.psgname = pasM.psgname;
            frameModel.cardtypename = pasM.cardname;
            frameModel.cardno = pasM.cardno;
            BeAirOrderDetailPassengerFrame *pasF = [[BeAirOrderDetailPassengerFrame alloc] init];
            pasF.pasM = frameModel;
            [self.orderInfoModel.pasFrameArray addObject:pasF];
        }
        
        // 联系人frame化
        for (BeOrderContactModel *conM in self.orderInfoModel.contactList)
        {
            BeAirOrderDetailContactFrame *conF = [[BeAirOrderDetailContactFrame alloc] init];
            conF.conM = conM;
            [self.orderInfoModel.conFrameArray addObject:conF];
        }
        
        [self setupFooterView];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self requestFlase:error];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2){
        return self.orderInfoModel.pasFrameArray.count;
    }else if (section == 3){
        return self.orderInfoModel.conFrameArray.count;
    } else if (section == 4){
        if (self.orderInfoModel.expensecenter.length == 0) {
            return 0;
        }
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.orderInfoF.height;
    }
    if (indexPath.section == 1) {
        return 166;
    }
    if (indexPath.section == 2) {
        BeAirOrderDetailPassengerFrame *pasFrame = [self.orderInfoModel.pasFrameArray objectAtIndex:indexPath.row];
        return pasFrame.height;
    }  if (indexPath.section == 3) {
        BeAirOrderDetailContactFrame *conFrame = [self.orderInfoModel.conFrameArray objectAtIndex:indexPath.row];
        return conFrame.height;
    }
    return 35;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 45.0;
    }
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeAirTicketOrderInfoCell *cell = [BeAirTicketOrderInfoCell cellWithTableView:tableView];
    if (indexPath.section == 0) {
        if (self.orderInfoF != nil){
            cell.infoFrame = self.orderInfoF;
        }
        return cell;
    } else if (indexPath.section == 1) {
        BeTrainInfoCell *cell = [BeTrainInfoCell cellWithTableView:tableView];
        cell.trainModel = [self.orderInfoModel.traininfolist objectAtIndex:indexPath.row];
        return cell;
    }
    else if  (indexPath.section == 2) {
        BeAirOrderDetailPassengerCell *cell = [BeAirOrderDetailPassengerCell cellWithTableView:tableView];
        if (indexPath.row == 0) {
            cell.titleStr = @"乘车人:";
        } else {
            cell.titleStr = @"";
        }
        cell.pasF = [self.orderInfoModel.pasFrameArray objectAtIndex:indexPath.row];
        return cell;
        
    } else if  (indexPath.section == 3) {
        BeAirOrderDetailContactCell *cell = [BeAirOrderDetailContactCell cellWithTableView:tableView];
        if (indexPath.row == 0) {
            cell.titleStr = @"联系人:";
        } else {
            cell.titleStr = @"";
        }
        cell.conF = [self.orderInfoModel.conFrameArray objectAtIndex:indexPath.row];
        return cell;
    }
    else if (indexPath.section == 4){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        NSString *centerStr = [NSString stringWithFormat:@"费用中心  %@", self.orderInfoModel.expensecenter];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = kAirTicketDetailTitleColor;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = centerStr;
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        self.orderInfoF.showSumDetail = !self.orderInfoF.showSumDetail;
        self.orderInfoF.infoModel = self.orderInfoF.infoModel;
        [self.tableView reloadData];
    }
    if (indexPath.section == 1) {
        
//        BeWebViewController *webVC = [[BeWebViewController alloc]init];
//        webVC.webViewUrl = [NSString stringWithFormat:@"%@%@", kServerHost, kTrainRuleUrl];
//        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        SBHDingxxHeaderCell *headerView = [[[NSBundle mainBundle] loadNibNamed:@"SBHDingxxHeaderCell" owner:self options:nil] objectAtIndex:0];
        BeTrainInfoModel *trainModel = self.orderInfoModel.traininfolist.firstObject;
        headerView.comeCity.text = trainModel.boardpointname;
        headerView.reachCity.text = trainModel.offpointname;
        headerView.typeImage.image = [UIImage imageNamed:@"ddlb_jiantouIcon"];
        return headerView;
    }
    return nil;
}

- (void)toPay
{
    [[ServerFactory getServerInstance:@"BeTrainServer"]payTrainOrderWith:self.orderInfoModel.orderno andSuccess:^(NSDictionary *callback)
     {
         // 20024
         if([[callback stringValueForKey:@"code" defaultValue:@""]isEqualToString:@"20024"])
         {
             [MBProgressHUD showMessage:@"支付成功"];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self.navigationController popToRootViewControllerAnimated:YES];
             });
         }
     }andFailure:^(NSError *error)
     {
         if([[error.userInfo stringValueForKey:@"code" defaultValue:@""]isEqualToString:@"20023"])
         {
             [CommonMethod showMessage:@"您的企业剩余额度不足"];
         }
         else if([[error.userInfo stringValueForKey:@"code" defaultValue:@""]isEqualToString:@"10004"])
         {
             [CommonMethod showMessage:@"当前用户没有开通权限"];
         }
         else
         {
             [self requestFlase:error];
         }
     }];
    /*
    BeTrainBookModel *bookModel = [[BeTrainBookModel alloc]init];
    [bookModel configureTrainInfoWithOrderModel:self.orderInfoModel];
    BeTrainBookingController *trainBookVC = [[BeTrainBookingController alloc]init];
    trainBookVC.sourceType = TrainBookSourceTypeConfirm;
    trainBookVC.bookModel = bookModel;
    [self.navigationController pushViewController:trainBookVC animated:YES];*/
}
- (void)cancelOrder
{
    NSString *urlStr = [NSString stringWithFormat:@"%@Order/UpdateOrderState",kTrainHost];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"OrderNo"] = self.orderno;
    params[@"usertoken"] = [GlobalData getSharedInstance].token;
    [[SBHHttp sharedInstance] postPath:urlStr withParameters:params showHud:YES success:^(id responseObj) {
        [MBProgressHUD showSuccess:@"取消订单成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [self requestFlase:error];
    }];
}
- (void)refundTicket
{
    NSMutableArray *Tickets = [NSMutableArray array];
    for(int i = 0;i < self.orderInfoModel.psglist.count;i++)
    {
        BeTrainPassengerModel *model = [self.orderInfoModel.psglist objectAtIndex:i];
        [Tickets addObject:model.ticketno];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@Order/CancelOrder",kTrainHost];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"Tickets"] = Tickets;
    params[@"usertoken"] = [GlobalData getSharedInstance].token;
    [[SBHHttp sharedInstance] postPath:urlStr withParameters:params showHud:YES success:^(id responseObj) {
        [MBProgressHUD showSuccess:@"退票成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [self requestFlase:error];
    }];
}
@end
