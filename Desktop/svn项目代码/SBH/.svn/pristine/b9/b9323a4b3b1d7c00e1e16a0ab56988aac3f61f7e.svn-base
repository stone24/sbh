//
//  MessageListViewController.m
//  sbh
//
//  Created by RobinLiu on 15/1/28.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "MessageListViewController.h"
#import "MJRefresh.h"
#import "ServerFactory.h"
#import "MessageServer.h"
#import "MsgListCell.h"
#import "MsgEditView.h"
#import "BeFlightOrderDetailController.h"
#import "CommonDefine.h"
#import "SBHManageModel.h"
#import "MBProgressHUD.h"
#import "BeWebViewController.h"
#import "BeHotelOrderDetailController.h"
#import "BeHotelOrderModel.h"
#import "BeAirDynamicViewController.h"
#import "BeTrainOrderDetailController.h"
#import "ColorConfigure.h"
#import "BeCarOrderDetailViewController.h"

typedef NS_ENUM(NSInteger, MessageStatusUpdate) {
    MessageStatusDelete = 0,
    MessageStatusRead = 1,
};
@interface MessageListViewController ()<MsgCellDelegate,MsgEditViewDelegate>
{
    int currentPage;
    int pageCount;
}

@property (nonatomic,retain)MsgEditView *bottomEditView;
@property (nonatomic,retain)UIBarButtonItem *rightItem;
@property (nonatomic,retain)UIBarButtonItem *leftItem;
@property (nonatomic,assign)BOOL isEditing;
@property (nonatomic,assign)BOOL checkAll;
@property (nonatomic,retain)NSMutableArray *editArray;
@property (nonatomic,retain)NSMutableArray *heightArray;
@end

@implementation MessageListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(msgTabbarChangeUI:) name:kNotificationMsgUpdate object:nil];
        //[self setTabBarCount];
        currentPage = 1;
    };
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.tableView)
    {
        self.isEditing = NO;
        self.isEditing = NO;
        self.checkAll = NO;
        [self pullToRefreshTableAction];
    }
    self.bottomEditView.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showEditView];
    self.isEditing = NO;
    self.checkAll = NO;
    self.title = @"消息";
    currentPage = 1;
    self.tableView.height = self.view.frame.size.height - CGRectGetHeight(self.navigationController.navigationBar.frame)- CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    self.rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(doEditAction)];
    self.navigationItem.rightBarButtonItem= self.rightItem;
//    self.leftItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(doLeftAction)];
//    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.editArray = [[NSMutableArray alloc]init];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullToRefreshTableAction)];
    [self pullToRefreshTableAction];
    self.heightArray = [[NSMutableArray alloc]init];
    MsgListCell * cell = [[MsgListCell alloc]init];
    [self.heightArray addObject:cell];
}
- (void)doLeftAction
{
    if(![self.leftItem.title isEqualToString:@""])
    {
        if([self.leftItem.title isEqualToString:@"全选"])
        {
            self.leftItem.title = @"全不选";
            for(MessageListModel *model in self.dataArray)
            {
                model.isSelectButton = YES;
            }
            self.checkAll = YES;
            [self.tableView reloadData];
            [self.editArray removeAllObjects];
            [self.editArray addObjectsFromArray:self.dataArray];
            if(self.editArray.count == 0)
            {
               self.bottomEditView.deleteTitle = @"删除";
            }else
            {
                self.bottomEditView.deleteTitle = [NSString stringWithFormat:@"删除(%zd)",self.editArray.count];
            }
            return;
        }
        if([self.leftItem.title isEqualToString:@"全不选"])
        {
            self.leftItem.title = @"全选";
            for(MessageListModel *model in self.dataArray)
            {
                model.isSelectButton = NO;
            }
            self.checkAll = NO;
            [self.tableView reloadData];
            [self.editArray removeAllObjects];
            self.bottomEditView.deleteTitle = @"删除";
            return;
        }

    }
}
-(void)doEditAction
{
    self.isEditing = !self.isEditing;
    self.rightItem.title = ((self.isEditing== NO)?@"编辑": @"完成");
    self.leftItem.title = ((self.isEditing== NO)?@"": @"全选");
    self.bottomEditView.hidden = !self.isEditing;
    if([self.rightItem.title isEqualToString:@"完成"])
    {
        [self.editArray removeAllObjects];
        self.bottomEditView.deleteTitle = @"删除";
        self.tableView.mj_header.hidden = YES;
        self.tableView.mj_footer.hidden = YES;
        self.title = @"批量操作";
    }
    if([self.rightItem.title isEqualToString:@"编辑"])
    {
        for(MessageListModel *model in self.dataArray)
        {
            model.isSelectButton = NO;
        }
        self.checkAll = NO;
        self.tableView.mj_header.hidden = NO;
        if(currentPage == pageCount)
        {
            self.tableView.mj_footer.hidden = YES;
        }
        else
        {
            self.tableView.mj_footer.hidden = NO;
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataAction)];
        }
        self.title = @"消息";
        [self.editArray removeAllObjects];
    }
    [self.tableView reloadData];
}
- (void)pullToRefreshTableAction
{
    [self loadMoreDataWithPage:1];
    //[self setTabBarCount];
}
- (void)loadMoreDataAction
{
    if(currentPage >= pageCount)
    {
        return;
    }
    currentPage ++;
    [self loadMoreDataWithPage:currentPage];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.editArray removeAllObjects];
        [self.editArray addObject:[self.dataArray objectAtIndex:indexPath.row]];
        [self messageUiUpdateWithStatus:MessageStatusDelete andIndex:self.editArray];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MsgListCell *cell = (MsgListCell *)[self.heightArray objectAtIndex:indexPath.row];
    cell.listModel = [self.dataArray objectAtIndex:indexPath.row];
    return cell.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Identifier";
    MsgListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[MsgListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.isSelect = self.checkAll;
    cell.isShowButton = self.isEditing;
    cell.listModel = [self.dataArray objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return !self.isEditing;
}
- (UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - cellDelegate
- (void)cellDidSelect:(MsgListCell *)cell
{
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    MessageListModel *model = [self.dataArray objectAtIndex:path.row];
    model.isSelectButton = YES;
    if(![self.editArray containsObject:model])
    {
        [self.editArray addObject:model];
    }
    self.bottomEditView.deleteTitle = [NSString stringWithFormat:@"删除(%lu)",(unsigned long)self.editArray.count];
}
- (void)cellDidDeselect:(MsgListCell *)cell
{
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    MessageListModel *model = [self.dataArray objectAtIndex:path.row];
    model.isSelectButton = NO;
    if([self.editArray containsObject:model])
    {
        [self.editArray removeObject:model];
    }
    if(self.editArray.count == 0)
    {
        self.bottomEditView.deleteTitle = [NSString stringWithFormat:@"删除"];
    }
    if(self.editArray.count >0)
    {
        self.bottomEditView.deleteTitle = [NSString stringWithFormat:@"删除(%lu)",(unsigned long)self.editArray.count];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showEditView
{
    CGRect frame = self.view.frame;
    CGRect tabFrame = self.tabBarController.tabBar.frame;
    self.bottomEditView = [[MsgEditView alloc]initWithFrame:CGRectMake(0, frame.size.height-tabFrame.size.height-CGRectGetHeight(self.navigationController.navigationBar.frame)- CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), self.view.bounds.size.width, tabFrame.size.height)];
    self.bottomEditView.deleteTitle = @"删除";
    self.bottomEditView.delegate = self;
    [self.view addSubview:self.bottomEditView];
}
- (void)msgEditViewButtonDidClick:(EditViewClickType)type
{
    if(type == EditViewClickDelete)
    {
        [self messageUiUpdateWithStatus:MessageStatusDelete andIndex:self.editArray];
    }
    if(type == EditViewClickRead)
    {
        [self messageUiUpdateWithStatus:MessageStatusRead andIndex:self.editArray];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if(self.isEditing == YES)
    {
        MsgListCell *cell = (MsgListCell *)[tableView cellForRowAtIndexPath:indexPath];
        MessageListModel *model = [self.dataArray objectAtIndex:indexPath.row];
        if(model.isSelectButton == YES)
        {
            cell.selectButton.selected = NO;
            [self cellDidDeselect:cell];
            return;
        }
        if(model.isSelectButton == NO)
        {
            cell.selectButton.selected = YES;
            [self cellDidSelect:cell];
            return;
        }
        return;
    }
    MessageListModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if(model.messageType == 1)
    {
        SBHManageModel *manageModel = [[SBHManageModel alloc]init];
        manageModel.orderno = model.orderNO;
        BeFlightOrderDetailController * orderDetailVC = [[BeFlightOrderDetailController alloc] init];
        orderDetailVC.mangaeModel = manageModel;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }
    if(model.messageType == 2)
    {
        BeHotelOrderDetailController *hotelOrder = [[BeHotelOrderDetailController alloc]init];
        BeHotelOrderModel *orderModel = [[BeHotelOrderModel alloc] init];
        orderModel.HotelId = model.itemId;
        orderModel.OrderNo = model.orderNO;
        hotelOrder.hotModel = orderModel;
        [self.navigationController pushViewController:hotelOrder animated:YES];
    }
    if (model.messageType == 3) {
        BeWebViewController *webVC = [[BeWebViewController alloc] init];
        NSString *str = [NSString stringWithFormat:@"http://jcfw.shenbianhui.cn/ordermanagement/RedirectTarget?orderNo=%@",model.orderNO];
        webVC.webViewUrl = str;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    if(model.messageType == 4)
    {
        BeAirDynamicViewController *airVC = [[BeAirDynamicViewController alloc]init];
        airVC.type = CareFlightType;
        [self.navigationController pushViewController:airVC animated:YES];
    }
    
    if(model.messageType == 5)
    {
        BeTrainOrderDetailController *trainVC = [[BeTrainOrderDetailController alloc]init];
        trainVC.orderno = model.orderNO;
        [self.navigationController pushViewController:trainVC animated:YES];
    }
    
    if(model.messageType == 6)
    {
        BeCarOrderDetailViewController *detailVC = [[BeCarOrderDetailViewController alloc]init];
        detailVC.orderNo = model.orderNO;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    /*if(model.isShowed == NO)
    {
        [self.editArray removeAllObjects];
        [self.editArray addObject:model];
        [self messageUiUpdateWithStatus:MessageStatusRead andIndex:self.editArray];
    }*/
    NSMutableDictionary *returnDict = [[NSMutableDictionary alloc]init];
    [returnDict setValue:model.userID forKey:@"msgid"];
    [returnDict setValue:@"U" forKey:@"msgst"];
    [[ServerFactory getServerInstance:@"MessageServer"]doDeleteMessageWithDict:returnDict byCallBack:^(NSDictionary *callback)
     {
     
     }failureCallback:^(NSError *failure)
     {
     
     }];
}

- (void)loadMoreDataWithPage:(int)page
{
    [[ServerFactory getServerInstance:@"MessageServer"] doInquireMessageWithDict:page byCallBack:^(NSDictionary *callback){
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if([[callback objectForKey:@"state"]isEqualToString:@"true"]||[[callback objectForKey:@"status"]isEqualToString:@"true"])
        {
            if(page == 1)
            {
                currentPage = 1;
                [self.editArray removeAllObjects];
                [self.dataArray removeAllObjects];
                [self.heightArray removeAllObjects];
            }
            pageCount = [[callback objectForKey:@"pagecount"] intValue];
            currentPage = [[callback objectForKey:@"currentpage"] intValue];
            [self.dataArray addObjectsFromArray:[callback objectForKey:@"msglist"]];
            [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                MsgListCell *cell = [[MsgListCell alloc]init];
                [self.heightArray addObject:cell];
            }];
            [self.tableView reloadData];
        }
        [self setRightButtonItemHidden];
        }failureCallback:^(NSError *failure)
     {
         if(failure.code == 20015||failure.code == 70001)
         {
             [MBProgressHUD showError:@"您暂时没有新消息"];
         }
         else
         {
             [CommonMethod handleErrorWith:failure];
         }
         [self.tableView.mj_footer endRefreshing];
         [self.tableView.mj_header endRefreshing];
         [self setRightButtonItemHidden];
     }];
}
- (void)messageUiUpdateWithStatus:(MessageStatusUpdate)status andIndex:(NSMutableArray *)indexArray
{
    NSMutableDictionary *returnDict = [[NSMutableDictionary alloc]init];
    NSMutableString *idString = [[NSMutableString alloc]init];
    for(MessageListModel *model in self.editArray)
    {
        [idString appendFormat:@"%@,",model.userID];
        if([self.editArray indexOfObject:model]==self.editArray.count-1)
        {
            [idString deleteCharactersInRange:(NSMakeRange([idString length]-1, 1))];
        }
    }
    [returnDict setValue:idString forKey:@"msgid"];
    if (status == MessageStatusDelete)
    {
        [returnDict setValue:@"D" forKey:@"msgst"];
    }
    if(status == MessageStatusRead)
        
    {
        [returnDict setValue:@"U" forKey:@"msgst"];
    }
    [MBProgressHUD showMessage:@"正在更新数据..."];
    [[ServerFactory getServerInstance:@"MessageServer"]doDeleteMessageWithDict:returnDict byCallBack:^(NSDictionary *callback)
     {
         [MBProgressHUD hideHUD];
         if([[callback objectForKey:@"status"]isEqualToString:@"true"])
         {
             if(status == MessageStatusRead)
             {
                for(MessageListModel *model in self.editArray)
                     {
                         if(model.isShowed == YES)
                         {
                         
                         }
                         else
                         {
                             if([self.dataArray containsObject:model])
                             {
                                 //MessageListModel *modelHeight = [self.heightArray objectAtIndex:[self.dataArray indexOfObject:model]];
                                 model.isShowed = YES;
                                 //modelHeight.isShowed = YES;
                             }
                         }
                         [self.tableView reloadData];
                         self.bottomEditView.deleteTitle = @"删除";
                 }
             }
             if(status == MessageStatusDelete)
             {
                 for(MessageListModel *model in self.editArray)
                 {
                     if([self.dataArray containsObject:model])
                     {
                         [self.heightArray removeObjectAtIndex:[self.dataArray indexOfObject:model]];
                         [self.dataArray removeObject:model];

                     }
                }
                [self.tableView reloadData];
                [self.editArray removeAllObjects];
                self.bottomEditView.deleteTitle = @"删除";
                 

             }
        }
         else
         {
             NSString *code = [callback objectForKey:@"code"];
             if([code isEqualToString:@"20015"]||[code isEqualToString:@"70001"]) {
                 [MBProgressHUD showError:@"数据更新失败"];
             } else {
                 [self handleResuetCode:code];
             }
         }
         if(self.isEditing == YES)
            {
                [self doEditAction];
            }
         
         //[self setTabBarCount];
         [self setRightButtonItemHidden];
     }failureCallback:^(NSError *failure)
     {
         [MBProgressHUD hideHUD];
         [CommonMethod handleErrorWith:failure];
     }];
    
}
- (void)msgTabbarChangeUI:(NSNotification *)noti
{
    //[self setTabBarCount];
}
- (void)setTabBarCount
{
    [[ServerFactory getServerInstance:@"MessageServer"]doGetUnreadMessageCountByCallback:^(NSDictionary *callback)
     {
         if([[callback objectForKey:@"totalcount"] intValue]>0)
         {
             [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%@",[callback objectForKey:@"totalcount"]]];
         }
         else
         {
             [self.tabBarItem setBadgeValue:nil];
         }
         
     }failureCallback:^(NSError *failure)
     {
         
     }];
}
- (void)setRightButtonItemHidden
{
    if(self.dataArray.count == 0)
    {
        if(self.isEditing == NO)
        {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
    else
    {
        self.navigationItem.rightBarButtonItem = self.rightItem;
    }
}

@end
