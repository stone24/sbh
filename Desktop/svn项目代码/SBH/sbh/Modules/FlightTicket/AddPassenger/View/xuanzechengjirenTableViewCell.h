//
//  xuanzechengjirenTableViewCell.h
//  SBHAPP
//
//  Created by musmile on 14-7-6.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface xuanzechengjirenTableViewCell : UITableViewCell
{
    IBOutlet UILabel * iUserName;
    IBOutlet UILabel * iUserJob;
    IBOutlet UILabel * iUserSex;
    IBOutlet UILabel * iPhoneNum;
    IBOutlet UILabel * iUserCercode;
    IBOutlet UIButton* iSelectButton;
    
    BOOL isSelect;
}
@property (weak, nonatomic) IBOutlet UILabel *iemail;
@property (weak, nonatomic) IBOutlet UIButton *cute;
@property (weak, nonatomic) IBOutlet UIImageView *cute1;

@property(nonatomic,strong)UILabel * iPhoneNum;
@property(nonatomic,strong)UILabel * iUserName;
@property(nonatomic,strong)UILabel * iUserJob;
@property(nonatomic,strong)UILabel * iUserSex;
@property(nonatomic,strong)UILabel * iUserCode;
@property(nonatomic,strong)UILabel * iUserCercode;
@property(nonatomic,strong)UIButton* iSelectButton;
@property(nonatomic,readwrite)BOOL isSelect;

-(IBAction)selectBtAction:(id)sender;

@end
