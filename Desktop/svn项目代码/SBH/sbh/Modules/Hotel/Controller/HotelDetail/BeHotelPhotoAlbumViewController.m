
//
//  BeHotelPhotoAlbumViewController.m
//  sbh
//
//  Created by RobinLiu on 15/12/14.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelPhotoAlbumViewController.h"
#import "SBHHttp.h"
#import "ServerConfigure.h"
#import "ColorUtility.h"
#import "CommonDefine.h"
#import "UIImageView+WebCache.h"
#import "MWPhotoBrowser.h"

@interface BeHotelPhotoAlbumViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MWPhotoBrowserDelegate>

@property (strong, nonatomic)UICollectionView *collectionView;
@end
@implementation BeHotelPhotoAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.hidden = YES;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(kScreenWidth/2.0, kScreenWidth/2.0 * 413.0 / 550.0);//每个cell的大小
    
    layout.minimumLineSpacing = 0.0f;//每行的最小间距
    
    layout.minimumInteritemSpacing = 0.0f;//每列的最小间距
    
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//网格视图的/上/左/下/右,的边距    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView=[[UICollectionView alloc] initWithFrame:self.tableView.frame collectionViewLayout:layout];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    //注册Cell，必须要有
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.view addSubview:self.collectionView];
    self.title = [NSString stringWithFormat:@"酒店相册（%d张）",(int)self.photos.count];
    // Do any additional setup after loading the view.
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
    CGFloat startX = 8;
    if(indexPath.row %2 != 0)
    {
        startX = 4;
    }
    CGFloat width = kScreenWidth/2.0 - 12;
    CGFloat height = width * 413.0 / 550.0;
    CGFloat centerY = kScreenWidth/2.0 * 413.0 / 550.0/2.0;
    UIImageView *iG = [[UIImageView alloc]initWithFrame:CGRectMake(startX, 0, width, height)];
    iG.centerY = centerY;
    [iG sd_setImageWithURL:[NSURL URLWithString:[photo stringValueForKey:@"Image_Path" defaultValue:@""]]];
    iG.contentMode = UIViewContentModeScaleAspectFill;
    iG.clipsToBounds = YES;
    [cell addSubview:iG];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, iG.height - 18, iG.width, 18)];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = [photo stringValueForKey:@"Image_Descrition" defaultValue:@""];
    titleLabel.backgroundColor = [ColorUtility colorWithRed:0 green:0 blue:0 alpha:0.5];
    [iG addSubview:titleLabel];
    return cell;
}
#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self browserWithIndex:(int)indexPath.row];
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)browserWithIndex:(int)index
{
    BOOL displayActionButton = NO;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = YES;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;//分享按钮,默认是
    browser.displayNavArrows = displayNavArrows;//左右分页切换,默认否
    browser.displaySelectionButtons = displaySelectionButtons;//是否显示选择按钮在图片上,默认否
    browser.alwaysShowControls = NO;//控制条件控件 是否显示,默认否
    browser.zoomPhotosToFill = enableGrid;//是否全屏,默认是
    browser.enableGrid = enableGrid;//是否允许用网格查看所有图片,默认是
    browser.startOnGrid = startOnGrid;//是否第一张,默认否
    browser.enableSwipeToDismiss = YES;
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    [browser setCurrentPhotoIndex:index];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:browser];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
   // [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id )photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < _photos.count)
    {
        NSDictionary *member = [_photos objectAtIndex:index];
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[member stringValueForKey:@"Image_Path" defaultValue:@""]]];
        photo.caption = [member stringValueForKey:@"Image_Descrition" defaultValue:@""];
        return photo;
    }
    return nil;
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
