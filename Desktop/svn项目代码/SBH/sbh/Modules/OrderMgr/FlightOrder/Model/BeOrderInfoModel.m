//
//  BeOrderInfoModel.m
//  sbh
//
//  Created by SBH on 15/4/17.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeOrderInfoModel.h"
#import "MJExtension.h"
#import "NSDictionary+Additions.h"
@implementation BeOrderInsuranceType

@end
@implementation BeOrderInfoModel

- (id)init
{
    if(self = [super init])
    {
        _isSelectBaoli = YES;
        _orderInfoDict = [[NSMutableDictionary alloc]init];
        _projectAuditPersonArray = [[NSMutableArray alloc]init];
        _otherAuditPersonArray = [[NSMutableArray alloc]init];
        _selectedAuditPersonArray = [[NSMutableArray alloc]init];
        _selectedProject = [[BeAuditProjectModel alloc]init];
        _TicketId = @"";
        _selectedProject = [[BeAuditProjectModel alloc]init];
        _projectFlowID = @"";
        _baoxianlist = [[NSMutableArray alloc]init];
    }
    return self;
}
- (NSMutableArray *)flightFrameArray
{
    if (_flightFrameArray == nil) {
        _flightFrameArray = [NSMutableArray array];
    }
    return _flightFrameArray;
}

- (NSMutableArray *)pasFrameArray
{
    if (_pasFrameArray == nil) {
        _pasFrameArray = [NSMutableArray array];
    }
    return _pasFrameArray;
}

- (NSMutableArray *)conFrameArray
{
    if (_conFrameArray == nil) {
        _conFrameArray = [NSMutableArray array];
    }
    return _conFrameArray;
}

- (void)setSumDetailStr
{
    self.sumDetailStr = [NSString stringWithFormat:@"票面￥%@/机建￥%@/燃油￥%@/保险￥%@/服务费￥%d",self.sellprice,self.airporttax,self.fueltex,self.insurancepricetotal, [self.servicecharge intValue]];
}
- (void)setServicecharge:(NSString *)servicecharge
{
    NSString *str = [NSString stringWithFormat:@"%d", [servicecharge intValue]];
    _servicecharge = str;
}
- (void)setupAuditCommitDataWith:(NSDictionary *)dict
{
    
}

+ (NSMutableArray *)setupAuditArrayWith:(NSArray *)approvars
{
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSMutableArray *firstLevel = [[NSMutableArray alloc]init];
    NSMutableArray *SecondLevel = [[NSMutableArray alloc]init];
    NSMutableArray *ThirdLevel = [[NSMutableArray alloc]init];
    for(NSDictionary *approvalMember in approvars)
    {
        BeOrderWriteAuditInfoModel *model = [[BeOrderWriteAuditInfoModel alloc]initWithDict:approvalMember];
        if([model.level isEqualToString:@"1"])
        {
            model.displayLevel = @"一级审批人";
            [firstLevel addObject:model];
        }
        if([model.level isEqualToString:@"2"])
        {
            model.displayLevel = @"二级审批人";
            [SecondLevel addObject:model];
            
        }
        if([model.level isEqualToString:@"3"])
        {
            model.displayLevel = @"三级审批人";
            [ThirdLevel addObject:model];
        }
    }
    [resultArray addObjectsFromArray:firstLevel];
    [resultArray addObjectsFromArray:SecondLevel];
    [resultArray addObjectsFromArray:ThirdLevel];
    
    if(SecondLevel.count == 0 && ThirdLevel.count == 0)
    {
        for(int i = 0;i < resultArray.count;i++)
        {
            BeOrderWriteAuditInfoModel *model = resultArray[i];
            if([GlobalData getSharedInstance].userModel.isYPS)
            {
                if(i == 0)
                {
                    model.displayLevel = @"一级审批人";
                }
                else if(i == 1)
                {
                    model.displayLevel = @"二级审批人";
                }
                else if (i > 1)
                {
                    model.displayLevel = @"备选审批人";
                }
            }
            else
            {
                model.displayLevel = @"审批人";
            }
        }
    }
    return resultArray;
}
- (void)getAuitDataWith:(NSDictionary *)dict withSourceType:(OrderFinishSourceType )sourceType
{
    BOOL isXinshenpi = NO;
    BOOL hasFlowInformations = NO;
    if([[dict stringValueForKey:@"isaudit"] intValue]== 1)
    {
        //有审批的情况
        NSDictionary *newaudit = [dict dictValueForKey:@"newaudit"];
        _TicketId = [newaudit stringValueForKey:@"TicketId" defaultValue:@""];
        if([_TicketId length] < 1)
        {
            isXinshenpi = NO;
        }
        else
        {
            isXinshenpi = YES;
        }
        NSString *UsabledFlowType = [newaudit stringValueForKey:@"UsabledFlowType" defaultValue:@""];
        NSArray *typeArray = [[NSArray alloc]init];
        if(UsabledFlowType.length > 0)
        {
           typeArray = [UsabledFlowType componentsSeparatedByString:@","];
        }
        BOOL containsProject = [typeArray containsObject:@"3"];
        BOOL containsOther = NO;
        
        if([[[dict dictValueForKey:@"newaudit"] arrayValueForKey:@"FlowInformations"] count] > 0)
        {
            hasFlowInformations = YES;
            //新审批
            //获取项目审批人的数组信息
            for(NSDictionary *member in [newaudit arrayValueForKey:@"FlowInformations"])
            {
                if([[member stringValueForKey:@"type"] isEqualToString:@"3"])
                {
                    [_projectAuditPersonArray addObjectsFromArray: [BeOrderWriteModel setupAuditArrayWith:[member arrayValueForKey:@"approvars"]]];
                }
            }
            
            //1公司,2部门,3项目,4 个人 逗号分隔
            
            if([typeArray containsObject:@"1"]||[typeArray containsObject:@"2"]||[typeArray containsObject:@"4"])
            {
                containsOther = YES;
                if([GlobalData getSharedInstance].userModel.accountType == AccountTypeEnterprise)
                {
                    //公司账户   公司审批
                    if([typeArray containsObject:@"1"])
                    {
                        //公司审批
                        self.auditType = containsProject == YES? AuditTypeProjectAndEnt : AuditTypeWithoutProject;
                        for(NSDictionary *member in [newaudit arrayValueForKey:@"FlowInformations"])
                        {
                            if([[member stringValueForKey:@"type"] isEqualToString:@"1"])
                            {
                                [_otherAuditPersonArray addObjectsFromArray: [BeOrderWriteModel setupAuditArrayWith:[member arrayValueForKey:@"approvars"]]];
                            }
                        }
                    }
                }
                if([GlobalData getSharedInstance].userModel.accountType == AccountTypeEntDepartment)
                {
                    //部门账号   首先是部门审批  然后是公司审批
                    if([typeArray containsObject:@"2"])
                    {
                        //部门审批
                        self.auditType = containsProject == YES? AuditTypeProjectAndDep : AuditTypeWithoutProject;
                        for(NSDictionary *member in [newaudit arrayValueForKey:@"FlowInformations"])
                        {
                            if([[member stringValueForKey:@"type"] isEqualToString:@"2"])
                            {
                                [_otherAuditPersonArray addObjectsFromArray: [BeOrderWriteModel setupAuditArrayWith:[member arrayValueForKey:@"approvars"]]];
                            }
                        }
                    }
                    else if([typeArray containsObject:@"1"])
                    {
                        //公司审批
                        self.auditType = containsProject == YES? AuditTypeProjectAndEnt : AuditTypeWithoutProject;
                        for(NSDictionary *member in [newaudit arrayValueForKey:@"FlowInformations"])
                        {
                            if([[member stringValueForKey:@"type"] isEqualToString:@"1"])
                            {
                                [_otherAuditPersonArray addObjectsFromArray: [BeOrderWriteModel setupAuditArrayWith:[member arrayValueForKey:@"approvars"]]];
                            }
                        }
                    }
                }
                if([GlobalData getSharedInstance].userModel.accountType == AccountTypeEntIndividual)
                {
                    //个人账号   首先是个人审批 其实部门审批 最后是公司审批
                    
                    if([typeArray containsObject:@"4"])
                    {
                        //个人审批
                        self.auditType = containsProject == YES? AuditTypeProjectAndInd : AuditTypeWithoutProject;
                        for(NSDictionary *member in [newaudit arrayValueForKey:@"FlowInformations"])
                        {
                            if([[member stringValueForKey:@"type"] isEqualToString:@"4"])
                            {
                                [_otherAuditPersonArray addObjectsFromArray: [BeOrderWriteModel setupAuditArrayWith:[member arrayValueForKey:@"approvars"]]];
                            }
                        }
                    }
                    else if([typeArray containsObject:@"2"])
                    {
                        //部门审批
                        self.auditType = containsProject == YES? AuditTypeProjectAndDep : AuditTypeWithoutProject;
                        for(NSDictionary *member in [newaudit arrayValueForKey:@"FlowInformations"])
                        {
                            if([[member stringValueForKey:@"type"] isEqualToString:@"2"])
                            {
                                [_otherAuditPersonArray addObjectsFromArray: [BeOrderWriteModel setupAuditArrayWith:[member arrayValueForKey:@"approvars"]]];
                            }
                        }
                    }
                    else if([typeArray containsObject:@"1"])
                    {
                        //公司审批
                        self.auditType = containsProject == YES? AuditTypeProjectAndEnt : AuditTypeWithoutProject;
                        for(NSDictionary *member in [newaudit arrayValueForKey:@"FlowInformations"])
                        {
                            if([[member stringValueForKey:@"type"] isEqualToString:@"1"])
                            {
                                [_otherAuditPersonArray addObjectsFromArray: [BeOrderWriteModel setupAuditArrayWith:[member arrayValueForKey:@"approvars"]]];
                            }
                        }
                    }
                }
                [_selectedAuditPersonArray addObjectsFromArray:_otherAuditPersonArray];
            }
            else
            {
                if(containsProject)
                {
                    self.auditType = AuditTypeOnlyProject;
                    /*if([_projectAuditPersonArray count] == 0)
                     {
                     [_projectAuditPersonArray addObject:defaultModel];
                     }*/
                    [_selectedAuditPersonArray addObjectsFromArray:_projectAuditPersonArray];
                }
                else
                {
                    self.auditType = AuditTypeNone;
                    
                }
            }
        }
        else
        {
            if(containsProject == YES && containsOther == NO)
            {
                /* if([_projectAuditPersonArray count] == 0)
                 {
                 [_projectAuditPersonArray addObject:defaultModel];
                 }*/
                [_selectedAuditPersonArray addObjectsFromArray:_projectAuditPersonArray];
                self.auditType = AuditTypeOnlyProject;
                return;
            }
            else
            {
                if(typeArray.count == 0)
                {
                    self.auditType = AuditTypeNone;
                }
                else
                {
                    self.auditType = AuditTypeOld;
                }
                return;
            }
        }
    }
    if(isXinshenpi == NO)
    {
        if([[dict stringValueForKey:@"isaudit"] intValue]== 1 && isXinshenpi == NO)
        {
            //老审批
            self.auditType = AuditTypeOld;
        }
        else
        {
            self.auditType = AuditTypeNone;
        }
    }
}

- (NSDictionary *)getAuditDict
{
    if(self.auditType == AuditTypeNone || self.auditType ==       AuditTypeOld)
    {
        return nil;
    }
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc]init];
    NSDictionary *newaudit = [self.orderInfoDict objectForKey:@"newaudit"];
    dictData[@"OrderNo"] = self.orderno;
    dictData[@"OrderStatus"] = self.orderst;
    dictData[@"TicketId"] = self.TicketId;
    dictData[@"hotelid"] = @"";
    if (self.auditType == AuditTypeOnlyProject||(( self.auditType == AuditTypeProjectAndEnt || self.auditType ==  AuditTypeProjectAndDep||self.auditType ==AuditTypeProjectAndInd) && self.selectAudit == SelectedAuditModeProject))
    {
        //项目审批
        dictData[@"flowID"] = _projectFlowID;
    }
    else
    {
        dictData[@"flowID"] = [[[newaudit objectForKey:@"FlowInformations"] firstObject]stringValueForKey:@"flowID" defaultValue:@""];

    }
    dictData[@"sum"] = [NSString stringWithFormat:@"%d",[self.accountreceivable intValue]+[self.servicecharge intValue]];
    NSMutableArray *traContacts = [[NSMutableArray alloc]init];
    
    for (BePassengerModel *personM in _passengers) {
        NSMutableDictionary *member = [NSMutableDictionary dictionary];
        member[@"name"] = personM.psgname;
        member[@"mobile"] = personM.mobilephone;
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
