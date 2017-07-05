//
//  BePriceListController.m
//  SideBenefit
//
//  Created by SBH on 15-3-18.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BePriceListController.h"

@interface BePriceListController ()

@end

@implementation BePriceListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"priceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    BePriceListModel *prModel = [self.listArray objectAtIndex:indexPath.row];
    cell.textLabel.text = prModel.RoomDate;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",prModel.SalePrice];
    cell.textLabel.font = [UIFont systemFontOfSize:11];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 150)];
    headView.backgroundColor = [UIColor clearColor];
    UILabel *line = [[UILabel alloc] init];
    line.x = 15;
    line.y = headView.height - 1;
    line.height = 1;
    line.width = self.view.width - 30;
    line.backgroundColor = [UIColor whiteColor];
    [headView addSubview:line];
    
    UILabel *prTitle = [[UILabel alloc] init];
    prTitle.x = line.x;
    prTitle.height = 16;
    prTitle.y = line.y - 5 - prTitle.height;
    prTitle.width = 60;
    prTitle.textColor = SBHColor(19, 142, 234);
    prTitle.font = [UIFont systemFontOfSize:13];
    prTitle.text = self.titleStr;
    prTitle.textColor = [ColorConfigure globalBgColor];
    [headView addSubview:prTitle];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.y = prTitle.y;
    priceLabel.height = 16;
    priceLabel.width = 100;
    priceLabel.x = self.view.width - priceLabel.width - 15;
    priceLabel.textColor = SBHYellowColor;
    priceLabel.font = [UIFont systemFontOfSize:13];
    priceLabel.text = [NSString stringWithFormat:@"￥%@",self.totleMoneyStr];
    priceLabel.textAlignment = NSTextAlignmentRight;
    [headView addSubview:priceLabel];
    
    UILabel *title = [[UILabel alloc] init];
    title.x = line.x;
    title.y = prTitle.y - 50;
    title.height = 19;
    title.width = 100;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:16];
    title.text = @"费用明细";
    [headView addSubview:title];
    
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    footerView.backgroundColor = [UIColor clearColor];
    UILabel *prTitle = [[UILabel alloc] init];
    prTitle.textAlignment = NSTextAlignmentRight;
    prTitle.height = 19;
    prTitle.width = self.view.width-30;
    prTitle.x = self.view.width - 15 - prTitle.width;
    prTitle.y = footerView.height - prTitle.height - 5;
    NSString *str = [NSString stringWithFormat:@"总额：￥%@",self.totleMoneyStr];
    NSMutableDictionary *attStr = [NSMutableDictionary dictionary];
    attStr[NSForegroundColorAttributeName] = SBHYellowColor;
    attStr[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:str];
    [attrib setAttributes:attStr range:NSMakeRange(0,str.length)];
    [attrib addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 3)];
    [attrib addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 3)];
    prTitle.attributedText = attrib;
    
    [footerView addSubview:prTitle];
    return footerView;
}

@end
