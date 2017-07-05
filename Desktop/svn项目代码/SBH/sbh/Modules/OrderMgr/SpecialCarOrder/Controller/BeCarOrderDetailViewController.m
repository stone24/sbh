//
//  BeCarOrderDetailViewController.m
//  sbh
//
//  Created by RobinLiu on 15/7/13.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeCarOrderDetailViewController.h"
#import "SBHHttp.h"
#import "ServerFactory.h"
#import "ServerConfigure.h"
#import "BeCarOrderDetailModel.h"
#import "BeCarOrderDetailBookInfoCell.h"
#import "BeCarOrderDetailDriverInfoCell.h"
#import "BeCarOrderDetailOrderHeaderCell.h"
#import "ColorUtility.h"
#import "UIAlertView+Block.h"
#import <AlipaySDK/AlipaySDK.h>
#import "BeSpecialCarHttp.h"

#define kOrderInfoSectionTitle  @"订单信息"
#define kDriverInfoSectionTitle @"司机信息"
#define kDetailInfoSectionTitle @"预订信息"

@interface BeCarOrderDetailViewController ()<CarOrderDetailOrderHeaderCellDelegate>
{
    BeCarOrderDetailModel *model;
    BOOL isShowDetail;
}
@end

@implementation BeCarOrderDetailViewController
- (id)init
{
    if(self = [super init])
    {
        _orderNo = [[NSString alloc]init];
        model = [[BeCarOrderDetailModel alloc]init];
        isShowDetail = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.navigationItem.rightBarButtonItem = nil;
    [self.dataArray addObjectsFromArray:@[kOrderInfoSectionTitle,kDriverInfoSectionTitle,kDetailInfoSectionTitle]];
    [self getData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *title = [self.dataArray objectAtIndex:section];
    if([title isEqualToString:kDriverInfoSectionTitle]||[title isEqualToString:kDetailInfoSectionTitle])
    {
        return 32;
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = [self.dataArray objectAtIndex:section];
    if([title isEqualToString:kDriverInfoSectionTitle]||[title isEqualToString:kDetailInfoSectionTitle])
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth, 30)];
        label.text = title;
        [view addSubview:label];
        return view;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [self.dataArray objectAtIndex:indexPath.section];
    if([title isEqualToString:kOrderInfoSectionTitle])
    {
        return [BeCarOrderDetailOrderHeaderCell cellHeightWithModel:model andIsSpread:isShowDetail];
    }
    else if([title isEqualToString:kDriverInfoSectionTitle])
    {
        return [BeCarOrderDetailDriverInfoCell cellHeight];
    }
    else if([title isEqualToString:kDetailInfoSectionTitle])
    {
        return [BeCarOrderDetailBookInfoCell cellHeightWithModel:model];
    }
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [self.dataArray objectAtIndex:indexPath.section];
    if([title isEqualToString:kOrderInfoSectionTitle])
    {
        BeCarOrderDetailOrderHeaderCell *cell = [BeCarOrderDetailOrderHeaderCell cellWithTableView:tableView];
        [cell setCellWithModel:model andIsSpread:isShowDetail];
        cell.delegate = self;
        return cell;
    }
    else if([title isEqualToString:kDriverInfoSectionTitle])
    {
        BeCarOrderDetailDriverInfoCell *cell = [BeCarOrderDetailDriverInfoCell cellWithTableView:tableView];
        [cell setCellWithModel:model];
        return cell;
    }
    else if([title isEqualToString:kDetailInfoSectionTitle])
    {
        BeCarOrderDetailBookInfoCell *cell = [BeCarOrderDetailBookInfoCell cellWithTableView:tableView];
        [cell setCellWithModel:model];
        return cell;
    }
    return nil;
}
- (void)setUpFooterViewAndRightBarButtonItem
{
    if([model.orderState isEqualToString:@"待服务"]||[model.orderState isEqualToString:@"待答应"]||[model.orderState isEqualToString:@"待应答"])
    {
        if([model.AccountId isEqualToString:[GlobalData getSharedInstance].userModel.AccountID])
        {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消叫车" style:UIBarButtonItemStylePlain target:self action:@selector(cancelCarOrder)];
        }
    }
    else if([model.orderState isEqualToString:@"待个人支付"])
        {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
            UIButton *bookButton = [UIButton buttonWithType:UIButtonTypeCustom];
            bookButton.frame = CGRectMake(15, 27, kScreenWidth - 30, 40);
            [bookButton addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
            bookButton.layer.cornerRadius = 4.0f;
            [bookButton setTitle:@"个人支付" forState:UIControlStateNormal];
            [bookButton setBackgroundColor:[ColorUtility colorFromHex:0xfc7474]];
            [view addSubview:bookButton];
            self.tableView.tableFooterView = view;
    }
}
- (void)cancelCarOrder
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示信息"
                          message:@"确认取消叫车吗？"
                          delegate:self
                          cancelButtonTitle:@"继续等待"
                          otherButtonTitles:@"确认取消", nil];
    [alert showAlertViewWithCompleteBlock:^(NSInteger index)
     {
         if(index == 1)
         {
             if(model.orderSourceType == BeCarOrderSourceTypeCar)
             {
                 [self setupRequestCancelCall:@"false"];
             }
             else
             {
                 [self cancelJiesongji];
             }
         }
     }];
}
#pragma mark - 接送机取消
- (void)cancelJiesongji
{
    NSString *urlStr = [NSString stringWithFormat:@"%@ShouQi",@"http://192.168.10.27:8999/"];
    NSString *valueStr = [NSString stringWithFormat:@"orderNo=%@&orderId=%@&cancelType=39&channel=emax&method=cancelOrderBeforeAccepted",model.orderNo,model.orderId];
    [MBProgressHUD showMessage:@""];
    [BeSpecialCarHttp postPath:urlStr withParameters:valueStr success:^(id dict)
     {
         [MBProgressHUD hideHUD];
         NSLog(@"接送机取消叫车 = %@",dict);
     }failure:^(NSError *error){
         [MBProgressHUD hideHUD];
         NSLog(@"失败 = %@",error);
     }];
}
- (void)detailAction:(UIButton *)sender
{
    if([sender.currentTitle isEqualToString:@"取消叫车"]) {
        
        [self setupRequestCancelCall:@"false"];
    } else {
        [self setupRequestPayCenter];
    }
}
- (void)isShowDetailWithBool:(BOOL)isShow
{
    isShowDetail = isShow;
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.    
}
- (void)getData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,kCarOrderDetailUrl];
    [[ServerFactory getServerInstance:@"SBHHttp"]postPath:urlStr withParameters:@{@"orderno":_orderNo} showHud:NO success:^(NSDictionary *dict)
    {
        [model setDataWith:[dict objectForKey:@"orderinfo"]];
        if(model.isDriverInfoShow)
        {
            if(![self.dataArray containsObject:kDriverInfoSectionTitle])
            {
                [self.dataArray insertObject:kDriverInfoSectionTitle atIndex:1];
            }
        }
            else
            {
                if([self.dataArray containsObject:kDriverInfoSectionTitle])
                {
                    [self.dataArray removeObject:kDriverInfoSectionTitle];
                }
            }
            [self.tableView reloadData];
            [self setUpFooterViewAndRightBarButtonItem];
        }
    failure:^(NSError *error)
    {
        [self handleResuetCode:@"获取失败"];
    }];
}

- (void)setupRequestCancelCall:(NSString *)forceParam
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kSpeRequestUrl,@"ZC11_orderCancel"];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    NSData *data = [@"sbh:sbhzuche123" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *headerStr = [NSString stringWithFormat:@"Basic %@", [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn]];
    [request setValue:headerStr forHTTPHeaderField:@"Authorization"];
    NSString *valueStr = [NSString stringWithFormat:@"order_id=%@&force=%@&orderno=%@&accountid=%@", model.orderId, forceParam, model.orderNo, [GlobalData getSharedInstance].userModel.AccountID];
    [MBProgressHUD showMessage:@""];
    NSData *postData = [valueStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [request setHTTPBody:postData];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [MBProgressHUD hideHUD];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSString *msgStr = [dict stringValueForKey:@"status"];
        // 取消收费情况
        NSString *costStr = [dict stringValueForKey:@"cost"];
        if (costStr.length != 0) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"提示信息"
                                  message:@"取消叫车将扣10元，是否确定取消"
                                  delegate:self
                                  cancelButtonTitle:@"否"
                                  otherButtonTitles:@"是", nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger index)
             {
                 if(index == 1)
                 {
                     [self setupRequestCancelCall:@"true"];
                 }
             }];
        } else {
            if ([msgStr isEqualToString:@"true"]) {
                [MBProgressHUD showSuccess:@"已取消叫车"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            } else {
                [MBProgressHUD showError:@"取消订单失败"];
            }
        }
        
    }];
}

- (void)setupRequestPayCenter
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"SystemId"] = @"4";
    params[@"Platform"] = @"4";
    params[@"PlatType"] = @"4";
    params[@"PaySource"] = @"4";
    params[@"BankCode"] = @"";
    params[@"PayMoney"] = model.orderCost;
    params[@"BusinessCode"] = @"1";
    params[@"ReturnUrl"] = @"";
    params[@"CardNo"] = @"";
    params[@"BankAcctName"] = @"";
    params[@"BankIdType"] = @"";
    params[@"BankIdNo"] = @"";
    params[@"RiskData"] = @"";
    params[@"SharingData"] = @"";
    params[@"OrderNo"] = model.orderNo;
    params[@"UserName"] = [GlobalData getSharedInstance].userModel.AccountID;
    params[@"OrderDateTime"] = model.orderDate;
    params[@"GoodsName"] = @"支付";
    params[@"OrderInfo"] = @"支付";
    params[@"proOrderType"] = @"CR";
    [[SBHHttp sharedInstance]postPath:kPayCenterUrl withParameters:params showHud:YES success:^(NSDictionary *responseObject)
    {
        NSString *codeStr = [responseObject objectForKey:@"Code"];
        if ([codeStr isEqualToString:@"1"])
        {
            NSString *msgStr = [responseObject objectForKey:@"MsgStr"];
            [self requestAliPayWithString:msgStr];
        } else if ([codeStr isEqualToString:@"2"])
        {
            [self handleResuetCode:@"10006"];
        } else
        {
            [MBProgressHUD showError:@"支付失败"];
        }
      } failure:^(NSError * error)
     {
          [MBProgressHUD showError:@"网络不给力"];
     }];
}

// 支付宝支付接口
- (void)requestAliPayWithString:(NSString *)msgStr
{
    NSString *appScheme = @"sidebenefit";
    [[AlipaySDK defaultService] payOrder:msgStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSString *status = [resultDic stringValueForKey:@"resultStatus"];
        if ([status isEqualToString:@"9000"]) {
            [MBProgressHUD showSuccess:@"支付成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            
        } else {
            NSArray *array = [[UIApplication sharedApplication] windows];
            UIWindow *win=[array objectAtIndex:0];
            [win setHidden:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [MBProgressHUD showError:@"支付失败"];
        }
    }];
    NSArray *array = [[UIApplication sharedApplication] windows];
    UIWindow *win=[array objectAtIndex:0];
    [win setHidden:NO];
}
@end
