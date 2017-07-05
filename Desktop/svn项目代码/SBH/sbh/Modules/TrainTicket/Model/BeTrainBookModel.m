//
//  BeTrainBookModel.m
//  sbh
//
//  Created by RobinLiu on 15/6/23.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTrainBookModel.h"
#import "projectObj.h"
#import "selectContact.h"
#import "selectPerson.h"

@implementation BeTrainBookModel
- (id)init
{
    if(self = [super init])
    {
        _servicemoney = @"";
        _TrainCode = @"";
        _StartCity = @"";
        _EndTime = @"";
        _EndCity = @"";
        _CostTime = @"";
        _StartTime = @"";
        _TrainType = @"";
        _SDate = @"";
        _selectSeat = @"";
        _selectSeatCode = @"";
        _selectPrice = @"";
        _selectCount = @"";
        _guidSearch = @"";
        _projectArray = [[NSMutableArray alloc]init];
        _contactArray = [[NSMutableArray alloc]init];
        _passengerArray = [[NSMutableArray alloc]init];
        _toStationCode = @"";
        _fromStationCode = @"";
        _orderNo = @"";
    }
    return self;
}
- (void)clearCache
{
    [_projectArray removeAllObjects];
    [_contactArray removeAllObjects];
    [_passengerArray removeAllObjects];
    _orderNo = @"";
}
- (void)configureTrainInfoWithModel:(BeTrainTicketListModel *)model
{
    _TrainCode = [model.TrainCode mutableCopy];// = D311,//列车车次
    _StartCity = [model.StartCity mutableCopy];//出发城市
    _EndTime = [model.EndTime mutableCopy];// = 08:58,//到达时间
    _EndCity = [model.EndCity mutableCopy];// = 上海,//到达城市
    _CostTime = [model.CostTime mutableCopy];// = 11:42,//运行时间
    _StartTime = [model.StartTime mutableCopy];//= 21:16,//出发时间
    _TrainType = [model.TrainType mutableCopy];// = 动车,//列车等级
    _SDate = [model.SDate mutableCopy];//日期//出发日期
    _toStationCode = [model.endStationCode mutableCopy];
    _fromStationCode = [model.startStationCode mutableCopy];
}
- (void)configureTrainInfoWithOrderModel:(BeTrainOrderInfoModel *)model
{
    BeTrainInfoModel *trainModel = [model.traininfolist firstObject];
    _TrainCode = [trainModel.trainno mutableCopy];
    _StartCity = [trainModel.boardpointname mutableCopy];//出发城市
    _EndCity = [trainModel.offpointname mutableCopy];// = 上海,//到达城市
    _StartTime = [trainModel.departtime mutableCopy];//= 21:16,//出发时间
    _SDate = [trainModel.departdate mutableCopy];
    _EndTime = [trainModel.arrivatime mutableCopy];// = 08:58,//到达时间
    int hour = [trainModel.runTime intValue]/60;
    int minute = [trainModel.runTime intValue]%60;
    _CostTime = [NSString stringWithFormat:@"%d:%d",hour,minute];
    for(BeTrainPassengerModel *passenger in model.psglist)
    {
        _selectSeat = passenger.ticketclassname;
       break;
    }
    NSArray *passengerArray = [model.dict objectForKey:@"Passenger"];
    for (NSDictionary *memberDict in passengerArray)
    {
        selectPerson *selCon = [[selectPerson alloc] init];
        selCon.iName = [memberDict objectForKey:@"PsgName"];
        selCon.iCredNumber = [memberDict objectForKey:@"CardNo"];
        [_passengerArray addObject:selCon];
    }
    float onePrice = [model.ticketpricetotal floatValue]/[passengerArray count];
    _selectPrice = [NSString stringWithFormat:@"%f",onePrice];
    _orderNo = model.orderno;
     NSString *isExpense = [model.dict objectForKey:@"iscustomized"];
     NSString *isPro = [model.dict objectForKey:@"isprojectname"];
     NSString *isRea = [model.dict objectForKey:@"isreasons"];
     NSString *projectCode = [model.dict objectForKey:@"isprojectno"];
     //费用中心
     if ([isExpense isEqualToString:@"Y"]) {
     projectObj * aobj = [[projectObj alloc] init];
     aobj.projectCode = @"expensecenter";
     aobj.projectName = @"费用中心";
     aobj.projectValue= [model.dict objectForKey:@"ExpenseCenter"];
     aobj.isShow = YES;
     aobj.isRequired = YES;
     [_projectArray addObject:aobj];
     }
     
     //项目编号
     if ([projectCode isEqualToString:@"Y"]) {
     projectObj * pronamebj = [[projectObj alloc] init];
     pronamebj.projectCode = @"projectcode";
     pronamebj.projectName = @"项目编号";
     pronamebj.projectValue= [model.dict objectForKey:@"ProjectNo"];
     pronamebj.isShow = YES;
     pronamebj.isRequired = NO;
     [_projectArray addObject:pronamebj];
     }
     //项目名称
     if ([isPro isEqualToString:@"Y"]) {
     projectObj * pronamebj = [[projectObj alloc] init];
     pronamebj.projectCode = @"projectname";
     pronamebj.projectName = @"项目名称";
     pronamebj.projectValue= [model.dict objectForKey:@"ProjectName"];
     pronamebj.isShow = YES;
     pronamebj.isRequired = NO;
     [_projectArray addObject:pronamebj];
     }
     //出差原因
     if ([isRea isEqualToString:@"1"]) {
     projectObj *resonbj = [[projectObj alloc] init];
     resonbj.projectName = @"出行原因";
     resonbj.projectCode = @"reason";
     resonbj.projectValue= [model.dict objectForKey:@"BusinessReasons"];
     resonbj.isShow = YES;
     resonbj.isRequired = YES;
     [_projectArray addObject:resonbj];
     }
     // 联系人
     NSArray *array = [model.dict objectForKey:@"Linkmans"];
     for (NSDictionary *memberDict in array)
     {
         selectContact *selCon = [[selectContact alloc] init];
         selCon.iName = [memberDict objectForKey:@"ContactsName"];
         selCon.iMobile = [memberDict objectForKey:@"ContactsPhone"];
         selCon.iPhone = [memberDict objectForKey:@"ContactsPhone"];
         selCon.iEmail = [memberDict objectForKey:@"Email"];
         selCon.PerType = [memberDict objectForKey:@"PerType"];
         selCon.FlowType = [memberDict objectForKey:@"FlowType"];
         selCon.LoginName = [GlobalData getSharedInstance].userModel.loginname;
         [_contactArray addObject:selCon];
     }
}
@end
