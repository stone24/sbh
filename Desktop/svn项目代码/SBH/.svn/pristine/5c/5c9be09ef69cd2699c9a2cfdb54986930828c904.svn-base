//
//  BeTrainBookingHeaderView.m
//  sbh
//
//  Created by SBH on 15/6/16.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeTrainBookingHeaderView.h"
#import "BeTrainBookModel.h"

@interface BeTrainBookingHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *goCity;
@property (weak, nonatomic) IBOutlet UILabel *reachCity;
@property (weak, nonatomic) IBOutlet UILabel *goTime;
@property (weak, nonatomic) IBOutlet UILabel *reachTime;
@property (weak, nonatomic) IBOutlet UILabel *goDate;
@property (weak, nonatomic) IBOutlet UILabel *reachDate;
@property (weak, nonatomic) IBOutlet UILabel *timeConsuming;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sepLine;

@end

@implementation BeTrainBookingHeaderView
+ (instancetype)tabelViewHeaderView
{
    BeTrainBookingHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"BeTrainBookingHeaderView" owner:nil options:nil] lastObject];
    headerView.priceLabel.textColor = SBHYellowColor;
   
    headerView.timeConsuming.textColor = [ColorConfigure globalBgColor];
    return headerView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutIfNeeded];
    self.height = 125;
}

- (void)setBookModel:(BeTrainBookModel *)bookModel
{
    self.sepLine.height = 0.3;
    self.sepLine.backgroundColor = [UIColor lightGrayColor];
    _bookModel = bookModel;
    self.goCity.text = bookModel.StartCity;
    self.reachCity.text = bookModel.EndCity;
    self.goTime.text = bookModel.StartTime;
    self.reachTime.text = bookModel.EndTime;
    
    NSArray *costArray = [bookModel.CostTime componentsSeparatedByString:@":"];
    self.timeConsuming.text = [NSString stringWithFormat:@"%d时%d分",[[costArray firstObject] intValue],[[costArray objectAtIndex:1]intValue]];
    float ticketPrice = [bookModel.selectPrice floatValue];
    self.priceLabel.text = [NSString stringWithFormat:@"%@ ￥%.2f      服务费:￥%.2f",bookModel.selectSeat,ticketPrice,[bookModel.servicemoney doubleValue]];

    /*if(ticketPrice == [bookModel.selectPrice intValue])
    {
        self.priceLabel.text = [NSString stringWithFormat:@"%@ ￥%.2f      服务费:￥%d",bookModel.selectSeat,ticketPrice,[bookModel.servicemoney intValue]];
    }
    else
    {
        self.priceLabel.text = [NSString stringWithFormat:@"%@ ￥%.2f      服务费:￥%d",bookModel.selectSeat,ticketPrice,[bookModel.servicemoney intValue]];
    }*/
    // 计算到达日期
    NSArray *sTimeArray = [bookModel.StartTime componentsSeparatedByString:@":"];
    int costMin = [[costArray firstObject] intValue]*60 + [[costArray objectAtIndex:1]intValue];
    int sTimeMin = [[sTimeArray firstObject] intValue]*60 + [[sTimeArray objectAtIndex:1]intValue];
    int totMin = costMin+sTimeMin;
    NSDate *sDate = [CommonMethod dateFromString:bookModel.SDate WithParseStr:@"yyyy-MM-dd"];
    NSDate *newDate = [[NSDate alloc]
                       initWithTimeIntervalSinceReferenceDate:
                       ([sDate timeIntervalSinceReferenceDate] + totMin*60)];
    
    NSArray *goDateArray = [bookModel.SDate componentsSeparatedByString:@"-"];
    NSArray *reachDateArray = [[CommonMethod stringFromDate:newDate WithParseStr:kFormatYYYYMMDD] componentsSeparatedByString:@"-"];
    if (goDateArray.count <3 && reachDateArray.count < 3) {
        self.reachDate.text = [CommonMethod stringFromDate:newDate WithParseStr:kFormatYYYYMMDD];
        self.goDate.text = bookModel.SDate;
    } else {
        self.reachDate.text = [NSString stringWithFormat:@"%@月%@日", [reachDateArray objectAtIndex:1], [reachDateArray objectAtIndex:2]];
        self.goDate.text = [NSString stringWithFormat:@"%@月%@日", [goDateArray objectAtIndex:1], [goDateArray objectAtIndex:2]];
    }
    
}

@end
