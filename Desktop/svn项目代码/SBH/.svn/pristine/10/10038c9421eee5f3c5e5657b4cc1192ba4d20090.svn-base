//
//  BeOrdeSearchHeaderView.h
//  sbh
//
//  Created by RobinLiu on 16/7/7.
//  Copyright © 2016年 shenbianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBeOrdeSearchHeaderViewHeight 50.0f
@protocol SearchViewCancelClick <NSObject>
- (void)searchViewCancelButtonClick;
@end
@interface BeOrdeSearchHeaderView : UIView
@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)UIButton *cancelButton;

@property (nonatomic,assign)id<SearchViewCancelClick>delegate;
@end
