//
//  BeHotelListIterm.m
//  SideBenefit
//
//  Created by RobinLiu on 15/3/14.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelListItem.h"
#import "NSDictionary+Additions.h"
#import "CommonMethod.h"
#import "ServerConfigure.h"
#import "SBHUserModel.h"
#import "AppDelegate.h"

#define kImageVerticalSpace 5.0f
#define kListImageSize 100

@implementation BeHotelListItem

- (id)init
{
    if(self = [super init])
    {
        _canBook = YES;
        _SearchType = @"1";
    }
    return self;
}
- (void)setItemWithDict:(NSDictionary *)dict
{
    self.TravelType  = [dict stringValueForKey:@"TravelType"];

    self.hotelId = [dict stringValueForKey:@"Id"];
    
    self.hotelName = [dict stringValueForKey:@"Hotel_Name"];
    self.hotelAddress = [dict stringValueForKey:@"Hotel_Address"];
    self.addressAdditional = [dict stringValueForKey:@"Hotel_AddressAdditional"];
    
    self.googleLat = [dict stringValueForKey:@"Hotel_Lat"];
    self.googleLon = [dict stringValueForKey:@"Hotel_Lng"];
    
    self.price = [dict stringValueForKey:@"Hotel_TodayLowestPrice"];
   
    self.hotelImageUrl = [dict stringValueForKey:@"Hotel_Image"];
    self.cityId = [dict stringValueForKey:@"City_Code"];
    
    self.reviewScore = [dict stringValueForKey:@"Rate_Comm"];
    self.Hotel_SBHStar = [dict stringValueForKey:@"Hotel_SBHStar"];
    self.Hotel_Star = [dict stringValueForKey:@"Hotel_Star"];
    NSString *introduceString = [dict stringValueForKey:@"Hotel_Introduce" defaultValue:@""];
    NSArray *introduceArray = [introduceString componentsSeparatedByString:@"<br>"];
    NSString *tempString = [NSString string];
    NSMutableArray *tempArray = [NSMutableArray array];
    for(NSString *member in introduceArray)
    {
        if(member.length < 1)
        {
            continue;
        }
        [tempArray addObject:member];
    }
    for(NSString *member in tempArray)
    {
        if(member.length < 1)
        {
            continue;
        }
        tempString = [tempString stringByAppendingString:@"    "];
        tempString = [tempString stringByAppendingString:member];
        if(![[tempArray lastObject]isEqualToString:member])
        {
            tempString = [tempString stringByAppendingString:@"\n"];
        }
    }
    self.Hotel_Introduce = tempString;
    self.facilities = [[NSDictionary alloc]initWithDictionary:[dict dictValueForKey:@"HotFacilityInfo"]];
    if([AppDelegate appdelegate].coordinate.latitude > 0 && [AppDelegate appdelegate].coordinate.longitude > 0)
    {
        CLLocation *orig = [[CLLocation alloc] initWithLatitude:[AppDelegate appdelegate].coordinate.latitude  longitude:[AppDelegate appdelegate].coordinate.longitude];
        CLLocation* dist = [[CLLocation alloc] initWithLatitude:[self.googleLon doubleValue] longitude:[self.googleLat doubleValue] ];
        CLLocationDistance kilometers=[orig distanceFromLocation:dist];
        self.distance = kilometers;
    }
    else
    {
        self.distance = 0;
    }
}
- (UIView *)getFacilitiesImageView
{
   UIView *facilitiesImageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 102, 20)];
    CGPoint startCenter = {0,10};
    /*
     {
     "HHF_IsAirportShuttle" = 1;
     "HHF_IsBreakfast" = 0;
     "HHF_IsCarPark" = 1;
     "HHF_IsConference" = 1;
     "HHF_IsFreeNetWork" = 0;
     "HHF_IsFreeWifi" = 1;
     };
     */
    if([[self.facilities objectForKey:@"HHF_IsFreeWifi"] intValue]==1)
        {
            //免费wifi
            startCenter.x = [UIImage imageNamed:@"hotellist_cell_wifi"].size.width/2+startCenter.x;
            [self addImageWith:@"hotellist_cell_wifi" andCenter:startCenter andBackView:facilitiesImageView];
            startCenter.x = startCenter.x + kImageVerticalSpace+[UIImage imageNamed:@"hotellist_cell_wifi"].size.width/2;
            
        }
        if([[self.facilities objectForKey:@"HHF_IsFreeNetWork"] intValue]==1)
        {
            //免费宽带
            if([[self.facilities objectForKey:@"HHF_IsFreeWifi"] intValue]==1)
            {
                
            }
            else
            {
                startCenter.x = [UIImage imageNamed:@"hotellist_cell_wifi"].size.width/2+startCenter.x;
                [self addImageWith:@"hotellist_cell_wifi" andCenter:startCenter andBackView:facilitiesImageView];
                startCenter.x = startCenter.x + kImageVerticalSpace+[UIImage imageNamed:@"hotellist_cell_wifi"].size.width/2;
            }
        }
        if([[self.facilities objectForKey:@"HHF_IsCarPark"] intValue]==1)
        {
            //免费停车场
            startCenter.x = [UIImage imageNamed:@"hotellist_cell_park"].size.width/2+startCenter.x;
            [self addImageWith:@"hotellist_cell_park" andCenter:startCenter andBackView:facilitiesImageView];
            startCenter.x = startCenter.x + kImageVerticalSpace+[UIImage imageNamed:@"hotellist_cell_park"].size.width/2;
        }
        if([[self.facilities objectForKey:@"HHF_IsAirportShuttle"] intValue]==1)
        {
            //接送
            startCenter.x = [UIImage imageNamed:@"hotellist_cell_shuttle"].size.width/2+startCenter.x;
            [self addImageWith:@"hotellist_cell_shuttle" andCenter:startCenter andBackView:facilitiesImageView];
            startCenter.x = startCenter.x + kImageVerticalSpace+[UIImage imageNamed:@"hotellist_cell_shuttle"].size.width/2;
        }
        if([[self.facilities objectForKey:@"HHF_IsConference"] intValue]==1)
        {
            //会议室
            startCenter.x = [UIImage imageNamed:@"hotellist_cell_meetingroom"].size.width/2+startCenter.x;
            [self addImageWith:@"hotellist_cell_meetingroom" andCenter:startCenter andBackView:facilitiesImageView];
            startCenter.x = startCenter.x + kImageVerticalSpace+[UIImage imageNamed:@"hotellist_cell_meetingroom"].size.width/2;
        }
        if([[self.facilities objectForKey:@"HHF_IsBreakfast"] intValue]==1)
        {
            //酒店餐厅
             startCenter.x = [UIImage imageNamed:@"hotellist_cell_diningroom"].size.width/2+startCenter.x;
            [self addImageWith:@"hotellist_cell_diningroom" andCenter:startCenter andBackView:facilitiesImageView];
            startCenter.x = startCenter.x + kImageVerticalSpace+[UIImage imageNamed:@"hotellist_cell_diningroom"].size.width/2;
        }
    CGRect frame = facilitiesImageView.frame;
    frame.size.width = startCenter.x;
    return facilitiesImageView;
}
- (void)addImageWith:(NSString *)imageName andCenter:(CGPoint)center andBackView:(UIView *)back
{
    UIImage *ig = [UIImage imageNamed:imageName];
    CGRect frame = CGRectMake(0,0,ig.size.width,ig.size.height);
    UIImageView *imageV = [[UIImageView alloc]initWithImage:ig];
    imageV.frame = frame;
    imageV.center = center;
    [back addSubview:imageV];
}
@end
