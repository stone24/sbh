

#import "BeOrderManagerViewController.h"
#import "BeFlightOrderListViewController.h"
#import "SBHAuditControllerViewController.h"
#import "BeHotelOrderController.h"
#import "BeWebViewController.h"
#import "BeTrainOrderListController.h"
#import "BeMeetingOrderListViewController.h"
#import "BeCarOrderListViewController.h"

#import "SBHMyCell.h"

#import "SBHUserModel.h"
#import "BeOrderMenu.h"
#import "CommonDefine.h"
#import "ColorConfigure.h"
#import "ServerFactory.h"
#import "SBHHttp.h"

#define kImageNameTicket @"orderlist_cell_ticket"
#define kImageNameApprove @"orderlist_cell_approve"
#define kImageNameCheckin @"orderlist_cell_checkin"
#define kImageNameHotel @"orderlist_cell_hotel"
#define kImageNameMeeting @"orderlist_cell_meeting"
@interface BeOrderManagerViewController ()

@property (nonatomic, strong) NSString *auditCount;
@end

@implementation BeOrderManagerViewController
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        UIImage *image = [[UIImage imageNamed:@"sy_tb_form"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selectedImage = [[UIImage imageNamed:@"sy_tb_form_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"订单" image:image selectedImage:selectedImage];
        [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ColorConfigure globalBgColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationCountEvent:) name:kNotificationLoginSuccess object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clearUI) name:kNotificationLogOffSuccess object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationCountEvent:) name:UIApplicationDidBecomeActiveNotification object:nil];
        
    };
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([GlobalData getSharedInstance].userModel.isLogin)
    {
        [self requestAuditCount];
    }
}

- (void)setData
{
    if([GlobalData getSharedInstance].userModel.isLogin == YES)
    {
        [self.dataArray removeAllObjects];
        // 是否用户有审批功能
        if([[GlobalData getSharedInstance].userModel.EntName isEqualToString:kAccountCondition])
        {
            BeOrderMenu *airFlight = [[BeOrderMenu alloc] init];
            airFlight.iconUrl = @"mine_jipiao_icon";
            airFlight.titleStr = @"机票订单";
            [self.dataArray addObject:airFlight];
        }
        else if([[GlobalData getSharedInstance].userModel.IsInternalAirTicket intValue]== 1)
        {
            BeOrderMenu *airFlight = [[BeOrderMenu alloc] init];
            airFlight.iconUrl = @"mine_jipiao_icon";
            airFlight.titleStr = @"机票订单";
            [self.dataArray addObject:airFlight];
        }
        //,"IsTrain":"1" 是否开通高铁 0未开通 1开通
        if(!([[GlobalData getSharedInstance].userModel.EntName isEqualToString:kAccountCondition]) &&[[GlobalData getSharedInstance].userModel.IsTrain intValue]== 1)
        {
            BeOrderMenu *invest = [[BeOrderMenu alloc] init];
            invest.iconUrl = @"trainOrder";
            invest.titleStr = @"火车票订单";
            [self.dataArray addObject:invest];
            [self requestAuditCount];
        }
        
        // 酒店订单
        if([GlobalData getSharedInstance].userModel.isEnterpriseUser&&[[GlobalData getSharedInstance].userModel.IsInternalHotel intValue]== 1)
        {
            BeOrderMenu *hotel = [[BeOrderMenu alloc] init];
            hotel.iconUrl = @"jiudian";
            hotel.titleStr = @"酒店订单";
            [self.dataArray addObject:hotel];
        }
        BeOrderMenu *meetingOrder = [[BeOrderMenu alloc]init];
        meetingOrder.iconUrl = kImageNameMeeting;
        meetingOrder.titleStr = @"会议订单";
        [self.dataArray addObject:meetingOrder];
        if(!([GlobalData getSharedInstance].userModel.isCar == NO ||([[GlobalData getSharedInstance].userModel.EntName isEqualToString:kAccountCondition])))
        {
            BeOrderMenu *carOrder = [[BeOrderMenu alloc] init];
            carOrder.iconUrl = @"order_spe";
            carOrder.titleStr = @"用车订单";
            [self.dataArray addObject:carOrder];
        }
    }
    [self.tableView reloadData];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)notificationCountEvent:(NSNotification *)notic
{
    [self setData];
    [self requestAuditCount];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    self.tableView.backgroundColor = SBHColor(240, 240, 240);
}

- (void)requestAuditCount
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,kAuditCountUrl];
    [[ServerFactory getServerInstance:@"SBHHttp"]postPath:urlStr withParameters:@{} showHud:NO success:^(NSDictionary *callback)
     {
         self.auditCount = [callback objectForKey:@"totalcount"];
         if ([self.auditCount isEqualToString:@"0"]) {
             self.tabBarItem.badgeValue = nil;
             [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
         } else {
             self.tabBarItem.badgeValue = self.auditCount;
             [UIApplication sharedApplication].applicationIconBadgeNumber = [self.auditCount intValue];
         }
         [self.tableView reloadData];
     }failure:^(NSError *error)
     {
         
     }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SBHMyCell *cell =  [SBHMyCell cellWithTableView:tableView];
    BeOrderMenu *menu = [self.dataArray objectAtIndex:indexPath.row];
    [cell.myIcon setImage:[UIImage imageNamed:menu.iconUrl] forState:UIControlStateNormal];
    cell.sepImageView.hidden = YES;
    if ([menu.titleStr isEqualToString:@"审批中心"]&&self.auditCount&&![self.auditCount isEqualToString:@"0"])
    {
        cell.numTagIcon.hidden = NO;
        [cell.numTagIcon setTitle:self.auditCount forState:UIControlStateNormal];
    }
    cell.myTitle.text = menu.titleStr;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BeOrderMenu *menu = [self.dataArray objectAtIndex:indexPath.row];
    if ([menu.titleStr isEqualToString:@"审批中心"]) {
        SBHAuditControllerViewController *auditVc = [[SBHAuditControllerViewController alloc] init];
        auditVc.title = @"审批管理";
        [self.navigationController pushViewController:auditVc animated:YES];
    } else if ([menu.titleStr isEqualToString:@"机票订单"]){
        BeFlightOrderListViewController *dingVc = [[BeFlightOrderListViewController alloc] init];
        dingVc.title = @"机票订单";
        [self.navigationController pushViewController:dingVc animated:YES];
    } else if ([menu.titleStr isEqualToString:@"酒店订单"]){
        BeHotelOrderController *hotVc = [[BeHotelOrderController alloc] init];
        [self.navigationController pushViewController:hotVc animated:YES];
    } else if ([menu.titleStr isEqualToString:@"代办登机牌订单"]){
        BeWebViewController *webVC = [[BeWebViewController alloc]init];
        webVC.webViewUrl = @"http://jcfw.shenbianhui.cn/OrderManagement/OrderList";
        [self.navigationController pushViewController:webVC animated:YES];
    } else if ([menu.titleStr isEqualToString:@"火车票订单"]){
        BeTrainOrderListController *orderVc = [[BeTrainOrderListController alloc] init];
        orderVc.title = menu.titleStr;
        [self.navigationController pushViewController:orderVc animated:YES];
        
    } else if ([menu.titleStr isEqualToString:@"会议订单"])
    {
        BeMeetingOrderListViewController *meetingOrderList = [[BeMeetingOrderListViewController alloc]init];
        [self.navigationController pushViewController:meetingOrderList animated:YES];
    } else if ([menu.titleStr isEqualToString:@"用车订单"])
    {
        BeCarOrderListViewController *carOrderList = [[BeCarOrderListViewController alloc]init];
        [self.navigationController pushViewController:carOrderList animated:YES];
    }
}

- (void)clearUI
{
    [self.tabBarItem setBadgeValue:nil];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
@end
