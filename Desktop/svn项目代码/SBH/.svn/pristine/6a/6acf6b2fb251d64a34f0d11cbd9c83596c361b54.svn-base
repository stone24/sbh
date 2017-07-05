//
//  BeAuditProjectViewController.m
//  sbh
//
//  Created by RobinLiu on 16/2/18.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeAuditProjectViewController.h"
#import "BeRegularExpressionUtil.h"
#import "SBHHttp.h"
#import "ServerFactory.h"
#import "UIAlertView+Block.h"
#import "ColorConfigure.h"

@interface BeAuditProjectViewController ()
{
    NSMutableArray *filterArray;
}

@end

@implementation BeAuditProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请选择项目";
    filterArray = [[NSMutableArray alloc]init];
    [self getAuditProjectData];
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tableView)
    {
        return self.dataArray.count;
    }
    else
    {
        [self updateFilterCondition:self.searchBar.text];
        return filterArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    for(UIView *subView in [cell subviews])
    {
        if([subView isKindOfClass:[UILabel class]])
        {
            [subView removeFromSuperview];
        }
    }
    BeAuditProjectModel *model;
    if(tableView == self.tableView)
    {
         model = [self.dataArray objectAtIndex:indexPath.row];
    }
    else
    {
         model = [filterArray objectAtIndex:indexPath.row];
    }
    UILabel *cellTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [cellTextLabel setNumberOfLines:0];
    [cellTextLabel setFrame:CGRectMake(12,0, kScreenWidth - 24,40)];
    cellTextLabel.text = model.projectName;
    cellTextLabel.font = [UIFont systemFontOfSize:15];
    [cell addSubview:cellTextLabel];
    
    if([model.AvailableAmount integerValue] != -1)
    {
        UILabel *cellDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [cellDetailLabel setNumberOfLines:0];
        [cellDetailLabel setFrame:CGRectMake(12,40, kScreenWidth - 24,20)];
        cellDetailLabel.text = [NSString stringWithFormat:@"可用预算:%@",model.AvailableAmount];
        cellDetailLabel.textColor = [ColorConfigure loginButtonColor];
        cellDetailLabel.font = [UIFont systemFontOfSize:13];
        [cell addSubview:cellDetailLabel];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BeAuditProjectModel *model;
    if(tableView == self.tableView)
    {
        model = [self.dataArray objectAtIndex:indexPath.row];
    }
    else
    {
        model = [filterArray objectAtIndex:indexPath.row];
    }
    if([model.AvailableAmount integerValue] == -1)
    {
        [self getProjectAuditWith:model];
    }
    else if([model.AvailableAmount intValue] < [self.priceAmount intValue])
    {
        [CommonMethod showMessage:@"您预订的机票总金额超出了该项目的预算金额"];
        return;
    }
    else
    {
        [self getProjectAuditWith:model];
    }
}
#pragma mark - 获取项目审批人
- (void)getProjectAuditWith:(BeAuditProjectModel *)auditModel
{
    [[ServerFactory getServerInstance:@"BeAirTicketOrderWriteTool"]getProjectAuditPersonsWith:auditModel andPassengers:self.passengerArray andTicketId:self.TicketId andType:self.projectSourceType BySuccess:^(id dict)
     {
         if([dict dictValueForKey:@"projects"]!=nil)
         {
             NSMutableArray *dataArray = [[NSMutableArray alloc]init];
             NSDictionary *projects = [dict dictValueForKey:@"projects"];
             if([projects arrayValueForKey:@"FlowInformations"]!=nil)
             {
                 for(id member in [projects arrayValueForKey:@"FlowInformations"])
                 {
                     if (!([member isKindOfClass:[NSNull class]]||member==nil))
                     {
                         NSDictionary *dictMember = (NSDictionary *)member;
                         if([[dictMember stringValueForKey:@"type"] isEqualToString:@"3"])
                         {
                             [dataArray addObjectsFromArray: [BeOrderWriteModel setupAuditArrayWith:[dictMember arrayValueForKey:@"approvars"]]];
                         }
                     }
                 }
                 if(dataArray.count == 0)
                 {
                     UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该项目没有审批人" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                     [al showAlertViewWithCompleteBlock:^(NSInteger index)
                      {
                          return ;
                      }];
                     return;
                 }
                 else
                 {
                     NSString *flowID = [[[[dict objectForKey:@"projects"] objectForKey:@"FlowInformations"] firstObject]stringValueForKey:@"flowID" defaultValue:@""];
                     
                     self.block(dataArray,auditModel,flowID);
                     [self.navigationController popViewControllerAnimated:YES];
                 }
             }
             else
             {
                 UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该项目没有审批人" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [al showAlertViewWithCompleteBlock:^(NSInteger index)
                  {
                      return ;
                  }];
                 return;
             }
         }

     }failure:^(NSString *error)
     {
         // [self requestFlase:error];
     }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 获取审批的项目
- (void)getAuditProjectData
{
    NSString *urlString = [NSString stringWithFormat:@"%@Audit/AuditProjects",kServerHost];
    [[SBHHttp sharedInstance]postPath:urlString withParameters:@{@"usertoken":[GlobalData getSharedInstance].token,@"ticketid":self.TicketId} showHud:YES success:^(NSDictionary *callback)
    {
        if([callback dictValueForKey:@"projects"]!=nil)
        {
            if([[callback objectForKey:@"projects"] arrayValueForKey:@"ProjectInformations"]!=nil)
            {
                for(NSDictionary *member in [[callback objectForKey:@"projects"] arrayValueForKey:@"ProjectInformations"])
                {
                    BeAuditProjectModel *model = [[BeAuditProjectModel alloc]init];
                    model.projectName = [member stringValueForKey:@"projectName" defaultValue:@""];
                    model.porjectNo = [member stringValueForKey:@"porjectNo" defaultValue:@""];
                    model.AvailableAmount = [member stringValueForKey:@"AvailableAmount" defaultValue:@"0.00"];
                    [self.dataArray addObject:model];
                }
                [self.tableView reloadData];
            }
        }
    }failure:^(NSError *error)
    {
    }];
}
- (void)updateFilterCondition:(NSString *)condition
{
    [filterArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"projectName CONTAINS %@",condition];
    [filterArray addObjectsFromArray:[self.dataArray filteredArrayUsingPredicate:predicate]];
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
