//
//  BeHotelDetailSectionModel.m
//  sbh
//
//  Created by RobinLiu on 15/12/10.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelDetailSectionModel.h"
#import "BeHotelRoomListFrame.h"

#import "NSDictionary+Additions.h"
@implementation BeHotelDetailRoomAmenity
@end
@implementation BeHotelRegulationModel
- (id)init
{
    if(self = [super init])
    {
        _Id = @"";
        _Hotel_Id = @"";
        _Rul_ArrAndDep = @"";
        _Rul_Cancel = @"";
        _Rel_DepAndPre = @"";
        _Rel_Pet = @"";
        _Rel_Requirements = @"";
        _Rel_CheckIn = @"";
        _Rel_CheckOut = @"";
    }
    return self;
}
- (id)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        _Id = [dict stringValueForKey:@"Id" defaultValue:@""];
        _Hotel_Id = [dict stringValueForKey:@"Hotel_Id" defaultValue:@""];
        _Rul_ArrAndDep = [dict stringValueForKey:@"Rul_ArrAndDep" defaultValue:@""];
        _Rul_Cancel = [dict stringValueForKey:@"Rul_Cancel" defaultValue:@""];
        _Rel_DepAndPre = [dict stringValueForKey:@"Rel_DepAndPre" defaultValue:@""];
        _Rel_Pet = [dict stringValueForKey:@"Rel_Pet" defaultValue:@""];
        _Rel_Requirements = [dict stringValueForKey:@"Rel_Requirements" defaultValue:@""];
        _Rel_CheckIn = [dict stringValueForKey:@"Rel_CheckIn" defaultValue:@""];
        _Rel_CheckOut = [dict stringValueForKey:@"Rel_CheckOut" defaultValue:@""];
    }
    return self;
}

@end
@implementation BeHotelDetailRoomListModel
- (id)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        _RoomAmenities = [[NSMutableArray alloc]init];
        _Hotel_Id = [dict stringValueForKey:@"Hotel_Id" defaultValue:@""];
        _Room_Name = [dict stringValueForKey:@"Room_Name" defaultValue:@""];
        _Room_BedCode = [dict stringValueForKey:@"Room_BedCode" defaultValue:@""];
         _Room_BedName = [dict stringValueForKey:@"Room_BedName" defaultValue:@""];
         _Room_Image = [dict stringValueForKey:@"Room_Image" defaultValue:@""];
         _Room_Facilities = [dict stringValueForKey:@"Room_Facilities" defaultValue:@""];
         _Dr_Amount = [dict stringValueForKey:@"Dr_Amount" defaultValue:@""];
         _RoomNetWorkChange = [dict stringValueForKey:@"RoomNetWorkChange" defaultValue:@""];
         _Room_Size = [dict stringValueForKey:@"Room_Size" defaultValue:@""];
         _Room_NonSmoking = [dict stringValueForKey:@"Room_NonSmoking" defaultValue:@""];
         _Room_StandardOccupancy = [dict stringValueForKey:@"Room_StandardOccupancy" defaultValue:@""];
         _Room_Floor = [dict stringValueForKey:@"Room_Floor" defaultValue:@""];
         _Id = [dict stringValueForKey:@"Id" defaultValue:@""];
         _Room_Id = [dict stringValueForKey:@"Room_Id" defaultValue:@""];
         _Rp_Id = [dict stringValueForKey:@"Rp_Id" defaultValue:@""];
         _Rp_Name = [dict stringValueForKey:@"Rp_Name" defaultValue:@""];
         _Rp_Description = [dict stringValueForKey:@"Rp_Description" defaultValue:@""];
         _Rp_Type = [dict stringValueForKey:@"Rp_Type" defaultValue:@""];
         _Rp_IsCommissionabl = [dict stringValueForKey:@"Rp_IsCommissionabl" defaultValue:@""];
         _Rp_RateReturn = [dict stringValueForKey:@"Rp_RateReturn" defaultValue:@""];
         _Rp_MarketCode = [dict stringValueForKey:@"Rp_MarketCode" defaultValue:@""];
         _Rp_NetWork = [dict stringValueForKey:@"Rp_NetWork" defaultValue:@""];
         _Rp_Breakfast = [dict stringValueForKey:@"Rp_Breakfast" defaultValue:@""];
         _Rp_Guarantee = [dict stringValueForKey:@"Rp_Guarantee" defaultValue:@""];
         _Rp_GuaranteeForm = [dict stringValueForKey:@"Rp_GuaranteeForm" defaultValue:@""];
         _Rp_ChancelStatus = [dict stringValueForKey:@"Rp_ChancelStatus" defaultValue:@""];
         _Rp_ChancelDecription = [dict stringValueForKey:@"Rp_ChancelDecription" defaultValue:@""];
         _Source = [dict stringValueForKey:@"Source" defaultValue:@""];
         _Source_Code = [dict stringValueForKey:@"Source_Code" defaultValue:@""];
         _Rp_CreateDate = [dict stringValueForKey:@"Rp_CreateDate" defaultValue:@""];
         _Rp_LastUpdateDate = [dict stringValueForKey:@"Rp_LastUpdateDate" defaultValue:@""];
         _Rp_IsValid = [dict stringValueForKey:@"Rp_IsValid" defaultValue:@""];
         _Dr_SellStatus = [dict stringValueForKey:@"Dr_SellStatus" defaultValue:@""];
         _Dr_PromotionPrice = [dict stringValueForKey:@"Dr_PromotionPrice" defaultValue:@""];
    }
    return self;
}
@end
@implementation BeHotelDetailSectionModel
- (id)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        _isSread = NO;
        _Id = [dict stringValueForKey:@"Id" defaultValue:@""];
        _Dr_Amount = [dict stringValueForKey:@"Dr_Amount" defaultValue:@""];
        _Room_Image = [dict stringValueForKey:@"Room_Image" defaultValue:@""];
        _Room_Name = [dict stringValueForKey:@"Room_Name" defaultValue:@""];
        
        _cellArray = [[NSMutableArray alloc]init];
        _cellDisplayArray = [[NSMutableArray alloc]init];
        NSMutableArray *facilityArray = [[NSMutableArray alloc]init];
        for(NSDictionary *facilityDict in [dict objectForKey:@"RoomAmenities"])
        {
            BeHotelDetailRoomAmenity *facility = [[BeHotelDetailRoomAmenity alloc]init];
            facility.RA_Description = [facilityDict objectForKey:@"RA_Description"];
            facility.RA_Type = [facilityDict objectForKey:@"RA_Type"];
            [facilityArray addObject:facility];
        }
        for(NSDictionary *listMember in [dict objectForKey:@"RatePlanInfo"])
        {
            BeHotelDetailRoomListModel *listModel = [[BeHotelDetailRoomListModel alloc]initWithDict:listMember];
            [listModel.RoomAmenities addObjectsFromArray:facilityArray];
            [_cellArray addObject:listModel];
            
            BeHotelRoomListDisplayModel *displayModel = [[BeHotelRoomListDisplayModel alloc]init];
            displayModel.listModel = listModel;
            
            BeHotelRoomListFrame *listFrame = [[BeHotelRoomListFrame alloc]init];
            listFrame.displayModel = displayModel;
            [_cellDisplayArray addObject:listFrame];
        }
    }
    return self;
}
@end
