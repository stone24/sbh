//
//  BeSearchResultViewController.m
//  sbh
//
//  Created by liuxiaodan on 15/5/7.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeResultTableController.h"
#import "BeBaseModel.h"

@interface BeResultTableController ()

@end

@implementation BeResultTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    BeBaseModel *cellModel = [self.filteredArray objectAtIndex:indexPath.row];
    cell.textLabel.text = cellModel.titleDescription;
    cell.detailTextLabel.text = cellModel.detailDescription;
    return cell;
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
