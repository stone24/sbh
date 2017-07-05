//
//  BeTicketPriceCoverView.m
//  sbh
//
//  Created by RobinLiu on 16/3/14.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import "BeTicketPriceCoverView.h"
#import "ColorUtility.h"
#import "ColorConfigure.h"

@interface BeTicketPriceCoverView()
{
    UILabel *nameLabel;
    UILabel *descriptionLabel;
    UILabel *priceLabel;
    UIImageView *typeImageView;

    UIView *bgView;
    BeTicketPriceCoverViewBlock _block;
    UIButton *bookButton;
    UILabel *contentLabel;
}
@end
@implementation BeTicketPriceCoverView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
+ (BeTicketPriceCoverView *)sharedInstance
{
    static BeTicketPriceCoverView *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!_instance)
        {
            _instance = [[BeTicketPriceCoverView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
        }
    });
    return _instance;
}
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
        bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 10 + 64, kScreenWidth - 20, kScreenHeight - 10 - 64 -20)];
        bgView.layer.cornerRadius = 4.0f;
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.8;
        [self addSubview:bgView];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(bgView.width - 50, 5, 50, 50);
        [cancelButton setImage:[UIImage imageNamed:@"gdjg_tgq_guanbiIcon"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:cancelButton];
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 120, 16)];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.text = @"2016-04-26 星期二";
        nameLabel.font = [UIFont systemFontOfSize:16];
        [bgView addSubview:nameLabel];
        
        priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(bgView.width - 150, 18, 100, 26)];
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.textColor = [ColorConfigure loginButtonColor];
        priceLabel.font = [UIFont systemFontOfSize:25];
        [bgView addSubview:priceLabel];
        
        typeImageView = [[UIImageView alloc]initWithFrame: CGRectMake(CGRectGetMaxX(nameLabel.frame), nameLabel.y, 34, 13)];
        [bgView addSubview:typeImageView];
        
        descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 46, 110, 11)];
        descriptionLabel.textColor = [UIColor whiteColor];
        descriptionLabel.text = @"2016-04-26 星期二";
        descriptionLabel.font = [UIFont systemFontOfSize:11];
        [bgView addSubview:descriptionLabel];
        
        bookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        bookButton.frame = CGRectMake(10, bgView.height - 45, bgView.width - 20, 40);
        [bookButton setTitle:@"立即预定" forState:UIControlStateNormal];
        bookButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [bookButton setBackgroundColor:[ColorConfigure loginButtonColor]];
        bookButton.layer.cornerRadius = 4.0f;
        [bookButton addTarget:self action:@selector(bookClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:bookButton];
        
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 90,bgView.width - 20, 10)];
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.text = @"更改条件：";
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont systemFontOfSize:11];
        [bgView addSubview:contentLabel];
    }
    return self;
}
- (void)bookClick
{
    _block();
    [self cancelAction];
}
- (void)cancelAction
{
    [self removeFromSuperview];
}
- (void)showViewWithDict:(NSDictionary *)dict andModel:(BeTicketQueryResultModel *)model andIsShowBookButton:(BOOL)isShow andBlock:(BeTicketPriceCoverViewBlock)block
{
    _block = block;
    bookButton.hidden = !isShow;
    [[[UIApplication sharedApplication]keyWindow]addSubview:self];
    [UIView animateWithDuration:0.25f animations:^
     {
         NSString *priceTitleString = [NSString stringWithFormat:@"%@%@",[dict objectForKey:@"Rebate"],[dict objectForKey:@"ClassCodeType"]];
         NSDictionary * attributes = @{NSFontAttributeName :nameLabel.font};
         CGRect dest = [priceTitleString boundingRectWithSize:CGSizeMake(MAXFLOAT, nameLabel.height) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
         nameLabel.text = priceTitleString;
         nameLabel.width = dest.size.width;
         
         NSString *desString = [NSString stringWithFormat:@"机建￥%@ / 燃油￥%@",model.AirportTaxa,model.FuelsurTaxa];
         NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString:desString];
         [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange(2, model.AirportTaxa.length + 1)];
         [attrib addAttribute:NSForegroundColorAttributeName value:SBHYellowColor range:NSMakeRange(2+model.AirportTaxa.length + 1+5, model.FuelsurTaxa.length + 1)];
         descriptionLabel.attributedText = attrib;
         
         NSArray *array1 = [[dict objectForKey:@"price"]componentsSeparatedByString:@"|"];
         NSString *isource1 = nil;
         isource1 = [array1 objectAtIndex:1];
         TicketPriceType type = [isource1 intValue];
         NSString *imageName = [[NSString alloc]init];
         if(type == TicketTravelPriceType)
         {
             imageName = @"gdjg_shanglvjiaIcon";
         }
         else if(type == TicketSharePriceType)
         {
             imageName = @"gdjg_hongxiangjiaIcon";
         }
         else if(type == TicketOfficialWebsitePriceType)
         {
             imageName = @"train_officialWebsitePrice_image";
         }
         else if(type == TicketLargeCustomerPriceType)
         {
             imageName = @"train_ agreementPrice_image";
         }
         else
         {
             imageName = @"train_ agreementPrice_image";
         }
         UIImage *priceImage = [UIImage imageNamed:imageName];
         typeImageView.size = CGSizeMake(0, 0);
         typeImageView.image = priceImage;
         typeImageView.size = priceImage.size;
         typeImageView.x = CGRectGetMaxX(nameLabel.frame) + 5;
         NSString *priceString = [NSString stringWithFormat:@"%@",[array1 objectAtIndex:0]];
         NSString *markString = @"￥";
         NSMutableAttributedString *priceAttrib = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",markString,priceString]];
         [priceAttrib addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, markString.length)];
         [priceAttrib addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(markString.length, priceString.length)];
         priceLabel.attributedText = priceAttrib;
         

         NSString *contentString = [NSString stringWithFormat:@"退改签规则\n\n\n更改条件：\n\n%@\n\n退票条件：\n\n%@\n\n签转条件：\n\n%@\n\n舱位：\n\n%@",[dict objectForKey:@"Endorsement"],[dict objectForKey:@"EI"],[dict objectForKey:@"Refund"],[dict objectForKey:@"Code"]];
         if(type == TicketOfficialWebsitePriceType)
         {
             contentString = [contentString stringByAppendingString:@"\n\n备注：\n\n如改期后发生退票需退到乘机人卡里"];
         }
         contentLabel.text = contentString;
         CGRect contentRect = [contentLabel.text boundingRectWithSize:CGSizeMake(contentLabel.width, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:contentLabel.font} context:nil];
         contentLabel.height = contentRect.size.height;
     }completion:^(BOOL finished)
     {
     }];
}
@end
