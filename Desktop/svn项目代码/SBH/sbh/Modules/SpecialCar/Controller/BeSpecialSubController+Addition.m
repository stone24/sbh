//
//  BeSpecialSubController+Addition.m
//  sbh
//
//  Created by RobinLiu on 16/1/7.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeSpecialSubController+Addition.h"

@implementation BeSpecialSubController (Addition)
- (void)initializationData
{
    self.selectCityModel = [[BeSpeCityModel alloc]init];
    self.cityListArray = [[NSMutableArray alloc]init];
    self.reasonTitleArray = @[@"日常外出", @"加班用车", @"代客户叫车", @"其他"];
    self.carLevArray = [[NSMutableArray alloc]init];
    self.pickupCarLevArray = [[NSMutableArray alloc]init];
    self.seeOffCarLevArray = [[NSMutableArray alloc]init];
    self.infoModel = [[BeSpeInfoModel alloc] init];
    self.infoModel.startTime = @"现在";
    self.personModel = [[selectPerson alloc] init];
    self.personModel.depid = @"0";
    self.selPassengerModel = [[selectPerson alloc] init];
    self.startAddressModel = [[BeAddressModel alloc]init];
    self.currentLocationCity = [[BeSpeCityModel alloc]init];
    
    self.centerStr = @"";
    self.reasonStr = self.reasonTitleArray.firstObject;
    // 个人用户处理
    if ([[GlobalData getSharedInstance].userModel.levelcode isEqualToString:@"3"]) {
        self.personModel.iName = [GlobalData getSharedInstance].userModel.staffname;
        self.personModel.iMobile = [GlobalData getSharedInstance].userModel.MobilePhone;
        self.personModel.rolename = [GlobalData getSharedInstance].userModel.DptName;
        self.centerStr = [GlobalData getSharedInstance].userModel.DptName;
    }
    
    if ([[GlobalData getSharedInstance].userModel.levelcode isEqualToString:@"2"]) {
        self.personModel.rolename = [GlobalData getSharedInstance].userModel.DptName;
        self.centerStr = [GlobalData getSharedInstance].userModel.DptName;
    }
    
    self.pickupFlightModel = [[BeSpeCarFlightModel alloc]init];
    self.pickupDateModel = [[BeSpeInfoModel alloc]init];
    self.pickupDateModel.startTime = @"现在";
    self.pickupAirportModel = [[BeSpeCarAirportModel alloc]init];
    self.pickupDestinationModel = [[BeAddressModel alloc]init];
    
    self.seeOffDateModel = [[BeSpeInfoModel alloc]init];
    self.seeOffDateModel.startTime = @"现在";
    self.seeOffAirportModel = [[BeSpeCarAirportModel alloc]init];
    self.seeOffStartAddressModel = [[BeAddressModel alloc]init];
}
- (void)getCityList
{
    [[ServerFactory getServerInstance:@"BeMapServer"]getSpecialCarCityWithCallback:^(NSMutableArray *callback)
     {
         NSLog(@"用车城市 = %@",callback);
         NSArray *cityNameArray = [ChineseToPinyin cityDataArray];
         for(NSDictionary *member in callback)
         {
             BeSpeCityModel *model = [[BeSpeCityModel alloc]initWithCityDict:member];
             BOOL containsCity = NO;
             for(NSDictionary *cityMember in cityNameArray)
             {
                 NSString *name = [cityMember objectForKey:@"name"];
                 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@",name];
                 if ([predicate evaluateWithObject:model.cityName]) {
                     model.pinyin = [cityMember objectForKey:@"pinyin"];
                     containsCity = YES;
                     break;
                 }
             }
             if(!containsCity)
             {
                 model.pinyin = [ChineseToPinyin cityPinyinFromName:model.cityName];
             }
             [self.cityListArray addObject:model];
         }
     }andFailure:^(NSError *error)
     {
         NSLog(@"城市列表error=%@",error);
     }];
}

- (void)currentCityGetDataFrom:(BeSpeCityModel *)model
{
    self.currentLocationCity.cityName = [model.cityName mutableCopy];
    self.currentLocationCity.cityCode = [model.cityCode mutableCopy];
    self.currentLocationCity.cityLat = [model.cityLat mutableCopy];
    self.currentLocationCity.cityLng = [model.cityLng mutableCopy];
}
- (void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,13,0,13)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,13,0,13)];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,13,0,13)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,13,0,13)];
    }
}
- (void)getCityIdWithSuccess:(void (^)(void))callback andFailure:(void(^)(void))failureCallback
{
    NSString *tempString = [self.selectCityModel.cityName mutableCopy];
    if([tempString rangeOfString:@"市"].location != NSNotFound)
    {
        //过滤掉市字
        tempString = [[tempString componentsSeparatedByString:@"市"] firstObject];
    }
    if ([tempString rangeOfString:@"地区"].location != NSNotFound)
    {
        //过滤掉地区字
        tempString = [[tempString componentsSeparatedByString:@"地区"] firstObject];
    }
    NSString *urlString = [NSString stringWithFormat:@"%@ShouQi",@"http://192.168.10.27:8999/"];
    NSString *valueStr = [NSString stringWithFormat:@"cityName=%@&channel=emax&method=getCityAirport",tempString];
    [BeSpecialCarHttp postPath:urlString withParameters:valueStr success:^(id responseObj)
     {
         NSDictionary *data = [responseObj dictValueForKey:@"data"];
         self.selectCityModel.cityId = [data stringValueForKey:@"cityId"];
         NSArray *airports = [data arrayValueForKey:@"airports"];
         for(NSDictionary *member in airports)
         {
             self.pickupAirportModel = [[BeSpeCarAirportModel alloc]initWithDict:member];
             self.seeOffAirportModel = [[BeSpeCarAirportModel alloc]initWithDict:member];
             break;
         }
         callback();
     }failure:^(NSError *error){
         NSLog(@"失败 = %@",error);
         failureCallback();
     }];
}
- (void)getAirportTransferCarList
{
    NSString *urlString = [NSString stringWithFormat:@"%@ShouQi",@"http://192.168.10.27:8999/"];
    NSString *valueStr = [NSString stringWithFormat:@"cityId=%@&channel=emax&method=getGroupsPrice&pickUpType=%@",self.selectCityModel.cityId,self.sourceType == SpecialSubControllerTypePickUp?@"01":@"02"];
    [BeSpecialCarHttp postPath:urlString withParameters:valueStr success:^(id responseObj)
     {
         NSLog(@"接送机的车型列表 = %@",responseObj);
         NSArray *array = [responseObj objectForKey:@"result"];
         if(![array isKindOfClass:[NSArray class]])
         {
             return ;
         }
         
         if (array.count == 0) {
             
         }
         NSMutableArray *tempArray = [[NSMutableArray alloc]init];
         for (NSDictionary *dict in array)
         {
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
             [tempArray addObject:levModel];
         }
         NSSortDescriptor *firstnameDesc = [NSSortDescriptor sortDescriptorWithKey:@"startPriceInt" ascending:YES];
         // 按顺序添加排序描述器
         NSArray *descs = [NSArray arrayWithObjects:firstnameDesc, nil];
         if(self.sourceType == SpecialSubControllerTypePickUp)
         {
             [self.pickupCarLevArray removeAllObjects];
             [self.pickupCarLevArray addObjectsFromArray:[tempArray sortedArrayUsingDescriptors:descs]];
         }
         else
         {
             [self.seeOffCarLevArray removeAllObjects];
             [self.seeOffCarLevArray addObjectsFromArray:[tempArray sortedArrayUsingDescriptors:descs]];
         }
         [self.tableView reloadData];
     }failure:^(NSError *error){
         NSLog(@"失败 = %@",error);
     }];
}
- (void)getAirportTransferFee
{
    NSString *urlString = [NSString stringWithFormat:@"%@ShouQi",@"http://192.168.10.27:8999/"];
    NSString *serviceType = self.sourceType == SpecialSubControllerTypePickUp?@"3":@"5";
    NSString *bookingStartPointLo = @"";
    NSString *bookingStartPointLa = @"";
    NSString *bookingEndPointLo = @"";
    NSString *bookingEndPointLa = @"";
    if(self.sourceType == SpecialSubControllerTypePickUp)
    {
        //接机
        bookingStartPointLo = self.pickupAirportModel.longitude;
        bookingStartPointLa = self.pickupAirportModel.latitude;
        bookingEndPointLo = [NSString stringWithFormat:@"%f", self.pickupDestinationModel.location.longitude];
        bookingEndPointLa = [NSString stringWithFormat:@"%f", self.pickupDestinationModel.location.latitude];
    }
    else
    {
        //送机
        bookingStartPointLo = [NSString stringWithFormat:@"%f", self.seeOffStartAddressModel.location.longitude];
        bookingStartPointLa = [NSString stringWithFormat:@"%f", self.seeOffStartAddressModel.location.latitude];
        bookingEndPointLo = self.seeOffAirportModel.longitude;
        bookingEndPointLa = self.seeOffAirportModel.latitude;
    }
    NSString *valueStr = [NSString stringWithFormat:@"serviceType=%@&cityId=%@&bookingStartPointLo=%@&bookingStartPointLa=%@&bookingEndPointLo=%@&bookingEndPointLa=%@&groups=34:1,35:2&channel=emax&method=getFarePrediction",serviceType,self.selectCityModel.cityId,bookingStartPointLo,bookingStartPointLa,bookingEndPointLo,bookingEndPointLa];
    [BeSpecialCarHttp postPath:urlString withParameters:valueStr success:^(id responseObj)
     {
         NSLog(@"接送机的车型列表 = %@",responseObj);
         NSArray *array = [responseObj objectForKey:@"result"];
         if(![array isKindOfClass:[NSArray class]])
         {
             return ;
         }
         [self.carLevArray removeAllObjects];
         for (NSDictionary *dict in array)
         {
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
         NSSortDescriptor *firstnameDesc = [NSSortDescriptor sortDescriptorWithKey:@"startPriceInt" ascending:YES];
         // 按顺序添加排序描述器
         NSArray *descs = [NSArray arrayWithObjects:firstnameDesc, nil];
         NSArray *desArray = [self.carLevArray sortedArrayUsingDescriptors:descs];
         [self.carLevArray removeAllObjects];
         [self.carLevArray addObjectsFromArray:desArray];
         [self.tableView reloadData];
     }failure:^(NSError *error){
         NSLog(@"失败 = %@",error);
     }];
}
- (void)checkOrderParamsIsComplete
{
    BeSpeChooseCarCell *cell = (BeSpeChooseCarCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (cell.selCarModel.car_type_id.length == 0 || cell.selCarModel.start_price.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"叫车失败，请重试" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: @"重试",nil];
        alert.tag = 1003;
        [alert show];
        return;
    }
    if(self.sourceType == SpecialSubControllerTypeCar)
    {
        // 判断信息是否填写完全
        if (self.startAddressModel.title.length == 0) {
            [MBProgressHUD showError:@"请填写出发地"];
            return;
        }
        if(self.destinationModel.title.length == 0) {
            [MBProgressHUD showError:@"请填写目的地"];
            return;
        }
    }
    if(self.sourceType == SpecialSubControllerTypePickUp)
    {
        if(self.pickupFlightModel.flightName == nil ||[self.pickupFlightModel.flightName length] == 0)
        {
            [MBProgressHUD showError:@"请选择接机航班"];
            return;
        }
        if(self.pickupAirportModel.airportName == nil ||[self.pickupAirportModel.airportName length] == 0)
        {
            [MBProgressHUD showError:@"请选择接机机场"];
            return;
        }
        if(self.pickupDestinationModel.title == nil ||[self.pickupDestinationModel.title length] == 0)
        {
            [MBProgressHUD showError:@"请选择接机目的地"];
            return;
        }
    }
    if(self.sourceType == SpecialSubControllerTypeSeeOff)
    {
        if(self.seeOffStartAddressModel.title == nil ||[self.seeOffStartAddressModel.title length] == 0)
        {
            [MBProgressHUD showError:@"请选择送机出发地"];
            return;
        }
        if(self.seeOffAirportModel.airportName == nil ||[self.seeOffAirportModel.airportName length] == 0)
        {
            [MBProgressHUD showError:@"请选择送机机场"];
            return;
        }
    }
    
    if(self.personModel.iName.length == 0)
    {
        [MBProgressHUD showError:@"请填写乘车人姓名"];
        return;
    }
    else if(self.personModel.iMobile.length == 0)
    {
        [MBProgressHUD showError:@"请填写乘车人电话"];
        return;
    }
    else if(self.personModel.iName.length > 10)
    {
        [MBProgressHUD showError:@"乘车人姓名最多十个字"];
        return;
    } else if (![BeRegularExpressionUtil validateMobile:self.personModel.iMobile])
    {
        [MBProgressHUD showError:@"请输入正确的电话号码"];
        return;
    }
    if(self.centerStr.length == 0) {
        [MBProgressHUD showError:@"请填写费用中心"];
        SBHDingdanCommonCell *cell = (SBHDingdanCommonCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
        [cell.commonTextField becomeFirstResponder];
        return;
    }
    if(self.reasonStr.length == 0) {
        [MBProgressHUD showError:@"请填写用车原因"];
        SBHDingdanCommonCell *cell = (SBHDingdanCommonCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:3]];
        [cell.commonTextField becomeFirstResponder];
        return;
    }
    [self specialCarOrderSubmit];
}
- (void)specialCarOrderSubmit
{
    /*
     送机{"CarRule":"34","actualcost":"0","cartype":"34","cityid":"44","clat":"39.906225","clng":"116.462765","costcenter":"test","costdetail":"","dynamic_md5":"","endaddress":"首都国际机场T3航站楼 ","endname":"首都国际机场T3航站楼 ","estimatedcost":"341","flat":"39.906225","flng":"116.462765","map_type":"1","normalunitprice":"0","op":"1","ordercost":"0","orderno":"","othercost":"0","passengers":[{"Passengeraccountid":"194637","Passengerdepid":"0","Passengerentid":"0","passengermail":"","passengermobile":"15510599093","passengername":"wang"}],"remark":"","rent_time":"2","reservedate":"2016-12-20 14:27:01","ridingdate":"2016-12-20 14:27:29","ridingreasons":"日常外出","ridingway":"100","seats":"1","servicecost":"0","startaddress":"南航明珠商务酒店","startname":"北京市朝阳区东三环中路10号","startprice":"0","tlat":"40.056231","tlng":"116.614702","type":"3","format":"json","platform":"android","usertoken":"1482214847238|5009698b7d2f439c8afe31042c7119b6"}
     */
    
    /*接机
     {"CarRule":"34","actualcost":"0","airlineDate":"2016-12-21 00:35:00","airlineNum":"CA8902","arrCode":"PEK","cartype":"34","cityid":"44","clat":"39.905995","clng":"116.461855","costcenter":"刚刚","costdetail":"","depCode":"PEK","dynamic_md5":"","endaddress":"国贸-地铁站","endname":"国贸-地铁站","estimatedcost":"329","flat":"40.056231","flng":"116.614702","map_type":"1","normalunitprice":"0","op":"1","ordercost":"0","orderno":"","othercost":"0","passengers":[{"Passengeraccountid":"194637","Passengerdepid":"0","Passengerentid":"0","passengermail":"","passengermobile":"15510599093","passengername":"wang"}],"planDate":"2016-12-20 23:05:00","remark":"","rent_time":"2","reservedate":"2016-12-20 14:59:13","ridingdate":"2016-12-20 15:01:48","ridingreasons":"日常外出","ridingway":"100","seats":"1","servicecost":"0","startaddress":"首都国际机场T3航站楼 ","startname":"首都国际机场T3航站楼 ","startprice":"0","tlat":"39.908671","tlng":"116.460912","type":"2","format":"json","platform":"android","usertoken":"1482214847238|5009698b7d2f439c8afe31042c7119b6"}
     */
    
    
    BeSpeChooseCarCell *cell = (BeSpeChooseCarCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"ZuChe/ZCOrderSubmit"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"dynamic_md5"] = cell.selCarModel.dynamic_md5;
    params[@"cartype"] = cell.selCarModel.car_type_id;
    params[@"CarRule"] = cell.selCarModel.car_type_id;
    params[@"estimatedcost"] = cell.selCarModel.start_price;
    params[@"startprice"] = @"0";
    params[@"normalunitprice"] = @"0";
    params[@"actualcost"] = @"0";
    params[@"servicecost"] = @"0";
    params[@"othercost"] = @"0";
    params[@"ordercost"] = @"0";
    params[@"op"] = @"1";
    params[@"reservedate"] = [CommonMethod stringFromDate:[NSDate date] WithParseStr:kFormatYYYYMMDDHHMMSS];
    params[@"costcenter"] = self.centerStr;
    params[@"ridingreasons"] = self.reasonStr;
    params[@"remark"] = @"";
    params[@"settle"] = @"1";
    params[@"orderno"] = @"";
    params[@"ridingway"] = @"100";
    params[@"seats"] = @"1";
    params[@"usertoken"] = [GlobalData getSharedInstance].token;
    params[@"costdetail"] = @"";
    params[@"passengers"] = [self setupPersonParam];
    params[@"map_type"] = @"1";
    params[@"rent_time"] = @"2";
    // 下单的经纬度
    params[@"clng"] = self.selectCityModel.cityLng;
    params[@"clat"] = self.selectCityModel.cityLat;
    if(self.sourceType == SpecialSubControllerTypeCar)
    {
        NSString *startDateStr = self.infoModel.startTimePrama;
        // 实时/预订 type
        NSString *typeParam = @"0";
        if ([self.infoModel.startTime hasPrefix:@"今天"]) {
            typeParam = @"0";
        } else if([self.infoModel.startTime isEqualToString:@"现在"]){
            typeParam = @"1";
            double dataDouble = [[NSDate date] timeIntervalSince1970] + 5*60;
            NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:dataDouble];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            startDateStr = [dateFormatter stringFromDate:newDate];
        }
        params[@"ridingdate"] = startDateStr;
        params[@"type"] = typeParam;

        params[@"startname"] = self.startAddressModel.title;//详细地址
        params[@"endname"] = self.destinationModel.title;//详细地址
        params[@"startaddress"] = [self.startAddressModel.address length]>0?self.startAddressModel.address:self.startAddressModel.title;
        params[@"endaddress"] = [self.destinationModel.address length]>0?self.destinationModel.address:self.destinationModel.title;
        params[@"flng"] = [NSString stringWithFormat:@"%f", self.startAddressModel.location.longitude];
        params[@"flat"] = [NSString stringWithFormat:@"%f", self.startAddressModel.location.latitude];
        params[@"tlng"] = [NSString stringWithFormat:@"%f", self.destinationModel.location.longitude];
        params[@"tlat"] = [NSString stringWithFormat:@"%f", self.destinationModel.location.latitude];
        if (self.selectCityModel.cityCode.length == 0) {
            params[@"cityid"] = @"";
            params[@"cityname"] = self.selectCityModel.cityName;
        } else {
            params[@"cityid"] = self.selectCityModel.cityCode;
            params[@"cityname"] = @"";
        }
    }
    else if(self.sourceType == SpecialSubControllerTypePickUp)
    {
        params[@"type"] = @"2";
        params[@"airlineNum"] = self.pickupFlightModel.flightName;
        params[@"planDate"] = self.pickupFlightModel.planDate;
        params[@"airlineDate"] = self.pickupFlightModel.arrDate;
        params[@"depCode"] = self.pickupFlightModel.depCode;
        params[@"arrCode"] = self.pickupFlightModel.arrCode;
        
        NSString *startDateStr = self.pickupDateModel.startTimePrama;
        if([self.pickupDateModel.startTime isEqualToString:@"现在"]){
            double dataDouble = [[NSDate date] timeIntervalSince1970] + 5*60;
            NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:dataDouble];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            startDateStr = [dateFormatter stringFromDate:newDate];
        }
        params[@"ridingdate"] = startDateStr;
        params[@"startname"] = self.pickupAirportModel.airportName;//详细地址
        params[@"endname"] = self.pickupDestinationModel.title;//详细地址
        params[@"startaddress"] = self.pickupAirportModel.airportName;
        params[@"endaddress"] = [self.pickupDestinationModel.address length]>0?self.pickupDestinationModel.address:self.destinationModel.title;
        params[@"flng"] = self.pickupAirportModel.longitude;
        params[@"flat"] = self.pickupAirportModel.latitude;
        params[@"tlng"] = [NSString stringWithFormat:@"%f", self.pickupDestinationModel.location.longitude];
        params[@"tlat"] = [NSString stringWithFormat:@"%f", self.pickupDestinationModel.location.latitude];
        params[@"cityid"] = self.selectCityModel.cityId;
        params[@"cityname"] = self.selectCityModel.cityName;
    }
    else if (self.sourceType == SpecialSubControllerTypeSeeOff)
    {
        params[@"type"] = @"3";
        NSString *startDateStr = self.seeOffDateModel.startTimePrama;
        if([self.seeOffDateModel.startTime isEqualToString:@"现在"]){
            double dataDouble = [[NSDate date] timeIntervalSince1970] + 5*60;
            NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:dataDouble];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            startDateStr = [dateFormatter stringFromDate:newDate];
        }
        params[@"ridingdate"] = startDateStr;
        params[@"startname"] = self.seeOffStartAddressModel.title;//详细地址
        params[@"endname"] = self.seeOffAirportModel.airportName;//详细地址
        params[@"startaddress"] = [self.seeOffStartAddressModel.address length]>0?self.seeOffStartAddressModel.address:self.startAddressModel.title;
        params[@"endaddress"] = self.seeOffAirportModel.airportName;
        params[@"flng"] = [NSString stringWithFormat:@"%f", self.seeOffStartAddressModel.location.longitude];
        params[@"flat"] = [NSString stringWithFormat:@"%f", self.seeOffStartAddressModel.location.latitude];
        params[@"tlng"] = self.seeOffAirportModel.longitude;
        params[@"tlat"] = self.seeOffAirportModel.latitude;
        params[@"cityid"] = self.selectCityModel.cityId;
        params[@"cityname"] = self.selectCityModel.cityName;
    }
    NSLog(@"用车下单参数%@", params);
    
    // 参数转模型
    BeSpeCallCarPramaModel *callModel = [BeSpeCallCarPramaModel mj_objectWithKeyValues:params];
    callModel.passengersParam = [self setupPersonParam];
    //    // 处理参数模型
    callModel.passenger_name = self.personModel.iName;
    callModel.passenger_phone = self.personModel.iMobile;
    callModel.require_level = cell.selCarModel.car_level;
    NSMutableArray *carArray = [NSMutableArray array];
    if(self.sourceType == SpecialSubControllerTypeCar)
    {
        callModel.start_address = self.startAddressModel.title;
        callModel.end_address = self.destinationModel.title;
        [carArray addObjectsFromArray:self.carLevArray];
    }
    else if(self.sourceType == SpecialSubControllerTypePickUp)
    {
        callModel.start_address = self.pickupAirportModel.airportName;
        callModel.end_address = self.pickupDestinationModel.title;
        [carArray addObjectsFromArray:self.pickupCarLevArray];
    }
    else if (self.sourceType == SpecialSubControllerTypeSeeOff)
    {
        callModel.start_address = self.seeOffStartAddressModel.title;
        callModel.end_address = self.seeOffAirportModel.airportName;
        [carArray addObjectsFromArray:self.seeOffCarLevArray];
    }
    [[SBHHttp sharedInstance] postPath:urlStr withParameters:params showHud:YES success:^(id responseObj) {
        NSLog(@"setupRequestOverbooking===%@", responseObj);
        callModel.orderNum = [responseObj objectForKey:@"orderno"];
        callModel.order_id = [responseObj objectForKey:@"orderid"];
        callModel.ordertime = [responseObj objectForKey:@"ordertime"];
        BeSpeFinishController *finiVc = [[BeSpeFinishController alloc] init];
        finiVc.sourceType = (NSInteger)self.sourceType;
        finiVc.callModel = callModel;
        finiVc.carLevArray = carArray;
        [self.navigationController pushViewController:finiVc animated:YES];
    } failure:^(NSError *error) {
        
        [self requestFlase:error];
    }];
}

//乘机人的string
- (NSArray *)setupPersonParam
{
    NSMutableArray *arrayM = [NSMutableArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"passengermail"] = @"";
    dict[@"passengermobile"] = self.personModel.iMobile;
    dict[@"passengername"] = self.personModel.iName;
    dict[@"Passengerentid"] = [GlobalData getSharedInstance].userModel.entId;  // 公司id
    if (self.selPassengerModel.iName.length != 0) {
        if (![self.personModel.iName isEqualToString:self.selPassengerModel.iName]) {
            self.personModel.depid = @"0";
        }
    }
    dict[@"Passengerdepid"] = self.personModel.depid;   // 部门id
    dict[@"Passengeraccountid"] = [GlobalData getSharedInstance].userModel.AccountID;   // 部门id
    [arrayM addObject:dict];
    return arrayM;
}
@end
