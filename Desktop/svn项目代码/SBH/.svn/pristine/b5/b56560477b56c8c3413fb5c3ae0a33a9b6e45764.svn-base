//
//  BeSpeChooseCarCell.m
//  sbh
//
//  Created by SBH on 15/7/10.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeSpeChooseCarCell.h"
#import "ColorUtility.h"
#import "BeSpeCarLevelModel.h"

#define kImageCarW 90
#define kSpeCarTitleFontNor [UIFont systemFontOfSize:11]
#define kSpeCarTitleFontSel [UIFont systemFontOfSize:12]
#define kSpeCarTitleColorNor [ColorConfigure globalBgColor]
#define kSpeCarTitleColorSel [ColorConfigure globalBgColor]

@interface BeSpeChooseCarCell () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) NSMutableArray *imageViewArrayM;
@property (nonatomic, strong) NSMutableArray *carTitleArrayM;
@property (nonatomic, strong) NSMutableArray *levCarArrayM;

@end

@implementation BeSpeChooseCarCell

- (NSMutableArray *)levCarArrayM
{
    if (_levCarArrayM == nil) {
        _levCarArrayM = [NSMutableArray array];
    }
    return _levCarArrayM;
}

- (NSMutableArray *)imageViewArrayM
{
    if (_imageViewArrayM == nil) {
        _imageViewArrayM = [NSMutableArray array];
    }
    return _imageViewArrayM;
}

- (NSMutableArray *)carTitleArrayM
{
    if (_carTitleArrayM == nil) {
        _carTitleArrayM = [NSMutableArray array];
    }
    return _carTitleArrayM;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeSpeChooseCarCell";
    
    BeSpeChooseCarCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BeSpeChooseCarCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.priceLabel.textColor = SBHYellowColor;
    self.priceLabel.text = @"加载中";
/*
    NSString *str = @"10元 起";
    NSMutableDictionary *attStr = [NSMutableDictionary dictionary];
    attStr[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:str];
    [attrib setAttributes:attStr range:NSMakeRange([str length]-1,1)];
    self.priceLabel.attributedText = attrib;*/
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int offsetInt = (int)scrollView.contentOffset.x;
    int index = offsetInt/kImageCarW;
//    NSLog(@"%f---index--%d", scrollView.contentOffset.x, index);
    
    for (int i = 0; i<self.imageViewArrayM.count; i++) {
        UIImageView *imageView = [self.imageViewArrayM objectAtIndex:i];
        UILabel *label = [self.carTitleArrayM objectAtIndex:i];
        BeSpeCarLevelModel *levModel = [self.carlevArray objectAtIndex:i];
        if (imageView.tag == index) {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_s", levModel.name]];
            imageView.transform = CGAffineTransformMakeScale(1.3, 1.3);
            label.font = kSpeCarTitleFontSel;
            label.textColor = kSpeCarTitleColorSel;
            NSString *sufStr = @"";
            if (!levModel.didEvaluate) {
                sufStr = @"起";
                //self.priceLabel.text = [NSString stringWithFormat:@"%@元%@", levModel.start_price, sufStr];
                NSString *str = [NSString stringWithFormat:@"%@元 %@", levModel.start_price, sufStr];
                NSMutableDictionary *attStr = [NSMutableDictionary dictionary];
                attStr[NSFontAttributeName] = [UIFont systemFontOfSize:13];
                NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:str];
                [attrib setAttributes:attStr range:NSMakeRange([str length]-1,1)];
                self.priceLabel.attributedText = attrib;
            } else {
                NSString *str = [NSString stringWithFormat:@"约 %@元", levModel.start_price];
                NSMutableDictionary *attStr = [NSMutableDictionary dictionary];
                attStr[NSFontAttributeName] = [UIFont systemFontOfSize:13];
                NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:str];
                [attrib setAttributes:attStr range:NSMakeRange(0,1)];
                self.priceLabel.attributedText = attrib;
            }
            
            self.selCarModel = levModel;
        } else {
            imageView.image = [UIImage imageNamed:levModel.name];
            imageView.transform = CGAffineTransformMakeScale(1, 1);
            label.font = kSpeCarTitleFontNor;
            label.textColor = kSpeCarTitleColorNor;
        }
    }
//    if (index == 0) {
//        [_scrollView setContentOffset:CGPointMake(kImageCarW*0.5, 0) animated:NO];
//    } else {
//        [_scrollView setContentOffset:CGPointMake(kImageCarW*0.5 + kImageCarW*index, 0) animated:NO];
//    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    scrollView.scrollEnabled = NO;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    scrollView.scrollEnabled = YES;
    int offsetInt = (int)scrollView.contentOffset.x;
    int index = offsetInt/kImageCarW;
    if (index == 0) {
        [_scrollView setContentOffset:CGPointMake(kImageCarW*0.5, 0) animated:YES];
    } else {
//        if (index == 5) {
//            [_scrollView setContentOffset:CGPointMake(kImageCarW*index - kImageCarW*0.5, 0) animated:YES];
//            index = 4;
//        }else {
            [_scrollView setContentOffset:CGPointMake(kImageCarW*index + kImageCarW*0.5, 0) animated:YES];
//        }
    }
    
    for (int i = 0; i<self.imageViewArrayM.count; i++) {
        UIImageView *imageView = [self.imageViewArrayM objectAtIndex:i];
        UILabel *label = [self.carTitleArrayM objectAtIndex:i];
        BeSpeCarLevelModel *levModel = [self.carlevArray objectAtIndex:i];
        if (imageView.tag == index) {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_s", levModel.name]];
            imageView.transform = CGAffineTransformMakeScale(1.3, 1.3);
            label.font = kSpeCarTitleFontSel;
            label.textColor = kSpeCarTitleColorSel;
            NSString *sufStr = @"";
            if (!levModel.didEvaluate) {
                sufStr = @"起";
                //self.priceLabel.text = [NSString stringWithFormat:@"%@元%@", levModel.start_price, sufStr];
                NSString *str = [NSString stringWithFormat:@"%@元 %@", levModel.start_price, sufStr];
                NSMutableDictionary *attStr = [NSMutableDictionary dictionary];
                attStr[NSFontAttributeName] = [UIFont systemFontOfSize:13];
                NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:str];
                [attrib setAttributes:attStr range:NSMakeRange([str length]-1,1)];
                self.priceLabel.attributedText = attrib;
            } else {
                NSString *str = [NSString stringWithFormat:@"约 %@元", levModel.start_price];
                NSMutableDictionary *attStr = [NSMutableDictionary dictionary];
                attStr[NSFontAttributeName] = [UIFont systemFontOfSize:13];
                NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:str];
                [attrib setAttributes:attStr range:NSMakeRange(0,1)];
                self.priceLabel.attributedText = attrib;
            }
        } else {
            imageView.image = [UIImage imageNamed:levModel.name];
            imageView.transform = CGAffineTransformMakeScale(1, 1);
            label.font = kSpeCarTitleFontNor;
            label.textColor = kSpeCarTitleColorNor;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int offsetInt = (int)scrollView.contentOffset.x;
    int index = offsetInt/kImageCarW;
    if (index == 0) {
        [_scrollView setContentOffset:CGPointMake(kImageCarW*0.5, 0) animated:YES];
    } else {
//        if (index == 5) {
//            [_scrollView setContentOffset:CGPointMake(kImageCarW*index - kImageCarW*0.5, 0) animated:YES];
//            index = 4;
//        }else {
          [_scrollView setContentOffset:CGPointMake(kImageCarW*index + kImageCarW*0.5, 0) animated:YES];
//        }
    }
    
   
    for (int i = 0; i<self.imageViewArrayM.count; i++) {
        UIImageView *imageView = [self.imageViewArrayM objectAtIndex:i];
        UILabel *label = [self.carTitleArrayM objectAtIndex:i];
         BeSpeCarLevelModel *levModel = [self.carlevArray objectAtIndex:i];
        if (imageView.tag == index) {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_s", levModel.name]];
            imageView.transform = CGAffineTransformMakeScale(1.3, 1.3);
            label.font = kSpeCarTitleFontSel;
            label.textColor = kSpeCarTitleColorSel;
            NSString *sufStr = @"";
            if (!levModel.didEvaluate) {
                sufStr = @"起";
                //self.priceLabel.text = [NSString stringWithFormat:@"%@元%@", levModel.start_price, sufStr];
                
                 NSString *str = [NSString stringWithFormat:@"%@元 %@", levModel.start_price, sufStr];
                 NSMutableDictionary *attStr = [NSMutableDictionary dictionary];
                 attStr[NSFontAttributeName] = [UIFont systemFontOfSize:13];
                 NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:str];
                 [attrib setAttributes:attStr range:NSMakeRange([str length]-1,1)];
                 self.priceLabel.attributedText = attrib;
                
            } else {
                NSString *str = [NSString stringWithFormat:@"约 %@元", levModel.start_price];
                NSMutableDictionary *attStr = [NSMutableDictionary dictionary];
                attStr[NSFontAttributeName] = [UIFont systemFontOfSize:13];
                NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:str];
                [attrib setAttributes:attStr range:NSMakeRange(0,1)];
                self.priceLabel.attributedText = attrib;
            }
        } else {
            imageView.image = [UIImage imageNamed:levModel.name];
            imageView.transform = CGAffineTransformMakeScale(1, 1);
            label.font = kSpeCarTitleFontNor;
            label.textColor = kSpeCarTitleColorNor;
        }
    }
    
}

- (void)setCarlevArray:(NSArray *)carlevArray
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (BeSpeCarLevelModel *levM in carlevArray) {
//        ||[levM.name hasPrefix:@"新能源"]||[levM.name hasPrefix:@"奢华"]
        if ([levM.name hasPrefix:@"豪华"]||[levM.name hasPrefix:@"舒适"]||[levM.name hasPrefix:@"商务"]||[levM.name hasPrefix:@"经济"]) {
            [arrayM addObject:levM];
        }
    }
    _carlevArray = arrayM;
//    NSArray *titleArray = @[@"经济", @"舒适", @"商务", @"豪车"];
//    for (int i = 0; i<carlevArray.count; i++) {
//        [self.imagePathArray addObject:[NSString stringWithFormat:, i]];
//    }
    CGFloat imageH = 21;
    CGFloat imageW = kImageCarW;
    if (_carlevArray.count == 0) return;
    for (int i=0; i<_carlevArray.count; i++) {
        BeSpeCarLevelModel *levModel = [_carlevArray objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*imageW + SBHScreenW *0.5, 5, imageW, imageH)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesRecong = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapGesAction:)];
        [imageView addGestureRecognizer:gesRecong];
        //        imageView.backgroundColor = SBHColor(10*i, 20*i, 100);
        imageView.image =[UIImage imageNamed:levModel.name];
        imageView.tag = i;
        [_scrollView addSubview:imageView];
        [self.imageViewArrayM addObject:imageView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.x, CGRectGetMaxY(imageView.frame) + 10, imageView.width, 15)];
        label.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            label.font = kSpeCarTitleFontSel;
            label.textColor = kSpeCarTitleColorSel;
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_s", levModel.name]];
            imageView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        } else {
            label.font = kSpeCarTitleFontNor;
            label.textColor = kSpeCarTitleColorNor;
        }
//        if ([levModel.name hasPrefix:@"快车"]) {
//            label.text = @"经济型";
//        } else {
            label.text = levModel.name;
//        }
        [_scrollView addSubview:label];
        [self.carTitleArrayM addObject:label];
    }
    _scrollView.contentSize = CGSizeMake(_carlevArray.count*imageW + SBHScreenW - 10, 64);
    _scrollView.delegate = self;
    //    _scrollView.pagingEnabled = YES;
    [_scrollView setContentOffset:CGPointMake(imageW*0.5, 0) animated:NO];
    
    self.priceLabel.textColor = SBHYellowColor;
}

- (void)imageTapGesAction:(UIGestureRecognizer *)ges
{
    [_scrollView setContentOffset:CGPointMake(kImageCarW*ges.view.tag + kImageCarW*0.5, 0) animated:YES];
}

@end
