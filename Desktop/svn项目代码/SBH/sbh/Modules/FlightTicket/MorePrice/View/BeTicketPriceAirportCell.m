//
//  BeTicketPriceHeaderView.m
//  sbh
//
//  Created by RobinLiu on 16/3/14.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeTicketPriceAirportCell.h"
#import "ColorUtility.h"
#import "ColorConfigure.h"

@interface BeTicketPriceAirportCell()
{
    UILabel *flightNumberLabel;
    UILabel *departureDateLabel;
    UILabel *departureTimeLabel;
    UILabel *arriveTimeLabel;
    UILabel *departureAirportLabel;
    UILabel *arriveAirportLabel;
    UILabel *descriptionLabel;
    UIImageView *arrowImageView;
}
@end
@implementation BeTicketPriceAirportCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeTicketPriceAirportCellIdentifier";
    BeTicketPriceAirportCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeTicketPriceAirportCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [ColorUtility colorWithRed:245 green:245 blue:245];
        
        flightNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 17, 200, 15)];
        flightNumberLabel.textColor = [ColorUtility colorWithRed:35 green:35 blue:35];
        flightNumberLabel.font = [UIFont systemFontOfSize:14];
        flightNumberLabel.text = @"3U8896 | 230";
        [self addSubview:flightNumberLabel];
        
        departureDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 180, 17, 170, 15)];
        departureDateLabel.textAlignment = NSTextAlignmentRight;
        departureDateLabel.textColor = [ColorUtility colorWithRed:91 green:91 blue:91];
        departureDateLabel.text = @"2016-04-26 星期二";
        departureDateLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:departureDateLabel];
        
        departureTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 51, 100, 30)];
        departureTimeLabel.textColor = [UIColor blackColor];
        departureTimeLabel.font = [UIFont systemFontOfSize:29];
        [self addSubview:departureTimeLabel];
        
        arriveTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 150, 51, 140, 30)];
        arriveTimeLabel.textAlignment = NSTextAlignmentRight;
       // arriveTimeLabel.textColor = [UIColor blackColor];
        arriveTimeLabel.font = [UIFont systemFontOfSize:29];
        [self addSubview:arriveTimeLabel];
        
        departureAirportLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 84, 150, 15)];
        departureAirportLabel.textColor = [ColorUtility colorWithRed:111 green:113 blue:121];
        departureAirportLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:departureAirportLabel];
        
        arriveAirportLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 160, 84, 150, 15)];
        arriveAirportLabel.textAlignment = NSTextAlignmentRight;
        arriveAirportLabel.textColor = [ColorUtility colorWithRed:111 green:113 blue:121];
        arriveAirportLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:arriveAirportLabel];
        
        descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 106, 130, 11)];
        descriptionLabel.textColor = [ColorUtility colorWithRed:155 green:155 blue:155];
        descriptionLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:descriptionLabel];
        
        arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hblb_zhifeiIcon"]];
        arrowImageView.centerX = kScreenWidth/2.0;
        arrowImageView.centerY = kTicketPriceHeaderViewHeight/2.0;
        [self addSubview:arrowImageView];
    }
    return self;
}
- (void)setModel:(BeTicketQueryResultModel *)model
{
    _model = model;
    NSString *flightNumber = [NSString stringWithFormat:@"%@",_model.FlightNo];
    if(_model.AircraftName != nil && _model.AircraftName.length > 0)
    {
        flightNumber = [flightNumber stringByAppendingString:[NSString stringWithFormat:@"| %@",_model.AircraftName]];
    }
    flightNumberLabel.text = flightNumber;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *DepartureDateString = [[_model.DepartureDate componentsSeparatedByString:@"T"] firstObject];
    NSDate *date = [CommonMethod dateFromString:DepartureDateString WithParseStr:@"yyyy-MM-dd"];
    NSString * weekDayStr = [NSString stringWithFormat:@"星期%@",
                             [CommonMethod getWeekDayFromDate:date]];
    departureDateLabel.text = [NSString stringWithFormat:@"%@ %@", DepartureDateString, weekDayStr];
    
    departureAirportLabel.text = [_model.DepAirportName stringByAppendingString:_model.BoardPointAT];
    arriveAirportLabel.text = [_model.ArrAirportName stringByAppendingString:_model.OffPointAT];

    departureTimeLabel.text = [NSString stringWithFormat:@"%@:%@",[_model.DepartureTime substringToIndex:2],[_model.DepartureTime substringFromIndex:2]];
    int days = ([[[_model.FlightTime componentsSeparatedByString:@"分钟"] firstObject] intValue] + [[_model.DepartureTime substringToIndex:2] intValue]*60 + [[_model.DepartureTime substringFromIndex:2] intValue])/1440;
    arriveTimeLabel.textColor = [UIColor blackColor];
    arriveTimeLabel.text = [NSString stringWithFormat:@"%@:%@",[_model.ArrivalTime substringToIndex:2],[_model.ArrivalTime substringFromIndex:2]];
     if(days > 0)
     {
         NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@+%d天",[_model.ArrivalTime substringToIndex:2],[_model.ArrivalTime substringFromIndex:2],days]];
         [attrib addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, attrib.length)];
         [attrib addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:29] range:NSMakeRange(0, 5)];
         [attrib addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19] range:NSMakeRange(5, attrib.length - 5)];
         NSString *tipString = [NSString stringWithFormat:@"+%d天",days];

         CGSize tipSize = [tipString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];

         arriveTimeLabel.x = arriveTimeLabel.x - tipSize.width;

       //  arriveTimeLabel.attributedText = attrib;
         
         UILabel *tipLabel = [[UILabel alloc]init];
         tipLabel.text = tipString;
         tipLabel.textAlignment = NSTextAlignmentRight;
         tipLabel.textColor = departureDateLabel.textColor;
         tipLabel.font = [UIFont systemFontOfSize:14];
         tipLabel.frame = CGRectMake(CGRectGetMaxX(arriveTimeLabel.frame), arriveTimeLabel.y, tipSize.width, 20);

         [self addSubview:tipLabel];
     }
     else{
       /*  arriveTimeLabel.textColor = [UIColor blackColor];
         arriveTimeLabel.text = [NSString stringWithFormat:@"%@:%@",[_model.ArrivalTime substringToIndex:2],[_model.ArrivalTime substringFromIndex:2]];*/
     }
    
    NSString *imageNameString = [_model.ViaPort intValue] == 0?@"hblb_zhifeiIcon":@"hblb_jingtingIcon";
    arrowImageView.image = [UIImage imageNamed:imageNameString];
    
    NSString *desString = [NSString stringWithFormat:@"机建￥%@ / 燃油￥%@",_model.AirportTaxa,_model.FuelsurTaxa];
    NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:desString];
    [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange(2, _model.AirportTaxa.length + 1)];
    [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange(2+_model.AirportTaxa.length + 1+5, _model.FuelsurTaxa.length + 1)];
    descriptionLabel.attributedText = attrib;
}
@end
