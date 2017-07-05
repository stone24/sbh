//
//  BeOrderWriteFlightInfoModel.m
//  sbh
//
//  Created by SBH on 15/5/8.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeOrderWriteModel.h"
#import "NSDictionary+Additions.h"
@implementation BeOrderInsuranceModel
- (id)init
{
    if(self = [super init])
    {
        
    }
    return self;
}
@end
@implementation BeOrderWriteModel
- (id)init
{
    if(self = [super init])
    {
        _belongfunction = @"";
        _projectAuditPersonArray = [[NSMutableArray alloc]init];
        _otherAuditPersonArray = [[NSMutableArray alloc]init];
        _selectedAuditPersonArray = [[NSMutableArray alloc]init];
        _insuranceArray = [[NSMutableArray alloc]init];
        _selectedProject = [[BeAuditProjectModel alloc]init];
        _TicketId = @"";
        _selectedProject = [[BeAuditProjectModel alloc]init];
        _isContactCanEdit = YES;
        _selectPassArr = [[NSMutableArray alloc]init];
        _companyContactArray = [[NSMutableArray alloc]init];
        _projectArray = [[NSMutableArray alloc]init];
        _insuranceDict = [[NSMutableDictionary alloc]init];
        _showProjectReasons = YES;
        _maxPassengerCount = 9;
        _verifypassengers = @"1";
    }
    return self;
}
- (void)setupDataWithDict:(NSDictionary *)dict
{
    if([GlobalData getSharedInstance].iTiketOrderInfo.travelReason == kTravelReasonTypePrivate)
    {
        //因私支付时，不需要审批
        self.auditType = AuditTypeNone;
    }
    else if([[GlobalData getSharedInstance].isnewaudit isEqualToString:@"1"])
    {
        //新审批
        self.auditType = AuditTypeWithoutProject;
    }
    else if([dict arrayValueForKey:@"contactList"]!= nil)
    {
        if([dict arrayValueForKey:@"contactList"].count == 0|| [GlobalData getSharedInstance].iTiketOrderInfo.travelReason == kTravelReasonTypePrivate)
        {
            //没有审批
            self.auditType = AuditTypeNone;
        }
        else
        {
            //老审批
            self.auditType = AuditTypeOld;
            BeOrderWriteAuditInfoModel *model = [BeOrderWriteAuditInfoModel mj_objectWithKeyValues:[[dict arrayValueForKey:@"contactList"] firstObject]];
            model.displayLevel = @"审批人";
            [_selectedAuditPersonArray addObject:model];
        }
    }
    else
    {
        //没有审批
        self.auditType = AuditTypeNone;
    }
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
    if(sourceType == OrderFinishSourceTypeOrderDetail)
    {
        if([[GlobalData getSharedInstance].isnewaudit isEqualToString:@"0"])
        {
            //新审批
            self.auditType = AuditTypeNone;
        }
        else if([[[dict dictValueForKey:@"newaudit"] allKeys] count]!=0)
        {
            if([[dict dictValueForKey:@"newaudit"] objectForKey:@"FlowInformations"]!=nil)
            {
                //新审批
                NSDictionary *newaudit = [dict dictValueForKey:@"newaudit"];
                _TicketId = [newaudit stringValueForKey:@"TicketId" defaultValue:@""];
                if([_TicketId length] < 1)
                {
                    
                }
                //获取项目审批人的数组信息
                for(NSDictionary *member in [newaudit arrayValueForKey:@"FlowInformations"])
                {
                    if([[member stringValueForKey:@"type"] isEqualToString:@"3"])
                    {
                        [_projectAuditPersonArray addObjectsFromArray: [BeOrderWriteModel setupAuditArrayWith:[member arrayValueForKey:@"approvars"]]];
                    }
                }
                
                NSString *UsabledFlowType = [newaudit stringValueForKey:@"UsabledFlowType" defaultValue:@""];
                NSArray *typeArray = [UsabledFlowType componentsSeparatedByString:@","];
                
                BOOL containsProject = [typeArray containsObject:@"3"];
                BOOL containsOther = NO;
                
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
                        [_selectedAuditPersonArray addObjectsFromArray:_projectAuditPersonArray];
                    }
                    else
                    {
                        self.auditType = AuditTypeNone;
                        
                    }
                }
            }
        }

    }
    else
    {
        if(self.auditType == AuditTypeNone || self.auditType == AuditTypeOld)
        {
            return;
        }
        if([[[dict dictValueForKey:@"newaudit"] allKeys] count]!=0)
        {
            if([[dict dictValueForKey:@"newaudit"] objectForKey:@"FlowInformations"]!=nil)
            {
                //新审批
                NSDictionary *newaudit = [dict dictValueForKey:@"newaudit"];
                _TicketId = [newaudit stringValueForKey:@"TicketId" defaultValue:@""];
                if([_TicketId length] < 1)
                {
                    
                }
                //获取项目审批人的数组信息
                for(NSDictionary *member in [newaudit arrayValueForKey:@"FlowInformations"])
                {
                    if([[member stringValueForKey:@"type"] isEqualToString:@"3"])
                    {
                        [_projectAuditPersonArray addObjectsFromArray: [BeOrderWriteModel setupAuditArrayWith:[member arrayValueForKey:@"approvars"]]];
                    }
                }
                
                NSString *UsabledFlowType = [newaudit stringValueForKey:@"UsabledFlowType" defaultValue:@""];
                NSArray *typeArray = [UsabledFlowType componentsSeparatedByString:@","];
                
                BOOL containsProject = [typeArray containsObject:@"3"];
                BOOL containsOther = NO;
                
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
                        [_selectedAuditPersonArray addObjectsFromArray:_projectAuditPersonArray];
                    }
                    else
                    {
                        self.auditType = AuditTypeNone;
                        
                    }
                }
            }
        }
    }
}
- (int)getAllPrice
{
    float totalPrice = 0;
    for(BeOrderInsuranceModel *insuModel in _insuranceArray)
    {
        totalPrice = totalPrice + insuModel.insuranceCount * [insuModel.insurancePrice intValue];
    }
    totalPrice = totalPrice * _airlist.count;
    totalPrice = totalPrice + [[_airlist.firstObject totaladt] intValue];
    if(_airlist.count > 1)
    {
        totalPrice = totalPrice + [[_airlist.lastObject totaladt] intValue];
    }
    totalPrice = totalPrice * [_selectPassArr count];
    return totalPrice;
}
@end
