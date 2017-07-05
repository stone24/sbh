
#import "BeMorePriceViewController.h"
#import "BeFlightOrderWriteViewController.h"
#import "BeFlightTicketListViewController.h"
#import "BeTicketPriceRuleViewController.h"

#import "BeTicketDetailModel.h"
#import "ColorConfigure.h"
#import "UIAlertView+Block.h"
#import "BeMorePriceTool.h"
#import "ServerFactory.h"

#import "BeTicketPriceAirportCell.h"
#import "BeAirTicketMorePriceTableViewCell.h"
#import "BeTicketPriceCoverView.h"

@interface BeMorePriceViewController ()
{
    NSString *udid;
}
@property (nonatomic,strong)BeTicketPriceRuleModel *ruleModel;
@end

@implementation BeMorePriceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"top_right_index"] style:UIBarButtonItemStylePlain target:self action:@selector(backToRootViewController)];
    }
    return self;
}
- (id)init:(NSString *)str{
    self =  [super init];
    if (self) {
        _ruleModel = [[BeTicketPriceRuleModel alloc]init];
        udid = str;
        if ([[GlobalData getSharedInstance].isfirst isEqualToString:@"notfirst"]) {
            [GlobalData getSharedInstance].UDIDd = str;
        }
        else{
            [GlobalData getSharedInstance].UDID = str;
        }
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick event:@"J0001"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    if ([[GlobalData getSharedInstance].iSdancheng isEqualToString:@"RT"]) {
    }
    else{
        [GlobalData getSharedInstance].GOW = @"";
    }
    
    if ([[GlobalData getSharedInstance].isfirst isEqualToString:@"notfirst"]){
    }
    
    NSString *ititle = [NSString stringWithFormat:@"%@-%@",[GlobalData getSharedInstance].iTiketOrderInfo.iFromCityName,[GlobalData getSharedInstance].iTiketOrderInfo.iToCityName];
    if ([[GlobalData getSharedInstance].DANSHUAN isEqualToString:@"1"]) {
        self.title = ititle;
        [GlobalData getSharedInstance].overproreasons = @"";
        [GlobalData getSharedInstance].goremark = @"";
        [GlobalData getSharedInstance].backremark = @"";
    }
    else{
        if ([[GlobalData getSharedInstance].isfirst isEqualToString:@"notfirst"]) {
            NSString *string = [NSString stringWithFormat:@"%@(回程)",ititle];
            NSMutableDictionary *attStr = [NSMutableDictionary dictionary];
            attStr[NSFontAttributeName] = [UIFont systemFontOfSize:11];
            NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:string];
            [attrib addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, string.length)];
            [attrib addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, ititle.length)];
            [attrib addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(ititle.length, 4)];
            UILabel *label = [[UILabel alloc] init];
            label.height = 40;
            label.attributedText = attrib;
            self.navigationItem.titleView = label;
        } else {
            [GlobalData getSharedInstance].overproreasons = @"";
            NSString *string = [NSString stringWithFormat:@"%@(去程)",ititle];
            //        self.ititle.text =string;
            NSMutableDictionary *attStr = [NSMutableDictionary dictionary];
            attStr[NSFontAttributeName] = [UIFont systemFontOfSize:11];
            NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:string];
            [attrib addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, string.length)];
            [attrib addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, ititle.length)];
            [attrib addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(ititle.length, 4)];
            UILabel *label = [[UILabel alloc] init];
            label.height = 40;
            label.attributedText = attrib;
            self.navigationItem.titleView = label;
        }
    }    
    NSString *strin8 = [GlobalData getSharedInstance].DepartureDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [CommonMethod dateFromString:strin8 WithParseStr:@"yyyy-MM-dd"];
    NSString * weekDayStr = [NSString stringWithFormat:@"星期%@",
                             [CommonMethod getWeekDayFromDate:date]];
    NSString *backString = [NSString stringWithFormat:@"%@ %@", strin8, weekDayStr];
    // 保存去程回程的日期
    if ([[GlobalData getSharedInstance].isfirst isEqualToString:@"notfirst"]){
        [GlobalData getSharedInstance].huichengDate = backString;
    } else {
        [GlobalData getSharedInstance].quchengDate = backString;

    }
    [self getPriceList];
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
    }
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        return 59;
    }
    else if (indexPath.section == 0)
    {
        return kTicketPriceHeaderViewHeight;
    }
    return 59;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        BeTicketPriceAirportCell *cell =
        [BeTicketPriceAirportCell cellWithTableView:tableView];
        cell.model = self.airportModel;
        return cell;
    }
    else if (indexPath.section == 1)
    {
        BeAirTicketMorePriceTableViewCell *cell = [BeAirTicketMorePriceTableViewCell cellWithTableView:tableView];
        [cell setCellWithModel:[self.dataArray objectAtIndex:indexPath.row]];
        [cell addTarget:self andBookAction:@selector(bookAction:) andRefundAction:@selector(refundAction:) WithIndexPath:indexPath];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return;
    }
    BeTicketDetailModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [[BeTicketPriceCoverView sharedInstance]showViewWithDict:model.infoDict andModel:self.airportModel andIsShowBookButton:YES andBlock:^{
        [self bookAction:indexPath];
    }];
}
- (void)bookAction:(NSIndexPath *)indexPath
{
    [self orderTiket:(int)indexPath.row];
}
- (void)refundAction:(NSIndexPath *)indexPath
{
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}
/**
 * 点击预订按钮
 */
-(void)orderTiket:(int )tag
{
    if([GlobalData getSharedInstance].userModel.isLogin == NO)
    {
        [self.navigationController popViewControllerAnimated:NO];
        [BeLogUtility doLogOn];
        return;
    }
    [GlobalData getSharedInstance].isnewaudit = self.ruleModel.isnewaudit;
    BeTicketDetailModel *detailModel = [self.dataArray objectAtIndex:tag];
    if([GlobalData getSharedInstance].iTiketOrderInfo.travelReason == kTravelReasonTypePrivate ||[GlobalData getSharedInstance].userModel.accountType == AccountTypeIndependentIndividual)
    {
        [self recordDataWith:detailModel andAirport:self.airportModel];
        return;
    }
    else if(([detailModel.price intValue] == [self.ruleModel.recommendFlight.price intValue]) && ([detailModel.ForcedInsurance intValue] == [self.ruleModel.recommendFlight.ForcedInsurance intValue]))
    {
        //如果选中的价格跟最低价相等
        [self recordDataWith:detailModel andAirport:self.airportModel];
        return;
    }
    else if(self.ruleModel.isTPDisplay == YES)
    {
        //显示差旅政策
        BeTicketPriceRuleViewController *ruleVC = [[BeTicketPriceRuleViewController alloc]init];
        self.ruleModel.selectedFlight = detailModel;
        self.ruleModel.selectedAirport = self.airportModel;
        ruleVC.ruleModel = self.ruleModel;
        [self.navigationController pushViewController:ruleVC animated:YES];
        return;
    }
    else
    {
        [self recordDataWith:detailModel andAirport:self.airportModel];
        return;
    }
}

#pragma mark - 获取价格列表
- (void)getPriceList
{
    [[ServerFactory getServerInstance:@"BeMorePriceTool"]getMorePriceDataWith:self.airportModel.FlightNo and:udid bySuccess:^(NSDictionary *callback)
    {
        _ruleModel = [[BeTicketPriceRuleModel alloc]initWithDict:callback];
        NSArray *resArray = [callback objectForKey:@"item"];
        for (int i=0; i<[resArray count]; i++)
        {
            BeTicketDetailModel *model = [[BeTicketDetailModel alloc]initWithDict:[resArray objectAtIndex:i]];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
    }failure:^(NSString *failure)
    {
        [self handleResuetCode:failure];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
