//
//  BeMeetingViewController.m
//  sbh
//
//  Created by RobinLiu on 16/6/16.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeMeetingViewController.h"
#import "BeChooseCityViewController.h"
#import "CalendarHomeViewController.h"

#import "BeMeetingDateTableViewCell.h"
#import "BeHotelOrderWriteCell.h"
#import "BeMeetingReasonView.h"
#import "UIAlertView+Block.h"

#import "BeMeetingModel.h"
#import "SBHHttp.h"
#import "BeRegularExpressionUtil.h"

@interface BeMeetingViewController ()
{
    BeMeetingModel *meetingModel;
    UIButton *bookButton;
}

@end

@implementation BeMeetingViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFeildValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会议";
    meetingModel = [[BeMeetingModel alloc]init];
    [self.dataArray addObjectsFromArray:@[@"城市",@"时间",@"预算",@"人数",@"会议需求",@"联系人",@"联系手机"]];
    [self tableViewFooterView];
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        BeHotelOrderWriteCell *cell = [BeHotelOrderWriteCell cellWithTableView:tableView];
        cell.contentTF.textAlignment = NSTextAlignmentLeft;
        cell.contentTF.enabled = NO;
        cell.contentTF.text = meetingModel.cityName;
        cell.nameLabel.text = [self.dataArray objectAtIndex:indexPath.row];
        return cell;
    }
    else if(indexPath.row == 1)
    {
        BeMeetingDateTableViewCell *cell = [BeMeetingDateTableViewCell cellWithTableView:tableView];
        cell.model = meetingModel;
        [cell addTarget:self WithStartAction:@selector(selectStartDate) andLeaveAction:@selector(selectLeaveDate)];
        return cell;
    }
    else if (indexPath.row == 2)
    {
        BeHotelOrderWriteCell *cell = [BeHotelOrderWriteCell cellWithTableView:tableView];
        cell.contentTF.enabled = NO;
        cell.contentTF.textAlignment = NSTextAlignmentLeft;
        cell.contentTF.text = meetingModel.budget;
        cell.contentTF.placeholder = @"选填";
        cell.contentTF.tag = indexPath.row;
        cell.nameLabel.text = [self.dataArray objectAtIndex:indexPath.row];
        return cell;
    }
    else if (indexPath.row == 3)
    {
        BeHotelOrderWriteCell *cell = [BeHotelOrderWriteCell cellWithTableView:tableView];
        cell.contentTF.enabled = NO;
        cell.contentTF.placeholder = @"选填";
        cell.contentTF.tag = indexPath.row;
        cell.contentTF.textAlignment = NSTextAlignmentLeft;
        cell.contentTF.text = meetingModel.number;
        cell.nameLabel.text = [self.dataArray objectAtIndex:indexPath.row];
        return cell;
    }
    else if (indexPath.row == 4)
    {
        BeHotelOrderWriteCell *cell = [BeHotelOrderWriteCell cellWithTableView:tableView];
        cell.contentTF.placeholder = @"请选择";
        cell.contentTF.textAlignment = NSTextAlignmentLeft;
        cell.contentTF.enabled = NO;
        cell.contentTF.text = meetingModel.demand;
        cell.nameLabel.text = [self.dataArray objectAtIndex:indexPath.row];
        return cell;
    }
    else if (indexPath.row == 5)
    {
        BeHotelOrderWriteCell *cell = [BeHotelOrderWriteCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.arrowImageView.hidden = YES;
        cell.contentTF.placeholder = @"请输入姓名";
        cell.contentTF.tag = indexPath.row;
        cell.contentTF.textAlignment = NSTextAlignmentLeft;
        cell.contentTF.text = meetingModel.contactPerson;
        cell.nameLabel.text = [self.dataArray objectAtIndex:indexPath.row];
        return cell;
    }
    else if (indexPath.row == 6)
    {
        BeHotelOrderWriteCell *cell = [BeHotelOrderWriteCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.arrowImageView.hidden = YES;
        cell.contentTF.placeholder = @"请输入手机号";
        cell.contentTF.tag = indexPath.row;
        cell.contentTF.textAlignment = NSTextAlignmentLeft;
        cell.contentTF.text = meetingModel.contactPhone;
        cell.nameLabel.text = [self.dataArray objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    switch (indexPath.row) {
        case 0:
        {
            BeChooseCityViewController *cityVC = [[BeChooseCityViewController alloc]init];
            cityVC.sourceType = kHotelStayType;
            cityVC.isSearchBarFixed = YES;
            cityVC.cityBlock = ^(CityData *city)
            {
                meetingModel.cityName = [city.iCityName mutableCopy];
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:cityVC animated:YES];
        }
            break;
        case 4:
        {
            [[BeMeetingReasonView sharedInstance]showViewWithData:@[@"开会",@"用餐",@"机票",@"用车",@"住宿",@"娱乐",@"布置/搭建",@"茶歇"] andSelectString:meetingModel.demand andIsSingle:NO andBlock:^(NSString *reason)
             {
                 meetingModel.demand = [reason mutableCopy];
                 [self.tableView reloadData];
             }];
        }
            break;
        case 2:
        {
            [[BeMeetingReasonView sharedInstance]showViewWithData:@[@"¥5000以下",@"¥6000-15000",@"¥6000-50000",@"¥16000-20000",@"¥21000-30000",@"¥30000-50000",@"¥50000-80000",@"¥100000以上"] andSelectString:meetingModel.budget andIsSingle:YES andBlock:^(NSString *reason)
             {
                 
                 meetingModel.budget = [reason mutableCopy];
                 [self.tableView reloadData];
             }];
        }
            break;
        case 3:
        {
            [[BeMeetingReasonView sharedInstance]showViewWithData:@[@"20人以下",@"21-50人",@"51-100人",@"101-200人",@"201-500人",@"500人以上"] andSelectString:meetingModel.number andIsSingle:YES andBlock:^(NSString *reason)
             {
                 meetingModel.number = [reason mutableCopy];
                 [self.tableView reloadData];
             }];
        }
            break;
        default:
            return;
            break;
    }
}
- (void)tableViewFooterView
{
    UIView *tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
    bookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bookButton setBackgroundColor:[ColorConfigure loginButtonColor]];
    bookButton.frame = CGRectMake(15, 30, SBHScreenW - 30, 40);
    bookButton.layer.cornerRadius = 4.0f;
    [bookButton addTarget:self action:@selector(bookButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bookButton setTitle:@"提交" forState:UIControlStateNormal];
    [tableFooterView addSubview:bookButton];
    self.tableView.tableFooterView = tableFooterView;
}

- (void)textFeildValueChanged:(NSNotification *)noti
{
    UITextField *tf = (UITextField *)[noti object];
    if (tf.tag == 5)
    {
        meetingModel.contactPerson = tf.text;
    }
    else if (tf.tag == 6)
    {
        meetingModel.contactPhone = tf.text;
    }
}
#pragma mark - 开始时间
- (void)selectStartDate
{
    [self.view endEditing:YES];
    CalendarHomeViewController *dateSelectVC = [[CalendarHomeViewController alloc]init];
    [dateSelectVC setCalendarType:DayTipsTypeMeetingStart andSelectDate:meetingModel.startDate andStartDate:[NSDate date]];
    dateSelectVC.calendarblock = ^(CalendarDayModel *model)
    {
        meetingModel.startDate = [model date];
        NSTimeInterval time=[meetingModel.leaveDate timeIntervalSinceDate:meetingModel.startDate];
        if(((int)time)/(3600*24)<1)
        {
            meetingModel.leaveDate = [meetingModel.startDate dateByAddingTimeInterval:3600*24];
        };
        [self.tableView reloadData];
    };
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:dateSelectVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
#pragma mark - 结束时间
- (void)selectLeaveDate
{
    [self.view endEditing:YES];
    CalendarHomeViewController *dateSelectVC = [[CalendarHomeViewController alloc]init];
    [dateSelectVC setCalendarType:DayTipsTypeMeetingLeave andSelectDate:meetingModel.leaveDate andStartDate:meetingModel.startDate];
    dateSelectVC.calendarblock = ^(CalendarDayModel *model){
        meetingModel.leaveDate = [model date];
        [self.tableView reloadData];
    };
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:dateSelectVC];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark - 预订
- (void)bookButtonAction
{
    [self.view endEditing:YES];
    if(!(meetingModel.contactPerson.length > 0))
    {
        [CommonMethod showMessage:@"请输入联系人姓名"];
        return;
    }
    if(!(meetingModel.contactPhone.length > 0))
    {
        [CommonMethod showMessage:@"请输入手机号码"];
        return;
    }
    if(![BeRegularExpressionUtil validateMobile:meetingModel.contactPhone])
    {
        [CommonMethod showMessage:@"请输入正确的手机号码"];
        return;
    }
    /*
     new SelectListItem { Value = "0", Text="请选择" },
     new SelectListItem { Value = "1", Text="20人以下" },
     new SelectListItem { Value = "2", Text="21-50人"},
     new SelectListItem { Value = "3", Text="51-100人" },
     new SelectListItem { Value = "4", Text="101-200人" },
     new SelectListItem { Value = "5", Text="201-500人" },
     new SelectListItem { Value = "6", Text="500人以上" }
     
     
     new SelectListItem { Value = "0", Text="请选择" },
     new SelectListItem { Value = "1", Text="¥5000以下" },
     new SelectListItem { Value = "2", Text="¥6000-15000"},
     new SelectListItem { Value = "3", Text="¥6000-50000" },
     new SelectListItem { Value = "4", Text="¥16000-20000" },
     new SelectListItem { Value = "5", Text="¥21000-30000" },
     new SelectListItem { Value = "6", Text="¥30000-50000" },
     new SelectListItem { Value = "7", Text="¥50000-80000" },
     new SelectListItem { Value = "8", Text="¥100000以上" }
     */
    NSString *number = @"0";
    if([meetingModel.number isEqualToString:@"20人以下"])
    {
        number = @"1";
    }
    else if([meetingModel.number isEqualToString:@"21-50人"])
    {
        number = @"2";
    }
    else if([meetingModel.number isEqualToString:@"51-100人"])
    {
        number = @"3";
    }
    else if([meetingModel.number isEqualToString:@"101-200人"])
    {
        number = @"4";
    }
    else if([meetingModel.number isEqualToString:@"201-500人"])
    {
        number = @"5";
    }
    else if([meetingModel.number isEqualToString:@"500人以上"])
    {
        number = @"6";
    }
    
    NSString *budget = @"0";
    if([meetingModel.budget isEqualToString:@"¥5000以下"])
    {
        budget = @"1";
    }
    else if([meetingModel.budget isEqualToString:@"¥6000-15000"])
    {
        budget = @"2";
    }
    else if([meetingModel.budget isEqualToString:@"¥6000-50000"])
    {
        budget = @"3";
    }
    else if([meetingModel.budget isEqualToString:@"¥16000-20000"])
    {
        budget = @"4";
    }
    else if([meetingModel.budget isEqualToString:@"¥21000-30000"])
    {
        budget = @"5";
    }
    else if([meetingModel.budget isEqualToString:@"¥30000-50000"])
    {
        budget = @"6";
    }
    else if([meetingModel.budget isEqualToString:@"¥50000-80000"])
    {
        budget = @"7";
    }
    else if([meetingModel.budget isEqualToString:@"¥100000以上"])
    {
        budget = @"8";
    }
    
    NSDictionary *dict = @{@"meeting_cityname":meetingModel.cityName,@"meeting_strdate":[CommonMethod stringFromDate:meetingModel.startDate WithParseStr:kFormatYYYYMMDD],@"meeting_enddate":[CommonMethod stringFromDate:meetingModel.leaveDate WithParseStr:kFormatYYYYMMDD],@"meeting_number":number,@"meeting_budget":budget,@"meeting_demand":meetingModel.demand,@"meeting_linkman":meetingModel.contactPerson,@"meeting_linktelephone":meetingModel.contactPhone,@"usertoken":[GlobalData getSharedInstance].token};

    [[SBHHttp sharedInstance]postPath:[NSString stringWithFormat:@"%@Meeting/MeetingSubmit",kServerHost] withParameters:dict showHud:YES success:^(id callback)
     {
         if([[callback objectForKey:@"code"] isEqualToString:@"20020"])
         {
             UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提交成功，稍后工作人员会与您联系" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
             [al showAlertViewWithCompleteBlock:^(NSInteger index)
              {
                  [self.navigationController popViewControllerAnimated:YES];
              }];
         }
         /*
          {"status":"true","code":"20020","meetingInfo":{"ErrorNo":1,"ErrorMsg":"","BackInfo":true}}
          下单成功
          */
     }failure:^(NSError *error)
     {
     }];
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
