//
//  BeHotelOrderWriteModel.m
//  sbh
//
//  Created by RobinLiu on 15/12/15.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelOrderWriteModel.h"
#import "selectPerson.h"
#import "selectContact.h"
#import "BeRegularExpressionUtil.h"
#import "BePriceListModel.h"
#import "BeOrderWriteModel.h"
#import "BePassengerModel.h"

@implementation BeHotelOrderWriteModel
- (id)init
{
    if(self = [super init])
    {
        _CreateTime = @"";
        _City_Code = @"";
        _CityName = @"";

        _RatePlanInfoId = @"";
        _HotelId = @"";
        _HotelName = @"";
        _StarRate = @"";
        _belongfunction = @"";
        _Category = @"";
        _GsType = @"";
        _RoomName = @"";
        _Address = @"";
        _PayType = @"";
        _PayMethod = @"";
        _CheckInDate = @"";
        _CheckOutDate = @"";
        _PolicyRemark = @"";
        _PolicyName = @"";
        _ReservedTime = @"14:00";//默认时间
        _ExpenseCenter = @"";
        _ProjectName = @"";
        _ProjectCode = @"";
        _BusinessReasons = @"";
        _Rp_ChancelStatus = @"";
        _ServiceFee = @"0";
        _AddBreakfastFee = @"0";
        _AddBedFee = @"0";
        _BroadbandFee = @"0";
        _OtherFee = @"0";
        _orderNo = @"";
        _OrderNote = @"";
        _Persons = [[NSMutableArray alloc]init];
        
        _Contacts = [[NSMutableArray alloc]init];
        _Ticket = [[NSMutableArray alloc]init];
        _priceArray = [[NSMutableArray alloc]init];
        _selectedProject = [[BeAuditProjectModel alloc]init];
        
        _errorNo = @"";
        _flag = @"false";
        _RoomCount = @"1";
        _roomPrice = @"";
        
        _expenseDisplayArray= [[NSMutableArray alloc]init];
        _payTypeString = @"";
        _roomSectionDisplayArray = [[NSMutableArray alloc]init];
        
        _isExceed = @"0";
        _PolicyReason = @"";
        if ([[GlobalData getSharedInstance].userModel.levelcode isEqualToString:@"2"] ||[[GlobalData getSharedInstance].userModel.levelcode isEqualToString:@"3"] )
        {
            if([GlobalData getSharedInstance].userModel.DptName.length > 0)
            {
                _ExpenseCenter = [GlobalData getSharedInstance].userModel.DptName;
            }
        }
        if ([[GlobalData getSharedInstance].userModel.levelcode isEqualToString:@"3"])
        {
            //员工账号把个人信息带过来
            
            SBHUserModel *userModel = [GlobalData getSharedInstance].userModel;
            selectPerson *selPerson = [[selectPerson alloc] init];
            selPerson.iGender = userModel.Gender;
            selPerson.iBirthday = userModel.BirthDay;
            selPerson.iMobile = userModel.MobilePhone;
            selPerson.iCredtype = userModel.cardType;
            selPerson.iName = userModel.staffname;
            selPerson.rolename = userModel.DptName;
            selPerson.iCredNumber = userModel.certificatenumber;
            selPerson.iId = userModel.PID;
            if (userModel.staffname.length != 0|| ![userModel.staffname isEqualToString:@""])
            {
                [_Persons insertObject:selPerson atIndex:0];
            }
        }
        selectContact *contactModel = [[selectContact alloc]init];
        [_Contacts addObject:contactModel];
        _projectAuditPersonArray = [[NSMutableArray alloc]init];
        _otherAuditPersonArray = [[NSMutableArray alloc]init];
        _selectedAuditPersonArray = [[NSMutableArray alloc]init];
        _projectFlowID = @"";
        _VerifypriceID = @"";
    }
    return self;
}
- (void)setDataWith:(BeHotelListItem *)listItem and:(BeHotelDetailSectionModel *)hotelSectionModel and:(BeHotelDetailRoomListModel *)roomModel
{
    _City_Code = listItem.cityId;
    _CityName = listItem.cityName;

    _RatePlanInfoId = roomModel.Id;
    _HotelId = listItem.hotelId;
    _HotelName = listItem.hotelName;
    _StarRate = listItem.Hotel_Star;
    _Category = listItem.Hotel_SBHStar;
    _GsType = listItem.TravelType;
    _RoomName = hotelSectionModel.Room_Name;
    _Address = listItem.hotelAddress;
    
    _CheckInDate = listItem.CheckInDate;
    _CheckOutDate = listItem.CheckOutDate;
    
    _PolicyRemark = roomModel.Rp_ChancelDecription;
    _PolicyName = roomModel.Rp_Name;
    _Rp_ChancelStatus = roomModel.Rp_ChancelStatus;
    _roomPrice = roomModel.Dr_Amount;
    
    int payTypeNum = [roomModel.Rp_Type intValue];
    if(payTypeNum == 14 || payTypeNum == 16 || payTypeNum == 805 || payTypeNum == 3)
    {
        if([roomModel.Rp_Guarantee intValue]==0)
        {
            _PayType = @"3";
        }
        else
        {
            _PayType = @"1";
        }
        _PayMethod = @"4";
        _payTypeString = [NSString stringWithFormat:@"审批通过后，系统自动%@",kPayTipString];
        [_roomSectionDisplayArray addObjectsFromArray:@[kRoomCount,kRoomPerson,kCheckInTime,kRemark]];
    }
    else
    {
        _PayType = @"2";
        _PayMethod = @"3";
        _payTypeString = kPayTipString;
        [_roomSectionDisplayArray addObjectsFromArray:@[kRoomCount,kRoomPerson,kRemark]];
    }
}
- (void)updateExpenseDisplayWith:(NSDictionary *)dict
{
    [_expenseDisplayArray removeAllObjects];
    if([[dict stringValueForKey:kBusinessReasons]isEqualToString:@"Y"]||[[dict stringValueForKey:kBusinessReasons]isEqualToString:@"1"])
    {
        [_expenseDisplayArray addObject:kBusinessReasons];
    }
    if([[dict stringValueForKey:kExpenseCenter]isEqualToString:@"Y"]||[[dict stringValueForKey:kExpenseCenter]isEqualToString:@"1"])
    {
        [_expenseDisplayArray addObject:kExpenseCenter];
    }
    if([[dict stringValueForKey:kProjectCode]isEqualToString:@"Y"]||[[dict stringValueForKey:kProjectCode]isEqualToString:@"1"])
    {
        [_expenseDisplayArray addObject:kProjectCode];
    }
    if([[dict stringValueForKey:kProjectName]isEqualToString:@"Y"]||[[dict stringValueForKey:kProjectName]isEqualToString:@"1"])
    {
        [_expenseDisplayArray addObject:kProjectName];
    }
}
- (void)checkInfoIsCorrectWithBlock:(void (^)(BOOL isCanBook,NSString *status))callback
{
    if(self.Persons.count == 0)
    {
        callback(NO,@"请选择入住人");
        return;
    }
    if(self.Persons.count != [self.RoomCount intValue])
    {
        callback(NO,@"入住人数需与房间数量一致");
        return;
    }
    for(selectPerson *personModel in self.Persons)
    {
        if(personModel.iName.length < 1 || personModel.iName == nil)
        {
            callback(NO,@"入住人姓名不能为空");
            return;
        }
        if([GlobalData getSharedInstance].userModel.isYiyang)
        {
            if(personModel.iCredNumber.length < 1 || personModel.iCredNumber == nil)
            {
                //NSString *warningTip = [NSString stringWithFormat:@"入住人%@的身份证号码不能为空",personModel.iName];
                NSString *warningTip = @"有未填写的身份证号码";
                callback(NO,warningTip);
                return;
            }
            if(![BeRegularExpressionUtil validateIdentityCard:personModel.iCredNumber])
            {
                NSString *warningTip = [NSString stringWithFormat:@"入住人%@的身份证号码格式不正确",personModel.iName];
                callback(NO,warningTip);
                return;
            }
        }
    }
    for(selectContact *contactModel in self.Contacts)
    {
        if(contactModel.iName.length < 1 || contactModel.iName == nil)
        {
            callback(NO,@"联系人姓名不能为空");
            return;
        }
        if(contactModel.iMobile.length < 1 && contactModel.iMobile == nil)
        {
            callback (NO,@"联系人电话不能为空");
            return;
        }
        if(![BeRegularExpressionUtil validateMobile:contactModel.iMobile])
        {
            callback (NO,@"联系人电话格式不正确");
            return;
        }
    }
    for(NSString * member in self.expenseDisplayArray)
    {
        if([member isEqualToString:kExpenseCenter])
        {
            if(self.ExpenseCenter.length < 1)
            {
                callback (NO,@"请输入费用中心");
                return;
            }
        }
        if([member isEqualToString:kBusinessReasons])
        {
            if(self.BusinessReasons.length < 1)
            {
                callback (NO,@"请输入出差原因");
                return;
            }
        }
    }
    callback(YES,@"");
}
- (void)setupDataWithHotelOrderData:(NSDictionary *)detailDict
{
    NSDictionary *dict = [[[detailDict objectForKey:@"orderinfo"]objectForKey:@"ho"] firstObject];
    NSDictionary *Order = [dict objectForKey:@"Order"];
    _TicketId = [[detailDict dictValueForKey:@"newaudit"] stringValueForKey:@"TicketId" defaultValue:@""];
    _City_Code = [Order stringValueForKey:@"CityCode" defaultValue:@""];
    _CityName = [Order stringValueForKey:@"CityName" defaultValue:@""];
    _HotelId = [Order stringValueForKey:@"HotelId" defaultValue:@""];
    _PayType = [Order stringValueForKey:@"PayType" defaultValue:@""];
    _PayMethod = [Order stringValueForKey:@"PayMethod" defaultValue:@""];
    [_Persons removeAllObjects];
    [_Contacts removeAllObjects];
    [_priceArray removeAllObjects];
    NSDictionary *orderDict = [dict dictValueForKey:@"Order"];
    _orderNo = [orderDict stringValueForKey:@"OrderNo"];
    for(NSDictionary * member in [dict objectForKey:@"Persons"])
    {
        selectPerson *personModel = [[selectPerson alloc]init];
        personModel.iName = [member stringValueForKey:@"Name"];
        [_Persons addObject:personModel];
    }
    NSArray *contactA = [dict arrayValueForKey:@"Contacts"];
    if(contactA.count > 0)
    {
        NSDictionary *member = [contactA firstObject];
        selectContact *conModel = [[selectContact alloc]init];
        conModel.iName = [member stringValueForKey:@"Name" defaultValue:@""];
        conModel.iMobile = [member stringValueForKey:@"Mobile" defaultValue:@""];
        [_Contacts addObject:conModel];
    }
    if([orderDict stringValueForKey:kBusinessReasons]!=nil && [orderDict stringValueForKey:kBusinessReasons].length > 0)
    {
        [_expenseDisplayArray addObject:kBusinessReasons];
        _BusinessReasons = [orderDict stringValueForKey:kBusinessReasons];
    }
    if([orderDict stringValueForKey:kExpenseCenter]!=nil &&[orderDict stringValueForKey:kExpenseCenter].length > 0)
    {
        [_expenseDisplayArray addObject:kExpenseCenter];
        _ExpenseCenter = [orderDict stringValueForKey:kExpenseCenter];
    }
    if([orderDict stringValueForKey:kProjectCode]!=nil &&[orderDict stringValueForKey:kProjectCode].length > 0)
    {
        [_expenseDisplayArray addObject:kProjectCode];
        _ProjectCode = [orderDict stringValueForKey:kProjectCode];

    }
    if([orderDict stringValueForKey:kProjectName]!=nil &&[orderDict stringValueForKey:kProjectName].length > 0)
    {
        [_expenseDisplayArray addObject:kProjectName];
        _ProjectName = [orderDict stringValueForKey:kProjectName];

    }
    _CreateTime = [[[[orderDict stringValueForKey:@"CreateTime"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] componentsSeparatedByString:@"."] firstObject];
    NSArray *priceA = [dict arrayValueForKey:@"Prices"];
    for(NSDictionary *member in priceA)
    {
        BePriceListModel *prModel = [BePriceListModel mj_objectWithKeyValues:member];
        prModel.RoomDate = [[prModel.RoomDate componentsSeparatedByString:@"T"] firstObject];
        [_priceArray addObject:prModel];
    }
    _HotelName = [orderDict stringValueForKey:@"HotelName" defaultValue:@""];
    _RoomName = [orderDict stringValueForKey:@"RoomName" defaultValue:@""];
    _CheckInDate = [[[orderDict stringValueForKey:@"CheckInDate" defaultValue:@""] componentsSeparatedByString:@"T"] firstObject];
    _CheckOutDate = [[[orderDict stringValueForKey:@"CheckOutDate" defaultValue:@""] componentsSeparatedByString:@"T"] firstObject];
    _roomPrice = [orderDict stringValueForKey:@"RoomFee" defaultValue:@""];
}

- (void)getHotelAuditWith:(NSDictionary *)dict
{
 /*
  status = true,
  code = 20027,
  ticketid = aec7e1c9-5489-43de-9978-493a629b0deb,
  newaudit = {
  TicketId = aec7e1c9-5489-43de-9978-493a629b0deb,
  Version = 1,
  message = ,
  UsabledFlowType = 3,
  FlowInformations = [
  ],
  resultcode = 1
  }
  }
  */
    /*
     {
     status = true,
     code = 20027,
     ticketid = be78d4af-f550-4acd-bcfd-3632ba4ec865,
     newaudit = {
     TicketId = be78d4af-f550-4acd-bcfd-3632ba4ec865,
     Version = 1,
     message = ,
     UsabledFlowType = 1,3,
     FlowInformations = [
     {
     type = 1,
     flowID = 70174,
     approvars = [
     {
     mobile = 15510599093,
     account = <null>,
     IsAudited = 0,
     AuditDt = 0001-01-01T00:00:00,
     level = 1,
     ApprovalResult = <null>,
     email = xiudong.zhao@shenbianhui.cn,
     name = 东哥
     }
     ]
     }
     ],
     resultcode = 1
     }
     }
     */
    _auditDict = [dict dictValueForKey:@"newaudit"];
    _selectAudit = HotelSelectedAuditModeOther;
    if([[[dict dictValueForKey:@"newaudit"] allKeys] count]!=0)
    {
        NSDictionary *newaudit = [dict dictValueForKey:@"newaudit"];
        _TicketId = [newaudit stringValueForKey:@"TicketId" defaultValue:@""];
        NSString *UsabledFlowType = [newaudit stringValueForKey:@"UsabledFlowType" defaultValue:@""];
        NSArray *typeArray = [UsabledFlowType componentsSeparatedByString:@","];
        BOOL containsProject = [typeArray containsObject:@"3"];

        //1公司,2部门,3项目,4 个人 逗号分隔
        
        /**
         * 获取项目审批人的数组
         */
        for(NSDictionary *member in [newaudit arrayValueForKey:@"FlowInformations"])
        {
            if([[member stringValueForKey:@"type"] isEqualToString:@"3"])
            {
                [_projectAuditPersonArray addObjectsFromArray: [BeOrderWriteModel setupAuditArrayWith:[member arrayValueForKey:@"approvars"]]];
            }
        }

        /**
         * 公司账户
         */
        if([GlobalData getSharedInstance].userModel.accountType == AccountTypeEnterprise)
        {
            //公司账户   公司审批
            if([typeArray containsObject:@"1"])
            {
                //公司审批
                self.auditType = containsProject == YES? HotelAuditTypeProjectAndEnt : HotelAuditTypeWithoutProject;
                [self selectArrayAddDataWith:@"1" andDict:newaudit];
            }
            else
            {
                [_selectedAuditPersonArray addObjectsFromArray:_projectAuditPersonArray];
                self.auditType = containsProject == YES? HotelAuditTypeOnlyProject : HotelAuditTypeNone;
            }
            return;
        }
        /**
         * 部门账户
         */
        if([GlobalData getSharedInstance].userModel.accountType == AccountTypeEntDepartment)
        {
            // 首先是部门审批
            if([typeArray containsObject:@"2"])
            {
                //部门审批
                self.auditType = containsProject == YES? HotelAuditTypeProjectAndDep : HotelAuditTypeWithoutProject;
                [self selectArrayAddDataWith:@"2" andDict:newaudit];

            }
            // 然后是公司审批
            else if([typeArray containsObject:@"1"])
            {
                //公司审批
                self.auditType = containsProject == YES? HotelAuditTypeProjectAndEnt : HotelAuditTypeWithoutProject;
                [self selectArrayAddDataWith:@"1" andDict:newaudit];
            }
            else
            {
                [_selectedAuditPersonArray addObjectsFromArray:_projectAuditPersonArray];
                self.auditType = containsProject == YES? HotelAuditTypeOnlyProject : HotelAuditTypeNone;
            }
            return;
        }
        
        /**
         * 个人账号
         */
        if([GlobalData getSharedInstance].userModel.accountType == AccountTypeEntIndividual)
        {
            //个人账号   首先是个人审批 其实部门审批 最后是公司审批
            
            if([typeArray containsObject:@"4"])
            {
                //个人审批
                self.auditType = containsProject == YES? HotelAuditTypeProjectAndInd : HotelAuditTypeWithoutProject;
                [self selectArrayAddDataWith:@"4" andDict:newaudit];
            }
            else if([typeArray containsObject:@"2"])
            {
                //部门审批
                self.auditType = containsProject == YES? HotelAuditTypeProjectAndDep : HotelAuditTypeWithoutProject;
                [self selectArrayAddDataWith:@"2" andDict:newaudit];
            }
            else if([typeArray containsObject:@"1"])
            {
                //公司审批
                self.auditType = containsProject == YES? HotelAuditTypeProjectAndEnt : HotelAuditTypeWithoutProject;
                [self selectArrayAddDataWith:@"1" andDict:newaudit];
            }
            else
            {
                [_selectedAuditPersonArray addObjectsFromArray:_projectAuditPersonArray];
                self.auditType = containsProject == YES? HotelAuditTypeOnlyProject : HotelAuditTypeNone;
            }
            return;
        }
    }
    else
    {
        self.auditType = HotelAuditTypeNone;
    }
}
- (void)selectArrayAddDataWith:(NSString *)typeString andDict:(NSDictionary *)dictData
{
    for(NSDictionary *member in [dictData arrayValueForKey:@"FlowInformations"])
    {
        if([[member stringValueForKey:@"type"] isEqualToString:typeString])
        {
            [_otherAuditPersonArray addObjectsFromArray: [BeOrderWriteModel setupAuditArrayWith:[member arrayValueForKey:@"approvars"]]];
        }
    }
    [_selectedAuditPersonArray addObjectsFromArray:_otherAuditPersonArray];
}
- (NSDictionary *)getAuditDict
{
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc]init];
    dictData[@"OrderNo"] = self.orderNo;
    //todo
    
    dictData[@"OrderStatus"] = self.orderNo;
    dictData[@"TicketId"] = self.TicketId;
    dictData[@"hotelid"] = self.HotelId;
    if (self.auditType == HotelAuditTypeOnlyProject||(( self.auditType == HotelAuditTypeProjectAndEnt || self.auditType ==  HotelAuditTypeProjectAndDep||self.auditType ==HotelAuditTypeProjectAndInd) && self.selectAudit == HotelSelectedAuditModeProject))
    {
        //项目审批
        dictData[@"flowID"] = _projectFlowID;
    }
    else
    {
        dictData[@"flowID"] = [[[_auditDict objectForKey:@"FlowInformations"] firstObject]stringValueForKey:@"flowID" defaultValue:@""];
        
    }
    CGFloat totalPrice = 0;
    for(BePriceListModel *prModel in _priceArray)
    {
        totalPrice = totalPrice + (int)_Persons.count * [prModel.SalePrice doubleValue];
    }
    dictData[@"sum"] = [NSString stringWithFormat:@"%f",totalPrice];
    NSMutableArray *traContacts = [[NSMutableArray alloc]init];
    
    for (selectPerson *personM in _Persons) {
        NSMutableDictionary *member = [NSMutableDictionary dictionary];
        member[@"name"] = personM.iName;
        member[@"mobile"] = personM.iMobile;
        member[@"level"] = @"0";
        member[@"IsAudited"] = @"false";
        [traContacts addObject:member];
    }
    dictData[@"traContacts"] = traContacts;//出差人联系方式
    
    dictData[@"usertoken"] = [GlobalData getSharedInstance].token;
    NSMutableArray *listPerson = [[NSMutableArray alloc]init];
    
    for(BeOrderWriteAuditInfoModel *model in self.selectedAuditPersonArray)
    {
        NSMutableDictionary *modelDict = [[NSMutableDictionary alloc]initWithDictionary:model.responseDict];
        
        if([[modelDict allKeys]containsObject:@"ApprovalResult"])
        {
            [modelDict removeObjectForKey:@"ApprovalResult"];
        }
        [listPerson addObject:modelDict];
    }
    dictData[@"listPerson"] = listPerson;
    return dictData;
}
@end
