//
//  BeDatePickerView.m
//  sbh
//
//  Created by SBH on 15/7/13.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeDatePickerView.h"
#import "ColorUtility.h"
#import "BeSpeInfoModel.h"

// 屏幕尺寸
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kTitleAttrubiteFont [UIFont systemFontOfSize:16]
#define kMargin 10
#define kRowMargin 5
#define kInputBtnFont [UIFont systemFontOfSize:16]
#define kPickerContentFont [UIFont boldSystemFontOfSize:20]
//#define kPickerContentFont [UIFont boldSystemFontOfSize:20]
#define kInputBtnFontColor [UIColor whiteColor]
#define kPickerRowH 45
#define kPickerH 275
#define kAnimateDuration 0.3

#define kTitleFont [UIFont systemFontOfSize:14]
#define kContentFont [UIFont systemFontOfSize:13]
#define kSecendTitleFont [UIFont systemFontOfSize:12]
#define kBgColor [ColorUtility colorFromHex:0xf8f8f8]
#define kThemeColor [ColorUtility colorFromHex:0x27afe3]
#define kTitleColor [ColorUtility colorFromHex:0x4b4b4b]
#define kSecendTitleColor [ColorUtility colorFromHex:0xb4b4b4]
#define kLineColor [ColorUtility colorFromHex:0xdcdcdc]
#define kRedColor [ColorUtility colorFromHex:0xc9151e]

@interface BeDatePickerView () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) NSMutableArray *minArray;
@property (nonatomic, strong) NSMutableArray *hourArray;
@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, strong) NSMutableArray *tempArray;

@property (nonatomic, assign) NSInteger dateSelRow;
@property (nonatomic, assign) NSInteger hourSelRow;
@property (nonatomic, assign) NSInteger minSelRow;
@property (nonatomic, strong) UIView *pickBgView;

@end

@implementation BeDatePickerView

- (NSMutableArray *)tempArray
{
    if (_tempArray == nil) {
        _tempArray = [NSMutableArray array];
    }
    return _tempArray;
}


- (NSMutableArray *)minArray
{
    if (_minArray == nil) {
        _minArray = [NSMutableArray array];
    }
    return _minArray;
}

- (NSMutableArray *)hourArray
{
    if (_hourArray == nil) {
        _hourArray =[NSMutableArray array];
        [_hourArray addObject:@""];
    }
    return _hourArray;
}

- (NSMutableArray *)dateArray
{
    if (_dateArray == nil) {
        _dateArray =[NSMutableArray array];
        [_dateArray addObject:@"现在"];
        [_dateArray addObject:@"今天"];
        [_dateArray addObject:@"明天"];
        [_dateArray addObject:@"后天"];
    }
    return _dateArray;
}

+ (instancetype)beDatePickerView
{
    BeDatePickerView *datePicker = [[BeDatePickerView alloc] init];
    // 初始化数据
//    [datePicker setupData];
    //    datePicker.backgroundColor = [UIColor lightGrayColor];
    //    datePicker.alpha = 0.8;
    return datePicker;
}


- (void)setupData
{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self setupData];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, kScreenW, kPickerH)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        self.pickBgView = bgView;
       
        UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 45)];
        inputView.backgroundColor = [UIColor clearColor];
        [bgView addSubview:inputView];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 0, 60, inputView.height);
        cancelBtn.titleLabel.font = kInputBtnFont;
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:kTitleColor forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(pickerCancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [inputView addSubview:cancelBtn];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame = CGRectMake(kScreenW - 60, 0, 60, inputView.height);
        sureBtn.titleLabel.font = kInputBtnFont;
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[ColorConfigure globalBgColor] forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(pickerSureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [inputView addSubview:sureBtn];
        
        UILabel *hintLabel = [[UILabel alloc] initWithFrame:inputView.bounds];
        hintLabel.textAlignment = NSTextAlignmentCenter;
        hintLabel.textColor = kSecendTitleColor;
        hintLabel.font = kTitleFont;
        hintLabel.text = @"请选择出行时间";
        [inputView addSubview:hintLabel];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake( 0, inputView.height -1, kScreenW, 1)];
        line.backgroundColor = kLineColor;
        [inputView addSubview:line];
        //        [self pickerView:pickView didSelectRow:2 inComponent:0];
        //        [self pickerView:pickView didSelectRow:2 inComponent:1];
        //        [self pickerView:pickView didSelectRow:2 inComponent:2];
        //        [pickView selectRow:2 inComponent:0 animated:NO];
        //        [pickView selectRow:2 inComponent:1 animated:NO];
        //        [pickView selectRow:2 inComponent:2 animated:NO];
        UIPickerView *pickView = [[UIPickerView alloc] init];
        //        pickView.backgroundColor = [UIColor redColor];
        pickView.frame = CGRectMake(0, inputView.height, kScreenW, bgView.height - inputView.height);
        pickView.backgroundColor = [UIColor clearColor];
        pickView.delegate = self;
        pickView.dataSource = self;
        pickView.showsSelectionIndicator = YES;
        [bgView addSubview:pickView];
        
        // 初始化数据
        self.dateSelRow = 0;
        self.hourSelRow = 0;
        self.minSelRow = 0;
    }
    
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)pickerCancelBtnClick:(UIButton *)sender {
    [self close];
}

- (void)pickerSureBtnClick:(UIButton *)sender {
    BeSpeInfoModel *infoModel = [[BeSpeInfoModel alloc] init];
    //    NSString *dataStr = nil;
    int hourInt = 0;
    int minInt = 0;
    NSString *dateStr = [self getTimeWithFormatter:@"HH:mm:ss"];
    NSArray *array = [dateStr componentsSeparatedByString:@":"];
    hourInt = [array.firstObject intValue];
    minInt = [[array objectAtIndex:1] intValue];
    if (hourInt == 23 && minInt>20) {
        infoModel.startTime = self.dateArray.firstObject;
        infoModel.startTimePrama = [self getTimeWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
    } else {
        
        if (self.dateSelRow == 0) {
            infoModel.startTime = self.dateArray.firstObject;
            infoModel.startTimePrama = [self getTimeWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
        } else {
            if (self.dateSelRow == 1) {
                infoModel.startTime = [NSString stringWithFormat:@"%@ %@:%@", [self.dateArray objectAtIndex:self.dateSelRow], [self.hourArray objectAtIndex:self.hourSelRow], [self.minArray objectAtIndex:self.minSelRow]];
                infoModel.startTimePrama = [NSString stringWithFormat:@"%@ %@:%@:00", [self getTimeWithFormatter:@"yyyy-MM-dd"], [self.hourArray objectAtIndex:self.hourSelRow], [self.minArray objectAtIndex:self.minSelRow]];
            } else if(self.dateSelRow == 2){ // 明天
//                NSDate *date = [[NSDate alloc]
//                                initWithTimeIntervalSinceReferenceDate:
//                                ([[NSDate date] timeIntervalSinceReferenceDate] + 3600 * 24 * 1)];
                infoModel.startTime = [NSString stringWithFormat:@"%@ %@:%@", [self.dateArray objectAtIndex:self.dateSelRow], [self.hourArray objectAtIndex:self.hourSelRow], [self.minArray objectAtIndex:self.minSelRow]];
                infoModel.startTimePrama = [NSString stringWithFormat:@"%@ %@:%@:00", [self stringDateWithTimeInterval:3600 * 24 * 1], [self.hourArray objectAtIndex:self.hourSelRow], [self.minArray objectAtIndex:self.minSelRow]];
            } else if(self.dateSelRow == 3){ // 后天
//                NSDate *date = [[NSDate alloc]
//                                initWithTimeIntervalSinceReferenceDate:
//                                ([[NSDate date] timeIntervalSinceReferenceDate] + 3600 * 24 * 2)];
                infoModel.startTime = [NSString stringWithFormat:@"%@ %@:%@", [self.dateArray objectAtIndex:self.dateSelRow], [self.hourArray objectAtIndex:self.hourSelRow], [self.minArray objectAtIndex:self.minSelRow]];
                infoModel.startTimePrama = [NSString stringWithFormat:@"%@ %@:%@:00", [self stringDateWithTimeInterval:3600 * 24 * 2], [self.hourArray objectAtIndex:self.hourSelRow], [self.minArray objectAtIndex:self.minSelRow]];
            }
        }
    }
    self.datePickerViewSelResultBlock(infoModel);
    [self close]; // 最后才移除时间选择器
}

#pragma mark -- UIPickerViewDataSource and UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 2) {
        return self.minArray.count;
    }
    if (component == 1) {
        return self.hourArray.count;
    }
    return 4;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 1 || component == 2) {
        return kScreenW * 0.5 * 0.5;
    }
    return kScreenW * 0.5;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return kPickerRowH;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if (component == 0) {
//
//
//    }else {
//
//
//    }
//    return @"00";
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    if (component == 0) {
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreenW*2, kPickerRowH)];
        
        myView.textAlignment = NSTextAlignmentCenter;
        myView.backgroundColor = [UIColor clearColor];
        myView.font = kPickerContentFont; //用label来设置字体大小
        myView.textColor = kTitleColor;
        myView.text = [self.dateArray objectAtIndex:row];
        
    }else {
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreenW * 0.5 * 0.5, kPickerRowH)];
        myView.textAlignment = NSTextAlignmentLeft;
        myView.font = kPickerContentFont; //用label来设置字体大小
        myView.textColor = kTitleColor;
        if (component == 1) {
            myView.textAlignment = NSTextAlignmentCenter;
            myView.text = [self.hourArray objectAtIndex:row];
        } else {
            myView.text = [self.minArray objectAtIndex:row];
        }
        
    }
    
    return myView;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    //    UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
    //    label.textColor = SBHYellowColor;
    if (component == 0) {
        self.dateSelRow = row;
        if (row != 0) {
            [self.minArray removeAllObjects];
            [self.hourArray removeAllObjects];
            //            [self.minArray addObjectsFromArray:@[@"00", @"15", @"30", @"45"]];
            int hourInt = 0;
            int minInt = 0;
            if (row == 1) {
                NSString *dateStr = [self getTimeWithFormatter:@"HH:mm:ss"];
                NSArray *array = [dateStr componentsSeparatedByString:@":"];
                hourInt = [array.firstObject intValue];
                minInt = [[array objectAtIndex:1] intValue];
            }
            if (hourInt == 23 && minInt>20) {
                
            } else {
                for (int i = 0; i<24; i++) {
                    if (i>hourInt) {
                        [self.hourArray addObject:[NSString stringWithFormat:@"%02d", i]];
                    } else if (i==hourInt && minInt <= 20){
                        [self.hourArray addObject:[NSString stringWithFormat:@"%02d", i]];
                    }
                }
                
                for (int i = 0; i<6; i++) {
                    
                    int tempInt = 10*i;
                    if (row == 1) {
                        if (minInt <= 20) {
                            if (tempInt >= (minInt + 30)) {
                                [self.minArray addObject:[NSString stringWithFormat:@"%02d", tempInt]];
                            }
                        } else {
                            int temp11Int = minInt - 30;
                            if (tempInt >= temp11Int) {
                                [self.minArray addObject:[NSString stringWithFormat:@"%02d", tempInt]];
                            }
                        }
                    } else {
                        [self.minArray addObject:[NSString stringWithFormat:@"%02d", tempInt]];
                    }
                    
                    
                }
            }
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            
        } else {
            [self.minArray removeAllObjects];
            [self.hourArray removeAllObjects];
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
        }
        
    }
    
    if (component == 1) {
        self.hourSelRow = row;
        if (self.dateSelRow == 1) { // 判断第一列是否选择是今天，
            
            int minInt = 0;
            if (row == 0) {
                NSString *dateStr = [self getTimeWithFormatter:@"HH:mm:ss"];
                NSArray *array = [dateStr componentsSeparatedByString:@":"];
                minInt = [[array objectAtIndex:1] intValue];
            }
            [self.minArray removeAllObjects];
            for (int i = 0; i<6; i++) {
                int tempInt = 10*i;
                if (row == 0) {
                    if (minInt <= 20) {
                        if (tempInt >= (minInt + 30)) {
                            [self.minArray addObject:[NSString stringWithFormat:@"%02d", tempInt]];
                        }
                    } else {
                        int temp11Int = minInt - 30;
                        if (tempInt >= temp11Int) {
                            [self.minArray addObject:[NSString stringWithFormat:@"%02d", tempInt]];
                        }
                        
                    }
                } else {
                    [self.minArray addObject:[NSString stringWithFormat:@"%02d", tempInt]];
                }
                
                
            }
        }
        [pickerView reloadComponent:2];
    }
    
    if (component == 2) {
        self.minSelRow= row;
    }
    
}

- (void)show
{
    [[[UIApplication sharedApplication]keyWindow] addSubview:self];
    self.alpha = 0.0;
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.alpha = 1.0;
        self.pickBgView.transform = CGAffineTransformTranslate(self.pickBgView.transform, 0, - kPickerH);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)close
{
    self.datePickerViewSelResultBlock(nil);
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.pickBgView.transform = CGAffineTransformIdentity;
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self close];
}

- (NSString*)getTimeWithFormatter:(NSString *)str
{
    // 手机时间是否与服务器时间一致
    NSString *dateTime = [[NSUserDefaults standardUserDefaults] objectForKey:kServerDate];
    
    NSString* nsCurrentTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:str];
    
    nsCurrentTime = [formatter stringFromDate:[NSDate date]];
    if (dateTime.length != 0) {
        NSDate *dateParameter = [CommonMethod dateFromString:dateTime WithParseStr:@"yyyy-MM-dd HH:mm:ss"];
        nsCurrentTime = [formatter stringFromDate:dateParameter];
    }
    
    return nsCurrentTime;
}


- (NSString *)stringDateWithTimeInterval:(double)timeInterval
{
    // 手机时间是否与服务器时间一致
    NSString *dateTime = [[NSUserDefaults standardUserDefaults] objectForKey:kServerDate];
    NSDate *date = [[NSDate alloc]
                    initWithTimeIntervalSinceReferenceDate:
                    ([[NSDate date] timeIntervalSinceReferenceDate] + timeInterval)];
    if (dateTime.length != 0) {
        NSDate *dateParameter = [CommonMethod dateFromString:dateTime WithParseStr:@"yyyy-MM-dd HH:mm:ss"];
        date = [[NSDate alloc]
                initWithTimeIntervalSinceReferenceDate:
                ([dateParameter timeIntervalSinceReferenceDate] + timeInterval)];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    
    return destDateString;
}
@end
