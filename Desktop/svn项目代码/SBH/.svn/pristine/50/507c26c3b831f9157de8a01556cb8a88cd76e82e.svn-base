//
//  BeRoomRow03Cell.m
//  SideBenefit
//
//  Created by SBH on 15-3-11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelRoomListCell.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "CommonDefine.h"

#define kFullBookedTitle @"满房"
#define kCanBeBookedTitle @"预订"

@interface BeHotelRoomListCell ()
{
    UILabel *roomTitle;
    UILabel *roomGuranteeLabel;
    UILabel *payLabel;
    UILabel *cancelLabel;
    
    UILabel *priceLabel;
    UIButton *reserveBtn;
}
@end
@implementation BeHotelRoomListCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"Tie";
    BeHotelRoomListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[BeHotelRoomListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [ColorUtility colorFromHex:0xf3f3f3];
        self.contentView.backgroundColor = [ColorUtility colorFromHex:0xf3f3f3];
        roomTitle = [[UILabel alloc]init];
        roomTitle.textColor = [UIColor darkGrayColor];
        roomTitle.numberOfLines = 0;
        roomTitle.font = [UIFont systemFontOfSize:14];
        [self addSubview:roomTitle];
        
        roomGuranteeLabel = [[UILabel alloc]init];
        roomGuranteeLabel.centerY = roomTitle.centerY;
        roomGuranteeLabel.backgroundColor = [ColorUtility colorFromHex:0x5edc80];
        roomGuranteeLabel.textAlignment = NSTextAlignmentCenter;
        roomGuranteeLabel.textColor = [UIColor whiteColor];
        roomGuranteeLabel.font = [UIFont systemFontOfSize:10];
        roomGuranteeLabel.text = @"担保";
        roomGuranteeLabel.layer.cornerRadius = 2.0f;
        [self addSubview:roomGuranteeLabel];
        
        payLabel = [[UILabel alloc]init];
        payLabel.font = [UIFont systemFontOfSize:12];
        payLabel.textColor = [ColorConfigure loginButtonColor];
        payLabel.numberOfLines = 0;
        [self addSubview:payLabel];
        
        cancelLabel = [[UILabel alloc]init];
        cancelLabel.font = [UIFont systemFontOfSize:12];
        cancelLabel.textColor = [UIColor grayColor];
        cancelLabel.numberOfLines = 0;
        [self addSubview:cancelLabel];
        
        priceLabel = [[UILabel alloc]init];
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.centerY = 20;
        priceLabel.textColor = [ColorConfigure loginButtonColor];
        priceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        [self addSubview:priceLabel];
        
        reserveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        reserveBtn.centerY = 20;
        [reserveBtn addTarget:self action:@selector(bookAction) forControlEvents:UIControlEventTouchUpInside];
        reserveBtn.backgroundColor = [ColorConfigure loginButtonColor];
        reserveBtn.layer.cornerRadius = 4.0f;
        reserveBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:reserveBtn];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    roomTitle.frame = self.listFrame.HotelNameFrame;
    roomGuranteeLabel.frame = self.listFrame.guaranteeFrame;
    payLabel.frame = self.listFrame.payFrame;
    cancelLabel.frame = self.listFrame.cancelFrame;
    priceLabel.frame = self.listFrame.priceFrame;
    reserveBtn.frame = self.listFrame.bookFrame;
}
- (void)setListFrame:(BeHotelRoomListFrame *)listFrame
{
    _listFrame = listFrame;
    roomTitle.text = self.listFrame.displayModel.HotelName;
    roomGuranteeLabel.text = self.listFrame.displayModel.guaranteeString;
    payLabel.text = self.listFrame.displayModel.payString;
    cancelLabel.text = self.listFrame.displayModel.cancelString;
    
    NSMutableAttributedString *priceAttrib = [[NSMutableAttributedString alloc] initWithString:self.listFrame.displayModel.priceString];
    [priceAttrib setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(0,1)];
    priceLabel.attributedText = priceAttrib;
    
    UIColor *enbleColor = [ColorConfigure loginButtonColor];

    if([self.listFrame.displayModel.bookString isEqualToString:@"满房"])
    {
        enbleColor = [UIColor lightGrayColor];
        reserveBtn.enabled = NO;
        [reserveBtn setTitle:@"满房" forState:UIControlStateNormal];
    }
    else
    {
        reserveBtn.enabled = YES;
        [reserveBtn setTitle:@"预订" forState:UIControlStateNormal];
    }
    [reserveBtn setBackgroundColor:enbleColor];
    
}
- (void)bookAction
{
    if(self.delegate && self.indexPath)
    {
        [self.delegate bookWithIndexPath:self.indexPath];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
