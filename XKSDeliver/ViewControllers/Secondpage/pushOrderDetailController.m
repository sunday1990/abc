//
//  pushOrderDetailController.m
//  XKSDeliver
//
//  Created by 同行必达 on 15/11/16.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import "pushOrderDetailController.h"
#import "NetWorkTool.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "MapViewController.h"

NSInteger success = 123;
NSInteger fail    = 456;

@interface pushOrderDetailController ()<UIAlertViewDelegate>

@end

@implementation pushOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"1"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"3"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"4"]) {
        _topToLinesix.constant = -36;
        _planTraceBt.hidden    = YES;
        _topToLineNine.constant = -36;
    }

    if ([_fromWhich isEqualToString:@"OrderListViewController"]||[_displayMethod isEqualToString:@"present"]) {
        [self deployUI1];
        if ([[SystemConfig shareSystemConfig]getWaitingOrderListFromRunningData].count!=0) {
            
            _dataSource = [[SystemConfig shareSystemConfig]getWaitingOrderListFromRunningData][0];
            [self loadDataForView];
        }
        else
        {
            [self connectDetailData];
        }
    }else if ([_fromWhich isEqualToString:@"managerAssignOrder"])
    {
        [self deploUI2];
        [self loadDataForView];
    }
    else if ([_fromWhich isEqualToString:@"CellToAssignOrder"])
    {
        [self deploUI2];
        [self loadDataForView];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}
-(void)deployUI1
{
    self.titleLb.text = @"待接订单";
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)deploUI2
{
    self.titleLb.text = @"系统派单请接收";
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)returnBtClicked:(UIButton *)sender {
    
    if ([_fromWhich isEqualToString:@"OrderListViewController"]) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        if ([_displayMethod isEqualToString:@"present"]) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
          //  self.tabBarController.tabBar.hidden = NO;
        }
    }
    else if ([_fromWhich isEqualToString:@"managerAssignOrder"])
    {
        AppDelegate *appDelegate = [[AppDelegate alloc]init];
        appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    else if ([_fromWhich isEqualToString:@"CellToAssignOrder" ])
    {
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
    }
}
#pragma  mark alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    if (alertView.tag == success) {
        if (buttonIndex == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:NO completion:^{
            [appDelegate.window.rootViewController dismissViewControllerAnimated:NO completion:^{
                    
                }];
            }];
            self.tabBarController.tabBar.hidden = NO;
        }
    }else if (alertView.tag == fail)
    {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:NO completion:^{
                [appDelegate.window.rootViewController dismissViewControllerAnimated:NO completion:^{
                }];
            }];
            self.tabBarController.tabBar.hidden = NO;
        }
    }
}
- (IBAction)confirmOrderBtClicked:(UIButton *)sender {
    
    [self connectToReceiveTheOrder];
}
#pragma mark planTrace
- (IBAction)planTraceBtClicked:(UIButton *)sender {
    
    MapViewController *mapView = [[MapViewController alloc]init];
    mapView.orderID = [_dataSource valueForKey:@"orderId"];
    if ([_fromWhich isEqualToString:@"OrderListViewController"]) {

        mapView.pushFromWhere = @"OrderListViewController";
        [self.navigationController pushViewController:mapView animated:YES];
        if ([_displayMethod isEqualToString:@"present"]) {
            mapView.pushFromWhere = @"managerAssignOrder";
            mapView.coordinateForAssignOrder = @[[_dataSource valueForKey:@"reservedPlaceCoordinate"],[_dataSource valueForKey:@"way"]];
            //  mapView.coordinateForAssignOrder = @[@"32231321",@"323232"];
            [self presentViewController:mapView animated:YES completion:^{
            }];
        }
    }
    else if ([_fromWhich isEqualToString:@"managerAssignOrder"])
    {
        mapView.pushFromWhere = @"managerAssignOrder";
        mapView.coordinateForAssignOrder = @[[_dataSource valueForKey:@"reservedPlaceCoordinate"],[_dataSource valueForKey:@"way"]];
      //  mapView.coordinateForAssignOrder = @[@"32231321",@"323232"];
        [self presentViewController:mapView animated:YES completion:^{
        }];
    }
    else if ([_fromWhich isEqualToString:@"CellToAssignOrder"])
    {
        mapView.pushFromWhere = @"managerAssignOrder";
        mapView.coordinateForAssignOrder = @[[_dataSource valueForKey:@"reservedPlaceCoordinate"],[_dataSource valueForKey:@"way"]];
        //  mapView.coordinateForAssignOrder = @[@"32231321",@"323232"];
        [self presentViewController:mapView animated:YES completion:^{
        }];
    }
}
-(void)connectToReceiveTheOrder
{
//    NSArray *array = [[SystemConfig shareSystemConfig]getWaitingOrderListFromRunningData];
//    NSString *smsToCustomer = nil;
//    NSString *receiveOrderType = nil;
//    
//    for (NSDictionary *dict in array) {
//        if ([[dict valueForKey:@"orderId"]isEqualToString:_orderId]) {
//           smsToCustomer = [dict valueForKey:@"smsToCustomer"];
//           receiveOrderType = [dict valueForKey:@"receiveOrderType"];
//        }
//    }
    [NetWorkTool postRequestWithUrl:__receiveOrder param:@{@"orderId":_orderId,@"pushId":@"",@"smsToCustomer":@"",@"receiveOrderType":@"",} addProgressHudOn:self.view Tip:@"抢单中" successReturn:^(id successReturn) {
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        //        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        if ([[jsonDict valueForKey:@"result"]isEqualToString:@"false"]) {
            
            NSString *tip = [jsonDict valueForKey:@"msg"];
            UIAlertView *failedAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:tip delegate:self cancelButtonTitle:@"退出" otherButtonTitles:nil];
            failedAlert.tag = fail;
            [failedAlert show];
        }else
        {
            UIAlertView *successAlert = [[UIAlertView alloc]initWithTitle:@"恭喜抢单成功!" message:@"###请先查看备注###\n如无特别需求请立刻执行订单!" delegate:self cancelButtonTitle:@"已确认" otherButtonTitles:nil];
            successAlert.tag = success;
            [successAlert show];
        }
        
    } failed:^(id failed) {
        
    }];
}
-(void)connectDetailData
{
    __weak typeof(self) this = self;
    [NetWorkTool getRequestWithUrl:__orderDetail param:@{@"orderId":_orderId,} addProgressHudOn:self.view Tip:@"获取新订单详情" successReturn:^(id successReturn) {
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        this.dataSource = jsonDict;
        [this loadDataForView];
        
        
    } failed:^(id failed) {
    }];
}
-(void)loadDataForView
{
    
    if ([[_dataSource objectForKey:@"orderExecuteTypeStr"]isEqualToString:@""]) {
        _lineOrderTypeToTop.constant = -30;
    }
    else
    {
        _orderTypeLb.text = [_dataSource valueForKey:@"orderExecuteTypeStr"];
    }
    
    NSArray *timeString = [[_dataSource objectForKey:@"reservedTime"]componentsSeparatedByString:@" "];
    NSArray *timeDate   = [timeString[0]componentsSeparatedByString:@"-"];
    
    _orderReserveTimeLb.text   = [NSString stringWithFormat:@"%@日%@",timeDate[2],timeString[1]];
    
    if ([[_dataSource objectForKey:@"sendTimeAppointment"]isEqualToString:@""]) {
        _lineTwoTopToLineOne.constant = -30;

    }
    else
    {
        _reserveArriveTimeLb.text = [_dataSource valueForKey:@"sendTimeAppointment"];
    }
    
    if ([[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"1"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"3"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"4"]) {
        
        _addressTv.text = [NSString stringWithFormat:@"寄件地址:%@\n",[_dataSource objectForKey:@"reservedPlace"]];

    }else
    {
        _addressTv.text = [NSString stringWithFormat:@"寄件地址:%@\n收件地址:%@",[_dataSource objectForKey:@"reservedPlace"],[_dataSource objectForKey:@"targetAddress"]];
    }
    
    _awardMoneyLb.text         = [NSString stringWithFormat:@"%@ 元",[_dataSource objectForKey:@"driverDeductScale"]];
    _packageWeightLb.text      = [_dataSource objectForKey:@"itemWeight"];
    _askMoneyLb.text           = [_dataSource objectForKey:@"paymentTypeStr"];
    _payPersonLb.text          = [_dataSource objectForKey:@"payerTypeStr"];
    _packageNameLb.text        = [_dataSource objectForKey:@"itemName"];
    
    //deal distance
    NSString *locateString   = [_dataSource valueForKey:@"reservedPlaceCoordinate"];
    
    NSArray *latitudeAndLongtitude = [locateString componentsSeparatedByString:@","];
    
    double latiStartLocation = [[latitudeAndLongtitude firstObject]doubleValue];
    double latiMyLocation    = [[[SystemConfig  shareSystemConfig]getUserLocationLatitude]doubleValue];
    double longtiStartLocation = [[latitudeAndLongtitude lastObject]doubleValue];
    double longtiMyLocation    = [[[SystemConfig shareSystemConfig]getUserLocationLongtitude]doubleValue];
    double distanceResult      = [self distanceBetweenOrderBy:latiStartLocation  :latiMyLocation :longtiStartLocation :longtiMyLocation];
    
    
    if (distanceResult > 1000) {
        _getPackageDistanceLb.text = [NSString stringWithFormat:@"%.1f km",distanceResult/1000.00];
    }
    else
    {
        _getPackageDistanceLb.text= [NSString stringWithFormat:@"%.1f m",distanceResult];
    }
    
    _distanceLb.text           = [NSString stringWithFormat:@"%@km",[_dataSource objectForKey:@"kilometerNumber"]];
    _noteLb.text               = [_dataSource objectForKey:@"memoInfo"];


}

#pragma mark utility
-(double)distanceBetweenOrderBy:(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2{
    
    CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    double distance  = [curLocation distanceFromLocation:otherLocation];
    return distance;
}


@end
