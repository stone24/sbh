//
//  BeRoomRow00Cell.m
//  SideBenefit
//
//  Created by SBH on 15-3-11.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelDetailPolicyView.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "CommonDefine.h"
#import "CommonMethod.h"

#define kHotelContentHeight 25.0f
#define kHotelContentX 18.0


#define kTitleFont [UIFont systemFontOfSize:17]
#define kContentFont [UIFont systemFontOfSize:15]

@interface BeHotelDetailPolicyView()<UIGestureRecognizerDelegate, UITableViewDataSource,UITableViewDelegate>
{
    BeHotelRegulationModel *listModel;
}
@property (nonatomic, strong)UITableViewCell *prototypeCell;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *section0Array;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end
static BeHotelDetailPolicyView *_instance = nil;
@implementation BeHotelDetailPolicyView
+ (BeHotelDetailPolicyView *)sharedInstance
{
    if(_instance == nil)
    {
        @synchronized(self)
        {
            if(!_instance)
            {
                _instance = [[self alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
            }
        }
    }
    return _instance;
}
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorColor = [UIColor clearColor];
        [self addSubview:self.tableView];
        
        self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideDetailView)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        self.section0Array = [[NSMutableArray alloc]init];
        self.dataArray = [[NSMutableArray alloc]init];
        listModel = [[BeHotelRegulationModel alloc]init];
    }
    return self;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return YES;
    }
    return  YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        if([self.section0Array count] > 0)
        {
            return 1;
        }
    }
    else if([self.dataArray count] > 0)
    {
        return 1;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return [self getHeightWith:[self.section0Array firstObject]] + 5;
    }
    else
    {
        return ([self getHeightWith:[self.dataArray objectAtIndex:indexPath.section - 1]] + 5);
    }
    return kHotelContentHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section != 0)
    {
        return 30.0f;
    }
    return 0.001f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section != 0)
    {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 14,kScreenWidth, 30.0f)];
        headerView.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 0, kScreenWidth - 28, 30)];
        titleLabel.font = kTitleFont;
        titleLabel.text = @"酒店提示：";
        titleLabel.textColor = [ColorConfigure globalBgColor];
        [headerView addSubview:titleLabel];
        return headerView;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = kContentFont;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    if(indexPath.section == 0)
    {
        cell.textLabel.text = [self.section0Array objectAtIndex:indexPath.row];
    }
    else
    {
        cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.section - 1];
    }
    return cell;
}
- (void)showViewWithData:(BeHotelRegulationModel *)object
{
    listModel = object;
    [self setData];
    [[[UIApplication sharedApplication]keyWindow]addSubview:self];
}
- (void)setData
{
    [self.section0Array removeAllObjects];
    [self.dataArray removeAllObjects];
    if(listModel.Rul_ArrAndDep.length > 0)
    {
        [self.section0Array addObject:listModel.Rul_ArrAndDep];
    }
    if(listModel.Rul_Cancel.length > 0)
    {
        [self.dataArray addObject:listModel.Rul_Cancel];
    }
    if(listModel.Rel_DepAndPre.length > 0)
    {
        [self.dataArray addObject:listModel.Rel_DepAndPre];
    }
    if(listModel.Rel_Pet.length > 0)
    {
        [self.dataArray addObject:listModel.Rel_Pet];
    }
    if(listModel.Rel_Requirements.length > 0)
    {
        [self.dataArray addObject:listModel.Rel_Requirements];
    }
    if(listModel.Rel_CheckIn.length > 0)
    {
        [self.dataArray addObject:listModel.Rel_CheckIn];
    }
    if(listModel.Rel_CheckOut.length > 0)
    {
        [self.dataArray addObject:listModel.Rel_CheckOut];
    }
    [self.tableView reloadData];
    
    if(self.tableView.contentSize.height > (kScreenHeight - 20))
    {
        self.tableView.y = 20;
        self.tableView.height = kScreenHeight - 20;
        self.tableView.scrollEnabled = YES;
    }
    else
    {
        self.tableView.y = 20 + (kScreenHeight - 20 - self.tableView.contentSize.height) * 0.7;
        self.tableView.height = self.tableView.contentSize.height;
        self.tableView.scrollEnabled = NO;
    }
}
- (void)hideDetailView
{
    [self removeFromSuperview];
}
- (CGFloat)getHeightWith:(NSString *)text
{
    CGRect sumRect = [text boundingRectWithSize:CGSizeMake(kScreenWidth - 15 - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kContentFont} context:nil];
    return sumRect.size.height;
}

@end