//
//  BeRoomDetailModel.m
//  SideBenefit
//
//  Created by SBH on 15-3-11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeRoomDetailModel.h"
#import "NSDictionary+Additions.h"
#import "CommonDefine.h"
#import "SBHUserModel.h"

#define kDetailHotelDefaultText @""
#define kNoContainsBreakfastConditions @"无停留"
@implementation BeRoomDetailModel
- (void)setDescription:(NSString *)Description
{
    _Description = Description;
    self.desArray = [self.Description componentsSeparatedByString:@"、"];
}
- (void)setPolicyName:(NSString *)PolicyName
{
    if ([PolicyName rangeOfString:kNoContainsBreakfastConditions].location != NSNotFound && [PolicyName rangeOfString:@"("].location != NSNotFound) {
        _PolicyName = [PolicyName substringToIndex:[PolicyName rangeOfString:@"("].location];
    }
    else
    {
        _PolicyName = PolicyName;
    }
}
- (void)setFacilities:(NSString *)Facilities
{
    _Facilities = Facilities;
    _broudbandStatus = [self showFacilityWith:_Facilities];
}
- (void)setSpENT:(NSString *)SpENT
{
    _SpENT = SpENT;
    if([[SBHUserModel getSharedInstance].entId isEqualToString: _SpENT])
    {
        _showProtocal = YES;
    }
}
- (void)setIsNoStop:(NSString *)IsNoStop
{
    _IsNoStop = IsNoStop;
    if([_IsNoStop isEqualToString:@"True"])
    {
        _showNoStop = YES;
    }
    else
    {
        _showNoStop = NO;
    }
}
- (void)setPolicyRemark:(NSString *)PolicyRemark
{
    if(![PolicyRemark isEqualToString:@"null"]&& [PolicyRemark length]!=0&&PolicyRemark!=nil)
    {
        _PolicyRemark = PolicyRemark;
    }
    else
    {
        _PolicyRemark = @"";
    }
}
- (NSString *)showFacilityWith:(NSString *)facility
{
    NSString * Msg = @"无";
    NSArray * array = [facility componentsSeparatedByString:@","];
    if (array == nil
        || array.count <1 )
    {
        return Msg;
    }
    if ([array containsObject:@"62"])
    {
        Msg = @"无";
    }
    else if ([array containsObject:@"65"])
    {
        Msg = @"免费无线";
    }
    else if ([array containsObject:@"66"])
    {
        Msg = @"收费无线";
    }
    else if ([array containsObject:@"67"])
    {
        Msg = @"免费有线";
    }
    else if ([array containsObject:@"68"])
    {
        Msg = @"收费有线";
    }
    else if ([array containsObject:@"69"])
    {
        Msg = @"免费无线";
    }
    else if ([array containsObject:@"70"])
    {
        Msg = @"收费无线";
    }
    else if ([array containsObject:@"71"])
    {
        Msg = @"免费有线";
    }
    else if ([array containsObject:@"72"])
    {
        Msg = @"收费有线";
    }
    else if ([array containsObject:@"63"])
    {
        Msg = @"收费有线";
    }
    else if ([array containsObject:@"64"])
    {
        Msg = @"收费有线";
    }
    return Msg;
}
- (void)setBroadnetAccess:(NSString *)BroadnetAccess
{
    if ([BroadnetAccess isEqualToString:@"0"]) {
        _BroadnetAccess = @"无宽带";
    } else if ([BroadnetAccess isEqualToString:@"1"]) {
        _BroadnetAccess = @"免费无线";
    } else if ([BroadnetAccess isEqualToString:@"2"]) {
        _BroadnetAccess = @"免费有线";
    } else if ([BroadnetAccess isEqualToString:@"3"]) {
        _BroadnetAccess = @"收费有线";
    } else if ([BroadnetAccess isEqualToString:@"4"]) {
        _BroadnetAccess = @"收费无线";
    }
}
- (void)setRoomArea:(NSString *)RoomArea
{
    if([RoomArea isEqualToString:kDetailHotelDefaultText])
    {
        _RoomArea = RoomArea;
    }
    else
    {
        _RoomArea = [NSString stringWithFormat:@"%@㎡",RoomArea];
    }
}
- (void)setModelDataWithDict:(NSDictionary *)dict
{
    self.SpENT = [dict stringValueForKey:@"SpENT" defaultValue:@""];
    self.ImageURL = [dict stringValueForKey:@"ImageURL" defaultValue:@""];
    self.Description = [dict stringValueForKey:@"Description" defaultValue:@""];
    self.IsNoStop = [dict stringValueForKey:@"IsNoStop" defaultValue:@""];
    self.SalePrice = [dict stringValueForKey:@"SalePrice" defaultValue:kDetailHotelDefaultText];
    self.BedType = [dict stringValueForKey:@"BedType" defaultValue:kDetailHotelDefaultText];
    self.RoomArea = [dict stringValueForKey:@"RoomArea" defaultValue:kDetailHotelDefaultText];
    self.BroadnetAccess = [dict stringValueForKey:@"BroadnetAccess" defaultValue:@""];
    self.CancelState = [dict stringValueForKey:@"CancelState" defaultValue:@""];
    self.RoomName = [dict stringValueForKey:@"RoomName" defaultValue:kDetailHotelDefaultText];
    self.PolicyName = [dict stringValueForKey:@"PolicyName" defaultValue:@""];
    self.desArray = [self.Description componentsSeparatedByString:@"、"];
    if([[self.desArray firstObject]length]>0 &&[self.desArray firstObject]!=nil)
    {
        self.bedWidthDescription = [self.desArray firstObject];
    }
    else
    {
        self.bedWidthDescription = self.BedType;
    }
    self.PolicyId = [dict stringValueForKey:@"PolicyId" defaultValue:@""];
    self.HotelName = [dict stringValueForKey:@"HotelName" defaultValue:kDetailHotelDefaultText];
    self.HotelId = [dict stringValueForKey:@"HotelId" defaultValue:@""];
    self.RoomCode = [dict stringValueForKey:@"RoomCode" defaultValue:@""];
    self.JoinRoomId = [dict stringValueForKey:@"JoinRoomId" defaultValue:@""];
    self.Facilities = [dict stringValueForKey:@"Facilities" defaultValue:@""];
    self.PolicyRemark = [dict stringValueForKey:@"PolicyRemark" defaultValue:@""];
    int state = [dict intValueForKey:@"fangtai" defaultValue:0];
    if(state == 2)
    {
        self.roomBookState = HotelDetailRoomStateFullBooked;
    }
     else
    {
        self.roomBookState = HotelDetailRoomStateCanBeBooked;
    }
    int cancelStatus = [dict intValueForKey:@"CancelState" defaultValue:2];
    //取消状态1显示变更取消2不可变更取消3免费取消
    switch (cancelStatus) {
        case 0:
        {
            self.CancelState = kCannotBeCanceledTitle;
            self.CancelDes = kCannotBeCanceledContent;
        }
            break;
        case 1:
        {
            self.CancelState = kTimeLimitToCancelTitle;
            self.CancelDes = [dict stringValueForKey:@"CancelDes" defaultValue:kDetailHotelDefaultText];
        }
            break;
        case 2:
        {
            self.CancelState = kCannotBeCanceledTitle;
            self.CancelDes = kCannotBeCanceledContent;
        }
            break;
        case 3:
        {
            self.CancelState = kFreeCancelTitle;
            self.CancelDes = kFreeCancelContent;
        }
            break;
        default:
            break;
    }
}
@end
