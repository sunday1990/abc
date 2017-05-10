//
//  AppDelegate.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/10.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager *_baiduMapManager;
   // BOOL allowSelfSignedCertificates;
   // BOOL allowSSLHostNameMismatch;
}

@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, retain)BMKLocationService *locService;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong)NSDictionary *intervalCheckOrderDict;

@end




