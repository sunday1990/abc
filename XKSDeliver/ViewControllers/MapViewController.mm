//
//  MapViewController.m
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/10.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import "MapViewController.h"
#import "common.h"
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import "UIImage+Rotate.h"
#import "NetWorkTool.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]


BOOL IF_STANDARD           = YES;
BOOL IF_TRANSPORTATION_MAP = NO;
BOOL IF_LOCATE             = YES;


@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;

@end

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self judgeHowDeploy];
    [self deployMap];
    [self startLocate];
    
    //if locate
    [self startPlanRoute];
    [self deployUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [_baiduMapView viewWillAppear];
    _baiduMapView.delegate = self;
    _locateDeliver.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_baiduMapView viewWillDisappear];
    _baiduMapView.delegate = nil;
    _locateDeliver.delegate = nil;
    _routeSearch.delegate   = nil;
}

-(void)judgeHowDeploy
{
    if ([_pushFromWhere isEqualToString:@"planTrace"]) {
        _barView.hidden = NO;
        _mapTypeBtViewToTop.constant = _barView.frame.size.height+10;
    }
    else if ([_pushFromWhere isEqualToString:@"OrderListViewController"])
    {
        _barView.hidden = NO;
        _mapTypeBtViewToTop.constant = _barView.frame.size.height+10;
    }
    else if ([_pushFromWhere isEqualToString:@"managerAssignOrder"])
    {
        _barView.hidden = NO;
        _mapTypeBtViewToTop.constant = _barView.frame.size.height+10;
    }
}

-(void)deployMap
{
    _baiduMapView = [[BMKMapView alloc]initWithFrame: CGRectMake(0, 0, _SCREEN_WIDTH_, _SCREEN_HEIGHT_-self.tabBarController.tabBar.frame.size.height+22)];
    _baiduMapView.compassPosition = CGPointMake(30, 30);
    _baiduMapView.ChangeWithTouchPointCenterEnabled = YES;
    _baiduMapView.compassPosition  = CGPointMake(100, 100);
    [self.view addSubview:_baiduMapView];
    [self.view sendSubviewToBack:_baiduMapView];
}
-(void)startLocate
{
    _locateDeliver = [[BMKLocationService alloc]init];
    [_locateDeliver startUserLocationService];
    _baiduMapView.showsUserLocation = NO;//先关闭显示的定位图层
    _baiduMapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _baiduMapView.showsUserLocation = YES;//显示定位图层
}
-(void)startPlanRoute
{
    _routeSearch = [[BMKRouteSearch alloc]init];
    _routeSearch.delegate = self;

    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    
    if ([_pushFromWhere isEqualToString:@"planTrace"]) {
        for (NSDictionary *dict in [[SystemConfig shareSystemConfig]getRunningOrder]) {
            if ([[dict valueForKey:@"orderId"]isEqualToString:_orderID]) {
                start.pt = [self getCLLocationCoordinate2DWith:[dict valueForKey:@"reservedPlaceCoordinate"]];
                end.pt = [self getCLLocationCoordinate2DWith:[dict valueForKey:@"way"]];
            }
        }
    }
    else if ([_pushFromWhere isEqualToString:@"OrderListViewController"])
    {
        for (NSDictionary *dict in [[SystemConfig shareSystemConfig]getWaitingOrderListFromRunningData]) {
            if ([[dict valueForKey:@"orderId"]isEqualToString:_orderID]) {
                start.pt = [self getCLLocationCoordinate2DWith:[dict valueForKey:@"reservedPlaceCoordinate"]];
                end.pt = [self getCLLocationCoordinate2DWith:[dict valueForKey:@"way"]];
            }
        }
    }
    else if ([_pushFromWhere isEqualToString:@"managerAssignOrder"])
    {
        
        start.pt = [self getCLLocationCoordinate2DWith:_coordinateForAssignOrder[0]];
        end.pt   = [self getCLLocationCoordinate2DWith:_coordinateForAssignOrder[1]];
    }

    BMKWalkingRoutePlanOption *transitRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    transitRouteSearchOption.from = start;
    transitRouteSearchOption.to   = end;
    BOOL flag = [_routeSearch walkingSearch:transitRouteSearchOption];
    if (flag) {
        NSLog(@"规划成功");
    }
    else
    {
        NSLog(@"规划失败");
    }
    
}

- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray *array1 = [NSArray arrayWithArray:_baiduMapView.annotations];
    [_baiduMapView removeAnnotations:array1];
    array1 = [NSArray arrayWithArray:_baiduMapView.overlays];
    [_baiduMapView removeOverlays:array1];
    if (error == BMK_SEARCH_NO_ERROR) {
    BMKTransitRouteLine *plan = (BMKTransitRouteLine *)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        NSInteger planPointCounts = 0;
        
        for (int i = 0; i < size; i++)
        {
            //BMKWalkingStep
            BMKWalkingStep* walkingStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"收件地址";
                item.type = 0;
                [_baiduMapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"派件地址";
                item.type = 1;
                [_baiduMapView addAnnotation:item]; // 添加起点标注
            }
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = walkingStep.entrace.location;
            item.title = walkingStep.instruction;
            item.type = 4;
            [_baiduMapView addAnnotation:item];
            //轨迹点总数累计
            planPointCounts += walkingStep.pointsCount;
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* walkingStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<walkingStep.pointsCount;k++) {
                temppoints[i].x = walkingStep.points[k].x;
                temppoints[i].y = walkingStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
    
        [_baiduMapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];

    }else if(error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR)
    {
    
    }else
    {
        NSLog(@"未找到结果");
    }
//deal result
    
}
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.9];

        polylineView.lineWidth = 5.0;
        return polylineView;
    }
    return nil;
}
- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}



- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_baiduMapView updateLocationData:userLocation];
}

-(void)deployUI
{
    [_changeMapType setBackgroundImage:LOADIMAGE(@"Satellite@2x", @"png") forState:UIControlStateNormal];
    [_locateBt setBackgroundImage:LOADIMAGE(@"address_locate_off@2x", @"png") forState:UIControlStateNormal];
}

-(void)routePlanDidFinished:(NSDictionary *)userInfo
{
    NSLog(@"算路成功");
    //路径规划成功，开始导航
   // [BNCoreServices_UI showNaviUI: BN_NaviTypeReal delegete:self isNeedLandscape:YES];
}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
     
        return 	 [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnnotation*)annotation];
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark MapFunctionButton

- (IBAction)changeMapType:(UIButton *)sender {
    
    if (IF_STANDARD == YES) {
        [_baiduMapView setMapType:BMKMapTypeSatellite];
        [sender setBackgroundImage:LOADIMAGE(@"2Dmap@2x",@"png") forState:UIControlStateNormal];
        IF_STANDARD = NO;
    }else if (IF_STANDARD == NO)
    {
        [_baiduMapView setMapType:BMKMapTypeStandard];
        [sender setBackgroundImage:LOADIMAGE(@"Satellite@2x",@"png") forState:UIControlStateNormal];
        IF_STANDARD = YES;
    }
}

- (IBAction)changeTrafficBt:(UIButton *)sender {
    if (IF_TRANSPORTATION_MAP == YES) {
        [_baiduMapView setTrafficEnabled:NO];
        [sender setBackgroundImage:LOADIMAGE(@"transportation_unselected@2x", @"png") forState:UIControlStateNormal];
        IF_TRANSPORTATION_MAP = NO;
    }else if (IF_TRANSPORTATION_MAP == NO)
    {
        [_baiduMapView setTrafficEnabled:YES];
        [sender setBackgroundImage:LOADIMAGE(@"transportation_selected@2x", @"png") forState:UIControlStateNormal];
        IF_TRANSPORTATION_MAP = YES;
    }
}

- (IBAction)closeToCenterBt:(UIButton *)sender {
    _baiduMapView.zoomLevel++;
    NSLog(@"%f",_baiduMapView.zoomLevel);
}

- (IBAction)awayToCenterBt:(UIButton *)sender {
    if (_baiduMapView.zoomLevel <= 8) {
        return;
    }
    _baiduMapView.zoomLevel--;
    NSLog(@"%f",_baiduMapView.zoomLevel);
}

- (IBAction)reviseShopAddress:(UIButton *)sender {
    
    [NetWorkTool getRequestWithUrl:__reviseShopAddress totalParam:@{@"driverIMEI":[[SystemConfig shareSystemConfig]getDeviceToken],@"location":[NSString stringWithFormat:@"%@,%@",[[SystemConfig shareSystemConfig]getUserLocationLatitude],[[SystemConfig shareSystemConfig]getUserLocationLongtitude]]} addProgressHudOn:self.view Tip:@"修正门店地址" successReturn:^(id successReturn) {
        
//        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        ALERT_VIEW([jsonDict valueForKey:@"msg"]);
        
    } failed:^(id failed) {
        
    }];
    
    
}

- (IBAction)locateNow:(UIButton *)sender {
    
    if (IF_LOCATE == YES)
    {
        [sender setBackgroundImage:LOADIMAGE(@"address_locate_on@2x", @"png") forState:UIControlStateNormal];
        _baiduMapView.showsUserLocation = NO;//先关闭显示的定位图层
        _baiduMapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;//设置定位的状态
        _baiduMapView.showsUserLocation = YES;//显示定位图层
        _baiduMapView.zoomLevel = LocateAndFollow;
        IF_LOCATE = NO;
        
    }
    else if (IF_LOCATE == NO)
    {
        [sender setBackgroundImage:LOADIMAGE(@"address_locate_off@2x", @"png") forState:UIControlStateNormal];
        _baiduMapView.showsUserLocation = NO;//先关闭显示的定位图层
        _baiduMapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
        _baiduMapView.showsUserLocation = YES;//显示定位图层
        _baiduMapView.zoomLevel = DefaultZoomLevel;
        IF_LOCATE = YES;
    }
}

- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_baiduMapView setVisibleMapRect:rect];
    _baiduMapView.zoomLevel = _baiduMapView.zoomLevel - 0.3;
}

#pragma mark deal the location param

-(CLLocationCoordinate2D)getCLLocationCoordinate2DWith:(NSString *)locationData
{
    NSArray *locationArray = [locationData componentsSeparatedByString:@","];
    CLLocationDegrees  lati   = [locationArray[0] doubleValue];
    CLLocationDegrees  longti = [locationArray[1] doubleValue];
    CLLocationCoordinate2D location  = CLLocationCoordinate2DMake(lati, longti);
    
    return location;
}
#pragma mark exit
-(IBAction)returnBtClicked:(UIButton *)sender {
    
    if ([_pushFromWhere isEqualToString:@"planTrace"]) {
        _barView.hidden = NO;
        _mapTypeBtViewToTop.constant = _barView.frame.size.height+10;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([_pushFromWhere isEqualToString:@"OrderListViewController"])
    {
        [self.navigationController popViewControllerAnimated:YES];

    }
    else if ([_pushFromWhere isEqualToString:@"managerAssignOrder"])
    {
       [self dismissViewControllerAnimated:YES completion:^{
           
       }];
    }
    
}
@end
