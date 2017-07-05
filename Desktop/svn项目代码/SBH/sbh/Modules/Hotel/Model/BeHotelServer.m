//
//  BeHotelServer.m
//  SideBenefit
//
//  Created by RobinLiu on 15/3/14.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelServer.h"
#import "ServerConfigure.h"
#import "NSDate+WQCalendarLogic.h"
#import "SBHHttp.h"
#import "CityData.h"
#import "BeBrandModel.h"
#import "BeHotelConditionHeader.h"
#import "BePriceListModel.h"
#import "selectContact.h"
#import "BePriceListModel.h"

#define kHotelServerHost @"http://192.168.40.194:8088/"
@implementation BeHotelServer

- (void)doGetHotelListWith:(BeHotelListRequestModel *)object andCallback:(void (^)(NSMutableDictionary *))callback failureCallback:(void (^)(NSString *))failureCallback
{
    /*
     "orderby”:”1”,//
     "orderbymode”:”0”,//
     "hasisstop":"false”,//
     "facilitys":"0",
     "plantype":"0",
     
     "checkdate":"2015-12-07",
     "checkoutdate":"2015-12-08",
     "usertoken":"2687cf10377f462b93c0237454a65bb5",
     "pagesize":"10",
     "pagecount”:”1”,// “”
     "pageindex”:”1”,//
     "totals":"10”// “”
     */
    NSMutableDictionary *objectDict = [self getParameterWith:object];
    [objectDict setObject:object.totals forKey:@"totals"];
    [objectDict setObject:@"20" forKey:@"pagesize"];
    [objectDict setObject:object.pageCount forKey:@"pagecount"];
    [objectDict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)object.pagenum] forKey:@"pageindex"];
    
    NSString *urlStr =[NSString stringWithFormat:@"%@%@",kServerHost,kHotelListUrl];
   [[SBHHttp sharedInstance]postPath:urlStr withParameters:objectDict showHud:YES success:^ (id responseObject)
    {
        NSMutableDictionary *callbackDict = [[NSMutableDictionary alloc]initWithDictionary:(NSDictionary *)responseObject];
        ((void(^)(NSMutableDictionary*))callback)(callbackDict);
    }
    failure:^(NSError *error)
    {
        failureCallback(@"失败");
    }];
}
- (void)getHotelDetailWith:(BeHotelListItem *)object andFlag:(NSString *)flag byCallback:(void (^)(NSMutableDictionary *))callback failureCallback:(void (^)(NSString *))failureCallback
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:flag forKey:@"flag"];
    [parameter setObject:[GlobalData getSharedInstance].token forKey:@"usertoken"];
    [parameter setObject:object.cityId forKey:@"citycode"];
    [parameter setObject:object.cityName forKey:@"cityname"];
    [parameter setObject:object.CheckOutDate forKey:@"checkoutdate"];
    [parameter setObject:object.CheckInDate forKey:@"checkdate"];
    [parameter setObject:object.hotelId forKey:@"HotelId"];

    [parameter setObject:@"" forKey:@"keyword"];
    [parameter setObject:@"" forKey:@"discode"];
    [parameter setObject:@"" forKey:@"zonecode"];
    [parameter setObject:@"1" forKey:@"pagecount"];
    [parameter setObject:@"0" forKey:@"totals"];

    [parameter setObject:@"" forKey:@"price"];
    [parameter setObject:@"" forKey:@"stars"];
    [parameter setObject:@"0" forKey:@"orderby"];
    [parameter setObject:@"0" forKey:@"orderbymode"];
    [parameter setObject:@"" forKey:@"facilitys"];
    [parameter setObject:@"false" forKey:@"hasisstop"];
    [parameter setObject:@"0" forKey:@"plantype"];
    [parameter setObject:@"" forKey:@"brand"];
    [parameter setObject:@"1" forKey:@"traveltype"];
    NSString *urlStr =[NSString stringWithFormat:@"%@HotelNew/GetHotelDetail",kServerHost];
    [[SBHHttp sharedInstance]postPath:urlStr withParameters:parameter showHud:YES success:^ (id responseObject)
     {
         NSMutableDictionary *callbackDict = [[NSMutableDictionary alloc]initWithDictionary:(NSDictionary *)responseObject];
         ((void(^)(NSMutableDictionary*))callback)(callbackDict);
     }
    failure:^(NSError *error)
     {
         failureCallback(@"失败");
     }];
}
- (NSMutableDictionary *)getParameterWith:(BeHotelListRequestModel *)model
{
    NSMutableDictionary *objectDict = [[NSMutableDictionary alloc]init];
    [objectDict setObject:[GlobalData getSharedInstance].token forKey:@"usertoken"];
    [objectDict setObject:model.cityItem.cityId forKey:@"citycode"];
    [objectDict setObject:model.cityItem.iCityName forKey:@"cityname"];
    [objectDict setObject:model.keyName forKey:@"keyword"];
    
    NSString *discode = @"";
    for(id member in model.districtArray)
    {
        if([member isKindOfClass:[NSString class]])
        {
            discode = @"";
            break;
        }
        else if ([member isKindOfClass:[CityData class]])
        {
            CityData *model = (CityData *)member;
            discode = [discode stringByAppendingString:model.districtId];
        }
        if(![member isEqual:[model.districtArray lastObject]])
        {
            discode = [discode stringByAppendingString:@","];
        }
    }
    [objectDict setObject:discode forKey:@"discode"];
    
    
    NSString *zonecode = @"";
    for(id member in model.bussinessArray)
    {
        if([member isKindOfClass:[NSString class]])
        {
            zonecode = @"";
            break;
        }
        else if ([member isKindOfClass:[CityData class]])
        {
            CityData *model = (CityData *)member;
            zonecode = [zonecode stringByAppendingString:model.businessId];
        }
        if(![member isEqual:[model.bussinessArray lastObject]])
        {
            zonecode = [zonecode stringByAppendingString:@","];
        }
    }
    [objectDict setObject:zonecode forKey:@"zonecode"];
    
    NSString *brand = @"";
    for(id member in model.brandArray)
    {
        if([member isKindOfClass:[NSString class]])
        {
            brand = @"";
            break;
        }
        else if ([member isKindOfClass:[BeBrandModel class]])
        {
            BeBrandModel *model = (BeBrandModel *)member;
            brand = [brand stringByAppendingString:model.brandCode];
        }
        if(![member isEqual:[model.brandArray lastObject]])
        {
            brand = [brand stringByAppendingString:@","];
        }
    }
    [objectDict setObject:brand forKey:@"brand"];
    
    
    if([model.reason isEqualToString:kTravelReasonOnBussinessText])
    {
        [objectDict setObject:@"1" forKey:@"traveltype"];
    }
    else
    {
        [objectDict setObject:@"0" forKey:@"traveltype"];
    }
    
    NSString *price = @"";
    NSString *tempString = @"";
    for(NSString *member in model.priceArrayCondition)
    {
        if([member isEqualToString:KUnlimitedTitle])
        {
            price = @"";
            break;
        }
        else if ([member isEqualToString:kMoreThanSixHundred])
        {
            //@"￥600以上"
            tempString = @"600";
        }
        else if ([member isEqualToString:kFourHundredToSixHundred])
        {
            //@"￥401-600"
            tempString = @"401-600";
        }
        else if ([member isEqualToString:kTwoHundredToFourHundred])
        {
            //@"￥201-400"
            tempString = @"201-400";
        }
        else if ([member isEqualToString:kLessThanTwoHundred])
        {
            //@"￥0-200"
            tempString = @"0-200";
        }
        price = [price stringByAppendingString:tempString];
        if(![member isEqual:[model.priceArrayCondition lastObject]])
        {
            price = [price stringByAppendingString:@","];
        }
    }
    [objectDict setObject:price forKey:@"price"];
    
    NSString *star = @"";
    for(NSString *member in model.starArrayCondition)
    {
        if([member isEqualToString:KUnlimitedTitle])
        {
            star = @"";
            break;
        }
        else if ([member isEqualToString:kLuxuryTitle])
        {
            //五星/豪华
            tempString = @"5";
        }
        else if ([member isEqualToString:kTopGradeTitle])
        {
            //四星/高档"
            tempString = @"4";
        }
        else if ([member isEqualToString:kComfortTitle])
        {
            //@"三星/舒适"
            tempString = @"3";
        }
        else if ([member isEqualToString:kEconomyTitle])
        {
            //@"二星及以下/经济"
            tempString = @"1,2";
        }
        star = [star stringByAppendingString:tempString];
        if(![member isEqual:[model.starArrayCondition lastObject]])
        {
            star = [star stringByAppendingString:@","];
        }
    }
    [objectDict setObject:star forKey:@"stars"];
    
    /*
     /// 默认无
     none = 0,
     /// 好评
     good = 1,
     /// 价格
     price = 2,
     /// 星级
     star = 3,
     /// 品牌
     Brand = 4
     */
    /*
     "orderby":"1",// 0 正序 1 倒序
     "orderbymode":"0",
     */
/*#define kSourtDistanceCondition     @"距离          近→远"
#define kPriceAscCondition          @"价格          低→高"
#define kPriceDescCondition         @"价格          高→低"
#define kStarAscCondition           @"星级          低→高"
#define kStarDescCondition          @"星级          高→低"
#define kScoreDescCondition         @"评分          高→低"*/
    if(model.sortCondition.length < 1)
    {
        [objectDict setObject:@"0" forKey:@"orderbymode"];
        [objectDict setObject:@"0" forKey:@"orderby"];
    }
    else if([model.sortCondition isEqualToString:kSourtDistanceCondition])
    {
        [objectDict setObject:@"0" forKey:@"orderbymode"];// 0 正序 1 倒序
        [objectDict setObject:@"0" forKey:@"orderby"];
    }
    else if([model.sortCondition isEqualToString:kPriceAscCondition])
    {
        [objectDict setObject:@"0" forKey:@"orderbymode"];// 0 正序 1 倒序
        [objectDict setObject:@"2" forKey:@"orderby"];
    }
    else if([model.sortCondition isEqualToString:kPriceDescCondition])
    {
        [objectDict setObject:@"1" forKey:@"orderbymode"];// 0 正序 1 倒序
        [objectDict setObject:@"2" forKey:@"orderby"];
    }
    else if([model.sortCondition isEqualToString:kStarAscCondition])
    {
        [objectDict setObject:@"0" forKey:@"orderbymode"];// 0 正序 1 倒序
        [objectDict setObject:@"3" forKey:@"orderby"];
    }
    else if([model.sortCondition isEqualToString:kStarDescCondition])
    {
        [objectDict setObject:@"1" forKey:@"orderbymode"];// 0 正序 1 倒序
        [objectDict setObject:@"3" forKey:@"orderby"];
    }
    else if([model.sortCondition isEqualToString:kScoreDescCondition])
    {
        [objectDict setObject:@"1" forKey:@"orderbymode"];// 0 正序 1 倒序
        [objectDict setObject:@"1" forKey:@"orderby"];
    }
    else
    {
        [objectDict setObject:@"0" forKey:@"orderbymode"];
        [objectDict setObject:@"0" forKey:@"orderby"];
    }
    
    
    if (model.facilityArray.count < 1) {
        [objectDict setObject:@"0"forKey:@"facilitys"];
    }
    else if ([model.facilityArray containsObject:KUnlimitedTitle])
    {
        [objectDict setObject:@"0"forKey:@"facilitys"];
    }
    else
    {
        NSString *facilitysValue = @"";
        for(NSString *member in model.facilityArray)
        {
            if([member isEqualToString:kFacilityCondition1])
            {
                facilitysValue = [facilitysValue stringByAppendingString:@"1"];
                facilitysValue = [facilitysValue stringByAppendingString:@","];
            }
            if([member isEqualToString:kFacilityCondition2])
            {
                facilitysValue = [facilitysValue stringByAppendingString:@"2"];
                facilitysValue = [facilitysValue stringByAppendingString:@","];
            }
            if([member isEqualToString:kFacilityCondition3])
            {
                facilitysValue = [facilitysValue stringByAppendingString:@"3"];
                facilitysValue = [facilitysValue stringByAppendingString:@","];
            }
            if([member isEqualToString:kFacilityCondition4])
            {
                facilitysValue = [facilitysValue stringByAppendingString:@"4"];
                facilitysValue = [facilitysValue stringByAppendingString:@","];
            }
            if([member isEqualToString:kFacilityCondition5])
            {
                facilitysValue = [facilitysValue stringByAppendingString:@"5"];
                facilitysValue = [facilitysValue stringByAppendingString:@","];
            }
        }
        NSMutableString *faci = [NSMutableString stringWithString:facilitysValue];
        [faci deleteCharactersInRange:NSMakeRange([facilitysValue length]-1, 1)];
        [objectDict setObject:faci forKey:@"facilitys"];
    }
    [objectDict setObject:@"0"forKey:@"plantype"];
    [objectDict setObject:@"false" forKey:@"hasisstop"];
    [objectDict setObject:[model.edate stringFromDate:model.edate] forKey:@"checkoutdate"];
    [objectDict setObject:[model.sdate stringFromDate:model.sdate] forKey:@"checkdate"];
    return objectDict;
}
- (void)getHotelOrderPriceListWith:(BeHotelOrderWriteModel *)writeModel byCallback:(void (^)(NSDictionary *))successBack failureCallback:(void (^)(NSError *))failureCallback
{
    [[SBHHttp sharedInstance]postPath:[NSString stringWithFormat:@"%@HotelNew/GetRoomPrices",kServerHost] withParameters:@{@"Id": writeModel.RatePlanInfoId,@"CheckInDate": writeModel.CheckInDate,@"CheckOutDate":writeModel.CheckOutDate,@"usertoken": [GlobalData getSharedInstance].token,@"City_Code":writeModel.City_Code} showHud:YES success:^(NSDictionary *callback)
     {
         successBack(callback);
     }failure:^(NSError *error)
     {
         failureCallback(error);
     }];

}
- (void)commitOrderWith:(BeHotelOrderWriteModel *)model byCallback:(void (^)(NSDictionary *))successBack failureCallback:(void (^)(NSError *))failureCallback
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"flag"] = model.flag;
    parameter[@"usertoken"] = [GlobalData getSharedInstance].token;
    parameter[@"City_Code"] = model.City_Code;
    parameter[@"Id"] = model.RatePlanInfoId;
    parameter[@"flag"] = model.flag;
    parameter[@"isExceed"] = model.isExceed;
    parameter[@"VerifypriceID"] = model.VerifypriceID;
    //todo "isExceed":"0",//首次提交判断超标0 首次提交 1原因提交
    NSMutableDictionary *SubmitOrder = [NSMutableDictionary dictionary];
    NSMutableDictionary *Order = [NSMutableDictionary dictionary];
    Order[@"HotelId"] = model.HotelId;
    Order[@"HotelName"] = model.HotelName;
    Order[@"StarRate"] = model.StarRate;
    Order[@"Category"] = model.Category;
    Order[@"GsType"] = model.GsType;
    Order[@"RoomName"] = model.RoomName;
    Order[@"CityName"] = model.CityName;
    Order[@"Address"] = model.Address;
    Order[@"RoomCount"] = model.RoomCount;
    Order[@"PayType"] = model.PayType;
    Order[@"PayMethod"] = model.PayMethod;
    Order[@"ServiceFee"] = model.ServiceFee;
    Order[@"AddBreakfastFee"] = model.AddBreakfastFee;
    Order[@"AddBedFee"] = model.AddBedFee;
    Order[@"BroadbandFee"] = model.BroadbandFee;
    Order[@"OtherFee"] = model.OtherFee;
    Order[@"OrderNote"] = model.OrderNote;
    Order[@"CheckInDate"] = model.CheckInDate;
    Order[@"CheckOutDate"] = model.CheckOutDate;
    Order[@"PolicyRemark"] = model.PolicyRemark;
    Order[@"PolicyName"] = model.PolicyName;
    Order[@"ReservedTime"] = model.ReservedTime;
    Order[@"ExpenseCenter"] = model.ExpenseCenter;
    Order[@"ProjectName"] = model.ProjectName;
    Order[@"ProjectCode"] = model.ProjectCode;
    Order[@"BusinessReasons"] = model.BusinessReasons;
    Order[@"PolicyReason"] = model.PolicyReason;
    double totalPrice = 0;
    double discount = 0;
    double totalPrice2 = 0;
    for(BePriceListModel *prModel in model.priceArray)
    {
        totalPrice = totalPrice + (int)model.Persons.count * [prModel.SalePrice doubleValue];
        discount = discount + (int)model.Persons.count * [prModel.Dr_MinPrice doubleValue];
    }
    totalPrice2 = totalPrice - discount;
    Order[@"allPrice"] = [NSString stringWithFormat:@"%.2f",totalPrice2];
    //"PolicyReason":"" //差旅政策超标原因

    int i = 0;
    NSMutableArray *PersonsArray = [NSMutableArray array];
    for(selectPerson *personModel in model.Persons)
    {
        if(personModel.iCredNumber.length < 1 || personModel.iCredNumber == nil)
        {
            personModel.iCredNumber = @"";
        }
        if(personModel.iMobile.length < 1 || personModel.iMobile == nil)
        {
            personModel.iMobile = @"";
        }
        
        if([personModel.iGender isEqualToString:@"男"]||[personModel.iGender isEqualToString:@"1"]||[personModel.iGender isEqualToString:@"M"])
        {
            personModel.iGender = @"1";
        }
        else
        {
            personModel.iGender = @"0";
        }
        if ([personModel.iCredtype isEqualToString:@"身份证"]||[personModel.iCredtype isEqualToString:@"1"]) {
            personModel.iCredtype = @"1";
        }
        else if (personModel.iCredtype ==NULL ){
            personModel.iCredtype = @"1";
        }
        
        else if ([personModel.iCredtype isEqualToString:@"护照"]||[personModel.iCredtype isEqualToString:@"2"]){
            personModel.iCredtype = @"2";
        }
        else if ([personModel.iCredtype isEqualToString:@"回乡证"]||[personModel.iCredtype isEqualToString:@"3"]){
            personModel.iCredtype = @"3";
        }
        else if ([personModel.iCredtype isEqualToString:@"台胞证"]||[personModel.iCredtype isEqualToString:@"4"]){
            personModel.iCredtype = @"4";
        }
        else if ([personModel.iCredtype isEqualToString:@"军人证"]||[personModel.iCredtype isEqualToString:@"5"]){
            personModel.iCredtype = @"5";
        }
        else if ([personModel.iCredtype isEqualToString:@"警官证"]||[personModel.iCredtype isEqualToString:@"6"]){
            personModel.iCredtype = @"6";
        }
        else if ([personModel.iCredtype isEqualToString:@"港澳通行证"]||[personModel.iCredtype isEqualToString:@"7"]){
            personModel.iCredtype = @"7";
        }
        else if ([personModel.iCredtype isEqualToString:@"其他证件"]||[personModel.iCredtype isEqualToString:@"8"]){
            personModel.iCredtype = @"8";
        } else {
            personModel.iCredtype = @"1";
        }
        
        NSMutableDictionary *personDict = [NSMutableDictionary dictionary];
        //todo "pid":"",//有值传员工id没值传0

        personDict[@"Name"] = personModel.iName;
        personDict[@"Gender"] = personModel.iGender;
        personDict[@"Mobile"] = personModel.iMobile;
        personDict[@"Email"] = @"";
        personDict[@"CardNo"] = personModel.iCredNumber;
        personDict[@"StopService"] = @"0";
        personDict[@"CardType"] = personModel.iCredtype;
        personDict[@"RoomNum"] = [NSString stringWithFormat:@"%d",i+1];
        [PersonsArray addObject:personDict];
        i++;
    }
    
    NSMutableArray *ContactArray = [NSMutableArray array];
    for(selectContact *contactModel in model.Contacts)
    {
        NSMutableDictionary *personDict = [NSMutableDictionary dictionary];
        personDict[@"Name"] = contactModel.iName;
        personDict[@"Mobile"] = contactModel.iMobile;
        personDict[@"Email"] = @"";
        personDict[@"NoticeMsg"] = @"1";
        personDict[@"NoticeEmail"] = @"0";
        personDict[@"belongfunction"] = contactModel.belongfunction;
        [ContactArray addObject:personDict];
    }
   // NSDictionary *Ticket = @{@"IsNeedTicket": @"0",@"SendType": @"0",@"TicketType":@"0",@"TicketHead":@"",@"ReceiveName": @"",@"Mobile":@"",@"Address":@"",@"KdFee":@""};
   // SubmitOrder[@"Ticket"] = Ticket; 这一期不需要发票
    
    SubmitOrder[@"Order"] = Order;
    SubmitOrder[@"Persons"] = PersonsArray;
    SubmitOrder[@"Contacts"] = ContactArray;
    parameter[@"SubmitOrder"] = SubmitOrder;
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:&error];
    NSMutableString *packageString = [[NSMutableString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"下单参数=||%@",packageString);
    
    [[SBHHttp sharedInstance]postPath:[NSString stringWithFormat:@"%@HotelNew/OrderSubmit",kServerHost] withParameters:parameter showHud:YES success:^(NSDictionary *callback)
     {
         successBack(callback);
     }failure:^(NSError *error)
     {
         failureCallback(error);
     }];
    
   /*
    结果;{
        "status": "true",
        "code": "20027",
        "orderNo": "H1512091491113",
        "totalPrices": 6077.0,
        "pricesList": [
                       {
                           "SalePrice": 1889.0,
                           "RoomDate": "2015-12-09T00:00:00"
                       },
                       {
                           "SalePrice": 1889.0,
                           "RoomDate": "2015-12-10T00:00:00"
                       },
                       {
                           "SalePrice": 1889.0,
                           "RoomDate": "2015-12-11T00:00:00"
                       }
                       ]
    }
   */
}
- (void)checkYiyangOrderWith:(BeHotelOrderWriteModel *)model byCallback:(void (^)(NSDictionary *))successBack failureCallback:(void (^)(NSError *))failureCallback
{
    /*
     string startDate = keys.Contains("startdate") == false ? "" : ((string)obj["startdate"]).Trim();//出发时间
     string fromCity = keys.Contains("fromcity") == false ? "" : ((string)obj["fromcity"]).Trim();//出发地
     string toCity = keys.Contains("tocity") == false ? "" : ((string)obj["tocity"]).Trim();//目的地
     string sailType = keys.Contains("sailtype") == false ? "" : ((string)obj["sailtype"]).Trim();//单程OW往返RT
     string identity = keys.Contains("identity") == false ? "" : ((string)obj["identity"]).Trim();//证件号 多个逗号隔开
     string money = keys.Contains("money") == false ? "" : ((string)obj["money"]).Trim();//订票金额
     string types = keys.Contains("types") == false ? "" : ((string)obj["types"]).Trim();//订票类型【F-飞机票，H-火车票，C-出租车，Q-签证费，G-酒店】
     string platform = keys.Contains("platform") == false ? "" : ((string)obj["platform"]).Trim();
     */
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"startdate"] = model.CheckInDate;
    parameter[@"fromcity"] = model.CityName;
    parameter[@"tocity"] = model.CityName;
    parameter[@"sailtype"] = @"OW";
    NSMutableArray *identifyArray = [[NSMutableArray alloc]init];
    for(selectPerson *personModel in model.Persons)
    {
        [identifyArray addObject:personModel.iCredNumber];
    }
    parameter[@"identity"] = [identifyArray componentsJoinedByString:@","];
    
    double totalPrice = 0;
    double discount = 0;
    double totalPrice2 = 0;
    
    for(BePriceListModel *prModel in model.priceArray)
    {
        totalPrice = totalPrice + (int)model.Persons.count * [prModel.SalePrice doubleValue];
        discount = discount + (int)model.Persons.count * [prModel.Dr_MinPrice doubleValue];
    }
    totalPrice2 = totalPrice - discount;
    parameter[@"money"] = [NSString stringWithFormat:@"￥%.2lf",totalPrice2];
    parameter[@"types"] = @"G";
    parameter[@"usertoken"] = [GlobalData getSharedInstance].token;

    [[SBHHttp sharedInstance]postPath:[NSString stringWithFormat:@"%@Enterprise/YiYangChecked",kServerHost] withParameters:parameter showHud:NO success:^(NSDictionary *callback)
     {
         successBack(callback);
     }failure:^(NSError *error)
     {
         failureCallback(error);
     }];
}
- (void)confirmOrderWith:(BeHotelOrderWriteModel *)orderModel byCallback:(void (^)(NSDictionary *))successBack failureCallback:(void (^)(NSError *))failureCallback
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"orderNo"] = orderModel.orderNo;
    parameter[@"usertoken"] = [GlobalData getSharedInstance].token;
    NSString *orderstatus = @"101";
    if([orderModel.errorNo intValue] == 2999)
    {
        orderstatus = @"200";
    }
    parameter[@"orderstatus"] = orderstatus;
    [[SBHHttp sharedInstance]postPath:[NSString stringWithFormat:@"%@HotelNew/ConfirmOrder",kServerHost] withParameters:parameter showHud:NO success:^(NSDictionary *callback)
     {
         successBack(callback);
     }failure:^(NSError *error)
     {
         failureCallback(error);
     }];
    /*
     订单确认
     地址:http://localhost:2900/HotelNew/ConfirmOrder
     参数:
     {
     "usertoken": "93052ae4f94a41e78cfff61ef41f5460",
     "orderNo":"H1512101091122"
     }
     结果:
     {
     "status": "false",
     "code": "20020",
     "msg": "提交成功"
     }
     */
}
- (void)getNearByHotelWith:(BeHotelListItem *)model byCallback:(void (^)(NSMutableArray *))successBack failureCallback:(void (^)(NSError *))failureCallback
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"hotelid"] = model.hotelId;
    parameter[@"checkindate"] = model.CheckInDate;
    parameter[@"checkoutdate"] = model.CheckOutDate;
    parameter[@"usertoken"] = [GlobalData getSharedInstance].token;
    [[SBHHttp sharedInstance]postPath:[NSString stringWithFormat:@"%@HotelNew/NearbyHotelID",kServerHost] withParameters:parameter showHud:NO success:^(NSDictionary *callback)
     {
         NSMutableArray *callbackArray = [NSMutableArray array];
         if([[callback dictValueForKey:@"hotellist"] allKeys].count > 0)
         {
             if([[[callback dictValueForKey:@"hotellist"]arrayValueForKey:@"BackInfo"] count]> 0)
             {
                 for(NSDictionary *member in [[callback dictValueForKey:@"hotellist"]arrayValueForKey:@"BackInfo"])
                 {
                     BeHotelListItem *item = [[BeHotelListItem alloc]init];
                     [item setItemWithDict:member];
                     item.price = [member stringValueForKey:@"Dr_Amount"];
                     item.hotelImageUrl = [member stringValueForKey:@"Image_Path" defaultValue:@""];
                     item.TravelType = [model.TravelType mutableCopy];
                     item.cityId = [model.cityId mutableCopy];

                     [callbackArray addObject:item];
                 }
             }
         }
         successBack(callbackArray);
         
     }failure:^(NSError *error)
     {
         failureCallback(error);
     }];
}
- (void)searchHotelWith:(NSString *)cityCode andKeyword:(NSString *)keyword byCallback:(void (^)(NSMutableArray *))successBack failureCallback:(void (^)(NSError *))failureCallback
{
    /*
     HotelNew/KeySearch 关键字
     // 城市编码
     string City_Code = keys.Contains("citycode") == false ? "" : ((string)obj["citycode"]).Trim();
     // 关键词
     string KeyWord = keys.Contains("keyword") == false ? "" : ((string)obj["keyword"]).Trim();
     
     */
    /*
     关键字接口 返回值     1   名称    2   商圈    3  品牌
     */
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"citycode"] = cityCode;
    parameter[@"keyword"] = keyword;
    parameter[@"usertoken"] = [GlobalData getSharedInstance].token;
    [[SBHHttp sharedInstance]postPath:[NSString stringWithFormat:@"%@HotelNew/KeySearch",kServerHost] withParameters:parameter showHud:NO success:^(NSDictionary *callback)
     {
         /*
          {
          status = true,
          keylist = {
          ErrorNo = 1,
          ErrorMsg = <null>,
          BackInfo = [
          {
          SearchID = 1000010001490,
          SearchContent = 北京加码主题酒店,
          SearchType = 1,
          Key = 1_1000010001490
          },
          ]
          },
          code = 20020
          }
          */
         NSMutableArray *callbackArray = [NSMutableArray array];
         if([[callback dictValueForKey:@"keylist"] allKeys].count > 0)
         {
             if([[[callback dictValueForKey:@"keylist"]arrayValueForKey:@"BackInfo"] count]> 0)
             {
                 for(NSDictionary *member in [[callback dictValueForKey:@"keylist"]arrayValueForKey:@"BackInfo"])
                 {
                     BeHotelListItem *item = [[BeHotelListItem alloc]init];
                     item.hotelId = [member stringValueForKey:@"SearchID"];
                     item.hotelName = [member stringValueForKey:@"SearchContent"];
                     item.SearchType = [member stringValueForKey:@"SearchType" defaultValue:@""];
                     [callbackArray addObject:item];
                 }
             }
         }
         successBack(callbackArray);
     }failure:^(NSError *error)
     {
         failureCallback(error);
     }];
}
- (void)getHotelAuditWith:(BeHotelOrderWriteModel *)model byCallback:(void (^)(NSDictionary *))successBack failureCallback:(void (^)(NSError *))failureCallback
{
    /*
     HotelAudit/GetHotelAudit
     var OrderNo = keys.Contains("OrderNo") == false ? "" : ((string)obj["OrderNo"]).Trim();
     var isExceed = keys.Contains("isExceed") == false ? "0" : ((string)obj["isExceed"]).Trim();//是否超标0不超1超标
     var TicketId = keys.Contains("ticketid") == false ? "" : ((string)obj["ticketid"]).Trim();//审批唯一标识如果有值使用此值，无值新建值
     */
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"OrderNo"] = model.orderNo;
    parameter[@"isExceed"] = model.isExceed;
    if(model.TicketId.length > 0)
    {
        parameter[@"ticketid"] = model.TicketId;
    }
    else
    {
        parameter[@"ticketid"] = @"";
    }
    parameter[@"usertoken"] = [GlobalData getSharedInstance].token;
    parameter[@"paytype"] = model.PayType;
    NSString *orderstatus = @"101";
    if([model.errorNo intValue] == 2999)
    {
        orderstatus = @"200";
    }
    parameter[@"orderstatus"] = orderstatus;
    NSMutableArray *passengers = [NSMutableArray array];
    for(selectPerson *passModel in model.Persons)
    {
         [passengers addObject:@{@"name":passModel.iName,@"mobile":passModel.iMobile,@"email":@""}];
    }
    parameter[@"TripMans"] = passengers;
    [[SBHHttp sharedInstance]postPath:[NSString stringWithFormat:@"%@HotelNew/HotelAudit/GetHotelAudit",kServerHost] withParameters:parameter showHud:NO success:^(NSDictionary *callback)
     {         
         successBack(callback);
     }failure:^(NSError *error)
     {
         failureCallback(error);
     }];

}
@end
