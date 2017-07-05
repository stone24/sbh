//
//  BeHotelDetailController.m
//  SideBenefit
//
//  Created by SBH on 15-3-11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelDetailController.h"
#import "BeOrderWriteController.h"
#import "BeHotelFacilityDetailViewController.h"
#import "BeHotelPhotoAlbumViewController.h"
#import "CalendarHomeViewController.h"
#import "BeHotelMapViewController.h"

#import "BeHotelDetailStayCell.h"
#import "BeHotelRoomListCell.h"
#import "BeHotelDetailInfoTableViewCell.h"
#import "BeHotelRoomSectionTitleCell.h"
#import "BeHotelDetailDescriptionView.h"
#import "BeHotelDetailPolicyView.h"

#import "BeHotelRoomListFrame.h"
#import "CommonDefine.h"
#import "ServerConfigure.h"
#import "SBHHttp.h"
#import "ServerFactory.h"
#import "BeHotelServer.h"
#import "BeHotelDetailSectionModel.h"
#import "MWPhoto.h"

#import <MapKit/MapKit.h>

#define kHotelInfoSection 0
#define kHotelStaySection 1
#define kHotelPolicySection (2 + self.dataArray.count)
#define kHotelPolicySectionHeight 24.0f
#define kPlaceHolderImage @"hotellist_cell_placeHolderImage"

@interface BeHotelDetailController () <BeHotelRoomListCellDelegate>
{
    BeHotelDetailInfoFrame *detailInfoFrame;
    BeHotelRegulationModel *regulationModel;
    NSMutableArray *photosArray;
}
@end

@implementation BeHotelDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"top_right_index"] style:UIBarButtonItemStylePlain target:self action:@selector(backMainBtn)];
        photosArray = [[NSMutableArray alloc]init];
        regulationModel = [[BeHotelRegulationModel alloc]init];
    }
    return self;
}

- (void)backMainBtn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginEvent:@"H0001"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"酒店详情";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getHotelDetailInfo) name:@"refreshHotelDetail" object:nil];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kHotelPolicySectionHeight)];
    self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    detailInfoFrame = [[BeHotelDetailInfoFrame alloc]init];
    detailInfoFrame.listData = self.item;
    [self getHotelDetailInfo];
}
#pragma mark - 获取酒店相册列表数据
- (void)getHotelImageData
{
    NSString *url = [NSString stringWithFormat:@"%@HotelNew/GetHotalImages",kServerHost];
    [[SBHHttp sharedInstance]postPath:url withParameters:@{@"HotelId":self.item.hotelId,@"usertoken":[GlobalData getSharedInstance].token}showHud:NO success:^(NSDictionary *callback)
     {
         [photosArray removeAllObjects];
         for(NSDictionary *member in [callback objectForKey:@"BackInfo"])
         {
             [photosArray addObject:member];
         }
         NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
         [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
     }failure:^(NSError *error)
     {
         
     }];
}
#pragma mark - 获取酒店详情数据
- (void)getHotelDetailInfo
{
    NSString *flag = @"false";
    if(self.sourceType == HotelDetailSourceTypeOrderList)
    {
        flag = @"true";
    }
    [[ServerFactory getServerInstance:@"BeHotelServer"]getHotelDetailWith:self.item andFlag:flag byCallback:^(NSMutableDictionary *callback)
    {
        [self.dataArray removeAllObjects];
        [self.item setItemWithDict:[callback dictValueForKey:@"BackInfo"]];
        detailInfoFrame.listData = self.item;
        
        self.item.canBook = ([[[callback dictValueForKey:@"BackInfo"] arrayValueForKey:@"RoomInfo"] count] >0)?YES:NO;
        detailInfoFrame.listData.canBook = self.item.canBook;
        
        if([[callback dictValueForKey:@"BackInfo"] dictValueForKey:@"HotelRegulation"]!=nil)
        {
            regulationModel = [[BeHotelRegulationModel alloc]initWithDict:[[callback dictValueForKey:@"BackInfo"] dictValueForKey:@"HotelRegulation"]];
        }
        for(NSDictionary *member in [[callback dictValueForKey:@"BackInfo"] arrayValueForKey:@"RoomInfo"])
        {
            BeHotelDetailSectionModel *sectionModel = [[BeHotelDetailSectionModel alloc]initWithDict:member];
            [self.dataArray addObject:sectionModel];
        }
        [self.tableView reloadData];
        [self getHotelImageData];
    }failureCallback:^(NSString *failureCallback)
    {
        
    }];
}

#pragma mark - TableView DataDource && Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3 + self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == kHotelInfoSection ||section == kHotelStaySection || section == kHotelPolicySection)
    {
        return 1;
    }
    else
    {
        BeHotelDetailSectionModel *sectionModel = [self.dataArray objectAtIndex:section - 2];
        if(sectionModel.isSread)
        {
            return sectionModel.cellArray.count + 1;
        }
        else
        {
            return 1;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == kHotelInfoSection)
    {
        return detailInfoFrame.cellHeight;
    }
    else if(indexPath.section == kHotelStaySection)
    {
        return [BeHotelDetailStayCell cellHeight];
    }
    else if (indexPath.section == kHotelPolicySection)
    {
        NSString *policyString = [NSString stringWithFormat:@"%@\n酒店提示\n%@",regulationModel.Rul_ArrAndDep,regulationModel.Rul_Cancel];
        CGRect sumRect = [policyString boundingRectWithSize:CGSizeMake(kScreenWidth - 15 - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        return sumRect.size.height + 10;
    }
    else
    {
        if(indexPath.row == 0)
        {
            return [BeHotelRoomSectionTitleCell cellHeight];
        }
        else
        {
            if(self.dataArray.count > 0)
            {
               BeHotelDetailSectionModel *sectionModel = [self.dataArray objectAtIndex:indexPath.section - 2];
                BeHotelRoomListFrame *frame = [sectionModel.cellDisplayArray objectAtIndex:(indexPath.row-1)];
                return frame.cellHeight;
            }
        }
    }
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == kHotelStaySection)
    {
        return 5;
    }
    else if(section == kHotelPolicySection)
    {
        return kHotelPolicySectionHeight;
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == kHotelPolicySection)
    {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kHotelPolicySectionHeight)];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 0, kScreenWidth - 28, kHotelPolicySectionHeight)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = @"酒店政策";
        titleLabel.textColor = [UIColor darkGrayColor];
        [headerView addSubview:titleLabel];
        return headerView;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == kHotelInfoSection)
    {
        BeHotelDetailInfoTableViewCell *cell = [BeHotelDetailInfoTableViewCell cellWithTableView:tableView];
        cell.infoFrame = detailInfoFrame;
        [cell updateImageUIWith:photosArray.count];
        [cell addTarget:self WithMapAction:@selector(showMapViewAction) andFacilityAction:@selector(showDetailFacilityAction) andImageAction:@selector(showImageListAction)];
        return cell;
    }
    else if(indexPath.section == kHotelStaySection)
    {
        BeHotelDetailStayCell *cell = [BeHotelDetailStayCell cellWithTableView:tableView];
        [cell updateUIWithCheckIn:self.item.CheckInDate andCheckOut:self.item.CheckOutDate];
        [cell addTarget:self andCheckIn:@selector(chooseCheckInDate) andCheckOut:@selector(chooseCheckOutDate)];
        return cell;
    }
    else if (indexPath.section == kHotelPolicySection)
    {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.text = [NSString stringWithFormat:@"%@\n酒店提示\n%@",regulationModel.Rul_ArrAndDep,regulationModel.Rul_Cancel];
        return cell;
    }
    else
    {
        if(indexPath.row == 0)
        {
            BeHotelRoomSectionTitleCell *headerCell = [BeHotelRoomSectionTitleCell cellWithTableView:tableView];
            headerCell.sectionModel = [self.dataArray objectAtIndex:indexPath.section - 2];
            return headerCell;
        }
        else
        {
            BeHotelRoomListCell *cell = [BeHotelRoomListCell cellWithTableView:tableView];
            cell.delegate = self;
            cell.indexPath = indexPath;
            BeHotelDetailSectionModel *sectionModel = [self.dataArray objectAtIndex:indexPath.section - 2];
            cell.listFrame = [sectionModel.cellDisplayArray objectAtIndex:(indexPath.row-1)];
            return cell;
        }
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == kHotelPolicySection)
    {
        [[BeHotelDetailPolicyView sharedInstance]showViewWithData:regulationModel];
    }
    else if (indexPath.section != kHotelPolicySection &&indexPath.section !=kHotelInfoSection && indexPath.section !=kHotelStaySection)
    {
        if(indexPath.row == 0)
        {
            [self sectionViewChangeArrowWith:indexPath.section];
        }
        else
        {
            [self showDetailWithIndexPath:indexPath];
        }
    }
}
#pragma mark - 预订
- (void)bookWithIndexPath:(NSIndexPath *)indexP
{
    BeHotelOrderWriteModel *writeModel = [[BeHotelOrderWriteModel alloc]init];
    BeHotelDetailSectionModel *sectionModel = [self.dataArray objectAtIndex:indexP.section - 2];
    [writeModel setDataWith:self.item and:sectionModel and:[sectionModel.cellArray objectAtIndex:(indexP.row-1)]];
    BeOrderWriteController *writeVc =[[BeOrderWriteController alloc] init];
    writeVc.writeModel = writeModel;
    [self.navigationController pushViewController:writeVc animated:YES];
}
#pragma mark - 显示每个房间的详情
- (void)showDetailWithIndexPath:(NSIndexPath *)indexP
{
    BeHotelDetailSectionModel *sectionModel = [self.dataArray objectAtIndex:indexP.section - 2];
    BeHotelDetailRoomListModel *listModel = [sectionModel.cellArray objectAtIndex:(indexP.row-1)];
    [[BeHotelDetailDescriptionView sharedInstance]showViewWithData:listModel andCheckInDate:self.item.CheckInDate  andBlock:^{
        [self bookWithIndexPath:indexP];
    }];
}
#pragma mark - 控制sectionHeaderView的cell个数
- (void)sectionViewChangeArrowWith:(NSInteger )section
{
    BeHotelDetailSectionModel *model = [self.dataArray objectAtIndex:section - 2];
    model.isSread = !model.isSread;
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    dispatch_async(dispatch_get_main_queue(), ^{
        //刷新完成
        if(model.isSread)
        {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    });
}
#pragma mark - 地图/周边/导航
- (void)showMapViewAction
{
    BeHotelMapViewController *mapVC = [[BeHotelMapViewController alloc]init];
    mapVC.hotelItem = self.item;
    [self.navigationController pushViewController:mapVC animated:YES];
}
#pragma mark - 酒店设施详情
- (void)showDetailFacilityAction
{
    BeHotelFacilityDetailViewController *facilityVC = [[BeHotelFacilityDetailViewController alloc]init];
    facilityVC.item = self.item;
    [self.navigationController pushViewController:facilityVC animated:YES];
}
#pragma mark - 酒店图片列表
- (void)showImageListAction
{
    BeHotelPhotoAlbumViewController *photoAlbumVC = [[BeHotelPhotoAlbumViewController alloc]init];
    photoAlbumVC.photos = photosArray;
    [self.navigationController pushViewController:photoAlbumVC animated:YES];
}
#pragma mark - 选择入住时间
- (void)chooseCheckInDate
{
    NSDate *startDate = [CommonMethod dateFromString:self.item.CheckInDate WithParseStr:@"yyyy-MM-dd"];
    NSDate *leaveDate = [CommonMethod dateFromString:self.item.CheckOutDate WithParseStr:@"yyyy-MM-dd"];
    
    CalendarHomeViewController *dateSelectVC = [[CalendarHomeViewController alloc]init];
    [dateSelectVC setCalendarType:DayTipsTypeHotelStart andSelectDate:startDate andStartDate:[NSDate date]];
    dateSelectVC.calendarblock = ^(CalendarDayModel *model)
    {
        NSDate *chooseStartDate = [model date];
        self.item.CheckInDate = [chooseStartDate stringFromDate:chooseStartDate];
        NSTimeInterval time=[leaveDate timeIntervalSinceDate:chooseStartDate];
        if(((int)time)/(3600*24)<1)
        {
            NSDate *edate = [chooseStartDate dateByAddingTimeInterval:3600*24*1];
            self.item.CheckOutDate = [edate stringFromDate:edate];
        };
        [self getHotelDetailInfo];
        [self.tableView reloadData];
    };
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:dateSelectVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
#pragma mark - 选择离店时间
- (void)chooseCheckOutDate
{
    NSDate *startDate = [CommonMethod dateFromString:self.item.CheckInDate WithParseStr:@"yyyy-MM-dd"];
    NSDate *chooseLeaveDate = [CommonMethod dateFromString:self.item.CheckOutDate WithParseStr:@"yyyy-MM-dd"];

    NSDate *leaveDate = [startDate dateByAddingTimeInterval:3600*24*1];
    
    CalendarHomeViewController *dateSelectVC = [[CalendarHomeViewController alloc]init];
    [dateSelectVC setCalendarType:DayTipsTypeHotelLeave andSelectDate:chooseLeaveDate andStartDate:leaveDate];
    dateSelectVC.calendarblock = ^(CalendarDayModel *model)
    {
        self.item.CheckOutDate = [[model date] stringFromDate:[model date]];
        [self.tableView reloadData];
        [self getHotelDetailInfo];
    };
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:dateSelectVC];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
