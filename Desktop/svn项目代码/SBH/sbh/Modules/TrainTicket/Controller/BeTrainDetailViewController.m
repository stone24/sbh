//
//  BeTrainDetailViewController.m
//  sbh
//
//  Created by RobinLiu on 15/6/23.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTrainDetailViewController.h"
#import "BeTrainDetailTableViewCell.h"
#import "BeTicketQueryHeaderView.h"
#import "BeTrainNumberTableViewCell.h"
#import "MJRefresh.h"
#import "BeTrainBookingController.h"
#import "BeTrainBookModel.h"
#import "BeTrainTicketInquireItem.h"
#import "ServerFactory.h"
#import "BeTrainServer.h"
#import "BeTrainDefines.h"

#define kTipsText @"您好，因12306晚间不能订票，22:30-7:30身边惠商旅版代理火车票订单，8:00之后为您采购出票，如紧急购票请至线下采购，给您带来的不便敬请谅解!"
@interface BeTrainDetailViewController ()<BeTrainDetailDelegate>
{
    BeTicketQueryHeaderView *headerView;
    BeTrainBookModel *bookModel;
    BeTrainTicketInquireItem *inquireItem;
    BOOL isShowTips;
    NSString *trainCode;
}

@end

@implementation BeTrainDetailViewController
- (id)init
{
    if(self = [super init])
    {
        isShowTips = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self customNav];
    [self customHeaderView];
    [self customTableViewHeight];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
}

- (void)refreshAction
{
    [self getData];
}
- (void)initData
{
    trainCode = [NSString stringWithFormat:@"%@",self.model.TrainCode];
    bookModel = [[BeTrainBookModel alloc]init];
    bookModel.guidSearch = [BeTrainTicketInquireItem sharedInstance].GuidSearch;
    inquireItem = [[BeTrainTicketInquireItem alloc]init];
    inquireItem.startDate = [BeTrainTicketInquireItem sharedInstance].startDate;
    inquireItem.fromTrainStation = [[BeTrainTicketInquireItem sharedInstance].fromTrainStation mutableCopy];;
    inquireItem.toTrainStation = [[BeTrainTicketInquireItem sharedInstance].toTrainStation mutableCopy];
    [self setupDatas];
}
- (void)setupDatas
{
    [bookModel configureTrainInfoWithModel:self.model];
    NSDate *currentDate = [CommonMethod dateFromString:[NSString stringWithFormat:@"%@",self.model.serverTime] WithParseStr:@"yyyy-MM-dd HH:mm:ss"];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    NSInteger thisHour = [currentComps hour];
    NSInteger thisMinute = [currentComps minute];
    if(thisHour < 7)
    {
        isShowTips = YES;
    }
    else if(thisHour == 7 && thisMinute <= 30)
    {
        isShowTips = YES;
    }
    else if(thisHour == 7 && thisMinute >= 30)
    {
        isShowTips = NO;
    }
    else if (thisHour > 7 && thisHour <= 22)
    {
        isShowTips = NO;
    }
    
    else if (thisHour == 22 && thisMinute <= 30)
    {
        isShowTips = NO;
    }
    else if(thisHour == 22 && thisMinute > 30)
    {
        isShowTips = YES;
    }
    else if (thisHour > 22)
    {
        isShowTips = YES;
    }
    else
    {
        isShowTips = NO;
    }
    [self.dataArray removeAllObjects];
    if(self.model.Rz2Seat.canDisplay)
    {
        [self.dataArray addObject:self.model.Rz2Seat];
    }
    if(self.model.Rz1Seat.canDisplay)
    {
        [self.dataArray addObject:self.model.Rz1Seat];
    }
    if(self.model.SwzSeat.canDisplay)
    {
        [self.dataArray addObject:self.model.SwzSeat];
    }
    if(self.model.YwSeat.canDisplay)
    {
        [self.dataArray addObject:self.model.YwSeat];
    }
    if(self.model.RwSeat.canDisplay)
    {
        [self.dataArray addObject:self.model.RwSeat];
    }
    if(self.model.TdzSeat.canDisplay)
    {
        [self.dataArray addObject:self.model.TdzSeat];
    }
    if(self.model.GrwSeat.canDisplay)
    {
        [self.dataArray addObject:self.model.GrwSeat];
    }
    if(self.model.RzSeat.canDisplay)
    {
        [self.dataArray addObject:self.model.RzSeat];
    }
    if(self.model.YzSeat.canDisplay)
    {
        [self.dataArray addObject:self.model.YzSeat];
    }
    if(self.model.WzSeat.canDisplay)
    {
        [self.dataArray addObject:self.model.WzSeat];
    }
    [self.tableView reloadData];
}
- (void)customTableViewHeight
{
    self.tableView.y = kTicketQueryHeaderHeight;
    CGFloat height = CGRectGetHeight([[UIScreen mainScreen] bounds])-CGRectGetHeight(self.navigationController.navigationBar.frame)-CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)-kTicketQueryHeaderHeight;
    self.tableView.height = height;
}
- (void)customHeaderView
{
    headerView = [[BeTicketQueryHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kTicketQueryHeaderHeight)];
    [headerView updateUIWithItem:inquireItem];
    [headerView addTarget:self andBeforeAction:@selector(beforeDayAction) andAfterAction:@selector(nextDayAction)];
    [self.view addSubview:headerView];
}

- (void)beforeDayAction
{
    [self.dataArray removeAllObjects];
    inquireItem.startDate = [CommonMethod getTheDayBefore:inquireItem.startDate];
    [headerView updateUIWithItem:inquireItem];
    [self getData];
}
- (void)nextDayAction
{
    [self.dataArray removeAllObjects];
    inquireItem.startDate = [CommonMethod getTheDayAfter:inquireItem.startDate];
    [headerView updateUIWithItem:inquireItem];
    [self getData];
}
- (void)getData
{
    [[ServerFactory getServerInstance:@"BeTrainServer"]getDataWithItem:inquireItem andSuccess:^(NSDictionary *dict)
     {
         for(NSDictionary *member in [dict objectForKey:@"ticketlist"])
         {
             NSDictionary *priceDict = [member objectForKey:@"Price"];
             if([[priceDict objectForKey:@"TrainCode"]isEqualToString:trainCode])
             {
                 self.model = nil;
                 self.model = [[BeTrainTicketListModel alloc]initWithDict:member];
                 self.model.serverTime = [dict stringValueForKey:@"servertime" defaultValue:@""];
                 [self setupDatas];
             }
         }
         [self endGetdata];
     }andFailure:^(NSError *error)
     {
         [self requestFlase:error];
         [self endGetdata];
     }];
}
- (void)endGetdata
{
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}
- (void)backMainBtn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;

       /* if(isShowTips)
        {
            return 2;
        }
        else
        {
            return 1;
        }*/
    }
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            return [BeTrainNumberTableViewCell cellHeight];
        }
        if(indexPath.row == 1)
        {
            if(kIs_iPhone4|| kIs_iPhone5)
            {
               return [self getTextHeight:kTipsText] + 40;
            }
            return [self getTextHeight:kTipsText] + 20;
        }
    }
    return [BeTrainDetailTableViewCell cellHeight];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 7.0f;
    }
    return 0.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            BeTrainNumberTableViewCell *cell = [BeTrainNumberTableViewCell cellWithTableView:tableView];
            cell.model = self.model;
            return cell;
        }
        if(indexPath.row == 1)
        {
            UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text = kTipsText;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            return cell;
        }
    }
    if(indexPath.section == 1)
    {
        BeTrainDetailTableViewCell *cell = [BeTrainDetailTableViewCell cellWithTableView:tableView];
        cell.delegate = self;
        [cell showDetailWith:[self.dataArray objectAtIndex:indexPath.row] andIndexPath:indexPath andModel:self.model];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)bookButtonDidClickWithIndexPath:(NSIndexPath *)indexPath
{
    if(isShowTips)
    {
        [CommonMethod showMessage:@"因12306夜间不能售票，暂不能办理火车票业务"];
        return;
    }
    if(![self isEnableBook])
    {
        [CommonMethod showMessage:@"请预定发车前1.5小时的车"];
        return;
    }
    if(![GlobalData getSharedInstance].userModel.isLogin)
    {
        [BeLogUtility doLogOn];
        return;
    }
    if([GlobalData getSharedInstance].userModel.accountType == AccountTypeEntIndividual && ([[GlobalData getSharedInstance].userModel.StaffBaoLi intValue] != 1))
    {
        //\"StaffBaoLi\":1//三级员工帐户是否开通保理1开通
        [CommonMethod showMessage:[NSString stringWithFormat:@"未开通%@权限，不能预订火车票",kPayTipString]];
        return;
    }
    BeTrainSeatModel *model = [self.dataArray objectAtIndex:indexPath.row];
    bookModel.selectPrice = [NSString stringWithFormat:@"%.1f",model.seatPrice];
    bookModel.selectSeat = [model.seatName mutableCopy];
    bookModel.selectCount = [model.seatCount mutableCopy];
    bookModel.selectSeatCode = [model.seatCode mutableCopy];
    [bookModel clearCache];
    BeTrainBookingController *bookVC = [[BeTrainBookingController alloc]init];
    bookVC.bookModel = bookModel;
    [self.navigationController pushViewController:bookVC animated:YES];
}
- (BOOL)isEnableBook
{
    /*
     预定发车前1.5小时的车
     发车后不能改签
     改签只能改签发车前1.5小时的车
     地点暂时不让改
     发车前1.5小时前能退票
     */
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *startTime = [NSString stringWithFormat:@"%@ %@:00",self.model.SDate,self.model.StartTime];
    NSDate *date1 = [formatter dateFromString:startTime];
    NSDate *date2 = [NSDate date];
    NSTimeInterval aTimer = [date1 timeIntervalSinceDate:date2];
    if(aTimer >= 90*60)
    {
        return YES;
    }
    return NO;
}
- (void)customNav
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"top_right_index"] style:UIBarButtonItemStylePlain target:self action:@selector(backMainBtn)];

    //快速 特快 普通 高速 动车 城际
    if([self.model.TrainCode hasPrefix:@"G"])
    {
        self.title = [NSString stringWithFormat:@"高铁 %@",self.model.TrainCode];
    }
    else if([self.model.TrainCode hasPrefix:@"D"])
    {
        self.title = [NSString stringWithFormat:@"动车 %@",self.model.TrainCode];
    }else if([self.model.TrainCode hasPrefix:@"C"])
    {
        self.title = [NSString stringWithFormat:@"城际 %@",self.model.TrainCode];
    }else if([self.model.TrainCode hasPrefix:@"K"])
    {
        self.title = [NSString stringWithFormat:@"快速 %@",self.model.TrainCode];
    }else if([self.model.TrainCode hasPrefix:@"T"])
    {
        self.title = [NSString stringWithFormat:@"特快 %@",self.model.TrainCode];
    }else
    {
        self.title = [NSString stringWithFormat:@"普通 %@",self.model.TrainCode];
    }
}

- (CGFloat)getTextHeight:(NSString *)text
{
    CGRect textSize = [text boundingRectWithSize:CGSizeMake(kScreenWidth - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    return textSize.size.height;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
