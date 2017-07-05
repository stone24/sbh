//
//  BeOrderWriteInsuranceCell.m
//  sbh
//
//  Created by RobinLiu on 15/10/23.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BeOrderWriteInsuranceCell.h"
#define kMaxInsuranceCount 5 //最大保险份数
#define kMinInsuranceCount 0 //最小保险份数
@interface BeOrderWriteInsuranceCell ()
{
    UILabel *insuranceNumberLabel;
    UILabel *insuranceLabel;
    UILabel *insuTitleLabel;
    int minNumber;
    int maxNumber;
    id thisTarget;
    SEL thisPlusAction;
    SEL thisReduceAction;
    SEL thisBoardAction;
    SEL thisShow1Action;
}
@end
@implementation BeOrderWriteInsuranceCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeOrderWriteInsuranceCellIdentifier";
    BeOrderWriteInsuranceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeOrderWriteInsuranceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        insuTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 250, 20)];
        insuTitleLabel.centerY = 20.0f;
        insuTitleLabel.textColor = SBHColor(35, 35, 35);
        insuTitleLabel.font = [UIFont systemFontOfSize:17];
        insuTitleLabel.userInteractionEnabled = YES;
        [self addSubview:insuTitleLabel];

        self.nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nameButton.frame = insuTitleLabel.bounds;
        [self.nameButton addTarget:self action:@selector(showInsuranceAlert) forControlEvents:UIControlEventTouchUpInside];
        [insuTitleLabel addSubview:self.nameButton];

        insuranceNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 55, 10, 20, 20)];
        insuranceNumberLabel.textAlignment = NSTextAlignmentCenter;
        insuranceNumberLabel.textColor = SBHColor(35, 35, 35);
        insuranceNumberLabel.font = [UIFont systemFontOfSize:17];
        insuranceNumberLabel.centerY = 20.0f;
        [self addSubview:insuranceNumberLabel];
        
        self.plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.plusButton.frame = CGRectMake(kScreenWidth - 35, 10, 20, 20);
        [self.plusButton addTarget:self action:@selector(plusNumber:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.plusButton];
        
        self.reduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.reduceButton.frame = CGRectMake(kScreenWidth - 75, 10, 20, 20);
        [self.reduceButton addTarget:self action:@selector(reduceNumber:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.reduceButton];
        [self checkButtonImageView];
    }
    return self;
}
- (void)setCellWithName:(NSString *)name andCount:(int)count andPrice:(int)price andMax:(int)max andMin:(int)min andIsButtonHidden:(BOOL)hidden
{
   // insuranceLabel.text = [NSString stringWithFormat:@"%@ ￥%d/人",name,price];
    insuTitleLabel.text = [NSString stringWithFormat:@"%@ ￥%d/人",name,price];
    minNumber = min;
    maxNumber = max;
    self.plusButton.hidden = hidden;
    self.reduceButton.hidden = hidden;
    insuranceNumberLabel.text = [NSString stringWithFormat:@"%d",count];
    [self checkButtonImageView];
}
- (void)showInsuranceAlert
{
     [thisTarget performSelector:thisShow1Action withObject:self.nameButton afterDelay:0.001f];
}
- (void)plusNumber:(UIButton *)sender
{
    int count = [insuranceNumberLabel.text intValue];
    if(count == maxNumber)
    {
        return;
    }
    count ++;
     CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
     k.values = @[@(0.1),@(1.0),@(1.5)];
     k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
     k.calculationMode = kCAAnimationLinear;
     [insuranceNumberLabel.layer addAnimation:k forKey:@"SHOW"];
    
    insuranceNumberLabel.text = [NSString stringWithFormat:@"%d",count];
    [self checkButtonImageView];
    [thisTarget performSelector:thisPlusAction withObject:self.plusButton afterDelay:0.001f];
}
- (void)reduceNumber:(UIButton *)sender
{
    int count = [insuranceNumberLabel.text intValue];
    if(count == minNumber)
    {
        return;
    }
    count --;
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.5)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    [insuranceNumberLabel.layer addAnimation:k forKey:@"SHOW"];
    insuranceNumberLabel.text = [NSString stringWithFormat:@"%d",count];
    [self checkButtonImageView];
    [thisTarget performSelector:thisReduceAction withObject:self.reduceButton afterDelay:0.001f];
}
- (void)checkButtonImageView
{
    int count = [insuranceNumberLabel.text intValue];
    if(count == minNumber)
    {
        [self.reduceButton setImage:[UIImage imageNamed:@"reduce_disable_image"] forState:UIControlStateNormal];
    }
    else
    {
        [self.reduceButton setImage:[UIImage imageNamed:@"reduce_image"] forState:UIControlStateNormal];
    }
    if(count == maxNumber)
    {
        [self.plusButton setImage:[UIImage imageNamed:@"plus_disable_image"] forState:UIControlStateNormal];
    }
    else
    {
        [self.plusButton setImage:[UIImage imageNamed:@"plus_image"] forState:UIControlStateNormal];
    }
}
- (void)addTarget:(id)target WithPlusAction:(SEL)plusAction andReduceAction:(SEL)reduceAction andShowInsurance:(SEL)show1Action
{
    thisTarget = target;
    thisPlusAction = plusAction;
    thisReduceAction = reduceAction;
    thisShow1Action = show1Action;
}
@end
