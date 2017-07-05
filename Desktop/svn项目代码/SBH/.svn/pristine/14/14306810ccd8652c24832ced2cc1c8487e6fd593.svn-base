//
//  BeHotelOrderPriceListView.m
//  sbh
//
//  Created by RobinLiu on 15/12/15.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelOrderPriceListView.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "CommonDefine.h"
#import "CommonMethod.h"
#import "BePriceListModel.h"

#define kHotelContentHeight 25.0f
#define kHotelContentX 18.0
#define kHotelFooterViewHeight 70.0

#define kTitleFont [UIFont systemFontOfSize:17]
#define kContentFont [UIFont systemFontOfSize:15]

@interface BeHotelOrderPriceListView()<UIGestureRecognizerDelegate, UITableViewDataSource,UITableViewDelegate>
{
    BeHotelOrderWriteModel *listModel;
    BeHotelOrderPriceListViewType privateType;
}
@property (nonatomic,strong)UITableView *tableView;
@end
static BeHotelOrderPriceListView *_instance = nil;
@implementation BeHotelOrderPriceListView
+ (BeHotelOrderPriceListView *)sharedInstance
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
        privateType = BeHotelOrderPriceListViewTypeWrite;
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorColor = [UIColor clearColor];
        [self addSubview:self.tableView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideDetailView)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        listModel = [[BeHotelOrderWriteModel alloc]init];
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
- (void)showViewWithData:(BeHotelOrderWriteModel *)object andType:(BeHotelOrderPriceListViewType)type
{
    privateType = type;
    [[[UIApplication sharedApplication]keyWindow]addSubview:self];
    listModel = object;
    [self.tableView reloadData];
    [self setData];
}
- (void)setData
{
    if(self.tableView.contentSize.height > (kScreenHeight - 20))
    {
        self.tableView.y = 20;
        self.tableView.height = kScreenHeight - 20;
        self.tableView.scrollEnabled = YES;
    }
    else
    {
        self.tableView.y = (kScreenHeight - 20 - self.tableView.contentSize.height) * 0.3 + 20;
        self.tableView.height = self.tableView.contentSize.height;
        self.tableView.scrollEnabled = NO;
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listModel.priceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kHotelFooterViewHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"priceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    BePriceListModel *prModel = [listModel.priceArray objectAtIndex:indexPath.row];
    cell.textLabel.text = prModel.RoomDate;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@ *%lu",prModel.SalePrice,(unsigned long)listModel.Persons.count];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = SBHYellowColor;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    headView.backgroundColor = [UIColor clearColor];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 20)];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:16];
    title.text = @"费用明细";
    [headView addSubview:title];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 60 - 20, 100, 16)];
    priceLabel.textColor = [ColorConfigure globalBgColor];
    priceLabel.font = [UIFont systemFontOfSize:13];
    priceLabel.text = @"房费";
    [headView addSubview:priceLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 59, kScreenWidth - 30, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:lineView];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHotelFooterViewHeight)];
    footerView.backgroundColor = [UIColor clearColor];
    UILabel *prTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth - 15, kHotelFooterViewHeight - 30)];
    prTitle.textAlignment = NSTextAlignmentRight;
    
    //应付金额￥1175-优惠金额￥15=应付金额￥1170
    double totalPrice = 0;
    double discount = 0;
    double totalPrice2 = 0;

    for(BePriceListModel *prModel in listModel.priceArray)
    {
        totalPrice = totalPrice + (int)listModel.Persons.count * [prModel.SalePrice doubleValue];
        discount = discount + (int)listModel.Persons.count * [prModel.Dr_MinPrice doubleValue];
    }
    totalPrice2 = totalPrice - discount;
    
    if(privateType == BeHotelOrderPriceListViewTypeWrite)
    {
        NSString *str1 = @"应付总额";
        NSString *str2 = [NSString stringWithFormat:@"￥%.2lf",totalPrice2];
        NSString *str3 = @"";//@" - 优惠金额";
        NSString *str4 = @"";//[NSString stringWithFormat:@"￥%.2lf",discount];
        NSString *str5 = @"";//@" = 应付金额";
        NSString *str6 = @"";//[NSString stringWithFormat:@"￥%.2lf",totalPrice2];
        
        NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@%@",str1,str2,str3,str4,str5,str6];
        NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:str];
        [attrib addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [str1 length])];
        [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange([str1 length], [str2 length])];
        
        [attrib addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange([str1 length]+ [str2 length], [str3 length])];
        [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange([str1 length]+ [str2 length]+[str3 length], [str4 length])];
        
        [attrib addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange([str1 length]+ [str2 length]+[str3 length]+ [str4 length], [str5 length])];
        [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange([str1 length]+ [str2 length]+[str3 length]+ [str4 length]+[str5 length], [str6 length])];
        
        [attrib addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, [str length])];
        prTitle.attributedText = attrib;
        prTitle.numberOfLines = 0;
        [footerView addSubview:prTitle];
    }
    else
    {
        NSString *str1 = @"";
        NSString *str2 = @"";
        NSString *str3 = @"";
        NSString *str4 = @"";
        NSString *str5 = @"应付金额";
        NSString *str6 = [NSString stringWithFormat:@"￥%.2lf",totalPrice2];
        
        NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@%@",str1,str2,str3,str4,str5,str6];
        NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:str];
        [attrib addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [str1 length])];
        [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange([str1 length], [str2 length])];
        
        [attrib addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange([str1 length]+ [str2 length], [str3 length])];
        [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange([str1 length]+ [str2 length]+[str3 length], [str4 length])];
        
        [attrib addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange([str1 length]+ [str2 length]+[str3 length]+ [str4 length], [str5 length])];
        [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange([str1 length]+ [str2 length]+[str3 length]+ [str4 length]+[str5 length], [str6 length])];
        
        [attrib addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, [str length])];
        prTitle.attributedText = attrib;
        prTitle.numberOfLines = 0;
        [footerView addSubview:prTitle];
    }
    return footerView;
}

- (void)hideDetailView
{
    [self removeFromSuperview];
}
@end
