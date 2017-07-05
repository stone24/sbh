//
//  BeTrainAlterationController.m
//  sbh
//
//  Created by SBH on 15/6/18.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTrainAlterationController.h"
#import "CalendarHomeViewController.h"
#import "BeAlterationFlightCell.h"
#import "SBHItemHeaderView.h"
#import "BeTrainOrderInfoModel.h"
#import "SBHHttp.h"
#import "BeTrainTicketListViewController.h"
#import "BeTrainTicketListModel.h"


@interface BeTrainAlterationController ()

@property (nonatomic, strong) NSArray *tickekArray;
// 返程所有机票
@property (nonatomic, strong) NSMutableArray *BackTickekArray;
// 去程所有机票
@property (nonatomic, strong) NSMutableArray *perArray;
@property (nonatomic, strong) NSMutableArray *flightArray;

@property (nonatomic, weak) UIButton *submitBtn;

// 是否有选航班
@property (nonatomic, assign) BOOL isDidChooseFlight;

@property (nonatomic, assign) BOOL isAltGo;
@property (nonatomic, assign) BOOL isAltBack;

@end

@implementation BeTrainAlterationController

- (NSArray *)tickekArray
{
    if (_tickekArray == nil) {
        _tickekArray = [NSArray array];
    }
    return _tickekArray;
}

- (NSMutableArray *)BackTickekArray
{
    if (_BackTickekArray == nil) {
        _BackTickekArray = [NSMutableArray array];
    }
    return _BackTickekArray;
}

- (NSMutableArray *)perArray
{
    if (_perArray == nil) {
        _perArray = [NSMutableArray array];
    }
    return _perArray;
}

- (NSMutableArray *)flightArray
{
    if (_flightArray == nil) {
        _flightArray = [NSMutableArray array];
    }
    return _flightArray;
}

//- (void)setInfoM:(BeTrainOrderInfoModel *)infoM
//{
//    _infoM = infoM;
//
//    NSArray *perArray = infoM.psglist;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = self.view.bounds;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [self setupTableFooterView];
    
}

- (UIView *)setupTableFooterView
{
    UIView *footView = [[UIView alloc] init];
    footView.height = 80;
    UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    footerButton.x = 15;
    footerButton.y = 20;
    footerButton.width = SBHScreenW - 30;
    footerButton.height = 44;
    footerButton.layer.cornerRadius = 4.0f;
    footerButton.backgroundColor = SBHColor(230, 230, 230);
    [footerButton setTitle:@"提交改签" forState:UIControlStateNormal];
    [footerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerButton addTarget:self action:@selector(submitApplyAction:) forControlEvents:UIControlEventTouchUpInside];
    footerButton.enabled = NO;
    [footView addSubview:footerButton];
    self.submitBtn = footerButton;
    return footView;
}

// 提交按钮状态
- (void)setupSubmitBtnStatus
{
    if ([self setupCheckPassenger] && self.isDidChooseFlight) {
        self.submitBtn.enabled = YES;
        self.submitBtn.backgroundColor = SBHYellowColor;
    } else {
        self.submitBtn.enabled = NO;
        self.submitBtn.backgroundColor = SBHColor(230, 230, 230);
    }
    
}

#pragma mark - 提交改签监听事件
- (void)submitApplyAction:(UIButton *)btn
{
    [self queryRefund];
}

// 改签接口调用
- (void)queryRefund
{
    //
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kServerHost,@"Train/TrainTGQ"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    BeTrainInfoModel *trainM = self.infoM.traininfolist.firstObject;
    params[@"trainorderno"] = self.infoM.orderno;
    params[@"type"] = @"GSQ";
    params[@"tickets"] = [self setupPersonParam];
    params[@"changeremark"] = [self spellAltFlightInfo];
    params[@"usertoken"] = [GlobalData getSharedInstance].token;
    params[@"times"] = trainM.departtime;
    [[SBHHttp sharedInstance] postPath:urlStr withParameters:params showHud:YES success:^(id responseObj) {
        [MBProgressHUD showSuccess:@"申请成功！！！"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        [self requestFlase:error];
    }];
}

// 乘机人是否有被选中的
- (BOOL)setupCheckPassenger
{
    for (BeTrainPassengerModel *pasModel in self.infoM.psglist) {
        if(pasModel.isChecked) {
            return YES;
        }
    }
    return NO;
}


//乘机人
- (NSArray *)setupPersonParam
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (BeTrainPassengerModel *pasModel in self.infoM.psglist) {
      if(pasModel.isChecked) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"hfairlinename"] = pasModel.offpointname;
            dict[@"hfpsgname"] = pasModel.psgname;
            dict[@"hfboardpoint"] = pasModel.boardpointname;
            dict[@"hfpassengersno"] = pasModel.passengersno;
            dict[@"hftid"] = pasModel.tid;
            dict[@"hfbillid"] = pasModel.billid;
            dict[@"hftickettagno"] = pasModel.ticketno;
            BeTrainInfoModel *trainM = self.infoM.traininfolist.firstObject;
            dict[@"fltstartdatesel"] = trainM.departdate;
            dict[@"txtflightno"] = pasModel.trainno;
            dict[@"ddlticketclassname"] = pasModel.ticketclassname;
            [arrayM addObject:dict];

        }
    }
    return arrayM;
}
    
// 要改签航班信息
- (NSString *)spellAltFlightInfo
{
    // 改签的航班信息
    NSString *changeremarkStr = [NSString stringWithFormat:@""];
//    if (self.isAltGo) {
//        BeFlightModel *flModel = self.flightArray.firstObject;
//        NSString *tempStr = [NSString stringWithFormat:@"去程改签日期:%@\n去程改签航班:%@ %@\n\n", flModel.fltdate, flModel.carriername, flModel.flightno];
//        changeremarkStr = [changeremarkStr stringByAppendingString:tempStr];
//    }
//    if (self.isAltBack) {
//        BeFlightModel *flModel = self.flightArray.lastObject;
//        NSString *tempStr = [NSString stringWithFormat:@"返程改签日期:%@\n返程改签航班:%@ %@", flModel.fltdate, flModel.carriername, flModel.flightno];
//        changeremarkStr = [changeremarkStr stringByAppendingString:tempStr];
//    }
    
    return changeremarkStr;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.infoM.psglist.count;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 40;
    }
    return 75;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 50;
    }
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"passengerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.section == 1) {
        BeAlterationFlightCell *cell = [BeAlterationFlightCell cellWithTableView:tableView];
        BeTrainInfoModel *trainM = self.infoM.traininfolist.firstObject;
        BeTrainPassengerModel *pasM = self.infoM.psglist.firstObject;
        if (indexPath.row == 0) {
            trainM.altTilteStr = @"选择去程日期";
            trainM.altValueStr = trainM.departdate;
        } else {
            trainM.altTilteStr = @"选择去程车次";
            trainM.altValueStr = [NSString stringWithFormat:@"%@/%@", pasM.trainno, pasM.ticketclassname];
        }
        
        cell.trainM = trainM;
        return cell;
    }
    
    BeTrainPassengerModel *pasModel = [self.infoM.psglist objectAtIndex:indexPath.row];
    cell.textLabel.text = pasModel.psgname;
    // 设置勾选按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.width = 50;
    btn.height = 40;
    btn.x = SBHScreenW - btn.width;
    [btn setImage:[UIImage imageNamed:@"xzlxr_weixuanzeIcon"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"xzlxr_xuanzhongIcon"] forState:UIControlStateSelected];
    [cell addSubview:btn];
    [btn addTarget:self action:@selector(chooseBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.selected = pasModel.isChecked;
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.x = 10;
    lineLabel.y = 39;
    lineLabel.width = SBHScreenW - 20;
    lineLabel.height = 1;
    lineLabel.backgroundColor = SBHColor(240, 240, 240);
    [cell addSubview:lineLabel];
    
    return cell;
}

- (void)chooseBtn:(UIButton *)btn
{
    btn.selected = !btn.selected;
    UITableViewCell *cell = nil;
    if (iOS8) {  // ios8
        cell = (UITableViewCell *)[btn superview];
    } else { // ios7
        cell = (UITableViewCell *)[[btn superview] superview];
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    BeTrainPassengerModel *pasModel = [self.infoM.psglist objectAtIndex:indexPath.row];
    pasModel.isChecked = btn.selected;
    [self setupSubmitBtnStatus];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        SBHItemHeaderView *itemView = [[NSBundle mainBundle] loadNibNamed:@"SBHItemHeaderView" owner:nil options:nil].firstObject;
        itemView.itemName.text = @"选择改签乘机人";
        itemView.rightView.hidden = YES;
        itemView.backgroundColor = [UIColor whiteColor];
        return itemView;
    }
    
    UIView *itemHeader = [[UIView alloc] init];
    itemHeader.backgroundColor = SBHColor(250, 250, 250);
    return itemHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        BeTrainInfoModel *trainM = self.infoM.traininfolist.firstObject;
        BeTrainPassengerModel *pasM = self.infoM.psglist.firstObject;
         if (indexPath.row == 0) {
            CalendarHomeViewController *calendarVC = [[CalendarHomeViewController alloc] init];
            [calendarVC setCalendarType:DayTipsTypeAirStart andSelectDate:[NSDate date] andStartDate:[NSDate date]];
            calendarVC.calendarblock = ^(CalendarDayModel *model)
            {
                // 保存选择的时间
                trainM.departdate = [model toString];
                [BeTrainTicketInquireItem sharedInstance].fromTrainStation = trainM.boardpointname;
                [BeTrainTicketInquireItem sharedInstance].toTrainStation = trainM.offpointname;
                [BeTrainTicketInquireItem sharedInstance].startDateStr = [model toString];
                
                BeTrainTicketListViewController *tickerVc = [[BeTrainTicketListViewController alloc] init];
                tickerVc.sourceType = kTrainTicketListSourceAlte;
                tickerVc.trainTicketListModelBlock = ^(BeTrainTicketListModel *ticketModel){
                    // 保存选择的时间
                    trainM.departdate = [BeTrainTicketInquireItem sharedInstance].startDateStr;
                    trainM.departtime = ticketModel.StartTime;
                    pasM.trainno = ticketModel.TrainCode;
                    pasM.ticketclassname = ticketModel.displayModel.seatName;
                    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    self.isDidChooseFlight = YES;
                    [self setupSubmitBtnStatus];
                };
                [self.navigationController pushViewController:tickerVc animated:YES];
               
            };
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:calendarVC];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        } else if (indexPath.row == 1){
           [BeTrainTicketInquireItem sharedInstance].fromTrainStation = trainM.boardpointname;
           [BeTrainTicketInquireItem sharedInstance].toTrainStation = trainM.offpointname;
           [BeTrainTicketInquireItem sharedInstance].startDateStr = trainM.departdate; // trainM.departdate
            
            BeTrainTicketListViewController *tickerVc = [[BeTrainTicketListViewController alloc] init];
            tickerVc.sourceType = kTrainTicketListSourceAlte;
            tickerVc.trainTicketListModelBlock = ^(BeTrainTicketListModel *ticketModel){
                // 保存选择的时间
                trainM.departdate = [BeTrainTicketInquireItem sharedInstance].startDateStr;
                trainM.departtime = ticketModel.StartTime;
                pasM.trainno = ticketModel.TrainCode;
                pasM.ticketclassname = ticketModel.displayModel.seatName;
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                self.isDidChooseFlight = YES;
                [self setupSubmitBtnStatus];
            };
            [self.navigationController pushViewController:tickerVc animated:YES];
        }
        
    }
}

@end
