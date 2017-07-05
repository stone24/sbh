//
//  BeHotelDetailSectionModel.h
//  sbh
//
//  Created by RobinLiu on 15/12/10.
//  Copyright © 2015年 shenbianhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeHotelDetailRoomAmenity : NSObject
@property (nonatomic,strong)NSString *RA_Description;
@property (nonatomic,strong)NSString *RA_Type;
@end
@interface BeHotelDetailRoomListModel : NSObject
@property (nonatomic,strong)NSString *Hotel_Id;
/**
 * 价钱
 */
@property (nonatomic,strong)NSString *Dr_Amount;

/**
 * 9=可预订，非9售罄
 */
@property (nonatomic,strong)NSString *Dr_SellStatus;//" = 9;
@property (nonatomic,strong)NSString *Id;// = 6161;
@property (nonatomic,strong)NSString *RoomNetWorkChange;// = "\U514d\U8d39\U65e0\U7ebf";
@property (nonatomic,strong)NSString *Room_BedCode;//" = 3;
@property (nonatomic,strong)NSString *Room_BedName;//" = "\U5927\U5e8a";
@property (nonatomic,strong)NSString *Room_Facilities;//" = "3,5,7,12";
@property (nonatomic,strong)NSString *Room_Floor;//" = 1;
@property (nonatomic,strong)NSString *Room_Id;//" = 10000100005060001;
@property (nonatomic,strong)NSString *Room_Image;//" = "http://Images4.c-ctrip.com/target/fd/hotel/g2/M00/7B/34/Cghzf1UnWkmAbPc8ACF5m8OnTjQ576_550_412.jpg";
@property (nonatomic,strong)NSString *Room_Name;//" = "\U80e1\U540c\U5957\U623f";
@property (nonatomic,strong)NSString *Room_NonSmoking;//" = 0;
@property (nonatomic,strong)NSString *Room_Size;//" = 70;
@property (nonatomic,strong)NSString *Room_StandardOccupancy;//" = 2;
@property (nonatomic,strong)NSMutableArray *RoomAmenities;
/**
 *  case 0:
 Msg = "无早";
 break;
 case 1:
 Msg = "单早";
 break;
 case 2:
 Msg = "双早";
 break;
 case 3:
 Msg = "三早";
 break;
 case 4:
 Msg = "四早";
 break;
 case 100:
 Msg = "含早";
 */
@property (nonatomic,strong)NSString *Rp_Breakfast;//" = 2;

/**
 * 取消规则
 */
@property (nonatomic,strong)NSString *Rp_ChancelDecription;//" = "\U4e0d\U53ef\U53d6\U6d88";
@property (nonatomic,strong)NSString *Rp_ChancelStatus;//" = 0;
@property (nonatomic,strong)NSString *Rp_CreateDate;//" = "2015-11-13";
@property (nonatomic,strong)NSString *Rp_Description;//" = "\U80e1\U540c\U5957\U623f[\U542b\U65e9]";

/**
 * Rp_Guarantee 担保   0 无担保  非0是担保
 */
@property (nonatomic,strong)NSString *Rp_Guarantee;
@property (nonatomic,strong)NSString *Rp_GuaranteeForm;
@property (nonatomic,strong)NSString *Rp_Id;//" = 10001;
@property (nonatomic,strong)NSString *Rp_IsCommissionabl;//" = 0;
@property (nonatomic,strong)NSString *Rp_IsValid;//" = 1;
@property (nonatomic,strong)NSString *Rp_LastUpdateDate;//" = "2015-11-13";
@property (nonatomic,strong)NSString *Rp_MarketCode;//" = 63;
@property (nonatomic,strong)NSString *Rp_Name;//" = "\U542b\U65e9";
@property (nonatomic,strong)NSString *Rp_NetWork;//" = 0;
@property (nonatomic,strong)NSString *Rp_RateReturn;//" = 0;

/**
 * 优惠价格
 */
@property (nonatomic,strong)NSString *Dr_PromotionPrice;
/**
 * [Description("--")]
 Default = 0,
 /// <summary>
 /// 促销现付（携程）
 /// </summary>
 [Description("到店现付")]
 Promotional = 14,
 /// <summary>
 /// 标准现付（携程）
 /// </summary>
 [Description("到店现付")]
 Standard = 16,
 /// <summary>
 /// 普通预付（携程）
 /// </summary>
 [Description("预付")]
 StandardPrepay = 501,
 /// <summary>
 /// 促销预付（携程）
 /// </summary>
 [Description("预付")]
 PromotionalPrepay = 502,
 /// <summary>
 /// 自签现付
 /// </summary>
 [Description("到店现付")]
 Entering = 805,
 /// <summary>
 /// 自签预付
 /// </summary>
 [Description("预付")]
 EnteringPrepay = 806
 */
@property (nonatomic,strong)NSString *Rp_Type;//" = 16;
@property (nonatomic,strong)NSString *Source;// = Ctrip;
@property (nonatomic,strong)NSString *Source_Code;//" = 11268038;
@end
/**
 * 酒店政策
 */
@interface BeHotelRegulationModel : NSObject
@property (nonatomic,strong)NSString *Id;
@property (nonatomic,strong)NSString *Hotel_Id;//": "1000010000021",
@property (nonatomic,strong)NSString *Rul_ArrAndDep;//": "入住时间：14:00以后      离店时间：12:00以前",
@property (nonatomic,strong)NSString *Rul_Cancel;//": "不同类型的客房附带不同的取消预订和预先付费政策 选择上述客房时，请参阅“客房政策”。",
@property (nonatomic,strong)NSString *Rel_DepAndPre;//": "入住时需要出示政府核发的身份证件(带照片)。请携带信用卡和现金用以支付押金或额外费用。",
@property (nonatomic,strong)NSString *Rel_Pet;//": "根据客人要求允许携带宠物。不收取额外费用。",
@property (nonatomic,strong)NSString *Rel_Requirements;//": "信用卡授权解除需时1-3个月。视不同国家、城市之银行操作时间而定。",
@property (nonatomic,strong)NSString *Rel_CheckIn;//": "该酒店14:00办理入住，早到可能需要等待",
@property (nonatomic,strong)NSString *Rel_CheckOut;//": ""
- (id)initWithDict:(NSDictionary *)dict;
@end
@interface BeHotelDetailSectionModel : NSObject

/**
 * 是否展开
 */
@property (nonatomic,assign)BOOL isSread;

/**
 * cell数据（原始数据）
 */
@property (nonatomic,strong)NSMutableArray *cellArray;

/**
 * cell显示数据
 */
@property (nonatomic,strong)NSMutableArray *cellDisplayArray;

/**
 * 价钱
 */
@property (nonatomic,strong)NSString *Dr_Amount;

/**
 * id
 */
@property (nonatomic,strong)NSString *Id;
/**
 * 图片
 */
@property (nonatomic,strong)NSString *Room_Image;
/**
 * 名称
 */
@property (nonatomic,strong)NSString *Room_Name;
- (id)initWithDict:(NSDictionary *)dict;
@end
