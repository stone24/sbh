//
//  BeTicketPriceRuleViewController.m
//  sbh
//
//  Created by RobinLiu on 16/3/9.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeTicketPriceRuleViewController.h"
#import "BeFlightOrderWriteViewController.h"
#import "BeFlightTicketListViewController.h"
#import "BeTicketPriceRuleViewController.h"

#import "BeTicketDetailModel.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"

#import "BeTicketPriceRuleTipView.h"
#import "BeTicketPriceAirportCell.h"
#import "BeAirTicketMorePriceTableViewCell.h"
#import "BeTicketPriceCoverView.h"
#import "BeTicketRuleReasonView.h"

@interface BeTicketPriceRuleViewController ()

@end

@implementation BeTicketPriceRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"差旅政策";
    BeTicketPriceRuleTipView *tipView = [[BeTicketPriceRuleTipView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    [self.view addSubview:tipView];
    self.tableView.y = self.tableView.y + tipView.height;
    self.tableView.height = self.tableView.height - tipView.height;
    [self addFooterView];
}
- (void)addFooterView
{
    if(self.ruleModel.policyType == TravelPolicyTypeNoForce)
    {
        UIView *tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
        UIButton *inquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
        inquireButton.frame = CGRectMake(15, 30, SBHScreenW - 30, 40);
        inquireButton.layer.cornerRadius = 4.0f;
        [inquireButton addTarget:self action:@selector(generateAction) forControlEvents:UIControlEventTouchUpInside];
        [inquireButton setBackgroundColor:[ColorConfigure loginButtonColor]];
        [inquireButton setTitle:@"继续生成订单" forState:UIControlStateNormal];
        [tableFooterView addSubview:inquireButton];
        self.tableView.tableFooterView = tableFooterView;
    }
}
#pragma mark - 根据选中的模型下单
- (void)generateAction
{
    if([self.ruleModel.selectedReason length] < 1)
    {
        [CommonMethod showMessage:@"请选择超标原因"];
        return;
    }
    if([[GlobalData getSharedInstance].iSdancheng isEqualToString:@"RT"] &&[[GlobalData getSharedInstance].isfirst isEqualToString:@"notfirst"])
    {
        //往返的返
        [GlobalData getSharedInstance].backremark = [NSString stringWithFormat:@"%@|%@",self.ruleModel.selectedReason,self.ruleModel.recommendFlight.price];
    }
    else
    {
        //往
        [GlobalData getSharedInstance].goremark = [NSString stringWithFormat:@"%@|%@",self.ruleModel.selectedReason,self.ruleModel.recommendFlight.price];
    }
    [self recordDataWith:self.ruleModel.selectedFlight andAirport:self.ruleModel.selectedAirport];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.ruleModel.policyType == TravelPolicyTypeNoForce)
    {
        return 2;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 2;
    }
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return 10.0f;
    }
    return 0.001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            return kTicketPriceHeaderViewHeight;
        }
        else
        {
            return 59;
        }
    }
    else if (indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            return 25.0f;
        }
        else if (indexPath.row == 1)
        {
            return kTicketPriceHeaderViewHeight;
        }
        else if (indexPath.row == 2)
        {
            return 59;
        }
        else if (indexPath.row == 3)
        {
            return 40.0f;
        }
    }
    return 0.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        BeTicketPriceAirportCell *cell =
        [BeTicketPriceAirportCell cellWithTableView:tableView];
        cell.model = self.ruleModel.recommendAirport;
        return cell;
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        BeAirTicketMorePriceTableViewCell *cell = [BeAirTicketMorePriceTableViewCell cellWithTableView:tableView];
        [cell setCellWithModel:self.ruleModel.recommendFlight];
        [cell addTarget:self andBookAction:@selector(bookAction) andRefundAction:@selector(refundAction:) WithIndexPath:indexPath];
        return cell;
    }
    else if (indexPath.section == 1 && indexPath.row == 0)
    {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.text = @"如果您继续当前的价格预订，请选择原因：";
        cell.textLabel.textColor = [UIColor brownColor];
        cell.backgroundColor = [ColorUtility colorFromHex:0xffda93];
        cell.contentView.backgroundColor = [ColorUtility colorFromHex:0xffda93];

        return cell;
    }
    else if (indexPath.section == 1 && indexPath.row == 1)
    {
        BeTicketPriceAirportCell *cell =
        [BeTicketPriceAirportCell cellWithTableView:tableView];
        cell.model = self.ruleModel.selectedAirport;
        return cell;
    }
    else if (indexPath.section == 1 && indexPath.row == 2)
    {
        BeAirTicketMorePriceTableViewCell *cell = [BeAirTicketMorePriceTableViewCell cellWithTableView:tableView];
        [cell setCellWithModel:self.ruleModel.selectedFlight];
        [cell hideBookButton];
        return cell;
    }
    else if (indexPath.section == 1 && indexPath.row == 3)
    {
        //选择超标原因
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"选择超标原因：";
        cell.detailTextLabel.text = self.ruleModel.selectedReason;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 1 && indexPath.row == 3)
    {
        [[BeTicketRuleReasonView sharedInstance]showViewWith:self.ruleModel.reasonArray  andBlock:^(NSString *selectedString){
            self.ruleModel.selectedReason = [selectedString mutableCopy];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    if(indexPath.section == 0 && indexPath.row == 1)
    {
        [[BeTicketPriceCoverView sharedInstance]showViewWithDict:self.ruleModel.recommendFlight.infoDict andModel:self.ruleModel.recommendAirport andIsShowBookButton:YES andBlock:^{
            [self bookAction];
        }];
    }
    if(indexPath.section == 1 && indexPath.row == 2)
    {
        [[BeTicketPriceCoverView sharedInstance]showViewWithDict:self.ruleModel.selectedFlight.infoDict andModel:self.ruleModel.selectedAirport andIsShowBookButton:NO andBlock:^{
        }];
    }
}
#pragma mark - 根据推荐的模型下单
- (void)bookAction
{
    [self recordDataWith:self.ruleModel.recommendFlight andAirport:self.ruleModel.recommendAirport];
}
- (void)refundAction:(UIButton *)sender
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
