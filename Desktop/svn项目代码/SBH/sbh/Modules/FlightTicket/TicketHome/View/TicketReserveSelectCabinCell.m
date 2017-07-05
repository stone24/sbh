//
//  cangweixuanzeTableViewCell.m
//  SBHAPP
//
//  Created by musmile on 14-6-27.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "TicketReserveSelectCabinCell.h"

#define kCaBinSelectTitle @"舱位选择"
#define kReasonSelectTitle @"出行事由"

@implementation TicketReserveSelectCabinCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"TicketReserveSelectCabinCell";
    TicketReserveSelectCabinCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[[NSBundle mainBundle] loadNibNamed:@"TicketReserveSelectCabinCell" owner:nil options:nil] firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    return cell;
}
- (void)setDisplayType:(CellDisplayType)displayType
{
    _displayType = displayType;
    switch (displayType) {
        case kCellDisplayTypeCabin:
        {
            _cangweixuanze.text = kCaBinSelectTitle;
        }
            break;
         case kCellDisplayTypeReason:
        {
            _cangweixuanze.text = kReasonSelectTitle;
        }
            break;
        default:
            break;
    }
}
@end
