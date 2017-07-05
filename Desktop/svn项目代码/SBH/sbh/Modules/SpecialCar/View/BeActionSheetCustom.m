//
//  BeActionSheetCustom.m
//  sbh
//
//  Created by SBH on 15/7/21.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeActionSheetCustom.h"
#import "gongsilianxirenTableViewCell.h"

#define kSelectImage @"cell_single_selection"
#define kUnselectImage @"cell_unselect"
#define kCellHight 38
#define kAnimateDuration 0.3

@interface BeActionSheetCustom () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *listArray;

@end

@implementation BeActionSheetCustom

- (NSArray *)listArray
{
    if (_listArray == nil) {
        _listArray = [NSArray array];
    }
    return _listArray;
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        UITableView *tableView = [[UITableView alloc] init];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollEnabled = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
        self.tableView = tableView;
    }
    return self;
}

- (void)close
{

    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.tableView.transform = CGAffineTransformIdentity;
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (id)initWithTitle:(NSArray *)titleArray
{
    if(self = [super init])
    {
        self.listArray = titleArray;
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//        self.height - titleArray.count*kCellHight
        self.tableView.frame = CGRectMake(0, self.height, self.width, titleArray.count*kCellHight);
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"gongsilianxirenTableViewCell";
    gongsilianxirenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"gongsilianxirenTableViewCell" owner:nil options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    [cell.rotDel00Btn setImage:[UIImage imageNamed:kUnselectImage] forState:UIControlStateNormal];
    [cell.rotDel00Btn setImage:[UIImage imageNamed:kSelectImage] forState:UIControlStateSelected];
    cell.rotDel00Btn.userInteractionEnabled = NO;
    if (indexPath.row == self.indexInt) {
        cell.rotDel00Btn.selected = YES;
    }
    cell.name.font = [UIFont systemFontOfSize:15];
    cell.name.text = [self.listArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexInt = (int)indexPath.row;
    [self.tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.actionSheetCustomClickBlock(self.indexInt); 
        [self close];
    });
}

- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    self.alpha = 0.0;
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.alpha = 1.0;
        self.tableView.transform = CGAffineTransformTranslate(self.tableView.transform, 0, - self.tableView.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self close];
}
@end
