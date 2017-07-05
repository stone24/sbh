//
//  BeChoosePassengerController.h
//  sbh
//
//  Created by SBH on 15/7/22.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BaseViewController.h"
#import "selectPerson.h"

//typedef enum {
//    BeChoosePersonTypeSpe,
//    BeChoosePersonTypeTrain,
//    BeChoosePersonTypeAirFlight,
//    BeChoosePersonTypeHotel
//} BeChoosePersonType;
typedef void(^ChoosePassengerBlock) (NSMutableArray *selectedArray);

@interface BeChoosePassengerController : BaseViewController
{
    NSMutableArray * contactArray;
    BOOL isSelect;
    BOOL isSelect1;
    BOOL isSelect2;
    BOOL isSelect3;
    BOOL isSelect4;
    BOOL isSelect5;
    BOOL isSelect6;
    selectPerson *iselPerson;
}

@property (weak, nonatomic) IBOutlet UITableView *itableview;
@property (nonatomic, assign) int chengjrNum;
@property (nonatomic, strong) NSMutableArray *selchengjr;
@property (nonatomic,assign)int roomNum;
@property (nonatomic,copy)ChoosePassengerBlock block;
- (id)init:(NSString *)str object:(selectPerson *)selPerson;
@end





