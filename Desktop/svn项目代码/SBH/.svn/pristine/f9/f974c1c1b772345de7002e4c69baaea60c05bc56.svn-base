//
//  BeSpecialCarFlightViewController.m
//  sbh
//
//  Created by RobinLiu on 2016/12/15.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeSpecialCarFlightViewController.h"
#import "CalendarHomeViewController.h"

#import "SBHMyCell.h"

#import "BeSpeCarFlightModel.h"
#import "BeSpeCarAirportModel.h"
#import "BeSpeCarConfigure.h"
#import "NSDictionary+Additions.h"

@interface BeSpecialCarFlightViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UITableView *searchTableView;
@property (nonatomic,assign)int selectIndex;
@property (nonatomic,strong)NSDate *selectDate;
@end

@implementation BeSpecialCarFlightViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.sourceType == SpecialCarFlightVCTypeFlightNumber?@"航班":@"选择机场";
    self.selectDate = [NSDate date];
    [self addSubviews];
    if(self.sourceType == SpecialCarFlightVCTypeAirport)
    {
        [self getAirportList];
    }
    // Do any additional setup after loading the view.
}
- (void)addSubviews
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    footerButton.frame = CGRectMake(15, 60, kScreenWidth - 30, 44);
    footerButton.layer.cornerRadius = 4.0f;
    footerButton.backgroundColor = SBHYellowColor;
    [footerButton setTitle:@"确定" forState:UIControlStateNormal];
    [footerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:footerButton];
    self.tableView.tableFooterView = footView;
    
    self.searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 46, kScreenWidth, self.tableView.height - 46) style:UITableViewStylePlain];
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    self.searchTableView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.searchTableView];
    self.searchTableView.hidden = YES;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.sourceType == SpecialCarFlightVCTypeAirport && tableView == self.tableView)
    {
        return self.dataArray.count;
    }
    if(self.sourceType == SpecialCarFlightVCTypeFlightNumber && tableView == self.tableView)
    {
        return 2;
    }
    if(tableView == self.searchTableView)
    {
        return self.dataArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
     return tableView == self.tableView?6.0:0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableView && self.sourceType == SpecialCarFlightVCTypeFlightNumber && indexPath.row == 0)
    {
        SBHMyCell *cell = [SBHMyCell cellWithTableView:tableView];
        cell.rightArrow.hidden = cell.sepImageView.hidden = cell.myTitle.hidden = YES;
        [cell.myIcon setImage:[UIImage imageNamed:@"speCarFlight"] forState:UIControlStateNormal];
        UITextField *tf = [[UITextField alloc]initWithFrame:cell.myTitle.frame];
        tf.width = kScreenWidth - tf.x - 15;
        tf.delegate = self;
        tf.placeholder = @"输入航班号";
        tf.font = kSpeFont;
        tf.textColor = kSpeDarkColor;
        [cell addSubview:tf];
        return cell;
    }
    else if(tableView == self.tableView && self.sourceType == SpecialCarFlightVCTypeFlightNumber && indexPath.row == 1)
    {
        SBHMyCell *cell = [SBHMyCell cellWithTableView:tableView];
        cell.rightArrow.hidden = cell.sepImageView.hidden = YES;
        cell.myTitle.font = kSpeFont;
        cell.myTitle.textColor = kSpeDarkColor;
        [cell.myIcon setImage:[UIImage imageNamed:@"speCarDate"] forState:UIControlStateNormal];
        cell.myTitle.text = self.selectDate == nil?@"选择航班日期": [CommonMethod stringFromDate:self.selectDate WithParseStr:kFormatYYYYMMDD];
        return cell;
    }
    else if(tableView == self.tableView && self.sourceType == SpecialCarFlightVCTypeAirport)
    {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        for(UIImageView *subview in [cell subviews])
        {
            if([subview isKindOfClass:[UIImageView class]])
            {
                [subview removeFromSuperview];
            }
        }
        UIImageView *selectImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_single_selection"]];
        selectImageView.x = kScreenWidth - 20;
        selectImageView.centerY = 20;
        [cell addSubview:selectImageView];
        selectImageView.hidden = self.selectIndex == indexPath.row?NO:YES;
        BeSpeCarAirportModel *airportModel = self.dataArray[indexPath.row];
        cell.textLabel.text = airportModel.airportName;
        cell.textLabel.font = kSpeFont;
        cell.textLabel.textColor = kSpeDarkColor;
        return cell;
    }
    else if (tableView == self.searchTableView)
    {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = cell.contentView.backgroundColor = [ColorUtility colorWithRed:241 green:241 blue:241];
        BeSpeCarFlightModel *flightModel = self.dataArray[indexPath.row];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(38, 0, kScreenWidth  - 50, 21)];
        label.centerY = 20.0;
        label.font = kSpeFont;
        label.text = flightModel.flightName;
        label.textColor = kSpeDarkColor;
        [cell addSubview:label];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.sourceType == SpecialCarFlightVCTypeFlightNumber && tableView == self.tableView && indexPath.row == 1)
    {
        CalendarHomeViewController *calendarVC = [[CalendarHomeViewController alloc]init];
        [calendarVC setCalendarType:DayTipsTypeAirStart andSelectDate:self.selectDate andStartDate:[NSDate date]];
        calendarVC.calendarblock = ^(CalendarDayModel *selectModel)
        {
            self.selectDate = [selectModel date];
            [self.tableView reloadData];
        };
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:calendarVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        [self.view endEditing:YES];
    }
    if(self.sourceType == SpecialCarFlightVCTypeAirport && tableView == self.tableView)
    {
        self.selectIndex = (int)indexPath.row;
        [tableView reloadData];
    }
    if(tableView == self.searchTableView)
    {
        self.selectFlight = self.dataArray[indexPath.row];
        self.searchTableView.hidden = self.tableView.scrollEnabled =YES;
    }
}
- (void)sureAction
{
    if(self.block)
    {
        if(self.sourceType == SpecialCarFlightVCTypeFlightNumber)
        {
            if(self.selectFlight.flightName != nil && self.selectFlight.flightName.length > 0)
            {
                self.block(self.selectFlight);
            }
        }
        else
        {
            self.block(self.dataArray[self.selectIndex]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)textFieldValueChanged:(NSNotification *)noti
{
    UITextField *tf = [noti object];
    self.searchTableView.hidden = self.tableView.scrollEnabled = tf.text.length > 0?NO:YES;
    if(tf.text > 0)
    {
        [self searchFlightWith:tf.text];
    }
}
#pragma mark - 航班查询
- (void)searchFlightWith:(NSString *)text
{
    NSString *urlString = [NSString stringWithFormat:@"%@ShouQi",@"http://192.168.10.27:8999/"];
    NSString *valueStr = [NSString stringWithFormat:@"planeNumber=%@&date=%@&type=0&channel=emax&method=getFlightInfo",text,[CommonMethod stringFromDate:self.selectDate WithParseStr:kFormatYYYYMMDD]];
    [BeSpecialCarHttp postPath:urlString withParameters:valueStr success:^(id responseObj)
     {
         NSLog(@"航班查询 = %@",responseObj);
         if([[responseObj stringValueForKey:@"result"] intValue] != 0)
         {
             return ;
         }
         NSDictionary *data = [responseObj dictValueForKey:@"data"];
         if([[data allKeys] count] > 0)
         {
             BeSpeCarFlightModel *flightModel = [[BeSpeCarFlightModel alloc]initWithDict:data];
             flightModel.flightName = text;
             [self.dataArray addObject:flightModel];
         }
         [self.searchTableView reloadData];
     }failure:^(NSError *error)
     {
         
     }];
}
#pragma mark - 获取机场
- (void)getAirportList
{
    [self interceptionString];
    NSString *urlString = [NSString stringWithFormat:@"%@ShouQi",@"http://192.168.10.27:8999/"];
    NSString *valueStr = [NSString stringWithFormat:@"cityName=%@&channel=emax&method=getCityAirport",self.cityName];
    [BeSpecialCarHttp postPath:urlString withParameters:valueStr success:^(id responseObj)
     {
         if([[responseObj stringValueForKey:@"result"] intValue] != 0)
         {
             [MBProgressHUD showError:@"获取机场失败"];
             return ;
         }
         NSDictionary *data = [responseObj dictValueForKey:@"data"];
         NSArray *airports = [data arrayValueForKey:@"airports"];
         if([airports count] == 0)
         {
             [MBProgressHUD showError:@"获取机场失败"];
             return ;
         }
         for(NSDictionary *member in airports)
         {
             BeSpeCarAirportModel *airportModel = [[BeSpeCarAirportModel alloc]initWithDict:member];
             [self.dataArray addObject:airportModel];
         }
         [self.tableView reloadData];
         /*
          获取机场 = {
          result = 0,
          data = {
          cityId = 44,
          sort = 1,
          status = 1,
          centreLa = 39.91395,
          code = 010,
          airports = [
          {
          location = 116.614702,40.056231,
          airportCode = PEK,
          latitude = 40.056231,
          longitude = 116.614702,
          airportName = 首都国际机场T3航站楼 ,
          airportId = 84
          },
          {
          location = 116.593888,40.079598,
          airportCode = PEK,
          latitude = 40.079598,
          longitude = 116.593888,
          airportName = 首都国际机场T2航站楼 ,
          airportId = 85
          },
          {
          location = 116.587896,40.081216,
          airportCode = PEK,
          latitude = 40.081216,
          longitude = 116.587896,
          airportName = 首都国际机场T1航站楼 ,
          airportId = 86
          },
          {
          location = 116.3970889039,39.7912777934,
          airportCode = NAY,
          latitude = 39.7912777934,
          longitude = 116.3970889039,
          airportName = 南苑机场,
          airportId = 101
          },
          {
          location = 111.111,222.222,
          airportCode = QWERTY,
          latitude = 222.222,
          longitude = 111.111,
          airportName = 大机场,
          airportId = 122
          }
          ],
          citySpell = beijing,
          cityName = 北京,
          centreLo = 116.396027
          }
          }

          */
         NSLog(@"获取机场 = %@",responseObj);
     }failure:^(NSError *error){
         NSLog(@"失败 = %@",error);
     }];
}
- (void)interceptionString
{
    if([self.cityName rangeOfString:@"市"].location != NSNotFound)
    {
        //过滤掉市字
        self.cityName = [[self.cityName componentsSeparatedByString:@"市"] firstObject];
    }
    if ([self.cityName rangeOfString:@"地区"].location != NSNotFound)
    {
        //过滤掉地区字
        self.cityName = [[self.cityName componentsSeparatedByString:@"地区"] firstObject];
    }
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
