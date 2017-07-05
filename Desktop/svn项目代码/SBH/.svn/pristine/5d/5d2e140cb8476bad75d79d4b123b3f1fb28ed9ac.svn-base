//
//  BeHotelOrderRemarksViewController.m
//  sbh
//
//  Created by RobinLiu on 15/12/14.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelOrderRemarksViewController.h"
#import "BeHotelOrderDescriptionView.h"

#define kUnselectionImage @"cell_unselect"
#define kCheckBoxImage @"cell_check_box"
#define kSingleSelectionImage @"cell_single_selection"

@interface BeHotelOrderRemarksViewController ()
{
    NSMutableArray *selectIndexArray;
    BeHotelOrderDescriptionView *footerView;
}

@end

@implementation BeHotelOrderRemarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"备注";
    selectIndexArray = [[NSMutableArray alloc]init];
    [self addFooterView];
    [self.dataArray addObject:@[@"尽量安排宽带"]];
    [self.dataArray addObject:@[@"一定安排大床",@"尽量安排大床房",@"一定安排双床"]];
    [self.dataArray addObject:@[@"尽量安排无烟房",@"尽量安排吸烟房"]];

    // Do any additional setup after loading the view.
}
- (void)addFooterView
{
    footerView = [[BeHotelOrderDescriptionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    UIView *tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
    UIButton *inquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inquireButton.frame = CGRectMake(15, 25, SBHScreenW - 30, 40);
    inquireButton.layer.cornerRadius = 4.0f;
    [inquireButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [inquireButton setBackgroundColor:[ColorConfigure loginButtonColor]];
    [inquireButton setTitle:@"确定" forState:UIControlStateNormal];
    [tableFooterView addSubview:inquireButton];
    self.tableView.tableFooterView = tableFooterView;
}
- (void)saveAction
{
    if(self.block)
    {
        NSString *blockString = [NSString string];
        for(NSIndexPath *member in selectIndexArray)
        {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:member];
            blockString = [blockString stringByAppendingString:cell.textLabel.text];
            blockString = [blockString stringByAppendingString:@","];
        }
        blockString = [blockString stringByAppendingString:footerView.HotelDescriptionTV.text];
        if([[blockString substringFromIndex:blockString.length-1] isEqualToString:@","])
        {
            blockString = [blockString substringToIndex:blockString.length-1];
        }
        self.block (blockString);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataArray objectAtIndex:section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 2)
    {
        return 100;
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == self.dataArray.count - 1)
    {
        return footerView;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
    UILabel *prTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 4, kScreenWidth - 15, 16)];
    prTitle.font = [UIFont systemFontOfSize:14];
    if(section == 0)
    {
        prTitle.text = @"网络";
    }
    else if(section == 1)
    {
        prTitle.text = @"床型";
    }
    else if(section == 2)
    {
        prTitle.text = @"房型";
    }
    [headerView addSubview:prTitle];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    BOOL contains = NO;
    for(NSIndexPath *member in selectIndexArray)
    {
        if(member.section == indexPath.section && member.row == indexPath.row)
        {
            contains = YES;
            break;
        }
    }
    if(contains)
    {
        cell.imageView.image = [UIImage imageNamed:kCheckBoxImage];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:kUnselectionImage];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BOOL contains = NO;
    NSUInteger index = 0;
    for(NSIndexPath *member in selectIndexArray)
    {
        if(member.section == indexPath.section && member.row == indexPath.row)
        {
            index = [selectIndexArray indexOfObject:member];
            contains = YES;
            break;
        }
    }
    if(contains == YES)
    {
        [selectIndexArray removeObjectAtIndex:index];
    }
    else
    {
        for(NSIndexPath *member in selectIndexArray)
        {
            if(member.section == indexPath.section)
            {
                index = [selectIndexArray indexOfObject:member];
                contains = YES;
            }
        }
        if(contains)
        {
            [selectIndexArray removeObjectAtIndex:index];
        }
        [selectIndexArray addObject:indexPath];
    }
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
