//
//  BeTrainServer.m
//  sbh
//
//  Created by RobinLiu on 15/6/17.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTrainServer.h"
#import "ServerConfigure.h"
#import "SBHHttp.h"
#import "BeTrainTicketInquireItem.h"
#import "CommonMethod.h"
#import "selectPerson.h"
#import "selectContact.h"
#import "projectObj.h"
#import "BeTrainDefines.h"

@implementation BeTrainServer
- (void)getDataWithItem:(BeTrainTicketInquireItem *)item andSuccess:(void(^)(NSDictionary *))success andFailure:(void (^)(NSError *))err
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kTrainHost,kTrainSearchUrl];
    NSMutableDictionary *dict= [NSMutableDictionary dictionary];
    [dict setObject:item.fromTrainStation forKey:@"from_station_name"];
    [dict setObject:item.toTrainStation forKey:@"to_station_name"];
    [dict setObject:item.startDateStr forKey:@"train_date"];
    [dict setObject:item.toStationCode forKey:@"to_station"];
    [dict setObject:item.fromStationCode forKey:@"from_station"];
    [dict setObject:item.journeytype forKey:@"journeytype"];
    [dict setObject:item.gs forKey:@"gs"];
    [dict setObject:@"" forKey:@"guidsearch"];
    [dict setObject:item.orderKey forKey:@"order_key"];
    [dict setObject:[GlobalData getSharedInstance].token forKey:@"usertoken"];
    [[SBHHttp sharedInstance]postPath:urlString withParameters:dict showHud:YES success:^(NSDictionary *successObject)
     {
         success(successObject);
     }failure:^(NSError *error)
     {
         err(error);
     }];
}
- (void)getTrainOrderWriteData:(BeTrainBookModel *)item andSuccess:(void (^)(NSDictionary *))success andFailure:(void (^)(NSError *))err
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kTrainHost,@"Search/TrainBooking"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"guidsearch"] = item.guidSearch;
    params[@"usertoken"] = [GlobalData getSharedInstance].token;
    /*
     var DepartDate = keys.Contains("departdate") == false ? "" : ((string)obj["departdate"]).Trim();//出发日期
     var TicketPrice = keys.Contains("ticketprice") == false ? "" : ((string)obj["ticketprice"]).Trim();//预定票价
     */
    params[@"departdate"] = item.SDate;
    params[@"ticketprice"] = item.selectPrice;

    [[SBHHttp sharedInstance] postPath:urlStr withParameters:params showHud:YES success:^(id responseObj) {
        success (responseObj);
    } failure:^(NSError *error) {
        err(error);
    }];
}

- (void)commitTrainOrderWithData:(BeTrainBookModel *)item andPture:(NSString *)ptrue andSuccess:(void (^)(NSDictionary *))success andFailure:(void (^)(NSError *))error
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kTrainHost,@"Search/OrderSubmit"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ptrue"] = ptrue;
    params[@"usertoken"] = [GlobalData getSharedInstance].token;
    params[@"to_station"] = item.toStationCode;
    params[@"from_station"] = item.fromStationCode;
    params[@"to_station_name"] = item.EndCity;
    params[@"from_station_name"] = item.StartCity;
    params[@"train_date"] = item.SDate;
    params[@"journeytype"] = @"OW";
    params[@"gs"] = @"1";
    params[@"train_date_ar"] = @"";
    params[@"guidsearch"] = item.guidSearch;
    params[@"train_no"] = item.TrainCode;
    NSMutableArray *passengerArray = [NSMutableArray array];
    for(int i = 0;i < item.passengerArray.count;i++)
    {
        selectPerson * selPeron = [item.passengerArray objectAtIndex:i];
        selPeron.iGender = @"M";
        if ([selPeron.iCredtype isEqualToString:@"身份证"]||[selPeron.iCredtype isEqualToString:@"1"]) {
         selPeron.iCredtype = @"1";
         }
         else if (selPeron.iCredtype ==NULL ){
         selPeron.iCredtype = @"1";
         }
         
         else if ([selPeron.iCredtype isEqualToString:@"护照"]||[selPeron.iCredtype isEqualToString:@"2"]){
         selPeron.iCredtype = @"2";
         }
         else if ([selPeron.iCredtype isEqualToString:@"回乡证"]||[selPeron.iCredtype isEqualToString:@"3"]){
         selPeron.iCredtype = @"3";
         }
         else if ([selPeron.iCredtype isEqualToString:@"台胞证"]||[selPeron.iCredtype isEqualToString:@"4"]){
         selPeron.iCredtype = @"4";
         }
         else if ([selPeron.iCredtype isEqualToString:@"军人证"]||[selPeron.iCredtype isEqualToString:@"5"]){
         selPeron.iCredtype = @"5";
         }
         else if ([selPeron.iCredtype isEqualToString:@"警官证"]||[selPeron.iCredtype isEqualToString:@"6"]){
         selPeron.iCredtype = @"6";
         }
         else if ([selPeron.iCredtype isEqualToString:@"港澳通行证"]||[selPeron.iCredtype isEqualToString:@"7"]){
         selPeron.iCredtype = @"7";
         }
         else if ([selPeron.iCredtype isEqualToString:@"其他证件"]||[selPeron.iCredtype isEqualToString:@"8"]){
         selPeron.iCredtype = @"8";
         } else {
         selPeron.iCredtype = @"1";
         }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"id"] = [NSString stringWithFormat:@"%d",i+1];
        dict[@"type"] = @"1";
        dict[@"gender"] = selPeron.iGender;
        dict[@"name"] = selPeron.iName;
        dict[@"credtype"] = selPeron.iCredtype;
        dict[@"crednumber"] = selPeron.iCredNumber;
        dict[@"mobile"] = selPeron.iMobile;
        [passengerArray addObject:dict];
    }
    params[@"passengers"] = passengerArray;
    NSMutableArray *contactArray = [NSMutableArray array];

    for (int i = 0;i < item.contactArray.count;i++)
    {
        selectContact *conModel = [item.contactArray objectAtIndex:i];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"name"] = conModel.iName;
        NSString *mobileString = [NSString string];
        if([conModel.iMobile length] > 0)
        {
            mobileString = conModel.iMobile;
        }
        else if([conModel.iPhone length] > 0)
        {
            mobileString = conModel.iPhone;
        }
        dict[@"mobile"] = mobileString;
        dict[@"phone"] = mobileString;
        dict[@"loginname"] = conModel.LoginName;
        dict[@"pertype"] = conModel.PerType;
        dict[@"flowtype"] = conModel.FlowType;
        dict[@"email"] = conModel.iEmail;
        dict[@"index"] = [NSString stringWithFormat:@"%d",i+1];
        dict[@"returnstate"] = @"0";
        [contactArray addObject:dict];
    }
    params[@"contact"] = contactArray;
    //费用中心
    NSString *feiCenter = @"";
    
    //项目名称
    NSString *proName = @"";
    //项目编码
    NSString *proCode = @"";
    // 出行原由
    NSString *reaStr = @"";
    for (int i=0; i<[item.projectArray count]; i++)
    {
        projectObj * feicenobj = [item.projectArray objectAtIndex:i];
        if([feicenobj.projectCode isEqual:@"expensecenter"])
        {
            feiCenter = feicenobj.projectValue;
        }
        else if([feicenobj.projectCode isEqual:@"projectname"])
        {
            proName = feicenobj.projectValue;
        }
        else if([feicenobj.projectCode isEqual:@"projectcode"])
        {
            proCode = feicenobj.projectValue;
        }
        else if ([feicenobj.projectCode isEqualToString:@"reason"])
        {
            reaStr = feicenobj.projectValue;
        }
    }
    params[@"expensecenter"] = feiCenter;
    params[@"projectname"] = proName;
    params[@"projectcode"] = proCode;
    params[@"businessreasons"] = reaStr;
    
    params[@"realcode"] = item.selectSeatCode;
    params[@"realseatname"] = item.selectSeat;
    if([item.selectSeatCode isEqualToString:kWZCode])
    {
        if([[item.TrainCode lowercaseString]hasPrefix:@"g"]||[[item.TrainCode lowercaseString]hasPrefix:@"d"]||[[item.TrainCode lowercaseString]hasPrefix:@"c"])
        {
            params[@"seatcode"] = kSecondClassCode;
            params[@"seatname"] = kSecondClassCondition;
        }
        else
        {
            params[@"seatcode"] = kHardSeatCode;
            params[@"seatname"] = kHardSeatCondition;
        }
    }
    else
    {
        params[@"seatcode"] = item.selectSeatCode;
        params[@"seatname"] = item.selectSeat;
    }
    params[@"isvalidate"] = @"";
    params[@"order_key"] = @"";
    params[@"allowbook"] = @"false";
    [[SBHHttp sharedInstance] postPath:urlStr withParameters:params showHud:YES success:^(id responseObj) {
        success (responseObj);
    } failure:^(NSError *err) {
        error(err);
    }];
}
- (void)getTrainOrderStatusWith:(NSString *)orderno andSuccess:(void (^)(NSDictionary *))success andFailure:(void (^)(NSError *))error
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kTrainHost,@"Search/OrderStatus"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"orderno"] = orderno;
    parameter[@"usertoken"] = [GlobalData getSharedInstance].token;
    [[SBHHttp sharedInstance] postPath:urlStr withParameters:parameter showHud:NO success:^(id responseObj) {
        success (responseObj);
    } failure:^(NSError *err) {
        error(err);
    }];
}

- (void)payTrainOrderWith:(NSString *)orderno andSuccess:(void (^)(NSDictionary *))success andFailure:(void (^)(NSError *))error
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kTrainHost,@"Search/OrderPay"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"orderno"] = orderno;
    parameter[@"usertoken"] = [GlobalData getSharedInstance].token;
    [[SBHHttp sharedInstance] postPath:urlStr withParameters:parameter showHud:YES success:^(id responseObj) {
        success (responseObj);
    } failure:^(NSError *err) {
        error(err);
    }];
}
- (void)checkYiyangTrainOrderWith:(BeTrainBookModel *)model byCallback:(void (^)(NSDictionary *))successBack failureCallback:(void (^)(NSError *))failureCallback
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
    parameter[@"startdate"] = model.SDate;
    parameter[@"fromcity"] = model.StartCity;
    parameter[@"tocity"] = model.EndCity;
    parameter[@"sailtype"] = @"OW";
    NSMutableArray *identifyArray = [[NSMutableArray alloc]init];
    for(selectPerson *personModel in model.passengerArray)
    {
        [identifyArray addObject:personModel.iCredNumber];
    }
    parameter[@"identity"] = [identifyArray componentsJoinedByString:@","];
    
    double Insure = [model.selectPrice doubleValue] + [model.servicemoney doubleValue];
    double priceDouble = Insure * [model.passengerArray count];
    int priceInt = (int)priceDouble;
    NSString *priceMoney = nil;
    if (priceDouble == priceInt) {
        priceMoney = [NSString stringWithFormat:@"￥%d", priceInt];
    } else {
        priceMoney = [NSString stringWithFormat:@"￥%.2f", priceDouble];
    }
    parameter[@"money"] = priceMoney;
    parameter[@"types"] = @"H";
    parameter[@"usertoken"] = [GlobalData getSharedInstance].token;
    
    [[SBHHttp sharedInstance]postPath:[NSString stringWithFormat:@"%@Enterprise/YiYangChecked",kServerHost] withParameters:parameter showHud:NO success:^(NSDictionary *callback)
     {
         successBack(callback);
     }failure:^(NSError *error)
     {
         failureCallback(error);
     }];
}
@end
