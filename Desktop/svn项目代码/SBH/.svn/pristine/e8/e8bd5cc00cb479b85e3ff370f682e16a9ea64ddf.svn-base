//
//  BeAuditPersonViewController.m
//  sbh
//
//  Created by RobinLiu on 16/2/18.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeAuditPersonViewController.h"

@interface BeAuditPersonViewController ()

@end

@implementation BeAuditPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"审批人信息";
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row == 0)
    {
        cell.textLabel.text = @"审批人姓名";
        cell.detailTextLabel.text = self.model.Name;
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"审批人电话";
        cell.detailTextLabel.text = self.model.Mobile;
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"审批人邮箱";
        cell.detailTextLabel.text = self.model.Email;
    }
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
