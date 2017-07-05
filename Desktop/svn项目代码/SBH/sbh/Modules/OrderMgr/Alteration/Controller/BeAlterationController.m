//
//  BeAlterationController.m
//  sbh
//
//  Created by SBH on 15/4/14.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeAlterationController.h"
#import "CalendarHomeViewController.h"
#import "BeFlightTicketListViewController.h"

#import "BeAlterationFlightCell.h"
#import "SBHItemHeaderView.h"

#import "SBHHttp.h"

#import "BeTicketQueryResultModel.h"
#import "BeFlightModel.h"
#import "BePassengerModel.h"
#import "BeOrderInfoModel.h"

@interface BeAlterationController ()

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

@implementation BeAlterationController

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

- (void)setInfoM:(BeOrderInfoModel *)infoM
{
    _infoM = infoM;
//    NSArray *array = [[detailDict objectForKey:@"orderdetail"] objectForKey:@"airorderflights"];
    for (BeFlightModel *flightM in infoM.airorderflights) {
        [self.flightArray addObject:flightM];
    }
    
    NSArray *perArray = infoM.stgpassengers;
    self.tickekArray = [NSArray arrayWithArray:perArray];
    for (int i = 0; i < perArray.count; i++) {
        BePassengerModel *pasModel = [perArray objectAtIndex:i];
        if (self.flightArray.count > 1) {
            if (i%2 == 0) {
                [self.perArray addObject:pasModel];
            } else {
                [self.BackTickekArray addObject:pasModel];
            }
        } else {
            [self.perArray addObject:pasModel];
        }
    }
}

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
    [footerButton setTitle:@"提交改期" forState:UIControlStateNormal];
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

#pragma mark - 退票接口调用
- (void)queryRefund
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kServerHost,@"Order/RetreatOrder"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderno"] = self.infoM.orderno;
    params[@"type"] = @"GSQ";
    params[@"tickets"] = [self spellTicketInfo];
    params[@"changeremark"] = [self spellAltFlightInfo];
    params[@"usertoken"] = [GlobalData getSharedInstance].token;
    params[@"isaudit"] = self.infoM.auditType == AuditTypeNone?@"0":@"1";
    params[@"oldornew"] = self.infoM.auditType == AuditTypeOld?@"0":@"1";
    [[SBHHttp sharedInstance] postPath:urlStr withParameters:params showHud:YES success:^(id responseObj) {
           [MBProgressHUD showSuccess:@"申请成功！！！"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
    } failure:^(NSError *error) {
        if([[error.userInfo stringValueForKey:@"msg"] length] > 0)
        {
            [CommonMethod showMessage:[error.userInfo stringValueForKey:@"msg"defaultValue:@""]];
        }
        else
        {
            [self requestFlase:error];
        }
    }];
}

// 乘机人是否有被选中的
- (BOOL)setupCheckPassenger
{
    for (BePassengerModel *pasModel in self.perArray) {
            if(pasModel.isChecked) {
                return YES;
        }
    }
        return NO;
}

// 要改签航班信息
- (NSString *)spellAltFlightInfo
{
    // 改签的航班信息
    NSString *changeremarkStr = [NSString stringWithFormat:@""];
    if (self.isAltGo) {
        BeFlightModel *flModel = self.flightArray.firstObject;
        NSString *tempStr = [NSString stringWithFormat:@"去程改签日期:%@\n去程改签航班:%@ %@\n\n", flModel.fltdate, flModel.carriername, flModel.flightno];
         changeremarkStr = [changeremarkStr stringByAppendingString:tempStr];
    }
    if (self.isAltBack) {
        BeFlightModel *flModel = self.flightArray.lastObject;
        NSString *tempStr = [NSString stringWithFormat:@"返程改签日期:%@\n返程改签航班:%@ %@", flModel.fltdate, flModel.carriername, flModel.flightno];
       changeremarkStr = [changeremarkStr stringByAppendingString:tempStr];
    }
    
    return changeremarkStr;
}

// 要改签机票信息
- (NSMutableArray *)spellTicketInfo
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.perArray.count; i++) {
        BePassengerModel *pasModel = [self.perArray objectAtIndex:i];
        if(pasModel.isChecked) {
            if (self.isAltGo) {
                [self addTickekToArray:array withPasModel:pasModel];
            }
            if (self.isAltBack) {
                BePassengerModel *backPasModel = [self.BackTickekArray objectAtIndex:i];
                [self addTickekToArray:array withPasModel:backPasModel];
            }
            
        }
        
    }

    return array;
}

- (void)addTickekToArray:(NSMutableArray *)arrayM withPasModel:(BePassengerModel *)pasModel
{
    NSMutableDictionary *personDict = [NSMutableDictionary dictionary];
    personDict[@"boardpoint"] = pasModel.airline;
    personDict[@"passengersno"] = pasModel.passengersno;
    personDict[@"tid"] = pasModel.ID;
    personDict[@"billid"] = pasModel.billid;
    personDict[@"tickettagno"] = pasModel.tickettagno;
    personDict[@"tktno"] = pasModel.tktno;
    personDict[@"passengers"] = pasModel.psgname;
    [arrayM addObject:personDict];
}

// 乘机人
//- (NSString *)getSelectTiketString
//{
//    NSString * tiketsStr = nil;
//    for (BePassengerModel *pasModel in self.perArray) {
//        if(pasModel.isChecked) {
////            NSString *idno = [NSString stringWithFormat:@"%ld",(long)btn.tag];
//                    NSString *boardpoint   = pasModel.airline;
//                    NSString *passengersno = pasModel.passengersno;
//                    NSString *billid = pasModel.billid;
//                    NSString *tktno = pasModel.tickettagno;
//                    NSString *tid = pasModel.ID;
//                    if(tiketsStr == nil)
//                    {
//                        tiketsStr = [NSString stringWithFormat:@"{\"boardpoint\":\"%@\",\"passengersno\":\"%@\",\"tid\":\"%@\",\"billid\":\"%@\",\"tickettagno\":\"%@\"}",boardpoint,passengersno,tid,billid,tktno];
//                    }
//                    else
//                    {
//                        NSString * newtiket = [NSString stringWithFormat:@"{\"boardpoint\":\"%@\",\"passengersno\":\"%@\",\"tid\":\"%@\",\"billid\":\"%@\",\"tickettagno\":\"%@\"}",boardpoint,passengersno,tid,billid,tktno];
//                        tiketsStr = [NSString stringWithFormat:@"%@,%@",tiketsStr,newtiket];
//                    }
//                }
//        
//    }
//    return tiketsStr;
//}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1+self.flightArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.perArray.count;
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
    if(indexPath.section == 0)
    {
        static NSString *identifier = @"passengerCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType  = UITableViewCellAccessoryNone;
        }
        BePassengerModel *pasModel = [self.perArray objectAtIndex:indexPath.row];
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
   else {
        BeAlterationFlightCell *cell = [BeAlterationFlightCell cellWithTableView:tableView];
       cell.flightM  = nil;

       BeFlightModel *flightM = [[BeFlightModel alloc]init];
        NSString *tempStr = nil;
        if (indexPath.section == 1) {
            flightM = [self.flightArray firstObject];
            tempStr = @"选择去程";
        } else {
            flightM = [self.flightArray lastObject];
            tempStr = @"选择返程";
        }
        if (indexPath.row == 0) {
            flightM.flightTilteStr = [NSString stringWithFormat:@"%@日期", tempStr];
            flightM.flightValueStr = flightM.fltdate;
        } else {
            flightM.flightTilteStr = [NSString stringWithFormat:@"%@航班", tempStr];
            flightM.flightValueStr = [NSString stringWithFormat:@"%@ %@", flightM.carriername, flightM.flightno];
        }
        
        cell.flightM = flightM;
        return cell;
    }
    return nil;
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
    BePassengerModel *pasModel = [self.perArray objectAtIndex:indexPath.row];
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
    // 设置查询所需参数
    [GlobalData getSharedInstance].iTiketOrderInfo = [[TicketOrderInfo alloc] init];
    // 单程
    [GlobalData getSharedInstance].DANSHUAN = @"1";

    // 城市三字码
    BePassengerModel *pasModel = self.perArray.firstObject;
    NSArray *lineCode = [[pasModel airline] componentsSeparatedByString:@"-"];

    if (indexPath.section != 0) {
        // 提取航班组对应的模型
        BeFlightModel *flightModel = [self.flightArray objectAtIndex:(indexPath.section - 1)];
        if (indexPath.section == 1) {
            [GlobalData getSharedInstance].iTiketOrderInfo.iFromCityCode = lineCode.firstObject;
            [GlobalData getSharedInstance].iTiketOrderInfo.iToCityCode = lineCode.lastObject;
            [GlobalData getSharedInstance].iTiketOrderInfo.iFromCityName= flightModel.boardcityname;
            [GlobalData getSharedInstance].iTiketOrderInfo.iToCityName = flightModel.offcityname;
        } else {
            [GlobalData getSharedInstance].iTiketOrderInfo.iFromCityCode = lineCode.lastObject;
            [GlobalData getSharedInstance].iTiketOrderInfo.iToCityCode = lineCode.firstObject;
            [GlobalData getSharedInstance].iTiketOrderInfo.iFromCityName= flightModel.offcityname;
            [GlobalData getSharedInstance].iTiketOrderInfo.iToCityName = flightModel.boardcityname;
        }
        
        if (indexPath.row == 0) {
                CalendarHomeViewController *calendarVC = [[CalendarHomeViewController alloc] init];
                [calendarVC setCalendarType:DayTipsTypeAirStart andSelectDate:[NSDate date] andStartDate:[NSDate date]];
                calendarVC.calendarblock = ^(CalendarDayModel *model)
                {
                    // 保存选择的时间
                    flightModel.fltdate = [model toString];
                    BeFlightTicketListViewController *chaVc = [[BeFlightTicketListViewController alloc] init];
                    // 仓位为F,C情况下
                    if ([flightModel.classcode isEqualToString:@"F"] || [flightModel.classcode isEqualToString:@"C"]) {
                        chaVc.querySourceType = kQueryControllerSourceAlter;
                    } else {
                        chaVc.querySourceType = kQueryControllerSourceAlteSeveral;
                        chaVc.originalFlightNo = flightModel.flightno;
                    }
                    
                    chaVc.flightModelBlock = ^(BeTicketQueryResultModel *tickModel){
                        flightModel.fltdate = tickModel.DepartureDate;
                        flightModel.flightno = tickModel.FlightNo;
                        flightModel.carriername = tickModel.CarrierSName;
                        self.isDidChooseFlight = YES;
                        // 判断改的去程和返程
                        if (indexPath.section == 1) {
                            self.isAltGo = YES;
                        } else {
                            self.isAltBack = YES;
                        }
                        [GlobalData getSharedInstance].iTiketOrderInfo.iStartDate = [model date];
                        [self.tableView reloadData];
                        [self setupSubmitBtnStatus];
                    };
                    [GlobalData getSharedInstance].iTiketOrderInfo.iStartDate = [model date];
                    
                    [self.navigationController pushViewController:chaVc animated:YES];
                   // NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
                   // [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                };
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:calendarVC];
                [self.navigationController presentViewController:nav animated:YES completion:nil];
        } else if (indexPath.row == 1){
                [GlobalData getSharedInstance].iTiketOrderInfo.iStartDate =[CommonMethod dateFromString:flightModel.fltdate WithParseStr:@"yyyy-MM-dd"];
                BeFlightTicketListViewController *chaVc = [[BeFlightTicketListViewController alloc] init];
            
                if ([flightModel.classcode isEqualToString:@"F"] || [flightModel.classcode isEqualToString:@"C"]) {
                    chaVc.querySourceType = kQueryControllerSourceAlter;
                } else {
                    chaVc.querySourceType = kQueryControllerSourceAlteSeveral;
                    chaVc.originalFlightNo = flightModel.flightno;
                }
            
                chaVc.flightModelBlock = ^(BeTicketQueryResultModel *tickModel){
                    flightModel.fltdate = tickModel.DepartureDate;
                    flightModel.flightno = tickModel.FlightNo;
                    flightModel.carriername = tickModel.CarrierSName;
                    self.isDidChooseFlight = YES;
                    // 判断改的去程和返程
                    if (indexPath.section == 1) {
                        self.isAltGo = YES;
                    } else {
                        self.isAltBack = YES;
                    }
                    [self.tableView reloadData];
                    [self setupSubmitBtnStatus];
                };
                [self.navigationController pushViewController:chaVc animated:YES];
            
        }
        
    }
}

@end
