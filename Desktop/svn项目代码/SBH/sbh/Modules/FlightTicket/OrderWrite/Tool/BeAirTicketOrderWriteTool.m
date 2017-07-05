//
//  BeAirTicketOrderWriteTool.m
//  sbh
//
//  Created by RobinLiu on 15/11/13.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BeAirTicketOrderWriteTool.h"
#import "ServerFactory.h"

#import "SBHHttp.h"
#import "JSONKit.h"
#import "selectContact.h"
#import "projectObj.h"
#import "BeRegularExpressionUtil.h"
#import "BePassengerModel.h"
#define kTicketKey @"ticketKey"
#define kContactKey @"contactKey"
#define kErrorKey @"errorKey"

@implementation BeAirTicketOrderWriteTool
- (void)getOrderWriteDataBySuccess:(void (^)(NSDictionary *))callback failure:(void (^)(NSError *))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"Order/FlightCommit"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"usertoken"] = [GlobalData getSharedInstance].token;
    params[@"airlinetype"] = [GlobalData getSharedInstance].iSdancheng;
    params[@"depairport"] = [GlobalData getSharedInstance].iTiketOrderInfo.iFromAirportCode;
    params[@"arrairport"] = [GlobalData getSharedInstance].iTiketOrderInfo.iToAirportCode;
    params[@"aircarrier"] = [GlobalData getSharedInstance].iTiketOrderInfo.iAirCompanyCode;
    
    params[@"depairdate"] = [GlobalData getSharedInstance].iTiketOrderInfo.iStartTime;
    params[@"arrairdate"] = [GlobalData getSharedInstance].airReachTime;
    params[@"classrating"] = [GlobalData getSharedInstance].iTiketOrderInfo.iShippingspace;
    
    params[@"flightno"] = [GlobalData getSharedInstance].FLIGHTNORT;
    params[@"guid"] = [GlobalData getSharedInstance].GOW;
    params[@"flightnort"] = [GlobalData getSharedInstance].FLIGHTNORTt;
    params[@"guidrt"] = [GlobalData getSharedInstance].GOWw;
    params[@"op"] = [NSString stringWithFormat:@"%ld", (long)[GlobalData getSharedInstance].iTiketOrderInfo.travelReason];
    params[@"gow"] = [GlobalData getSharedInstance].UDID;
    params[@"grt"] = [GlobalData getSharedInstance].UDIDd;
    params[@"pow"] = [GlobalData getSharedInstance].POW;
    params[@"prt"] = [GlobalData getSharedInstance].POWw;
    params[@"expensecenter"] = @"";
    params[@"projectname"] = @"";
    params[@"projectcode"] = @"";
    [[SBHHttp sharedInstance] postPath:urlStr withParameters:params showHud:YES success:^(id responseObj)
    {
        callback(responseObj);
    }failure:^(NSError *error)
     {
         failure(error);
     }];
}
- (void)getOrderWriteContactListBySuccess:(void (^)(NSArray *contactList,NSString *belongfunction))callback failure:(void (^)(NSString *))failure
{
    NSMutableArray *companyContactArray = [NSMutableArray array];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"Order/OrderContactList"];
    [[ServerFactory getServerInstance:@"SBHHttp"]postPath:urlStr withParameters:@{} showHud:NO success:^(NSDictionary *dictOriginal)
     {
         NSLog(@"获取联系人 = %@",dictOriginal);
         NSString *status = [dictOriginal objectForKey:@"status"];
         //NSString *belongfunction = [dictOriginal objectForKey:@"belongfunction"];
         NSString *belongfunction = [[NSString alloc]init];
         if ([status isEqualToString:@"true"]) {
             
             NSArray * tmpArr = [[dictOriginal objectForKey:@"ordercontactlist"] objectForKey:@"contactcom"];
             if ([tmpArr isKindOfClass:[NSArray class]]) {
                 for (int i =0; i<[tmpArr count]; i++)
                 {
                     NSDictionary * itemDic = [tmpArr objectAtIndex:i];
                     selectContact * aselContact = [[selectContact alloc] init];
                     aselContact.iName = [itemDic objectForKey:@"contactsname"];
                     aselContact.iEmail= [itemDic objectForKey:@"contactsemail"];
                     aselContact.iPhone= [itemDic objectForKey:@"contactstel"];
                     aselContact.iMobile=[itemDic objectForKey:@"contactsphone"];
                     aselContact.contactsloginname = [itemDic objectForKey:@"contactsloginname"];
                     aselContact.belongfunction = [itemDic stringValueForKey:@"belongfunction" defaultValue:@""];
                     [companyContactArray addObject:aselContact];
                 }
             }
             id tmpArr1 = [[dictOriginal objectForKey:@"ordercontactlist"] objectForKey:@"contactdep"];
             
             if ([tmpArr1 isKindOfClass:[NSArray class]]) {
                 for (int i =0; i<[tmpArr1 count]; i++)
                 {
                     NSDictionary * itemDic = [tmpArr1 objectAtIndex:i];
                     selectContact * aselContact = [[selectContact alloc] init];
                     aselContact.iName = [itemDic objectForKey:@"contactsname"];
                     aselContact.iEmail= [itemDic objectForKey:@"contactsemail"];
                     aselContact.iPhone= [itemDic objectForKey:@"contactstel"];
                     aselContact.iMobile=[itemDic objectForKey:@"contactsphone"];
                     aselContact.contactsloginname = [itemDic objectForKey:@"contactsloginname"];
                     aselContact.belongfunction = [itemDic stringValueForKey:@"belongfunction" defaultValue:@""];
                     [companyContactArray addObject:aselContact];
                 }
             }
             
             id tmpArr2 = [[dictOriginal objectForKey:@"ordercontactlist"] objectForKey:@"contactoth"];
             
             if ([tmpArr2 isKindOfClass:[NSArray class]]) {
                 for (int i =0; i<[tmpArr2 count]; i++)
                 {
                     NSDictionary * itemDic = [tmpArr2 objectAtIndex:i];
                     selectContact * aselContact = [[selectContact alloc] init];
                     aselContact.iName = [itemDic objectForKey:@"pername"];
                     aselContact.iEmail= [itemDic objectForKey:@"perphone"];
                     aselContact.iPhone= [itemDic objectForKey:@"pertel"];
                     aselContact.iMobile=[itemDic objectForKey:@"peremail"];
                     aselContact.contactsloginname = [itemDic objectForKey:@"contactsloginname"];
                     aselContact.belongfunction = [itemDic stringValueForKey:@"belongfunction" defaultValue:@""];
                     [companyContactArray addObject:aselContact];
                 }}
             if(companyContactArray.count > 0)
             {
                 NSMutableArray *callbackA = [NSMutableArray array];
                 NSMutableArray *tempA = [NSMutableArray array];
                 for(selectContact *conModel in companyContactArray)
                 {
                     if(![tempA containsObject:conModel.iName])
                     {
                         [tempA addObject:conModel.iName];
                         [callbackA addObject:conModel];
                     }
                 }
                 //去重
                 callback(callbackA,belongfunction);
             }
             else
             {
                 callback (companyContactArray,belongfunction);
             }
         }
         else
         {
             NSString * code = [dictOriginal objectForKey:@"code"];
             if ([code isEqualToString:@"2007"])
             {
                 failure (code);
             }
             else
             {
                 failure (@"请求失败");
             }
         }

     }failure:^(NSError *error)
     {
         
     }];
}
- (void)getSpecilCompanyExpenseCenterWith:(NSString *)userName BySuccess:(void (^)(NSString *))callback failure:(void (^)(NSString *))failure
{
    NSString *postUrl = [NSString stringWithFormat:@"%@Enterprise/ZxrzChecked",kServerHost];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fromcity"] = [GlobalData getSharedInstance].iTiketOrderInfo.iFromCityName;
    if([[GlobalData getSharedInstance].iSdancheng isEqualToString:@"OW"])
    {
        params[@"sailtype"] = @"1";
    }
    else
    {
        params[@"sailtype"] = @"2";
    }
    params[@"startdate"] = [GlobalData getSharedInstance].iTiketOrderInfo.iStartTime;
    params[@"tocity"] = [GlobalData getSharedInstance].iTiketOrderInfo.iToCityName;
    params[@"username"] = userName;//@"桂松蕾";
    params[@"usertoken"] = [GlobalData getSharedInstance].token;
    [[SBHHttp sharedInstance]postPath:postUrl withParameters:params showHud:YES success:^(NSDictionary *callData)
    {
        if(![[callData objectForKey:@"msg"]isEqualToString:@"-1"])
        {
            callback([callData objectForKey:@"msg"]);
        }
        else
        {
            failure(@"无出差申请单,不能下单");
        }
    }failure:^(NSError *error)
    {
        failure(@"无出差申请单,不能下单");
    }];
}
- (void)getInsuranceDataBySuccess:(void (^)(NSString *info1, NSString * price1,NSString *info2, NSString *price2,NSString *info3, NSString * price3,NSArray *successArray))callback failure:(void (^)(NSString *))failure
{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",kServerHost,@"Order/Baoxian"];
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[@"usertoken"] = [GlobalData getSharedInstance].token;
    [[SBHHttp sharedInstance]postPath:postUrl withParameters:paraDict showHud:NO success:^(NSDictionary *callData)
     {
         NSLog(@"获取保险 = %@",callData);
         if ([[callData objectForKey:@"status"] isEqualToString:@"true"])
         {
             NSArray *callArray = [callData objectForKey:@"Content"];
             NSString *callbackInfo1 = [[[callArray objectAtIndex:0] objectForKey:@"info"]stringByReplacingOccurrencesOfString:@"|" withString:@"\n"];
             NSString *callbackPrice1 = [[callArray objectAtIndex:0] objectForKey:@"price"];
             NSString *callbackInfo2 = [[[callArray objectAtIndex:1] objectForKey:@"info"]stringByReplacingOccurrencesOfString:@"|" withString:@"\n"];
             NSString *callbackPrice2 = [[callArray objectAtIndex:1] objectForKey:@"price"];
             NSString *callbackInfo3 = [[[callArray objectAtIndex:2] objectForKey:@"info"]stringByReplacingOccurrencesOfString:@"|" withString:@"\n"];
             NSString *callbackPrice3 = [[callArray objectAtIndex:2] objectForKey:@"price"];

             callback(callbackInfo1,callbackPrice1,callbackInfo2,callbackPrice2,callbackInfo3,callbackPrice3,callArray);
         }
         else
         {
             failure(@"获取保险规则失败");
         }
     }failure:^(NSError *error)
     {
         failure(error.description);
     }];
}

- (void)getProjectAuditPersonsWith:(BeAuditProjectModel *)model andPassengers:(NSArray *)pArray andTicketId:(NSString *)ticketId andType:(AuditNewType)type BySuccess:(void (^)(NSDictionary *))callback failure:(void (^)(NSString *))failure
{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",kServerHost,@"Audit/AuditPjPerson"];
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[@"usertoken"] = [GlobalData getSharedInstance].token;
    paraDict[@"porjectno"] = model.porjectNo;
    paraDict[@"projectname"] = model.projectName;
    paraDict[@"ticketid"] = ticketId;
    paraDict[@"type"] = [NSString stringWithFormat:@"%ld",(long)type];

    NSMutableArray *passengers = [NSMutableArray array];
    for(id model in pArray)
    {
        if([model isKindOfClass:[BePassengerModel class]])
        {
            BePassengerModel *passModel = (BePassengerModel *)model;
            [passengers addObject:@{@"name":passModel.psgname,@"mobile":passModel.mobilephone,@"email":@""}];
        }
        if([model isKindOfClass:[selectPerson class]])
        {
            selectPerson *passModel = (selectPerson *)model;

            [passengers addObject:@{@"name":passModel.iName,@"mobile":passModel.iMobile,@"email":@""}];
        }
    }
    paraDict[@"passengers"] = passengers;
    //获取项目审批流加入 passengers集合
    //[{"name":"龚学会","mobile":"13240471235","email":"test"}]
    [[SBHHttp sharedInstance]postPath:postUrl withParameters:paraDict showHud:YES success:^(NSDictionary *callData)
     {
         callback(callData);
     }failure:^(NSError *error)
     {
         failure(error.description);
     }];
}
- (void)changeAuditTypeWith:(NSString *)porjectNo And:(NSString *)projectName andTicketId:(NSString *)ticketId andType:(AuditNewType)type andTripMans:(NSArray *)passengerArray andIsExceed:(NSString *)isExceed andOrderNo:(NSString *)orderNo BySuccess:(void (^)(NSDictionary *))callback failure:(void (^)(NSString *))failure
{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",kServerHost,@"Audit/AuditNewInfo"];
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[@"usertoken"] = [GlobalData getSharedInstance].token;
    paraDict[@"porjectno"] = porjectNo;
    paraDict[@"projectname"] = projectName;
    paraDict[@"ticketid"] = ticketId;
    paraDict[@"type"] = [NSString stringWithFormat:@"%ld",(long)type];
    paraDict[@"orderno"] = orderNo;
    paraDict[@"isExceed"]= isExceed;//超标确认提交 0首次提交 1超标确认提交
    NSMutableArray *passengers = [NSMutableArray array];
    for(id model in passengerArray)
    {
        if([model isKindOfClass:[BePassengerModel class]])
        {
            BePassengerModel *passModel = (BePassengerModel *)model;
            [passengers addObject:@{@"name":passModel.psgname,@"mobile":passModel.mobilephone,@"email":@""}];
        }
        if([model isKindOfClass:[selectPerson class]])
        {
            selectPerson *passModel = (selectPerson *)model;
            [passengers addObject:@{@"name":passModel.iName,@"mobile":passModel.iMobile,@"email":@""}];
        }
    }
    paraDict[@"TripMans"] = passengers;
    [[SBHHttp sharedInstance]postPath:postUrl withParameters:paraDict showHud:YES success:^(NSDictionary *callData)
     {
         callback(callData);
     }failure:^(NSError *error)
     {
         failure(error.description);
     }];
}
/**
 * 机票下单 180秒
 */
+ (void)commmitFlightOrderServerWith:(NSMutableDictionary *)params BySuccess:(void (^)(NSDictionary *))callback failure:(void (^)(NSError *))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"Order/CommitOrder"];
    [[ServerFactory getServerInstance:@"SBHHttp"]postPath:urlStr withParameters:params showHud:YES success:^(NSDictionary *dic)
     {
         callback(dic);
     }failure:^(NSError *error)
     {
         
     }];
}

- (void)commitFlightOrderWith:(BeOrderWriteModel *)writeModel BySuccess:(void (^)(NSDictionary *))callback failure:(void (^)(id))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSDictionary *passDict = [self getSelePassStringWith:writeModel];
    if([[passDict objectForKey:kErrorKey] length] > 0)
    {
        failure([passDict objectForKey:kErrorKey]);
        return;
    }
    NSMutableArray * allContactArray = [self getContactStringWith:writeModel];
    //费用中心
    NSString * feiCenter = @"";
    
    //出差原因
    NSString * reasonStr = @"";
    
    //项目名称
    NSString * proName = @"";
    
    //项目编码
    NSString * proCode = @"";
    
    
    for (int i=0; i<[writeModel.projectArray count]; i++)
    {
        projectObj * feicenobj = [writeModel.projectArray objectAtIndex:i];
        if([feicenobj.projectCode isEqual:@"expensecenter"])
        {
            feiCenter = feicenobj.projectValue;
        }
        else if([feicenobj.projectCode isEqual:@"isreasons"])
        {
            reasonStr = feicenobj.projectValue;
        }
        else if([feicenobj.projectCode isEqual:@"projectname"])
        {
            proName = feicenobj.projectValue;
        }
        else if([feicenobj.projectCode isEqual:@"projectcode"])
        {
            proCode = feicenobj.projectValue;
        }
    }
    if ([GlobalData getSharedInstance].FLIGHTNORTt ==NULL) {
        [GlobalData getSharedInstance].FLIGHTNORTt = @"";
    }
    if ([GlobalData getSharedInstance].GOWw ==NULL) {
        [GlobalData getSharedInstance].GOWw = @"";
    }
    if ([GlobalData getSharedInstance].UDIDd ==NULL) {
        [GlobalData getSharedInstance].UDIDd = @"";
    }
    if ([GlobalData getSharedInstance].POWw ==NULL) {
        [GlobalData getSharedInstance].POWw = @"";
    }
    if ([writeModel.iscustomized isEqualToString:@"N"]) {
        feiCenter = @"";
    }
    
    //时间校准
    NSString *backTime = [GlobalData getSharedInstance].iTiketOrderInfo.iEndTime;
    
    if([[GlobalData getSharedInstance].iSdancheng isEqualToString:@"OW"])
    {
        backTime = @"";
    }
    
    NSString *tempStr = @"1";
    if ([GlobalData getSharedInstance].iTiketOrderInfo.travelReason == kTravelReasonTypePrivate) {
        tempStr = @"0";
    }
    NSString * startTime = [GlobalData getSharedInstance].iTiketOrderInfo.iStartTime;
    
    NSString *comParam = @"0";  // 代办登机牌
    ///"isaudit": "",//是否有审批0没有1有
    // "oldornew": "",//是否新旧审批 0旧审批 1新审批
    NSString *isaudit = writeModel.auditType == AuditTypeNone?@"0":@"1";
    NSString *oldornew = writeModel.auditType == AuditTypeOld?@"0":@"1";
    
    params[@"usertoken"] = [GlobalData getSharedInstance].token;
    params[@"format"] = @"json";
    params[@"platform"] = @"ios";
    params[@"airlinetype"] = [GlobalData getSharedInstance].iSdancheng;
    params[@"depairport"] = [GlobalData getSharedInstance].iTiketOrderInfo.iFromAirportCode;
    params[@"arrairport"] =[GlobalData getSharedInstance].iTiketOrderInfo.iToAirportCode;
    params[@"aircarrier"] = @"";
    params[@"depairdate"] = startTime;
    params[@"arrairdate"] = backTime;
    params[@"classrating"] = @"0";
    params[@"flightno"] = [GlobalData getSharedInstance].FLIGHTNORT;
    
    params[@"guid"] = [GlobalData getSharedInstance].GOW;
    
    params[@"flightnort"] = [GlobalData getSharedInstance].FLIGHTNORTt;
    
    params[@"guidrt"] = [GlobalData getSharedInstance].GOWw;
    
    params[@"op"] = tempStr;
    
    params[@"gow"] = [GlobalData getSharedInstance].UDID;
    
    params[@"grt"] = [GlobalData getSharedInstance].UDIDd;
    
    params[@"pow"] = [GlobalData getSharedInstance].POW;
    
    params[@"prt"] = [GlobalData getSharedInstance].POWw;
    
    params[@"expensecenter"] = feiCenter;
    
    params[@"isreason"] = reasonStr;
    params[@"projectname"] = proName;
    params[@"projectcode"] = proCode;
    
    params[@"totalprice"] = [NSString stringWithFormat:@"%d",[writeModel getAllPrice]];
    
    params[@"djp"] = comParam;
    params[@"passengers"] = [passDict objectForKey:kTicketKey];
    params[@"contact"] = allContactArray;
    params[@"isaudit"] = isaudit;
    params[@"oldornew"] = oldornew;
    params[@"isexceed"]= @"0";//超标确认提交 0首次提交 1超标确认提交
    params[@"overproreasons"] = [GlobalData getSharedInstance].overproreasons;
    params[@"goremark"] = [GlobalData getSharedInstance].goremark;
    params[@"backremark"] = [GlobalData getSharedInstance].backremark;
    params[@"verifypassengers"] = writeModel.verifypassengers;
    [GlobalData getSharedInstance].storedCommitInfo = [params mutableCopy];
    
    [BeAirTicketOrderWriteTool commmitFlightOrderServerWith:params BySuccess:^(NSDictionary *responseDict)
     {
         callback(responseDict);

     }failure:^(NSError *failError){
         failure(failError);
     }];
}

//乘机人的string
-(NSDictionary *)getSelePassStringWith:(BeOrderWriteModel *)writeModel
{
    NSString *errorStr = @"";
    NSMutableArray *ticketArray = [NSMutableArray array];
    for (int i =0; i<[writeModel.selectPassArr count]; i++)
    {
        selectPerson * selPeron = [writeModel.selectPassArr objectAtIndex:i];
        if ([selPeron.iType isEqualToString:@""])
        {
            selPeron.iType = @"ADT";
        }
        if ([selPeron.iCredNumber isEqualToString:@""])
        {
            errorStr = @"证件号码不能为空";
            return @{kErrorKey:errorStr,kTicketKey:ticketArray};
        }
        if ([selPeron.iBirthday isEqualToString:@"" ])
        {
            errorStr = @"出生日期不能为空";
            return @{kErrorKey:errorStr,kTicketKey:ticketArray};
        }
        if ([selPeron.iCredtype isEqualToString:@"其他证件"])
        {
            if(selPeron.iCredNumber.length == 18 && ![BeRegularExpressionUtil validateIdentityCard:selPeron.iCredNumber ])
            {
                errorStr = @"乘机人证件号码有误，请核对之后再提交订单";
                return @{kErrorKey:errorStr,kTicketKey:ticketArray};
            }
        }
        if([selPeron.iGender isEqualToString:@"0"]||[selPeron.iGender isEqualToString:@"女"]||[[selPeron.iGender lowercaseString] isEqualToString:@"f"])
        {
            selPeron.iGender = @"F";
        }
        else
        {
            selPeron.iGender = @"M";
        }
        
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
        NSString *countA = @"0";
        NSString *countB = @"0";
        NSString *countC = @"0";
        for(BeOrderInsuranceModel *insuModel in writeModel.insuranceArray)
        {
            if([insuModel.insuranceName isEqualToString:kInsuranceTitleA])
            {
                countA = [NSString stringWithFormat:@"%d",insuModel.insuranceCount];
            }
            else if([insuModel.insuranceName isEqualToString:kInsuranceTitleB])
            {
                countB = [NSString stringWithFormat:@"%d",insuModel.insuranceCount];
            }
            else if([insuModel.insuranceName isEqualToString:kInsuranceTitleDelay])
            {
                countC = [NSString stringWithFormat:@"%d",insuModel.insuranceCount];
            }
        }
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"id"] = selPeron.iId;
        params[@"type"] = selPeron.iType;
        params[@"gender"] = selPeron.iGender;
        params[@"name"] = selPeron.iName;
        params[@"credtype"] = selPeron.iCredtype;
        params[@"crednumber"] = selPeron.iCredNumber;
        params[@"moblie"] = selPeron.iMobile;
        
        params[@"oftencred"] = selPeron.iOftencred;
        params[@"birthday"] = selPeron.iBirthday;
        params[@"owcb"] = @"";//去程
        params[@"rtcb"] = @"";//回程
        
        params[@"insquantity"] = countA;//航班意外险A款 数量
        params[@"insprice"] = [writeModel.insuranceDict objectForKey:kInsuranceTitleA];//金额
        
        params[@"insquantityaccident"] = countB;//亚太航空意外险B款 数量
        params[@"inspriceaccident"] = [writeModel.insuranceDict objectForKey:kInsuranceTitleB];//金额
        
        params[@"insquantitydelay"] = countC;// 平安航班延误险（单次航班）数量
        params[@"inspricedelay"] = [writeModel.insuranceDict objectForKey:kInsuranceTitleDelay]; //金额
        
        params[@"insquantityrescue"] = @"";//人保交通意外救援保险（7天）数量 暂时传空
        params[@"inspricerescue"] = @"";
        [ticketArray addObject:params];
    }
    return @{kErrorKey:errorStr,kTicketKey:ticketArray};
}
//联系人的string
- (NSMutableArray *)getContactStringWith:(BeOrderWriteModel *)writeModel
{
    NSMutableArray *contactArray = [NSMutableArray array];
    for (int i=0; i<[writeModel.companyContactArray count]; i++)
    {
        selectContact * aContact = [writeModel.companyContactArray objectAtIndex:i];
        
        NSString * phone = @"";
        if(aContact.isOpenPhone)
        {
            phone = aContact.iMobile;
        }
        
        NSString * email = @"";
        if (aContact.isOpenEmail)
        {
            email = aContact.iEmail;
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"name"] = aContact.iName;
        params[@"phone"] = phone;
        params[@"pertype"] = @"2";
        params[@"flowtype"] = @"0";
        params[@"returnstate"] = aContact.iResturnState;
        params[@"index"] = aContact.iIndex;
        params[@"mobile"] = phone;
        params[@"email"] = email;
        params[@"loginname"] = aContact.contactsloginname;
        params[@"belongfunction"] = aContact.belongfunction;
        [contactArray addObject:params];
    }
    for (int i=0; i<writeModel.contactList.count; i++) {
        BeOrderWriteAuditInfoModel *auditM = [writeModel.contactList objectAtIndex:i];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"name"] = auditM.Name;
        params[@"phone"] = auditM.Mobile;
        params[@"pertype"] = auditM.PerType;
        params[@"flowtype"] =  auditM.FlowType;
        params[@"index"] = @"1";
        params[@"mobile"] = auditM.Tel;
        params[@"email"] = auditM.Email;
        params[@"belongfunction"] = @"";
        [contactArray addObject:params];
    }
    return contactArray;
}
- (void)commitNewAuditWith:(NSDictionary *)paramsDict andType:(AuditNewType)type BySuccess:(void (^)(NSDictionary *))callback failure:(void (^)(NSError *))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"Audit/AuditNewMsg"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:paramsDict];
    dict[@"type"] = [NSString stringWithFormat:@"%ld",(long)type];
    [[SBHHttp sharedInstance] postPath:urlStr withParameters:dict showHud:YES success:^(id responseObject) {
        callback(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
- (void)checkYiyangFlightOrderWith:(BeOrderWriteModel *)model byCallback:(void (^)(NSDictionary *))successBack failureCallback:(void (^)(NSError *))failureCallback
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
    parameter[@"startdate"] = [GlobalData getSharedInstance].iTiketOrderInfo.iStartTime;
    parameter[@"fromcity"] = [GlobalData getSharedInstance].iTiketOrderInfo.iFromCityName;
    parameter[@"tocity"] = [GlobalData getSharedInstance].iTiketOrderInfo.iToCityName;
    parameter[@"sailtype"] = ([[GlobalData getSharedInstance].iSdancheng isEqualToString:@"OW"] == YES)?@"OW":@"RT";
    NSMutableArray *identifyArray = [[NSMutableArray alloc]init];
    for(selectPerson *personModel in model.selectPassArr)
    {
        [identifyArray addObject:personModel.iCredNumber];
    }
    parameter[@"identity"] = [identifyArray componentsJoinedByString:@","];
    parameter[@"money"] = [NSString stringWithFormat:@"%d",[model getAllPrice]];
    parameter[@"types"] = @"F";
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
