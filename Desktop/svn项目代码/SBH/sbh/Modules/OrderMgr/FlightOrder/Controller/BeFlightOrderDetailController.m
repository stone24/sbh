//
//  dingdanxinxiViewController.m
//  sbh
//
//  Created by musmile on 14-7-7.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "BeFlightOrderDetailController.h"
#import "ticketReserveViewController.h"
#import "BeAlterationController.h"
#import "BeFlightOrderPaymentController.h"
#import "BePriceListController.h"

#import "SBHDingxxHeaderCell.h"
#import "SBHDingxxFooterView.h"
#import "SBHAuditCoverView.h"
#import "gongsilianxirenCell.h"
#import "BeAlteRetView.h"
#import "BeAirTicketOrderInfoCell.h"
#import "BeAirOrderDetailFlightCell.h"
#import "BeAirOrderDetailPassengerCell.h"
#import "BeAirOrderDetailContactCell.h"

#import "SBHManageModel.h"
#import "SBHOrderModel.h"
#import "SBHLogModel.h"
#import "selectPerson.h"
#import "selectContact.h"
#import "SBHHttp.h"
#import "NSString+Extension.h"

@interface BeFlightOrderDetailController () <UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    int auditInt;
}

@property (nonatomic, strong) UIScrollView *coverScrollView;
@property (nonatomic, strong) UIView *covertgaiView;

@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) SBHOrderModel *orderModel;
@property (nonatomic, strong) UIButton *lastBtn;
@property (nonatomic, strong) UIButton *lastBtn00;
@property (nonatomic, strong) UILabel *commonline;
@property (nonatomic, strong) UIButton *doneFinishBtn;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *minuTime;
@property (nonatomic, strong) NSString *secondTime;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) NSString *creatTime;

@property (nonatomic, strong) NSMutableArray *chengjirBtns;
@property (nonatomic, strong) SBHAuditCoverView *auditView;
@property (nonatomic, strong) UIButton *auditCoverBtn;
@property (nonatomic, strong) UITextView *contentTextView;

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSString *dateStr;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, assign) BOOL isTimePicker;
@property (nonatomic, assign) BOOL isoperatOpen;

@property (nonatomic, strong) SBHLogModel *logModel;
// 订单详情所有数据模型
@property (nonatomic, strong) BeOrderInfoModel *orderInfoModel;
@property (nonatomic, strong) BeAirTicketDetailInfoFrame *infoFrame;
@end

@implementation BeFlightOrderDetailController

- (SBHLogModel *)logModel
{
    if (_logModel == nil) {
        _logModel = [[SBHLogModel alloc] init];
    }
    return _logModel;
}

- (NSMutableArray *)chengjirBtns
{
    if (_chengjirBtns == nil) {
        _chengjirBtns = [[NSMutableArray alloc] init];
    }
    return _chengjirBtns;
}

- (SBHOrderModel *)orderModel
{
    if (_orderModel == nil) {
        _orderModel = [[SBHOrderModel alloc] init];
    }
    return _orderModel;
}

- (void)setMangaeModel:(SBHManageModel *)mangaeModel
{
    _mangaeModel = mangaeModel;
    if ([self.mangaeModel.detailType isEqualToString:@"SBHAuditDetail"]) {
        auditInt = -1;
    } else {
        auditInt = 0;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"订单详情";
    self.tableView.hidden = YES;
    [self setupRequestOrder];
}

- (void)setupFooterView
{
    SBHDingxxFooterView *footerView = [[NSBundle mainBundle] loadNibNamed:@"SBHDingxxHeaderCell" owner:self options:nil].lastObject;
    for(UIView *subview in [footerView subviews])
    {
        if([subview isKindOfClass:[UIImageView class]])
        {
            subview.hidden = YES;
        }
    }
    footerView.payBtnClick.backgroundColor = [ColorConfigure loginButtonColor];
    footerView.payBtnClick.layer.cornerRadius = 4.0f;
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    self.tableView.sectionFooterHeight = 80;
    if (auditInt == -1) {  // 审批界面进订单详情
        if (![self.mangaeModel.orderst isEqualToString:@"审批浏览"]) {
            footerView.gaiqianBtn.hidden= NO;
            footerView.tuipiaoBtn.hidden = NO;
            [footerView.gaiqianBtn addTarget:self action:@selector(gaiqianBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [footerView.tuipiaoBtn addTarget:self action:@selector(gaiqianBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            footerView.gaiqianBtn.tag = 9001;
            footerView.tuipiaoBtn.tag = 9002;
            [footerView.gaiqianBtn setTitle:@"同意" forState:UIControlStateNormal];
            [footerView.tuipiaoBtn setTitle:@"拒绝" forState:UIControlStateNormal];
            [footerView.tuipiaoBtn setBackgroundImage:[UIImage imageNamed:@"xiaoxi_bot_icon"] forState:UIControlStateNormal];
            [footerView.tuipiaoBtn setTitleColor:SBHColor(215, 215, 215) forState:UIControlStateNormal];
        }
    } else {  // 除审批界面进入的其他几种情况
        if ([self.orderInfoModel.orderst isEqualToString:@"已订座"]) {
            if ([self.orderInfoModel.isAudit isEqualToString:@"1"] && [self.orderInfoModel.officialorprivate isEqualToString:@"因公"]){
                if ([self.mangaeModel.issend isEqualToString:@"1"]) {
                    
                } else {
                    [footerView.payBtnClick setTitle:@"去审批" forState:UIControlStateNormal];
                    footerView.payBtnClick.hidden = NO;
                    [footerView.payBtnClick addTarget:self action:@selector(goTopay) forControlEvents:UIControlEventTouchUpInside];
                }
            } else {
                footerView.payBtnClick.hidden = NO;
                [footerView.payBtnClick addTarget:self action:@selector(goTopay) forControlEvents:UIControlEventTouchUpInside];
            }
            
        } else if ([self.orderInfoModel.orderst isEqualToString:@"已出票"] || [self.orderInfoModel.orderst isEqualToString:@"已改签"]){
            footerView.gaiqianBtn.hidden= NO;
            footerView.tuipiaoBtn.hidden = NO;
            [footerView.gaiqianBtn addTarget:self action:@selector(gaiqianBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [footerView.tuipiaoBtn addTarget:self action:@selector(gaiqianBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            self.tableView.sectionFooterHeight = 0;
        }
    }
}

- (void)gaiqianBtnClick:(UIButton *)btn
{
    for (UIView *subView in self.covertgaiView.subviews) {
        if (!(subView.tag == 8)) {
             [subView removeFromSuperview];
        }
    }
    [self.chengjirBtns removeAllObjects];
    self.covertgaiView.height = self.coverScrollView.height;
    
    if ([btn.currentTitle isEqualToString:@"退票申请"]){
        self.covertgaiView.hidden = NO;
        self.coverScrollView.hidden = NO;
        [self setupCover:@"确认退票"];
        [self.doneFinishBtn setTitle:@"确认退票" forState:UIControlStateNormal];
    } else if ([btn.currentTitle isEqualToString:@"改期申请"]){
        BeAlterationController *altVc = [[BeAlterationController alloc] init];
        altVc.title = @"改期申请";
        altVc.infoM = self.orderInfoModel;
        [self.navigationController pushViewController:altVc animated:YES];
    }else if ([btn.currentTitle isEqualToString:@"同意"]){
        [self requestAudit:@"Y"];
    } else if([btn.currentTitle isEqualToString:@"拒绝"]){

        [self setupAuditCover];
    }
}

- (void)setupAuditCover
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = self.view.bounds;
    btn.backgroundColor = [UIColor blackColor];
    btn.alpha = 0.2;
    [btn addTarget:self action:@selector(auditCoverBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.auditCoverBtn = btn;
    
    SBHAuditCoverView *auditView = [[[NSBundle mainBundle] loadNibNamed:@"SBHAuditCoverView" owner:nil options:nil] firstObject];
    auditView.width = self.view.width - 20;
    auditView.height = 345;
    auditView.x = 10;
    auditView.y = (self.view.height - auditView.height) * 0.2;
    // 设置消息和确定按钮
    [auditView.closeCoverBtn addTarget:self action:@selector(auditCloseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [auditView.doneBtn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    auditView.contentTextView.delegate = self;
    [self.view addSubview:auditView];
    self.auditView = auditView;
}

- (void)auditCoverBtnClick:(UIButton *)btn
{
    btn.hidden = YES;
    self.auditView.hidden = YES;
}

- (void)auditCloseButtonClick:(UIButton *)btn
{
    self.auditView.hidden = YES;
    self.auditCoverBtn.hidden = YES;
}

- (void)doneBtnClick:(UIButton *)btn
{
    if (self.auditView.contentTextView.text.length == 0 || [self.auditView.contentTextView.text isEqualToString:@"拒绝原因"]) {
        [MBProgressHUD showError:@"请说明拒绝原因"];
    }
    else
    {
        [self requestAudit:@"N"];
    }
}

- (void)requestAudit:(NSString *)auditType
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"Audit/OrderAudit"];
    NSString *contentStr = [self.auditView.contentTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *params = @{@"orderno":self.mangaeModel.orderno,  @"isAudit": auditType,@"log":contentStr};
    [[SBHHttp sharedInstance]postPath:urlStr withParameters:params showHud:YES success:^(NSDictionary *dic){
        NSString *codeStr = [dic objectForKey:@"code"];
        if ([codeStr isEqualToString:@"20024"]) {
            [MBProgressHUD showSuccess:@"审批成功"];
        } else if([codeStr isEqualToString:@"20029"]){
            [MBProgressHUD showError:@"操作成功"];
        } else {
            [self handleResuetCode:[dic objectForKey:@"code"]];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }failure:^(NSError *error)
    {
        NSDictionary *dic = [error userInfo];
        NSString *codeStr = [dic stringValueForKey:@"code"];
        if ([codeStr isEqualToString:@"20024"]) {
            [MBProgressHUD showSuccess:@"审批成功"];
        } else if([codeStr isEqualToString:@"20029"]){
            [MBProgressHUD showError:@"操作成功"];
        } else {
            [self handleResuetCode:codeStr];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - 获取订单详情
- (void)setupRequestOrder
{
    self.tableView.hidden = YES;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"Order/OrderDetail"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderno"] = self.mangaeModel.orderno;
    params[@"usertoken"] = [GlobalData getSharedInstance].token;
    [[SBHHttp sharedInstance] postPath:urlStr withParameters:params showHud:YES success:^(id responseObj) {

        self.tableView.hidden = NO;
        NSLog(@"订单详情%@", responseObj);
        [BeAirticketModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *
         {
             return @{@"ID" : @"id"};
         }];
        [BePassengerModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID" : @"id"};
        }];
        [BePassengerModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"airtickets" : [BeAirticketModel class]};
        }];
        [BeOrderInfoModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"airorderflights" : [BeFlightModel class], @"passengers" : [BePassengerModel class], @"contact" : [BeOrderContactModel class], @"orderlog" : [SBHLogModel class], @"stgpassengers" : [BePassengerModel class]};
        }];
        BeOrderInfoModel *orderModel = [BeOrderInfoModel mj_objectWithKeyValues:[responseObj objectForKey:@"orderdetail"]];
        orderModel.creattime = [responseObj stringValueForKey:@"creattime"];
        orderModel.servicecharge = [responseObj stringValueForKey:@"servicecharge"];
        orderModel.isreasons = [responseObj stringValueForKey:@"isreasons"];
        orderModel.isAudit = [responseObj stringValueForKey:@"isaudit"];
        for(NSDictionary *listMember in [responseObj objectForKey:@"baoxianlist"])
        {
            BeOrderInsuranceType *type = [BeOrderInsuranceType mj_objectWithKeyValues:listMember];
            [orderModel.baoxianlist addObject:type];
        }
        BeAirTicketDetailInfoFrame *infoFrame = [[BeAirTicketDetailInfoFrame alloc] init];
        infoFrame.infoModel = orderModel;
        self.infoFrame = infoFrame;
        [orderModel getAuitDataWith:responseObj withSourceType:OrderFinishSourceTypeOrderDetail];
        self.orderInfoModel = orderModel;
        
        // 航班信息frame化
        for (BeFlightModel *flightM in orderModel.airorderflights) {
            BeAirTicketOrderFlightFrame *flightFrame = [[BeAirTicketOrderFlightFrame alloc] init];
            flightFrame.flightModel = flightM;
            [orderModel.flightFrameArray addObject:flightFrame];
        }
        
        // 乘机人frame化
        for (BePassengerModel *pasM in orderModel.passengers) {
            BeAirOrderDetailPassengerFrame *pasF = [[BeAirOrderDetailPassengerFrame alloc] init];
            pasF.pasM = pasM;
            [orderModel.pasFrameArray addObject:pasF];
        }
        
        // 联系人frame化
        for (BeOrderContactModel *conM in orderModel.contact) {
            BeAirOrderDetailContactFrame *conF = [[BeAirOrderDetailContactFrame alloc] init];
            conF.conM = conM;
            [orderModel.conFrameArray addObject:conF];
        }
        
        NSString *creatStr = orderModel.creattime;
        creatStr = [creatStr stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        NSString *chaSecond = [NSString intervalSinceNow:creatStr];
        int chaDouble = [chaSecond intValue];
        if (chaDouble < 13*60) {
            int int1 = (13*60-chaDouble) / 60;
            int int2 = (13*60-chaDouble) % 60;
            self.minuTime = [NSString stringWithFormat:@"%02d",int1];
            self.secondTime = [NSString stringWithFormat:@"%02d",int2];
        } else {
            self.minuTime = @"00";
            self.secondTime = @"00";
        }
         self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [self.tableView reloadData];
        [self setupFooterView];
    } failure:^(NSError *error) {
        [self requestFlase:error];
    }];
}

// 设置退改view
- (void)setupCover:(NSString *)str
{
    if(self.coverScrollView == nil)
    {
        self.coverScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, kScreenHeight - 64 - 20)];
        self.coverScrollView.delegate = self;
        self.coverScrollView.backgroundColor = [UIColor blackColor];
        self.coverScrollView.layer.cornerRadius = 4.0;
        [self.view addSubview:self.coverScrollView];
    }
    if(self.covertgaiView == nil)
    {
        self.covertgaiView = [[UIView alloc]initWithFrame:self.coverScrollView.bounds];
        self.covertgaiView.alpha = 0.9;
        self.covertgaiView.backgroundColor = [UIColor blackColor];
        [self.coverScrollView addSubview:self.covertgaiView];
    }
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.width = 41;
    closeBtn.height = 34;
    closeBtn.y = 10;
    closeBtn.x = self.covertgaiView.width - closeBtn.width - 8;
    [closeBtn setImage:[UIImage imageNamed:@"gdjg_tgq_guanbiIcon"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeCover) forControlEvents:UIControlEventTouchUpInside];
    [self.covertgaiView addSubview:closeBtn];
    
    UILabel *comeLabel = [[UILabel alloc] init];
    comeLabel.text = self.mangaeModel.comeCity;
    comeLabel.textColor = [UIColor whiteColor];
    comeLabel.font = [UIFont systemFontOfSize:14];
    CGSize comeSize = [comeLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil]];
    CGFloat comeX = 10;
    CGFloat comeY = 30;
    CGFloat comeW = comeSize.width;
    CGFloat comeH = 13;
    comeLabel.frame = CGRectMake(comeX, comeY, comeW, comeH);
    [self.covertgaiView addSubview:comeLabel];
    
    UIImageView *typeImage = [[UIImageView alloc] init];
    typeImage.x = CGRectGetMaxX(comeLabel.frame) + 2;
    typeImage.y = comeY + 3;
    typeImage.width = 20;
    typeImage.height = 8;
    typeImage.image = [UIImage imageNamed:@"ddxx_tg_jiantouIcon"];
    [self.covertgaiView addSubview:typeImage];
    
    UILabel *reachLabel = [[UILabel alloc] init];
    reachLabel.text = self.mangaeModel.reachCity;
    reachLabel.textColor = [UIColor whiteColor];
    CGSize reachSize = [reachLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil]];
    reachLabel.font = [UIFont systemFontOfSize:14];
    reachLabel.x = CGRectGetMaxX(typeImage.frame) + 2;
    reachLabel.y = comeY;
    reachLabel.width = reachSize.width;
    reachLabel.height = comeH;
    [self.covertgaiView addSubview:reachLabel];
    
    UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    typeBtn.x = CGRectGetMaxX(reachLabel.frame) + 2;
    typeBtn.y = comeY;
    typeBtn.width = 24;
    typeBtn.height = 13;
    [typeBtn setImage:[UIImage imageNamed:@"ddxx_quchengIcon"] forState:UIControlStateNormal];
    [self.covertgaiView addSubview:typeBtn];
    
    UILabel *luanmaLabel = [[UILabel alloc] init];
    luanmaLabel.textColor = [UIColor whiteColor];
    
    // 富文本机建燃油
    BePassengerModel *pasM = self.orderInfoModel.passengers.firstObject;
    BeAirticketModel *ticketM = pasM.airtickets.firstObject;
    NSString *str11 = ticketM.sellprice;
    NSString *str22 = ticketM.airporttax;
    NSString *str33 = ticketM.fueltex;
    NSString *jgStr = [NSString stringWithFormat:@"￥%@",str11];
    NSString *jjStr = [NSString stringWithFormat:@"￥%@",str22];
    NSString *ryStr = [NSString stringWithFormat:@"￥%@",str33];
    NSString *string = [NSString stringWithFormat:@"票价￥%@ / 机建￥%@ / 燃油￥%@",str11,str22,str33];
    NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:string];
    [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange(2, jgStr.length)];
    [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange(2+jgStr.length+5, jjStr.length)];
    [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange(2+jgStr.length+10+jjStr.length, ryStr.length)];
    //    [attrib addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(ititle.length, 4)];
    luanmaLabel.text = string;
    CGSize lmSize = [luanmaLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil]];
    luanmaLabel.font = [UIFont systemFontOfSize:13];
    luanmaLabel.x = comeX;
    luanmaLabel.y = CGRectGetMaxY(comeLabel.frame) + 5;
    luanmaLabel.width = lmSize.width;
    luanmaLabel.height = lmSize.height;
    luanmaLabel.attributedText = attrib;
    [self.covertgaiView addSubview:luanmaLabel];
    
    for (int i = 0; i < self.orderInfoModel.passengers.count; i++) {
        BePassengerModel *pasM = [self.orderInfoModel.passengers objectAtIndex:i];
        BeAirticketModel *ticketM = pasM.airtickets.firstObject;
        UIButton *lxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        lxBtn.selected = NO;
        CGFloat btnW = 65;
        CGFloat btnH = 19;
        CGFloat btnY = CGRectGetMaxY(luanmaLabel.frame) + 20;
//        lxBtn.backgroundColor = [UIColor redColor];

        lxBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -3);
        lxBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

        int colum = i%3;
        int row = i/3;
        lxBtn.x = 10 + 100*colum;
        lxBtn.y = btnY + 25 * row;
        lxBtn.width = btnW;
        lxBtn.height = btnH;
        lxBtn.tag = [ticketM.ID intValue];
        [lxBtn setTitle:pasM.psgname forState:UIControlStateNormal];
        [lxBtn setImage:[UIImage imageNamed:@"ddxx_tg_weixuanIcon" ] forState:UIControlStateNormal];
        [lxBtn setImage:[UIImage imageNamed:@"ddxx_tg_xuanzhongIcon" ] forState:UIControlStateSelected];
        lxBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        lxBtn.tag = 8000 + i;
        [lxBtn addTarget:self action:@selector(lxBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.covertgaiView addSubview:lxBtn];
        [self.chengjirBtns addObject:lxBtn];
        
        UILabel *statingLabel = [[UILabel alloc] init];
        statingLabel.backgroundColor = [UIColor whiteColor];
        statingLabel.x = CGRectGetMaxX(lxBtn.frame) + 1;
        statingLabel.y = lxBtn.y + 5;
        statingLabel.width = 45;
        statingLabel.height = 13;
        statingLabel.font = [UIFont systemFontOfSize:12];
        statingLabel.text = @"(改签中)";
        statingLabel.hidden = YES;
        [self.covertgaiView addSubview:statingLabel];
        
        if (i == (self.orderInfoModel.passengers.count - 1)) {
            self.lastBtn = lxBtn;
        }
    }
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.x = comeX;
    lineLabel.y = CGRectGetMaxY(self.lastBtn.frame) + 20;
    lineLabel.width = self.covertgaiView.width - 20;
    lineLabel.height = 1;
    lineLabel.backgroundColor = [UIColor whiteColor];
    [self.covertgaiView addSubview:lineLabel];
    self.commonline = lineLabel;
    
    if (self.orderInfoModel.airorderflights.count == 2) {
        UILabel *fcomeLabel = [[UILabel alloc] init];
        fcomeLabel.text = self.mangaeModel.reachCity;
        fcomeLabel.textColor = [UIColor whiteColor];
        fcomeLabel.font = [UIFont systemFontOfSize:14];
        fcomeLabel.x = comeX;
        fcomeLabel.y = CGRectGetMaxY(lineLabel.frame) + 20;
        fcomeLabel.width = reachLabel.width;
        fcomeLabel.height = comeH;
        [self.covertgaiView addSubview:fcomeLabel];
        
        UIImageView *ftypeImage = [[UIImageView alloc] init];
        ftypeImage.x = CGRectGetMaxX(fcomeLabel.frame) + 2;
        ftypeImage.y = fcomeLabel.y + 3;
        ftypeImage.width = 20;
        ftypeImage.height = 8;
        ftypeImage.image = [UIImage imageNamed:@"ddxx_tg_jiantouIcon"];
        [self.covertgaiView addSubview:ftypeImage];
        
        UILabel *freachLabel = [[UILabel alloc] init];
        freachLabel.text = self.mangaeModel.comeCity;
        freachLabel.textColor = [UIColor whiteColor];
        freachLabel.font = [UIFont systemFontOfSize:14];
        freachLabel.x = CGRectGetMaxX(ftypeImage.frame) + 2;
        freachLabel.y = fcomeLabel.y;
        freachLabel.width = comeSize.width;
        freachLabel.height = comeH;
        [self.covertgaiView addSubview:freachLabel];
        
        UIButton *ftypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        ftypeBtn.x = CGRectGetMaxX(freachLabel.frame) + 2;
        ftypeBtn.y = freachLabel.y;
        ftypeBtn.width = 24;
        ftypeBtn.height = 13;
        [ftypeBtn setImage:[UIImage imageNamed:@"ddxx_huichengIcon"] forState:UIControlStateNormal];
        [self.covertgaiView addSubview:ftypeBtn];
//
        UILabel *fluanmaLabel = [[UILabel alloc] init];
        fluanmaLabel.textColor = [UIColor whiteColor];

        // 富文本机建燃油
        BeAirticketModel *ticketM = pasM.airtickets.lastObject;
        NSString *str1 = ticketM.sellprice;
        NSString *str2 = ticketM.airporttax;
        NSString *str3 = ticketM.fueltex;
        NSString *jgStr00 = [NSString stringWithFormat:@"￥%@",str1];
        NSString *jjStr00 = [NSString stringWithFormat:@"￥%@",str2];
        NSString *ryStr00 = [NSString stringWithFormat:@"￥%@",str3];
        NSString *string00 = [NSString stringWithFormat:@"票价￥%@ / 机建￥%@ / 燃油￥%@",str1,str2,str3];
        NSMutableAttributedString *attrib00 = [[NSMutableAttributedString alloc] initWithString:string00];
        [attrib00 addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange(2, jgStr00.length)];
        [attrib00 addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange(2+jgStr00.length+5, jjStr00.length)];
        [attrib00 addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange(2+jgStr00.length+10+jjStr00.length, ryStr00.length)];
        fluanmaLabel.text = string00;
        CGSize lmSize00 = [fluanmaLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil]];

        fluanmaLabel.font = [UIFont systemFontOfSize:13];
        fluanmaLabel.x = comeX;
        fluanmaLabel.y = CGRectGetMaxY(fcomeLabel.frame) + 5;
        fluanmaLabel.width = lmSize00.width;
        fluanmaLabel.height = lmSize00.height;
        fluanmaLabel.attributedText = attrib00;
        [self.covertgaiView addSubview:fluanmaLabel];
        
        for (int i = 0; i < self.orderInfoModel.passengers.count; i++) {
            BePassengerModel *pasM = [self.orderInfoModel.passengers objectAtIndex:i];
            BeAirticketModel *ticketM = pasM.airtickets.lastObject;
            UIButton *lxBtn00 = [UIButton buttonWithType:UIButtonTypeCustom];
            lxBtn00.selected = NO;
            CGFloat btnW = 65;
            CGFloat btnH = 19;
            CGFloat btnY = CGRectGetMaxY(fluanmaLabel.frame) + 20;
            int colum = i%3;
            int row = i/3;
            lxBtn00.x = 10 + 100*colum;
            lxBtn00.y = btnY + 25 * row;
            lxBtn00.width = btnW;
            lxBtn00.height = btnH;
            lxBtn00.tag = [ticketM.ID intValue];
            [lxBtn00 setTitle:pasM.psgname forState:UIControlStateNormal];
            [lxBtn00 setImage:[UIImage imageNamed:@"ddxx_tg_weixuanIcon" ] forState:UIControlStateNormal];
            [lxBtn00 setImage:[UIImage imageNamed:@"ddxx_tg_xuanzhongIcon" ] forState:UIControlStateSelected];
            lxBtn00.titleLabel.font = [UIFont systemFontOfSize:14];
            [lxBtn00 addTarget:self action:@selector(lxBtn00Click:) forControlEvents:UIControlEventTouchUpInside];
            [self.covertgaiView addSubview:lxBtn00];
            [self.chengjirBtns addObject:lxBtn00];
            
            UILabel *statingLabel00 = [[UILabel alloc] init];
            statingLabel00.backgroundColor = [UIColor whiteColor];
            statingLabel00.x = CGRectGetMaxX(lxBtn00.frame) + 1;
            statingLabel00.y = lxBtn00.y + 5;
            statingLabel00.width = 45;
            statingLabel00.height = 13;
            statingLabel00.font = [UIFont systemFontOfSize:12];
//            statingLabel00.text = @"(改签中)";
            statingLabel00.hidden = YES;
            [self.covertgaiView addSubview:statingLabel00];
            
            if (i == (self.orderInfoModel.passengers.count - 1)) {
                self.lastBtn00 = lxBtn00;
            }
        }
        UILabel *lineLabel00 = [[UILabel alloc] init];
        lineLabel00.x = comeX;
        lineLabel00.y = CGRectGetMaxY(self.lastBtn00.frame) + 20;
        lineLabel00.width = self.covertgaiView.width - 20;
        lineLabel00.height = 1;
        lineLabel00.backgroundColor = [UIColor whiteColor];
        [self.covertgaiView addSubview:lineLabel00];
         self.commonline = lineLabel00;
    }

    UITextView *jijianTextView = [[UITextView alloc] init];
    jijianTextView.x = 10;
    jijianTextView.y = CGRectGetMaxY(self.commonline.frame) + 10;
    jijianTextView.width = self.covertgaiView.width - 20;
    jijianTextView.height = 58;
    jijianTextView.textColor = [UIColor lightGrayColor];
    jijianTextView.backgroundColor = SBHColor(225, 225, 225);
    jijianTextView.font = [UIFont systemFontOfSize:12];
    jijianTextView.text = @"说明原因";
    jijianTextView.delegate = self;
    jijianTextView.returnKeyType = UIReturnKeyDone;
    [self.covertgaiView addSubview:jijianTextView];
    self.textView = jijianTextView;
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.x = comeX;
    doneBtn.y = CGRectGetMaxY(self.textView.frame) + 20;
    doneBtn.width = self.textView.width;
    doneBtn.height = 40;
    doneBtn.backgroundColor = SBHYellowColor;
    doneBtn.titleLabel.textColor = [UIColor whiteColor];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [doneBtn addTarget:self action:@selector(doneFinishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.covertgaiView addSubview:doneBtn];
    self.doneFinishBtn = doneBtn;
    
    self.coverScrollView.contentSize = CGSizeMake(self.covertgaiView.width, CGRectGetMaxY(doneBtn.frame) + 10);
    self.covertgaiView.height = self.coverScrollView.contentSize.height;

}


- (void)lxBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
}

- (void)lxBtn00Click:(UIButton *)btn
{
    btn.selected = !btn.selected;
}

- (void)doneFinishBtnClick:(UIButton *)btn
{
    [self queryRefund:btn.currentTitle];
}
//tableview 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
            return 1;
    }
    else if (section == 1){
        return [self.orderInfoModel.flightFrameArray count];
    }
    else if (section == 2){
        return [self.orderInfoModel.pasFrameArray count];
    }else if (section == 3){
        return [self.orderInfoModel.conFrameArray count];;
    } else if (section == 4){
        if([[GlobalData getSharedInstance].userModel.EntName isEqualToString:kAccountCondition] )
        {
            return 0;
        }
        if (self.orderInfoModel.expensecenter.length != 0 && self.orderInfoModel.isreasons.length != 0) {
            return 2;
        } else if (self.orderInfoModel.expensecenter.length != 0 || self.orderInfoModel.isreasons.length != 0) {
            return 1;
        }
    }else if (section == 5){
        if (self.isoperatOpen) {

            return 1;
        } else {
            return 0;
        }
        
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.orderInfoModel.orderlog isKindOfClass:[NSArray class]]) {
        for (SBHLogModel *logM in self.orderInfoModel.orderlog) {
            if ([logM.operatman isEqualToString:@"客户审批"])
            {
                self.logModel = logM;
                return 6;
            }
        }
    }
    
        return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return self.infoFrame.height;
    }
    else if (indexPath.section == 1)
    {
        BeAirTicketOrderFlightFrame *flightFrame = [self.orderInfoModel.flightFrameArray objectAtIndex:indexPath.row];
        return flightFrame.height;
    }
    else if (indexPath.section == 2)
    {
        BeAirOrderDetailPassengerFrame *pasFrame = [self.orderInfoModel.pasFrameArray objectAtIndex:indexPath.row];
        return pasFrame.height;
    }
    else if (indexPath.section == 3)
    {
        BeAirOrderDetailContactFrame *conFrame = [self.orderInfoModel.conFrameArray objectAtIndex:indexPath.row];
        return conFrame.height;
    }
    else if (indexPath.section == 4)
    {
        if([[GlobalData getSharedInstance].userModel.EntName isEqualToString:kAccountCondition] )
        {
            return 0.0f;
        }
    }
    else if (indexPath.section == 5)
    {
        NSString *operatStr = self.logModel.operatcontent;
        CGSize contentSize = [operatStr boundingRectWithSize:CGSizeMake(self.view.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        return 10+contentSize.height;
    }
    return 35;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section == 2 || section == 3 || section == 4) {
        return 0.001;
    } else if (section == 0 ){
        
        if ([self.mangaeModel.orderst isEqualToString:@"已订座"] && [self.mangaeModel.isaudit isEqualToString:@"0"]) {
            return 70;
        }else {
            return 0.001;
        }
    } else if (section == 5){
        return 35;
    }
    return 45.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        BeAirTicketOrderInfoCell *cell = [BeAirTicketOrderInfoCell cellWithTableView:tableView];
        if (self.infoFrame != nil){
            for(UIView *subview in [cell subviews])
            {
                subview.userInteractionEnabled = YES;
            }
            cell.infoFrame = self.infoFrame;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(priceDetail)];
            [cell.detailBtn addGestureRecognizer:tap];
        }
        return cell;
        
    } else if  (indexPath.section == 1)
    {
        BeAirOrderDetailFlightCell *cell = [BeAirOrderDetailFlightCell cellWithTableView:tableView];
            if (indexPath.row == 0) {
                cell.titleStr = @"去程:";
            } else {
                cell.titleStr = @"返程:";
                [cell setSeparatorInset:UIEdgeInsetsMake(0, kScreenWidth, 0, 0)];
            }
            cell.flightFrame = [self.orderInfoModel.flightFrameArray objectAtIndex:indexPath.row];
         return cell;
        
    } else if  (indexPath.section == 2)
    {
        BeAirOrderDetailPassengerCell *cell = [BeAirOrderDetailPassengerCell cellWithTableView:tableView];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, kScreenWidth)];
        if (indexPath.row == 0)
        {
            cell.titleStr = @"乘机人:";
        } else
        {
            cell.titleStr = @"";
        }
        cell.pasF = [self.orderInfoModel.pasFrameArray objectAtIndex:indexPath.row];
        return cell;
        
    } else if  (indexPath.section == 3)
    {
        BeAirOrderDetailContactCell *cell = [BeAirOrderDetailContactCell cellWithTableView:tableView];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, kScreenWidth)];
        if (indexPath.row == 0) {
            cell.titleStr = @"联系人:";
        } else {
            cell.titleStr = @"";
        }
        cell.conF = [self.orderInfoModel.conFrameArray objectAtIndex:indexPath.row];
        return cell;
    }
    else if (indexPath.section == 4)
    {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, kScreenWidth)];
        if([[GlobalData getSharedInstance].userModel.EntName isEqualToString:kAccountCondition] )
        {
            return cell;
        }
        else
        {
            NSString *centerStr = @"";
            if (self.orderInfoModel.expensecenter.length != 0 && self.orderInfoModel.isreasons.length != 0) {
                if (indexPath.row == 0) {
                    centerStr = [NSString stringWithFormat:@"费用中心  %@", self.orderInfoModel.expensecenter];
                } else {
                    centerStr = [NSString stringWithFormat:@"出差原因  %@", self.orderInfoModel.isreasons];
                }
            } else {
                if (self.orderInfoModel.expensecenter.length != 0) {
                    centerStr = [NSString stringWithFormat:@"费用中心  %@", self.orderInfoModel.expensecenter];
                }
                if (self.orderInfoModel.isreasons.length != 0) {
                    centerStr = [NSString stringWithFormat:@"出差原因  %@", self.orderInfoModel.isreasons];
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType  = UITableViewCellAccessoryNone;
            cell.textLabel.textColor = kAirTicketDetailTitleColor;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.text = centerStr;
            return cell;
        }
    } else if (indexPath.section == 5) {
        UITableViewCell *operatCell = [[UITableViewCell alloc] init];
        operatCell.selectionStyle = UITableViewCellSelectionStyleNone;
        operatCell.accessoryType  = UITableViewCellAccessoryNone;
//        NSArray *array = [[mdic objectForKey:@"orderdetail"] objectForKey:@"orderlog"];
//        NSDictionary *dic = [array objectAtIndex:indexPath.row];
        NSString *operatStr = self.logModel.operatcontent;
        UILabel *operatStepLabel = [[UILabel alloc] init];
        operatStepLabel.text = operatStr;
        operatStepLabel.width = self.view.width - 20;
        operatStepLabel.numberOfLines = 0;
        
        CGSize contentSize = [operatStr boundingRectWithSize:CGSizeMake(operatStepLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        operatStepLabel.font = [UIFont systemFontOfSize:12];
        operatStepLabel.x = 10;
        operatStepLabel.y = 5;
        operatStepLabel.height = contentSize.height;
//        operatStepLabel.backgroundColor = [UIColor redColor];
        [operatCell addSubview:operatStepLabel];
        return operatCell;
    }

    return nil;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4 )
    {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, kScreenWidth)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, kScreenWidth)];
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        SBHDingxxHeaderCell *headerView = [[[NSBundle mainBundle] loadNibNamed:@"SBHDingxxHeaderCell" owner:self options:nil] objectAtIndex:0];
        BeFlightModel *flightM = self.orderInfoModel.airorderflights.firstObject;
        headerView.comeCity.text = flightM.boardcityname;
        headerView.reachCity.text = flightM.offcityname;
        if (self.orderInfoModel.airorderflights.count == 2) {
             headerView.typeImage.image = [UIImage imageNamed:@"ddlb_wangfanJiantouIcon"];
        } else {
             headerView.typeImage.image = [UIImage imageNamed:@"ddlb_jiantouIcon"];
        }
        return headerView;
    }
    else if (section == 0)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 70)];
        view.backgroundColor = SBHColor(240, 240, 240);
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.view.width - 20, 60)];
        timeLabel.numberOfLines = 3;
        timeLabel.font = [UIFont systemFontOfSize:14];
        timeLabel.textColor = SBHColor(153, 153, 153);
        NSString *string = [NSString stringWithFormat:@"为确保出票,请在%@:%@内完成支付,逾期将自动取消订单。以免机票售完或价格变化,给您的出行带来不便。", self.minuTime, self.secondTime];
        NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:string];
        [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange(8, 5)];
        [attrib addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:19] range:NSMakeRange(8, 5)];
        timeLabel.attributedText = attrib;
        self.timeLabel = timeLabel;
        [view addSubview:timeLabel];
        // 设置定时器
        if ([self.mangaeModel.orderst isEqualToString:@"已订座"] && [self.mangaeModel.isaudit isEqualToString:@"0"]) {
            return view;
        }
        return nil;
    }
    else if (section == 5)
    {
        UIView *view = [[UIView alloc] init];
        view.height = 35;
        view.width = self.view.width;
        view.x = 0;
        view.y = 0;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = view.bounds;
        [btn addTarget:self action:@selector(operatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UILabel *titlelebel = [[UILabel alloc] init];
        titlelebel.contentMode = UIViewContentModeTop;
        titlelebel.height = 15;
        titlelebel.x = 10;
        titlelebel.y = 8;
        titlelebel.width = 80;
        titlelebel.font = [UIFont systemFontOfSize:14];
        titlelebel.textColor = SBHColor(38, 38, 38);
        titlelebel.text = @"操作记录";
        [view addSubview:titlelebel];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhankai_jiantou_xia"]];
        imageView.x = self.view.width - 10 - imageView.width;
        [view addSubview:imageView];
        imageView.centerY = titlelebel.centerY;
        if (self.isoperatOpen) {
            imageView.image = [UIImage imageNamed:@"auditDetail_arrow_up"];
        } else {
            imageView.image = [UIImage imageNamed:@"zhankai_jiantou_xia"];
        }
        return view;
    }
    return nil;
}
#pragma mark - 查看价格明细
- (void)priceDetail
{
    NSMutableArray *arrayM = [NSMutableArray array];
    BePriceListModel *sellM = [[BePriceListModel alloc] init];
    sellM.RoomDate = @"票价";
    sellM.SalePrice = self.orderInfoModel.sellprice;
    [arrayM addObject:sellM];
    
    BePriceListModel *fueltexM = [[BePriceListModel alloc] init];
    fueltexM.RoomDate = @"机建";
    fueltexM.SalePrice = self.orderInfoModel.fueltex;
    [arrayM addObject:fueltexM];
    
    BePriceListModel *airporttaxM = [[BePriceListModel alloc] init];
    airporttaxM.RoomDate = @"燃油";
    airporttaxM.SalePrice = self.orderInfoModel.airporttax;
    [arrayM addObject:airporttaxM];
    
    BePriceListModel *serM = [[BePriceListModel alloc] init];
    serM.RoomDate = @"服务费";
    serM.SalePrice = self.orderInfoModel.servicecharge;
    [arrayM addObject:serM];
    
    /* BePriceListModel *insuM = [[BePriceListModel alloc] init];
     insuM.RoomDate = @"保险";
     insuM.SalePrice = self.orderInfoModel.insurancepricetotal;
     [arrayM addObject:insuM];
     */
    int typeA = 0;int priceA = 0;
    int typeB = 0;int priceB = 0;
    int typeC = 0;int priceC = 0;
    for(BeOrderInsuranceType *member in self.orderInfoModel.baoxianlist)
    {
        /*
         亚太航空意外险B款（单次航班）3
         平安航班延误险（单次航班）4
         综合交通意外险（10天）/原易购合众保险；1
         人保交通意外救援保险（7天） 5
         */
        if([member.businesstype intValue ] == 1)
        {
            typeA = typeA + [member.insuranceneedcount intValue];
            priceA = priceA + [member.paidmoney intValue];
        }
        else if([member.businesstype intValue ] == 3)
        {
            typeB = typeB + [member.insuranceneedcount intValue];
            priceB = priceB + [member.paidmoney intValue];
        }
        else if([member.businesstype intValue ] == 4)
        {
            typeC = typeC + [member.insuranceneedcount intValue];
            priceC = priceC + [member.paidmoney intValue];
        }
    }
    if(typeA > 0)
    {
        BePriceListModel *sellM = [[BePriceListModel alloc] init];
        sellM.RoomDate = [NSString stringWithFormat:@"航班意外险（A款） %d份",typeA];
        sellM.SalePrice = [NSString stringWithFormat:@"%.d",priceA];
        [arrayM addObject:sellM];
    }
    if(typeB > 0)
    {
        BePriceListModel *sellM = [[BePriceListModel alloc] init];
        sellM.RoomDate = [NSString stringWithFormat:@"航班意外险（B款） %d份",typeB];
        sellM.SalePrice = [NSString stringWithFormat:@"%.d",priceB];
        [arrayM addObject:sellM];
    }
    if(typeC > 0)
    {
        BePriceListModel *sellM = [[BePriceListModel alloc] init];
        sellM.RoomDate = [NSString stringWithFormat:@"延误取消险%d份",typeC];
        sellM.SalePrice = [NSString stringWithFormat:@"%.d",priceC];
        [arrayM addObject:sellM];
    }
    BePriceListController *prVc = [[BePriceListController alloc] init];
    prVc.tableView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    prVc.tableView.backgroundColor = [UIColor blackColor];
    prVc.tableView.alpha = 0.85;
   
    prVc.listArray = arrayM;
    prVc.roomNum = 1;
    prVc.totleMoneyStr = [NSString stringWithFormat:@"%d", [self.orderInfoModel.accountreceivable intValue] + [self.orderInfoModel.servicecharge intValue]];
    prVc.titleStr = @"机票费";
    [prVc.tableView reloadData];
    
    [[UIApplication sharedApplication].keyWindow addSubview:prVc.tableView];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesAction:)];
    [prVc.tableView addGestureRecognizer:tapGes];
}
- (void)tapGesAction:(UIGestureRecognizer *)gesture
{
    UITableView *table = (UITableView *)[gesture view];
    [table removeFromSuperview];
}
- (void)operatBtnClick:(UIButton *)btn
{
    self.isoperatOpen = !self.isoperatOpen;
    [self.tableView reloadData];
}
- (void)timerAction
{
    int secondInt = [self.secondTime intValue];
    int minuInt = [self.minuTime intValue];
    secondInt = secondInt - 1;
    if (secondInt < 0) {
        if (minuInt > 0){
            secondInt = 59;
            minuInt = minuInt - 1;
            self.secondTime = [NSString stringWithFormat:@"%02d",secondInt];
            self.minuTime = [NSString stringWithFormat:@"%02d",minuInt];
        } else {
          [self.timer invalidate];
            self.timer = nil;
        }
        
    } else {
    self.secondTime = [NSString stringWithFormat:@"%02d",secondInt];
    }
    NSString *string = [NSString stringWithFormat:@"为确保出票,请在%@:%@内完成支付,逾期将自动取消订单。以免机票售完或价格变化,给您的出行带来不便。", self.minuTime, self.secondTime];
     NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:string];
     [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange(8, 5)];
     [attrib addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:19] range:NSMakeRange(8, 5)];
     self.timeLabel.attributedText = attrib;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        BeFlightModel *flightM = [self.orderInfoModel.airorderflights objectAtIndex:indexPath.row];
        NSString *contentStr = [NSString stringWithFormat:@"退改签规则\n更改条件:\n\n%@\n\n退票条件:\n\n%@\n\n改签条件:\n\n%@\n\n舱位:\n\n%@", flightM.endorsement, flightM.refundmemo, flightM.ei, flightM.classcode];
        BeAlteRetView *altRetView = [[BeAlteRetView alloc] initWithTitle:contentStr];
        [altRetView show];
    }
}

//付款
- (void)goTopay {
    
    BeFlightOrderPaymentController *payVc = [[BeFlightOrderPaymentController alloc] initWith:self.mangaeModel.orderno];
    payVc.sourceType = OrderFinishSourceTypeOrderDetail;
    [self.navigationController pushViewController:payVc animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1314) {
    [self setupRequestOrder];
    }
    if(alertView.tag == 3)
    {
        if ([alertView.message isEqualToString:@"机票查询超时"]||[alertView.message isEqualToString:kNetworkAbnormal]){
            UIViewController * longinVC = [self getNavigationHistoryVC:                                                                                                                                                         [ticketReserveViewController class]];
            if(longinVC !=nil)
                [self.navigationController popToViewController:longinVC animated:YES];
        }
    }
    else
    {
        if (alertView.tag==3001) {
            [BeLogUtility doLogOn];
        }
    }
}

- (void)closeCover {
    self.covertgaiView.hidden = YES;
    self.coverScrollView.hidden = YES;
    [self.view endEditing:YES];
}

- (void)datePickerValueo00Change:(UIDatePicker *)datePicker
{
    if (self.isTimePicker) {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"]; // 这里是用小写的 h
        NSString *dateStr = [dateFormatter stringFromDate:datePicker.date];
        self.timeStr = dateStr;
 
    } else {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"]; // 这里是用小写的 h
        NSString *dateStr = [dateFormatter stringFromDate:datePicker.date];
        self.dateStr = dateStr;
    }
}

- (void)cancelBtnClick
{
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.view.transform = CGAffineTransformIdentity;
    self.coverScrollView.contentOffset = CGPointMake(0, 0);
    [self.view endEditing:YES];
}

#pragma mark _ UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1013) {
        self.coverScrollView.contentOffset = CGPointMake(0, 100);
        self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, -80);
    } else {
        [self.view endEditing:YES];
        if (textField.tag == 1011) {
            self.datePicker.datePickerMode = UIDatePickerModeDate;
            self.datePicker.minimumDate = [NSDate date];
             self.isTimePicker = NO;
        } else {
            self.datePicker.datePickerMode = UIDatePickerModeTime;
            self.isTimePicker = YES;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.view.transform = CGAffineTransformIdentity;
    self.coverScrollView.contentOffset = CGPointMake(0, 0);
    [self.view endEditing:YES];
    return YES;
}
#pragma mark _ UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.auditView.contentTextView.text = @"";
    textView.text = @"";
    self.view.transform = CGAffineTransformIdentity;
    if (textView.tag == 1001) {
        [UIView animateWithDuration:0.35 animations:^{
            self.coverScrollView.contentOffset = CGPointMake(0, 100);
            self.covertgaiView.transform = CGAffineTransformMakeTranslation( 0, -150);
        }];
    } else {
        textView.textColor = SBHColor(53, 53, 53);
        CGFloat aa = self.view.height - 84 - textView.y - 250 - textView.height;
        if (aa > 0) {
            aa = 0;
        }
        [UIView animateWithDuration:0.35 animations:^{
            self.covertgaiView.transform = CGAffineTransformTranslate(self.covertgaiView.transform, 0, aa);
        }];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.35 animations:^{
        self.coverScrollView.contentOffset = CGPointMake(0, 0);
        self.covertgaiView.transform = CGAffineTransformIdentity;
    }];
    
    if (self.auditView.contentTextView.text.length == 0) {
        self.auditView.contentTextView.text = @"拒绝原因";
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
     [self.view endEditing:YES];
}

#pragma mark - 退票接口调用
-(void)queryRefund:(NSString*)type
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"Order/RetreatOrder"];
    NSString * selectTiket = [self getSelectTiketString];
    if([selectTiket length] <= 0)
    {
        [CommonMethod showMessage:@"请选择机票！"];
        return;
    }
    NSString *changeremark= nil;
        type = @"TSQ";
        changeremark = self.textView.text;
    NSString *isaudit = self.orderInfoModel.auditType == AuditTypeNone?@"0":@"1";
    NSString *oldornew = self.orderInfoModel.auditType == AuditTypeOld?@"0":@"1";
    NSDictionary *params = @{@"orderno":self.mangaeModel.orderno,@"type":type,@"changeremark":changeremark,@"tickets":selectTiket,@"isaudit":isaudit,@"oldornew":oldornew};
    [[SBHHttp sharedInstance]postPath:urlStr withParameters:params showHud:YES success:^(NSDictionary *dic)
    {
        [MBProgressHUD showSuccess:@"申请成功！！！"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }failure:^(NSError *error)
     {
         NSDictionary *dic = [error userInfo];
         if([[dic stringValueForKey:@"msg" defaultValue:@""] length] > 0)
         {
             [CommonMethod showMessage:[dic objectForKey:@"msg"]];
         }
         else
         {
             NSString * code = [dic objectForKey:@"code"];
             [self handleResuetCode:code];
         }
     }];
}

//乘机人
- (NSString *)getSelectTiketString
{
    NSString * tiketsStr = nil;
    for (UIButton *btn in self.chengjirBtns) {
        if(btn.isSelected) {
            NSString *idno = [NSString stringWithFormat:@"%ld",(long)btn.tag];
            for (int i =0; i<self.orderInfoModel.stgpassengers.count; i++)
            {
                 BePassengerModel *pasM = [self.orderInfoModel.stgpassengers objectAtIndex:i];
                if ([idno isEqualToString:pasM.ID]) {
                    NSString * boardpoint   = pasM.airline;
                    NSString * passengersno = pasM.passengersno;
                    NSString * billid       = pasM.billid;
                    NSString * tktno        = pasM.tktno;
                    NSString * tid          = pasM.ID;
                    NSString * tickettagno  = pasM.tickettagno;
                    NSString * psgname      = pasM.psgname;
                    if(tiketsStr == nil)
                    {
                        tiketsStr = [NSString stringWithFormat:@"{\"boardpoint\":\"%@\",\"passengersno\":\"%@\",\"tid\":\"%@\",\"billid\":\"%@\",\"tickettagno\":\"%@\",\"tktno\":\"%@\",\"passengers\":\"%@\"}",boardpoint,passengersno,tid,billid,tickettagno,tktno,psgname];
                    }
                    else
                    {
                        NSString *newtiket = [NSString stringWithFormat:@"{\"boardpoint\":\"%@\",\"passengersno\":\"%@\",\"tid\":\"%@\",\"billid\":\"%@\",\"tickettagno\":\"%@\",\"tktno\":\"%@\",\"passengers\":\"%@\"}",boardpoint,passengersno,tid,billid,tickettagno,tktno,psgname];
                        tiketsStr = [NSString stringWithFormat:@"%@,%@",tiketsStr,newtiket];
                    }
                }
            }
        }
    }
    NSLog(@"tiketsStr=%@",tiketsStr);
    return tiketsStr;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
