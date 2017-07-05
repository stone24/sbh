//
//  BeHotelMapViewController.m
//  sbh
//
//  Created by RobinLiu on 16/3/30.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeHotelMapViewController.h"
#import "BeHotelDetailController.h"

#import "BeHotelMapTableHeaderView.h"
#import "BeHotelAnnotationView.h"
#import "CommonUtility.h"
#import "UIActionSheet+Block.h"
#import "UIImageView+WebCache.h"

#import "BeHotelAnnotation.h"

#define kCalloutViewMargin          -8
@interface BeHotelMapViewController ()<BeHotelMapTableHeaderDelegate>

@property (nonatomic,assign)BOOL showList;
@property (nonatomic,strong) NSMutableArray *annotations;
@property (nonatomic,strong) NSMutableArray *nearbyAnnotations;
@end

@implementation BeHotelMapViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.showList = NO;
    self.annotations = [[NSMutableArray alloc]init];
    self.nearbyAnnotations = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    self.mapView = [[MAMapView alloc]init];
    self.mapView.frame = self.view.bounds;
    self.mapView.delegate = self;
   // self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
    [self.view addSubview:self.mapView];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(5, 24, 40, 36);
    [leftButton setImage:[UIImage imageNamed:@"commonBackArrow"] forState:UIControlStateNormal];
    leftButton.backgroundColor = [UIColor darkGrayColor];
    leftButton.alpha = 0.8;
    leftButton.layer.cornerRadius = 3.0f;
    [leftButton addTarget:self action:@selector(leftMenuClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    UIButton *guideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    guideButton.frame = CGRectMake(kScreenWidth - 50 - 5, 24, 50, 36);
    [guideButton setTitle:@"导航" forState:UIControlStateNormal];
    guideButton.backgroundColor = [UIColor darkGrayColor];
    guideButton.alpha = 0.8;
    guideButton.layer.cornerRadius = 3.0f;
    leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [guideButton addTarget:self action:@selector(guideAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:guideButton];
    
    BeHotelMapTableHeaderView *headerView = [[BeHotelMapTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
    headerView.delegate = self;
    self.tableView.tableHeaderView = headerView;
    [self getListData];
    [self changeFrameWith:NO];
  //  [self.mapView showAnnotations:self.annotations edgePadding:UIEdgeInsetsMake(20, 20, 20, 80) animated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.mapView.zoomLevel = 16.1;
    MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
    a1.coordinate = CLLocationCoordinate2DMake([self.hotelItem.googleLon doubleValue],[self.hotelItem.googleLat doubleValue]);
    a1.title      = self.hotelItem.hotelName;
    [self.annotations addObject:a1];
    [self.mapView addAnnotations:self.annotations];
    [self.mapView setCenterCoordinate:[self.annotations[0] coordinate] animated:YES];
    [self.mapView selectAnnotation:self.annotations[0] animated:YES];
}
- (void)changeFrameWith:(BOOL)isShow
{
    CGFloat mapViewHeight = isShow?(kScreenHeight/2.0):(kScreenHeight - 25);
    self.mapView.frame = CGRectMake(0, 0, kScreenWidth, mapViewHeight);
    
    self.tableView.frame = CGRectMake(0, self.mapView.height, kScreenWidth, kScreenHeight - self.mapView.height);
}
- (void)showTableView
{
    [UIView animateWithDuration:0.3 animations:^{
        [self changeFrameWith:YES];
        self.tableView.scrollEnabled = YES;
    }completion:^(BOOL finished)
    {
        [self.mapView addAnnotations:self.nearbyAnnotations];
        NSMutableArray *allArray = [NSMutableArray array];
        [allArray addObjectsFromArray:[self.annotations mutableCopy]];
        [allArray addObjectsFromArray:[self.nearbyAnnotations mutableCopy]];
        [self.mapView setVisibleMapRect:[CommonUtility minMapRectForAnnotations:allArray] animated:YES];
    }];
}
- (void)hideTableView
{
    [UIView animateWithDuration:0.3 animations:^{
        [self changeFrameWith:NO];
        self.tableView.scrollEnabled = NO;
    }completion:^(BOOL finished)
     {
         [self.mapView removeAnnotations:self.nearbyAnnotations];
         // [self.mapView showAnnotations:self.annotations edgePadding:UIEdgeInsetsMake(20, 20, 20, 80) animated:YES];
         [self.mapView setCenterCoordinate:[self.annotations[0] coordinate] animated:YES];
         [self.mapView selectAnnotation:self.annotations[0] animated:YES];
     }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    BeHotelListItem *detailModel = [self.dataArray objectAtIndex:indexPath.row];
    for(UIView *subView in [cell subviews])
    {
        if([subView isKindOfClass:[UILabel class]])
        {
            [subView removeFromSuperview];
        }
    }
    UILabel *cellTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [cellTextLabel setNumberOfLines:0];
    [cellTextLabel setFrame:CGRectMake(12,0, kScreenWidth - 12 - 75,70)];
    cellTextLabel.attributedText = [self textLabelAttribWith:detailModel];
    [cell addSubview:cellTextLabel];

    UILabel *cellDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [cellDetailLabel setNumberOfLines:0];
    [cellDetailLabel setFrame:CGRectMake(kScreenWidth - 75,0, 65,70)];
    cellDetailLabel.textAlignment = NSTextAlignmentRight;
    cellDetailLabel.attributedText = [self detailLabelAttribWith:detailModel];
    [cell addSubview:cellDetailLabel];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.mapView selectAnnotation:[self.nearbyAnnotations objectAtIndex:indexPath.row] animated:YES];
}
#pragma mark - 获取附近酒店数据
- (void)getListData
{
 /*   CLLocationCoordinate2D coordinates[10] = {
        {39.992520, 116.336170},
        {39.992520, 116.336170},
        {39.998293, 116.352343},
        {40.004087, 116.348904},
        {40.001442, 116.353915},
        {39.989105, 116.353915},
        {39.989098, 116.360200},
        {39.998439, 116.360201},
        {39.979590, 116.324219},
        {39.978234, 116.352792}};
    
    for (int i = 0; i < 10; ++i)
    {
        MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
        a1.coordinate = coordinates[i];
        a1.title      = [NSString stringWithFormat:@"anno: %d", i];
        [self.nearbyAnnotations addObject:a1];
        
        BeHotelListItem *item = [[BeHotelListItem alloc]init];
        item.hotelName = [NSString stringWithFormat:@"%d",i];
        [self.dataArray addObject:item];
    }
    [self.tableView reloadData];

    */
    [[ServerFactory getServerInstance:@"BeHotelServer"]getNearByHotelWith:self.hotelItem byCallback:^(NSMutableArray *callback)
     {
         [self.dataArray removeAllObjects];
         [self.dataArray addObjectsFromArray:callback];
         for(BeHotelListItem *member in self.dataArray)
         {
             BeHotelAnnotation *a1 = [[BeHotelAnnotation alloc] init];
             a1.coordinate = CLLocationCoordinate2DMake([member.googleLon doubleValue],[member.googleLat doubleValue]);
             a1.hotelModel = member;
             a1.index = [self.dataArray indexOfObject:member];
             [self.nearbyAnnotations addObject:a1];
         }
         [self.tableView reloadData];
     }failureCallback:^(NSError *failureCallback)
     {
         
     }];
}
#pragma mark - 导航
- (void)guideAction
{
    CLLocationCoordinate2D coords2 = CLLocationCoordinate2DMake([self.hotelItem.googleLon doubleValue],[self.hotelItem.googleLat doubleValue]); // 直接调用ios自己带的apple map
    { //当前的位置
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation]; //起点
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords2 addressDictionary:nil]];
        toLocation.name = self.hotelItem.hotelName;
        NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
        NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES}; //打开苹果自身地图应用，并呈现特定的item
        [MKMapItem openMapsWithItems:items launchOptions:options];
    }
}
#pragma mark - 点击view
- (void)receiveSelect:(NSNotification *)noti
{
    [self didSelectViewWith:[[noti.userInfo objectForKey:@"index"] integerValue]];
}

- (void)didSelectViewWith:(NSInteger)index
{
    BeHotelDetailController *detailVC = [[BeHotelDetailController alloc]init];
    detailVC.item = [self.dataArray objectAtIndex:index];
    detailVC.item.cityId = [self.hotelItem.cityId mutableCopy];
    detailVC.item.CheckInDate = [self.hotelItem.CheckInDate mutableCopy];
    detailVC.item.CheckOutDate = [self.hotelItem.CheckOutDate mutableCopy];
    detailVC.item.cityName = [self.hotelItem.cityName mutableCopy];
    detailVC.sourceType = HotelDetailSourceTypeHotelList;
    [self.navigationController pushViewController:detailVC animated:YES];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveSelect:) name:kHotelAnnotationNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        if([annotation.title isEqualToString:self.hotelItem.hotelName])
        {
            static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
            MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
            if (annotationView == nil)
            {
                annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            }
            annotationView.canShowCallout               = YES;
            annotationView.animatesDrop                 = YES;
            annotationView.draggable                    = YES;
            annotationView.rightCalloutAccessoryView    = [UIButton buttonWithType:UIButtonTypeCustom];
            annotationView.pinColor                     = MAPinAnnotationColorRed;
            return annotationView;
        }
    }
    else if ([annotation isKindOfClass:[BeHotelAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        BeHotelAnnotationView *annotationView = (BeHotelAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[BeHotelAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            // must set to NO, so we can show the custom callout view.
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -5);
        }
        /*annotationView.image = [UIImage imageNamed:@"hotelAnnotation"];
        NSInteger index = [self.nearbyAnnotations indexOfObject:annotation];
        BeHotelListItem*item =[self.dataArray objectAtIndex:index];
        annotationView.portrait = [UIImage imageNamed:@"hema.png"];
        annotationView.name     = item.hotelName;
        annotationView.imageUrl = item.hotelImageUrl;
        annotationView.calloutView.title = item.hotelName;
         annotationView.calloutView.subtitle = item.hotelName;
         [annotationView.calloutView.portraitView sd_setImageWithURL:[NSURL URLWithString:item.hotelImageUrl]];
         */
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"accessory view :%@", view);
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view didChangeDragState:(MAAnnotationViewDragState)newState fromOldState:(MAAnnotationViewDragState)oldState
{
    NSLog(@"old :%ld - new :%ld", (long)oldState, (long)newState);
}

- (void)mapView:(MAMapView *)mapView didAnnotationViewCalloutTapped:(MAAnnotationView *)view
{
    NSLog(@"callout view :%@", view);
}

#pragma mark - Life Cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        self.annotations = [NSMutableArray array];
    }
    return self;
}

- (CGPoint)randomPoint
{
    CGPoint randomPoint = CGPointZero;
    
    randomPoint.x = arc4random() % (int)(CGRectGetWidth(self.view.bounds));
    randomPoint.y = arc4random() % (int)(CGRectGetHeight(self.view.bounds));
    
    return randomPoint;
}

- (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect
{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}

#pragma mark - Action Handle
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view
{
    if([view.reuseIdentifier isEqualToString:@"customReuseIndetifier"])
    {
        if ([view isKindOfClass:[BeHotelAnnotationView class]])
        {
            BeHotelAnnotationView *cusView = (BeHotelAnnotationView *)view;
            [cusView setSelected:NO animated:YES];
        }
    }
    else
    {
        [view setSelected:NO animated:YES];
    }
}
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    
    /* Adjust the map center in order to show the callout view completely. */
    if ([view isKindOfClass:[BeHotelAnnotationView class]])
    {
        BeHotelAnnotationView *cusView = (BeHotelAnnotationView *)view;
        CGRect frame = [cusView convertRect:cusView.calloutView.frame toView:self.mapView];
        
        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin));
        
        if (!CGRectContainsRect(self.mapView.frame, frame))
        {
            CGSize offset = [self offsetToContainRect:frame inRect:self.mapView.frame];
            
            CGPoint theCenter = self.mapView.center;
            theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
            
            CLLocationCoordinate2D coordinate = [self.mapView convertPoint:theCenter toCoordinateFromView:self.mapView];
            
            [self.mapView setCenterCoordinate:coordinate animated:YES];
        }
    }
    else
    {
        [self.mapView setCenterCoordinate:[self.annotations[0] coordinate] animated:YES];
        [view setSelected:YES animated:YES];
    }
}
#pragma mark - cell显示数据
- (NSMutableAttributedString *)textLabelAttribWith:(BeHotelListItem *)item
{
    CLLocation *orig = [[CLLocation alloc] initWithLatitude:[self.hotelItem.googleLon doubleValue]  longitude:[self.hotelItem.googleLat doubleValue]];
    
    CLLocation* dist = [[CLLocation alloc] initWithLatitude:[item.googleLon doubleValue] longitude:[item.googleLat doubleValue] ];
    
    CLLocationDistance kilometers=[orig distanceFromLocation:dist];
    item.distance = kilometers;
    
    NSString *hotelName = item.hotelName;
    NSString *hotelContent= [NSString stringWithFormat:@"%@分 离酒店直线距离%.2f米",item.reviewScore,item.distance];
    NSString *hotelAddress = item.hotelAddress;
    NSMutableAttributedString *textLabelAttrib = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@\n%@",hotelName,hotelContent,hotelAddress]];
    
    [textLabelAttrib setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(0,[hotelName length])];
    [textLabelAttrib setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange([hotelName length],[textLabelAttrib length] - [hotelName length])];
    
    [textLabelAttrib addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, hotelName.length)];
    [textLabelAttrib addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange([hotelName length],[textLabelAttrib length] - [hotelName length])];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3.0];//调整行间距
    [textLabelAttrib addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textLabelAttrib length])];
    return textLabelAttrib;
}
- (NSMutableAttributedString *)detailLabelAttribWith:(BeHotelListItem *)item
{
    int starRate = 0;
    NSString *starString = [NSString string];
    if(item.Hotel_Star.length > 0)
    {
        starRate = [item.Hotel_Star intValue];
        switch (starRate) {
            case 7:
                starString = @"七星";
                break;
            case 6:
                starString = @"六星";
                break;
            case 5:
                starString = @"五星";
                break;
            case 4:
                starString = @"四星";
                break;
            case 3:
                starString = @"三星";
                break;
            default:
                starString = @"两星及以下";
                break;
        }
    }
    else if(item.Hotel_SBHStar.length > 0)
    {
        starRate = [item.Hotel_SBHStar intValue];
        switch (starRate) {
            case 7:
                starString = @"豪华";
                break;
            case 6:
                starString = @"豪华";
                break;
            case 5:
                starString = @"豪华";
                break;
            case 4:
                starString = @"高档";
                break;
            case 3:
                starString = @"舒适";
                break;
            default:
                starString = @"经济";
                break;
        }
    }
    else
    {
        starString = @"两星及以下/经济";
    }
    
    NSString *priceIcon = @"￥";
    NSString *priceString = item.price;
    NSString *priceTitle = @" 起";
    NSMutableAttributedString *priceAttrib = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@\n%@",priceIcon,priceString,priceTitle,starString]];
    [priceAttrib setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(0,[priceIcon length])];
    [priceAttrib setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:17]} range:NSMakeRange([priceIcon length],[priceString length])];
    [priceAttrib setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange([priceIcon length]+[priceString length],[priceTitle length])];
    [priceAttrib setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange([priceIcon length]+[priceString length] + [priceTitle length] + 1 ,[starString length])];

    [priceAttrib addAttribute:NSForegroundColorAttributeName value:[ColorConfigure loginButtonColor] range:NSMakeRange(0, priceIcon.length + priceString.length)];
    [priceAttrib addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(priceIcon.length + priceString.length,priceAttrib.length - priceIcon.length - priceString.length)];
    return priceAttrib;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
