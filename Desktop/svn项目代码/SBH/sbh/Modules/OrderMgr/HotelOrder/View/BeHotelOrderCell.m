//
//  BeHotelOrderCell.m
//  SideBenefit
//
//  Created by SBH on 15-3-10.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelOrderCell.h"
#import "ColorUtility.h"

@interface BeHotelOrderListStatusCell ()
{
    UILabel *statusLabel;
    UILabel *priceLabel;
}
@end
@implementation BeHotelOrderListStatusCell
+ (CGFloat)cellHeight
{
    return 34.0f;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeHotelOrderListStatusCellIdentifier";
    BeHotelOrderListStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeHotelOrderListStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, 50, 20)];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.centerY = [BeHotelOrderListStatusCell cellHeight]/2.0;
        statusLabel.textColor = [UIColor whiteColor];
        statusLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:statusLabel];
        
        priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 200, 0, 187, 20)];
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.centerY = statusLabel.centerY;
        priceLabel.textColor = [UIColor darkGrayColor];
        priceLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:priceLabel];
    }
    return self;
}
- (void)setListModel:(BeHotelOrderModel *)listModel
{
    _listModel = listModel;
    statusLabel.text = [[_listModel.OrderStatus componentsSeparatedByString:@"("] firstObject];
    statusLabel.backgroundColor = _listModel.statusColor;
    statusLabel.layer.cornerRadius = 3.0f;
    priceLabel.text = [NSString stringWithFormat:@"￥%@",_listModel.OrderSumFee];
}
@end
@interface BeHotelOrderListContentCell ()
{
    UILabel *nameLabel;
    UILabel *addressLabel;
    UILabel *dateLabel;
}

@end
@implementation BeHotelOrderListContentCell
+ (CGFloat)cellHeight
{
    return 82.0f;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeHotelOrderListContentCellIdentifier";
    BeHotelOrderListContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeHotelOrderListContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 10, kScreenWidth - 26, 20)];
        nameLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:nameLabel];
        
        addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, CGRectGetMaxY(nameLabel.frame)+ 2, kScreenWidth - 26, 20)];
        addressLabel.textColor = [UIColor darkGrayColor];
        addressLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:addressLabel];
        
        dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, CGRectGetMaxY(addressLabel.frame) + 2, kScreenWidth - 26, 20)];
        dateLabel.textColor = [UIColor darkGrayColor];
        dateLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:dateLabel];
    }
    return self;
}
- (void)setListModel:(BeHotelOrderModel *)listModel
{
    _listModel = listModel;
    nameLabel.text = _listModel.HotelName;
    addressLabel.text = _listModel.Address;
    NSArray *arrayIn = [_listModel.CheckInDate componentsSeparatedByString:@"-"];
    NSArray *arrayOut = [_listModel.CheckOutDate componentsSeparatedByString:@"-"];
    NSDate *aDate = [CommonMethod dateFromString:_listModel.CheckInDate WithParseStr:@"yyyy-MM-dd"];
    NSString * weekDayStr = [NSString stringWithFormat:@"周%@",
                             [CommonMethod getWeekDayFromDate:aDate]];
    NSDate * aDate00 = [CommonMethod dateFromString:_listModel.CheckOutDate WithParseStr:@"yyyy-MM-dd"];
    int dayInt = [aDate00 timeIntervalSinceDate:aDate]/86400;
    _listModel.exDays = dayInt;
    dateLabel.text = [NSString stringWithFormat:@"入:%@月%@日(%@) 离:%@月%@日(%d晚)",[arrayIn objectAtIndex:1],[arrayIn objectAtIndex:2],weekDayStr,[arrayOut objectAtIndex:1],[arrayOut objectAtIndex:2],dayInt];
}
@end

@interface BeHotelOrderCell ()
{
    UIButton *button1;
    UIButton *button2;
}

@end
@implementation BeHotelOrderCell

+ (CGFloat)cellHeight
{
    return 34.0f;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeHotelOrderCellIdentifier";
    BeHotelOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeHotelOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(kScreenWidth - 20 - 60 - 60, 0, 60, 24);
        button1.layer.cornerRadius = 3.0f;
        button1.layer.borderWidth = 1.0f;
        button1.centerY = [BeHotelOrderCell cellHeight]/2.0;
        button1.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:button1];
        
        button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame = CGRectMake(kScreenWidth - 10 - 60, 0, 60, 24);
        button2.layer.cornerRadius = 3.0f;
        button2.layer.borderWidth = 1.0f;
        button2.centerY = button1.centerY;
        button2.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:button2];
    }
    return self;
}
- (void)setListModel:(BeHotelOrderModel *)listModel
{
    _listModel = listModel;
    if([listModel.OrderStatus intValue] == 200)
    {
        if(listModel.PayStatus == 0)
        {
            if(listModel.ExamineStatus == 0)
            {
                //待审批
                button1.hidden = YES;
                [button2 setTitle:@"去审批" forState:UIControlStateNormal];
                [button2 setTitleColor:[ColorUtility colorFromHex:0xfe9b14] forState:UIControlStateNormal];
                button2.layer.borderColor = [[ColorUtility colorFromHex:0xfe9b14] CGColor];
                [button2 addTarget:self action:@selector(auditAction) forControlEvents:UIControlEventTouchUpInside];
            }
            else if(listModel.ExamineStatus == 5)
            {
                [button1 setTitle:@"取消" forState:UIControlStateNormal];
                [button1 setTitleColor:[ColorUtility colorFromHex:0x31ccb7] forState:UIControlStateNormal];
                button1.layer.borderColor = [[ColorUtility colorFromHex:0x31ccb7] CGColor];
                [button1 addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
                
                [button2 setTitle:@"支付" forState:UIControlStateNormal];
                [button2 setTitleColor:[ColorUtility colorFromHex:0xfe9b14] forState:UIControlStateNormal];
                button2.layer.borderColor = [[ColorUtility colorFromHex:0xfe9b14] CGColor];
                [button2 addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                button1.hidden = YES;
                button2.hidden = YES;
            }
        }
        else
        {
            button1.hidden = YES;
            [button2 setTitle:@"取消" forState:UIControlStateNormal];
            [button2 setTitleColor:[ColorUtility colorFromHex:0x31ccb7] forState:UIControlStateNormal];
            button2.layer.borderColor = [[ColorUtility colorFromHex:0x31ccb7] CGColor];
            [button2 addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    else if([_listModel.OrderStatus isEqualToString:kStatusYiqueren])
    {
        //"已确认"
        button1.hidden = YES;
        [button2 setTitle:@"再次预订" forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button2.layer.borderColor = [[UIColor grayColor] CGColor];        [button2 addTarget:self action:@selector(bookAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([_listModel.OrderStatus isEqualToString:kStatusYituiding])
    {
        //已退订"
        button1.hidden = YES;
        [button2 setTitle:@"再次预订" forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button2.layer.borderColor = [[UIColor grayColor] CGColor];        [button2 addTarget:self action:@selector(bookAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([_listModel.OrderStatus isEqualToString:kStatusYiquxiao])
    {
        //已取消
        button1.hidden = YES;
        [button2 setTitle:@"再次预订" forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button2.layer.borderColor = [[UIColor grayColor] CGColor];
        [button2 addTarget:self action:@selector(bookAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([_listModel.OrderStatus isEqualToString:kStatusDaiqueren]||[_listModel.OrderStatus isEqualToString:kStatusApply])
    {
        //待确认 //申请单
        button1.hidden = YES;
        [button2 setTitle:@"取消" forState:UIControlStateNormal];
        [button2 setTitleColor:[ColorUtility colorFromHex:0x31ccb7] forState:UIControlStateNormal];
        button2.layer.borderColor = [[ColorUtility colorFromHex:0x31ccb7] CGColor];
        [button2 addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([_listModel.OrderStatus isEqualToString:kStatusChulizhong])
    {
        //处理中
        button1.hidden = YES;
        button2.hidden = YES;
    }
    else if([_listModel.OrderStatus isEqualToString:kStatusDaizhifu])
    {
        //待支付
        [button1 setTitle:@"取消" forState:UIControlStateNormal];
        [button1 setTitleColor:[ColorUtility colorFromHex:0x31ccb7] forState:UIControlStateNormal];
        button1.layer.borderColor = [[ColorUtility colorFromHex:0x31ccb7] CGColor];
        [button1 addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        
        [button2 setTitle:@"支付" forState:UIControlStateNormal];
        [button2 setTitleColor:[ColorUtility colorFromHex:0xfe9b14] forState:UIControlStateNormal];
        button2.layer.borderColor = [[ColorUtility colorFromHex:0xfe9b14] CGColor];
        [button2 addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([_listModel.OrderStatus isEqualToString:kStatusToAudit])
    {
        //待审批
        button1.hidden = YES;
        [button2 setTitle:@"去审批" forState:UIControlStateNormal];
        [button2 setTitleColor:[ColorUtility colorFromHex:0xfe9b14] forState:UIControlStateNormal];
        button2.layer.borderColor = [[ColorUtility colorFromHex:0xfe9b14] CGColor];
        [button2 addTarget:self action:@selector(auditAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([_listModel.OrderStatus isEqualToString:kStatusHaveAudit])
    {
        button1.hidden = YES;
        button2.hidden = YES;
    }
}
- (void)auditAction
{
    if(self.delegate && self.indexPath)
    {
        [self.delegate auditWithIndex:self.indexPath];
    }
}
- (void)payAction
{
    if(self.delegate && self.indexPath)
    {
        [self.delegate payWithIndex:self.indexPath];
    }
}
- (void)cancelAction
{
    if(self.delegate && self.indexPath)
    {
        [self.delegate cancelWithIndex:self.indexPath];
    }
}
- (void)bookAction
{
    if(self.delegate && self.indexPath)
    {
        [self.delegate bookWithIndex:self.indexPath];
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
