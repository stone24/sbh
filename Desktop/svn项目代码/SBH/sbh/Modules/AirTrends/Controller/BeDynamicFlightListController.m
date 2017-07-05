//
//  BeDynamicFlightListController.m
//  SideBenefit
//
//  Created by SBH on 15-3-6.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeDynamicFlightListController.h"
#import "BeDynamicFlightListCell.h"
#import "BeDynamicModel.h"
#import "ServerConfigure.h"
#import "CommonMethod.h"
#import "SBHHttp.h"

@interface BeDynamicFlightListController ()<UIAlertViewDelegate>
@end

@implementation BeDynamicFlightListController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self rightMenuClick];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shuaxin"] style:UIBarButtonItemStylePlain target:self action:@selector(rightMenuClick)];
    self.tableView.backgroundColor = SBHColor(249, 249, 249);
}

- (void)leftMenuClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightMenuClick
{
    [self.dataArray removeAllObjects];
    [self requestCityRefer];
}

- (void)requestCityRefer
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kServerHost,@"AirFlight/SearchFlightDynamic"];
    [[SBHHttp sharedInstance]postPath:urlStr withParameters:self.params showHud:YES success:^(NSDictionary *responseObject)
    {
        NSArray *array = [responseObject objectForKey:@"dt"];
        if (array.count == 0) return;
        if ([[array firstObject] isKindOfClass:[NSArray class]])
        {
            array = [array firstObject];
        }
        NSDictionary *firstDict = array.firstObject;
        if ([[firstDict  objectForKey:@"FlightNo"] length] == 0)
            return;
        for (NSDictionary *dict in array)
        {
            [self.dataArray addObject:[BeDynamicModel mj_objectWithKeyValues:dict]];
        }
              
        NSArray *array00 = [responseObject objectForKey:@"gzlb"];
        for (NSDictionary *dict in array00)
        {
            NSString *careFlightNo = [dict objectForKey:@"Flightno"];
            NSString *dynTimeStr = [dict objectForKey:@"Times"];
            NSArray *strArray = [dynTimeStr componentsSeparatedByString:@" "];
            NSString *dateStr = @"";
            if (strArray.count >= 1)
            {
                dateStr = strArray.firstObject;
            }
                  
            dateStr = [dateStr stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
            NSDate *dynDate = [CommonMethod dateFromString:dateStr WithParseStr:kFormatYYYYMMDD];
                  
            for (BeDynamicModel *dyModel in self.dataArray)
            {
                BOOL sameDate = [dynDate isEqualToDate:[CommonMethod dateFromString:dyModel.FlightDeptimePlanDate WithParseStr:kFormatYYYYMMDD]];
                if ([dyModel.FlightNo isEqualToString:careFlightNo] && [dyModel.FlightDepcode isEqualToString:[dict objectForKey:@"Depcode"]] && [dyModel.FlightArrcode isEqualToString:[dict objectForKey:@"Arrcode"]] && sameDate)
                {
                    dyModel.careBtnSelect = YES;
                    break;
                }
            }
        }
        [self.tableView reloadData];
      }failure:^(NSError *error)
     {
         NSString *codeStr = [[error userInfo] stringValueForKey:@"code"];
         [self handleResuetCode:codeStr];
      }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==3001) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [BeLogUtility doLogOn];
        });
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BeDynamicFlightListCell *cell = [BeDynamicFlightListCell cellWithTableView:tableView];
    BeDynamicModel *dyModel = [self.dataArray objectAtIndex:indexPath.row];
    cell.flightNO.text = dyModel.FlightNo;
    cell.goTimeLabel.text = dyModel.FlightDeptimePlanTime;
    cell.reachTimeLabel.text = dyModel.FlightArrtimePlanTime;
    cell.goAirportLabel.text = [NSString stringWithFormat:@"%@%@",dyModel.FlightDepAirport,dyModel.FlightHTerminal];
    cell.reachAirportLabel.text =[NSString stringWithFormat:@"%@%@",dyModel.FlightArrAirport,dyModel.FlightTerminal];
    cell.flightStateImage.image = [UIImage imageNamed:dyModel.FlightState];
    cell.flightStateImage.size = [UIImage imageNamed:dyModel.FlightState].size;
    [cell.careBtn addTarget:self action:@selector(careBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.careBtn.selected = dyModel.careBtnSelect;
    [cell.careBtn setBackgroundImage:nil forState:UIControlStateSelected];
    [cell.careBtn setImage:nil forState:UIControlStateSelected];
    if ([dyModel.FlightState isEqualToString:@"zhuangtai_beijiang"]) {
        // 备降
    }
    cell.sepLabel.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)careBtnClick:(UIButton *)btn
{
    BeDynamicFlightListCell *dyCell = nil;
    if (iOS8) {  // ios8
        dyCell = (BeDynamicFlightListCell *)[[btn superview] superview];
    } else { // ios7
        dyCell = (BeDynamicFlightListCell *)[[[btn superview] superview] superview];
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:dyCell];
    if (dyCell.careBtn.selected) {
        [self setupRequestCancel:indexPath];
    } else {
        [self setupRequestCare:indexPath];
    }
}

- (void)setupRequestCare:(NSIndexPath *)indexPath
{
    BeDynamicModel *dyModel = [self.dataArray objectAtIndex:indexPath.row];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kServerHost, @"AirFlight/AddFlightDynamic"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 拼参数
    params[@"flightdate"] = dyModel.FlightDeptimePlanDate;
    params[@"flightno"] = dyModel.FlightNo;
    params[@"arrcode"] = dyModel.FlightArrcode;
    params[@"depcode"] = dyModel.FlightDepcode;
    [[SBHHttp sharedInstance]postPath:urlStr withParameters:params showHud:YES success:^(NSDictionary *responseObject)
     {
         dyModel.careBtnSelect = YES;
         [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
     } failure:^( NSError * error)
     {
     }];
}
//    取消航班动态
- (void)setupRequestCancel:(NSIndexPath *)indexPath
{
    BeDynamicModel *dyModel = [self.dataArray objectAtIndex:indexPath.row];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kServerHost,@"AirFlight/CancelFlightDynamic"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 拼参数
    params[@"flightdate"] = dyModel.FlightDeptimePlanDate;
    params[@"flightno"] = dyModel.FlightNo;
    params[@"arrcode"] = dyModel.FlightArrcode;
    params[@"depcode"] = dyModel.FlightDepcode;
    [[SBHHttp sharedInstance]postPath:urlStr withParameters:params showHud:YES success:^(NSDictionary *responseObject)
     {
         dyModel.careBtnSelect = NO;
         [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(NSError * error)
    {
    }];
}
@end
