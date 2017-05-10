//
//  SystemConfig.m
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/12.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import "SystemConfig.h"


static SystemConfig *temSingleInstance = nil;

@implementation SystemConfig

//@synthesize systemConfig;


#pragma mark singleton init  connectFileProperty
- (instancetype)init
{
    self = [super init];
    if (self) {
        _systemConfig = [[NSMutableDictionary alloc]initWithContentsOfFile:[self getSystemConfigFile]];
        if (!_systemConfig) {
            _systemConfig = [[NSMutableDictionary alloc]initWithCapacity:2000];
            [self saveSystemConfigData];
        }
    }
    return self;
}

+(SystemConfig *)shareSystemConfig
{
    if (!temSingleInstance) {
        temSingleInstance = [[SystemConfig alloc]init];
    }
    return temSingleInstance;
}

+(NSUserDefaults *)shareSystemDefaults
{
    return [NSUserDefaults  standardUserDefaults];
}
-(NSString *)getSystemConfigFile
{
    NSString *pathString = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/systemConfig.plist",pathString];
}
-(void)saveSystemConfigData
{
    [_systemConfig writeToFile:[self getSystemConfigFile] atomically:YES];
}

-(void)clearSystemConfigData
{
    NSFileManager *fileManager = [ NSFileManager defaultManager];
    [fileManager removeItemAtPath:[self getSystemConfigFile] error:nil];
}
#pragma mark element
//是否第一次登陆
-(void)saveIfFirstTimeComein:(NSString *)iffirst
{
    [_systemConfig setValue:iffirst forKey:_IFFIRST_TIME_LOGIN_];
    [self saveSystemConfigData];
}
-(NSString *)getIfFirstTimeComein
{
    return (NSString *)[_systemConfig valueForKey:_IFFIRST_TIME_LOGIN_];
}

//设置手机UUID
-(void)saveUUID:(NSString *)uuidString
{
    [_systemConfig setValue:uuidString forKey:_UUID_STRING_];
    [self saveSystemConfigData];
}
-(NSString *)getUUIDString
{
    return (NSString *)[_systemConfig valueForKey:_UUID_STRING_];
}
//定位经纬度
//维度
-(void)saveUserLocationLatitude:(NSString *)latitude
{
    [_systemConfig setValue:latitude forKey:_LOCATION_LATITUDE_];
    [self saveSystemConfigData];
}
-(NSString *)getUserLocationLatitude
{
    return (NSString *)[_systemConfig valueForKey:_LOCATION_LATITUDE_];
}
//经度
-(void)saveUserLocationLongtitude:(NSString *)longtitude
{
    [_systemConfig setValue:longtitude forKey:_LOCATION_LONGTITUDE_];
    [self saveSystemConfigData];
}
-(NSString *)getUserLocationLongtitude
{
    return (NSString *)[_systemConfig valueForKey:_LOCATION_LONGTITUDE_];
}
//用户名
-(void)saveUserName:(NSString *)userName
{
    [_systemConfig setValue:userName forKey:_USER_NAME_];
    [self saveSystemConfigData];
}
-(NSString *)getUserName
{
    return (NSString *)[_systemConfig valueForKey:_USER_NAME_];
}
//用户密码
-(void)saveUserPassword:(NSString *)userPassword
{
    [_systemConfig setValue:userPassword forKey:_USER_PASSWORD_];
    [self saveSystemConfigData];
}
-(NSString *)getUserPassword
{
    return  (NSString *)[_systemConfig valueForKey:_USER_PASSWORD_];
}

//记录登陆状态
-(void)saveUserStatus:(NSString *)userStatus
{
    [_systemConfig setValue:userStatus forKey:_USER_STATUS_];
    [self saveSystemConfigData];
}
-(NSString *)getUserStatus
{
    return  (NSString *)[_systemConfig valueForKey:_USER_STATUS_];
}

//sesstionID
-(void)saveSesstionID:(NSString *)sessionid
{
    [_systemConfig setValue:sessionid forKey:_SESSION_ID_];
    [self saveSystemConfigData];
}
-(NSString *)getSessionId
{
    return (NSString *)[_systemConfig valueForKey:_SESSION_ID_];
}
//登陆时间
-(void)saveLoginTime:(NSString *)loginTime
{
    [_systemConfig setValue:loginTime forKey:_USER_LOGINTIME_];
    [self saveSystemConfigData];
}
-(NSString *)getLoginTime
{
    return (NSString *)[_systemConfig valueForKey:_USER_LOGINTIME_];
}
//客服电话
-(void)saveServiceNumber:(NSString *)serviceNum
{
    [_systemConfig setValue:serviceNum forKey:_SERVICE_NUMBER_];
    [self saveSystemConfigData];
}
-(NSString *)getServiceNumber
{
    return  [(NSString *)_systemConfig valueForKey:_SERVICE_NUMBER_];
}
//sleepTime
-(void)saveSleepTime:(NSString *)sleepTime
{
    [_systemConfig setValue:sleepTime forKey:_SLEEP_TIME_];
    [self saveSystemConfigData];
}
-(NSString *)getSleepTime
{
    return [(NSString *)_systemConfig valueForKey:_SLEEP_TIME_];
}
//on line status
-(void)saveOnlineStatus:(NSString *)onlineStatus
{
    [_systemConfig setValue:onlineStatus forKey:_ONLINE_STATUS_];
    [self saveSystemConfigData];
}
-(NSString *)getOnlineStatus
{
    return  [(NSString *)_systemConfig valueForKey:_ONLINE_STATUS_];
}
//poistionOffsetPeriod
-(void)savePositionOffsetPeriod:(NSString *)positionoffsetperiod
{
    [_systemConfig setValue:positionoffsetperiod forKey:_POSITION_OFFSET_PERIOD_];
    [self saveSystemConfigData];
}
-(NSString *)getPositionOffsetPeriod
{
    return [(NSString *)_systemConfig valueForKey:_POSITION_OFFSET_PERIOD_];
}
//sessiontimeout
-(void)saveSessionTimeOut:(NSString *)sessiontimeout
{
    [_systemConfig setValue:sessiontimeout forKey:_SESSIOIN_TIMEOUT_];
    [self saveSystemConfigData];
}
-(NSString *)getSessionTimeout
{
    return [(NSString *)_systemConfig valueForKey:_SESSIOIN_TIMEOUT_];
}
//配送距离
-(void)saveDistanceToStartAddress:(NSString *)distanceToStartAddress
{
    [_systemConfig setValue:distanceToStartAddress forKey:_DISTANCE_TO_STARTADDRESS_];
    [self saveSystemConfigData];
}
-(NSString *)getDistanceToStartAddress
{
    return  (NSString *)[_systemConfig valueForKey:_DISTANCE_TO_STARTADDRESS_];
}

//是否是第一次获取待接订单的信息
-(void)saveIFFirstTimeGetWaitingOrderList:(NSString *)ifFirstGetList
{
    [_systemConfig setValue:ifFirstGetList forKey:_IFFIRST_TIME_GETlIST_];
    [self saveSystemConfigData];
}
-(NSString *)getIfFirstGetWaitingOrderList
{
    return  (NSString *)[_systemConfig valueForKey:_IFFIRST_TIME_GETlIST_];
}

//是否第一次获取驻店订单信息
-(void)saveIFFirstTimeGetInStoreOrderList:(NSString *)ifFirstGetList
{
    [_systemConfig setValue:ifFirstGetList forKey:_IFFIRTT_TIME_GET_STORELIST];
}
-(NSString *)getIfFirstGetInStoreOrderList
{
    return  (NSString *)[_systemConfig valueForKey:_IFFIRTT_TIME_GET_STORELIST];
}


//本地待接订单数据
-(void)saveWaitingOrderList:(NSArray *)waitingOrderList
{
    [_systemConfig setValue:waitingOrderList forKey:_WAITING_ORDER_LIST_];
    [self saveSystemConfigData];
}
-(NSMutableArray *)getWaitingOrderList
{
    return  (NSMutableArray *)[_systemConfig valueForKey:_WAITING_ORDER_LIST_];
}
//本地待解驻点订单数据
-(void)saveInStoreOrderList:(NSArray *)inStoreOrderList
{
    [_systemConfig setValue:inStoreOrderList forKey:_INSTORE_ORDER_LIST_];
    [self saveSystemConfigData];
}
-(NSArray *)getInStoreOrderList
{
    return  (NSMutableArray *)[_systemConfig valueForKey:_INSTORE_ORDER_LIST_];
}

//进行中订单数据
-(void)saveRunningOrderList:(NSMutableArray *)runningOrderList
{
    [_systemConfig setValue:runningOrderList forKey:_RUNNING_ORDER_LIST_];
    [self saveSystemConfigData];
}
-(NSMutableArray *)getRunningOrder
{
    return (NSMutableArray *)[_systemConfig valueForKey:_RUNNING_ORDER_LIST_];
}



//从进行中订单获得的本地待接单数据
-(void)saveWaitingOrderlistFromRunningData:(NSMutableArray *)waitingOrderList
{
    [_systemConfig setValue:waitingOrderList forKey:_WAIT_ORDER_FROM_RUNNING_];
    [self saveSystemConfigData];
}
-(NSMutableArray *)getWaitingOrderListFromRunningData
{
    return  (NSMutableArray *)[_systemConfig valueForKey:_WAIT_ORDER_FROM_RUNNING_];
}
//保存推送消息
-(void)saveNoticeInfo:(NSArray *)noticeInfo
{
    [_systemConfig setValue:noticeInfo forKey:_NOTICE_INFO_];
    [self saveSystemConfigData];
}
-(NSArray *)getNoticeInfo
{
    return (NSArray *)[_systemConfig valueForKey:_NOTICE_INFO_];
}
//保存 channal_id
-(void)saveDeviceToken:(NSString *)deviceToken
{
    [_systemConfig setValue:deviceToken forKey:_DEVICE_TOKEN_];
    [self saveSystemConfigData];
}
-(NSString *)getDeviceToken
{
//    return @"867066026385610";
//    NSLog(@"token%@",(NSString *)[_systemConfig valueForKey:_DEVICE_TOKEN_]);
//    NSLog(@"imei:%@",(NSString *)[_systemConfig valueForKey:_DEVICE_TOKEN_]);
    return  (NSString *)[_systemConfig valueForKey:_DEVICE_TOKEN_];
}
//保存指派订单
-(void)saveAssignOrder:(NSDictionary *)assignOrder
{
    [_systemConfig setValue:assignOrder forKey:_ASSIGN_ORDER_];
    [self saveSystemConfigData];
}
-(NSDictionary *)getAssignOrder
{
    return  (NSDictionary *)[_systemConfig valueForKey:_ASSIGN_ORDER_];
}

//快递员类型
-(void)saveDeliverType:(NSString *)deliverType
{
    [_systemConfig setValue:deliverType forKey:_DELIVER_TYPE_];
    [self saveSystemConfigData];
}

//  0-普通兼职（众包）	2-兼职小时工（众包小时工)
//  3-全职驻店 	4-驻店小时工  1-驻店兼职

-(NSString *)getDeliverType
{
    return  (NSString *)[_systemConfig valueForKey:_DELIVER_TYPE_];
}

//是否有抽奖订单
-(void)saveIfHasAwardOrder:(NSString *)haveAward
{
    [_systemConfig setValue:haveAward forKey:_IFHAVEAWARD_];
    [self saveSystemConfigData];
}
-(NSString *)getIfHasAwardOrder
{
    return  (NSString *)[_systemConfig valueForKey:_IFHAVEAWARD_];
}

//众包是否有抽奖活动
-(void)saveIfAmateurToGame:(NSString *)haveRight
{
    [_systemConfig setValue:haveRight forKey:_AMATEUR_GAME_RIGHT_];
    [self saveSystemConfigData];
}

//是否加入订单编号功能
-(void)saveIfHasOrderNo:(NSString *)ifhasOrder
{
    [_systemConfig setValue:ifhasOrder forKey:_IF_HAS_ORDER_];
    [self saveSystemConfigData];
}
- (NSString *)getIFHasOrderNo{
    return (NSString *)[_systemConfig valueForKey:_IF_HAS_ORDER_];
}




-(NSString *)getIFAmateurGameRight
{
    return  (NSString *)[_systemConfig valueForKey:_AMATEUR_GAME_RIGHT_];
}

//历史地址记录
-(void)saveHistoryAddress:(NSArray *)addressArray
{
//    [_systemConfig setValue:addressArray forKey:_HISTORY_ADDRESS_];
//    [self saveSystemConfigData];
    
    [[NSUserDefaults standardUserDefaults]setValue:addressArray forKey:_HISTORY_ADDRESS_];
}
-(NSArray *)getHistoryAddressArray
{
    
   return  (NSArray *)[[NSUserDefaults standardUserDefaults]valueForKey:_HISTORY_ADDRESS_];
 //   return  (NSArray *)[_systemConfig valueForKey:_HISTORY_ADDRESS_];
}

//历史店家记录
-(void)saveHistoryShopAddress:(NSArray *)shopAddressArray
{
//    [_systemConfig setValue:shopAddressArray forKey:_HISTORY_SHOP_ADDRESS];
//    [self saveSystemConfigData];
    [[NSUserDefaults standardUserDefaults]setValue:shopAddressArray forKey:_HISTORY_SHOP_ADDRESS];
    
}
-(NSArray *)getHistoryShopAddressArray
{
    return [(NSArray *)[NSUserDefaults standardUserDefaults]valueForKey:_HISTORY_SHOP_ADDRESS];
   // return (NSArray *)[_systemConfig valueForKey:_HISTORY_SHOP_ADDRESS];
}

//店家信息本地缓存
-(void)saveShopInfo:(NSArray *)shopInfo
{
    [_systemConfig setValue:shopInfo forKey:_SHOP_INFO_];
    [self saveSystemConfigData];
}

-(NSArray *)getShopInfo
{
    return (NSArray *)[_systemConfig valueForKey:_SHOP_INFO_];
}

//快递员店家
-(void)saveMainShopInfo:(NSDictionary *)mainShopInfo
{
    [[NSUserDefaults standardUserDefaults]setValue:mainShopInfo forKey:_MAIN_SHOP_INFO_];
}
-(NSDictionary *)getMainShopInfo
{
    return [(NSDictionary *)[NSUserDefaults standardUserDefaults]valueForKey:_MAIN_SHOP_INFO_];
}


- (BOOL)validateIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    if (!value) {
        return NO;
        
    }else {
        length = value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {//判断省份
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSArray *JYMArr = @[@"10X98765432",@"10x98765432"];
                for (int i = 0; i<JYMArr.count; i++) {
                    NSString *JYMX = JYMArr[i];
                    M = [JYMX substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                    if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                        return YES;// 检测ID的校验位
                    }else {
                        if (i != JYMArr.count-1) {
                            continue;
                        }else{
                            return NO;
                        }
                    }
                    
                }
                
                
            }else {
                return NO;
            }
        default:
            return false;
    }
}
@end
