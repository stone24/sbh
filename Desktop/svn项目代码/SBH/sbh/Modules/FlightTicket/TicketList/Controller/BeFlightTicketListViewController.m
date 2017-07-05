//
//  chaxunjipiaoViewController.m
//  SBHAPP
//
//  Created by musmile on 14-7-1.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "BeFlightTicketListViewController.h"
#import "BeTicketQueryTableViewCell.h"
#import "BeMorePriceViewController.h"

#import "BeTicketQueryTabbar.h"
#import "BeTicketQueryPickerView.h"
#import "BeTicketQueryResultModel.h"
#import "BeTicketQueryHeaderView.h"
#import "BeTicketQueryListData.h"
#import "BeTicketQuerySelectHeaderView.h"
#import "UIAlertView+Block.h"

@interface BeFlightTicketListViewController ()
{
    BeTicketQueryListData *listData;
    BeTicketQueryTabbar *queryTabbar;
    BeTicketQueryHeaderView *headerView;
    BeTicketQuerySelectHeaderView *selectHeaderView;
}
@end

@implementation BeFlightTicketListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"top_right_index"] style:UIBarButtonItemStylePlain target:self action:@selector(backMainBtn)];
        listData = [[BeTicketQueryListData alloc]init];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[GlobalData getSharedInstance].DANSHUAN isEqualToString:@"1"]||[[GlobalData getSharedInstance].iSdancheng isEqualToString:@"OW"])
    {
        [GlobalData getSharedInstance].iTiketOrderInfo.ticketBookType = kOneWayTicketType;
        [GlobalData getSharedInstance].iTiketOrderInfo.tripType = kAirTripTypeGoing;
        if(listData.listArray.count == 0)
        {
            [self requestData];
        }
//        [self requestData];
        [self customHeader];
        [self customTableViewHeightWithSelectViewHidden:YES];
    }
    else
    {
        //只有不是第一次才会请求
        if([[GlobalData getSharedInstance].isfirst isEqualToString:@"notfirst"])
        {
            [GlobalData getSharedInstance].iTiketOrderInfo.ticketBookType = kRoundTripTicketType;
            [GlobalData getSharedInstance].iTiketOrderInfo.tripType = kAirTripTypeReturn;
            [self customTableViewHeightWithSelectViewHidden:NO];
            [self customHeader];
            [self requestData];
        }
        else
        {
            [GlobalData getSharedInstance].iTiketOrderInfo.ticketBookType = kRoundTripTicketType;
            [GlobalData getSharedInstance].iTiketOrderInfo.tripType = kAirTripTypeGoing;
            if(listData.listArray.count == 0)
            {
                [self requestData];
            }
            [self customHeader];
            [self customTableViewHeightWithSelectViewHidden:YES];
        }
    }
    [self setNavTitle];
    
}
- (void)backMainBtn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{   
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    [self customTabbar];
    [self customSelectHeaderView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessAction) name:kNotificationLoginSuccess object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLoginSuccess object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loginSuccessAction
{
    NSArray * viewControllers = [self.navigationController viewControllers];
    if(viewControllers == nil)
    {
        return;
    }
   if([[GlobalData getSharedInstance].userModel.IsInternalAirTicket intValue]== 0 && ![[GlobalData getSharedInstance].userModel.EntName isEqualToString:kAccountCondition])
    {
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的企业暂未开通机票服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al showAlertViewWithCompleteBlock:^(NSInteger index)
         {
             [self.navigationController popToRootViewControllerAnimated:YES];
             return;
         }];
    }
    [GlobalData getSharedInstance].iTiketOrderInfo.ticketBookType = kRoundTripTicketType;
    [GlobalData getSharedInstance].iTiketOrderInfo.tripType = kAirTripTypeGoing;
    [self requestData];
    [self customHeader];
    [self customTableViewHeightWithSelectViewHidden:YES];
    
    if([GlobalData getSharedInstance].userModel.isLogin && [GlobalData getSharedInstance].userModel.isEnterpriseUser)
    {
        [GlobalData getSharedInstance].iTiketOrderInfo.travelReason = kTravelReasonTypeOnBusiness;
    }
    else
    {
        [GlobalData getSharedInstance].iTiketOrderInfo.travelReason = kTravelReasonTypePrivate;
    }
}

- (void)customTableViewHeightWithSelectViewHidden:(BOOL)isHidden
{
    if(isHidden)
    {
        selectHeaderView.hidden = YES;
        self.tableView.y = kTicketQueryHeaderHeight;
        CGFloat height = CGRectGetHeight([[UIScreen mainScreen] bounds])-CGRectGetHeight(self.navigationController.navigationBar.frame)-CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)-kTicketQueryHeaderHeight - kTicketQueryTabbarHeight;
        self.tableView.height = height;
    }
    else
    {
        selectHeaderView.hidden = NO;
        NSString *dateStr = [GlobalData getSharedInstance].iTiketOrderInfo.iStartTime;
        dateStr = [dateStr substringFromIndex:5];
        selectHeaderView.dateLabel.text = dateStr;
        selectHeaderView.flightNOLabel.text = [GlobalData getSharedInstance].FLIGHTNORT;
        selectHeaderView.flightDurationLabel.text = [NSString stringWithFormat:@"%@-%@",self.GcomeTime, self.GreachTime];
        self.tableView.y = kTicketQueryHeaderHeight +kBeTicketQuerySelectHeaderHeight;
        CGFloat height = CGRectGetHeight([[UIScreen mainScreen] bounds])-CGRectGetHeight(self.navigationController.navigationBar.frame)-CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)-kTicketQueryHeaderHeight - kTicketQueryTabbarHeight - kBeTicketQuerySelectHeaderHeight;
        self.tableView.height = height;
    }
}

- (void)customSelectHeaderView
{
    selectHeaderView = [[BeTicketQuerySelectHeaderView alloc]initWithFrame:CGRectMake(0, kTicketQueryHeaderHeight, self.view.frame.size.width, kBeTicketQuerySelectHeaderHeight)];
    [self.view addSubview:selectHeaderView];
}
- (void)customHeader
{
    headerView = [[BeTicketQueryHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kTicketQueryHeaderHeight)];
    [headerView updateUIWithItem:[GlobalData getSharedInstance].iTiketOrderInfo];
    [headerView addTarget:self andBeforeAction:@selector(selectBeforeDate) andAfterAction:@selector(selectAfterDate)];
    [self.view addSubview:headerView];
}
- (void)selectBeforeDate
{
    if([GlobalData getSharedInstance].iTiketOrderInfo.tripType == kAirTripTypeGoing)
    {
        [GlobalData getSharedInstance].iTiketOrderInfo.iStartDate = [CommonMethod getTheDayBefore:[GlobalData getSharedInstance].iTiketOrderInfo.iStartDate];
    }
    else
    {
        [GlobalData getSharedInstance].iTiketOrderInfo.iEndDate = [CommonMethod getTheDayBefore:[GlobalData getSharedInstance].iTiketOrderInfo.iEndDate];
    }
    [headerView updateUIWithItem:[GlobalData getSharedInstance].iTiketOrderInfo];
    [self requestData];
}

- (void)selectAfterDate
{
    if([GlobalData getSharedInstance].iTiketOrderInfo.tripType == kAirTripTypeGoing)
    {
        [GlobalData getSharedInstance].iTiketOrderInfo.iStartDate = [CommonMethod getTheDayAfter:[GlobalData getSharedInstance].iTiketOrderInfo.iStartDate];
    }
    else
    {
        [GlobalData getSharedInstance].iTiketOrderInfo.iEndDate = [CommonMethod getTheDayAfter:[GlobalData getSharedInstance].iTiketOrderInfo.iEndDate];
    }
    [headerView updateUIWithItem:[GlobalData getSharedInstance].iTiketOrderInfo];
    [self requestData];
}

- (void)requestData
{
    [GlobalData getSharedInstance].queryTiketDate = [NSDate date];
    [MBProgressHUD showMessage:nil];
    [[GlobalData getSharedInstance].iTiketOrderInfo queryAirListWithBlock:^(NSMutableDictionary *result)
     {
         [MBProgressHUD hideHUD];
         if([[result stringValueForKey:@"guid"] length] != 0)
         {
             [self setDataWithResult:result];
         }
         else
         {
             [MBProgressHUD hideHUD];
             [self handleResuetCode:[result objectForKey:@"code"]];
             listData.isDataException = YES;
             [listData clearAllData];
             [self.tableView reloadData];
         }
     }];
}
- (void)setDataWithResult:(NSDictionary *)result
{
    NSLog(@"result = %@",result);
    [listData setDataWithDict:result WithCabinType:[GlobalData getSharedInstance].iTiketOrderInfo.cabinType andFlightNo:self.originalFlightNo and:self.querySourceType];
    [BeTicketQueryPickerView sharedInstance].ticketQueryInfo = listData;
    [[BeTicketQueryPickerView sharedInstance] addAllConditions];
    /* if (self.querySourceType==kQueryControllerSourceAlter)
     {
     [[BeTicketQueryPickerView sharedInstance] setHideCabin:YES];
     }// F C没有仓位选择
     else if (self.querySourceType==kQueryControllerSourceAlteSeveral)
     {
     [[BeTicketQueryPickerView sharedInstance] setHideCabin:YES];
     [[BeTicketQueryPickerView sharedInstance] setHideAirport:YES];
     }// 非F C没有仓位和机场选择*/
    if (self.querySourceType==kQueryControllerSourceAlter||self.querySourceType==kQueryControllerSourceAlteSeveral)
    {
        [[BeTicketQueryPickerView sharedInstance] setHideCabin:YES];
        [[BeTicketQueryPickerView sharedInstance] setHideAirport:YES];
        [[BeTicketQueryPickerView sharedInstance] setHideAirCompany:YES];
    }
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listData.filterArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeTicketQueryResultModel *model = [listData.filterArray objectAtIndex:indexPath.row];
    NSString *depStr = [NSString stringWithFormat:@"%@%@", model.DepAirportName, model.BoardPointAT];
    if (depStr.length > 6) {
        return 95;
    }
    return [BeTicketQueryTableViewCell cellHight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeTicketQueryTableViewCell *cell = [BeTicketQueryTableViewCell cellWithTableView:tableView];
    BeTicketQueryResultModel *model = [listData.filterArray objectAtIndex:indexPath.row];
    cell.querySourceType = self.querySourceType;
    [cell setCellWithItem:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeTicketQueryResultModel *resultModel = [listData.filterArray objectAtIndex:indexPath.row];
    // 判断售罄情况
    if (resultModel.isSoldOut) {
        return;
    }
    if (self.querySourceType == kQueryControllerSourceAlter || self.querySourceType == kQueryControllerSourceAlteSeveral)
    {
        BeTicketQueryResultModel *model = [listData.filterArray objectAtIndex:indexPath.row];
        self.flightModelBlock(model);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if ([[GlobalData getSharedInstance].isfirst isEqualToString:@"notfirst"]) {
            [GlobalData getSharedInstance].FLIGHTNORTt = resultModel.FlightNo;
            [GlobalData getSharedInstance].GOWw = resultModel.guid;
            [GlobalData getSharedInstance].airReachTime = resultModel.ArrivalDate;
        }
        else
        {
            [GlobalData getSharedInstance].FLIGHTNORT = resultModel.FlightNo;
            [GlobalData getSharedInstance].airReachTime = resultModel.ArrivalDate;
            [GlobalData getSharedInstance].iTiketOrderInfo.iFromAirportCode = resultModel.DepAirport;
            [GlobalData getSharedInstance].iTiketOrderInfo.iToAirportCode = resultModel.ArrAirport;
        }
#pragma mark- 机票预定页过去的数据（航班号+机型）
        NSString *kk = @"";
        if ([resultModel.POW count]>=2)
        {
            kk = [resultModel.POW objectAtIndex:1];
        }
        if ([[GlobalData getSharedInstance].isfirst isEqualToString:@"notfirst"]) {
            [GlobalData getSharedInstance].POWw = kk;
        }
        else{
            [GlobalData getSharedInstance].POW = kk;
        }
        NSArray *array = @[resultModel.DepartureTime,resultModel.ArrivalTime];
        [GlobalData getSharedInstance].array = array;
        [GlobalData getSharedInstance].DepartureDate = resultModel.DepartureDate;
        
        BeMorePriceViewController *yuding = [[BeMorePriceViewController alloc] init:listData.guid];
        yuding.airportModel = resultModel;
        [self.navigationController pushViewController:yuding animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)leftMenuClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customTabbar
{
    queryTabbar = [[BeTicketQueryTabbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) -CGRectGetHeight(self.navigationController.navigationBar.frame) - kTicketQueryTabbarHeight, self.view.frame.size.width, kTicketQueryTabbarHeight)];
    [queryTabbar addTarget:self andFilterAction:@selector(showPickerView) andTimeAction:@selector(sortWithTime) andPriceAction:@selector(sortWithPrice)];
    [self.view addSubview:queryTabbar];
}
- (void)showPickerView
{
    if(listData.isDataException)
    {
        return;
    }
    [[BeTicketQueryPickerView sharedInstance]showPickerViewWithBlock:^(void)
    {
        [listData filterWithItem:[BeTicketQueryDataSource sharedInstance]];
        [self.tableView reloadData];
        [queryTabbar updateFilterUIWith:listData];
    }];
}
- (void)sortWithTime
{
    if(listData.isDataException)
    {
        return;
    }
    listData.timeUp = !listData.timeUp;
    [listData sortTimeWithIsUp:listData.timeUp];
    [self.tableView reloadData];
    [queryTabbar updateTimeUIWith:listData];
}
- (void)sortWithPrice
{
    if(listData.isDataException)
    {
        return;
    }
    listData.priceUp = !listData.priceUp;
    [listData sortPriceIsUp:listData.priceUp];
    [self.tableView reloadData];
    [queryTabbar updatePriceUIWith:listData];
}

- (void)setNavTitle
{
    if([GlobalData getSharedInstance].iTiketOrderInfo.ticketBookType == kOneWayTicketType)
    {
        //如果是单程
        NSString *ititle = [NSString stringWithFormat:@"%@-%@",[GlobalData getSharedInstance].iTiketOrderInfo.iFromCityName,[GlobalData getSharedInstance].iTiketOrderInfo.iToCityName];
        self.title = ititle;
        listData.departCityName = [GlobalData getSharedInstance].iTiketOrderInfo.iFromCityName;
        listData.arriveCityName = [GlobalData getSharedInstance].iTiketOrderInfo.iToCityName;
    }
    else
    {
        //如果是往返
       NSMutableString *ititle = nil;
        if([GlobalData getSharedInstance].iTiketOrderInfo.tripType == kAirTripTypeGoing)
        {
            //去程
            ititle = [NSMutableString stringWithFormat:@"%@-%@(去程)",[GlobalData getSharedInstance].iTiketOrderInfo.iFromCityName,[GlobalData getSharedInstance].iTiketOrderInfo.iToCityName];
            listData.departCityName = [GlobalData getSharedInstance].iTiketOrderInfo.iFromCityName;
            listData.arriveCityName = [GlobalData getSharedInstance].iTiketOrderInfo.iToCityName;
        }
        else
        {
            //回程
            ititle = [NSMutableString stringWithFormat:@"%@-%@(回程)",[GlobalData getSharedInstance].iTiketOrderInfo.iFromCityName,[GlobalData getSharedInstance].iTiketOrderInfo.iToCityName];
            listData.departCityName = [GlobalData getSharedInstance].iTiketOrderInfo.iToCityName;
            listData.arriveCityName = [GlobalData getSharedInstance].iTiketOrderInfo.iFromCityName;
        }
        NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:ititle];
        [attrib addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} range:NSMakeRange(0, ititle.length)];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.height = 40;
        titleLabel.attributedText = attrib;
        self.navigationItem.titleView = titleLabel;
    }
}
@end
