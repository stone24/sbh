//
//  ServerConfigure.h
//  sbh
//
//  Created by RobinLiu on 2017/6/29.
//  Copyright © 2017年 shenbianhui. All rights reserved.
//

#ifndef ServerConfigure_h
#define ServerConfigure_h

#ifdef DEBUG
/*
#define kServerHost             @"http://newapp1.shenbianhui.cn/"
#define kTrainHost              @"http://apptrain1.shenbianhui.cn/"
#define kHotelImageUrlHost      @"http://serviceimg.shenbianhui.cn/"
#define kOnlineCheckInHost      @"http://checkin.shenbianhui.cn/"
#define kPayCenterUrl           @"http://paycenter.shenbianhui.cn/alipay/PayForm.aspx"
//#define kSpeRequestUrl          @"http://cmpcarapi.shenbianhui.cn/"  // 用车
#define kSpeRequestUrl          @"http://carapi.shenbianhui.cn/"  // 用车
*/
 #define kServerHost             @"http://192.168.10.27:8082/"
 #define kTrainHost              @"http://192.168.10.27:8141/"
 #define kHotelImageUrlHost     @"http://192.168.10.27:811/"
 #define kOnlineCheckInHost     @"http://checkin.shenbianhui.cn/"
 #define kPayCenterUrl          @"http://sim.paycenter.shenbianhui.cn/alipay/PayForm.aspx"
 #define kSpeRequestUrl         @"http://192.168.10.27:8999/"  // 用车

#else
#define kServerHost             @"http://newapp1.shenbianhui.cn/"
#define kTrainHost              @"http://apptrain1.shenbianhui.cn/"
#define kHotelImageUrlHost      @"http://serviceimg.shenbianhui.cn/"
#define kOnlineCheckInHost      @"http://checkin.shenbianhui.cn/"
#define kPayCenterUrl           @"http://paycenter.shenbianhui.cn/alipay/PayForm.aspx"
#define kSpeRequestUrl          @"http://carapi.shenbianhui.cn/"  // 用车

#endif

//消息
#define GetMessageListUrl      @"Message/MessageList"
#define DeleteMessageUrl       @"Message/MessageDel"
#define GetUnreadMsgCountUrl   @"/Message/MessageCount"

//首页
#define HomeGetBannerUrl       @"Passport/images"
// 邮寄
#define kHomePostUrl           @"http://jcfw.shenbianhui.cn/mailitem/wpyjpage"
//登录注册
#define kVIPUserLoginUrl       @"Passport/SignIn"
#define kVIPUserModifyPsdUrl   @"Passport/SignUp"
#define kNormalUserLoginUrl    @"Passport/SignIn"
#define kNormalUserRegisterUrl @"Passport/RegUser"
#define kNormalUserModifyPsdUrl @"Passport/GetPwd"
#define kNormalUserRegCodeUrl  @"Passport/RegCode"
#define kUserLogOffUrl         @"Passport/SignOut"
#define kResetPasswordUrl      @"Passport/SignUp"

//查询订单(代办登机牌)
#define kCheckOrderListUrl     @"Order/OrderList"
//一键办理
#define kCheckInUrl            @"http://jcfw.shenbianhui.cn/BoardingCheck/BoardingCheckPageAppFirst"

//修改个人信息
#define kUpdateUserInfoUrl     @"Passport/UpdateUserInfo"

//酒店
#define kHotelListUrl          @"HotelNew/HotelSearch"
#define kHotelDetailUrl        @"Hotel/HotelList/HotelRoomList"
#define kHotelListImageUrl     @"ImportHotelImage/"
#define kHotelDetailScrollUrl  @"Hotel/HotelList/HotelImg"
#define kHotelListImageSize    @"images.aspx?size=100,100&urls=ImportHotelImage/"
#define kHotelRoomImageSize    @"images.aspx?size=300,300&urls=ImportRoomImage/"

//机票订单
#define kAirTicketOrderListUrl  @"Order/OrderList"

//酒店订单
#define kHotelOrderListUrl     @"Hotel/HotelOrder/OrderList"
#define kHotelOrderDetailUrl   @"Hotel/HotelOrder/OrderDetail"
#define kCancelHotelOrderUrl   @"Hotel/HotelOrder/OrderCancel"
#define kHotelOrderBookingUrl   @"Hotel/HotelOrder/Orderbooking"
#define kHotelOrderSubmitUrl    @"Hotel/HotelOrder/OrderSubmit"

//隐私条款
#define kPrivacyPolicyUrl       @"http://apptest.shenbianhui.cn/ystk.html"

//机票
#define kAirFlightSearchMoreUrl @"AirFlight/SearchMore"
#define kSearchAirFlightListUrl @"AirFlight/SearchAirFlight"
#define kAirFlightSearchMoreSaas4Url @"AirFlight/SearchMore4"
#define kSearchAirFlightListSaas4Url @"AirFlight/SearchAirFlight4"
//审批
#define kAuditCountUrl         @"Audit/AuditCount"

//火车票
#define kTrainSearchUrl         @"Search/SearchList"

//应用下载页面
#define kAppDownloadUrl         @"http://itunes.apple.com/us/app/id"
#define kAppLookUpUrl           @"https://itunes.apple.com/lookup"

//租车行程
#define kCarOrderListUrl        @"ZuChe/ZCOrderList"
#define kCarOrderDetailUrl      @"ZuChe/ZCOrderInfo"

// 服务器时间
#define kServerDate             @"kServerDate"

#endif /* ServerConfigure_h */
