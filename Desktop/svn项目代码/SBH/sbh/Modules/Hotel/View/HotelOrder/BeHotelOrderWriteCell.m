//
//  BeWriteContactCell.m
//  SideBenefit
//
//  Created by SBH on 15-3-12.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelOrderWriteCell.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "CommonDefine.h"
@implementation BeHotelOrderWriteCell

+ (CGFloat)cellHeight
{
    return 40.0f;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeHotelOrderWriteCellIdentifier";
    BeHotelOrderWriteCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeHotelOrderWriteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 62, 20)];
        self.nameLabel.centerY = 20.0;
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel.textColor = [ColorUtility colorFromHex:0x1d1d1d];
        [self addSubview:self.nameLabel];
        
        self.contentTF = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, kScreenWidth - 25 - 90, 20)];
        self.contentTF.font = [UIFont systemFontOfSize:15];
        self.contentTF.textAlignment = NSTextAlignmentRight;
        self.contentTF.centerY = self.nameLabel.centerY;
        self.contentTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:self.contentTF];
        
        self.arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotel_book_arrow"]];
        [self addSubview:self.arrowImageView];
        self.arrowImageView.centerX = kScreenWidth - 16;
        self.arrowImageView.centerY = 20.0;
        [self addSubview:self.arrowImageView];
        
        self.keywordDeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.keywordDeleteButton.frame = CGRectMake(kScreenWidth - 40, 0, 40, 40);
        [self.keywordDeleteButton setImage:[UIImage imageNamed:@"hoteldetail_cancelBtn_normal"] forState:UIControlStateNormal];
        self.keywordDeleteButton.centerY = self.arrowImageView.centerY;
        [self addSubview:self.keywordDeleteButton];
        self.keywordDeleteButton.hidden = YES;
    }
    return self;
}
- (void)addTarget:(id)target andDeleteKeyword:(SEL)deleteAction
{
    for(UIView *subview in [self subviews])
    {
        subview.userInteractionEnabled = YES;
    }
    [self.keywordDeleteButton addTarget:target action:deleteAction forControlEvents:UIControlEventTouchUpInside];
}
@end

@interface BeHotelOrderWriteChooseCell ()
{
    id _target;
    SEL _action;
}
@end
@implementation BeHotelOrderWriteChooseCell

- (void)awakeFromNib
{
    [super awakeFromNib];

}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeHotelOrderWriteChooseCellIdentifier";
    BeHotelOrderWriteChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeHotelOrderWriteChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 85, 20)];
        titleLabel.centerY = 20.0;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [ColorUtility colorFromHex:0x1d1d1d];
        titleLabel.text = @"入住人";
        [self addSubview:titleLabel];
        
        UIButton *bookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        bookButton.frame = CGRectMake(kScreenWidth - 85, 0, 72, 23);
        bookButton.centerY = 20.0;
        bookButton.layer.cornerRadius = 3.0f;
        [bookButton setBackgroundColor:[ColorConfigure globalBgColor]];
        bookButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [bookButton addTarget:self action:@selector(choosePerson) forControlEvents:UIControlEventTouchUpInside];
        [bookButton setTitle:@"选择入住人" forState:UIControlStateNormal];
        [self addSubview:bookButton];
    }
    return self;
}
- (void)choosePerson
{
    [_target performSelector:_action withObject:nil afterDelay:0];
}
- (void)addTarget:(id)target andChooseAction:(SEL)chooseAction
{
    _target = target;
    _action = chooseAction;
}
@end
