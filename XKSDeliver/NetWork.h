//
//  NetWork.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/12.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#ifndef NetWork_h
#define NetWork_h
#import "NetWorkTool.h"
#import "NetworkingState.h"
//return info

        //login
#define ifsuccess               @"r"
#define sleepTime               @"m"
#define companyTelephone        @"t"
#define onlineStatus            @"s"
#define poistionOffsetPeriod    @"pot"
#define sessionTime             @"sessionTimeout"


//boruicy.mobile.notification.neworder：推送新订单
//boruicy.mobile.notification.updateorder：更新订单
//boruicy.mobile.notification.cancelorder：取消订单
//boruicy.mobile.notification.auto.assignorder：自动推送


//notification

#define _NOTIFICATION_NAME_ @"noti"

//notiState

//新推单
#define  _NOTI_ASSIGN_ORDER_     @"boruicy.mobile.notification.neworder"
//更新订单
#define  _NOTI_UPDATE_ORDER_     @"boruicy.mobile.notification.updateorder"
//取消订单
#define  _NOTI_CANCEL_ORDER_     @"boruicy.mobile.notification.cancelorder"
//派单
#define  _NOTI_NEW_ORDER_        @"boruicy.mobile.notification.auto.assignorder"
//通知
#define _NOTI_NEW_NOTICE_        @"boruicy.mobile.notification.auto.baidupushnotice"
//抽奖订单
#define _NOTI_AWARD_ORDER_        @"boruicy.mobile.notification.auto.awardorder"



//

#endif /* NetWork_h */
