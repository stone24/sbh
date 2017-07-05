                          //
//  BeChoosePassengerController.m
//  sbh
//
//  Created by SBH on 15/7/22.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeChoosePassengerController.h"
#import "xuanzechengjirenTableViewCell.h"
#import "MJRefresh.h"
#import "SBHUserModel.h"
#import "SBHHttp.h"

@interface BeChoosePassengerController ()<UITextFieldDelegate>
{
    NSString *jugg;
    //是否第一次进入
    BOOL FIRST;
    NSMutableArray *name;
    NSMutableArray *arr;
    NSMutableArray *arr1;
    NSMutableArray *passager;
    NSMutableArray *cylxModel;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopLayout;
@property (weak, nonatomic) IBOutlet UITextField *sousuoTextField;
- (IBAction)sousuoBtnClick;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)segmentControlAction:(UISegmentedControl *)sender;

- (IBAction)textFieldChange:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

// 当前页数
@property (nonatomic, assign) int pageindex;
@property (nonatomic, strong) NSString *pagecount; // 总页数
@property (nonatomic, strong) NSString *zcount; // 总条数
@property (nonatomic, strong) NSString *sousuonr;
@end

@implementation BeChoosePassengerController

-(NSMutableArray *)selchengjr
{
    if (!_selchengjr) {
        _selchengjr = [NSMutableArray array];
    }
    return _selchengjr;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"chengjiren_tb_1.png"] forState:UIControlStateNormal];
        //        btn.width = 20;
        //        btn.height = 20;
        [btn addTarget:self action:@selector(rightBtn) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        //        self.navigationItem.rightBarButtonItem.width = 20;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtn)];
        [cylxModel removeAllObjects];
        self.sousuonr = @"";
        
    }
    return self;
}
- (id)init:(NSString *)str object:(selectPerson *)selPerson{
    self = [super init];
    if (self) {
        jugg = str;
        iselPerson = selPerson;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化控件
    self.segmentControl.tintColor = [ColorConfigure globalBgColor];
    [self.segmentControl setTitle:@"最近出行人" forSegmentAtIndex:0];
    [self.segmentControl setTitle:@"企业员工" forSegmentAtIndex:1];
    
    name = [[NSMutableArray alloc]init];
    arr = [[NSMutableArray alloc]init];
    arr1 = [[NSMutableArray alloc]init];
    passager = [[NSMutableArray alloc]init];
    contactArray = [[NSMutableArray alloc]init];
    cylxModel = [[NSMutableArray alloc] init];
    FIRST = YES;
    
    // 企业个人用户处理
    if ([[GlobalData getSharedInstance].userModel.levelcode isEqualToString:@"3"]) {
        self.tableViewTopLayout.constant = -52;
        self.itableview.backgroundColor = SBHColor(240, 240, 240);
        self.sousuoTextField.placeholder = @"请输入姓名查找";
    }
    [self addHeader];
    [self addFooter];
    self.pagecount = @"0";
    self.zcount = @"0";
    [self refreshData];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xzlxr_sousuoIcon"]];
    imageView.contentMode = UIViewContentModeRight;
    imageView.width = 25;
    self.sousuoTextField.leftView = imageView;
    self.sousuoTextField.leftViewMode = UITextFieldViewModeAlways;
    
    //    [self.itableview reloadData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"BeChoosePassengerController"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"BeChoosePassengerController"];
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

//下一页
-(void)requestNextPage
{
    self.pageindex ++;
    if ([self.pagecount intValue] < self.pageindex) {
        [MBProgressHUD showError:@"数据已全部加载"];
        [self.itableview.mj_footer endRefreshing];
        [self.itableview.mj_header endRefreshing];
    } else {
        if (self.segmentControl.selectedSegmentIndex == 0) {
            [self requestresist1];
        } else {
            [self requestregist];
        }
        
    }
}

//刷新数据
-(void)refreshData
{
    
    self.pageindex = 1;
    [contactArray removeAllObjects];
    [cylxModel removeAllObjects];
    //        [no removeAllObjects];
    //        [self.itableview reloadData];
    if (self.segmentControl.selectedSegmentIndex == 0) {
        [self requestresist1];
    } else {
        [self requestregist];
    }
    
}

#pragma mark======员工
- (void)requestregist{
   
    FIRST = YES;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"Enterprise/GetEmployee"];
    self.sousuoTextField.text = @"";
    NSString *str00 = self.sousuonr;
    [[SBHHttp sharedInstance] postPath:urlStr withParameters:@{@"pagesize":@"20",@"zcount":self.zcount,@"pagecount":self.pagecount,@"pageindex":[NSString stringWithFormat:@"%d",self.pageindex],@"username":str00} showHud:YES success:^(id dic)
     {
         self.zcount = [dic objectForKey:@"totalcount"];
         self.pagecount = [dic objectForKey:@"pagecount"];
         
             NSArray *array = [dic objectForKey:@"list"];
             
             if (self.pageindex == 1) {
                 [contactArray removeAllObjects];
             }
             for (int i =0; i<[array count]; i++)
             {
                 selectPerson * aSelPerson = [[selectPerson alloc] init];
                 NSDictionary * aSelDic    = [array objectAtIndex:i];
                 id idObject = [aSelDic objectForKey:@"id"];
                 if([idObject isKindOfClass:[NSString class]])
                 {
                     aSelPerson.iId = idObject;
                 }
                 else if([idObject isKindOfClass:[NSNumber class]])
                 {
                     NSString * idStri = [NSString stringWithFormat:@"%d",[(NSNumber*)idObject intValue]];
                     aSelPerson.iId = idStri;
                 }
                 aSelPerson.iType        = [aSelDic stringValueForKey:@"typecode"];
                 aSelPerson.iGender      = [aSelDic stringValueForKey:@"gender"];
                 
                 aSelPerson.iName        = [aSelDic stringValueForKey:@"name"];
                 aSelPerson.iCredtype    = [aSelDic stringValueForKey:@"cardtype"];
                 if ([aSelPerson.iCredtype intValue]<0) {
                     aSelPerson.iCredtype = @"1";
                 }
                 if ([aSelPerson.iCredtype isEqualToString:@"1"]) {
                     aSelPerson.iCredtype = @"身份证";
                 }
                 else  if ([aSelPerson.iCredtype isEqualToString:@"2"]) {
                     aSelPerson.iCredtype = @"护照";
                 }
                 else  if ([aSelPerson.iCredtype isEqualToString:@"3"]) {
                     aSelPerson.iCredtype = @"回乡证";
                 }
                 else if ([aSelPerson.iCredtype isEqualToString:@"4"]) {
                     aSelPerson.iCredtype = @"同胞证";
                 }
                 else if ([aSelPerson.iCredtype isEqualToString:@"5"]) {
                     aSelPerson.iCredtype = @"军人证";
                 }
                 else if ([aSelPerson.iCredtype isEqualToString:@"6"]) {
                     aSelPerson.iCredtype = @"警官证";
                 }
                 else if ([aSelPerson.iCredtype isEqualToString:@"7"]) {
                     aSelPerson.iCredtype = @"港澳通行证";
                 }
                 else if ([aSelPerson.iCredtype isEqualToString:@"8"]) {
                     aSelPerson.iCredtype = @"其他证件";
                 }
                 aSelPerson.iCredNumber  = [aSelDic stringValueForKey:@"cardno"];
                 aSelPerson.iMobile      = [aSelDic stringValueForKey:@"mobilephone"];
                 aSelPerson.rolename = [aSelDic stringValueForKey:@"rolename"];
                 aSelPerson.iInsquantity =  aSelPerson.iInsquantity = [NSString stringWithFormat:@"%d",[GlobalData getSharedInstance].insquantity];
                 aSelPerson.iInsprice    = @"";
                 aSelPerson.iOftencred   = @"";
                 aSelPerson.iBirthday    = [aSelDic objectForKey:@"birthday"];
                 
                 aSelPerson.iFromType    = @"1";
                 [cylxModel addObject:aSelPerson];
                 
                 [contactArray addObject:aSelPerson];
             }
         
         [self.itableview reloadData];
         [self.itableview.mj_footer endRefreshing];
         [self.itableview.mj_header endRefreshing];
     } failure:^(NSError *error)
     {
         [self.itableview.mj_footer endRefreshing];
         [self.itableview.mj_header endRefreshing];
         self.sousuonr = @"";
         NSDictionary *dic = [error userInfo];
         NSString * code = [dic stringValueForKey:@"code"];
         if([code isEqualToString:@"20015"]||[code isEqualToString:@"70001"]) {
             
         } else {
             [self handleResuetCode:code];
         }
     }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1991) {
        if (buttonIndex==0) {
            [self back];
        }
    }
    else if (alertView.tag==3001)
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
        [BeLogUtility doLogOn];
    }
}

//CarPassenger 用车常用联系人
//usertoken
//pagecount
//zcount
//pagesize
//pageindex
//username
//platform
//联系人
- (void)requestresist1
{
    FIRST = NO;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"ZuChe/CarPassenger"];
    NSString *str00 = self.sousuonr;
    NSString *depStr = nil;
    if ([[GlobalData getSharedInstance].userModel.levelcode isEqualToString:@"1"]) {
        depStr = @"-1";
    } else {
        depStr = [GlobalData getSharedInstance].userModel.roleid;
    }
    NSDictionary *params = @{@"pagesize":@"20",@"zcount":self.zcount,@"pagecount":self.pagecount,@"pageindex":[NSString stringWithFormat:@"%d",self.pageindex],@"username":str00};
    [[SBHHttp sharedInstance] postPath:urlStr withParameters:params showHud:YES success:^(id dic)
     {
         [self.itableview.mj_footer endRefreshing];
         [self.itableview.mj_header endRefreshing];
         NSArray *array = [dic objectForKey:@"cp"];
         for (int i =0; i<[array count]; i++)
         {
             selectPerson * aSelPerson = [[selectPerson alloc] init];
             NSDictionary * aSelDic    = [array objectAtIndex:i];
             id idObject = [aSelDic objectForKey:@"id"];
             if([idObject isKindOfClass:[NSString class]])
             {
                 aSelPerson.iId = idObject;
             }
             else if([idObject isKindOfClass:[NSNumber class]])
             {
                 NSString * idStri = [NSString stringWithFormat:@"%d",[(NSNumber*)idObject intValue]];
                 aSelPerson.iId  = idStri;
             }
             
             aSelPerson.iType  = @"ADT";
             aSelPerson.iGender  = @"男";
             aSelPerson.PassengerEntId =[aSelDic stringValueForKey:@"PassengerEntId"];
             aSelPerson.PassengerAccountId =[aSelDic stringValueForKey:@"PassengerAccountId"];
             aSelPerson.depid = [aSelDic stringValueForKey:@"PassengerDepId"];
             aSelPerson.iName        = [aSelDic stringValueForKey:@"name"];
             aSelPerson.iMobile      = [aSelDic stringValueForKey:@"mobilephone"];
             aSelPerson.rolename      = [aSelDic stringValueForKey:@"Depname"];
             [cylxModel addObject:aSelPerson];
             [contactArray addObject:aSelPerson];
         }
         [self.itableview reloadData];
     }
     failure:^(NSError *error)
     {
         [self.itableview.mj_footer endRefreshing];
         [self.itableview.mj_header endRefreshing];
         NSString * code = [error.userInfo stringValueForKey:@"code"];
         if([code isEqualToString:@"20015"]||[code isEqualToString:@"70001"]) {
             
         } else {
             [self handleResuetCode:code];
         }
     }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)rightBtn
{
    BOOL refu = NO;
    NSMutableArray *testArray = self.selchengjr;
    NSMutableArray *array00 = [NSMutableArray array];
    for (int i = 0; i<contactArray.count; i++) {
        selectPerson *selPerson = [contactArray objectAtIndex:i];
        if (selPerson.isSelectItem) {
            if (self.selchengjr.count == 0) {
                //                [self.selchengjr addObject:selPerson];
                [array00 addObject:selPerson];
            } else {
                for (int j=0;j<testArray.count;j++) {
                    selectPerson *selPP = (selectPerson *)[testArray objectAtIndex:j];
                    if ([selPerson.iName isEqualToString:selPP.iName]) {
                        refu = YES;
                    }
                }
                if (refu == NO) {
                    [array00 addObject:selPerson];
                }else {
                    refu = NO;
                }
            }
        }
    }
    if(self.block)
    {
        self.block(array00);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//tableview的委托函数
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
    if ([contactArray count]>0) {
        selectPerson * selPerson = [[selectPerson alloc] init];
       
        if (contactArray.count !=0) {
            selPerson = [contactArray objectAtIndex:indexPath.row];
        }
        
        if (self.segmentControl.selectedSegmentIndex == 0) {
            cell.iUserSex.hidden = YES;
            cell.iPhoneNum.hidden = YES;
            cell.iemail.text = selPerson.iMobile;
        } else {
             cell.iemail.text = [NSString stringWithFormat:@"%@ %@",selPerson.iCredtype,selPerson.iCredNumber];
        }
        //            cell.iUserName.text = [[contactArray objectAtIndex:indexPath.row]objectForKey:@"name"];
        cell.iUserName.text = selPerson.iName;
        cell.iUserSex.text = [NSString stringWithFormat:@"(%@)", selPerson.iGender];
        [name addObject:cell.iUserName.text];
        cell.iUserJob.text = selPerson.rolename;
        //            cell.iUserCode.text = [[contactArray objectAtIndex:indexPath.row]objectForKey:@"id"];
        //            cell.iPhoneNum.text = [[contactArray objectAtIndex:indexPath.row] objectForKey:@"mobilephone"];
        cell.iPhoneNum.text = selPerson.iMobile;
        cell.iUserCode.text = @"";
        if (selPerson.isSelectItem) {
            
            [cell.cute1 setImage:[UIImage imageNamed:@"xzlxr_xuanzhongIcon"]];
        }
        else{
            
            [cell.cute1 setImage:[UIImage imageNamed:@"xzlxr_weixuanzeIcon"]];
        }
        
        [cell.iSelectButton addTarget:self action:@selector(click1:) forControlEvents:UIControlEventTouchUpInside];
        cell.iSelectButton.tag = 2000+indexPath.row ;
    }
    //    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

//选择乘机人
- (void)click1:(UIButton *)btn{
//    btn.selected = !btn.selected;
    for (selectPerson *selModel in contactArray) {
        selModel.isSelectItem = NO;
    }
    selectPerson *selModel = [contactArray objectAtIndex:btn.tag-2000];
    selModel.isSelectItem = !selModel.isSelectItem;

    [self.itableview reloadData];

    
}

- (IBAction)sousuoBtnClick {
    
    [UIView animateWithDuration:0.25 animations:^{
//        self.seachViewLayoutRight.constant = 10;
        self.sousuoTextField.width = self.sousuoTextField.width + 45;
//        [self.view layoutIfNeeded];
        self.cancelBtn.hidden = YES;
    }];
    [self.view endEditing:YES];
}


- (IBAction)textFieldChange:(UITextField *)sender {
    self.sousuonr = sender.text;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 animations:^{
//        self.seachViewLayoutRight.constant = 50;
        textField.width = textField.width - 45;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.cancelBtn.hidden = NO;
    }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{    SBHLog(@"%@",textField.text);
    self.sousuonr = textField.text;
    [self sousuoChengjiren];
    [UIView animateWithDuration:0.25 animations:^{
//        self.seachViewLayoutRight.constant = 10;
        textField.width = textField.width + 45;
        [self.view layoutIfNeeded];
        self.cancelBtn.hidden = YES;
    }];
    [self.view endEditing:YES];
    return YES;
}

- (void)sousuoChengjiren
{
    [contactArray removeAllObjects];
    self.pagecount = @"0";
    self.pageindex = 1;
    self.zcount = @"0";
    [self.view endEditing:YES];
    if (self.segmentControl.selectedSegmentIndex == 0) {
        [self requestresist1];
    } else {
        [self requestregist];
    }
    
}
- (IBAction)segmentControlAction:(UISegmentedControl *)sender {
    [self.view endEditing:YES];
    if (sender.selectedSegmentIndex == 0) {
        [contactArray removeAllObjects];
        self.zcount = @"0";
        self.pagecount = @"0";
        [self refreshData];
    } else {
        [contactArray removeAllObjects];
        self.zcount = @"0";
        self.pagecount = @"0";
        self.sousuonr = @"";
        [self refreshData];
    }
    
}

@end
