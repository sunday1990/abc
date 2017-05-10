//
//  ConstantDefinition.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/12.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#ifndef ConstantDefinition_h
#define ConstantDefinition_h
//upload location interval
#define _UPLOAD_LOCATION_INTERVAL_ [[[SystemConfig shareSystemConfig]getSleepTime]doubleValue]



//loacation setting
#define _LOCATE_PER_DISTANCE_ 5

#define _ALERT_DISPLAY_TIME_ 30

//rest time
#define _REST_TIME_ 900


//UUID key in keychain
#define UUID @"firstuuid"

//frame
#define _SCREEN_WIDTH_        [UIScreen mainScreen].bounds.size.width
#define _SCREEN_HEIGHT_       [UIScreen mainScreen].bounds.size.height
#define WIDTH  ([[UIScreen mainScreen]bounds].size.width)
#define HEIGHT ([[UIScreen mainScreen]bounds].size.height)


#define _CELL_HEIGHT_ 60
#define _RUNNINGCELL_HEIGHT_ 140+6

#define _KEBOARD_HANG_PARAM_ 150

#define SYSTEM_VERSION ([[UIDevice currentDevice].systemVersion floatValue])

#define UI_NAV_BAR_HEIGHT  (SYSTEM_VERSION < 7 ? 44:64)

#define UI_TAB_BAR_HEIGHT  49

#define UI_STATUS_BAR_HEIGHT (SYSTEM_VERSION < 7 ? 0:20)

//color
#define _DEFAULT_BACK_     [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1]

#define _TABBAR_BLUE_     [UIColor colorWithRed:39/255.0 green:91/255.0 blue:187/255.0 alpha:1]
#define _TABLE_HEADERGREEN_ [UIColor colorWithRed:12/255.0 green:170/255.0 blue:154/255.0 alpha:1]

#define _SELECTED_BLUE_    [UIColor colorWithRed:24/255.0 green:53/255.0 blue:131/255.0 alpha:1]; 

#define DarkTextColor   [UIColor colorWithHexString:@"0x333333"]

#define LightTextColor  [UIColor colorWithHexString:@"0x666666"]

#define Blue_Color  RGB(39, 91, 187);

#define _TEXT_RED_ [UIColor colorWithRed:150/255.0 green:34/255.0 blue:0/255.0 alpha:1];
#define _TEXT_TIPRED_ [UIColor colorWithRed:216/255.0 green:65/255.0 blue:62/255.0 alpha:1];
#define _TEXT_GREEN_ [UIColor colorWithRed:79/255.0 green:150/255.0 blue:21/255.0 alpha:1];
#define _TEXT_TIPGRAY_ [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];


#define _STATUSCOLOR_ONLINE_     [UIColor colorWithRed:255/255.0 green:48/255.0 blue:48/255.0 alpha:1]
#define _STATUSCOLOR_RESTPERIOD_     [UIColor colorWithRed:255/255.0 green:165/255.0 blue:0/255.0 alpha:1]
#define _STATUSCOLOR_UPLINE_     [UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1]

//distance to start address
#define _DISTANCE_1_ @"2"
#define _DISTANCE_2_ @"4"
#define _DISTANCE_3_ @"6"


// hud in NetWoringState
#define MISSTAG 1234


//systemset page cell title
#define _SYSPAGETITTLE1_ @"修改密码"
#define _SYSPAGETITTLE2_ @"绑定手机"
#define _SYSPAGETITTLE3_ @"清除数据"
#define _SYSPAGETITTLE4_ @"通知通告"
#define _SYSPAGETITTLE5_ @""
#define _SYSPAGETITTLE6_ @"关于系统"
#define _SYSPAGETITILE7_ @"邀请好友"

//status
#define _status_online_ @"在线"
#define _status_rest_   @"休息"
#define _status_quit_   @"收工"

//identifer
#define id_historyorder @"历史订单"
#define id_waitingorder @"待接订单"
#define id_instoreorder @"驻店订单"
#define id_awardorder   @"抽奖"
#define id_scan         @"扫一扫"

#endif /* ConstantDefinition_h */
