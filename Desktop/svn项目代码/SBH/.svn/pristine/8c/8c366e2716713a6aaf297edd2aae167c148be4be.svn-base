//
//  BeHotelOrderContactTableViewCell.m
//  sbh
//
//  Created by RobinLiu on 15/12/15.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelOrderContactTableViewCell.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "CommonDefine.h"

@implementation BeHotelOrderContactTableViewCell
+ (CGFloat)cellHeight
{
    return 2 * 40.0f;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeHotelOrderContactTableViewCellIdentifier";
    BeHotelOrderContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeHotelOrderContactTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        NSArray *titleArray = @[@"联系人",@"手机"];
        for(int i = 0 ;i < titleArray.count ;i ++)
        {
            UILabel *personTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 85, 20)];
            personTitleLabel.centerY = 20.0 + i * 40;
            personTitleLabel.font = [UIFont systemFontOfSize:15];
            personTitleLabel.textColor = [ColorUtility colorFromHex:0x1d1d1d];
            personTitleLabel.text = [titleArray objectAtIndex:i];
            [self addSubview:personTitleLabel];
            
            UITextField *personTF = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, kScreenWidth - 40 - 85 - 15 - 10, 20)];
            personTF.centerY = personTitleLabel.centerY;
            personTF.textAlignment = NSTextAlignmentRight;
            personTF.clearButtonMode = UITextFieldViewModeWhileEditing;
            personTF.font = [UIFont systemFontOfSize:15];
            [self addSubview:personTF];
            UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(13, 0, 0, 0.3)];
            sepLine.backgroundColor = [UIColor lightGrayColor];
            sepLine.width = kScreenWidth - 13 - 40;
            sepLine.y = 40 - 0.3 + 40 *i;
            if(i != 1)
            {
                [self addSubview:sepLine];
            }

            if(i == 0)
            {
                self.contactNameTF = personTF;
                self.nameLabel = personTitleLabel;
            }
            else if(i == 1)
            {
                self.contactTelephoneTF = personTF;
                self.telephoneLabel = personTitleLabel;
            }
        }
       /* verticalLine = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth - 40, 0, 0.3, 9 * 40.0f)];
        verticalLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:verticalLine];*/
        
        self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectButton.frame = CGRectMake(kScreenWidth - 40, 0, 40, 40);
        self.selectButton.centerY = 40.0f;
        [self.selectButton setImage:[UIImage imageNamed:@"hotelOrderWritePerson"] forState:UIControlStateNormal];
        [self addSubview:self.selectButton];
    }
    return self;
}
@end

