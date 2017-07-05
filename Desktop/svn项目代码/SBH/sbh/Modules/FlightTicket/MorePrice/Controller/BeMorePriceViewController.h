//
//  yudingJIPIAOViewController.h
//  SBHAPP
//
//  Created by musmile on 14-7-2.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "BeTicketPriceBaseViewController.h"
#import "BeTicketQueryResultModel.h"
#import "BeTicketPriceRuleModel.h"

@interface BeMorePriceViewController : BeTicketPriceBaseViewController
@property (nonatomic,strong)BeTicketQueryResultModel *airportModel;
-(id)init:(NSString *)str;
@end
