//
//  MsgListCell.m
//  sbh
//
//  Created by RobinLiu on 15/1/29.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "MsgListCell.h"
#import "ColorConfigure.h"
#import "FontConfigure.h"
#import "DateFormatterConfig.h"
#import "CommonDefine.h"

#define kDotViewSpace 10.0f
#define kLabelSpace 10.f
#define kLabelHeight 15.0f
#define kRightDeleteWidth 50.0f
#define kMsgListCellUnreadImage @"msglist_cell_unread"
#define kMsgListCellReadedImage @"msglist_cell_readed"

@interface MsgListCell()
{
    UIImageView *_redDot;
    UILabel *_titleLabel;
    UILabel *_contentLabel;
    UILabel *_createTimeLabel;
    CGFloat originX;
    BOOL _buttonIsShow;
    UIImageView *_headerLine;
    UIImageView *_footerLine;
    UIImageView *_msgIndicator;
}
@end

@implementation MsgListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initSubviews];
        _height = 0.0f;
    }
    return self;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (void)initSubviews
{
    //左侧显示未读红色的小红点
    _headerLine = [[UIImageView alloc]init];
    _headerLine.backgroundColor = [ColorConfigure cellContentColor];
    //[self addSubview:_headerLine];
    _footerLine = [[UIImageView alloc]init];
    _footerLine.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1];
   // [self addSubview:_footerLine];
    _redDot = [[UIImageView alloc]init];
    _redDot.image = [UIImage imageNamed:kMsgListCellUnreadImage];
    _redDot.x = 13;
    _redDot.y = 11;
    [self addSubview:_redDot];
    
    //标题
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = [ColorConfigure cellTitleColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [FontConfigure cellTitleFont];
    [self addSubview:_titleLabel];
    
    //内容
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.textColor = [ColorConfigure cellContentColor];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [FontConfigure cellContentFont];
    [self addSubview:_contentLabel];
    
    _createTimeLabel = [[UILabel alloc]init];
    _createTimeLabel.textColor = [ColorConfigure cellTimeColor];
    _createTimeLabel.textAlignment = NSTextAlignmentRight;
    _createTimeLabel.font = [FontConfigure cellContentFont];
    [self addSubview:_createTimeLabel];
    
    _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectButton setImage:[UIImage imageNamed:@"ddtx_baoxian"] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamed:@"ddtx_baoxian2"] forState:UIControlStateSelected];
    [_selectButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _selectButton.frame = CGRectMake(kDotViewSpace, kDotViewSpace, 10, 10);
    [self addSubview:_selectButton];
    
    _msgIndicator = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xiaoxi_right"]];
    [self addSubview:_msgIndicator];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    if([super isEditing])
    {
        
    }
    if(![super isEditing])
    {
        
    }
}
- (void)setIsShowButton:(BOOL)isShowButton
{
    _buttonIsShow = isShowButton;
}
- (void)setListModel:(MessageListModel *)listModel
{
    originX = _buttonIsShow==YES?33.0f:33.0f;
    if(_buttonIsShow == NO)
    {
        _redDot.hidden = NO ;
        if(listModel.isShowed)
        {
            _redDot.image = [UIImage imageNamed:kMsgListCellReadedImage];
            _redDot.width = [UIImage imageNamed:kMsgListCellReadedImage].size.width/2;
            _redDot.height = [UIImage imageNamed:kMsgListCellReadedImage].size.height/2;
        }
        else
        {
            _redDot.image = [UIImage imageNamed:kMsgListCellUnreadImage];
            _redDot.width = [UIImage imageNamed:kMsgListCellUnreadImage].size.width/2;
            _redDot.height = [UIImage imageNamed:kMsgListCellUnreadImage].size.height/2;
        }
    }
    else
    {
        _redDot.hidden = YES;
    }
    _selectButton.hidden = !_buttonIsShow;
    // _redDot.frame = CGRectMake(kDotViewSpace-2, kDotViewSpace+3, kDotViewSpace/2.0+2, kDotViewSpace/2.0+2);
    
    _titleLabel.text = listModel.msgTitle;
    _titleLabel.frame = CGRectMake(originX, kLabelSpace, kScreenWidth, kLabelHeight);
    
    CGSize contentSize = [listModel.msgContent boundingRectWithSize:CGSizeMake(kScreenWidth - originX-kRightDeleteWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[FontConfigure cellContentFont]} context:nil].size;
    _contentLabel.text = listModel.msgContent;
    _contentLabel.frame = CGRectMake(originX, CGRectGetMaxY(_titleLabel.frame) +kLabelSpace, contentSize.width, contentSize.height);
    _createTimeLabel.text = [DateFormatterConfig dateStringFromDateString:listModel.createTime];
    _createTimeLabel.frame = CGRectMake(0, kLabelSpace, kScreenWidth-9-15, kLabelHeight);
    _msgIndicator.frame = CGRectMake(kScreenWidth-9-9, kLabelSpace+3, 6.5, 9);
    
    _height = CGRectGetMaxY(_contentLabel.frame) + kLabelSpace;
    _footerLine.frame = CGRectMake(0, _height-1, kScreenWidth, 1);
    if(_buttonIsShow)
    {
        _selectButton.frame = CGRectMake(kDotViewSpace, kDotViewSpace, 20, 20);
    }
    _selectButton.selected = listModel.isSelectButton;
}

- (void)buttonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if(sender.selected)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(cellDidSelect:)])
        {
            [self.delegate cellDidSelect:self];
        }
    }
    if(!sender.selected)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(cellDidDeselect:)])
        {
            [self.delegate cellDidDeselect:self];
        }
    }
}
- (void)setIsSelect:(BOOL)isSelect
{
    _selectButton.selected = isSelect;
}
@end
