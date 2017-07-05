//
//  gongsilianxirenController.h
//  sbh
//
//  Created by musmile on 14-7-7.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "BaseViewController.h"
#import "selectContact.h"

typedef NS_ENUM(NSInteger,ContactViewControllerSourceType)
{
    ContactSourceTypeEdit = 0,
    ContactSourceTypeAdd = 1,
};
typedef void(^SelectContactBlock) (selectContact *selectedModel);
@interface gongsilianxirenController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *itabview;
@property (nonatomic,strong)selectContact *contactModel;
@property (nonatomic,assign)ContactViewControllerSourceType sourceType;
@property (nonatomic,copy)SelectContactBlock block;
- (IBAction)save:(id)sender;
@end
