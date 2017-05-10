//
//  common.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/12.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#ifndef common_h
#define common_h
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "ConstantDefinition.h"
#import "SystemConfig.h"
#import "NetWork.h"
#import "UIView+frame.h"
#import "UtilityMethod.h"
#import "UIColor+expanded.h"
#import "MyControl.h"
#import "UILabel+Category.h"
#import "NSString+YYAdd.h"
#import "UINavigationController+PushPop.h"
#import "ReactiveCocoa.h"
#import "Singleton.h"
//                                       #####VERSION#####
#define APPSTORE_APPID   @"1051588705"

//                                       #####SERVER#####
//******IF CONNECT MAIN SERVER define it !!! ******

#warning  modity version number when update
// Version
#define _VERSION_NUM_ @"1.11"

#define SERVICE_ENVIRONMENT

#ifndef SERVICE_ENVIRONMENT
//CONNECT WHICH TEST SERVER
//real test

#define SERVICE_URL   @"http://101.200.90.137:20068/client"

// 以下为调试地址
//      tangjinyi test
//#define SERVICE_URL @"http://192.168.0.114:9080/client"
//      liusheng  test
//#define SERVICE_URL @"http://192.168.1.154:9080/client"
//      zhaoqiang test
//#define SERVICE_URL   @"http://192.168.1.115:9080/client/"
//      maowei test
//#define SERVICE_URL   @"http://192.168.1.113:9080/client"

#else

//#define SERVICE_URL   @"http://txbd.xiakesong.cn"
////https://txbd.xiakesong.cn
#define SERVICE_URL   @"https://txbd.xiakesong.cn"

#endif
//service port

#ifdef _XMPPSERVCIE_PORT_

#define _XMPP_PORT_ @"9897"

#else

#define _XMPP_PORT_ @"9896"

#endif

//                                     #####THIRD_PART#####
//#define GAODE_MAP_APIKEY @"f6a6549803a12e12d8949b8f1e7e2043"
#define BAIDU_MAP_APIKEY    @"lFyNA4KNqs0ZeNpBd81SOzge"
#define IFLY_APIKEY         @""
#define UMENG_APIKEY        @"56699da9e0f55ab39a002c87"
#define SHARE_SDK_APPKEY    @"d9ca1084af65"

//SINA
#define SINA_APPKEY         @"828853448"
#define SINA_SECRET_KEY     @"df9aa2e5440c67c38add4dd76c309904"

//QQ
#define QQ_APPID            @"110503499"     //16进制 41DD7EEE
#define QQ_APPKEY           @"9O4DO4OITEfc5Dor"

//WECHANT
#define WECHAT_APPID        @"wx8a0ffafaf0cce226"
#define WECHAT_SECRET_KEY   @"1ac3516ddded1cbd3186537c7d1e7127"

#endif /* common_h */
