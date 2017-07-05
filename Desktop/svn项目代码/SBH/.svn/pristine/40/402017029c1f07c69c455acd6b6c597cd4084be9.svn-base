//
//  BeAirDynamicViewController.m
//  SideBenefit
//
//  Created by SBH on 15-2-28.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeAirDynamicViewController.h"
#import "BeChooseCityViewController.h"
#import "TicketReserveSelectCityCell.h"
#import "BeDynamicDateCell.h"
#import "BeDynamicFlightListCell.h"
#import "BeDynamicFlightListController.h"
#import "BeDynamicModel.h"
#import "ColorConfigure.h"
#import "BeAirDynamicServer.h"
#import "ServerFactory.h"
#import "CalendarHomeViewController.h"
#import "CalendarDayModel.h"

#define kCityReferTitle @"起降地查询"
#define kFlightReferTitle @"航班号查询"
#define kCareFlightTitle @"已关注航班"

@interface BeAirDynamicViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIView *tableFooterView;
    UISegmentedControl *tableControl;
}

@property (nonatomic, strong) UITextField *flightTextField;
@property (nonatomic, strong) NSString *flightTextStr;
@property (nonatomic, strong) NSMutableArray *careList;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, assign) BOOL hiddenHeader;
@end

@implementation BeAirDynamicViewController

- (NSMutableArray *)careList
{
    if (_careList == nil) {
        _careList = [NSMutableArray array];
    }
    return _careList;
}
- (id)init
{
    if (self = [super init]) {
        self.type = CityReferType;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 友盟统计
    [MobClick beginEvent:@"D0001"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLabel];
    self.title = @"航班动态";
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self customView];
    [GlobalData getSharedInstance].iTiketOrderInfo = [[TicketOrderInfo alloc] init];
    [GlobalData getSharedInstance].iTiketOrderInfo.iFromCityName = @"北京";
    [GlobalData getSharedInstance].iTiketOrderInfo.iFromCityCode = @"PEK";
    [GlobalData getSharedInstance].iTiketOrderInfo.iToCityName = @"深圳";
    [GlobalData getSharedInstance].iTiketOrderInfo.iToCityCode = @"SZX";
    [GlobalData getSharedInstance].iTiketOrderInfo.iStartTime = [CommonMethod stringFromDate:[NSDate date]WithParseStr:kFormatYYYYMMDD];
    [self.tableView reloadData];
    self.hiddenHeader = YES;
    [self setSelfType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.x = 80;
    label.width = self.view.width - 160;
    label.height = 100;
    label.y = 150;
    label.textColor = SBHColor(25, 124, 234);
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 3;
    label.text = @"  您还没有关注航班\n按“起降地”和“航班号”\n  查询要关注的航班";
    [self.view addSubview:label];
    self.hintLabel = label;
    self.hintLabel.hidden = YES;
}

- (void)requestCareFlight
{
    [MBProgressHUD showMessage:@""];
    [[ServerFactory getServerInstance:@"BeAirDynamicServer"] getRequestCareFlightWithSuccessCallback:^(NSMutableArray *callback)
    {
        [MBProgressHUD hideHUD];
        [self.careList removeAllObjects];
        [self.careList addObjectsFromArray:callback];
        if (self.careList.count == 1) {
            BeDynamicModel *dyM = self.careList.firstObject;
            if (dyM.FlightNo.length == 0) {
                [self.careList removeAllObjects];
                self.hintLabel.hidden = NO;
            }
        }
        [self.tableView reloadData];
    }andFailureCallback:^(NSString *callback)
    {
        [MBProgressHUD hideHUD];
        [self.careList removeAllObjects];
        self.hintLabel.hidden = NO;
        [self.tableView reloadData];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSString *titleString = [tableControl titleForSegmentAtIndex:tableControl.selectedSegmentIndex];
    if([titleString isEqualToString:kCareFlightTitle])
    {
        
        return self.careList.count;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.hiddenHeader) {
        return 0;
    } else {
        return 100;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *titleString = [tableControl titleForSegmentAtIndex:tableControl.selectedSegmentIndex];
    if([titleString isEqualToString:kCityReferTitle]&&indexPath.row == 0)
    {
            return 84;
    }
    if([titleString isEqualToString:kCareFlightTitle])
    {
        return 95;
    }
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *titleString = [tableControl titleForSegmentAtIndex:tableControl.selectedSegmentIndex];
    if([titleString isEqualToString:kCityReferTitle] && indexPath.row == 0)
    {
        TicketReserveSelectCityCell *cell = [TicketReserveSelectCityCell cellWithTableView:tableView];
        cell.width = kScreenWidth;
        [cell setCellWith:[GlobalData getSharedInstance].iTiketOrderInfo];
        [cell addTarget:self andDepartureAction:@selector(selectDepartureCityAction) andReachAction:@selector(selectReachCityAction) andOverturnAction:@selector(exchangeCityAction)];
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    if([titleString isEqualToString:kFlightReferTitle] && indexPath.row == 0)
    {
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.frame = CGRectMake(13, 52, self.view.width - 26, 1);
        lineLabel.backgroundColor = SBHColor(223, 225, 224);
        [cell addSubview:lineLabel];
        
        UITextField *textField = [[UITextField alloc] init];
        textField.text = self.flightTextStr;
        textField.delegate = self;
        textField.x = 13;
        textField.y = 15;
        textField.width = self.view.width - 26;
        textField.height = 30;
        textField.placeholder = @"输入航班号";
        [cell addSubview:textField];
        self.flightTextField = textField;
        return cell;

    }
    if(![titleString isEqualToString:kCareFlightTitle] && indexPath.row == 1)
    {
        BeDynamicDateCell *cell = nil;
        static NSString *cell1 = @"cell1";
        cell = [tableView dequeueReusableCellWithIdentifier:cell1];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BeDynamicDateCell" owner:self options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType  = UITableViewCellAccessoryNone;
        }
        NSDate * aDate = [CommonMethod dateFromString:
                          [GlobalData getSharedInstance].iTiketOrderInfo.iStartTime
                                         WithParseStr:@"yyyy-MM-dd"];
        NSString * weekDayStr = [NSString stringWithFormat:@"星期%@",
                                 [CommonMethod getWeekDayFromDate:aDate]];
        NSString *dateStr = [NSString stringWithFormat:@"%@ %@",[GlobalData getSharedInstance].iTiketOrderInfo.iStartTime, weekDayStr];
        [cell.referDate setText:dateStr];
        return cell;
    }
    if ([titleString isEqualToString:kCareFlightTitle])
     {
         if (self.careList.count == 0) {
             UITableViewCell *cell = [[UITableViewCell alloc] init];
             return cell;
         }
        BeDynamicFlightListCell *cell = [BeDynamicFlightListCell cellWithTableView:tableView];
        BeDynamicModel *dyModel = [self.careList objectAtIndex:indexPath.row];
        cell.flightNO.text = dyModel.FlightNo;
        // 添加时间
         UILabel *dateLabel = [[UILabel alloc] init];
         dateLabel.y = cell.flightNO.y;
         dateLabel.x = cell.flightNO.x + 60;
         dateLabel.width = 80;
         dateLabel.height = 13;
         dateLabel.font = [UIFont systemFontOfSize:13];
         dateLabel.text = dyModel.FlightDeptimePlanDate;
         dateLabel.textColor = SBHColor(35, 35, 35);
         [cell addSubview:dateLabel];
         
        cell.goTimeLabel.text = dyModel.FlightDeptimePlanTime;
        cell.reachTimeLabel.text = dyModel.FlightArrtimePlanTime;
        cell.goAirportLabel.text = [NSString stringWithFormat:@"%@%@",dyModel.FlightDepAirport,dyModel.FlightHTerminal];
        cell.reachAirportLabel.text =[NSString stringWithFormat:@"%@%@",dyModel.FlightArrAirport,dyModel.FlightTerminal];
        cell.flightStateImage.image = [UIImage imageNamed:dyModel.FlightState];
        cell.careBtn.selected = dyModel.careBtnSelect;
        [cell.careBtn addTarget:self action:@selector(careBtnClick:) forControlEvents:UIControlEventTouchUpInside];
         cell.width = kScreenWidth;
        return cell;
    }
    return cell;
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
    [self setupRequestCancel:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *titleString = [tableControl titleForSegmentAtIndex:tableControl.selectedSegmentIndex];
    if([titleString isEqualToString:kCareFlightTitle])
    {
    }
     else if (indexPath.row == 1)
    {
        CalendarHomeViewController *calendarVC = [[CalendarHomeViewController alloc]init];
        [calendarVC setCalendarType:DayTipsTypeAirStart andSelectDate:[CommonMethod dateFromString:[GlobalData getSharedInstance].iTiketOrderInfo.iStartTime WithParseStr:@"yyyy-MM-dd"] andStartDate:[NSDate date]];
        calendarVC.calendarblock = ^(CalendarDayModel *selectModel)
            {
                    [GlobalData getSharedInstance].iTiketOrderInfo.iStartTime = [selectModel toString];
                    [self.tableView reloadData];
            };
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:calendarVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        [self.view endEditing:YES];
    }
}

//取消关心的航班
- (void)setupRequestCancel:(NSIndexPath *)indexPath
{
    BeDynamicModel *dyModel = [self.careList objectAtIndex:indexPath.row];
    [MBProgressHUD showMessage:@""];
    [[ServerFactory getServerInstance:@"BeAirDynamicServer"]cancelCareFlightWith:dyModel andSuccessCallback:^(NSString *success)
     {
         [MBProgressHUD hideHUD];
         [self.careList removeObjectAtIndex:indexPath.row];
         [self.tableView reloadData];
         if (self.careList.count == 0) {
             self.hintLabel.hidden = NO;
         }
     }andFailureCallback:^(NSString *failure)
     {
         [MBProgressHUD hideHUD];
         
     }];
}

- (void)selectDepartureCityAction
{
    BeChooseCityViewController *choose = [[BeChooseCityViewController alloc]init];
    choose.sourceType = kTicketDepartureType;
    choose.cityBlock = ^(CityData *acity)
    {
        [[GlobalData getSharedInstance].iTiketOrderInfo updateDepartureCityWith:acity];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:choose animated:YES];
}
- (void)selectReachCityAction
{
    BeChooseCityViewController *choose = [[BeChooseCityViewController alloc]init];
    choose.sourceType = kTicketReachType;
    choose.cityBlock = ^(CityData *acity)
    {
        [[GlobalData getSharedInstance].iTiketOrderInfo updateReachCityWith:acity];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:choose animated:YES];
}

- (void)exchangeCityAction
{
    [[GlobalData getSharedInstance].iTiketOrderInfo exchangeCity];
}

//城市交换
- (void)exchange:(UIButton *)btn{
    NSString * tmcityName = [GlobalData getSharedInstance].iTiketOrderInfo.iFromCityName;
    [GlobalData getSharedInstance].iTiketOrderInfo.iFromCityName =
    [GlobalData getSharedInstance].iTiketOrderInfo.iToCityName;
    [GlobalData getSharedInstance].iTiketOrderInfo.iToCityName   = tmcityName;
    
    NSString * tmcityCode = [GlobalData getSharedInstance].iTiketOrderInfo.iFromCityCode;
    [GlobalData getSharedInstance].iTiketOrderInfo.iFromCityCode =
    [GlobalData getSharedInstance].iTiketOrderInfo.iToCityCode;
    [GlobalData getSharedInstance].iTiketOrderInfo.iToCityCode   = tmcityCode;
    
    NSString *tmairportcode = [GlobalData getSharedInstance].iTiketOrderInfo.iFromAirportCode;
    [GlobalData getSharedInstance].iTiketOrderInfo.iFromAirportCode =
    [GlobalData getSharedInstance].iTiketOrderInfo.iToAirportCode;
    [GlobalData getSharedInstance].iTiketOrderInfo.iToAirportCode   = tmairportcode;
    
    [self.tableView reloadData];
    
}

#pragma mark --- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.flightTextStr = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)segmentAction:(UISegmentedControl *)sender
{
    self.hintLabel.hidden = YES;
    NSString *title = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    if([title isEqualToString:kCareFlightTitle])
    {
        if([GlobalData getSharedInstance].userModel.isLogin == YES)
        {
            [self requestCareFlight];
            tableFooterView.hidden = YES;
        } else {
            [BeLogUtility doLogOn];
        }
        
    }
    else{
        tableFooterView.hidden = NO;
        [self.tableView reloadData];
    }
}
- (void)inquireAction:(UIButton *)button
{
    NSString *title = [tableControl titleForSegmentAtIndex:tableControl.selectedSegmentIndex];
    if(![[tableControl titleForSegmentAtIndex:tableControl.selectedSegmentIndex]isEqualToString:kCareFlightTitle])
    {
        [self.view endEditing:YES];
        BeDynamicFlightListController *dyListVc = [[BeDynamicFlightListController alloc] init];
        dyListVc.title = [GlobalData getSharedInstance].iTiketOrderInfo.iStartTime;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        // 拼参数
        params[@"format"] = @"json";
        params[@"platform"] = @"ios";
        params[@"flightdate"] = [GlobalData getSharedInstance].iTiketOrderInfo.iStartTime;
        params[@"depcode"] = @"";
        params[@"arrcode"] = @"";
        params[@"flightno"] = @"";
        if ([title isEqualToString:kCityReferTitle]) {
            if ([[GlobalData getSharedInstance].iTiketOrderInfo.iFromCityCode isEqualToString:[GlobalData getSharedInstance].iTiketOrderInfo.iToCityCode]) {
                [CommonMethod showMessage:@"出发城市与到达城市不能为同一城市"];
                return;
            }
            params[@"depcode"] = [GlobalData getSharedInstance].iTiketOrderInfo.iFromCityCode;
            params[@"arrcode"] = [GlobalData getSharedInstance].iTiketOrderInfo.iToCityCode;
        } else {
            if (self.flightTextField.text.length == 0) {
                [CommonMethod showMessage:@"请输入要查询的航班号"];
                return;
            }
            params[@"flightno"] = self.flightTextField.text;
        }
        dyListVc.params = params;
        [self.navigationController pushViewController:dyListVc animated:YES];
    }
    
    // 友盟统计
    [MobClick event:@"D0002"];
}
- (void)customView
{
    UIView *tableHeadeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    tableControl = [[UISegmentedControl alloc]initWithItems:@[kFlightReferTitle,kCityReferTitle,kCareFlightTitle]];
    tableControl.tintColor = [ColorConfigure globalBgColor];
    if (_type == CareFlightType) {
        tableControl.selectedSegmentIndex = 2;
    } else {
        tableControl.selectedSegmentIndex = 0;
    }
    tableControl.frame = CGRectMake(15, 10, SBHScreenW - 30, 32);
    [tableControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
    [tableHeadeView addSubview:tableControl];
    UILabel *label = [[UILabel alloc] init];
    label.x = tableControl.x;
    label.width = tableControl.width;
    label.height = 100;
    label.y = CGRectGetMaxY(tableControl.frame) + 30;
    label.textColor = [ColorConfigure globalBgColor];
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 3;
    label.text = @"  您还没有关注航班\n按“起降地”和“航班号”\n  查询要关注的航班";
    label.textAlignment = NSTextAlignmentCenter;
    self.hintLabel = label;
    self.hintLabel.hidden = YES;
    [tableHeadeView addSubview:label];
    self.tableView.tableHeaderView = tableHeadeView;
    tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
    UIButton *inquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inquireButton.frame = CGRectMake(15, 30, SBHScreenW - 30, 40);
    inquireButton.layer.cornerRadius = 4.0f;
    [inquireButton addTarget:self action:@selector(inquireAction:) forControlEvents:UIControlEventTouchUpInside];
    [inquireButton setBackgroundColor:[ColorConfigure loginButtonColor]];
    [inquireButton setTitle:@"查询" forState:UIControlStateNormal];
    [tableFooterView addSubview:inquireButton];
    self.tableView.tableFooterView = tableFooterView;
    [self.tableView reloadData];
}

- (void)setSelfType
{
    if(self.type == CityReferType)
    {
        [tableControl setSelectedSegmentIndex:(NSInteger)CityReferType];
    }
    else if(self.type == FlightReferType)
    {
        [tableControl setSelectedSegmentIndex:(NSInteger)FlightReferType];
    }
    else if(self.type == CareFlightType)
    {
        [tableControl setSelectedSegmentIndex:(NSInteger)CareFlightType];
    }
    [self segmentAction:tableControl];
}
@end
