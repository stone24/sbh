//
//  chaxunjipiaoTableViewCell.m
//  SBHAPP
//
//  Created by musmile on 14-7-1.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "BeTicketQueryTableViewCell.h"

@implementation BeTicketQueryTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}
+ (CGFloat)cellHight
{
    return kTicketReserveListHeight;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    BeTicketQueryTableViewCell *cell = nil;
    static NSString *cell1 = @"cell1";
    cell = [tableView dequeueReusableCellWithIdentifier:cell1];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BeTicketQueryTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    return cell;
}
- (void)setCellWithItem:(BeTicketQueryResultModel *)item
{
    NSString *departureTime = [NSString stringWithFormat:@"%@:%@",[item.DepartureTime substringToIndex:2],[item.DepartureTime substringFromIndex:2]];
    NSString *arriveTime = [NSString stringWithFormat:@"%@:%@",[item.ArrivalTime substringToIndex:2],[item.ArrivalTime substringFromIndex:2]];
    _chufashijian.text = departureTime;
    _daodashijian.text = arriveTime;
    if ([item.ViaPort isEqualToString:@"0"]) {
        
        _biaozhiIcon.image = [UIImage imageNamed:@"zhifeiIcon"];
    }
    else if ([item.ViaPort isEqualToString:@"1"]) {
        _biaozhiIcon.image = [UIImage imageNamed:@"jingtingIcon"];
    }
    
    _chufajichang.text = [NSString stringWithFormat:@"%@%@",item.DepAirportName,item.BoardPointAT];
    _daodajichang.text = [NSString stringWithFormat:@"%@%@",item.ArrAirportName,item.OffPointAT];
    _shengyu.text = item.Seat;
    NSString *iNoString = [NSString stringWithFormat:@"%@%@",item.CarrierSName,item.FlightNo];
    if(item.AircraftName != nil && item.AircraftName.length > 0)
    {
        iNoString = [iNoString stringByAppendingString:[NSString stringWithFormat:@" | %@",item.AircraftName]];
    }
    _iNo.text = iNoString;
    // 判断售罄
    if (item.isSoldOut) {
        self.shengyu.hidden = YES;
        self.jiage.hidden = YES;
        self.mark.hidden = YES;
        UILabel *alteLabel = [[UILabel alloc] init];
        alteLabel.width = 60;
        alteLabel.height = 50;
        alteLabel.y = (self.height - alteLabel.height) * 0.2;
        alteLabel.x = SBHScreenW - alteLabel.width - 8;
        alteLabel.numberOfLines = 1;
        alteLabel.text = @"已售罄";
        alteLabel.font = [UIFont systemFontOfSize:16];
        alteLabel.textColor = SBHColor(153, 153, 153);
        alteLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:alteLabel];
        self.backgroundColor = SBHColor(245, 245, 245);
    } else {
        // 改签情况处理
        if (self.querySourceType == kQueryControllerSourceAlter || self.querySourceType == kQueryControllerSourceAlteSeveral) {
            
            if ([item.minprice isEqualToString:@"0"] || item.minprice.length == 0 || [item.minprice isEqualToString:@"--"]) return;
            self.shengyu.hidden = YES;
            self.jiage.hidden = YES;
            self.mark.hidden = YES;
            UILabel *alteLabel = [[UILabel alloc] init];
            alteLabel.y = 5;
            alteLabel.width = 60;
            alteLabel.height = 65;
            alteLabel.x = SBHScreenW - alteLabel.width - 8;
            alteLabel.numberOfLines = 2;
            alteLabel.text = @"航班\n选择";
            alteLabel.font = [UIFont systemFontOfSize:18];
            alteLabel.textColor = SBHYellowColor;
            alteLabel.textAlignment = NSTextAlignmentRight;
            [self addSubview:alteLabel];
        } else {
            _jiage.text = item.minprice;
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
