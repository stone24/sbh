//
//  BeTicketPriceBaseViewController.m
//  sbh
//
//  Created by RobinLiu on 16/3/15.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeTicketPriceBaseViewController.h"

@interface BeTicketPriceBaseViewController ()

@end

@implementation BeTicketPriceBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 6001) {
        if (buttonIndex == 1) {
            BeFlightTicketListViewController *longinVC = (BeFlightTicketListViewController *)[self getNavigationHistoryVC:                                                                                                                                                         [BeFlightTicketListViewController class]];
            longinVC.querySourceType = kQueryControllerSourceReturn;
            if(longinVC !=nil) {
                [self.navigationController popToViewController:longinVC animated:YES];
            }
        } else {
            [GlobalData getSharedInstance].isfirst = @"isfirst";
        }
    } else if (alertView.tag == 6002) {
        if (buttonIndex == 1) {
            BeFlightOrderWriteViewController *dingdan = [[BeFlightOrderWriteViewController alloc] init];
            [self.navigationController pushViewController:dingdan animated:YES];
        }
    }
    if (alertView.tag==3001)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [BeLogUtility doLogOn];
        });
    }
}
- (void)recordDataWith:(BeTicketDetailModel *)detailModel andAirport:(BeTicketQueryResultModel *)airportModel
{
    if ([[GlobalData getSharedInstance].isfirst isEqualToString:@"notfirst"]) {
        [GlobalData getSharedInstance].FLIGHTNORTt = airportModel.FlightNo;
        [GlobalData getSharedInstance].GOWw = airportModel.guid;
        [GlobalData getSharedInstance].airReachTime = airportModel.ArrivalDate;
    }
    else
    {
        [GlobalData getSharedInstance].FLIGHTNORT = airportModel.FlightNo;
        [GlobalData getSharedInstance].airReachTime = airportModel.ArrivalDate;
        [GlobalData getSharedInstance].iTiketOrderInfo.iFromAirportCode = airportModel.DepAirport;
        [GlobalData getSharedInstance].iTiketOrderInfo.iToAirportCode = airportModel.ArrAirport;
    }
#pragma mark- 机票预定页过去的数据（航班号+机型）
    NSString *kk = @"";
    if ([airportModel.POW count]>=2)
    {
        kk = [airportModel.POW objectAtIndex:1];
    }
    if ([[GlobalData getSharedInstance].isfirst isEqualToString:@"notfirst"]) {
        [GlobalData getSharedInstance].POWw = kk;
    }
    else{
        [GlobalData getSharedInstance].POW = kk;
    }
    NSArray *array = @[airportModel.DepartureTime,airportModel.ArrivalTime];
    [GlobalData getSharedInstance].array = array;
    [GlobalData getSharedInstance].DepartureDate = airportModel.DepartureTime;
    
    
    if ([[GlobalData getSharedInstance].iSdancheng isEqualToString:@"RT"]&&[[GlobalData getSharedInstance].isfirst isEqualToString:@"isfirst"])
    {
        //往返的往
        [GlobalData getSharedInstance].isfirst = @"notfirst";
        NSString * count = [detailModel.infoDict objectForKey:@"Seat"];
        if ([count isEqualToString:@""]) {
            [GlobalData getSharedInstance].seatTicketNum = nil;
        }
        else{
            [GlobalData getSharedInstance].seatTicketNum = count;
        }
        NSArray *array = [[detailModel.infoDict objectForKey:@"price"] componentsSeparatedByString:@"|"];
        [GlobalData getSharedInstance].POW = [array objectAtIndex:1];
        [GlobalData getSharedInstance].GOW = [detailModel.infoDict objectForKey:@"guid"];
        BeFlightTicketListViewController *listVC = (BeFlightTicketListViewController *)[self getNavigationHistoryVC:                                                                                                                                                         [BeFlightTicketListViewController class]];
        [[GlobalData getSharedInstance].chooseFlightArray removeAllObjects];
        [[GlobalData getSharedInstance].chooseFlightArray addObject:detailModel];
        // 传递数据（出发到达时间）
        NSString *str1 = [[GlobalData getSharedInstance].array objectAtIndex:0];
        NSString* string1 = [str1 substringToIndex:2];//截取下标7之后的字符串
        NSString *string11 =[str1 substringFromIndex:2];//截取下标2之前的字符串
        listVC.GcomeTime = [NSString stringWithFormat:@"%@:%@",string1,string11];
        NSString *str2 = [[GlobalData getSharedInstance].array objectAtIndex:1];
        NSString* string2 = [str2 substringToIndex:2];//截取下标7之后的字符串
        NSString *string22 =[str2 substringFromIndex:2];//截取下标2之前的字符串
        listVC.GreachTime = [NSString stringWithFormat:@"%@:%@",string2,string22];
        
        listVC.querySourceType = kQueryControllerSourceReturn;
        if (detailModel.priceType != TicketSharePriceType) {
            if(listVC !=nil) {
                
                [self.navigationController popToViewController:listVC animated:YES];
            }
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您选择的共享价，退改规则仅供参考，以实际发生为准，是否继续？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
            alertView.tag = 6001;
            [alertView show];
        }
    }
    else{
        NSString *count = [detailModel.infoDict objectForKey:@"Seat"];
        if ([count isEqualToString:@""])
        {
            if ([[GlobalData getSharedInstance].iSdancheng isEqualToString:@"OW"])
            {
                [GlobalData getSharedInstance].seatTicketNum = nil;
            }
        }
        else
        {
            
            NSString *str = [GlobalData getSharedInstance].seatTicketNum;
            
            if (str.length != 0 && [[GlobalData getSharedInstance].iSdancheng isEqualToString:@"RT"])
            {
                if ([count intValue]< [str intValue])
                {
                    [GlobalData getSharedInstance].seatTicketNum = count;
                }
            }
            else
            {
                [GlobalData getSharedInstance].seatTicketNum = count;
            }
        }
        [GlobalData getSharedInstance].ForcedInsurance = detailModel.ForcedInsurance;
        NSArray *array = [[detailModel.infoDict objectForKey:@"price"] componentsSeparatedByString:@"|"];
        BeFlightOrderWriteViewController *dingdan = [[BeFlightOrderWriteViewController alloc]init];
        
        if ([[GlobalData getSharedInstance].iSdancheng isEqualToString:@"OW"])
        {
            //单程
            [GlobalData getSharedInstance].GOW = [detailModel.infoDict objectForKey:@"guid"];
            [GlobalData getSharedInstance].POW = [array objectAtIndex:1];
            [[GlobalData getSharedInstance].chooseFlightArray removeAllObjects];
            [[GlobalData getSharedInstance].chooseFlightArray addObject:detailModel];
        }
        else
        {
            //往返的第二次
            [GlobalData getSharedInstance].GOWw = [detailModel.infoDict objectForKey:@"guid"];
            [GlobalData getSharedInstance].POWw = [array objectAtIndex:1];
            if ([GlobalData getSharedInstance].chooseFlightArray.count > 1)
            {
                [[GlobalData getSharedInstance].chooseFlightArray removeLastObject];
            }
            [[GlobalData getSharedInstance].chooseFlightArray addObject:detailModel];
        }
        
        if (detailModel.priceType != TicketSharePriceType)
        {
            [self.navigationController pushViewController:dingdan animated:YES];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您选择的共享价，退改规则仅供参考，以实际发生为准，是否继续？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
            alertView.tag = 6002;
            [alertView show];
        }
    }
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
