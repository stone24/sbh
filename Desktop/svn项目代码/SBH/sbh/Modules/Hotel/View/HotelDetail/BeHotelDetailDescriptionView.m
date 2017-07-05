
//
//  BeHotelDetailDescriptionView.m
//  sbh
//
//  Created by RobinLiu on 15/12/11.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import "BeHotelDetailDescriptionView.h"
#import "ColorConfigure.h"
#import "ColorUtility.h"
#import "UIImageView+WebCache.h"
#import "ServerConfigure.h"
#import "CommonDefine.h"
#import "CommonMethod.h"

#define kHotelImageHeight (343.0 * kScreenWidth / 604.0)
#define kHotelContentHeight 25.0f
#define kHotelContentX 18.0
#define kHotelLayerCorner 3.0

#define kHotelHeaderHeight 40
#define kHotelFooterHeight 44

#define kAnimationAppear @"AppearAnimation"
#define kAnimationDiappear @"DisappearAnimation"
#define kCancelImage @"hoteldetail_cancelBtn_normal"
#define kPlaceHolderImage @"hotellist_cell_placeHolderImage"

#define kAppearDuration 0.4
#define kDisappearDuration 0.4
#define kTitleFont [UIFont systemFontOfSize:17]
#define kContentFont [UIFont systemFontOfSize:15]
#define kScrollSize  (CGRectGetWidth([UIApplication sharedApplication].keyWindow.frame)-70)
#define kTitleVerticalSpace 12
#define kImageVerticalSpace 6
#define kLabelHeight 15

@interface BeHotelDetailDescriptionView()<UIGestureRecognizerDelegate, UITableViewDataSource,UITableViewDelegate>
{
    UIView *detailView;
    BookBlock privateBlock;
    BeHotelDetailRoomListModel *listModel;
    UILabel *discountLabel;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *section1Array;
@property (nonatomic,strong)NSMutableArray *section2Array;
@property (nonatomic,strong)UILabel *hotelNameLabel;
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UIButton *bookButton;
@property (nonatomic,strong)UIImageView *arrowImageView;
@property (nonatomic,assign)BOOL isSpread;
@property (nonatomic,strong)NSString *checkInDate;
@end
static BeHotelDetailDescriptionView *_instance = nil;
@implementation BeHotelDetailDescriptionView
+ (BeHotelDetailDescriptionView *)sharedInstance
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
        _checkInDate = [[NSString alloc]init];
        self.userInteractionEnabled = YES;
        detailView = [[UIView alloc]initWithFrame:CGRectMake(10, 50, kScreenWidth - 20, kScreenHeight-100)];
        detailView.layer.cornerRadius = kHotelLayerCorner;
        detailView.backgroundColor = [UIColor whiteColor];
        [self addSubview:detailView];
        
        [self addHeader];
        [self addFooter];
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kHotelHeaderHeight, detailView.width, detailView.height - kHotelHeaderHeight - kHotelFooterHeight) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.separatorColor = [UIColor clearColor];
        [detailView addSubview:self.tableView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideDetailView)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        self.section1Array = [[NSMutableArray alloc]init];
        self.section2Array = [[NSMutableArray alloc]init];
        listModel = [[BeHotelDetailRoomListModel alloc]init];
    }
    return self;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
- (void)addHeader
{
    self.hotelNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 0, detailView.width - 17 - 35, kHotelHeaderHeight)];
    self.hotelNameLabel.font = [UIFont systemFontOfSize:kLabelHeight];
    self.hotelNameLabel.numberOfLines = 0;
    self.hotelNameLabel.textColor = [UIColor blackColor];
    [detailView addSubview:self.hotelNameLabel];
    
    discountLabel = [[UILabel alloc]initWithFrame:CGRectMake(250 + 13, 5, 14, 14)];
    discountLabel.text = @"减";
    discountLabel.textColor = [UIColor whiteColor];
    discountLabel.backgroundColor = [UIColor redColor];
    discountLabel.textAlignment = NSTextAlignmentCenter;
    discountLabel.centerY = self.hotelNameLabel.centerY;
    discountLabel.font = [UIFont systemFontOfSize:11];
   // [detailView addSubview:discountLabel];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(CGRectGetWidth(detailView.frame)-35, 0, 20, 20);
    cancelButton.centerY = kHotelHeaderHeight/2.0;
    [cancelButton setImage:[UIImage imageNamed:kCancelImage] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(hideDetailView) forControlEvents:UIControlEventTouchUpInside];
    [detailView addSubview:cancelButton];
}
- (void)addFooter
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, detailView.height - kHotelFooterHeight, detailView.width, kHotelFooterHeight)];
    footerView.backgroundColor = [ColorUtility colorFromHex:0xf6f6f6];
    [detailView addSubview:footerView];

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:footerView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(kHotelLayerCorner, kHotelLayerCorner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = footerView.bounds;
    maskLayer.path = maskPath.CGPath;
    footerView.layer.mask = maskLayer;
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 20)];
    self.priceLabel.centerY = kHotelFooterHeight/2.0f;
    self.priceLabel.textColor = [ColorConfigure loginButtonColor];
    [footerView addSubview:self.priceLabel];
    
    self.bookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bookButton.frame = CGRectMake(footerView.width - 52 - 10, 0,52, 21);
    [self.bookButton setBackgroundColor:[ColorConfigure loginButtonColor]];
    self.bookButton.centerY = kHotelFooterHeight/2.0f;
    self.bookButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.bookButton.layer.cornerRadius = 2.0f;
    [self.bookButton setTitle:@"预订" forState:UIControlStateNormal];
    [self.bookButton addTarget:self action:@selector(bookAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:self.bookButton];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return self.section1Array.count;
    }
    else if(section == 2)
    {
        if(self.isSpread)
        {
            return self.section2Array.count;
        }
        else
        {
            return 0;
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return kHotelImageHeight;
    }
    if(indexPath.section == 1)
    {
        NSAttributedString *member = [self.section1Array objectAtIndex:indexPath.row];
        return [self getHeightWith:member.string] + 10;
    }
    else if(indexPath.section == 2)
    {
        NSAttributedString *member = [self.section2Array objectAtIndex:indexPath.row];
        return [self getHeightWith:member.string] + 10;
    }
    return kHotelContentHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return 10.0f;
    }
    else if(section == 2)
    {
        return 40.0f;
    }
    return 0.001f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, detailView.width, 10)];
        headerView.backgroundColor = [UIColor whiteColor];
        return headerView;
    }
    if(section == 2)
    {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, detailView.width, 40)];
        headerView.backgroundColor = [UIColor whiteColor];
        CGRect textSize = [@"查看更多房型设施" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kContentFont} context:nil];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kHotelContentX, 0, textSize.size.width, 20)];
        titleLabel.centerY = headerView.height/2.0f;
        titleLabel.font = kContentFont;
        titleLabel.text = @"查看更多房型设施";
        titleLabel.textColor = [ColorConfigure globalBgColor];
        [headerView addSubview:titleLabel];
        
        self.arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhankai_a_icon"]];
        self.arrowImageView.x = CGRectGetMaxX(titleLabel.frame) + 5;
        self.arrowImageView.centerY = headerView.height/2.0f;
        [headerView addSubview:self.arrowImageView];
        if(self.isSpread)
        {
             self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform, -M_PI);
        }
        else
        {
            self.arrowImageView.transform = CGAffineTransformIdentity;
        }
        UIButton *spreadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        spreadButton.frame = headerView.bounds;
        [spreadButton addTarget:self action:@selector(spreadAction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:spreadButton];
        return headerView;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.textLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.section == 0)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, detailView.width, kHotelImageHeight)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:listModel.Room_Image]placeholderImage:[UIImage imageNamed:@"hotellist_cell_placeHolderImage"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [cell addSubview:imageView];
    }
    if(indexPath.section == 1)
    {
        cell.textLabel.attributedText = [self.section1Array objectAtIndex:indexPath.row];
    }
    if(indexPath.section == 2)
    {
        cell.textLabel.attributedText = [self.section2Array objectAtIndex:indexPath.row];
    }
    return cell;
}
- (void)spreadAction
{
    self.isSpread = !self.isSpread;
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    dispatch_async(dispatch_get_main_queue(), ^{
        //刷新完成
        if(self.isSpread)
        {
            if(self.section2Array.count > 0)
            {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
    });
       // reloadDate会在主队列执行，而dispatch_get_main_queue会等待机会，直到主队列空闲才执行
}
- (void)bookAction
{
    privateBlock();
    [self hideDetailView];
}

- (void)showViewWithData:(BeHotelDetailRoomListModel *)object andCheckInDate:(NSString *)dateString andBlock:(BookBlock)block
{
    listModel = object;
    privateBlock = block;
    _checkInDate = [dateString mutableCopy];
    [self setData];
    [[[UIApplication sharedApplication]keyWindow]addSubview:self];
    [UIView animateWithDuration:0.25f animations:^
     {
         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
     }completion:^(BOOL finished)
     {
         
     }];
}
- (void)setData
{
    self.isSpread = NO;
    self.hotelNameLabel.text = listModel.Room_Name;
    BOOL isDiscount = [listModel.Dr_Amount floatValue] - [listModel.Dr_PromotionPrice floatValue] == 0?NO : YES;
    if(isDiscount)
    {
        discountLabel.hidden = NO;
        CGSize nameSize = [self.hotelNameLabel.text sizeWithAttributes:@{NSFontAttributeName:self.hotelNameLabel.font}];
        discountLabel.x = self.hotelNameLabel.x + nameSize.width + 2 ;
    }
    else
    {
        discountLabel.hidden = YES;
    }
   
    UIColor *enbleColor = [ColorConfigure loginButtonColor];
    if([listModel.Dr_SellStatus isEqualToString:@"0"])
    {
        enbleColor = [UIColor lightGrayColor];
        self.bookButton.enabled = NO;
        [self.bookButton setTitle:@"满房" forState:UIControlStateNormal];
    }
    else
    {
        self.bookButton.enabled = YES;
        [self.bookButton setTitle:@"预订" forState:UIControlStateNormal];
    }
    [self.bookButton setBackgroundColor:enbleColor];
    
    NSString *priceIcon = @"￥";
    NSString *priceString = listModel.Dr_Amount;
    NSMutableAttributedString *priceAttrib = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",priceIcon,priceString]];
    [priceAttrib setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(0,[priceIcon length])];
    [priceAttrib setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:17]} range:NSMakeRange([priceIcon length],[priceString length])];
    [priceAttrib addAttribute:NSForegroundColorAttributeName value:enbleColor range:NSMakeRange(0,priceAttrib.length)];
    self.priceLabel.attributedText = priceAttrib;
    
    [self.section1Array removeAllObjects];
    [self.section2Array removeAllObjects];
    
    NSArray *titleArray = @[@"早餐",@"面积",@"可住",@"床型",@"楼层",@"无烟",@"宽带",@"到店现付",@"不可取消"];
    for(int i = 0;i < titleArray.count;i++)
    {
        NSString *str1 = [NSString stringWithFormat:@"%@",[titleArray objectAtIndex:i]];
        NSString *str2 = [NSString string];
        if([[titleArray objectAtIndex:i] isEqualToString:@"早餐"])
        {
            int breakFast = [listModel.Rp_Breakfast intValue];
            switch (breakFast) {
                case 0:
                    str2 = [NSString stringWithFormat:@"%@ 无早",listModel.Rp_Description];
                    break;
                case 1:
                    str2 = [NSString stringWithFormat:@"%@ 单早",listModel.Rp_Description];
                    break;
                case 2:
                    str2 = [NSString stringWithFormat:@"%@ 双早",listModel.Rp_Description];
                    break;
                case 3:
                    str2 = [NSString stringWithFormat:@"%@ 三早",listModel.Rp_Description];
                    break;
                case 4:
                    str2 = [NSString stringWithFormat:@"%@ 四早",listModel.Rp_Description];
                    break;
                case 100:
                    str2 = [NSString stringWithFormat:@"%@ 含早",listModel.Rp_Description];
                    break;
                default:
                    str2 = [NSString stringWithFormat:@"%@ 无早",listModel.Rp_Description];
                    break;
            }
        }
        else if([[titleArray objectAtIndex:i] isEqualToString:@"面积"])
        {
            str2 = [NSString stringWithFormat:@"%@m²",listModel.Room_Size];
        }
        else if([[titleArray objectAtIndex:i] isEqualToString:@"可住"])
        {
            str2 = [NSString stringWithFormat:@"%@人",listModel.Room_StandardOccupancy];
        }

        else if([[titleArray objectAtIndex:i] isEqualToString:@"床型"])
        {
            str2 = listModel.Room_BedName;
        }

        else if([[titleArray objectAtIndex:i] isEqualToString:@"楼层"])
        {
            str2 = [NSString stringWithFormat:@"%@层",listModel.Room_Floor];
        }

        else if([[titleArray objectAtIndex:i] isEqualToString:@"无烟"])
        {
            str2 = [listModel.Room_NonSmoking intValue]==0?@"是":@"否";
        }
        else if([[titleArray objectAtIndex:i] isEqualToString:@"宽带"])
        {
            str2 = listModel.RoomNetWorkChange;
        }
        else if([[titleArray objectAtIndex:i] isEqualToString:@"到店现付"])
        {
            int payType = [listModel.Rp_Type intValue];
            switch (payType) {
                case 14:
                    str1 = @"到店现付";
                    break;
                case 16:
                    str1 = @"到店现付";
                    break;
                case 501:
                    str1 = @"预付";
                    break;
                case 502:
                    str1 = @"预付";
                    break;
                case 805:
                    str1 = @"到店现付";
                    break;
                case 806:
                    str1 = @"预付";
                    break;
                default:
                    str1 = @"到店现付";
                    break;
            }
            str2 = @"";
        }
        else if([[titleArray objectAtIndex:i] isEqualToString:@"不可取消"])
        {
            if([listModel.Rp_ChancelStatus intValue] == 2)
            {
                //"Rp_ChancelStatus": 1,//取消状态 0不可取消  1免费取消 2限时取消
                //显示规则：  限时取消(”checkinDate + 取消规则中的开始时间 “+ 之前取消 )
                //下一版改
        
                str1 = @"限时取消";
                str2 = @"";
               /* if([listModel.Rp_ChancelDecription containsString:@" "])
                {
                    str2 = [NSString stringWithFormat:@"%@ %@之前取消",_checkInDate,[[[[listModel.Rp_ChancelDecription componentsSeparatedByString:@" "] objectAtIndex:1] componentsSeparatedByString:@"-"] objectAtIndex:0]];
                }else
                {
                    str2 = [NSString stringWithFormat:@"%@ %@之前取消",_checkInDate,[[[[listModel.Rp_ChancelDecription componentsSeparatedByString:@"天"] objectAtIndex:1] componentsSeparatedByString:@"前"] objectAtIndex:0]];
                }*/
            }
            else
            {
                str1 = @"不可取消";
                //str1 = [[listModel.Rp_ChancelDecription componentsSeparatedByString:@"（"]firstObject];
                str2 = @"";
            };
        }
        NSString *allString = [NSString stringWithFormat:@"%@    %@",str1,str2];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allString];
        [str addAttribute:NSFontAttributeName value:kContentFont range:NSMakeRange(0,[allString length])];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,[str1 length])];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange([str1 length],[str2 length])];
        [self.section1Array addObject:str];
    }
    for(BeHotelDetailRoomAmenity *amemityModel in listModel.RoomAmenities)
    {
        NSString *str1 = amemityModel.RA_Type;
        NSString *str2 = amemityModel.RA_Description;
        NSString *allString = [NSString stringWithFormat:@"%@    %@",str1,str2];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allString];
        [str addAttribute:NSFontAttributeName value:kContentFont range:NSMakeRange(0,[allString length])];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,[str1 length])];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange([str1 length],[str2 length])];
        [self.section2Array addObject:str];
    }
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
- (void)hideDetailView
{
    self.backgroundColor = [UIColor clearColor];
    [self removeFromSuperview];
}
- (CGFloat)getHeightWith:(NSString *)text
{
    CGRect sumRect = [text boundingRectWithSize:CGSizeMake(kScreenWidth - 15 - 20 - 20, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:kContentFont} context:nil];
    return sumRect.size.height;
}
@end
