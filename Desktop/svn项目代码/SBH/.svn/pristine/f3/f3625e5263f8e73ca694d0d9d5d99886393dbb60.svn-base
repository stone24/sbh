//
//  BeTrainTicketHomeViewController.m
//  sbh
//
//  Created by RobinLiu on 15/6/15.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTrainTicketHomeViewController.h"
#import "TicketReserveSelectCityCell.h"
#import "BeTrainSelectDateCell.h"

#import "BeTrainTicketListViewController.h"
#import "CalendarHomeViewController.h"
#import "BeChooseCityViewController.h"

#import "BeTrainTicketInquireItem.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"

@interface BeTrainTicketHomeViewController ()

@end

@implementation BeTrainTicketHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"火车票";
    self.tableView.separatorColor = [UIColor clearColor];
    [self customFooterView];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return [TicketReserveSelectCityCell cellHeight];
    }
    return [BeTrainSelectDateCell cellheight];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        TicketReserveSelectCityCell *cell = [TicketReserveSelectCityCell cellWithTableView:tableView];
        [cell setCellWith:[BeTrainTicketInquireItem sharedInstance]];
        [cell addTarget:self andDepartureAction:@selector(departureCityAction) andReachAction:@selector(reachCityAction) andOverturnAction:@selector(overturnAction)];
        return cell;
    }
    else
    {
        BeTrainSelectDateCell *cell = [BeTrainSelectDateCell cellWithTableView:tableView];
        [cell setCellWith:[BeTrainTicketInquireItem sharedInstance].startDate];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 1)
    {
        [self selectDateAction];
    }
}
- (void)selectDateAction
{
    CalendarHomeViewController *calendarVC = [[CalendarHomeViewController alloc]init];
    [calendarVC setCalendarType:DayTipsTypeTrainStart andSelectDate:[BeTrainTicketInquireItem sharedInstance].startDate andStartDate:[NSDate date]];
    calendarVC.calendarblock = ^(CalendarDayModel *selectModel)
    {
        [BeTrainTicketInquireItem sharedInstance].startDate = selectModel.date;
        [BeTrainTicketInquireItem sharedInstance].startDateStr = [selectModel toString];
        [self.tableView reloadData];
    };
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:calendarVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
- (void)inquireAction
{
    if([[BeTrainTicketInquireItem sharedInstance].fromTrainStation isEqualToString:[BeTrainTicketInquireItem sharedInstance].toTrainStation])
    {
        [CommonMethod showMessage:@"出发站与到达站不能相同"];
        return;
    }
    BeTrainTicketListViewController *listVC = [[BeTrainTicketListViewController alloc]init];
    [self.navigationController pushViewController:listVC animated:YES];
}
- (void)departureCityAction{
    BeChooseCityViewController *chooseVC = [[BeChooseCityViewController alloc]init];
    chooseVC.sourceType = kTrainDepartureType;
    chooseVC.cityBlock = ^(CityData *selectCity) {
        [BeTrainTicketInquireItem sharedInstance].fromTrainStation = selectCity.iCityName;
        [BeTrainTicketInquireItem sharedInstance].fromStationCode = selectCity.iCityCode;

        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:chooseVC animated:YES];
}
- (void)reachCityAction
{
    BeChooseCityViewController *chooseVC = [[BeChooseCityViewController alloc]init];
    chooseVC.sourceType = kTrainArriveType;
    chooseVC.cityBlock = ^(CityData *selectCity) {
        [BeTrainTicketInquireItem sharedInstance].toTrainStation = selectCity.iCityName;
        [BeTrainTicketInquireItem sharedInstance].toStationCode = selectCity.iCityCode;
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:chooseVC animated:YES];
}
- (void)overturnAction
{
    NSString *tempString = [BeTrainTicketInquireItem sharedInstance].fromTrainStation;
    [BeTrainTicketInquireItem sharedInstance].fromTrainStation = [BeTrainTicketInquireItem sharedInstance].toTrainStation;
    [BeTrainTicketInquireItem sharedInstance].toTrainStation = tempString;
    tempString = [BeTrainTicketInquireItem sharedInstance].fromStationCode;
    [BeTrainTicketInquireItem sharedInstance].fromStationCode = [BeTrainTicketInquireItem sharedInstance].toStationCode;
    [BeTrainTicketInquireItem sharedInstance].toStationCode = tempString;
}
-(void)customFooterView
{
    UIView *tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    UIButton *inquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inquireButton.frame = CGRectMake(15, 30, SBHScreenW - 30, 40);
    inquireButton.layer.cornerRadius = 4.0f;
    [inquireButton addTarget:self action:@selector(inquireAction) forControlEvents:UIControlEventTouchUpInside];
    [inquireButton setBackgroundColor:[ColorConfigure loginButtonColor]];
    [inquireButton setTitle:@"查询车票" forState:UIControlStateNormal];
    [tableFooterView addSubview:inquireButton];
    self.tableView.tableFooterView = tableFooterView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
