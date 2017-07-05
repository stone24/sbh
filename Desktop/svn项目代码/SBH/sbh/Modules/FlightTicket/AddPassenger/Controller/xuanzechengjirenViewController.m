//
//  xuanzechengjirenViewController.m
//  SBHAPP
//
//  Created by musmile on 14-7-6.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "xuanzechengjirenViewController.h"
#import "xuanzechengjirenTableViewCell.h"
#import "BePassengerViewController.h"
#import "MJRefresh.h"
#import "SBHUserModel.h"
#import "SBHHttp.h"
#import "BePassengerTool.h"
#import "ServerFactory.h"

@interface xuanzechengjirenViewController () <UITextFieldDelegate>
{
    NSMutableArray * contactArray;
}
@property (weak, nonatomic) IBOutlet UITableView *itableview;
@property (weak, nonatomic) IBOutlet UITextField *sousuoTextField;
- (IBAction)sousuoBtnClick;
- (IBAction)addChengjirenBtnClick;
@property (weak, nonatomic) IBOutlet UIButton *addPassenger;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)segmentControlAction:(UISegmentedControl *)sender;
- (IBAction)textFieldChange:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIView *choosePerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seachViewLayoutRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *staffViewLayoutTop;
@property (nonatomic, assign) int pageindex;
@property (nonatomic, strong) NSString *pagecount; // 总页数
@property (nonatomic, strong) NSString *zcount; // 总条数
@property (nonatomic, strong) NSString *sousuonr;

@end

@implementation xuanzechengjirenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtn)];
        self.sousuonr = @"";
        self.isSpecialCompany = NO;
        self.selectArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.itableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.001)];
    [self.addPassenger setTitleColor:[ColorConfigure globalBgColor] forState:UIControlStateNormal];
    self.segmentControl.tintColor = [ColorConfigure globalBgColor];
    [self.segmentControl setTitle:@"最近出行人" forSegmentAtIndex:0];
    [self.segmentControl setTitle:@"企业员工" forSegmentAtIndex:1];
    contactArray = [[NSMutableArray alloc]init];
    if(self.enType == BeChoosePersonTypeHotel)
    {
        [self.addPassenger setTitle:@"新增入住人" forState:UIControlStateNormal];
    }
    if (self.enType == BeChoosePersonTypeCar) {
        self.staffViewLayoutTop.constant = -65;
        self.itableview.backgroundColor = SBHColor(240, 240, 240);
        self.choosePerView.backgroundColor = SBHColor(240, 240, 240);
        if ([self.title isEqualToString:@"选择入住人"]) {
            [self.segmentControl setTitle:@"最近入住人" forSegmentAtIndex:0];
        }
    }
    if ([GlobalData getSharedInstance].userModel.isEnterpriseUser == NO) {
        self.itableview.transform = CGAffineTransformMakeTranslation(0, -52);
        self.itableview.height = self.itableview.height + 52;
        self.itableview.backgroundColor = SBHColor(240, 240, 240);
    }
    self.pageindex = 1;
    self.pagecount = @"0";
    self.zcount = @"0";
    self.segmentControl.selectedSegmentIndex = 0;
    [self segmentControlAction:self.segmentControl];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xzlxr_sousuoIcon"]];
    imageView.contentMode = UIViewContentModeRight;
    imageView.width = 25;
    self.sousuoTextField.leftView = imageView;
    self.sousuoTextField.leftViewMode = UITextFieldViewModeAlways;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"xuanzechengjirenViewController"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"xuanzechengjirenViewController"];
}

//刷新
- (void)addFooter
{
    self.itableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestNextPage)];
}

- (void)addHeader
{
    self.itableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
}

-(void)requestNextPage
{
    self.pageindex ++;
    if ([self.pagecount intValue] < self.pageindex) {
        [MBProgressHUD showError:@"数据已全部加载"];
        [self.itableview.mj_footer endRefreshing];
        [self.itableview.mj_header endRefreshing];
    } else
    {
        [self getEmployeeList];
    }
}

-(void)refreshData
{
    self.pageindex = 1;
    [self getEmployeeList];
}

#pragma mark - 获取员工列表
- (void)getEmployeeList
{
    self.sousuoTextField.text = @"";
    NSDictionary *parameter = @{@"usertoken":[GlobalData getSharedInstance].token,@"pagesize":@"20",@"zcount":self.zcount,@"pagecount":self.pagecount,@"username":self.sousuonr,@"pageindex":[NSString stringWithFormat:@"%d",self.pageindex]};
    [[ServerFactory getServerInstance:@"BePassengerTool"]getEmployeeListWith:parameter bySuccess:^(NSString *currentPage,NSString *pageCount,NSString *totalCount,NSArray *listArray)
    {
        [self.itableview.mj_footer endRefreshing];
        [self.itableview.mj_header endRefreshing];
        self.zcount = totalCount;
        self.pagecount = pageCount;
        if([currentPage intValue]==1)
        {
            [contactArray removeAllObjects];
        }
        [contactArray addObjectsFromArray:listArray];
        for (int i = 0; i<self.selectArray.count; i++)
        {
            NSUInteger index = 0;
            BOOL isSame = NO;
            selectPerson *selPerson = [self.selectArray objectAtIndex:i];
            for(selectPerson *member in contactArray)
            {
                if ([member.iName isEqualToString:selPerson.iName] && [member.iCredNumber isEqualToString:selPerson.iCredNumber]&& [member.iMobile isEqualToString:selPerson.iMobile] && [member.rolename isEqualToString:selPerson.rolename])
                {
                    isSame = YES;
                    index = [contactArray indexOfObject:member];
                    break;
                }
            }
            if(isSame)
            {
                selectPerson *sameModel = [contactArray objectAtIndex:index];
                sameModel.isSelectItem = YES;
            }
        }
        [self.itableview reloadData];
    }failure:^(NSError *error)
    {
       // [self requestFlase:error];
    }];
}
#pragma mark - 获取最近出行人列表
- (void)getRecentPassengerList
{
    NSString *depStr = nil;
    if ([[GlobalData getSharedInstance].userModel.levelcode isEqualToString:@"1"])
    {
        depStr = @"-1";
    }
    else
    {
        depStr = [GlobalData getSharedInstance].userModel.roleid;
    }
    if(self.enType == BeChoosePersonTypeHotel /*getRecentHotelListWith*/)
    {
        [[ServerFactory getServerInstance:@"BePassengerTool"]getRecentHotelListWith:self.sousuonr andDepartId:depStr bySuccess:^(NSMutableArray *listArray)
         {
             [contactArray removeAllObjects];
             [contactArray addObjectsFromArray:listArray];
             for (int i = 0; i<self.selectArray.count; i++)
             {
                 NSUInteger index = 0;
                 BOOL isSame = NO;
                 selectPerson *selPerson = [self.selectArray objectAtIndex:i];
                 for(selectPerson *member in contactArray)
                 {
                     if ([member.iName isEqualToString:selPerson.iName] && [member.iCredNumber isEqualToString:selPerson.iCredNumber]&& [member.iMobile isEqualToString:selPerson.iMobile]&& [member.rolename isEqualToString:selPerson.rolename] )
                     {
                         isSame = YES;
                         index = [contactArray indexOfObject:member];
                         break;
                     }
                 }
                 if(isSame)
                 {
                     selectPerson *sameModel = [contactArray objectAtIndex:index];
                     sameModel.isSelectItem = YES;
                 }
             }
             [self.itableview reloadData];
         }failure:^(NSError *error)
         {
             // [self requestFlase:error];
         }];
    }
    else
    {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"Order/FlightContact"];
        [[ServerFactory getServerInstance:@"SBHHttp"]postPath:urlStr withParameters:@{@"name":self.sousuonr,@"departmentid":depStr} showHud:NO success:^(NSDictionary *successDict)
        {
            NSMutableArray *callbackArray = [NSMutableArray array];
            for(NSDictionary *member in [successDict arrayValueForKey:@"flightcontact"])
            {
                selectPerson * aSelPerson = [[selectPerson alloc] initWithDict:member andFromType:@"2"];
                [callbackArray addObject:aSelPerson];
            }
            [contactArray removeAllObjects];
            [contactArray addObjectsFromArray:callbackArray];
            for (int i = 0; i<self.selectArray.count; i++)
            {
                NSUInteger index = 0;
                BOOL isSame = NO;
                selectPerson *selPerson = [self.selectArray objectAtIndex:i];
                for(selectPerson *member in contactArray)
                {
                    if ([member.iName isEqualToString:selPerson.iName] && [member.iCredNumber isEqualToString:selPerson.iCredNumber]&& [member.iMobile isEqualToString:selPerson.iMobile]&& [member.rolename isEqualToString:selPerson.rolename] )
                    {
                        isSame = YES;
                        index = [contactArray indexOfObject:member];
                        break;
                    }
                }
                if(isSame)
                {
                    selectPerson *sameModel = [contactArray objectAtIndex:index];
                    sameModel.isSelectItem = YES;
                }
            }
            [self.itableview reloadData];
        }failure:^(NSError *error)
        {
        }];
    }
}
#pragma mark - 确定
- (void)rightBtn
{
    NSMutableArray *blockArray = [NSMutableArray array];
    NSMutableArray *selectA = [self.selectArray mutableCopy];
    NSMutableIndexSet *indexSets = [[NSMutableIndexSet alloc]init];
    for (int i = 0; i<selectA.count; i++)
    {
        selectPerson *selPerson = [selectA objectAtIndex:i];
        if ([selPerson.iName isEqualToString:@""] && [selPerson.iCredNumber isEqualToString:@""]&& [selPerson.iMobile isEqualToString:@""])
        {
            [indexSets addIndex:i];
        }
        else
        {
            for(selectPerson *member in contactArray)
            {
                if (member.isSelectItem && [member.iName isEqualToString:selPerson.iName] && [member.iCredNumber isEqualToString:selPerson.iCredNumber]&& [member.iMobile isEqualToString:selPerson.iMobile] && [member.rolename isEqualToString:selPerson.rolename])
                {
                    [indexSets addIndex:i];
                    break;
                }
            }
        }
    }
    [selectA removeObjectsAtIndexes:indexSets];
    [blockArray addObjectsFromArray:selectA];
    for (selectPerson *selPerson in contactArray)
    {
        if (selPerson.isSelectItem)
        {
            [blockArray addObject:selPerson];
        }
    }
    if(blockArray.count > self.maxCount)
    {
        if(self.enType == BeChoosePersonTypeHotel)
        {
            {
                [MBProgressHUD showError:[NSString stringWithFormat:@"请最多选择选择%d人",self.maxCount]];
            }
        }
        if(self.enType == BeChoosePersonTypeTrain)
        {
            {
                [MBProgressHUD showError:[NSString stringWithFormat:@"选择出行人数不能超过%d人",self.maxCount]];
            }
        }
        if(self.enType == BeChoosePersonTypeAirFlight)
        {
            if(self.maxCount < 9)
            {
                [MBProgressHUD showError:[NSString stringWithFormat:@"选择出行人数超过剩余票数%d张",self.maxCount]];
            }
            else
            {
                [MBProgressHUD showError:[NSString stringWithFormat:@"选择出行人数不能超过%d人",self.maxCount]];
            }
        }
        return;
    }
    if(self.block)
    {
        self.block (blockArray);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [contactArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    xuanzechengjirenTableViewCell *cell = nil;
    static NSString *cell1 = @"cell1";
    cell = [tableView dequeueReusableCellWithIdentifier:cell1];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"xuanzechengjirenTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    selectPerson * selPerson = [[selectPerson alloc] init];
    selPerson = [contactArray objectAtIndex:indexPath.row];
    cell.iSelectButton.hidden = YES;
    cell.iUserName.text = selPerson.iName;
    cell.iUserSex.text = [NSString stringWithFormat:@"(%@)", selPerson.iGender];
    cell.iUserJob.text = selPerson.rolename;
    cell.iPhoneNum.text = selPerson.iMobile;
    cell.iUserCode.text = @"";
    cell.iemail.text = [NSString stringWithFormat:@"%@ %@",selPerson.iCredtype,selPerson.iCredNumber];
    if (selPerson.isSelectItem)
    {
        [cell.cute1 setImage:[UIImage imageNamed:@"cell_check_box"]];
    }
    else
    {
        [cell.cute1 setImage:[UIImage imageNamed:@"cell_unselect"]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectPerson *selModel = [contactArray objectAtIndex:indexPath.row];
    selModel.isSelectItem = !selModel.isSelectItem;
    xuanzechengjirenTableViewCell *cell = (xuanzechengjirenTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (selModel.isSelectItem)
    {
        [cell.cute1 setImage:[UIImage imageNamed:@"cell_check_box"]];
    }
    else
    {
        [cell.cute1 setImage:[UIImage imageNamed:@"cell_unselect"]];
    }
}

- (IBAction)sousuoBtnClick
{
    [UIView animateWithDuration:0.25 animations:^{
        self.seachViewLayoutRight.constant = 10;
        [self.view layoutIfNeeded];
        self.cancelBtn.hidden = YES;
    }];
    [self.view endEditing:YES];
}

- (IBAction)addChengjirenBtnClick {
    selectPerson *selPer = [[selectPerson alloc] init];
    selPer.iInsquantity = [NSString stringWithFormat:@"%d", [GlobalData getSharedInstance].insquantity];
    BePassengerViewController *addVc = [[BePassengerViewController alloc] init:selPer];
    addVc.sourceType = (NSInteger)self.enType;
    if ([self.title isEqualToString:@"选择乘车人"])
    {
        addVc.title = kaddPassengerTypeTrain;
    }
    else if(self.enType == BeChoosePersonTypeHotel)
    {
        addVc.title = @"新增入住人";
    }
    else
    {
        addVc.title = @"新增乘机人";
    }
    [self.navigationController pushViewController:addVc animated:YES];
}

- (IBAction)textFieldChange:(UITextField *)sender {
    self.sousuonr = sender.text;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 animations:^{
        self.seachViewLayoutRight.constant = 50;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.cancelBtn.hidden = NO;
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.sousuonr = textField.text;
    [self sousuoChengjiren];
    [UIView animateWithDuration:0.25 animations:^{
        self.seachViewLayoutRight.constant = 10;
        [self.view layoutIfNeeded];
        self.cancelBtn.hidden = YES;
    }];
    [self.view endEditing:YES];
    return YES;
}

- (void)sousuoChengjiren
{
    self.pagecount = @"0";
    self.pageindex = 1;
    self.zcount = @"0";
    [self.view endEditing:YES];
    if (self.segmentControl.selectedSegmentIndex == 0) {
        [self getRecentPassengerList];
    } else {
        [self getEmployeeList];
    }
}
- (IBAction)segmentControlAction:(UISegmentedControl *)sender {
    [self.view endEditing:YES];
    [contactArray removeAllObjects];
    [self.itableview reloadData];
    self.zcount = @"0";
    self.pagecount = @"0";
    self.sousuonr = @"";
    if (sender.selectedSegmentIndex == 0)
    {
        [self getRecentPassengerList];
        self.itableview.mj_header.hidden = YES;
        self.itableview.mj_footer.hidden = YES;
    }
    else
    {
        [self addHeader];
        [self addFooter];
        [self getEmployeeList];
        self.itableview.mj_header.hidden = NO;
        self.itableview.mj_footer.hidden = NO;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
