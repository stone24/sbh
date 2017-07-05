//
//  BeMapCustomAddressCell.m
//  sbh
//
//  Created by RobinLiu on 16/1/8.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeMapCustomAddressCell.h"

@interface BeMapCustomAddressCell ()
{
    UILabel *resonLabel;
    UIImageView *leftImageView;
    UILabel *addressLabel;
}
@end

@implementation BeMapCustomAddressCell
+ (CGFloat)cellHeight
{
    return 50.0f;
}
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
    static NSString *identifier = @"BeMapCustomAddressCellIdentifier";
    BeMapCustomAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[BeMapCustomAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"specilaCar_home"]];
        [self addSubview:leftImageView];
        leftImageView.centerX = 21;
        leftImageView.centerY = [BeMapCustomAddressCell cellHeight]/2.0;
        
        self.modifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.modifyButton setImage:[UIImage imageNamed:@"specilaCar_modify"] forState:UIControlStateNormal];
        self.modifyButton.frame = CGRectMake(kScreenWidth - 50, 0, 50, [BeMapCustomAddressCell cellHeight]);
        [self addSubview:self.modifyButton];
        
        resonLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 + 10,0, 50, [BeMapCustomAddressCell cellHeight])];
        resonLabel.textColor = [UIColor blackColor];
        resonLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:resonLabel];
        
        addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 + 50,0, kScreenWidth - 30 - 50 - self.modifyButton.width, [BeMapCustomAddressCell cellHeight])];
        addressLabel.textColor = [UIColor grayColor];
        addressLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:addressLabel];
    }
    return self;
}
- (void)setAddressModel:(BeAddressModel *)model andType:(BeMapCustomAddressShowType)showType
{
    resonLabel.text = showType == BeMapCustomAddressShowTypeHome? @"家":@"公司";
    NSString *imageName = showType == BeMapCustomAddressShowTypeHome? @"specilaCar_home":@"specilaCar_company";
    leftImageView.image = [UIImage imageNamed:imageName];
    if(model.title.length >0 && model.title !=nil)
    {
        addressLabel.text = model.title;
    }
    else
    {
       if(showType == BeMapCustomAddressShowTypeHome)
       {
           addressLabel.text = @"请输入家的位置";
       }
        else
        {
            addressLabel.text = @"请输入公司的位置";
        }
    }
}
@end
