//
//  BeTrainDetailTableViewCell.m
//  sbh
//
//  Created by RobinLiu on 15/6/23.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTrainDetailTableViewCell.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "CommonDefine.h"

@interface BeTrainDetailTableViewCell()
{
    UILabel *ticketTypeLabel;
    UILabel *ticketPriceLabel;
    UILabel *availableLabel;
    UIButton *bookButton;
    NSIndexPath *_path;
}
@end
@implementation BeTrainDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeTrainDetailTableViewCellIdentifier";
    BeTrainDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeTrainDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    [cell setCellSubViews];
    return cell;
}
+ (CGFloat)cellHeight
{
    return 55.0;
}
- (void)setCellSubViews
{
    float width = kScreenWidth/4.0;
    float centerY = [BeTrainDetailTableViewCell cellHeight]/2.0;
    ticketTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 20)];
    ticketTypeLabel.centerY = centerY;
    ticketTypeLabel.textAlignment = NSTextAlignmentCenter;
    ticketTypeLabel.text = @"高级软卧";
    [self addSubview:ticketTypeLabel];
    
    ticketPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(width, 0, width, 20)];
    ticketPriceLabel.centerY = centerY;
    ticketPriceLabel.textAlignment = NSTextAlignmentCenter;
    ticketPriceLabel.textColor = [ColorConfigure loginButtonColor];
    ticketPriceLabel.text = @"￥9999.9";
    [self addSubview:ticketPriceLabel];
    
    availableLabel = [[UILabel alloc]initWithFrame:CGRectMake(width *2.0, 0, width, 20)];
    availableLabel.centerY = centerY;
    availableLabel.textAlignment = NSTextAlignmentCenter;
    availableLabel.text = @"9999张";
    [self addSubview:availableLabel];
    
    bookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bookButton.frame = CGRectMake(width * 3 + (width - 51)/2.0, 0, 51, 30);
    bookButton.centerY = centerY;
    bookButton.layer.cornerRadius = 5.0f;
    bookButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [bookButton setTitle:@"预订" forState:UIControlStateNormal];
    [bookButton addTarget:self action:@selector(bookAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bookButton];
}
- (void)bookAction
{
    if(self.delegate)
    {
        [self.delegate bookButtonDidClickWithIndexPath:_path];
    }
}
- (void)showDetailWith:(BeTrainSeatModel *)seatItem andIndexPath:(NSIndexPath *)thisPath andModel:(BeTrainTicketListModel *)model
{
    ticketTypeLabel.text = seatItem.seatName;
    NSString *priceString = [NSString stringWithFormat:@"%.1f",seatItem.seatPrice];
    if([priceString intValue] == [priceString floatValue])
    {
        ticketPriceLabel.text = [NSString stringWithFormat:@"￥%.0f",seatItem.seatPrice];
    }
    else
    {
        ticketPriceLabel.text = [NSString stringWithFormat:@"￥%.1f",seatItem.seatPrice];
    }
    _path = thisPath;
    if([seatItem.seatCount isEqualToString:@"*"])
    {
        availableLabel.text = model.note;
        availableLabel.font = [UIFont systemFontOfSize:10];
        bookButton.enabled = NO;
        bookButton.backgroundColor = [UIColor lightGrayColor];
    }
    else if([seatItem.seatCount intValue]<1)
    {
        availableLabel.text = @"无票";
        availableLabel.font = [UIFont systemFontOfSize:17];
        bookButton.enabled = NO;
        bookButton.backgroundColor = [UIColor lightGrayColor];
    }
    else
    {
        availableLabel.text = [NSString stringWithFormat:@"%@张",seatItem.seatCount];
        availableLabel.font = [UIFont systemFontOfSize:17];
        bookButton.enabled = YES;
        bookButton.backgroundColor = [ColorConfigure loginButtonColor];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
