//
//  BeOrderWriteController.m
//  SideBenefit
//
//  Created by SBH on 15-3-12.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeOrderWriteController.h"

#import "selectContact.h"
#import "BePriceListModel.h"

#import "BeHotelOrderWriteCell.h"
#import "BeWritePersonCell.h"
#import "BeHotelOrderDescriptionView.h"
#import "BeHotelOrderHeaderView.h"
#import "BeHotelOrderFooterView.h"
#import "BeHotelOrderContactTableViewCell.h"
#import "dingdantianxieTableViewCell.h"
#import "BeHotelOrderWriteRoomCountView.h"
#import "BeHotelOrderWriteCheckInView.h"
#import "BeHotelOrderPriceListView.h"
#import "UIAlertView+Block.h"

#import "gongsilianxirenController.h"
#import "xuanzechengjirenViewController.h"
#import "BeHotelOrderRemarksViewController.h"
#import "BeHotelOrderPayViewController.h"
#import "BeHotelTravelPolicyViewController.h"
#import "BePassengerViewController.h"

#import "ColorUtility.h"
#import "BeRegularExpressionUtil.h"
#import "SBHHttp.h"
#import "ServerFactory.h"
#import "BeHotelServer.h"
#import "BeAirTicketOrderWriteTool.h"

#define kCheckInPersonTag   999
#define kCheckInPersonIdCardTag   1300
#define kContactNameTag     888
#define kContactPhoneTag    889
#define kExpenseCenterTag   700
#define kProjectNameTag     701
#define kProjectCodeTag     702
#define kBusinessReasonsTag 703

#define kFullHotelTip @"订单已生成，客服正在确认房间，并在1小时内回复您预订结果。感谢您的预订。"
@interface BeOrderWriteController ()
{
    BeHotelOrderFooterView *footerView;
    BeHotelOrderHeaderView *headerView;
}
@end

@implementation BeOrderWriteController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginEvent:@"H0003"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAddPerson:) name:kNotificationAddHotelPerson object:nil];
    if(![GlobalData getSharedInstance].userModel.isYPS)
    {
        if(self.writeModel.Persons.count != [self.writeModel.RoomCount intValue])
        {
            self.writeModel.RoomCount = [NSString stringWithFormat:@"%d",1];
            [self.writeModel.Persons removeAllObjects];
            selectPerson *personModel = [[selectPerson alloc]init];;
            [self.writeModel.Persons addObject:personModel];
        }
    }
    self.title = @"订单填写";
    [self addHeaderView];
    [self addFooterView];
    [self getPriceList];
}
- (void)addHeaderView
{
    headerView = [[BeHotelOrderHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kHotelOrderHeaderViewHeight)];
    headerView.writeModel = self.writeModel;
    self.tableView.tableHeaderView = headerView;
}
- (void)addFooterView
{
    BeHotelOrderDescriptionView *tableFooterView = [[BeHotelOrderDescriptionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kHotelOrderDescriptionHeight)];
    //显示取消规则
    if([self.writeModel.Rp_ChancelStatus intValue] == 2)
    {
        //"Rp_ChancelStatus": 1,//取消状态 0不可取消  1免费取消 2限时取消
        //显示规则：  限时取消(”checkinDate + 取消规则中的开始时间 “+ 之前取消 )
        //下一版改
        if([self.writeModel.PolicyRemark containsString:@" "])
        {
            NSString *tempString= [NSString stringWithFormat:@"限时取消（%@ %@之前取消）",self.writeModel.CheckInDate,[[[[self.writeModel.PolicyRemark componentsSeparatedByString:@" "] objectAtIndex:1] componentsSeparatedByString:@"-"] objectAtIndex:0]];
            tableFooterView.HotelDescriptionTV.text = [tempString mutableCopy];
        }else
        {
            NSString *tempString= [NSString stringWithFormat:@"限时取消（%@ %@之前取消）",self.writeModel.CheckInDate,[[[[self.writeModel.PolicyRemark componentsSeparatedByString:@"天"] objectAtIndex:1] componentsSeparatedByString:@"前"] objectAtIndex:0]];
            tableFooterView.HotelDescriptionTV.text = [tempString mutableCopy];
        }
    }
    else
    {
        tableFooterView.HotelDescriptionTV.text = self.writeModel.PolicyRemark;
    }
    tableFooterView.HotelDescriptionTV.userInteractionEnabled = NO;
    self.tableView.tableFooterView = tableFooterView;
    self.tableView.height = self.tableView.height - kHotelOrderFooterViewHeight;
    
    footerView = [[BeHotelOrderFooterView alloc]initWithFrame:CGRectMake(0, self.tableView.height, kScreenWidth, kHotelOrderFooterViewHeight)];
    footerView.detailButton.x = kScreenWidth - 150;
    footerView.detailButton.width = 74;
    if([self.writeModel.PayType isEqualToString:@"1"]||[self.writeModel.PayType isEqualToString:@"3"])
    {
        [footerView.payButton setTitle:@"预订" forState:UIControlStateNormal];
    }
    else
    {
        [footerView.payButton setTitle:@"生成订单" forState:UIControlStateNormal];
    }
    [footerView addTarget:self andPayAction:@selector(payAction) andDetailAction:@selector(lookUpDetailAction)];
    [self.view addSubview:footerView];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([self.writeModel.PayType intValue] == 2)
    {
        return 4;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        if([GlobalData getSharedInstance].userModel.isYPS)
        {
            return self.writeModel.roomSectionDisplayArray.count + self.writeModel.Persons.count;
        }
        else
        {
            return self.writeModel.roomSectionDisplayArray.count;
        }
    }
    if([self.writeModel.PayType intValue] == 2  && section == 3)
    {
        return self.writeModel.expenseDisplayArray.count;
    }
    if ([self.writeModel.PayType intValue] != 2  && section == 2)
    {
        return self.writeModel.expenseDisplayArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![GlobalData getSharedInstance].userModel.isYPS)
    {
        if(indexPath.section == 0 && indexPath.row == 1)
        {
            BOOL isShow = [GlobalData getSharedInstance].userModel.isYiyang;
            return [BeWritePersonCell cellHeightWithArray:self.writeModel.Persons andIsShowIdCard:isShow];
        }
    }
    if (indexPath.section == 1)
    {
        return [BeHotelOrderContactTableViewCell cellHeight];
    }
    return 40.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0?0.001:9.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if([GlobalData getSharedInstance].userModel.isYPS)
        {
            if(indexPath.row == 0)
            {
                //房间数
                BeHotelOrderWriteCell *cell = [BeHotelOrderWriteCell cellWithTableView:tableView];
                cell.contentTF.x = 90;
                cell.contentTF.width = kScreenWidth - 50 - 90;
                cell.arrowImageView.centerX = kScreenWidth - 20;
                cell.contentTF.enabled = NO;
                cell.nameLabel.text = kRoomCount;
                cell.contentTF.text = [NSString stringWithFormat:@"%@间",self.writeModel.RoomCount];
                cell.contentTF.textAlignment = NSTextAlignmentRight;
                return cell;
            }
            else if ([GlobalData getSharedInstance].userModel.isYPS && indexPath.row == 1)
            {
                //益普索 选人按钮
                BeHotelOrderWriteChooseCell *cell = [BeHotelOrderWriteChooseCell cellWithTableView:tableView];
                [cell addTarget:self andChooseAction:@selector(addPersonAction)];
                return cell;
            }
            else if(indexPath.row > 1 && indexPath.row < (self.writeModel.Persons.count+2 ))
            {
                //益普索 入住人
                dingdantianxieTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"dingdantianxieTableViewCell" owner:self options:nil] objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType  = UITableViewCellAccessoryNone;
                cell.sepImageView.hidden = YES;
                selectPerson *personModel = [self.writeModel.Persons objectAtIndex:indexPath.row - 2];
                cell.xingming.text = personModel.iName;
                [cell.rotDelBtn addTarget:self action:@selector(rotDelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.rotDelBtn.tag = 2000 + indexPath.row;
                [cell.delChengjrBtn addTarget:self action:@selector(delChengjrBtn:) forControlEvents:UIControlEventTouchUpInside];
                cell.delChengjrBtn.tag = 3000 + indexPath.row;
                return cell;
            }
            else if ([[self.writeModel.roomSectionDisplayArray objectAtIndex:2] isEqualToString:kCheckInTime] && (indexPath.row == self.writeModel.roomSectionDisplayArray.count + self.writeModel.Persons.count - 2))
            {
                // 入住时间
                BeHotelOrderWriteCell *cell = [BeHotelOrderWriteCell cellWithTableView:tableView];
                cell.contentTF.x = 90;
                cell.contentTF.width = kScreenWidth - 50 - 90;
                cell.arrowImageView.centerX = kScreenWidth - 20;
                cell.contentTF.enabled = NO;
                cell.nameLabel.text = kCheckInTime;
                cell.contentTF.text = self.writeModel.ReservedTime;
                cell.contentTF.textAlignment = NSTextAlignmentRight;
                return cell;
            }
            else if ([[self.writeModel.roomSectionDisplayArray lastObject]isEqualToString:kRemark] && (indexPath.row == self.writeModel.roomSectionDisplayArray.count + self.writeModel.Persons.count-1))
            {
                // 备注
                BeHotelOrderWriteCell *cell = [BeHotelOrderWriteCell cellWithTableView:tableView];
                cell.contentTF.x = 90;
                cell.contentTF.width = kScreenWidth - 50 - 90;
                cell.contentTF.enabled = NO;
                cell.nameLabel.text = kRemark;
                cell.contentTF.text = self.writeModel.OrderNote;
                cell.contentTF.placeholder = @"无";
                [cell addTarget:self andDeleteKeyword:@selector(deleteOrderNote)];
                cell.contentTF.textAlignment = NSTextAlignmentRight;
                if(self.writeModel.OrderNote.length > 0)
                {
                    cell.keywordDeleteButton.hidden = NO;
                    cell.arrowImageView.centerX = kScreenWidth - 40;
                }
                else
                {
                    cell.keywordDeleteButton.hidden = YES;
                    cell.arrowImageView.centerX = kScreenWidth - 20;
                }
                return cell;
            }
        }
        else
        {
            if(indexPath.row != 1)
            {
                BeHotelOrderWriteCell *cell = [BeHotelOrderWriteCell cellWithTableView:tableView];
                cell.contentTF.enabled = NO;
                cell.contentTF.textAlignment = NSTextAlignmentRight;
                cell.contentTF.x = 90;
                cell.contentTF.width = kScreenWidth - 50 - 90;
                cell.arrowImageView.centerX = kScreenWidth - 20;
                if([[self.writeModel.roomSectionDisplayArray objectAtIndex:indexPath.row] isEqualToString:kRoomCount])
                {
                    cell.nameLabel.text = kRoomCount;
                    cell.contentTF.text = [NSString stringWithFormat:@"%@间",self.writeModel.RoomCount];
                }
                else if ([[self.writeModel.roomSectionDisplayArray objectAtIndex:indexPath.row] isEqualToString:kCheckInTime])
                {
                    cell.nameLabel.text = kCheckInTime;
                    cell.contentTF.text = self.writeModel.ReservedTime;
                }
                else if ([[self.writeModel.roomSectionDisplayArray objectAtIndex:indexPath.row] isEqualToString:kRemark])
                {
                    cell.nameLabel.text = kRemark;
                    cell.contentTF.text = self.writeModel.OrderNote;
                    cell.contentTF.placeholder = @"无";
                    [cell addTarget:self andDeleteKeyword:@selector(deleteOrderNote)];
                    cell.contentTF.width = kScreenWidth - 50 - 90;
                    if(self.writeModel.OrderNote.length > 0)
                    {
                        cell.keywordDeleteButton.hidden = NO;
                        cell.arrowImageView.centerX = kScreenWidth - 40;
                    }else
                    {
                        cell.keywordDeleteButton.hidden = YES;
                        cell.arrowImageView.centerX = kScreenWidth - 20;
                    }
                }
                return cell;
            }
            else if(indexPath.row == 1)
            {
                BeWritePersonCell *cell = [BeWritePersonCell cellWithTableView:tableView];
                BOOL isShow = [GlobalData getSharedInstance].userModel.isYiyang;
                [cell setCellWithArray:self.writeModel.Persons andIsShowIdCard:isShow];
                cell.personNameTF1.tag = kCheckInPersonTag;
                cell.idCardTF1.tag = kCheckInPersonIdCardTag;

                cell.personNameTF2.tag = kCheckInPersonTag + 1;
                cell.idCardTF2.tag = kCheckInPersonIdCardTag + 1;

                cell.personNameTF3.tag = kCheckInPersonTag + 2;
                cell.idCardTF3.tag = kCheckInPersonIdCardTag + 2;

                cell.personNameTF4.tag = kCheckInPersonTag + 3;
                cell.idCardTF4.tag = kCheckInPersonIdCardTag + 3;

                cell.personNameTF5.tag = kCheckInPersonTag + 4;
                cell.idCardTF5.tag = kCheckInPersonIdCardTag + 4;

                cell.personNameTF6.tag = kCheckInPersonTag + 5;
                cell.idCardTF6.tag = kCheckInPersonIdCardTag + 5;

                cell.personNameTF7.tag = kCheckInPersonTag + 6;
                cell.idCardTF7.tag = kCheckInPersonIdCardTag + 6;

                cell.personNameTF8.tag = kCheckInPersonTag + 7;
                cell.idCardTF8.tag = kCheckInPersonIdCardTag + 7;

                cell.personNameTF9.tag = kCheckInPersonTag + 8;
                cell.idCardTF9.tag = kCheckInPersonIdCardTag + 8;

                if(self.writeModel.Persons.count > 0)
                {
                    selectPerson *personModel = [self.writeModel.Persons objectAtIndex:0];
                    cell.personNameTF1.text = personModel.iName;
                    cell.idCardTF1.text = personModel.iCredNumber;

                }
                if(self.writeModel.Persons.count > 1)
                {
                    selectPerson *personModel = [self.writeModel.Persons objectAtIndex:1];
                    cell.personNameTF2.text = personModel.iName;
                    cell.idCardTF2.text = personModel.iCredNumber;

                }if(self.writeModel.Persons.count > 2)
                {
                    selectPerson *personModel = [self.writeModel.Persons objectAtIndex:2];
                    cell.personNameTF3.text = personModel.iName;
                    cell.idCardTF3.text = personModel.iCredNumber;

                }
                if(self.writeModel.Persons.count > 3)
                {
                    selectPerson *personModel = [self.writeModel.Persons objectAtIndex:3];
                    cell.personNameTF4.text = personModel.iName;
                    cell.idCardTF4.text = personModel.iCredNumber;

                }
                if(self.writeModel.Persons.count > 4)
                {
                    selectPerson *personModel = [self.writeModel.Persons objectAtIndex:4];
                    cell.personNameTF5.text = personModel.iName;
                    cell.idCardTF5.text = personModel.iCredNumber;

                }
                if(self.writeModel.Persons.count >5)
                {
                    selectPerson *personModel = [self.writeModel.Persons objectAtIndex:5];
                    cell.personNameTF6.text = personModel.iName;
                    cell.idCardTF6.text = personModel.iCredNumber;

                }
                if(self.writeModel.Persons.count >6)
                {
                    selectPerson *personModel = [self.writeModel.Persons objectAtIndex:6];
                    cell.personNameTF7.text = personModel.iName;
                    cell.idCardTF7.text = personModel.iCredNumber;

                }
                if(self.writeModel.Persons.count >7)
                {
                    selectPerson *personModel = [self.writeModel.Persons objectAtIndex:7];
                    cell.personNameTF8.text = personModel.iName;
                    cell.idCardTF8.text = personModel.iCredNumber;

                }
                if(self.writeModel.Persons.count > 8)
                {
                    selectPerson *personModel = [self.writeModel.Persons objectAtIndex:8];
                    cell.personNameTF9.text = personModel.iName;
                    cell.idCardTF9.text = personModel.iCredNumber;

                }
                [cell.selectButton addTarget:self action:@selector(addPersonAction) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
        }
    }
    else if (indexPath.section == 1)
    {
        BeHotelOrderContactTableViewCell *cell = [BeHotelOrderContactTableViewCell cellWithTableView:tableView];
        cell.contactNameTF.textAlignment = NSTextAlignmentRight;
        cell.contactTelephoneTF.textAlignment = NSTextAlignmentRight;
        [cell.selectButton addTarget:self action:@selector(addLinkmanAction) forControlEvents:UIControlEventTouchUpInside];
        cell.contactTelephoneTF.x = 90;
        cell.contactTelephoneTF.width = kScreenWidth - 50 - 90;
        cell.contactNameTF.x = cell.contactTelephoneTF.x;
        cell.contactNameTF.width = cell.contactTelephoneTF.width;
        cell.selectButton.centerX = kScreenWidth - 20;
        
        selectContact *conModel = [self.writeModel.Contacts firstObject];
        if(conModel)
        {
            cell.contactNameTF.text = conModel.iName;
            cell.contactNameTF.placeholder = @"联系人姓名";
            cell.contactNameTF.tag = kContactNameTag;
            cell.contactTelephoneTF.text = conModel.iMobile;
            cell.contactTelephoneTF.tag = kContactPhoneTag;
            cell.contactTelephoneTF.placeholder = @"联系人手机号";
        }
        return cell;
    }
    else if([self.writeModel.PayType intValue] == 2 && indexPath.section == 2)
    {
        BeHotelOrderWriteCell *cell = [BeHotelOrderWriteCell cellWithTableView:tableView];
        cell.arrowImageView.hidden = YES;
        cell.contentTF.enabled = NO;
        //预付 保理支付
        cell.nameLabel.text = kPayTipString;
        cell.nameLabel.width = 250;
        return cell;
    }
    else if(([self.writeModel.PayType intValue] == 2  && indexPath.section == 3) ||([self.writeModel.PayType intValue] != 2  && indexPath.section == 2))
    {
        BeHotelOrderWriteCell *cell = [BeHotelOrderWriteCell cellWithTableView:tableView];
        cell.arrowImageView.hidden = YES;
        cell.contentTF.x = 90;
        cell.contentTF.width = kScreenWidth - 50 - 90;
        cell.contentTF.textAlignment = NSTextAlignmentRight;
        if([[self.writeModel.expenseDisplayArray objectAtIndex:indexPath.row] isEqualToString:kExpenseCenter])
        {
            cell.nameLabel.text = @"费用中心";
            cell.contentTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"(必填)" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
            cell.contentTF.text = self.writeModel.ExpenseCenter;
            cell.contentTF.tag = kExpenseCenterTag;
        }
        else if([[self.writeModel.expenseDisplayArray objectAtIndex:indexPath.row] isEqualToString:kBusinessReasons])
        {
            cell.nameLabel.text = @"出差原因";
            cell.contentTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"(必填)" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];

            cell.contentTF.text = self.writeModel.BusinessReasons;
            cell.contentTF.tag = kBusinessReasonsTag;
        }
        else if([[self.writeModel.expenseDisplayArray objectAtIndex:indexPath.row] isEqualToString:kProjectName])
        {
            cell.nameLabel.text = @"项目名称";
            cell.contentTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
            cell.contentTF.text = self.writeModel.ProjectName;
            cell.contentTF.tag = kProjectNameTag;
        }
        else if([[self.writeModel.expenseDisplayArray objectAtIndex:indexPath.row] isEqualToString:kProjectCode])
        {
            cell.nameLabel.text = @"项目编号";
            cell.contentTF.text = self.writeModel.ProjectCode;
            cell.contentTF.tag = kProjectCodeTag;
            if([GlobalData getSharedInstance].userModel.isTianzhi)
            {
                cell.contentTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"(必填)" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
            }
            else{
                cell.contentTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
            }
        }
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
    {
        if(([GlobalData getSharedInstance].userModel.isYPS && (indexPath.row == 0 || indexPath.row >= (self.writeModel.Persons.count+2 ))) ||((![GlobalData getSharedInstance].userModel.isYPS) && indexPath.row != 1))
        {
            BeHotelOrderWriteCell *cell = (BeHotelOrderWriteCell *)[tableView cellForRowAtIndexPath:indexPath];
            if([cell.nameLabel.text isEqualToString:kRoomCount])
            {
                [[BeHotelOrderWriteRoomCountView sharedInstance]showViewWithData:self.writeModel.RoomCount andBlock:^(NSString *selectString)
                 {
                     if([GlobalData getSharedInstance].userModel.isYPS)
                     {
                         self.writeModel.RoomCount = selectString;
                         if(self.writeModel.Persons.count > [self.writeModel.RoomCount intValue])
                         {
                             int startNum = [self.writeModel.RoomCount intValue];
                             int maxNum = (int)self.writeModel.Persons.count;
                             for(int i = startNum; i < maxNum;i++)
                             {
                                 [self.writeModel.Persons removeLastObject];
                             }
                         }
                         NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
                         [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                         [self updateFooterViewUI];
                     }
                     else
                     {
                         self.writeModel.RoomCount = selectString;
                         if(self.writeModel.Persons.count < [self.writeModel.RoomCount intValue])
                         {
                             int startNum = (int)self.writeModel.Persons.count;
                             for(int i = startNum; i < [self.writeModel.RoomCount intValue];i++)
                             {
                                 selectPerson *personModel = [[selectPerson alloc]init];
                                 [self.writeModel.Persons addObject:personModel];
                             }
                         }
                         else if(self.writeModel.Persons.count > [self.writeModel.RoomCount intValue])
                         {
                             int startNum = [self.writeModel.RoomCount intValue];
                             int maxNum = (int)self.writeModel.Persons.count;
                             for(int i = startNum; i < maxNum;i++)
                             {
                                 [self.writeModel.Persons removeLastObject];
                             }
                         }
                         NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
                         [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                         [self updateFooterViewUI];
                     }
                 }];
            }
            else if ([cell.nameLabel.text isEqualToString:kCheckInTime])
            {
                [[BeHotelOrderWriteCheckInView sharedInstance]showViewWithData:self.writeModel.ReservedTime andBlock:^(NSString *selectString)
                 {
                     self.writeModel.ReservedTime = selectString;
                     [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                 }];
            }
            else if ([cell.nameLabel.text isEqualToString:kRemark])
            {
                BeHotelOrderRemarksViewController *remarksVC = [[BeHotelOrderRemarksViewController alloc]init];
                remarksVC.block = ^(NSString *selectString )
                {
                    self.writeModel.OrderNote = selectString;
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                };
                [self.navigationController pushViewController:remarksVC animated:YES];
            }
        }
        else if(indexPath.row != 1 && [GlobalData getSharedInstance].userModel.isYPS)
        {
            selectPerson * selPeron = [self.writeModel.Persons objectAtIndex:indexPath.row - 2];
            BePassengerViewController *tian = [[BePassengerViewController alloc] init:selPeron];
            tian.sourceType = AddPassengerSourceTypeHotel;
            tian.title = @"";
            tian.canEdit = YES;
            tian.block = ^(selectPerson *callback)
            {
                [self.writeModel.Persons removeObjectAtIndex:indexPath.row - 2];
                [self.writeModel.Persons insertObject:callback atIndex:indexPath.row - 2];
                 NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:tian animated:YES];
        }
    }
}
#pragma mark - 删除入住人
- (void)rotDelBtnClick:(UIButton *)btn
{
    btn.layer.anchorPoint = CGPointMake(0.5, 0.5);
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        [UIView animateWithDuration:0.3 animations:^{
            btn.transform = CGAffineTransformRotate(btn.transform, M_PI_2);
        }];
        NSIndexPath *path = [NSIndexPath indexPathForRow:(btn.tag - 2000) inSection:0];
        dingdantianxieTableViewCell *cell = (dingdantianxieTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
        cell.delChengjrBtn.hidden = NO;
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            //            btn.transform = CGAffineTransformRotate(btn.transform, );
            btn.transform = CGAffineTransformIdentity;
        }];
        NSIndexPath *path = [NSIndexPath indexPathForRow:(btn.tag - 2000) inSection:0];
        dingdantianxieTableViewCell *cell = (dingdantianxieTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
        cell.delChengjrBtn.hidden = YES;
    }
}
- (void)delChengjrBtn:(UIButton *)btn
{
    [self.writeModel.Persons removeObjectAtIndex:(btn.tag - 3000 - 2)];
    [self updateFooterViewUI];
    [self.tableView reloadData];
}
#pragma mark - 酒店新增入住人
- (void)receiveAddPerson:(NSNotification *)noti
{
    selectPerson *personModel = [selectPerson mj_objectWithKeyValues:noti.userInfo];
    NSMutableArray *selectArray = [[NSMutableArray alloc]initWithObjects:personModel, nil];
    if(selectArray.count < 1)
    {
        return;
    }
    NSMutableIndexSet *indexSets = [[NSMutableIndexSet alloc] init];
    for (int i = 0; i<selectArray.count; i++)
    {
        NSUInteger index = 0;
        BOOL isSame = NO;
        selectPerson *selPerson = [selectArray objectAtIndex:i];
        for(selectPerson *member in self.writeModel.Persons)
        {
            if ([member.iName isEqualToString:selPerson.iName] && [member.iCredNumber isEqualToString:selPerson.iCredNumber]&& [member.iMobile isEqualToString:selPerson.iMobile])
            {
                isSame = YES;
                index = [self.writeModel.Persons indexOfObject:member];
                break;
            }
        }
        if(isSame)
        {
            [indexSets addIndex:i];
        }
    }
    if(indexSets.count > 0)
    {
        [selectArray removeObjectsAtIndexes:indexSets];
    }
    [indexSets removeAllIndexes];
    
    if(selectArray.count == [self.writeModel.RoomCount intValue])
    {
        [self.writeModel.Persons removeAllObjects];
        [self.writeModel.Persons addObjectsFromArray:selectArray];
    }
    else
    {
        NSMutableIndexSet *indexSets2 = [[NSMutableIndexSet alloc] init];
        
        int emptyCount = 0;
        for(selectPerson *member in self.writeModel.Persons)
        {
            emptyCount ++ ;
            if ([member.iName isEqualToString:@""] && [member.iCredNumber isEqualToString:@""]&& [member.iMobile isEqualToString:@""])
            {
                [indexSets2 addIndex:(emptyCount-1)];
            }
        }
        [self.writeModel.Persons removeObjectsAtIndexes:indexSets2];
        [self.writeModel.Persons addObjectsFromArray:selectArray];
        
        int max = (int)self.writeModel.Persons.count;
        if(max > [self.writeModel.RoomCount intValue])
        {
            NSMutableIndexSet *indexSets1 = [[NSMutableIndexSet alloc] init];
            for(int i = 0; i < max - ([self.writeModel.RoomCount intValue]) ;i++)
            {
                [indexSets1 addIndex:i];
            }
            [self.writeModel.Persons removeObjectsAtIndexes:indexSets1];
        }
        else if (max < [self.writeModel.RoomCount intValue])
        {
            if(![GlobalData getSharedInstance].userModel.isYPS)
            {
                int startNum = (int)self.writeModel.Persons.count;
                for(int i = startNum; i < [self.writeModel.RoomCount intValue];i++)
                {
                    selectPerson *personModel = [[selectPerson alloc]init];
                    [self.writeModel.Persons addObject:personModel];
                }
            }
        }
    }
    for(selectPerson * selPerson in self.writeModel.Persons)
    {
        if(selPerson.rolename.length !=0 && selPerson.rolename!=nil)
        {
            self.writeModel.ExpenseCenter = selPerson.rolename;
            break;
        }
    }
    [self updateFooterViewUI];
    [self.tableView reloadData];
}
#pragma mark - 删除备注
- (void)deleteOrderNote
{
    self.writeModel.OrderNote = @"";
    [self.tableView reloadData];
}
#pragma mark - 添加联系人
- (void)addLinkmanAction
{
    gongsilianxirenController *gongsi = [[gongsilianxirenController alloc]init];
    gongsi.sourceType = ContactSourceTypeEdit;
    if(self.writeModel.Contacts.count > 0)
    {
        gongsi.contactModel = [self.writeModel.Contacts firstObject];
    }  
    gongsi.block = ^(selectContact *contactModel)
    {
        [self.writeModel.Contacts removeAllObjects];
        [self.writeModel.Contacts addObject:contactModel];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:gongsi animated:YES];
}

#pragma mark - 添加入住人
- (void)addPersonAction
{
    xuanzechengjirenViewController *xuanze = [[xuanzechengjirenViewController alloc] init];
    xuanze.title = @"选择入住人";
    xuanze.maxCount = [self.writeModel.RoomCount intValue];
    xuanze.enType = BeChoosePersonTypeHotel;
    [xuanze.selectArray addObjectsFromArray:[self.writeModel.Persons mutableCopy]];
    xuanze.block = ^(NSMutableArray *selectArray)
    {
        if(selectArray.count < 1)
        {
            return;
        }
        NSMutableIndexSet *indexSets = [[NSMutableIndexSet alloc] init];
        for (int i = 0; i<selectArray.count; i++)
        {
            NSUInteger index = 0;
            BOOL isSame = NO;
            selectPerson *selPerson = [selectArray objectAtIndex:i];
            for(selectPerson *member in self.writeModel.Persons)
            {
                if ([member.iName isEqualToString:selPerson.iName] && [member.iCredNumber isEqualToString:selPerson.iCredNumber]&& [member.iMobile isEqualToString:selPerson.iMobile] && [member.rolename isEqualToString:selPerson.rolename])
                {
                    isSame = YES;
                    index = [self.writeModel.Persons indexOfObject:member];
                    break;
                }
            }
            if(isSame)
            {
                [indexSets addIndex:i];
            }
        }
        if(indexSets.count > 0)
        {
            [selectArray removeObjectsAtIndexes:indexSets];
        }
        [indexSets removeAllIndexes];
        
        if(selectArray.count == [self.writeModel.RoomCount intValue])
        {
            [self.writeModel.Persons removeAllObjects];
            [self.writeModel.Persons addObjectsFromArray:selectArray];
        }
        else
        {
            NSMutableIndexSet *indexSets2 = [[NSMutableIndexSet alloc] init];

            int emptyCount = 0;
            for(selectPerson *member in self.writeModel.Persons)
            {
                emptyCount ++ ;
                if ([member.iName isEqualToString:@""] && [member.iCredNumber isEqualToString:@""]&& [member.iMobile isEqualToString:@""])
                {
                    [indexSets2 addIndex:(emptyCount-1)];
                }
            }
            [self.writeModel.Persons removeObjectsAtIndexes:indexSets2];
            [self.writeModel.Persons addObjectsFromArray:selectArray];
            int max = (int)self.writeModel.Persons.count;
            if(max > [self.writeModel.RoomCount intValue])
            {
                NSMutableIndexSet *indexSets1 = [[NSMutableIndexSet alloc] init];
                for(int i = 0; i < max - ([self.writeModel.RoomCount intValue]) ;i++)
                {
                    [indexSets1 addIndex:i];
                }
                [self.writeModel.Persons removeObjectsAtIndexes:indexSets1];
            }
            else if (max < [self.writeModel.RoomCount intValue])
            {
                if(![GlobalData getSharedInstance].userModel.isYPS)
                {
                    int startNum = (int)self.writeModel.Persons.count;
                    for(int i = startNum; i < [self.writeModel.RoomCount intValue];i++)
                    {
                        selectPerson *personModel = [[selectPerson alloc]init];
                        [self.writeModel.Persons addObject:personModel];
                    }
                }
            }
        }
        for(selectPerson * selPerson in self.writeModel.Persons)
        {
            if(selPerson.rolename.length !=0 && selPerson.rolename!=nil)
            {
                self.writeModel.ExpenseCenter = selPerson.rolename;
                break;
            }
        }
        [self updateFooterViewUI];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:xuanze animated:YES];
}
#pragma mark - 合计
- (void)updateFooterViewUI
{
    headerView.writeModel = self.writeModel;
    [footerView updatePriceUIWith:self.writeModel];
}
- (void)textFieldValueChanged:(NSNotification *)noti
{
    UITextField *tf = (UITextField *)[noti object];
    if(tf.tag == kContactNameTag)
    {
        selectContact *contactModel = [self.writeModel.Contacts firstObject];
        contactModel.iName = tf.text;
    }
    else if (tf.tag == kContactPhoneTag)
    {
        selectContact *contactModel = [self.writeModel.Contacts firstObject];
        contactModel.iMobile = tf.text;
    }
    else if (tf.tag == kExpenseCenterTag)
    {
        self.writeModel.ExpenseCenter = tf.text;
    }
    else if (tf.tag == kProjectNameTag)
    {
        self.writeModel.ProjectName = tf.text;
    }
    else if (tf.tag == kProjectCodeTag)
    {
        self.writeModel.ProjectCode = tf.text;
    }
    else if (tf.tag == kBusinessReasonsTag)
    {
        self.writeModel.BusinessReasons = tf.text;
    }
    else if (tf.tag >= kCheckInPersonTag && tf.tag < kCheckInPersonTag + 9)
    {
        selectPerson *personModel = [self.writeModel.Persons objectAtIndex:tf.tag - kCheckInPersonTag];
        personModel.iName = tf.text;
    }
    else if (tf.tag >= kCheckInPersonIdCardTag && tf.tag < kCheckInPersonIdCardTag + 9)
    {
        selectPerson *personModel = [self.writeModel.Persons objectAtIndex:tf.tag - kCheckInPersonIdCardTag];
        personModel.iCredNumber = tf.text;
    }
}

- (void)payAction
{
    [self.writeModel checkInfoIsCorrectWithBlock:^(BOOL isCanBook,NSString *status)
     {
        if(!isCanBook)
        {
            [MBProgressHUD showError:status];
            return;
        }
        else
        {
            if([GlobalData getSharedInstance].userModel.isYiyang)
            {
                [self checkYiyangOrder];
            }
            else
            {
                [self submitOrder];
            }
        }
     }];
}
#pragma mark - 亿阳查费用中心
- (void)checkYiyangOrder
{
    [[ServerFactory getServerInstance:@"BeHotelServer"]checkYiyangOrderWith:self.writeModel byCallback:^(NSDictionary *responseData)
     {
         if([[responseData stringValueForKey:@"FYZX"] length] > 0)
         {
             self.writeModel.ExpenseCenter = [responseData stringValueForKey:@"FYZX"];
             [self submitOrder];
         }
         else
         {
             [CommonMethod showMessage:@"没有查询到差旅单号"];
         }
     }failureCallback:^(NSError *error)
     {
         [CommonMethod showMessage:@"没有查询到差旅单号"];
     }];
}
#pragma mark - 生成订单
- (void)submitOrder
{
    [[ServerFactory getServerInstance:@"BeHotelServer"]commitOrderWith:self.writeModel byCallback:^(NSDictionary *responseData)
     {
         self.writeModel.orderNo = [responseData objectForKey:@"orderNo"];
         [[ServerFactory getServerInstance:@"BeHotelServer"]getHotelAuditWith:self.writeModel byCallback:^(id callback)
          {
              NSLog(@"审批信息 = %@",callback);
              [self.writeModel getHotelAuditWith:callback];
              if([self.writeModel.PayType isEqualToString:@"1"]||[self.writeModel.PayType isEqualToString:@"3"])
              {
                  //到付
                  if(self.writeModel.auditType == HotelAuditTypeNone && [self.writeModel.errorNo intValue] == 2999)
                  {
                      //无审批
                      UIAlertView *alert=[[UIAlertView alloc]
                                          initWithTitle:@"温馨提示"
                                          message:kFullHotelTip
                                          delegate:self
                                          cancelButtonTitle:@"知道了"
                                          otherButtonTitles:nil];
                      [alert showAlertViewWithCompleteBlock:^(NSInteger index)
                       {
                           [self.navigationController popToRootViewControllerAnimated:YES];
                       }];
                  }
                  else if (self.writeModel.auditType == HotelAuditTypeNone && [self.writeModel.errorNo intValue] != 2999)
                  {
                      UIAlertView *alert=[[UIAlertView alloc]
                                          initWithTitle:@"温馨提示"
                                          message:@"预订成功，房费请于酒店前台支付"
                                          delegate:self
                                          cancelButtonTitle:@"知道了"
                                          otherButtonTitles:nil];
                      [alert showAlertViewWithCompleteBlock:^(NSInteger index)
                       {
                           [self.navigationController popToRootViewControllerAnimated:YES];
                       }];
                  }
                  else if (self.writeModel.auditType != HotelAuditTypeNone && [self.writeModel.errorNo intValue] == 2999)
                   {
                       //有审批
                       UIAlertView *alert=[[UIAlertView alloc]
                                           initWithTitle:@"温馨提示"
                                           message:kFullHotelTip
                                           delegate:self
                                           cancelButtonTitle:@"知道了"
                                           otherButtonTitles:nil];
                       [alert showAlertViewWithCompleteBlock:^(NSInteger index)
                        {
                            BeHotelOrderPayViewController *payVC = [[BeHotelOrderPayViewController alloc]init];
                            payVC.sourceType = HotelOrderPaySourceTypeWriteOrder;
                            payVC.writeModel = self.writeModel;
                            [self.navigationController pushViewController:payVC animated:YES];
                        }];
                   }
                   else if (self.writeModel.auditType != HotelAuditTypeNone && [self.writeModel.errorNo intValue] != 2999)
                   {
                       //有审批
                       BeHotelOrderPayViewController *payVC = [[BeHotelOrderPayViewController alloc]init];
                       payVC.sourceType = HotelOrderPaySourceTypeWriteOrder;
                       payVC.writeModel = self.writeModel;
                       [self.navigationController pushViewController:payVC animated:YES];
                   }
              }
              else
              {
                  //预付
                  [self.writeModel.priceArray removeAllObjects];
                  for (NSDictionary *member in [responseData objectForKey:@"pricesList"])
                  {
                      BePriceListModel *prModel = [BePriceListModel mj_objectWithKeyValues:member];
                      [self.writeModel.priceArray addObject:prModel];
                  }
                  NSString *str = [[NSString alloc]init];
                  if([self.writeModel.errorNo intValue] == 2999)
                  {
                      str = kFullHotelTip;
                  }
                  else
                  {
                       str = [NSString stringWithFormat:@"生成订单成功,订单号为:%@",self.writeModel.orderNo];
                  }
                  UIAlertView *alert=[[UIAlertView alloc]
                                      initWithTitle:@"温馨提示"
                                      message:str
                                      delegate:self
                                      cancelButtonTitle:@"知道了"
                                      otherButtonTitles:nil];
                  [alert showAlertViewWithCompleteBlock:^(NSInteger index)
                   {
                       BeHotelOrderPayViewController *payVC = [[BeHotelOrderPayViewController alloc]init];
                       payVC.sourceType = HotelOrderPaySourceTypeWriteOrder;
                       payVC.writeModel = self.writeModel;
                       [self.navigationController pushViewController:payVC animated:YES];
                   }];
              }
          }failureCallback:^(NSError *error)
          {
              NSLog(@"审批信息错误 = %@",error);
              [self requestFlase:error];
          }];
     }failureCallback:^(NSError *error)
    {
        NSLog(@"酒店下单错误 = %@",error);
         NSString *codeStr = [error.userInfo objectForKey:@"code"];
         if([codeStr isEqualToString:@"20028"])
         {
             BeHotelTravelPolicyViewController *ruleVC = [[BeHotelTravelPolicyViewController alloc]init];
             ruleVC.writeModel = self.writeModel;
             ruleVC.ruleDict = [error.userInfo objectForKey:@"cl"];
             [self.navigationController pushViewController:ruleVC animated:YES];
         }
         else if([codeStr isEqualToString:@"20035"])
         {
             UIAlertView *alert=[[UIAlertView alloc]
                                 initWithTitle:@"温馨提示"
                                 message:@"房间价格变动"
                                 delegate:self
                                 cancelButtonTitle:@"知道了"
                                 otherButtonTitles:nil];
             [alert showAlertViewWithCompleteBlock:^(NSInteger index)
              {
                  [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshHotelDetail" object:nil];
                  [self.navigationController popViewControllerAnimated:YES];
              }];
         }
         else if ([codeStr isEqualToString:@"10003"])
         {
             [self handleResuetCode:codeStr];
         }
         else if([codeStr isEqualToString:@"20031"])
         {
             [CommonMethod showMessage:@"企业额度不够,或是合同已到期，请验证后，再提交"];
         }
         else
         {
             [self handleResuetCode:codeStr];
         }
     }];
}
#pragma mark - 查看价格明细
- (void)lookUpDetailAction
{
    [[BeHotelOrderPriceListView sharedInstance]showViewWithData:self.writeModel andType:BeHotelOrderPriceListViewTypeWrite];
}
#pragma mark - 获取酒店价格列表数据
- (void)getPriceList
{
    [[ServerFactory getServerInstance:@"BeHotelServer"]getHotelOrderPriceListWith:self.writeModel byCallback:^(NSDictionary *dict)
     {
         NSLog(@"酒店价格返回 = %@",dict);
         BOOL isCanBook = [[dict objectForKey:@"isBook"] boolValue];
         BOOL Verifyprice = [[dict objectForKey:@"Verifyprice"] boolValue];
         self.writeModel.errorNo = [dict stringValueForKey:@"ErrorNo" defaultValue:@""];
         NSMutableArray *priceA = [NSMutableArray array];
         for (NSDictionary *member in [dict objectForKey:@"prices"])
         {
             BePriceListModel *prModel = [BePriceListModel mj_objectWithKeyValues:member];
             [priceA addObject:prModel];
         }
         if([self.writeModel.errorNo intValue] == 2999)
         {
             [self.writeModel updateExpenseDisplayWith:dict];
             self.writeModel.VerifypriceID = [dict objectForKey:@"VerifypriceID"];
             [self.writeModel.priceArray removeAllObjects];
             [self.writeModel.priceArray addObjectsFromArray:priceA];
             [self.tableView reloadData];
             [self updateFooterViewUI];
             [self requestContactList];
             return ;
         }
         else
         {
             if(isCanBook)
             {
                 if(Verifyprice)
                 {
                     [self.writeModel updateExpenseDisplayWith:dict];
                     self.writeModel.VerifypriceID = [dict objectForKey:@"VerifypriceID"];
                     [self.writeModel.priceArray removeAllObjects];
                     [self.writeModel.priceArray addObjectsFromArray:priceA];
                     [self.tableView reloadData];
                     [self updateFooterViewUI];
                     [self requestContactList];
                     return ;
                 }
                 else
                 {
                     UIAlertView *alert=[[UIAlertView alloc]
                                         initWithTitle:@"温馨提示"
                                         message:@"房间价格变动"
                                         delegate:self
                                         cancelButtonTitle:@"知道了"
                                         otherButtonTitles:nil];
                     [alert showAlertViewWithCompleteBlock:^(NSInteger index)
                      {
                          [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshHotelDetail" object:nil];
                          [self.navigationController popViewControllerAnimated:YES];
                      }];
                     return ;
                 }
             }
             else
             {
                 UIAlertView *alert=[[UIAlertView alloc]
                                     initWithTitle:@"温馨提示"
                                     message:@"该时间段房源紧张，暂不可预订"
                                     delegate:self
                                     cancelButtonTitle:@"知道了"
                                     otherButtonTitles:nil];
                 [alert showAlertViewWithCompleteBlock:^(NSInteger index)
                  {
                      [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshHotelDetail" object:nil];
                      [self.navigationController popViewControllerAnimated:YES];
                  }];
                 return ;
             }
         }
         
     }failureCallback:^(NSError *error){
         
     }];
}
#pragma mark - 获取公司联系人
- (void)requestContactList
{
    //只有益普索获取联系人
    [[ServerFactory getServerInstance:@"BeAirTicketOrderWriteTool"]getOrderWriteContactListBySuccess:^(NSArray *callback,NSString *belongfunction)
     {
         self.writeModel.belongfunction = [belongfunction mutableCopy];
         if(callback.count > 0 &&[GlobalData getSharedInstance].userModel.isYPS)
         {
             [self.writeModel.Contacts removeAllObjects];
             [self.writeModel.Contacts addObjectsFromArray:callback];
         }
         [self.tableView reloadData];
     }failure:^(NSString *failure)
     {
         [self handleResuetCode:failure];
     }];
}
- (void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,13,0,0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,13,0,0)];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,13,0,0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,13,0,0)];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
