//
//  SystemConfig.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/12.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _IFFIRST_TIME_LOGIN_        @"iffirsttimelogin"
#define _UUID_STRING_               @"uuidstring"
#define _LOCATION_LATITUDE_         @"latitude"
#define _LOCATION_LONGTITUDE_       @"longtitude"
#define _USER_NAME_                 @"username"
#define _USER_PASSWORD_             @"userpassword"
#define _USER_STATUS_               @"userstatus"
#define _SESSION_ID_                @"sessionid"
#define _USER_LOGINTIME_            @"logintime"
#define _SERVICE_NUMBER_            @"t"
#define _SLEEP_TIME_                @"m"
#define _ONLINE_STATUS_             @"s"
#define _POSITION_OFFSET_PERIOD_    @"pot"
#define _SESSIOIN_TIMEOUT_          @"sessiontimeout"
#define _DISTANCE_TO_STARTADDRESS_  @"distanceToStartAddress"
#define _WAITING_ORDER_LIST_        @"waitingOrderList"
#define _INSTORE_ORDER_LIST_        @"instoreOrderList"
#define _RUNNING_ORDER_LIST_        @"runningOrderList"
#define _IFFIRST_TIME_GETlIST_      @"iffirstTimeGetWaitingOrderList"
#define _IFFIRTT_TIME_GET_STORELIST @"iffirstTimeGetInStoreOrderList"
#define _WAIT_ORDER_FROM_RUNNING_   @"waitingOrderFromRunning"
#define _NOTICE_INFO_               @"noticeInfo"
#define _DEVICE_TOKEN_              @"devicetoken"
#define _ASSIGN_ORDER_              @"assignorder"
#define _DELIVER_TYPE_              @"deliverType"
#define _IFHAVEAWARD_               @"ifhaveaward"
#define _AMATEUR_GAME_RIGHT_        @"ifamateurhavegameright"
#define _HISTORY_ADDRESS_           @"historyAddress"
#define _HISTORY_SHOP_ADDRESS       @"historyshopaddress"
#define _SHOP_INFO_                 @"shopinformation"
#define _MAIN_SHOP_INFO_            @"mainshopinfomation"
#define _IF_HAS_ORDER_              @"ifhasorderNo"


@interface SystemConfig : NSObject
{
    //储存在本地的数据
   // NSMutableDictionary* systemConfig;
}


@property (nonatomic,strong)NSMutableDictionary *systemConfig;


+(SystemConfig *)shareSystemConfig;


//是否第一次登陆
-(void)saveIfFirstTimeComein:(NSString *)iffirst;
-(NSString *)getIfFirstTimeComein;

//设置手机UUID
-(void)saveUUID:(NSString *)uuidString;
-(NSString *)getUUIDString;

//定位经纬度
//维度
-(void)saveUserLocationLatitude:(NSString *)latitude;
-(NSString *)getUserLocationLatitude;
//经度
-(void)saveUserLocationLongtitude:(NSString *)longtitude;
-(NSString *)getUserLocationLongtitude;

//用户名
-(void)saveUserName:(NSString *)userName;
-(NSString *)getUserName;
//用户密码
-(void)saveUserPassword:(NSString *)userPassword;
-(NSString *)getUserPassword;

//记录登陆状态
-(void)saveUserStatus:(NSString *)userStatus;
-(NSString *)getUserStatus;

//sesstionID
-(void)saveSesstionID:(NSString *)sessionid;
-(NSString *)getSessionId;

//登陆时间
-(void)saveLoginTime:(NSString *)loginTime;
-(NSString *)getLoginTime;

//客服电话
-(void)saveServiceNumber:(NSString *)serviceNum;
-(NSString *)getServiceNumber;

//sleepTime
-(void)saveSleepTime:(NSString *)sleepTime;
-(NSString *)getSleepTime;
//on line status
-(void)saveOnlineStatus:(NSString *)onlineStatus;
-(NSString *)getOnlineStatus;
//poistionOffsetPeriod
-(void)savePositionOffsetPeriod:(NSString *)positionoffsetperiod;
-(NSString *)getPositionOffsetPeriod;
//sessiontimeout
-(void)saveSessionTimeOut:(NSString *)sessiontimeout;
-(NSString *)getSessionTimeout;

//配送距离
-(void)saveDistanceToStartAddress:(NSString *)distanceToStartAddress;
-(NSString *)getDistanceToStartAddress;


//是否是第一次获取待接订单的信息
-(void)saveIFFirstTimeGetWaitingOrderList:(NSString *)ifFirstGetList;
-(NSString *)getIfFirstGetWaitingOrderList;
//是否第一次获取驻店订单信息
-(void)saveIFFirstTimeGetInStoreOrderList:(NSString *)ifFirstGetList;
-(NSString *)getIfFirstGetInStoreOrderList;

//本地待接订单数据
-(void)saveWaitingOrderList:(NSArray *)waitingOrderList;
-(NSArray *)getWaitingOrderList;
//本地待解驻点订单数据
-(void)saveInStoreOrderList:(NSArray *)inStoreOrderList;
-(NSArray *)getInStoreOrderList;

//进行中订单数据
-(void)saveRunningOrderList:(NSArray *)runningOrderList;
-(NSArray *)getRunningOrder;

//从进行中订单获得的本地待接单数据
-(void)saveWaitingOrderlistFromRunningData:(NSMutableArray *)waitingOrderList;
-(NSMutableArray *)getWaitingOrderListFromRunningData;

//保存推送消息
-(void)saveNoticeInfo:(NSArray *)noticeInfo;
-(NSArray *)getNoticeInfo;

//保存deviceToken
-(void)saveDeviceToken:(NSString *)deviceToken;
-(NSString *)getDeviceToken;

//保存指派订单
-(void)saveAssignOrder:(NSDictionary *)assignOrder;
-(NSDictionary *)getAssignOrder;

//快递员类型
-(void)saveDeliverType:(NSString *)deliverType;
-(NSString *)getDeliverType;

//是否有抽奖订单
-(void)saveIfHasAwardOrder:(NSString *)haveAward;
-(NSString *)getIfHasAwardOrder;

//众包是否有抽奖活动
-(void)saveIfAmateurToGame:(NSString *)haveRight;
-(NSString *)getIFAmateurGameRight;

//历史地址记录
-(void)saveHistoryAddress:(NSArray *)addressArray;
-(NSArray *)getHistoryAddressArray;

//历史店家记录
-(void)saveHistoryShopAddress:(NSArray *)shopAddressArray;
-(NSArray *)getHistoryShopAddressArray;

//店家信息本地缓存
-(void)saveShopInfo:(NSArray *)shopInfo;
-(NSArray *)getShopInfo;
//是否加入订单编号功能
-(void)saveIfHasOrderNo:(NSString *)ifhasOrder;
- (NSString *)getIFHasOrderNo;
//快递员店家
-(void)saveMainShopInfo:(NSDictionary *)mainShopInfo;
-(NSDictionary *)getMainShopInfo;
//清除所有
-(void)clearSystemConfigData;
//验证身份证号
- (BOOL)validateIDCardNumber:(NSString *)value;

@end
