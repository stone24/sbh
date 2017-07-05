//
//  BeAlterationFlightCell.m
//  sbh
//
//  Created by SBH on 15/4/14.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeAlterationFlightCell.h"
#import "BeFlightModel.h"
#import "BeTrainInfoModel.h"

@interface BeAlterationFlightCell ()
@property (weak, nonatomic) IBOutlet UILabel *flightTilte;
@property (weak, nonatomic) IBOutlet UILabel *flightValue;

@end

@implementation BeAlterationFlightCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"BeAlterationFlightCell";
    
    BeAlterationFlightCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BeAlterationFlightCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)setFlightM:(BeFlightModel *)flightM
{
    _flightM = flightM;
    
    self.flightTilte.text = flightM.flightTilteStr;
    self.flightValue.text = flightM.flightValueStr;
}

- (void)setTrainM:(BeTrainInfoModel *)trainM
{
    _trainM = trainM;
    self.flightTilte.text = trainM.altTilteStr;
    self.flightValue.text = trainM.altValueStr;
}
@end
