//
//  BeHotelSearchContentCell.m
//  SideBenefit
//
//  Created by RobinLiu on 15/3/11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelSearchContentCell.h"

@implementation BeHotelSearchContentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeHotelSearchContentCell";
    BeHotelSearchContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[[NSBundle mainBundle] loadNibNamed:@"BeHotelSearchContentCell" owner:nil options:nil] firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
    self.selectionStyle = UITableViewCellEditingStyleNone;
    _canSelect = YES;
    self.markImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:kSingleSelectionImage]];;
    self.markImageView.centerX = 28;
    self.markImageView.centerY = self.contentLabel.centerY;
    [self.contentView addSubview:self.markImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(_canSelect)
    {
        NSString *imageName = selected== YES?kSingleSelectionImage:kUnselectionImage;
        UIImage *image = [UIImage imageNamed:imageName];
        self.markImageView.image = image;
        self.markImageView.size = image.size;
    }
    // Configure the view for the selected state
}
- (void)setCellWithTicketQuery:(BeTicketQueryDataSource *)item andIndex:(NSIndexPath *)indexPath
{
    _markImageView.size = CGSizeZero;
    _markImageView.centerY = _contentLabel.centerY;
    _canSelect = NO;
    if([item.selectItemTitle isEqualToString:kFilterNonstopFlightTitle])
    {
        
    }
    else if([item.selectItemTitle isEqualToString:kFilterTakeOffTimeTitle])
    {
        _contentLabel.text = [item.takeOffTimeConditionArray objectAtIndex:indexPath.row];
        if ([item.selectedDateArray containsObject: _contentLabel.text])
        {
            if([_contentLabel.text isEqualToString:kFilterConditionUnlimited])
            {
                [self setSingleSelectionImage];
            }
            else
            {
                [self setCheckBoxImage];
            }
        }
        else
        {
            [self setUnselectionImage];
        }
    }
    else if([item.selectItemTitle isEqualToString:kFilterAirportTitle])
    {
        if(indexPath.section == 0)
        {
            _contentLabel.text = [item.departureAirportArray objectAtIndex:indexPath.row];
            if ([item.selectedDepartureAirportArray containsObject: _contentLabel.text])
            {
                if([_contentLabel.text isEqualToString:kFilterConditionUnlimited])
                {
                    [self setSingleSelectionImage];
                }
                else
                {
                    [self setCheckBoxImage];
                }
            }
            else
            {
                [self setUnselectionImage];
            }
        }
        if(indexPath.section == 1)
        {
            _contentLabel.text = [item.arriveAirportArray objectAtIndex:indexPath.row];
            if ([item.selectedArriveAirportArray containsObject: _contentLabel.text])
            {
                if([_contentLabel.text isEqualToString:kFilterConditionUnlimited])
                {
                    [self setSingleSelectionImage];
                }
                else
                {
                    [self setCheckBoxImage];
                }
            }
            else
            {
                [self setUnselectionImage];
            }
        }
    }
    else if([item.selectItemTitle isEqualToString:kFilterCabinTitle])
    {
        _contentLabel.text = [item.cabinConditionArray objectAtIndex:indexPath.row];
        if ([item.selectedCabin isEqualToString: _contentLabel.text])
        {
            [self setSingleSelectionImage];
        }
        else
        {
            [self setUnselectionImage];
        }
        
    }
    else if([item.selectItemTitle isEqualToString:kFilterAirlineCompanyTitle])
    {
        _contentLabel.text = [item.airlineCompanyConditionArray objectAtIndex:indexPath.row];
        if ([item.selectedAirCompanyArray containsObject: _contentLabel.text])
        {
            if([_contentLabel.text isEqualToString:kFilterConditionUnlimited])
            {
                [self setSingleSelectionImage];
            }
            else
            {
                [self setCheckBoxImage];
            }
        }
        else
        {
            [self setUnselectionImage];
        }
    }
    //_markImageView.size = _markImageView.image.size;
}
- (void)setSingleSelectionImage
{
    _markImageView.image = [UIImage imageNamed:kSingleSelectionImage];
    _markImageView.size = [UIImage imageNamed:kSingleSelectionImage].size;
    _markImageView.centerY = _contentLabel.centerY;
}
- (void)setUnselectionImage
{
    _markImageView.image = [UIImage imageNamed:kUnselectionImage];
    _markImageView.size = [UIImage imageNamed:kUnselectionImage].size;
    _markImageView.centerY = _contentLabel.centerY;
}
- (void)setCheckBoxImage
{
    _markImageView.image = [UIImage imageNamed:kCheckBoxImage];
    _markImageView.size = [UIImage imageNamed:kCheckBoxImage].size;
    _markImageView.centerY = _contentLabel.centerY;
}
@end
