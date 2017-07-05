//
//  BeSpeCarFinishTableViewCell.m
//  sbh
//
//  Created by RobinLiu on 2016/12/22.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeSpeCarFinishTableViewCell.h"

@interface BeSpeCarFinishTitleTableViewCell ()
{
    UILabel *contentLabel;
}

@end

@implementation BeSpeCarFinishTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"BeSpeCarFinishTitleTableViewCellIdentifier";
    BeSpeCarFinishTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeSpeCarFinishTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.backgroundColor = cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kBeSpeCarFinishTableViewCellTitleHeight)];
        contentLabel.numberOfLines = 0;
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.textColor = [UIColor grayColor];
        contentLabel.font = [UIFont boldSystemFontOfSize:17];
        [self addSubview:contentLabel];
    }
    return self;
}
- (void)setTitle:(NSString *)title andContent:(NSString *)content
{
    NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",title,content]];
    [attrib addAttributes:@{NSForegroundColorAttributeName:SBHYellowColor} range:NSMakeRange(0,[title length])];
    [attrib addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]} range:NSMakeRange(0,[title length])];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [paragraphStyle setLineSpacing:5.0];

    [attrib addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [[NSString stringWithFormat:@"%@\n%@",title,content] length])];
    contentLabel.attributedText = attrib;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

@interface BeSpeCarFinishTableViewCell ()
{
    UILabel *contentLabel;
}

@end

@implementation BeSpeCarFinishTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"BeSpeCarFinishTableViewCellIdentifier";
    BeSpeCarFinishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeSpeCarFinishTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.backgroundColor = cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth-30, kBeSpeCarFinishTableViewCellOrderContentHeight)];
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.textColor = [UIColor grayColor];
        contentLabel.numberOfLines = 0;
        [self addSubview:contentLabel];
    }
    return self;
}
- (void)setCarModel:(BeSpeCallCarPramaModel *)carModel
{
    _carModel = carModel;
    NSString *str1 = @"用车时间：";
    NSString *str2 = _carModel.ridingdate;
    NSString *str3 = @"\n乘车人：";
    NSString *str4 = [NSString stringWithFormat:@"%@ %@", _carModel.passenger_name, _carModel.passenger_phone];
    NSString *str5 = @"\n出发地：";
    NSString *str6 = _carModel.start_address;
    NSString *str7 = @"\n到达地：";
    NSString *str8 = _carModel.end_address;

    NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",str1,str2,str3,str4,str5,str6,str7,str8]];
    [attrib setAttributes:@{NSForegroundColorAttributeName:SBHYellowColor} range:NSMakeRange([str1 length],[str2 length])];
    [attrib setAttributes:@{NSForegroundColorAttributeName:SBHYellowColor} range:NSMakeRange([str1 length]+[str2 length]+[str3 length],[str4 length])];
    [attrib setAttributes:@{NSForegroundColorAttributeName:kPlaceLabelColor} range:NSMakeRange([str1 length]+[str2 length]+[str3 length]+[str4 length]+[str5 length],[str6 length])];
    [attrib setAttributes:@{NSForegroundColorAttributeName:kPlaceLabelColor} range:NSMakeRange([attrib length]-[str8 length],[str8 length])];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8.0];
    [attrib addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",str1,str2,str3,str4,str5,str6,str7,str8] length])];
    contentLabel.attributedText = attrib;
    
    CGFloat maxWidth = kScreenWidth - 30.0;
    CGFloat width1 = [[NSString stringWithFormat:@"%@%@",str1,str2] boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:contentLabel.font} context:nil].size.width;
    CGFloat width2 = [[NSString stringWithFormat:@"%@%@",str3,str4] boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:contentLabel.font} context:nil].size.width;
    CGFloat width3 = [[NSString stringWithFormat:@"%@%@",str5,str6] boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:contentLabel.font} context:nil].size.width;
    CGFloat width4 = [[NSString stringWithFormat:@"%@%@",str7,str8] boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:contentLabel.font} context:nil].size.width;
    CGFloat max1 = width1>width2?width1:width2;
    CGFloat max2 = width3>width4?width3:width4;
    CGFloat width = max1>max2?max1:max2;
    contentLabel.x = (kScreenWidth - width)/2.0;
    contentLabel.width = width;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@interface BeSpeCarFinishTimerTableViewCell ()
{
    UILabel *contentLabel;
}

@end

@implementation BeSpeCarFinishTimerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"BeSpeCarFinishTimerTableViewCellIdentifier";
    BeSpeCarFinishTimerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeSpeCarFinishTimerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.backgroundColor = cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kBeSpeCarFinishTableViewCellTimerHeight)];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont systemFontOfSize:16];
        contentLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:contentLabel];
    }
    return self;
}
- (void)setCellWithMinute:(int)minute andSecond:(int)second andCarNum:(int)carNum
{
    NSString *str1 = @"已用时 ";
    NSString *str2 = [NSString stringWithFormat:@"%02d:%02d",minute,second];
    NSString *str3 = @"\n已通知 ";
    NSString *str4 = [NSString stringWithFormat:@"%d",carNum];
    NSString *str5 = @" 辆车";
    
    NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@%@%@",str1,str2,str3,str4,str5]];
    [attrib setAttributes:@{NSForegroundColorAttributeName:SBHYellowColor} range:NSMakeRange([str1 length],[str2 length])];
    [attrib setAttributes:@{NSForegroundColorAttributeName:SBHYellowColor} range:NSMakeRange([str1 length]+[str2 length]+[str3 length],[str4 length])];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [paragraphStyle setLineSpacing:5.0];
    [attrib addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [[NSString stringWithFormat:@"%@%@%@%@%@",str1,str2,str3,str4,str5] length])];
    contentLabel.attributedText = attrib;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

@interface BeSpeCarFinishDriverTableViewCell ()
{
    UILabel *contentLabel;
}

@end

@implementation BeSpeCarFinishDriverTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"BeSpeCarFinishDriverTableViewCellIdentifier";
    BeSpeCarFinishDriverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeSpeCarFinishDriverTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.backgroundColor = cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kBeSpeCarFinishTableViewCellTimerHeight)];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont systemFontOfSize:16];
        contentLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:contentLabel];
        
        UIImage *buttonImage = [UIImage imageNamed:@"spe_callCar_phone"];
        self.phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.phoneButton.size = buttonImage.size;
        self.phoneButton.centerY = kBeSpeCarFinishTableViewCellTimerHeight/2.0;
        [self.phoneButton setImage:buttonImage forState:UIControlStateNormal];
        [self addSubview:self.phoneButton];
    }
    return self;
}
- (void)setDriverModel:(BeSpeCallCarResultModel *)driverModel
{
    _driverModel = driverModel;
    NSString *str1 = [NSString stringWithFormat:@"%@：%@",_driverModel.DriverName,_driverModel.DriverMobile];
    NSString *str2 = [NSString stringWithFormat:@"%@ %@",_driverModel.LicenseNumber,_driverModel.CarName];
    contentLabel.text = [NSString stringWithFormat:@"%@\n%@",str1,str2];
    
    CGFloat str1Width = [str1 boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:contentLabel.font} context:nil].size.width;
    CGFloat str2Width = [str2 boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:contentLabel.font} context:nil].size.width;

    CGFloat space = 16.0;
    CGFloat maxWidth = str1Width>str2Width?str1Width:str2Width;
    contentLabel.x = (kScreenWidth - maxWidth - space - self.phoneButton.size.width)/2.0;
    contentLabel.width = maxWidth;
    
    self.phoneButton.x = CGRectGetMaxX(contentLabel.frame) + space;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
