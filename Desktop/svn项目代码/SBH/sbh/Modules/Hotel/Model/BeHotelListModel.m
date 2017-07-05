//
//  BeHotelListModel.m
//  SideBenefit
//
//  Created by RobinLiu on 15/3/14.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelListModel.h"
#import "NSDictionary+Additions.h"
#import "BeHotelListItem.h"

@implementation BeHotelListModel
- (id)initConfigure
{
    if(self = [super init])
    {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)setListModelWithDict:(NSDictionary *)dict andCityName:(NSString *)cityName andCheckInDate:(NSString *)checkInDateString andCheckOutDate:(NSString *)checkOutDateString
{
    /*
     {
     code = 20020;
     guid = "ceae6120-7c07-4f6e-b520-78f49c522baa";
     hinfo =     (
          );
     pagecount = 1;
     pagenum = 1;
     pagesize = 10;
     status = true;
     totalcount = 1;
     }
     */
    self.pageNum = [dict intValueForKey:@"pageIndex"];
    self.pageSize = [dict intValueForKey:@"pageSize"];
    self.pageCount = [dict intValueForKey:@"pageCount"];
    self.totalCount = [dict intValueForKey:@"recordCount"];
    self.status = [dict stringValueForKey:@"status"];
    self.code = [dict intValueForKey:@"code"];
   // self.guid = [dict stringValueForKey:@"guid"];
    if(self.pageNum == 1)
    {
        [self.dataArray removeAllObjects];
    }
   // NSMutableArray *filterArray = [NSMutableArray array];
    for(NSDictionary *containObject in [dict arrayValueForKey:@"listT"])
    {
        BeHotelListItem *item = [[BeHotelListItem alloc]init];
        [item setItemWithDict:containObject];
        item.CheckInDate = checkInDateString;
        item.CheckOutDate = checkOutDateString;
        item.cityName = cityName;
        //[filterArray addObject:item];
        [self.dataArray addObject:item];
    }
    /*NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    NSArray *sortedArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    [self.dataArray addObjectsFromArray:sortedArray];*/
}

@end
