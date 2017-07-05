//
//  SBHDingdtxHeaterCell.m
//  sbh
//
//  Created by SBH on 14-12-18.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "SBHDingdtxHeaterCell.h"
#import "ColorUtility.h"

@interface SBHDingdtxHeaterCell ()
- (IBAction)altRetRuleBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *altRetRuleBtn;

@end

@implementation SBHDingdtxHeaterCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SBHDingdtxHeaterCell";
    SBHDingdtxHeaterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SBHDingdtxHeaterCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    return cell;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [ColorUtility colorWithRed:245 green:245 blue:245];
    [self.altRetRuleBtn setTitleColor:[ColorConfigure globalBgColor] forState:UIControlStateNormal];
}

- (void)setAirListM:(BeOrderWriteAirlistModel *)airListM
{
    _airListM = airListM;
   // 航班号
    NSString *numString = [NSString stringWithFormat:@"%@", airListM.flightno];
    if(airListM.aircraft != nil && airListM.aircraft.length > 0)
    {
        numString = [numString stringByAppendingString:[NSString stringWithFormat:@" | %@", airListM.aircraft]];
    }
    self.numLabel.text = numString;
    self.goDateLabel.text = airListM.departuredate;
    self.comeTimeLabel.text = airListM.fltimeStr;
   // self.reachTimeLabel.text = airListM.arrivaltimeStr;
    self.fromjcLabel.text = [NSString stringWithFormat:@"%@%@", airListM.depairportname, airListM.boardpointat];
    self.tojcLabel.text = [NSString stringWithFormat:@"%@%@", airListM.arrairportname, airListM.offpointat];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date1 = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@:%@",[[airListM.departuredate componentsSeparatedByString:@" "] firstObject],[airListM.departuretime substringToIndex:2], [airListM.departuretime substringFromIndex:2]]];
    NSDate *date2 = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@:%@",[[airListM.arrivaldate componentsSeparatedByString:@" "] firstObject],[airListM.arrivaltime substringToIndex:2] , [airListM.arrivaltime substringFromIndex:2] ]];
    NSTimeInterval aTimer = [date2 timeIntervalSinceDate:date1];
    
    int days = (aTimer / 60.0 + [[airListM.departuretime substringToIndex:2] intValue]*60 + [[airListM.departuretime substringFromIndex:2] intValue])/1440;
    self.reachTimeLabel.text = airListM.arrivaltimeStr;
    self.tipLabel.hidden = YES;
    
     if(days > 0)
     {
         NSString *tipString = [NSString stringWithFormat:@"+%d天",days];
         CGSize tipSize = [tipString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];

         self.tipLabel = nil;
         self.tipLabel = [[UILabel alloc]init];
         self.tipLabel.text = tipString;
         self.tipLabel.textAlignment = NSTextAlignmentRight;
         self.tipLabel.textColor = self.goDateLabel.textColor;
         self.tipLabel.font = [UIFont systemFontOfSize:14];
         self.tipLabel.frame = CGRectMake(kScreenWidth - 10 - tipSize.width, self.reachTimeLabel.y, tipSize.width, 20);
         [self addSubview:self.tipLabel];
         
         CGSize timeSize = [airListM.arrivaltimeStr sizeWithAttributes:@{NSFontAttributeName:self.reachTimeLabel.font}];
         self.reachTimeLabel.x = kScreenWidth - timeSize.width - tipSize.width - 10;
    }
    else
    {
    }
    if ([airListM.viaport isEqualToString:@"有"])
    {
        _arrowTypeImage.image = [UIImage imageNamed:@"hblb_jingtingIcon"];
    }
    else
    {
        _arrowTypeImage.image = [UIImage imageNamed:@"hblb_zhifeiIcon"];
    }
    
    // 富文本机建燃油
    NSString *jgStr = [NSString stringWithFormat:@"￥%@",airListM.pricedirections];
    NSString *jjStr = [NSString stringWithFormat:@"￥%@",airListM.fuelsurtaxa];
    NSString *ryStr = [NSString stringWithFormat:@"￥%@",airListM.airporttaxa];
    NSString *string = [NSString stringWithFormat:@"票价%@ / 机建%@ / 燃油%@",jgStr , jjStr, ryStr];
    NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:string];
    [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange(2, jgStr.length)];
    [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange(2+jgStr.length+5, jjStr.length)];
    [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange(2+jgStr.length+10+jjStr.length, ryStr.length)];

    self.jiranhunLabel.attributedText = attrib;

    // 算总价
    NSString *moneyString = [NSString stringWithFormat:@"￥%@", airListM.totaladt];
    NSString *totalString = [NSString stringWithFormat:@"单人总价%@",moneyString];
    NSMutableAttributedString *totalAttrib = [[NSMutableAttributedString alloc] initWithString:totalString];
    [totalAttrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange(4, moneyString.length)];
    self.totalPriceLabel.attributedText = totalAttrib;

}

- (IBAction)altRetRuleBtnClick:(UIButton *)sender {
    self.orderWriteAltRetRuleCell();
}
@end
