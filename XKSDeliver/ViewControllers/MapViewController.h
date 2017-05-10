//
//  MapViewController.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/10.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#define LocateAndFollow 19
#define DefaultZoomLevel 11


#import <UIKit/UIKit.h>

#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#import <BaiduMapAPI_Search/BMKRouteSearch.h>



@interface MapViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKRouteSearchDelegate>
{
    BMKMapView *_baiduMapView;
    BMKLocationService *_locateDeliver;
    BMKRouteSearch *_routeSearch;
}

@property (nonatomic,strong)NSString *pushFromWhere;
@property (nonatomic,strong)NSArray *coordinateForAssignOrder;
@property (nonatomic,strong)NSString *orderID;


@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapTypeBtViewToTop;
- (IBAction)returnBtClicked:(UIButton *)sender;



@property (weak, nonatomic) IBOutlet UIButton *changeMapType;
@property (weak, nonatomic) IBOutlet UIButton *changeTrafficBt;


- (IBAction)changeMapType:(UIButton *)sender;
- (IBAction)changeTrafficBt:(UIButton *)sender;

- (IBAction)closeToCenterBt:(UIButton *)sender;
- (IBAction)awayToCenterBt:(UIButton *)sender;

- (IBAction)reviseShopAddress:(UIButton *)sender;



@property (weak, nonatomic) IBOutlet UIButton *locateBt;
- (IBAction)locateNow:(UIButton *)sender;

@end
