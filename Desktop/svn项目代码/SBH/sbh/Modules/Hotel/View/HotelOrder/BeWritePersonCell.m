//
//  BeWritePersonCell.m
//  SideBenefit
//
//  Created by SBH on 15-3-12.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeWritePersonCell.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "CommonDefine.h"

#define kSepTag         999
#define kSepLineTag     888
#define kPersonLabelTag 1300
#define kIdCardLabelTag 1100
#define kPersonTFTag    1700
#define kIdCardTFTag    1900
@interface BeWritePersonCell ()
{
    UIView *sep1;
    UIView *sep2;
    UIView *sep3;
    UIView *sep4;
    UIView *sep5;
    UIView *sep6;
    UIView *sep7;
    UIView *sep8;
    
    UIView *sepLine1;
    UIView *sepLine2;
    UIView *sepLine3;
    UIView *sepLine4;
    UIView *sepLine5;
    UIView *sepLine6;
    UIView *sepLine7;
    UIView *sepLine8;
    UIView *sepLine9;

    UILabel *personLabel1;
    UILabel *personLabel2;
    UILabel *personLabel3;
    UILabel *personLabel4;
    UILabel *personLabel5;
    UILabel *personLabel6;
    UILabel *personLabel7;
    UILabel *personLabel8;
    UILabel *personLabel9;

    UILabel *idCardLabel1;
    UILabel *idCardLabel2;
    UILabel *idCardLabel3;
    UILabel *idCardLabel4;
    UILabel *idCardLabel5;
    UILabel *idCardLabel6;
    UILabel *idCardLabel7;
    UILabel *idCardLabel8;
    UILabel *idCardLabel9;
    
    UIView *verticalLine;
}
@end
@implementation BeWritePersonCell
+ (CGFloat)cellHeightWithArray:(NSArray *)personArray andIsShowIdCard:(BOOL)isShow
{
    if(personArray.count == 0 || personArray.count == 1)
    {
        return isShow == YES ? 40.0f * 2.0 :40.0f;
    }
    return isShow == YES ? personArray.count * 40.0f * 2.0 :personArray.count * 40.0f;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeWritePersonCellIdentifier";
    BeWritePersonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeWritePersonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        for(int i = 0 ;i < 9 ;i ++)
        {
            UILabel *personTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 75+ 10, 20)];
            personTitleLabel.centerY = 20.0 + i * 40 * 2;
            personTitleLabel.font = [UIFont systemFontOfSize:15];
            personTitleLabel.textColor = [ColorUtility colorFromHex:0x1d1d1d];
            personTitleLabel.text = [NSString stringWithFormat:@"入住人%d",i+1];
            personTitleLabel.tag = kPersonLabelTag + i;
            [self addSubview:personTitleLabel];
            
            UILabel *idCardTitleLabel = [[UILabel alloc]initWithFrame:personTitleLabel.bounds];
            idCardTitleLabel.x = personTitleLabel.x;
            idCardTitleLabel.centerY = personTitleLabel.centerY + 40;
            idCardTitleLabel.font = [UIFont systemFontOfSize:15];
            idCardTitleLabel.textColor = [ColorUtility colorFromHex:0x1d1d1d];
            idCardTitleLabel.text = [NSString stringWithFormat:@"身份证%d",i+1];
            idCardTitleLabel.tag = kIdCardLabelTag + i;
            [self addSubview:idCardTitleLabel];
            
            UITextField *personTF = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, kScreenWidth - 50 - 90, 20)];
            personTF.centerY = personTitleLabel.centerY;
            personTF.clearButtonMode = UITextFieldViewModeWhileEditing;
            personTF.font = [UIFont systemFontOfSize:15];
            personTF.placeholder = @"姓名";
            personTF.textAlignment = NSTextAlignmentRight;
            personTF.tag = kPersonTFTag + i;
            [self addSubview:personTF];
            
            UITextField *idCardTF = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, kScreenWidth - 50 - 90, 20)];
            idCardTF.centerY = idCardTitleLabel.centerY;
            idCardTF.clearButtonMode = UITextFieldViewModeWhileEditing;
            idCardTF.font = [UIFont systemFontOfSize:15];
            idCardTF.placeholder = @"身份证";
            idCardTF.textAlignment = NSTextAlignmentRight;
            idCardTF.tag = kIdCardTFTag + i;
            [self addSubview:idCardTF];
            
            UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(13, 0, 0, 0.3)];
            sepLine.backgroundColor = [UIColor lightGrayColor];
            sepLine.width = kScreenWidth - 13 - 40;
            sepLine.y = 40.0 + i * 40 * 2.0;
            sepLine.tag = kSepLineTag + i;
            [self addSubview:sepLine];
                
            UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(13, 0, 0, 0.3)];
            sep.backgroundColor = [UIColor lightGrayColor];
            sep.width = kScreenWidth - 13 - 40;
            sep.y = 80 - 0.3 + 40 * i * 2.0;
            sep.tag = kSepTag + i;
            if(i != 8)
            {
                [self addSubview:sep];
            }
            
            if(i == 0)
            {
                self.personNameTF1 = personTF;
                self.idCardTF1 = idCardTF;
                idCardLabel1 = idCardTitleLabel;
                sepLine1 = sepLine;
                sep1 = sep;
                personLabel1 = personTitleLabel;
            }
            else if(i == 1)
            {
                self.personNameTF2 = personTF;
                self.idCardTF2 = idCardTF;
                idCardLabel2 = idCardTitleLabel;
                sepLine2 = sepLine;
                sep2 = sep;
                personLabel2 = personTitleLabel;

            }
            else if(i == 2)
            {
                self.personNameTF3 = personTF;
                self.idCardTF3 = idCardTF;
                idCardLabel3 = idCardTitleLabel;
                sepLine3 = sepLine;
                sep3 = sep;
                personLabel3 = personTitleLabel;

            }
            else if(i == 3)
            {
                self.personNameTF4 = personTF;
                self.idCardTF4 = idCardTF;
                idCardLabel4 = idCardTitleLabel;
                sepLine4 = sepLine;
                sep4 = sep;
                personLabel4 = personTitleLabel;

            }
            else if(i == 4)
            {
                self.personNameTF5 = personTF;
                self.idCardTF5 = idCardTF;
                idCardLabel5 = idCardTitleLabel;
                sepLine5 = sepLine;
                sep5 = sep;
                personLabel5 = personTitleLabel;

            }
            else if(i == 5)
            {
                self.personNameTF6 = personTF;
                self.idCardTF6 = idCardTF;
                idCardLabel6 = idCardTitleLabel;
                sepLine6 = sepLine;
                sep6 = sep;
                personLabel6 = personTitleLabel;

            }
            else if(i == 6)
            {
                self.personNameTF7 = personTF;
                self.idCardTF7 = idCardTF;
                idCardLabel7 = idCardTitleLabel;
                sepLine7 = sepLine;
                sep7 = sep;
                personLabel7 = personTitleLabel;

            }
            else if(i == 7)
            {
                self.personNameTF8 = personTF;
                self.idCardTF8 = idCardTF;
                idCardLabel8 = idCardTitleLabel;
                sepLine8 = sepLine;
                sep8 = sep;
                personLabel8 = personTitleLabel;

            }
            else if(i == 8)
            {
                self.personNameTF9 = personTF;
                self.idCardTF9 = idCardTF;
                idCardLabel9 = idCardTitleLabel;
                sepLine9 = sepLine;
                personLabel9 = personTitleLabel;

            }
        }
        verticalLine = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth - 40, 0, 0.3, 9 * 40.0f * 2)];
        verticalLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:verticalLine];
        
        self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectButton.frame = CGRectMake(kScreenWidth - 40, 0, 40, 40);
        [self.selectButton setImage:[UIImage imageNamed:@"hotelOrderWriteContact"] forState:UIControlStateNormal];
        [self addSubview:self.selectButton];
    }
    return self;
}
- (void)setCellWithArray:(NSArray *)personArray andIsShowIdCard:(BOOL)isShow
{
    BOOL isIdCardHidden = !isShow;
    
    if(isIdCardHidden)
    {
        for(UIView *subview in [self subviews])
        {
            if((subview.tag - kSepTag >= 0 && subview.tag - kSepTag < 9)&&(subview.backgroundColor == [UIColor lightGrayColor]))
            {
                subview.y = 40 - 0.3 + 40 * (subview.tag - kSepTag);
            }
            if([subview isKindOfClass:[UILabel class]] && subview.tag - kPersonLabelTag >=0 && subview.tag - kPersonLabelTag < 9)
            {
                subview.centerY = 20.0 + (subview.tag - kPersonLabelTag) * 40;

            }
            if([subview isKindOfClass:[UITextField class]] && subview.tag - kPersonTFTag >=0 && subview.tag - kPersonTFTag < 9)
            {
                subview.centerY = 20.0 + (subview.tag - kPersonTFTag) * 40;
            }
             if(([subview isKindOfClass:[UILabel class]] && subview.tag - kIdCardLabelTag >=0 && subview.tag - kIdCardLabelTag < 9)||([subview isKindOfClass:[UITextField class]] && subview.tag - kIdCardTFTag >=0 && subview.tag - kIdCardTFTag < 9)||((subview.tag - kSepLineTag >=0 && subview.tag - kSepLineTag < 9)&&(subview.backgroundColor == [UIColor lightGrayColor])))
            {
                subview.hidden = YES;
            }
        }
    }
    self.personNameTF1.hidden = personLabel1.hidden = NO;
    self.idCardTF1.hidden = idCardLabel1.hidden = sepLine1.hidden = isIdCardHidden;
    
    
    BOOL isPersonHidden = personArray.count > 1?NO:YES;
    self.personNameTF2.hidden = personLabel2.hidden = sep1.hidden = isPersonHidden;
    self.idCardTF2.hidden = idCardLabel2.hidden = sepLine2.hidden = (isIdCardHidden == YES?YES:isPersonHidden);

    isPersonHidden = personArray.count > 2?NO:YES;
    self.personNameTF3.hidden = personLabel3.hidden = sep2.hidden = isPersonHidden;
    self.idCardTF3.hidden = idCardLabel3.hidden = sepLine3.hidden = (isIdCardHidden == YES?YES:isPersonHidden);

    isPersonHidden = personArray.count > 3?NO:YES;
    self.personNameTF4.hidden = personLabel4.hidden = sep3.hidden = isPersonHidden;
    self.idCardTF4.hidden = idCardLabel4.hidden = sepLine4.hidden = (isIdCardHidden == YES?YES:isPersonHidden);

    isPersonHidden = personArray.count > 4?NO:YES;
    self.personNameTF5.hidden = personLabel5.hidden = sep4.hidden = isPersonHidden;
    self.idCardTF5.hidden = idCardLabel5.hidden = sepLine5.hidden = (isIdCardHidden == YES?YES:isPersonHidden);

    isPersonHidden = personArray.count > 5?NO:YES;
    self.personNameTF6.hidden = personLabel6.hidden = sep5.hidden = isPersonHidden;
    self.idCardTF6.hidden = idCardLabel6.hidden = sepLine6.hidden = (isIdCardHidden == YES?YES:isPersonHidden);

    isPersonHidden = personArray.count > 6?NO:YES;
    self.personNameTF7.hidden = personLabel7.hidden = sep6.hidden = isPersonHidden;
    self.idCardTF7.hidden = idCardLabel7.hidden = sepLine7.hidden = (isIdCardHidden == YES?YES:isPersonHidden);

    isPersonHidden = personArray.count > 7?NO:YES;
    self.personNameTF8.hidden = personLabel8.hidden = sep7.hidden = isPersonHidden;
    self.idCardTF8.hidden = idCardLabel8.hidden = sepLine8.hidden = (isIdCardHidden == YES?YES:isPersonHidden);

    isPersonHidden = personArray.count > 8?NO:YES;
    self.personNameTF9.hidden = personLabel9.hidden = sep8.hidden  = isPersonHidden;
    self.idCardTF9.hidden = idCardLabel9.hidden = sepLine9.hidden = (isIdCardHidden == YES?YES:isPersonHidden);

    verticalLine.height = personArray.count * 40.0f * (isShow == YES ?2.0:1.0);
    self.selectButton.centerY = verticalLine.height/2.0;

    if(personArray.count < 2)
    {
        personLabel1.text = @"入住人";
    }
}
@end
