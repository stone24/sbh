//
//  BeHotelFacilityDetailViewController.m
//  sbh
//
//  Created by RobinLiu on 15/12/10.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelFacilityDetailViewController.h"

@interface BeHotelFacilityDetailViewController ()
{
    
}

@end

@implementation BeHotelFacilityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设施详情";
    if([[self.item.facilities objectForKey:@"HHF_IsFreeWifi"] intValue]==1)
    {
        [self.dataArray addObject:@{@"image":@"hotellist_cell_wifi",@"title":@"免费wifi"}];
        //免费wifi
    }
    if([[self.item.facilities objectForKey:@"HHF_IsFreeNetWork"] intValue]==1)
    {
        //免费宽带
        [self.dataArray addObject:@{@"image":@"hotellist_cell_wifi",@"title":@"免费宽带"}];
    }
    if([[self.item.facilities objectForKey:@"HHF_IsCarPark"] intValue]==1)
    {
        //免费停车场
        [self.dataArray addObject:@{@"image":@"hotellist_cell_park",@"title":@"免费停车场"}];
    }
    if([[self.item.facilities objectForKey:@"HHF_IsAirportShuttle"] intValue]==1)
     {
     //接送
         [self.dataArray addObject:@{@"image":@"hotellist_cell_shuttle",@"title":@"免费接送"}];
     }
    if([[self.item.facilities objectForKey:@"HHF_IsConference"] intValue]==1)
    {
        //会议室
        [self.dataArray addObject:@{@"image":@"hotellist_cell_meetingroom",@"title":@"免费会议室"}];
    }
    if([[self.item.facilities objectForKey:@"HHF_IsBreakfast"] intValue]==1)
    {
        //酒店餐厅
        [self.dataArray addObject:@{@"image":@"hotellist_cell_diningroom",@"title":@"餐厅"}];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        CGFloat height = 35;
        int row = (int)self.dataArray.count/3;
        if(self.dataArray.count%3!=0)
        {
            row ++;
        }
        height = height + row*25;
        return height;
    }
    else if(indexPath.row == 0 && indexPath.section == 1)
    {
        return 35.0f;
    }
    else if (indexPath.row == 1 && indexPath.section == 1)
    {
        return [self getHeightWith:self.item.Hotel_Introduce] + 10;
    }
    return 100.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return 10.0f;
    }
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 0, kScreenWidth - 28, 35.0f)];
        titleLabel.text = @"酒店设施";
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.textColor = [UIColor darkGrayColor];
        [cell addSubview:titleLabel];
        int i = 0;
        for(NSDictionary *member in self.dataArray)
        {
            UIImageView *ig = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[member objectForKey:@"image"]]];
            ig.centerY = 13.0 + (25.0) * (i / 3) + 35.0f;
            ig.centerX = 20 + (kScreenWidth/3)* (i%3);
            [cell addSubview:ig];
            
            CGRect sumRect = [[member objectForKey:@"title"] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
            UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 17)];
            contentLabel.text = [member objectForKey:@"title"];
            contentLabel.textColor = [UIColor darkGrayColor];
            contentLabel.font = [UIFont systemFontOfSize:13];
            contentLabel.centerY = ig.centerY;
            contentLabel.x = CGRectGetMaxX(ig.frame) + 5;
            contentLabel.width = sumRect.size.width;
            [cell addSubview:contentLabel];
            i++;
        }
        return cell;
    }
    else if(indexPath.section == 1)
    {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
       if (indexPath.row == 0)
       {
           cell.textLabel.text = @"酒店介绍";
           cell.textLabel.font = [UIFont systemFontOfSize:18];
           cell.textLabel.textColor = [UIColor darkGrayColor];
       }
       else
       {
           cell.textLabel.text = self.item.Hotel_Introduce;
           cell.textLabel.font = [UIFont systemFontOfSize:15];
           cell.textLabel.numberOfLines = 0;
           cell.textLabel.textColor = [UIColor darkGrayColor];
       }
        return cell;
    }
    return nil;
}
- (CGFloat)getHeightWith:(NSString *)text
{
    CGRect sumRect = [text boundingRectWithSize:CGSizeMake(kScreenWidth - 15 - 20, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    return sumRect.size.height;
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
