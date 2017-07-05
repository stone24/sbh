//
//  quanbudingdanTableViewCell.m
//  SBHAPP
//
//  Created by musmile on 14-7-2.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "quanbudingdanTableViewCell.h"
#import "BeTrainOrderListModel.h"

@implementation quanbudingdanTableViewCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)shenpiBtn:(id)sender {
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"quanbudingdanTableViewCell";
    quanbudingdanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"quanbudingdanTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)setTrainM:(BeTrainOrderListModel *)trainM
{
    _trainM = trainM;
    self.hangbanriqi.text = trainM.departdate;
    self.typeIcon.image = [UIImage imageNamed:@"ddlb_jiantouIcon"];
    self.xingming.text = trainM.psgname;
    self.comeCity.text = trainM.boardpointline;
    self.reachCity.text = trainM.offpointline;
    self.jine.text = [NSString stringWithFormat:@"￥%@", trainM.accountreceivable];
    self.titleIcon.image = [UIImage imageNamed:@"trainOrder_icon"];
    /*
     <asp:ListItem Value="YQX">已取消</asp:ListItem>      已取消
     <asp:ListItem Value="YDZ">已订座</asp:ListItem>      待支付
     <asp:ListItem Value="DCP">待出票</asp:ListItem>      待出票
     <asp:ListItem Value="CPZ">出票中</asp:ListItem>      待出票
     <asp:ListItem Value="YCP">已出票</asp:ListItem>      已出票
     <asp:ListItem Value="GSQ">改签已申请</asp:ListItem>
     <asp:ListItem Value="GSL">改签已受理</asp:ListItem>
     <asp:ListItem Value="YGQ">已改签</asp:ListItem>
     <asp:ListItem Value="TSQ">退票已申请</asp:ListItem>  退票中
     <asp:ListItem Value="TSL">退票已受理</asp:ListItem>  退票中
     <asp:ListItem Value="TPZ">退票中</asp:ListItem>      退票中
     <asp:ListItem Value="YTP">已退票</asp:ListItem>      已退票
     <asp:ListItem Value="WSY">未使用</asp:ListItem>
     <asp:ListItem Value="YSY">已使用</asp:ListItem>
     <asp:ListItem Value="DSQ">待申请</asp:ListItem>
     默认值：   处理中
     */
    
    /*
     ID	TypeName	ValueCode	Description	ItemIndex	IsValid	TypeDisplay	ProductCode
     1	PlaneMode	W	大飞机	0	Y	大飞机	NULL
     2	PlaneMode	N	小飞机	1	Y	小飞机	NULL
     3	ProductCategory	TP	机票产品	0	Y	机票	NULL
     4	ProductCategory	HP	酒店产品	1	y	酒店	NULL
     5	BusinessCategory	RS	预定业务	0	Y	预定	NULL
     6	BusinessCategory	PS	支付业务	1	Y	支付	NULL
     7	BusinessCategory	TCS	出票后确认	2	Y	出票后确认	NULL
     8	PlaneMode	M	中飞机	2	Y	中飞机	NULL
     
     9	OrderStatus	DQR	待确认	0	Y	待确认	F
     10	OrderStatus	YQX	已取消	1	Y	已取消	F,T
     11	OrderStatus	YDZ	已订座	2	Y	已订座	F
     12	OrderStatus	DCP	待出票	3	Y	待出票	F,T
     13	OrderStatus	CPZ	出票中	4	Y	出票中	F
     14	OrderStatus	YCP	已出票	5	Y	已出票	F,T
     15	OrderStatus	GSQ	改签已申请	6	Y	改签申请	F
     16	OrderStatus	GSL	改签已受理	7	Y	改签受理	F
     17	OrderStatus	YGQ	已改签	8	Y	已改签	F,T
     18	OrderStatus	TSQ	退票已申请	9	Y	退票申请	F,T
     19	OrderStatus	TSL	退票已受理	10	Y	退票受理	F
     20	OrderStatus	YTP	已退票	11	Y	已退票	F,T
     21	PaymentStatus	WZF	未支付	0	Y	未支付	NULL
     22	PaymentStatus	YZF	已支付	1	Y	已支付	NULL
     23	PaymentStatus	DTK	待退款	2	Y	待退款	NULL
     24	PaymentStatus	YTK	已退款	3	Y	已退款	NULL
     25	BusinessCategory	GQS	改签后确认	3	Y	改签后确认	NULL
     26	ProductCategory	TTP	火车票产品	2	Y	火车票	NULL
     27	OrderStatus	DZF	待支付	12	Y	待支付	NULL
     28	OrderStatus	GZF	改签待支付	13	Y	改签待支付	NULL
     29	OrderStatus	GCP	改签待出票	14	Y	改签待出票	NULL
     30	OrderStatus	GSH	改签待审核	12	Y	改签待审核	F
     31	OrderStatus	TSH	退票待审核	13	Y	退票待审核	F
     32	OrderStatus	TPZ	退票中	15	Y	退票中	F
     33	OrderStatus	YTJ	已提交	16	Y	已提交	T
     34	OrderStatus	GTG	改签审核通过	17	Y	改签审核通过	F,T
     35	OrderStatus	TTG	退票审核通过	18	Y	退票审核通过	F,T
     36	OrderStatus	TBH	退票审核驳回	19	Y	退票审核驳回	F,T
     37	OrderStatus	GBH	改签审核驳回	20	Y	改签审核驳回	F,T
     38	OrderStatus	CTG	出票审核通过	21	Y	出票审核通过	F,T
     39	OrderStatus	CBH	出票审核驳回	22	Y	出票审核驳回	F,T
     40	OrderStatus	CCL	出票审核通过处理	23	Y	出票审核通过处理	F,T
     41	OrderStatus	ZZZ	占座中	24	Y	占座中	T
     */
     if([trainM.orderst isEqualToString:@"YQX"]||[[trainM.dict stringValueForKey:@"IsCancel" defaultValue:@"N"]isEqualToString:@"Y"])
     {
         [self.zhuangtai1 setTextColor:[UIColor lightGrayColor]];
         self.zhuangtai1.text = @"已取消";
     }
     else if([trainM.orderst isEqualToString:@"YDZ"]&&[[trainM.dict stringValueForKey:@"AppPayCode" defaultValue:@"0"]isEqualToString:@"1"])
     {
         [self.zhuangtai1 setTextColor:[UIColor orangeColor]];
         self.zhuangtai1.text = @"待支付";
     }
     else if([trainM.orderst isEqualToString:@"YCP"])
     {
         [self.zhuangtai1 setTextColor:SBHYellowColor];
         self.zhuangtai1.text = @"已出票";
     }
     else if([trainM.orderst isEqualToString:@"YTJ"])
     {
         [self.zhuangtai1 setTextColor:kBlueColor];
         self.zhuangtai1.text = @"已提交";
     }
     else if ([trainM.orderst isEqualToString:@"YTP"])
     {
         [self.zhuangtai1 setTextColor:kBlueColor];
         self.zhuangtai1.text = @"已退票";
     }
     else if ([trainM.orderst isEqualToString:@"TPZ"]||[trainM.orderst isEqualToString:@"TSQ"]||[trainM.orderst isEqualToString:@"TSL"])
     {
         [self.zhuangtai1 setTextColor:[UIColor lightGrayColor]];
         self.zhuangtai1.text = @"退票中";
     }
     else
     {
         [self.zhuangtai1 setTextColor:SBHYellowColor];
         self.zhuangtai1.text = @"待出票";
     }
    self.payStats.hidden = YES;
}
@end
