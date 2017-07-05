//
//  BeTrainResultItem.h
//  sbh
//
//  Created by RobinLiu on 15/6/15.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeTrainTicketFilterConditions.h"
#import "BeTrainTicketListModel.h"

@interface BeTrainResultItem : NSObject
@property (nonatomic,retain)NSMutableArray *listArray;
@property (nonatomic,retain)NSMutableArray *filterArray;
@property (nonatomic,retain)NSString *guid;
@property (nonatomic,assign)BOOL timeUp;
@property (nonatomic,assign)BOOL priceUp;
@property (nonatomic,assign)BOOL isFilter;
@property (nonatomic,assign)BOOL isDuration;
@property (nonatomic,assign)BOOL isDataException;
- (void)setDataWithDict:(NSDictionary *)dict;
- (void)filterWithItem:(BeTrainTicketFilterConditions *)item;
- (void)sortTime;
- (void)sortPrice;
- (void)sortDuration;
- (void)clearAllData;
- (void)clearAllFilterConditions;

@end
