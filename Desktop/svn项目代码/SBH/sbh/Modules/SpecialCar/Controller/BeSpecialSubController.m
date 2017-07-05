//
//  BeSpecialSubController.m
//  sbh
//
//  Created by SBH on 15/7/9.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeSpecialSubController.h"
#import "BeSpecialSubController+Addition.h"

@interface BeSpecialSubController ()<BeMapAddressProtocol, UITextFieldDelegate,QMSSearchDelegate,BeSpeHeaderViewDelegate>

@property (nonatomic, strong) QMSSearcher *mapSearcher;
@property (nonatomic, assign) BOOL reRequest;
@end

@implementation BeSpecialSubController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用车";
    [self initializationData];
    [self getCityList];
    [self setRightBarButtonItemWithTitle:@"北京"];
    self.mapSearcher = [[QMSSearcher alloc] initWithDelegate:self];
    [self getCurrentLocation];
    [self setSubviews];
}
- (void)setSubviews
{
    BeSpeHeaderView *headerView = [[BeSpeHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, BeSpeHeaderViewHeight)];
    headerView.delegate = self;
   // self.tableView.tableHeaderView = headerView;
    
    UIView *footView = [[UIView alloc] init];
    footView.height = 80;
    UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    footerButton.frame = CGRectMake(15, 20, SBHScreenW - 30, 44);
    footerButton.layer.cornerRadius = 4.0f;
    footerButton.backgroundColor = SBHYellowColor;
    [footerButton setTitle:@"叫车" forState:UIControlStateNormal];
    [footerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:footerButton];
    self.tableView.tableFooterView = footView;
}
#pragma mark - 选择接送机还是用车
- (void)speHeaderViewDidClickWith:(NSInteger)index
{
    self.sourceType = index;
    if(index == 0)
    {
        if(self.carLevArray.count == 0)
        {
            [self startSearchWith:CLLocationCoordinate2DMake([self.selectCityModel.cityLat floatValue], [self.selectCityModel.cityLng floatValue])];
        }
    }
    else if (index == 1)
    {
        if(self.selectCityModel.cityId == nil || [self.selectCityModel.cityId length] == 0 || self.pickupAirportModel == nil)
        {
            [self getCityIdWithSuccess:^(void)
             {
                 if(self.pickupCarLevArray.count == 0)
                 {
                     [self getAirportTransferCarList];
                 }
             }andFailure:^(void)
             {
                 
             }];
        }else
        {
            if(self.pickupCarLevArray.count == 0)
            {
                [self getAirportTransferCarList];
            }
        }
    }
    else if (index == 2)
    {
        if(self.selectCityModel.cityId == nil || [self.selectCityModel.cityId length] == 0|| self.seeOffAirportModel == nil)
        {
            [self getCityIdWithSuccess:^(void)
             {
                 if(self.seeOffCarLevArray.count == 0)
                 {
                     [self getAirportTransferCarList];
                 }
             }andFailure:^(void)
             {
                 
             }];
        }
        else
        {
            if(self.seeOffCarLevArray.count == 0)
            {
                [self getAirportTransferCarList];
            }
        }
    }
    [self.tableView reloadData];
}

- (void)setRightBarButtonItemWithTitle:(NSString *)title
{
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(chooseCity)];
}
#pragma mark - 选择城市
- (void)chooseCity
{
    BeSpecialCarCityViewController *cityVC = [[BeSpecialCarCityViewController alloc]init];
    cityVC.cityListArray = self.cityListArray;
    cityVC.currentCityModel = self.currentLocationCity;
    cityVC.block = ^ (BeSpeCityModel *model)
    {
        if([model.cityName hasPrefix:self.selectCityModel.cityName])
        {
            //选择的城市跟当前选中的城市相等
            return;
        }
        if([model.cityName hasPrefix:self.currentLocationCity.cityName])
        {
            //选择的城市是当前定位的城市
            model.cityLat = [self.currentLocationCity.cityLat mutableCopy];
            model.cityLng = [self.currentLocationCity.cityLng mutableCopy];
        }
        self.destinationModel = nil;
        self.pickupAirportModel = nil;
        self.pickupFlightModel = nil;
        self.pickupDestinationModel = nil;
        self.seeOffAirportModel = nil;
        self.seeOffStartAddressModel = nil;
        [self.carLevArray removeAllObjects];
        [self.pickupCarLevArray removeAllObjects];
        [self.seeOffCarLevArray removeAllObjects];
        [self setRightBarButtonItemWithTitle:model.cityName];
        self.selectCityModel = model;
        [self.tableView reloadData];
        [self speHeaderViewDidClickWith:self.sourceType];
    };
    [self.navigationController pushViewController:cityVC animated:YES];
}
#pragma mark - 获取易道的城市code
- (void)setupYDServiceRequest
{
    [MBProgressHUD showMessage:@""];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kSpeRequestUrl,@"YD/YD1_Service"];
    [BeSpecialCarHttp getPath:urlStr success:^(id responseObj) {
      //  NSLog(@"获取城市 = %@", responseObj);
        NSArray *valueArray = [responseObj allValues];
        for (NSDictionary *dict in valueArray) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                NSString *cityStr = dict[@"name"];
                if ([self.selectCityModel.cityName hasPrefix:cityStr]) {
                    self.selectCityModel.cityCode = dict[@"short"];
                    break;
                }
            }
        }
        [self setupYDPriceRequest:self.selectCityModel.cityCode];
    } failure:^(NSError *error)
     {
         [self setupYDPriceRequest:self.selectCityModel.cityCode];
     }];
    if([self.currentLocationCity.cityName length] < 1)
    {
        [self currentCityGetDataFrom:self.selectCityModel];
    }
}
#pragma mark - 获取城市车型
- (void)setupYDPriceRequest:(NSString *)cityStr
{
    NSLog(@"发送 = %@",cityStr);
    if([self.infoModel.startTime isEqualToString:@"现在"]){
        self.infoModel.startTimePrama = [CommonMethod stringFromDate:[NSDate date] WithParseStr:kFormatYYYYMMDDHHMMSS];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kSpeRequestUrl,@"ZC2_Estimate"];
    NSString *valueStr = [NSString stringWithFormat:@"flat=%@&flng=%@&tlat=%@&tlng=%@&map_type=%@&require_level=%@&type=%@&city=%@&departure_time=%@&aircode=%@&rent_time=%@&rule=%@&cityname=%@", self.selectCityModel.cityLat,self.selectCityModel.cityLng, self.selectCityModel.cityLat, self.selectCityModel.cityLng, @"1", @"", @"2", cityStr, self.infoModel.startTimePrama, @"", @"1", @"1",self.selectCityModel.cityName];
    [BeSpecialCarHttp postPath:urlStr withParameters:valueStr success:^(id responseObj) {
        [MBProgressHUD hideHUD];
        NSLog(@"车型返回:%@", responseObj);
        NSArray *array = [responseObj objectForKey:@"result"];
        if (array.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"获取城市车型失败" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: @"重试",nil];
            alert.tag = 1002;
            [alert show];
            return;
        }
        [self.carLevArray removeAllObjects];
        for (NSDictionary *dict in array) {
            [BeSpeCarLevelModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *
             {
                 return @{@"start_price" : @"starting_fee" };
             }];
            BeSpeCarLevelModel *levModel = [BeSpeCarLevelModel mj_objectWithKeyValues:dict];
            levModel.name = levModel.car_type;
            levModel.start_price = [NSString stringWithFormat:@"%@", [dict[@"estimated_price_detail"] objectForKey:@"fixed_fee" ]];
            if(dict[@"estimated_price_detail"] != nil)
            {
                levModel.dynamic_md5 = [NSString stringWithFormat:@"%@", [dict[@"estimated_price_detail"] stringValueForKey:@"dynamic_md5" defaultValue:@""]];
            }
            else
            {
                levModel.dynamic_md5 = @"";
            }
            [self.carLevArray addObject:levModel];            
        }
        
        // 按价格进行排序
        NSSortDescriptor *firstnameDesc = [NSSortDescriptor sortDescriptorWithKey:@"startPriceInt" ascending:YES];
        // 按顺序添加排序描述器
        NSArray *descs = [NSArray arrayWithObjects:firstnameDesc, nil];
        NSArray *desArray = [self.carLevArray sortedArrayUsingDescriptors:descs];
        [self.carLevArray removeAllObjects];
        [self.carLevArray addObjectsFromArray:desArray];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        if(error.code == 20015)
        {
            [CommonMethod showMessage:@"所在城市暂未开通用车"];
            return ;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"获取城市车型失败" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: @"重试",nil];
        alert.tag = 1002;
        [alert show];
    }];
}

#pragma mark - 立即用车获取车型预估价
- (void)setupYDRequestEstimate
{
    if([self.infoModel.startTime isEqualToString:@"现在"]){
        self.infoModel.startTimePrama = [CommonMethod stringFromDate:[NSDate date] WithParseStr:kFormatYYYYMMDDHHMMSS];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kSpeRequestUrl,@"ZC2_Estimate"];
    NSString *valueStr = [NSString stringWithFormat:@"flat=%@&flng=%@&tlat=%@&tlng=%@&map_type=%@&require_level=%@&type=%@&city=%@&departure_time=%@&aircode=%@&rent_time=%@&rule=%@&cityname=%@", [NSString stringWithFormat:@"%f", self.startAddressModel.location.latitude],[NSString stringWithFormat:@"%f",self.startAddressModel.location.longitude], [NSString stringWithFormat:@"%f", self.destinationModel.location.latitude], [NSString stringWithFormat:@"%f", self.destinationModel.location.longitude], @"1", @"", @"2", self.selectCityModel.cityCode, self.infoModel.startTimePrama, @"", @"1", @"1",self.selectCityModel.cityName];
    [BeSpecialCarHttp postPath:urlStr withParameters:valueStr success:^(id responseObj) {
        SBHLog(@"%@", responseObj);
        NSArray *array = [responseObj objectForKey:@"result"];
        if (array.count == 0) {
            if (self.reRequest == NO) {
                [self setupYDRequestEstimate];
                self.reRequest = YES;
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络不给力，获取预估价失败" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: @"重试",nil];
                alert.tag = 1003;
                [alert show];
            }
        }
        [self.carLevArray removeAllObjects];
        for (NSDictionary *dict in array) {
            [BeSpeCarLevelModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *
             {
                 return @{@"start_price" : @"starting_fee" };
             }];
            BeSpeCarLevelModel *levModel = [BeSpeCarLevelModel mj_objectWithKeyValues:dict];
            levModel.name = levModel.car_type;
            levModel.start_price = [NSString stringWithFormat:@"%@", dict[@"total_fee"]];
            if(dict[@"estimated_price_detail"] != nil)
            {
                levModel.dynamic_md5 = [NSString stringWithFormat:@"%@", [dict[@"estimated_price_detail"] stringValueForKey:@"dynamic_md5" defaultValue:@""]];
            }
            else
            {
                levModel.dynamic_md5 = @"";
            }
            [self.carLevArray addObject:levModel];
        }
        
        // 按价格进行排序
        NSSortDescriptor *firstnameDesc = [NSSortDescriptor sortDescriptorWithKey:@"startPriceInt" ascending:YES];
        // 按顺序添加排序描述器
        NSArray *descs = [NSArray arrayWithObjects:firstnameDesc, nil];
        NSArray *desArray = [self.carLevArray sortedArrayUsingDescriptors:descs];
        [self.carLevArray removeAllObjects];
        [self.carLevArray addObjectsFromArray:desArray];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        if(error.code == 20015)
        {
            [CommonMethod showMessage:@"所在城市暂未开通用车"];
            return ;
        }
        if (self.reRequest == NO) {
            [self setupYDRequestEstimate];
            self.reRequest = YES;
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络不给力，获取预估价失败" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: @"重试",nil];
            alert.tag = 1003;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert show];
            });
        }
    }];
}

- (void)requestFlase:(NSError *)error
{
    if (error.code == kHttpRequestCancelledError || error.code == kErrCodeNetWorkUnavaible){
        [CommonMethod showMessage:kNetworkAbnormal];
    } else if ([error.domain isEqualToString:KErrorCode]){
        [CommonMethod showMessage:error.userInfo[KErrorCode]];
    } else {
        if (error.code == 20031) {
            [CommonMethod showMessage:@"企业额度不够,或是合同已到期，请验证后，再提交"];
        }else if (error.code == 20032)
        {
            [CommonMethod showMessage:@"经济型叫车异常，请选择其他车型"];
        }
        else if (error.code == -1005)  // 网络中断
        {
            [CommonMethod showMessage:@"网络异常"];
        }
        else if (error.code == -1001)  // 网络请求超时
        {
            [CommonMethod showMessage:@"网络超时"];
        }
        else {
            [CommonMethod showMessage:[NSString stringWithFormat:@"叫车失败，请重试%ld", (long)error.code]];
        }
    }
}
#pragma mark - 叫车
- (void)sureAction:(UIButton *)btn
{
    [self checkOrderParamsIsComplete];
}

#pragma mark - 选择出发时间
- (void)setupBottomPickerView
{
    BeDatePickerView *pickerView = [[BeDatePickerView alloc] initWithFrame:CGRectMake(0, 0, SBHScreenW, kScreenHeight)];
    pickerView.datePickerViewSelResultBlock = ^(BeSpeInfoModel *infoModel){
        if (infoModel != nil) {
            if(self.sourceType == SpecialSubControllerTypeCar)
            {
                self.infoModel = infoModel;
            }
            else if(self.sourceType == SpecialSubControllerTypePickUp)
            {
                self.pickupDateModel = infoModel;
            }
            else
            {
                self.seeOffDateModel = infoModel;
            }
            [self.tableView reloadData];
        }
        self.tableView.scrollEnabled = YES;
    };
    [pickerView show];
}

#pragma mark - TableViewDataSource && Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.sourceType == SpecialSubControllerTypePickUp?4:3;
    }
    if (section == 3)
    {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 122;
    }
    else if(indexPath.section == 2)
    {
        return 39*2.0;
    }
    return 39;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SBHMyCell *cell = [SBHMyCell cellWithTableView:tableView];
        cell.rightArrow.hidden = YES;
        cell.myTitle.font = kSpeFont;
        cell.myTitle.textColor = kSpeDarkColor;
        cell.sepImageView.hidden = YES;
        if(self.sourceType == SpecialSubControllerTypeCar)
        {
            //立即用车
            if(indexPath.row == 0)
            {
                [cell.myIcon setImage:[UIImage imageNamed:@"speCarDate"] forState:UIControlStateNormal];
                cell.myTitle.text = [self.infoModel.startTime isEqualToString:@"现在"]? @"出发时间(默认为当前时间)":self.infoModel.startTime;
            }
            else if (indexPath.row == 1)
            {
                [cell.myIcon setImage:[UIImage imageNamed:@"spe_start_place"] forState:UIControlStateNormal];
                cell.myTitle.text = self.startAddressModel.title.length == 0?@"出发地":self.startAddressModel.title;
            }
            else if (indexPath.row == 2)
            {
                [cell.myIcon setImage:[UIImage imageNamed:@"spe_ destination"] forState:UIControlStateNormal];
                cell.myTitle.text =self.destinationModel.title.length == 0? @"目的地":self.destinationModel.title;
            }
        }
        else if (self.sourceType == SpecialSubControllerTypePickUp)
        {
            //接机
            if(indexPath.row == 0)
            {
                [cell.myIcon setImage:[UIImage imageNamed:@"speCarFlight"] forState:UIControlStateNormal];
                cell.myTitle.text = self.pickupFlightModel.flightName.length>0?self.pickupFlightModel.flightName:@"航班号";
            }
            else if (indexPath.row == 1)
            {
                [cell.myIcon setImage:[UIImage imageNamed:@"speCarDate"] forState:UIControlStateNormal];
                cell.myTitle.text = [self.pickupDateModel.startTime isEqualToString:@"现在"]? @"接机时间(默认为当前时间)":self.pickupDateModel.startTime;
            }
            else if (indexPath.row == 2)
            {
                [cell.myIcon setImage:[UIImage imageNamed:@"spe_start_place"] forState:UIControlStateNormal];
                cell.myTitle.text = self.pickupAirportModel.airportName.length == 0?@"出发机场":self.pickupAirportModel.airportName;
            }
            else if (indexPath.row == 3)
            {
                [cell.myIcon setImage:[UIImage imageNamed:@"spe_ destination"] forState:UIControlStateNormal];
                cell.myTitle.text = self.pickupDestinationModel.title.length == 0? @"目的地":self.pickupDestinationModel.title;
            }
        }
        else if(self.sourceType == SpecialSubControllerTypeSeeOff)
        {
            //送机
            if(indexPath.row == 0)
            {
                [cell.myIcon setImage:[UIImage imageNamed:@"speCarDate"] forState:UIControlStateNormal];
                cell.myTitle.text = [self.seeOffDateModel.startTime isEqualToString:@"现在"]? @"送机时间(默认为当前时间)":self.seeOffDateModel.startTime;
            }
            else if (indexPath.row == 1)
            {
                [cell.myIcon setImage:[UIImage imageNamed:@"spe_start_place"] forState:UIControlStateNormal];
                cell.myTitle.text = self.seeOffStartAddressModel.title.length == 0?@"出发地":self.seeOffStartAddressModel.title;
            }
            else if (indexPath.row == 2)
            {
                [cell.myIcon setImage:[UIImage imageNamed:@"spe_ destination"] forState:UIControlStateNormal];
                cell.myTitle.text = self.seeOffAirportModel.airportName.length == 0?@"目的地":self.seeOffAirportModel.airportName;
            }
        }
        return cell;
    }
    if(indexPath.section == 1)
    {
        BeSpeChooseCarCell *cell = [BeSpeChooseCarCell cellWithTableView:tableView];
        if(self.sourceType == SpecialSubControllerTypeCar)
        {
            cell.carlevArray = self.carLevArray;
        }
        else if(self.sourceType == SpecialSubControllerTypePickUp)
        {
            cell.carlevArray = self.pickupCarLevArray;
        }
        else
        {
            cell.carlevArray = self.seeOffCarLevArray;
        }
        return cell;
    }
    if(indexPath.section == 2)
    {
        BeHotelOrderContactTableViewCell *cell = [BeHotelOrderContactTableViewCell cellWithTableView:tableView];
        [cell.selectButton setImage:[UIImage imageNamed:@"xzlxr_xintianjiaIcon"] forState:UIControlStateNormal];
        [cell.selectButton addTarget:self action:@selector(addPerAction) forControlEvents:UIControlEventTouchUpInside];
        cell.contactNameTF.x = cell.contactTelephoneTF.x = 90;
        cell.contactNameTF.width = cell.contactTelephoneTF.width = kScreenWidth - 50 - 90;
        cell.nameLabel.x = cell.telephoneLabel.x = 10;
        cell.selectButton.centerX = kScreenWidth - 20;
        cell.contactTelephoneTF.text = self.personModel.iMobile;
        cell.contactNameTF.text = self.personModel.iName;
        cell.nameLabel.text = cell.contactNameTF.placeholder = @"用车人";
        cell.telephoneLabel.text = cell.contactTelephoneTF.placeholder = @"联系电话";
        cell.nameLabel.textColor = cell.telephoneLabel.textColor = kSpeDarkColor;
        cell.contactNameTF.tag = 666;
        cell.contactNameTF.delegate = self;
        cell.contactTelephoneTF.tag = 667;
        cell.contactTelephoneTF.delegate = self;
        return cell;
    }
    if (indexPath.section == 3) {
        SBHDingdanCommonCell *cell = [SBHDingdanCommonCell cellWithTableView:tableView];
        cell.commonTextField.textColor = cell.xingming.textColor = kSpeDarkColor;
        cell.commonTextField.font = cell.xingming.font = kSpeFont;
        cell.sepImageView.hidden = YES;
        if (indexPath.row == 0) {
            cell.commonTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"(必填)" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
            cell.xingming.text = @"费用中心";
            cell.commonTextField.text = self.centerStr;
            cell.commonTextField.tag = 555;
            cell.commonTextField.delegate = self;
        }
        if (indexPath.row == 1) {
            cell.xingming.text = @"用车原因";
            cell.commonTextField.userInteractionEnabled = NO;
            cell.commonTextField.text = self.reasonStr;
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0 && self.sourceType == SpecialSubControllerTypePickUp)
        {
            //选择航班号
            BeSpecialCarFlightViewController *flightVC = [[BeSpecialCarFlightViewController alloc]init];
            flightVC.cityName = self.selectCityModel.cityName;
            flightVC.selectFlight = self.pickupFlightModel;
            flightVC.block = ^(BeSpeCarFlightModel *flightModel)
            {
                self.pickupFlightModel = flightModel;
                [self.tableView reloadData];
            };
            flightVC.sourceType = SpecialCarFlightVCTypeFlightNumber;
            [self.navigationController pushViewController:flightVC animated:YES];
        }
        else if ((indexPath.row == 2 && self.sourceType == SpecialSubControllerTypePickUp) || (indexPath.row == 2 && self.sourceType == SpecialSubControllerTypeSeeOff))
        {
            //选择机场
            BeSpecialCarFlightViewController *flightVC = [[BeSpecialCarFlightViewController alloc]init];
            flightVC.sourceType = SpecialCarFlightVCTypeAirport;
            flightVC.cityName = self.selectCityModel.cityName;
            flightVC.block = ^(BeSpeCarAirportModel *airportModel)
            {
                if(self.sourceType == SpecialSubControllerTypePickUp)
                {
                    self.pickupAirportModel = airportModel;
                }
                else
                {
                    self.seeOffAirportModel = airportModel;
                }
                [self.tableView reloadData];
                [self getAirportTransferFee];
            };
            [self.navigationController pushViewController:flightVC animated:YES];
        }
        else if ((indexPath.row == 1 && self.sourceType == SpecialSubControllerTypePickUp) || (indexPath.row == 0 && self.sourceType != SpecialSubControllerTypePickUp))
        {
            //选择出发时间
            self.tableView.scrollEnabled = NO;
            [self setupBottomPickerView];
        }
        else if (indexPath.row == 1 && self.sourceType != SpecialSubControllerTypePickUp)
        {
            //立即用车 选择出发地
            BeMapSearchViewController *mapVC = [[BeMapSearchViewController alloc]init];
            mapVC.sourceType = MapViewSourceTypeStart;
            mapVC.locationCity = self.selectCityModel;
            mapVC.delegate = self;
            [self.navigationController pushViewController:mapVC animated:YES];
        }
        else if ((indexPath.row == 2 && self.sourceType == SpecialSubControllerTypeCar)||(indexPath.row == 3 && self.sourceType == SpecialSubControllerTypePickUp))
        {
            //选择目的地
            BeMapSearchViewController *mapVC = [[BeMapSearchViewController alloc]init];
            mapVC.sourceType = MapViewSourceTypeDestination;
            mapVC.locationCity = self.selectCityModel;
            mapVC.delegate = self;
            [self.navigationController pushViewController:mapVC animated:YES];
        }
    }
    if (indexPath.section == 3)
    {
        if (indexPath.row == 1)
        {
            BeActionSheetCustom *sheet = [[BeActionSheetCustom alloc] initWithTitle:self.reasonTitleArray];
            sheet.actionSheetCustomClickBlock = ^(int clickIndex){
                self.reasonStr = [self.reasonTitleArray objectAtIndex:clickIndex];
                [self.tableView reloadData];
            };
            for (int i = 0; i<self.reasonTitleArray.count; i++) {
                NSString *str = [self.reasonTitleArray objectAtIndex:i];
                if ([str isEqualToString:self.reasonStr]) {
                    sheet.indexInt = i;
                }
            }
            [sheet show];
        }
    }
}
#pragma mark - 选择乘车人
- (void)addPerAction
{
    BeChoosePassengerController *chooseVc = [[BeChoosePassengerController alloc] init];
    chooseVc.title = @"选择乘车人";
    chooseVc.block = ^(NSMutableArray *callback)
    {
        if(callback.count > 0)
        {
            self.personModel = callback.lastObject;
            self.selPassengerModel = callback.lastObject;
            self.centerStr = self.personModel.rolename;
            [self.tableView reloadData];
        }
    };
    [self.navigationController pushViewController:chooseVc animated:YES];
}

#define mark - mapdelegate
- (void)selectStartAddressWith:(BeAddressModel *)item
{
    if(self.sourceType == SpecialSubControllerTypeCar)
    {
        self.startAddressModel = item;
        [self.tableView reloadData];
        if (self.destinationModel.title.length !=0 && self.startAddressModel.title.length !=0) {
            [self setupYDRequestEstimate];
        }
    }
    else if (self.sourceType == SpecialSubControllerTypeSeeOff)
    {
        self.seeOffStartAddressModel = item;
        [self.tableView reloadData];
        [self getAirportTransferFee];
    }
}
- (void)selectDestinationWith:(BeAddressModel *)item
{
    if(self.sourceType == SpecialSubControllerTypeCar)
    {
        self.destinationModel = item;
        [self.tableView reloadData];
        if (self.destinationModel.title.length !=0 && self.startAddressModel.title.length !=0) {
            [self setupYDRequestEstimate];
        }
    }
    else if (self.sourceType == SpecialSubControllerTypePickUp)
    {
        self.pickupDestinationModel = item;
        [self.tableView reloadData];
        [self getAirportTransferFee];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 555) {
        self.centerStr = textField.text;
    } else if(textField.tag == 556){
        self.reasonStr = textField.text;
    }
    if (textField.tag == 666) {
        self.personModel.iName = textField.text;
    }
    if (textField.tag == 667) {
        self.personModel.iMobile = textField.text;
        if (![BeRegularExpressionUtil validateMobile:textField.text]) {
            [MBProgressHUD showError:@"请输入正确的电话号码"];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==3001) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [BeLogUtility doLogOn];
        });
    }
    
    if (alertView.tag == 1002) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            if(self.sourceType == SpecialSubControllerTypeCar)
            {
                [self setupYDServiceRequest];
            }
            else
            {
                [self getAirportTransferCarList];
            }
        }
    }
    if (alertView.tag == 1003) {
        [MBProgressHUD hideHUD];
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            if(self.sourceType == SpecialSubControllerTypeCar)
            {
                [self setupYDRequestEstimate];
            }
            else
            {
                [self getAirportTransferFee];
            }
        }
    }
}
- (void)getCurrentLocation
{
#if TARGET_IPHONE_SIMULATOR
    self.selectCityModel.cityLat = [NSString stringWithFormat:@"%.6f",kSimulatorLat];
    self.selectCityModel.cityLng = [NSString stringWithFormat:@"%.6f",kSimulatorLng];
    [self startSearchWith:CLLocationCoordinate2DMake(kSimulatorLat, kSimulatorLng)];
    return;
#endif
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务已关闭" message:@"请到设置->隐私->定位服务中开启【身边惠商旅版】定位服务，以便司机能够准确获取您的位置信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger index)
         {
             [self.navigationController popViewControllerAnimated:YES];
         }];
        return;
    }
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if(delegate.coordinate.latitude < 1)
    {
        [self getCurrentLocation];
        return;
    }
    self.selectCityModel.cityLat = [NSString stringWithFormat:@"%.6f",delegate.coordinate.latitude];
    self.selectCityModel.cityLng = [NSString stringWithFormat:@"%.6f",delegate.coordinate.longitude];
    [self startSearchWith:delegate.coordinate];
}
- (void)startSearchWith:(CLLocationCoordinate2D )coordi
{
    QMSReverseGeoCodeSearchOption *reGeoSearchOption = [[QMSReverseGeoCodeSearchOption alloc] init];
    [reGeoSearchOption setLocationWithCenterCoordinate:coordi];
    [reGeoSearchOption setGet_poi:YES];
    [reGeoSearchOption setCoord_type:QMSReverseGeoCodeCoordinateTencentGoogleGaodeType];
    [self.mapSearcher searchWithReverseGeoCodeSearchOption:reGeoSearchOption];
}
- (void)searchWithGeoCodeSearchOption:(QMSGeoCodeSearchOption *)geoCodeSearchOption didReceiveResult:(QMSGeoCodeSearchResult *)geoCodeSearchResult
{
    // NSLog(@"geo result:%@", geoCodeSearchResult.location);
}
- (void)searchWithReverseGeoCodeSearchOption:(QMSReverseGeoCodeSearchOption *)reverseGeoCodeSearchOption didReceiveResult:(QMSReverseGeoCodeSearchResult *)reverseGeoCodeSearchResult
{
    if(self.selectCityModel.cityName.length < 1)
    {
        [self setRightBarButtonItemWithTitle:reverseGeoCodeSearchResult.address_component.city];
        self.selectCityModel.cityName = reverseGeoCodeSearchResult.address_component.city;
    }
    self.startAddressModel.location = CLLocationCoordinate2DMake([self.selectCityModel.cityLat floatValue], [self.selectCityModel.cityLng floatValue]);
    self.startAddressModel.address = reverseGeoCodeSearchResult.formatted_addresses.recommend;
    self.startAddressModel.title = reverseGeoCodeSearchResult.formatted_addresses.rough;
    [self.tableView reloadData];
    [self setupYDServiceRequest];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
