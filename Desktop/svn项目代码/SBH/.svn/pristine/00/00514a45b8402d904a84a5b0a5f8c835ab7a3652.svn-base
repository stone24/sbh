//
//  BeHotelBookView.m
//  SideBenefit
//
//  Created by RobinLiu on 15/3/10.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelBookTableViewCell.h"
#import "NSDate+WQCalendarLogic.h"
#import "ColorConfigure.h"
#import "CommonDefine.h"
#import "ColorUtility.h"
#import "BeHotelConditionHeader.h"

#define kButtonTitleFont [UIFont systemFontOfSize:16]
#define kButtonLittleFont [UIFont systemFontOfSize:11]

#define kBookDarkColor [UIColor blackColor]
#define kBookLightColor [UIColor lightGrayColor]

@implementation BeHotelBookCityNameCell
- (void)awakeFromNib
{
    [super awakeFromNib];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeHotelBookCityNameCellIdentifier";
    BeHotelBookCityNameCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeHotelBookCityNameCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        UIImageView *leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotel_book_city"]];
        [self addSubview:leftImageView];
        leftImageView.centerX = 21;
        leftImageView.centerY = 22.5;
        [self addSubview:leftImageView];
        
        UIImageView *arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotel_book_arrow"]];
        [self addSubview:arrowImageView];
        arrowImageView.centerX = kScreenWidth - 16;
        arrowImageView.centerY = 22.5;
        [self addSubview:arrowImageView];
        
        _cityNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80,0, kScreenWidth - 80 - 80, 45)];
        _cityNameLabel.textColor = [UIColor blackColor];
        _cityNameLabel.textAlignment = NSTextAlignmentCenter;
        _cityNameLabel.font = kButtonTitleFont;
        [self addSubview:_cityNameLabel];
    }
    return self;
}
@end

@interface BeHotelBookStayCell ()
@property (strong, nonatomic) UILabel *startDateLabel;
@property (strong, nonatomic) UILabel *startWeekLabel;
@property (strong, nonatomic) UILabel *stayDaysLabel;
@property (strong, nonatomic) UILabel *leaveDateLabel;
@property (strong, nonatomic) UILabel *leaveWeekLabel;
@end
@implementation BeHotelBookStayCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeHotelBookStayCellIdentifier";
    BeHotelBookStayCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeHotelBookStayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        UIImageView *leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotel_book_date"]];
        [self addSubview:leftImageView];
        leftImageView.centerX = 21;
        leftImageView.centerY = 22.5;
        [self addSubview:leftImageView];
        
        NSArray *titleArray = @[@"入住",@"离店"];
        CGFloat leftX = 32;
        CGFloat rightX = kScreenWidth/2.0 + 20;
        for(int i = 0;i < titleArray.count;i++)
        {
            UIImageView *arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotel_book_arrow"]];
            [self addSubview:arrowImageView];
            arrowImageView.centerX = i == 0?(kScreenWidth/2.0 - 12):(kScreenWidth - 16);
            arrowImageView.centerY = 30;
            [self addSubview:arrowImageView];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, 80, 13)];
            titleLabel.textColor = [UIColor lightGrayColor];
            titleLabel.font = kButtonLittleFont;
            titleLabel.text = [titleArray objectAtIndex:i];
            titleLabel.x = i == 0?(leftX + 12):(rightX + 12);
            [self addSubview:titleLabel];

            UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 18)];
            dateLabel.textColor = [UIColor blackColor];
            dateLabel.font = kButtonTitleFont;
            [self addSubview:dateLabel];
            dateLabel.centerY = arrowImageView.centerY;
            dateLabel.text = [titleArray objectAtIndex:i];
            dateLabel.x = titleLabel.x;
            if(i == 0)
            {
                self.startDateLabel = dateLabel;
            }
            else
            {
                self.leaveDateLabel = dateLabel;
            }
            
            UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 38, 13)];
            weekLabel.textColor = [UIColor lightGrayColor];
            weekLabel.centerY = arrowImageView.centerY;
            weekLabel.x = arrowImageView.x - 40;
            weekLabel.textAlignment = NSTextAlignmentRight;
            weekLabel.font = kButtonLittleFont;
            [self addSubview:weekLabel];
            if(i == 0)
            {
                self.startWeekLabel = weekLabel;
            }
            else
            {
                self.leaveWeekLabel = weekLabel;
            }
            if(i == 0)
            {
                self.stayDaysLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(arrowImageView.frame)+2, 0, 35, 12)];
                self.stayDaysLabel.textColor = [UIColor lightGrayColor];
                self.stayDaysLabel.font = kButtonLittleFont;
                self.stayDaysLabel.centerY = arrowImageView.centerY;
                self.stayDaysLabel.text = @"999晚";
                [self addSubview:self.stayDaysLabel];
            }
        }
    }
    return self;
}
- (void)setModel:(BeHotelListRequestModel *)model
{
    _model = model;
    self.startDateLabel.text = [self getDayStringWith:model.sdate];
    if ([[model.sdate compareIfTodayWithDate]isEqualToString:@"今天"]||[[model.sdate compareIfTodayWithDate]isEqualToString:@"明天"]||[[model.sdate compareIfTodayWithDate]isEqualToString:@"后天"]) {
        self.startWeekLabel.text = [model.sdate compareIfTodayWithDate];
    }
    else
    {
        self.startWeekLabel.text = [NSString stringWithFormat:@"星期%@",[CommonMethod getWeekDayFromDate:model.sdate]];
    }
    self.leaveDateLabel.text = [self getDayStringWith:model.edate];
    
    if ([[model.edate compareIfTodayWithDate]isEqualToString:@"今天"]||[[model.edate compareIfTodayWithDate]isEqualToString:@"明天"]||[[model.edate compareIfTodayWithDate]isEqualToString:@"后天"]) {
        self.leaveWeekLabel.text = [model.edate compareIfTodayWithDate];
    }
    else
    {
        self.leaveWeekLabel.text = [NSString stringWithFormat:@"星期%@",[CommonMethod getWeekDayFromDate:model.edate]];
    }
    self.stayDaysLabel.text = [NSString stringWithFormat:@"%d晚",[self getStayDaysWith:model.sdate andLeaveDate:model.edate]];
}
- (NSString *)getDayStringWith:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
- (int)getStayDaysWith:(NSDate *)startDate andLeaveDate:(NSDate *)leaveDate
{
    NSTimeInterval time=[leaveDate timeIntervalSinceDate:startDate];
    int days = ((int)time)/(3600*24);
    return days;
}
- (void)addTarget:(id)target WithStartAction:(SEL)startAction andLeaveAction:(SEL)leaveAction
{
    for(UIView *subview in [self subviews])
    {
        subview.userInteractionEnabled = YES;
    }
    UITapGestureRecognizer *startTap = [[UITapGestureRecognizer alloc]initWithTarget:target action:startAction];
    [self.startDateLabel addGestureRecognizer:startTap];
    
    UITapGestureRecognizer *leaveTap = [[UITapGestureRecognizer alloc]initWithTarget:target action:leaveAction];
    [self.leaveDateLabel addGestureRecognizer:leaveTap];
}
@end


@interface BeHotelBookKeywordCell ()
{
    UILabel *keyWordLabel;
    UIButton *keywordDeleteButton;
    UIImageView *arrowImageView;
}
@end
@implementation BeHotelBookKeywordCell
- (void)awakeFromNib
{
    [super awakeFromNib];

}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeHotelBookKeywordCellIdentifier";
    BeHotelBookKeywordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeHotelBookKeywordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        UIImageView *leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotel_book_keyword"]];
        [self addSubview:leftImageView];
        leftImageView.centerX = 21;
        leftImageView.centerY = 22.5;
        [self addSubview:leftImageView];
        
        arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotel_book_arrow"]];
        [self addSubview:arrowImageView];
        arrowImageView.centerX = kScreenWidth - 16;
        arrowImageView.centerY = 22.5;
        [self addSubview:arrowImageView];
        
        keyWordLabel = [[UILabel alloc]initWithFrame:CGRectMake(44, 0, kScreenWidth - 45 - 44, 45)];
        keyWordLabel.textColor = [UIColor blackColor];
        keyWordLabel.font = kButtonTitleFont;
        [self addSubview:keyWordLabel];
        
        keywordDeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        keywordDeleteButton.frame = CGRectMake(kScreenWidth - 45, 0, 45, 45);
        [keywordDeleteButton setImage:[UIImage imageNamed:@"hoteldetail_cancelBtn_normal"] forState:UIControlStateNormal];
        keywordDeleteButton.centerY = arrowImageView.centerY;
        [self addSubview:keywordDeleteButton];
    }
    return self;
}
- (void)setModel:(BeHotelListRequestModel *)model
{
    _model = model;
    NSMutableString *keyString = [NSMutableString stringWithString:@""];
    if(model.keyName.length > 0 && model.keyName !=nil)
    {
        keyString = [model.keyName mutableCopy];
    }
    else if (model.districtArray.count > 0 || model.bussinessArray.count > 0||model.brandArray.count > 0)
    {
        if(![model.districtArray containsObject:KUnlimitedTitle])
        {
            for(id member in model.districtArray)
            {
                if([member isKindOfClass:[NSString class]])
                {
                    keyString = (NSMutableString *)[keyString stringByAppendingString:member];
                }
                else if ([member isKindOfClass:[CityData class]])
                {
                    CityData *item = (CityData *)member;
                    NSString *districtName = item.districtName;
                    keyString = (NSMutableString *)[keyString stringByAppendingString:districtName];
                }
                if(![member isEqual:[model.districtArray lastObject]])
                {
                    keyString = (NSMutableString *)[keyString stringByAppendingString:@"、"];
                }
            }
        }
       
        if(keyString.length > 0)
        {
            keyString = (NSMutableString *)[keyString stringByAppendingString:@"、"];
        }
        if(![model.bussinessArray containsObject:KUnlimitedTitle])
        {
            for(id member in model.bussinessArray)
            {
                if([member isKindOfClass:[NSString class]])
                {
                    keyString = (NSMutableString *)[keyString stringByAppendingString:member];
                }
                else if ([member isKindOfClass:[CityData class]])
                {
                    CityData *item = (CityData *)member;
                    NSString *districtName = item.businessName;
                    keyString = (NSMutableString *)[keyString stringByAppendingString:districtName];
                }
                if(![member isEqual:[model.bussinessArray lastObject]])
                {
                    keyString = (NSMutableString *)[keyString stringByAppendingString:@"、"];
                }
            }
        }
        if(keyString.length > 0)
        {
            keyString = (NSMutableString *)[keyString stringByAppendingString:@"、"];
        }
        if(![model.brandArray containsObject:KUnlimitedTitle])
        {
            for(id member in model.brandArray)
            {
                if([member isKindOfClass:[NSString class]])
                {
                    keyString = (NSMutableString *)[keyString stringByAppendingString:member];
                }
                else if ([member isKindOfClass:[BeBrandModel class]])
                {
                    BeBrandModel *item= (BeBrandModel *)member;
                    NSString *districtName = item.brandName;
                    keyString = (NSMutableString *)[keyString stringByAppendingString:districtName];
                }
                if(![member isEqual:[model.brandArray lastObject]])
                {
                    keyString = (NSMutableString *)[keyString stringByAppendingString:@"、"];
                }
            }
        }
        if(keyString.length > 0)
        {
            NSString *lastChar = [keyString substringFromIndex:keyString.length-1];
            if([lastChar isEqualToString:@"、"])
            {
                NSUInteger location = keyString.length - 1;
                keyString = (NSMutableString *)[keyString substringToIndex:location];
            }
        }
    }
    if(keyString.length > 0)
    {
        keyWordLabel.text = keyString;
        keyWordLabel.textColor = kBookDarkColor;
        keywordDeleteButton.hidden = NO;
        arrowImageView.x = kScreenWidth - 40;
    }
    else
    {
        keyWordLabel.text = @"关键字/位置/品牌";
        keyWordLabel.textColor = kBookLightColor;
        keywordDeleteButton.hidden = YES;
        arrowImageView.centerX = kScreenWidth - 16;
    }
}
- (void)addTarget:(id)target andDeleteKeyword:(SEL)deleteAction
{
    for(UIView *subview in [self subviews])
    {
        subview.userInteractionEnabled = YES;
    }
    [keywordDeleteButton addTarget:target action:deleteAction forControlEvents:UIControlEventTouchUpInside];
}
@end

@interface BeHotelBookPriceStarCell ()
{
    UILabel *keyWordLabel;
    UIButton *keywordDeleteButton;
    UIImageView *arrowImageView;
}
@end
@implementation BeHotelBookPriceStarCell
- (void)awakeFromNib
{
    [super awakeFromNib];

}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeHotelBookPriceStarCellIdentifier";
    BeHotelBookPriceStarCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeHotelBookPriceStarCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        UIImageView *leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotel_book_price"]];
        [self addSubview:leftImageView];
        leftImageView.centerX = 21;
        leftImageView.centerY = 22.5;
        [self addSubview:leftImageView];
        
        arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotel_book_arrow"]];
        [self addSubview:arrowImageView];
        arrowImageView.centerX = kScreenWidth - 16;
        arrowImageView.centerY = 22.5;
        [self addSubview:arrowImageView];
        
        keyWordLabel = [[UILabel alloc]initWithFrame:CGRectMake(44, 0, kScreenWidth - 45 - 44, 45)];
        keyWordLabel.textColor = [UIColor blackColor];
        keyWordLabel.font = kButtonTitleFont;
        [self addSubview:keyWordLabel];
        
        keywordDeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        keywordDeleteButton.frame = CGRectMake(kScreenWidth - 45, 0, 45, 45);
        [keywordDeleteButton setImage:[UIImage imageNamed:@"hoteldetail_cancelBtn_normal"] forState:UIControlStateNormal];
        keywordDeleteButton.centerY = arrowImageView.centerY;
        [self addSubview:keywordDeleteButton];
    }
    return self;
}
- (void)setModel:(BeHotelListRequestModel *)model
{
    _model = model;
    NSString *keyString = @"";
    if(model.priceArrayCondition.count > 0 ||model.starArrayCondition.count > 0)
    {
        if(![model.priceArrayCondition containsObject:KUnlimitedTitle])
        {
            for(NSString *member in model.priceArrayCondition)
            {
                keyString = [keyString stringByAppendingString:member];
                if(![member isEqualToString:[model.priceArrayCondition lastObject]])
                {
                    keyString = [keyString stringByAppendingString:@"、"];
                }
            }
            if(keyString.length > 0)
            {
                keyString = [keyString stringByAppendingString:@"、"];
            }
        }
        if(![model.starArrayCondition containsObject:KUnlimitedTitle])
        {
            for(NSString *member in model.starArrayCondition)
            {
                keyString = [keyString stringByAppendingString:member];
                if(![member isEqualToString:[model.starArrayCondition lastObject]])
                {
                    keyString = [keyString stringByAppendingString:@"、"];
                }
            }
        }
        if(keyString.length > 0)
        {
            NSString *lastChar = [keyString substringFromIndex:keyString.length-1];
            if([lastChar isEqualToString:@"、"])
            {
                NSUInteger location = keyString.length - 1;
                keyString = (NSMutableString *)[keyString substringToIndex:location];
            }
        }
    }
    if(keyString.length > 0)
    {
        keyWordLabel.text = keyString;
        keyWordLabel.textColor = kBookDarkColor;
        keywordDeleteButton.hidden = NO;
        arrowImageView.x = kScreenWidth - 40;
    }
    else
    {
        keyWordLabel.text = @"价格/星级";
        keyWordLabel.textColor = kBookLightColor;
        keywordDeleteButton.hidden = YES;
        arrowImageView.centerX = kScreenWidth - 16;
    }
}
- (void)addTarget:(id)target andDeletePrice:(SEL)deleteAction
{
    for(UIView *subview in [self subviews])
    {
        subview.userInteractionEnabled = YES;
    }
    [keywordDeleteButton addTarget:target action:deleteAction forControlEvents:UIControlEventTouchUpInside];
}
@end

@interface BeHotelBookReasonCell ()
{
    UILabel *resonLabel;
}
@end
@implementation BeHotelBookReasonCell

- (void)awakeFromNib
{
    [super awakeFromNib];

}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeHotelBookReasonCellIdentifier";
    BeHotelBookReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeHotelBookReasonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        UIImageView *leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotel_book_reason"]];
        [self addSubview:leftImageView];
        leftImageView.centerX = 21;
        leftImageView.centerY = 22.5;
        [self addSubview:leftImageView];
        
        UIImageView *arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotel_book_arrow"]];
        [self addSubview:arrowImageView];
        arrowImageView.centerX = kScreenWidth - 16;
        arrowImageView.centerY = 22.5;
        [self addSubview:arrowImageView];
        
        resonLabel = [[UILabel alloc]initWithFrame:CGRectMake(44,0, kScreenWidth - 44 - 44, 45)];
        resonLabel.textColor = [UIColor blackColor];
        resonLabel.font = kButtonTitleFont;
        [self addSubview:resonLabel];
    }
    return self;
}
- (void)setModel:(BeHotelListRequestModel *)model
{
    _model = model;
    resonLabel.text = model.reason;
}
@end
