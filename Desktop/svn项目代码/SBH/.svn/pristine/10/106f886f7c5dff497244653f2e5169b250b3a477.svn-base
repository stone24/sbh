//
//  NSMutableArray+Additions.m
//  SideBenefit
//
//  Created by RobinLiu on 15/3/12.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "NSMutableArray+Additions.h"
#import "NSString+Additions.h"
#import "CityData.h"

@implementation NSMutableArray (Additions)

- (NSMutableArray *)sortWithFirstCharacter
{
    return nil;
}
- (NSMutableDictionary *)sortForFirstCharacter
{
    /*
     city.iCityName = [rs stringForColumn:@"CityName"];
     city.cityId = [rs stringForColumn:@"CityId"];
     city.provinceId = [rs stringForColumn:@"ProvinceId"]
     */
    NSMutableArray *keyArrays = [NSMutableArray array];
    NSMutableArray *valueArrays = [NSMutableArray array];
    for (CityData *member in self) {
        NSString *firstCh = [[[member.iCityName getPinyinCharacter] substringToIndex:1] uppercaseString];
        if([keyArrays containsObject:firstCh])
        {
           [[valueArrays objectAtIndex:[keyArrays indexOfObject:firstCh]]addObject:member];
        }
        else
        {
            [keyArrays addObject:firstCh];
            NSMutableArray *childValueArray = [[NSMutableArray alloc]initWithObjects:member,nil];
            [valueArrays addObject:childValueArray];
        }
    }
    NSMutableArray *objectArray = [[NSMutableArray alloc]init];
    for(NSMutableArray *object in valueArrays)
    {
        NSArray *sortedArray=[object sortedArrayUsingComparator:^(id a, id b) {
            CityData *aCity = (CityData *)a;
            CityData *bCity = (CityData *)b;
            return [[aCity.iCityName getPinyinCharacter] compare:[bCity.iCityName getPinyinCharacter]];
            
        }];
        [objectArray addObject:sortedArray];
    }
    NSMutableDictionary *sortDict = [[NSMutableDictionary alloc]initWithObjects:objectArray forKeys:keyArrays];
    return sortDict;
}

@end
