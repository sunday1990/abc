//
//  AppDelegate.m
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/10.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import "AppDelegate.h"
#import "AccountViewController.h"
#import "MapViewController.h"
#import "MapViewController.h"
#import "SystemSetViewController.h"
#import "OrderViewController.h"
#import "pushOrderDetailController.h"
#import "alertOrderViewController.h"
#import "OrderListViewController.h"
#import "SystemDetailViewController.h"

#import "SaveUUIDinKeychain.h"
#import "WGS84TOGCJ02.h"
#import "MobClick.h"
#import "NetWorkTool.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "common.h"

#import "BPush.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"


//#import "um"

#warning 排序

#warning check only one present 

NSInteger settingLocation =44;
NSInteger settingNet      =55;
NSString  *pushType = @"";

NSInteger  havenewVersionTag        = 0200;
NSInteger  updateInWifiTag          = 0201;
NSInteger  updateImmediatelyTag     = 0202;
NSInteger  updateNotFromAppstoreTag = 0203;

@interface AppDelegate ()<UIAlertViewDelegate,alertOrderView,BMKGeneralDelegate,BMKLocationServiceDelegate,CLLocationManagerDelegate>

@property (nonatomic,copy)NSString *updateUrl;


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    #if TARGET_IPHONE_SIMULATOR
    
    [[SystemConfig shareSystemConfig]saveDeviceToken:@"5529330924172454791"];
    #else
    
    #endif
    [self checkVersionAndUpdate];
    
    [self deployBasicLayout];
    
    [self configBasicData];
    
    [self configBaiduMap];
    
    [self configUmeng];
    
    //[self configLocationManager];
    [self netConnectWaring];
    
    [self configJPushWith:(UIApplication *)application and:(NSDictionary *)launchOptions];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
//  [self configLocalNotification];
    
    return YES;
}
#pragma mark local notification
-(void)configLocalNotificationWithTime:(NSString *)time
{
    /**
     创建本地通知对象
     */
    UILocalNotification *localnotification = [[UILocalNotification alloc]init];
    /**
     *  设置推送的相关属性
     */
    localnotification.fireDate = [NSDate dateWithTimeInterval:20.0 sinceDate:[NSDate date]];//通知触发时间
    localnotification.alertBody = @"明天放假啦";//通知具体内容
    localnotification.alertTitle = @"房租";//谁发出的通知
   // localnotification.soundName = UILocalNotificationDefaultSoundName;//通知时的音效
    localnotification.soundName = @"new_order.caf";
    localnotification.applicationIconBadgeNumber = 1;
    localnotification.alertAction = @"查看更多精彩内容";//默认为 滑动来 +查看;锁屏时显示底部提示
    /**
     *  调度本地通知,通知会在特定时间发出
     */
    [[UIApplication sharedApplication] scheduleLocalNotification:localnotification];
    
}

#pragma mark remote Notification
//处理收到的消息推送
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //在此处理接收到的消息。    // App 收到推送的通知
    [BPush handleNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    completionHandler(UIBackgroundFetchResultNewData);
    // 打印到日志 textView 中
   //  NSLog(@"********** iOS7.0之后 background **********");
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
    }
    else//杀死状态下，直接跳转到跳转页面。
    {
    }
    if ([[userInfo valueForKey:@"biz_action"]isEqualToString:_NOTI_NEW_ORDER_]) {
        //自动推待接订单
       // NSLog(@"userInfo user's info %@",userInfo);
        pushType = _NOTI_NEW_ORDER_;
        [self pushToViewWith:_NOTI_NEW_ORDER_];
    }
    else if ([[userInfo valueForKey:@"biz_action"]isEqualToString:_NOTI_CANCEL_ORDER_])
    {
        ALERT_VIEW(@"有订单被取消!");
        [[NSNotificationCenter defaultCenter]postNotificationName:_NOTIFICATION_NAME_ object:@{@"notiState":_NOTI_CANCEL_ORDER_}];
    }
    else if ([[userInfo valueForKey:@"biz_action"]isEqualToString:_NOTI_UPDATE_ORDER_])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:_NOTIFICATION_NAME_ object:@{@"notiState":_NOTI_UPDATE_ORDER_}];
    }
    else if ([[userInfo valueForKey:@"biz_action"]isEqualToString:_NOTI_ASSIGN_ORDER_])
    {
        //指派
        [[SystemConfig shareSystemConfig]saveAssignOrder:[userInfo valueForKey:@"order"]];
            pushType  = _NOTI_ASSIGN_ORDER_;
            //orderId
        [self pushToViewWith:_NOTI_ASSIGN_ORDER_];
    }
    else if ([[userInfo valueForKey:@"biz_action"]isEqualToString:_NOTI_NEW_NOTICE_])
    {
        [self ToNoticeList];
    }
    else if ([[userInfo valueForKey:@"biz_action"]isEqualToString:_NOTI_AWARD_ORDER_])
    {
        pushType = _NOTI_AWARD_ORDER_;
        [self pushToViewWith:_NOTI_AWARD_ORDER_];
    }
}

-(void)pushToViewWith:(NSString *)noticeType
{
    alertOrderViewController *alertOrderView = [[alertOrderViewController alloc]init];
    alertOrderView.alertOrderDelegate = self;
    [_window.rootViewController presentViewController:alertOrderView animated:YES completion:^{
    }];
}

-(void)alertOrderViewClicked:(NSString *)tag
{
    if ([tag isEqualToString:@"110"]) {
        
        if ([pushType isEqualToString:_NOTI_NEW_ORDER_]) {
            OrderListViewController *orderListView = [[OrderListViewController alloc]init];
            orderListView.fromWhich = id_waitingorder;
            orderListView.displayMethod = @"present";
            [_window.rootViewController presentViewController:orderListView animated:YES completion:^{
            }];
        }
        else if ([pushType isEqualToString:_NOTI_ASSIGN_ORDER_])
        {
            pushOrderDetailController *orderDetail = [[pushOrderDetailController alloc]init];
            orderDetail.fromWhich = @"managerAssignOrder";
            orderDetail.dataSource = [[SystemConfig shareSystemConfig]getAssignOrder];
            orderDetail.orderId = [[[SystemConfig shareSystemConfig]getAssignOrder]valueForKey:@"orderId"];
            [_window.rootViewController presentViewController:orderDetail animated:NO completion:^{
                        }];
        }
        else if ([pushType isEqualToString:_NOTI_AWARD_ORDER_])
        {
            OrderListViewController *orderListView = [[OrderListViewController alloc]init];
            orderListView.fromWhich = id_awardorder;
            orderListView.displayMethod = @"present";
            [_window.rootViewController presentViewController:orderListView animated:YES completion:^{
            }];
        }
    }
    else if ([tag isEqualToString:@"111"])
    {
        if ([pushType isEqualToString:_NOTI_NEW_ORDER_]) {
            
        }
        else if ([pushType isEqualToString:_NOTI_ASSIGN_ORDER_])
        {
            
        }
    }
}

#pragma mark Push Notification
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

#pragma local notification
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
        if (result) {
            [BPush setTag:@"Mytag" withCompleteHandler:^(id result, NSError *error) {
                if (result) {
                  //  NSLog(@"设置tag成功");
                }
            }];
        }
        
        if (![result valueForKey:@"channel_id"]) {
            [[SystemConfig shareSystemConfig]saveDeviceToken:@""];
            
        }else{
            [[SystemConfig shareSystemConfig]saveDeviceToken:[result valueForKey:@"channel_id"]];
        }
    }];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}

#pragma mark appdelegate

- (void)applicationWillResignActive:(UIApplication *)application {
    
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [BMKMapView willBackGround];
   // [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    if([CLLocationManager significantLocationChangeMonitoringAvailable])
    {
    }
    else
    {
    }
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
    [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
    [UMSocialSnsService  applicationDidBecomeActive];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [self logOut];
    [_locationManager stopUpdatingLocation];
    [[SystemConfig shareSystemConfig]saveLoginTime:@""];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:
}


#pragma mark system configuration
-(void)configBasicData
{
    self.intervalCheckOrderDict = [[NSDictionary alloc]init];
    
    [[NSUserDefaults standardUserDefaults]setValue:[NSDate distantFuture] forKey:@"uploadtime"];

    if (![[[SystemConfig shareSystemConfig]getIfFirstTimeComein]isEqualToString:@"no"])
    {
        if ([[SaveUUIDinKeychain shareKeyChain]getUUIDatKeyChain]==nil||[[[SaveUUIDinKeychain shareKeyChain]getUUIDatKeyChain]isEqualToString:@""]||[[[SaveUUIDinKeychain shareKeyChain]getUUIDatKeyChain]isEqual:[NSNull null]]) {
            [[SaveUUIDinKeychain shareKeyChain]initUUIDKeyInKeyChain];
            [[SaveUUIDinKeychain shareKeyChain]setUUID];
        }
            [[SystemConfig shareSystemConfig]saveUUID:[[SaveUUIDinKeychain shareKeyChain]getUUIDatKeyChain]];
            [[SystemConfig shareSystemConfig]saveIfFirstTimeComein:@"no"];
            [[SystemConfig shareSystemConfig]saveUserName:@""];
            [[SystemConfig shareSystemConfig]saveUserPassword:@""];
            [[SystemConfig shareSystemConfig]saveSesstionID:@""];
            [[SystemConfig shareSystemConfig]saveServiceNumber:@"4000563766"];
            [[SystemConfig shareSystemConfig]saveUserLocationLatitude:@""];
            [[SystemConfig shareSystemConfig]saveUserLocationLongtitude:@""];
            [[SystemConfig shareSystemConfig]saveDistanceToStartAddress:@"6"];
            [[SystemConfig shareSystemConfig]saveWaitingOrderList:@[]];
            [[SystemConfig shareSystemConfig]saveUserStatus:_status_online_];
            [[SystemConfig shareSystemConfig]saveLoginTime:@""];
            [[SystemConfig shareSystemConfig]saveShopInfo:@[]];
            [[SystemConfig shareSystemConfig]saveHistoryAddress:@[]];
            [[SystemConfig shareSystemConfig]saveHistoryShopAddress:@[]];
            [[NSUserDefaults standardUserDefaults]setValue:@"签到" forKey:@"signInOrOut"];
        
        ALERT_VIEW(@"本应用会持续定位,来接收用户实时位置附近的订单推送!");
        
    }
}

-(void)configLocationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
    }
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter  = _LOCATE_PER_DISTANCE_;

    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [_locationManager requestAlwaysAuthorization];
    }
    [_locationManager startUpdatingLocation];
}

-(void)configBaiduMap
{
    _baiduMapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_baiduMapManager start:@"lFyNA4KNqs0ZeNpBd81SOzge"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    _locService = [[BMKLocationService alloc]init];
    _locService.distanceFilter = kCLDistanceFilterNone;
    _locService.desiredAccuracy = 10;
    _locService.delegate =self;
    
    _locService.pausesLocationUpdatesAutomatically = NO;
    _locService.allowsBackgroundLocationUpdates    = YES;
    
    [_locService startUserLocationService];
    
}

-(void)configJPushWith:(UIApplication *)application and:(NSDictionary *)launchOptions
{
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        // 1.注册UserNotification,以获取推送通知的权限
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil];
        [application registerUserNotificationSettings:settings];
        // 2.注册远程推送
        [application registerForRemoteNotifications];
    } else {
        //iOS8之前,注册远程推送的方法
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeNewsstandContentAvailability | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
    
#warning change the environment
    
    [BPush registerChannel:launchOptions apiKey:@"SEfYlptGGQ2LmA9mORX9OOYD" pushMode:BPushModeProduction withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:NO];
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
       // NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
}

-(void)configUmeng
{
    
    [MobClick startWithAppkey:UMENG_APIKEY reportPolicy:BATCH channelId:nil];
    [UMSocialData setAppKey:UMENG_APIKEY];
    //打开调试log的开关
   // [UMSocialData openLog:YES];
    [UMSocialWechatHandler setWXAppId:WECHAT_APPID appSecret:WECHAT_SECRET_KEY url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setQQWithAppId:QQ_APPID appKey:QQ_APPKEY url:@"http://www.umeng.com/social"];
    //  http://www.umeng.com/social
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

-(void)checkVersionAndUpdate
{
    //build
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    CGFloat currentVersion = [[infoDic objectForKey:@"CFBundleVersion"] doubleValue];
    //CFBundleShortVersionString

    //[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"];
    
    
    UIView *view = [[UIView alloc]init];
    [NetWorkTool getRequestWithUrl:__checkVersionAndUpdate totalParam:@{@"nowDate":[NSString stringWithFormat:@"%@",[NSDate date]]} addProgressHudOn:view Tip:@"检测更新" successReturn:^(id successReturn) {
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil];
        //其它来源的安装
        _updateUrl = [jsonDict valueForKey:@"url"];
        //[serverVersion doubleValue]
        if ([[jsonDict valueForKey:@"checkVersion"]floatValue] <= currentVersion) {
            
        }
        else
        {
            if ([[jsonDict valueForKey:@"forceUpgrade"]isEqualToString:@"0"]) {
                UIAlertView *versionAlert = [[UIAlertView alloc]initWithTitle:@"版本更新" message:@"有新的版本可以更新" delegate:self cancelButtonTitle:@"去更新" otherButtonTitles:@"暂不更新", nil];
                versionAlert.tag = havenewVersionTag;
                [versionAlert show];
                //更新提示
            }else if ([[jsonDict valueForKey:@"forceUpgrade"]isEqualToString:@"1"])
            {
                Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
                if ([reach isReachableViaWiFi]==YES) {
                    UIAlertView *versionAlert = [[UIAlertView alloc]initWithTitle:@"版本更新" message:@"检测到您在wifi环境下请更新软件" delegate:self cancelButtonTitle:@"去更新" otherButtonTitles:nil];
                    versionAlert.tag = updateInWifiTag+1;
                    [versionAlert show];
                }
                else
                {
                    UIAlertView *versionAlert = [[UIAlertView alloc]initWithTitle:@"版本更新" message:@"有新的版本可以更新" delegate:self cancelButtonTitle:@"去更新" otherButtonTitles:@"暂不更新", nil];
                    versionAlert.tag = updateInWifiTag;
                    [versionAlert show];
                }
                //wifi下强制更新
            }
            else if ([[jsonDict valueForKey:@"forceUpgrade"]isEqualToString:@"2"])
            {
                UIAlertView *versionAlert = [[UIAlertView alloc]initWithTitle:@"版本更新" message:@"有新的版本必须更新" delegate:self cancelButtonTitle:@"去更新" otherButtonTitles:nil];
                versionAlert.tag = updateImmediatelyTag;
                [versionAlert show];
                //强制更新
            }
            else if ([[jsonDict valueForKey:@"forceUpgrade"]isEqualToString:@"3"])
            {
                UIAlertView *versionAlert = [[UIAlertView alloc]initWithTitle:@"版本更新" message:@"有新的版本必须更新" delegate:self cancelButtonTitle:@"去更新" otherButtonTitles:nil];
                versionAlert.tag = updateNotFromAppstoreTag;
                [versionAlert show];
                //其它来源更新
            }

        }
        
    } failed:^(id failed) {
        
    }];
}

#pragma mark UI
-(void)deployBasicLayout
{
    _window.backgroundColor =[UIColor whiteColor];
    UITabBarController *mainTabBarController = [[UITabBarController alloc]init];
    UIViewController *tempController  = _window.rootViewController;
    _window.rootViewController = mainTabBarController;
    
    AccountViewController *accountController     = [[AccountViewController alloc]init];
    MapViewController     *mapController         = [[MapViewController alloc]init];
    SystemSetViewController *systemSetController = [[SystemSetViewController alloc]init];
    
    UINavigationController *OrderNavigationController = [[UINavigationController alloc]initWithRootViewController:tempController];
    UINavigationController *AccountNavigationController = [[UINavigationController alloc]initWithRootViewController:accountController];
    UINavigationController *SystemSetNavigationController = [[UINavigationController alloc]initWithRootViewController:systemSetController];
    
    UITabBarItem *OrderItem = [[UITabBarItem alloc]initWithTitle:@"订单" image:LOADIMAGE(@"order_unselected@2x", @"png") selectedImage:LOADIMAGE(@"order_selected@2x", @"png")];
    tempController.tabBarItem = OrderItem;
    
    UITabBarItem *AccountItem = [[UITabBarItem alloc]initWithTitle:@"用户" image:LOADIMAGE(@"account_unselected@2x", @"png") selectedImage:LOADIMAGE(@"account_selected@2x", @"png")];
    accountController.tabBarItem = AccountItem;
    
    UITabBarItem *MapItem = [[UITabBarItem alloc]initWithTitle:@"地图" image:LOADIMAGE(@"map_unselected@2x", @"png") selectedImage:LOADIMAGE(@"map_selected@2x", @"png")];
    mapController.tabBarItem = MapItem;
    
    UITabBarItem *SysItem = [[UITabBarItem alloc]initWithTitle:@"系统" image:LOADIMAGE(@"system_unselected@2x", @"png") selectedImage:LOADIMAGE(@"system_selected@2x", @"png")];
    systemSetController.tabBarItem = SysItem;
    
    mainTabBarController.viewControllers = @[OrderNavigationController,AccountNavigationController,mapController,SystemSetNavigationController];
}

#pragma mark baidu map locate delegate
- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
     //   NSLog(@"baidu map api: ---------- ------授权成功");
    }
    else {
      //  NSLog(@"baidu map api: ---------- ------onGetPermissionState %d",iError);
    }
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    [[SystemConfig shareSystemConfig]saveUserLocationLatitude:[NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude]];
    [[SystemConfig shareSystemConfig]saveUserLocationLongtitude:[NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude]];
    
    if (([[SystemConfig shareSystemConfig]getLoginTime]!=nil)&&![[[SystemConfig shareSystemConfig]getLoginTime]isEqualToString:@""])
    {
        double timeInterval = 0-_UPLOAD_LOCATION_INTERVAL_/1000;
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"uploadtime"]timeIntervalSinceNow]< timeInterval )
        {
        [self ToUpLoadLocation];
        }
    }
}

#pragma mark alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == settingLocation) {
        
        (buttonIndex == 0) ? [self settingLocation]:[self doNothing];
        
    }else if (alertView.tag == settingNet)
    {
        (buttonIndex == 0) ? [self settingNet]:[self doNothing];
    }else if (alertView.tag == havenewVersionTag)
    {
        if (buttonIndex == 0) {
            [self startAppStore];
        }
    }else if (alertView.tag == updateInWifiTag+1)
    {
        if (buttonIndex == 0) {
            [self startAppStore];
        }
    }else if (alertView.tag == updateImmediatelyTag)
    {
        if (buttonIndex == 0) {
            [self startAppStore];
        }
    }else if (alertView.tag == updateNotFromAppstoreTag)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_updateUrl]];
 
    }
}
-(void)doNothing
{
}
-(void)settingLocation
{
    NSURL *locateUrl = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
    if ([[UIApplication sharedApplication]canOpenURL:locateUrl]) {
        [[UIApplication sharedApplication]openURL:locateUrl];
    }
}
-(void)settingNet
{
    NSURL *locateUrl = [NSURL URLWithString:@"prefs:root=Cellular"];
    if ([[UIApplication sharedApplication]canOpenURL:locateUrl]) {
        [[UIApplication sharedApplication]openURL:locateUrl];
    }
}
#pragma mark network listening
-(void)netConnectWaring
{
    NSURL *pingUrl = [NSURL URLWithString:@"http://baidu.com"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:pingUrl];
    NSOperationQueue *operttionQueue = manager.operationQueue;
    __weak typeof(self) this = self;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络状态");
                [this doAlertNetwork];
                [operttionQueue setSuspended:YES];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络访问");
                [this doAlertNetwork];
                [operttionQueue setSuspended:YES];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operttionQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [operttionQueue setSuspended:NO];
                break;
            default:
                [operttionQueue setSuspended:YES];
                break;
        }
    }];
    [manager.reachabilityManager startMonitoring];
    [[AFNetworkActivityIndicatorManager sharedManager]setEnabled:YES];
}
-(void)doAlertNetwork
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络访问错误" delegate:self cancelButtonTitle:@"去设置" otherButtonTitles:@"取消", nil];
    alertView.tag = settingNet;
    [alertView show];
}
#pragma toAppstore
-(void)startAppStore
{
    if ([[[UIDevice currentDevice] systemVersion] intValue] < 7)
    {
        NSString * appstoreUrlString = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?mt=8&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software&id=%@",@"1051588705"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstoreUrlString]];
    }else
    {
        NSString * appstoreUrlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",@"1051588705"];
        //https://itunes.apple.com/cn/app/id1051588705
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstoreUrlString]];
    }
}

#pragma mark networking


-(void)ToUpLoadLocation
{
    NSString *imeiString = [[SystemConfig shareSystemConfig]getDeviceToken];
    // from android "MM-dd HH:mm:ss"
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    // splice the param string
    NSString *OtherFourParam = [NSString stringWithFormat:@";%@,%@,%@,gps",[[SystemConfig shareSystemConfig]getUserLocationLatitude],[[SystemConfig shareSystemConfig]getUserLocationLongtitude],[dateFormatter stringFromDate:[NSDate date]]];
    NSString *paramString = [imeiString stringByAppendingString:OtherFourParam];
    
    for (NSDictionary * orderDict in [[SystemConfig shareSystemConfig]getWaitingOrderList]) {
        
        [paramString stringByAppendingString:[NSString stringWithFormat:@",%@",[orderDict valueForKey:@"orderId"]]];
    }
    
    if ([[[SystemConfig shareSystemConfig]getUserLocationLatitude]isEqualToString:@""])
    {
        return;
    }
    [NetWorkTool postToUpLoadLocationWithParam:@{@"p":paramString,} successReturn:^(id successReturn) {
        
        NSDictionary *jsonDict = nil;
//             jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];;
        jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        
            if ([[jsonDict valueForKey:@"r"]isEqualToString:@"1"])
            {
                [[NSUserDefaults standardUserDefaults]setValue:[NSDate date]forKey:@"uploadtime"];
            }
            else if ([[jsonDict valueForKey:@"r"]isEqualToString:@"0"])
            {
                exit(0);
            }
            
            if ([[jsonDict valueForKey:@"autoAssignOrderNumber"]integerValue]==0 && [jsonDict allKeys].count == 2){
                
            }
            else if ([[jsonDict valueForKey:@"newPushOrderNumber"]doubleValue]>0)
            {
                //指派
                [[SystemConfig shareSystemConfig]saveAssignOrder:[jsonDict valueForKey:@"newPushOrderInfos"]];
            }
            else if ([[jsonDict valueForKey:@"autoAssignOrderNumber"]doubleValue]>0)
            {
                pushType = _NOTI_NEW_ORDER_;
                [self pushToViewWith:_NOTI_NEW_ORDER_];
            }

        } failed:^(id failed) {
            NSLog(@"error output%@",failed);
    }];
    
}
- (BOOL)autoCheckFromAppStore
{
    BOOL result;
    //获取当前设备中应用的版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    CGFloat currentVersion = [[infoDic objectForKey:@"CFBundleVersion"] doubleValue];
    
    NSString *URL = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",APPSTORE_APPID];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:recervedData options:NSJSONReadingMutableContainers error:nil];
    NSArray *infoArray = [dic objectForKey:@"results"];
    NSString *lastVersion = nil;
    if ([infoArray count]) {
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        lastVersion = [releaseInfo objectForKey:@"version"];
    }
    //判断两个版本是否相同
    if (currentVersion < [lastVersion intValue])
    {
        result = YES;//更新
       // NSLog(@"");
    }
    else {
       // NSLog(@"");
        result = NO;
    }
    
    return result;
}
// 差分数据的方法
-(void)compareAndDealTheWaitingOrderDataWithList:(NSArray *)orderList
{
    
    NSMutableArray *oldArray;
    NSArray *oldcompareArray;
    NSArray *newArray;
    NSArray *newcompareArray;
    NSString *totalString1 = @"";
    
    if ([[[SystemConfig shareSystemConfig]getIfFirstGetWaitingOrderList]isEqualToString:@"no"]) {
        if ([[SystemConfig shareSystemConfig]getWaitingOrderList].count == 0 ) {
            [[SystemConfig shareSystemConfig]saveWaitingOrderList:orderList];
        }
    }else
    {
        [[SystemConfig shareSystemConfig]saveWaitingOrderList:orderList];
        [[SystemConfig shareSystemConfig]saveIFFirstTimeGetWaitingOrderList:@"no"];
    }
    oldArray = [[NSMutableArray alloc]initWithArray:[[SystemConfig shareSystemConfig]getWaitingOrderList]];
    oldcompareArray = [[SystemConfig shareSystemConfig]getWaitingOrderList];
    newArray = orderList;
    newcompareArray = [[SystemConfig shareSystemConfig]getWaitingOrderList];
    totalString1 = @"";

    //part one
    for (NSDictionary *dict in newArray) {
        totalString1= [totalString1 stringByAppendingString:[dict valueForKey:@"orderId"]];
    }
    
    for (NSMutableDictionary *dict in oldcompareArray) {
        if ([totalString1 rangeOfString:[dict valueForKey:@"orderId"]].location == NSNotFound) {
            [oldArray removeObject:dict];
        }
    }
    
    //part two
    NSString *totalString2 = @"";
    for (NSDictionary *dict in oldcompareArray) {
        totalString2 = [totalString2 stringByAppendingString:[dict valueForKey:@"orderId"]];
    }
    for (NSMutableDictionary *dict in newcompareArray) {
        if ([totalString2 rangeOfString:[dict valueForKey:@"orderId"]].location == NSNotFound) {
            [oldArray addObject:dict];
        }
    }
    [[SystemConfig shareSystemConfig]saveWaitingOrderList:oldArray];
}

-(void)ToNoticeList
{
    
    SystemDetailViewController *noticeListView = [[SystemDetailViewController alloc]init];
    noticeListView.fromType = @"present";
    noticeListView.fromWhich = _SYSPAGETITTLE4_;
    [_window.rootViewController presentViewController:noticeListView animated:YES completion:^{
        
    }];
    
}

-(void)logOut
{
    UIView *view = [[UIView alloc]init];
    
    [NetWorkTool postRequestWithUrl:__logOut param:@{@"nowDate":[NSString stringWithFormat:@"%@",[NSDate date]]} addProgressHudOn:view Tip:@"" successReturn:^(id successReturn) {
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        
    } failed:^(id failed) {
        
    }];
    
}




@end
