//
//  BeMapSearchViewController.m
//  sbh
//
//  Created by RobinLiu on 15/7/14.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeMapSearchViewController.h"
#import <QMapKit/QMapKit.h>
#import "CommonDefine.h"
#import "BeMapSelectView.h"
#import "SBHHttp.h"
#import "BeMapServer.h"
#import "ServerFactory.h"
#import <QMapSearchKit/QMapSearchKit.h>
#import "BeMapCustomAddressCell.h"

@interface BeMapSearchViewController ()<QMapViewDelegate,QMSSearchDelegate,UISearchBarDelegate>
{
    QCoordinateRegion region;
    UISearchBar *searchBar;
    UIView *dimView;
    NSMutableArray *homeArray;
    NSMutableArray *companyArray;
}
@property (nonatomic, strong)QMSSearcher *mapSearcher;
@property (nonatomic, strong)QMapView *tencentMapView;
@property (nonatomic,strong)BeMapSelectView *selectView;
@end

@implementation BeMapSearchViewController

- (void)setLocationCity:(BeSpeCityModel *)locationCity
{
    _locationCity = [[BeSpeCityModel alloc]init];
    _locationCity.cityName = [locationCity.cityName mutableCopy];
    _locationCity.cityCode = [locationCity.cityCode mutableCopy];
    _locationCity.cityLat = [locationCity.cityLat mutableCopy];
    _locationCity.cityLng = [locationCity.cityLng mutableCopy];
    [self interceptionString];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted )
    {
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"请打开定位获得更精确的位置" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setNavView];
    [self setupMapView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateCustomAddress:) name:@"kCustomAddress" object:nil];
}
- (void)initData
{
    homeArray = [[NSMutableArray alloc]init];
    companyArray = [[NSMutableArray alloc]init];
    self.mapSearcher = [[QMSSearcher alloc] initWithDelegate:self];
    if(_sourceType == MapViewSourceTypeStart)
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    }
    else if(_sourceType == MapViewSourceTypeDestination)
    {
        NSString *cityName = [self.locationCity.cityCode length]>0?self.locationCity.cityCode:self.locationCity.cityName;
        [[ServerFactory getServerInstance:@"BeMapServer"]getSearchHistoryWithCityName:cityName SuccessCallback:^(NSMutableArray *searchArray,BeAddressModel *homeModel,BeAddressModel *companyModel)
         {
             [homeArray removeAllObjects];
             [homeArray addObject:homeModel];
             [companyArray removeAllObjects];
             [companyArray addObject:companyModel];
             
             [self.dataArray removeAllObjects];
             [self.dataArray addObjectsFromArray:searchArray];
             [self.tableView reloadData];
             [self tableviewUp];
         } andFailure:^(NSMutableArray *searchArray,BeAddressModel *homeModel,BeAddressModel *companyModel,NSError *error)
         {
             [homeArray removeAllObjects];
             [homeArray addObject:homeModel];
             [companyArray removeAllObjects];
             [companyArray addObject:companyModel];
             
             [self.dataArray removeAllObjects];
             [self.dataArray addObjectsFromArray:searchArray];
             [self.tableView reloadData];
             [self tableviewUp];
             if(error.code ==10006)
             {
                 //重新登录
                 [self requestFlase:error];
             }
         }];
    }
}

- (void)setNavView
{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    navView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navImage"]];
    navView.userInteractionEnabled = YES;
    [self.view addSubview:navView];
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(50, 29, kScreenWidth - 100,29)];
    searchBar.placeholder = @"请输入地点";
    searchBar.delegate = self;
    [searchBar setBackgroundImage:[UIImage imageNamed:@"navImage"]];
    [navView addSubview:searchBar];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 20, searchBar.x, 44);
    [leftButton setImage:[UIImage imageNamed:@"commonBackArrow"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftMenuClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:leftButton];
}
- (void)endEditing
{
    [self.view endEditing:YES];
}
- (void)leftMenuClick
{
    [super leftMenuClick];
}
- (void)setupMapView
{
    if(_sourceType == MapViewSourceTypeStart)
    {
        [self setMapVisible];
    }
    else
    {
        self.tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    }
}
- (void)setMapVisible
{
    self.tencentMapView = [[QMapView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenWidth * 0.7)];
    self.tencentMapView.showsScale = NO;
    self.tencentMapView.showsUserLocation = YES;
    self.tencentMapView.zoomLevel = 17.1;
    self.tencentMapView.userTrackingMode = QUserTrackingModeFollow;
    self.tencentMapView.delegate = self;
    [self.view addSubview:self.tencentMapView];
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.frame = CGRectMake(15, self.tencentMapView.height -55, 40, 40);
    [locationButton setBackgroundImage:[UIImage imageNamed:@"spe_wheel"] forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(startLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.tencentMapView addSubview:locationButton];
    
    self.selectView = [[BeMapSelectView alloc]initWithFrame:CGRectMake(0, 0, 19, 36)];
    self.selectView.backgroundColor = [UIColor clearColor];
    [self.tencentMapView addSubview:self.selectView];
    self.selectView.centerX = self.tencentMapView.width/2.0;
    self.selectView.y = self.tencentMapView.height/2.0 - 36;
    self.tableView.frame = CGRectMake(0, self.tencentMapView.y+self.tencentMapView.height, self.view.frame.size.width, self.view.frame.size.height -self.tencentMapView.y-self.tencentMapView.height);

    dimView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    dimView.hidden = YES;
    dimView.alpha = 0.3;
    dimView.userInteractionEnabled = YES;
    dimView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:dimView];
    
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing)];
    [dimView addGestureRecognizer:gest];

    [self startLocation];
}
- (void)startLocation
{
    [self.tencentMapView setCenterCoordinate:CLLocationCoordinate2DMake([self.locationCity.cityLat floatValue], [self.locationCity.cityLng floatValue]) zoomLevel:17.1 animated:YES];
}
#pragma mark - mapDelegate
- (void)mapViewWillStartLocatingUser:(QMapView *)mapView
{
    
    //获取开始定位的状态
}
- (void)mapViewDidStopLocatingUser:(QMapView *)mapView
{
    //获取停止定位的状态
}
- (void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    //刷新位置
}
- (void)mapView:(QMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if(self.sourceType == MapViewSourceTypeStart && self.tableView.y != 64)
    {
        [self.selectView bounceActionWithBlock:^
         {
             CLLocationCoordinate2D centerCoordinate = mapView.region.center;
             [self getLocationWithLocation:centerCoordinate];
         }];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)thisSearchBar
{
    [searchBar resignFirstResponder];
    [self getSearchResultWith:thisSearchBar.text];
}
- (void)searchBar:(UISearchBar *)thisSearchBar textDidChange:(NSString *)searchText
{
    if(thisSearchBar == searchBar)
    {
        [homeArray removeAllObjects];
        [companyArray removeAllObjects];
        NSString *text = searchBar.text;
        [self getSearchResultWith:text];
    }
    else
    {
        return;
    }
}
- (void)getSearchResultWith:(NSString *)text
{
    [[ServerFactory getServerInstance:@"BeMapServer"]doInquireSuggestAddressWithCity:self.locationCity andText:text byCallBack:^(NSMutableArray *callback)
     {
         [self.dataArray removeAllObjects];
         [self.dataArray addObjectsFromArray:callback];
         [self.tableView reloadData];
         [self tableviewUp];
         if(callback.count < 1&& text.length > 0)
         {
            // [self startSearchWithTencentMap:text];
         }
     }failureCallback:^(NSString *failure) {
         
     }];
}
- (void)tableviewUp
{
    if(dimView.hidden == NO)
    {
        dimView.hidden = YES;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.y = 64;
        self.tableView.height = kScreenHeight - 64;
        self.tencentMapView.hidden = YES;
    }completion:^(BOOL finished)
     {
     }];
}
#pragma mark - tableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self endEditing];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return homeArray.count;
    }
    else if (section == 1)
    {
        return companyArray.count;
    }
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        BeMapCustomAddressCell *cell = [BeMapCustomAddressCell cellWithTableView:tableView];
        BeAddressModel *model = [homeArray objectAtIndex:indexPath.row];
        [cell setAddressModel:model andType:BeMapCustomAddressShowTypeHome];
        [cell.modifyButton addTarget:self action:@selector(modifyHomeAddress) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if (indexPath.section == 1)
    {
        BeMapCustomAddressCell *cell = [BeMapCustomAddressCell cellWithTableView:tableView];
        
        BeAddressModel *model = [companyArray objectAtIndex:indexPath.row];
        [cell setAddressModel:model andType:BeMapCustomAddressShowTypeCompany];
        [cell.modifyButton addTarget:self action:@selector(modifyCompanyAddress) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else
    {
        static NSString *identifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.textColor =[UIColor grayColor];
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        BeAddressModel *model = [self.dataArray objectAtIndex:indexPath.row];
        cell.textLabel.text = model.title;
        cell.detailTextLabel.text = model.address;
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    BeAddressModel *model;
    if(indexPath.section == 0)
    {
        model = [homeArray objectAtIndex:indexPath.row];
        if(model.title == nil|| model.title.length < 1)
        {
            [self modifyHomeAddress];
            return;
        }
    }
    else if (indexPath.section == 1)
    {
        model = [companyArray objectAtIndex:indexPath.row];
        if(model.title == nil|| model.title.length < 1)
        {
            [self modifyCompanyAddress];
            return;
        }
    }
    else if (indexPath.section == 2)
    {
        model = [self.dataArray objectAtIndex:indexPath.row];
    }
    if(model.title.length < 1)
    {
        return;
    }
    if(!([model.city isEqualToString:self.locationCity.cityCode]||[model.city hasPrefix:self.locationCity.cityName]))
    {
        [MBProgressHUD showError:@"不支持跨城市用车"];
        return;
    }
    if (self.sourceType == MapViewSourceTypeStart) {
        [self.delegate selectStartAddressWith:model];
        [self.navigationController popViewControllerAnimated:YES];

    }
    else if (self.sourceType == MapViewSourceTypeDestination)
    {
        [self.delegate selectDestinationWith:model];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.sourceType == MapViewSourceTypeCustomHomeAddress || self.sourceType == MapViewSourceTypeCustomCompanyAddress)
    {
        NSString *flag = self.sourceType == MapViewSourceTypeCustomHomeAddress?@"home":@"company";
        [[ServerFactory getServerInstance:@"BeMapServer"]modifyAddressWithFlag:flag andModel:model Callback:^()
         {
             [[NSNotificationCenter defaultCenter]postNotificationName:@"kCustomAddress" object:[NSNumber numberWithInt:self.sourceType] userInfo:[NSDictionary dictionaryWithObject:model forKey:@"data"]];
             [self.navigationController popViewControllerAnimated:YES];
         }andFailure:^(NSError *error)
         {
             [self requestFlase:error];
         }];
    }
}
- (void)keyboardWillShow{
    if(self.tableView.y == 64)
    {
        dimView.hidden = YES;
    }
    else
    {
        dimView.hidden = NO;
    }
}
- (void)keyboardWillHide
{
    dimView.hidden = YES;
}
- (void)getLocationWithLocation:(CLLocationCoordinate2D )Coordinate
{
    QMSReverseGeoCodeSearchOption *reGeoSearchOption = [[QMSReverseGeoCodeSearchOption alloc] init];
    [reGeoSearchOption setLocationWithCenterCoordinate:Coordinate];
    [reGeoSearchOption setGet_poi:YES];
    [reGeoSearchOption setCoord_type:QMSReverseGeoCodeCoordinateTencentGoogleGaodeType];
    [self.mapSearcher searchWithReverseGeoCodeSearchOption:reGeoSearchOption];
}
- (void)startSearchWithTencentMap:(NSString *)text
{
    QMSPoiSearchOption *poiSearchOption = [[QMSPoiSearchOption alloc] init];
    //地区检索
    [poiSearchOption setBoundaryByRegionWithCityName:self.locationCity.cityName autoExtend:NO];
    [poiSearchOption setKeyword:text];
    [self.mapSearcher searchWithPoiSearchOption:poiSearchOption];
}
//查询出现错误
- (void)searchWithSearchOption:(QMSSearchOption *)searchOption
              didFailWithError:(NSError*)error
{
    
}

//poi查询结果回调函数
- (void)searchWithPoiSearchOption:(QMSPoiSearchOption *)poiSearchOption
                 didReceiveResult:(QMSPoiSearchResult *)poiSearchResult
{
    [self.dataArray removeAllObjects];
    for(QMSPoiData *member in poiSearchResult.dataArray)
    {
        BeAddressModel *model = [[BeAddressModel alloc]init];
        model.title = member.title;
        model.address = member.address;
        model.location = member.location;
        if(self.locationCity.cityCode > 0)
        {
            model.city = self.locationCity.cityCode;
        }
        else
        {
            model.city = self.locationCity.cityName;
        }
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}
- (void)searchWithReverseGeoCodeSearchOption:(QMSReverseGeoCodeSearchOption *)reverseGeoCodeSearchOption didReceiveResult:(QMSReverseGeoCodeSearchResult *)reverseGeoCodeSearchResult
{
    if(![reverseGeoCodeSearchResult.address_component.city hasPrefix:self.locationCity.cityName])
    {
        [MBProgressHUD showError:@"不支持跨城市用车"];
        [self startLocation];
        return;
    }
    [self.dataArray removeAllObjects];
    for(QMSReGeoCodePoi *member in reverseGeoCodeSearchResult.poisArray)
    {
        BeAddressModel *model = [[BeAddressModel alloc]init];
        model.title = member.title;
        model.address = member.address;
        model.location = member.location;
        if(self.locationCity.cityCode > 0)
        {
            model.city = self.locationCity.cityCode;
        }
        else
        {
            model.city = reverseGeoCodeSearchResult.address_component.city;
        }
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}
- (void)interceptionString
{
    if ([self.locationCity.cityName rangeOfString:@"市"].location != NSNotFound && [self.locationCity.cityName rangeOfString:@"州"].location != NSNotFound)
    {
        //过滤掉郑州市的“市”字
        self.locationCity.cityName = [[self.locationCity.cityName componentsSeparatedByString:@"市"] firstObject];
    }
    else if ([self.locationCity.cityName rangeOfString:@"州"].location != NSNotFound && [self.locationCity.cityName rangeOfString:@"市"].location == NSNotFound)
    {
        //过滤掉阿坝州的州字（郑州，广州不可过滤）
        self.locationCity.cityName = [[self.locationCity.cityName componentsSeparatedByString:@"州"] firstObject];
    }
    else if([self.locationCity.cityName rangeOfString:@"市"].location != NSNotFound)
    {
        //过滤掉市字
        self.locationCity.cityName = [[self.locationCity.cityName componentsSeparatedByString:@"市"] firstObject];
    }
    if ([self.locationCity.cityName rangeOfString:@"地区"].location != NSNotFound)
    {
        //过滤掉地区字
        self.locationCity.cityName = [[self.locationCity.cityName componentsSeparatedByString:@"地区"] firstObject];
    }
}
- (void)modifyCompanyAddress
{
    BeMapSearchViewController *addressVC = [[BeMapSearchViewController alloc]init];
    addressVC.locationCity = self.locationCity;
    addressVC.sourceType = MapViewSourceTypeCustomCompanyAddress;
    [self.navigationController pushViewController:addressVC animated:YES];
}
- (void)modifyHomeAddress
{
    BeMapSearchViewController *addressVC = [[BeMapSearchViewController alloc]init];
    addressVC.locationCity = self.locationCity;
    addressVC.sourceType = MapViewSourceTypeCustomHomeAddress;
    [self.navigationController pushViewController:addressVC animated:YES];
}
- (void)updateCustomAddress:(NSNotification *)noti
{
    if([noti.object intValue] == MapViewSourceTypeCustomHomeAddress)
    {
        [homeArray removeAllObjects];
        [homeArray addObject:[[noti userInfo] objectForKey:@"data"]];
    }
    else
    {
        [companyArray removeAllObjects];
        [companyArray addObject:[[noti userInfo] objectForKey:@"data"]];
    }
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
