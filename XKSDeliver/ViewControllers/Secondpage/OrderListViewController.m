//
//  OrderListViewController.m
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/21.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import "OrderListViewController.h"
#import "common.h"
#import "historyOrderCell.h"
#import "waitingOrderCell.h"
#import "NetWorkTool.h"
#import "pushOrderDetailController.h"
#import "historyOrderDetailViewController.h"
#import "MJRefresh.h"
#import <CoreLocation/CoreLocation.h>
#import "SignDateResultVc.h"

typedef enum : NSUInteger {
    SORT_BY_TIME = 1000,
    SORT_BY_DISTANCE,
    SORT_BY_MONEY,
    SORT_BY_AWARDRATE,
    SORT_BY_PAYMETHOD,
} SORTTYPE;

NSInteger defaultPageNum = 1;
NSInteger orderPageNum   = 1;
NSInteger inStorePageNum = 1;
NSInteger awardPageNum   = 1;

//请求页逻辑处理
BOOL GoDidLoad = YES;
BOOL OrderGodidload = YES;

@interface OrderListViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

{
    NSInteger SORT;
}
@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    defaultPageNum = 1;
    GoDidLoad      = YES;
    OrderGodidload = YES;
    [self deployUI];
    if ([_fromWhich isEqualToString:id_historyorder]) {
        [self headerRefresh];
        [self footerRefresh];
    }
    [self deployIfToAssignDetail];
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    if ([_fromWhich isEqualToString:id_historyorder]) {

    }else if ([_fromWhich isEqualToString:id_waitingorder])
    {
        [self headerRefresh];
        [self footerRefresh];
    }else if ([_fromWhich isEqualToString:id_instoreorder])
    {
        [self headerRefresh];
        [self footerRefresh];
    }
    else if ([_fromWhich isEqualToString:id_awardorder])
    {
        [self headerRefresh];
        [self footerRefresh];
    }
    if ([_displayMethod isEqualToString:@"present"]) {
        _orderListTableToBottom.constant = 0;
    }
    [self listeningOrderStatus];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)deployIfToAssignDetail
{
    if ([_fromWhich isEqualToString:id_waitingorder]) {
        if ([_ifAutoAssignOrder isEqualToString:@"yes"]) {
            //直接看列表的待接订单
        }
        else if ([_ifAutoAssignOrder isEqualToString:@"no"])
        {
            pushOrderDetailController *assignOrderDetail = [[pushOrderDetailController alloc]init];
            assignOrderDetail.dataSource = [[SystemConfig shareSystemConfig]getWaitingOrderListFromRunningData][0];
            assignOrderDetail.fromWhich = @"CellToAssignOrder";
            assignOrderDetail.orderId   = [[[SystemConfig shareSystemConfig]getWaitingOrderListFromRunningData][0]valueForKey:@"orderId"];
            assignOrderDetail.dataSource = [[SystemConfig shareSystemConfig]getWaitingOrderListFromRunningData][0];
            [self presentViewController:assignOrderDetail animated:NO completion:^{
                
            }];
        }
    }
    
}

-(void)listeningOrderStatus
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(upDateOrder:) name:_NOTIFICATION_NAME_ object:nil];
    
}
-(void)upDateOrder:(NSNotification *)notification
{
    [_OrderListTableView reloadData];
}


-(void)deployUI
{
    if ([_fromWhich isEqualToString:id_historyorder])
    {
        _selectTypeBoard.hidden = YES;
        _settingBt.hidden       = YES;
        _serviceBt.hidden       = NO;
        _checkOrderNumBackView.hidden = NO;
    }else if ([_fromWhich isEqualToString:id_waitingorder])
    {
        if ([[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"1"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"3"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"4"])
        {
            _leadingToDistanceForAwardmoney.constant = -(_SCREEN_WIDTH_ - 20 - 3)/4;
        }
        _selectTypeBoard.hidden = NO;
        _settingBt.hidden       = NO;
        _serviceBt.hidden       = YES;
        _orderListTableToBar.constant = _selectTypeBoard.frame.size.height;
        
        [_settingBt setTitle:[NSString stringWithFormat:@"⊙ %@公里",[[SystemConfig shareSystemConfig]getDistanceToStartAddress]] forState:UIControlStateNormal];
        
        _chooseMileAction = [[UIActionSheet alloc]initWithTitle:@"设置查看范围" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"2公里内",@"4公里内",@"6公里内",nil];
        
    }else if ([_fromWhich isEqualToString:id_instoreorder])
    {
        _leadingToDistanceForAwardmoney.constant = -(_SCREEN_WIDTH_ - 20 - 3)/4;
        _selectTypeBoard.hidden = NO;
        _orderListTableToBar.constant = _selectTypeBoard.frame.size.height;

    }else if ([_fromWhich isEqualToString:id_awardorder])
    {
        _leadingToDistanceForAwardmoney.constant = -(_SCREEN_WIDTH_ - 20 - 3)/4;
        _selectTypeBoard.hidden = NO;
        _orderListTableToBar.constant = _selectTypeBoard.frame.size.height;
    }
    
    _OrderListTableView.delegate    = self;
    _OrderListTableView.dataSource  = self;
    _OrderListTableView.frame = CGRectMake(0, _OrderListTableView.top, WIDTH, HEIGHT-_OrderListTableView.top);
    _OrderListTableView.tableFooterView = [[UIView alloc]init];
    _OrderListTableView.backgroundColor = ROOT_VIEW_BGCOLOR;
    if ([_fromWhich isEqualToString:id_waitingorder]) {
        [_OrderListTableView registerNib:[UINib nibWithNibName:@"waitingOrder" bundle:nil] forCellReuseIdentifier:@"waitingOrderCell"];
    }
    else if ([_fromWhich isEqualToString:id_historyorder])
    {
        [_OrderListTableView registerNib:[UINib nibWithNibName:@"historyOrder" bundle:nil] forCellReuseIdentifier:@"historyOrderCell"];
    }else if ([_fromWhich isEqualToString:id_instoreorder])
    {
        [_OrderListTableView registerNib:[UINib nibWithNibName:@"waitingOrder" bundle:nil] forCellReuseIdentifier:@"waitingOrderCell"];

    }else if ([_fromWhich isEqualToString:id_awardorder])
    {
        [_OrderListTableView registerNib:[UINib nibWithNibName:@"waitingOrder" bundle:nil] forCellReuseIdentifier:@"waitingOrderCell"];
    }
    _barTitleLb.text  = _fromWhich;
}
#pragma mark footer and header Refresh
- (void)headerRefresh
{
    __weak __typeof(self) this = self;
    _OrderListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:this refreshingAction:@selector(refreshFromHeader)];
    [_OrderListTableView.mj_header beginRefreshing];
}
-(void)refreshFromHeader
{
    
    if ([_fromWhich isEqualToString:id_historyorder]) {
        defaultPageNum = 1;
        [self connectHistoryOrderData];
    }else if ([_fromWhich isEqualToString:id_waitingorder])
    {
        orderPageNum = 1;
        [self connectWaitingOrderData];
    }else if ([_fromWhich isEqualToString:id_instoreorder])
    {
        [self connectInStoreOrderDataFromHeader:YES];
    }else if ([_fromWhich isEqualToString:id_awardorder])
    {
        [self connectAwardOrderDataWith:YES];
    }
}
- (void)footerRefresh
{
    __weak __typeof(self) this = self;
    _OrderListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:this refreshingAction:@selector(refreshFromFooter)];
}
-(void)refreshFromFooter
{
    if ([_fromWhich isEqualToString:id_historyorder]) {
        if (GoDidLoad == YES) {
        }else
        {
            defaultPageNum ++;
        }
        [self connectHistoryOrderData];
    }
    else if ([_fromWhich isEqualToString:id_waitingorder])
    {
        if (OrderGodidload == YES) {
            
        }else
        {
            orderPageNum ++;
        }
        [self connectWaitingOrderData];
    }
    else if ([_fromWhich isEqualToString:id_instoreorder])
    {
        [self connectInStoreOrderDataFromHeader:NO];
    }
    else if ([_fromWhich isEqualToString:id_awardorder])
    {
        [self connectAwardOrderDataWith:NO];
    }
}

#pragma mark uitableview delegate datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_fromWhich isEqualToString:id_waitingorder]) {
        return waitingCellHeight;
    }
    else if ([_fromWhich isEqualToString:id_historyorder])
    {
        return _HistoryCellHight_;
    }else if ([_fromWhich isEqualToString:id_instoreorder])
    {
        return waitingCellHeight;
    }else if ([_fromWhich isEqualToString:id_awardorder])
    {
        return waitingCellHeight;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if ([_fromWhich isEqualToString:id_historyorder]) {
        historyOrderDetailViewController *historyOrderDetailView = [[historyOrderDetailViewController alloc]init];
        historyOrderDetailView.orderNumber = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"id"];
        historyOrderDetailView.fromWhich = @"OrderListViewController";
        [self.navigationController pushViewController: historyOrderDetailView animated:YES];
    }else if ([_fromWhich isEqualToString:id_waitingorder])
    {
        pushOrderDetailController *pushWaitOrderView = [[pushOrderDetailController alloc]init];
        pushWaitOrderView.fromWhich = @"OrderListViewController";
        pushWaitOrderView.orderId   = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"orderId"];
        // add mark for all order
        [self addMarkForOrderAt:indexPath.row];
        [self.navigationController pushViewController:pushWaitOrderView animated:YES];
        
        if ([_displayMethod isEqualToString:@"present"]) {
            pushWaitOrderView.displayMethod = @"present";
            [self presentViewController:pushWaitOrderView animated:YES completion:^{
            }];
        }
    }
    else if ([_fromWhich isEqualToString:id_instoreorder]||[_fromWhich isEqualToString:id_awardorder])
    {
        pushOrderDetailController *pushWaitOrderView = [[pushOrderDetailController alloc]init];
        pushWaitOrderView.fromWhich = @"OrderListViewController";
        pushWaitOrderView.orderId   = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"orderId"];
        // add mark for all order
        [self addMarkForOrderAt:indexPath.row];
        [self.navigationController pushViewController:pushWaitOrderView animated:YES];
        
        if ([_displayMethod isEqualToString:@"present"]) {
            pushWaitOrderView.displayMethod = @"present";
            [self presentViewController:pushWaitOrderView animated:YES completion:^{
                
            }];
        }
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_fromWhich isEqualToString:id_historyorder]) {
        historyOrderCell *historyordercell = [tableView dequeueReusableCellWithIdentifier:@"historyOrder"];
        historyordercell = [[NSBundle mainBundle]loadNibNamed:@"historyOrderCell" owner:self options:nil][0];
        historyordercell.startAddressLb.text = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"reservedPlace"];
        historyordercell.endAddressLb.text   = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"targetAddress"];
        //status
        if ([[[[_dataSource objectAtIndex:indexPath.row]valueForKey:@"status"]stringValue]isEqualToString:@"4"]) {
            historyordercell.orderStateLb.text = @"已经完成";
        }else
        {
            historyordercell.orderStateLb.text = [[[_dataSource objectAtIndex:indexPath.row]valueForKey:@"status"]stringValue];
        }
        historyordercell.orderPriceLb.text     = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"driverDeductScale"];
        
        if ([[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"1"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"3"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"4"])
        {
            historyordercell.orderPriceLbTitleLb.hidden = YES;
            historyordercell.orderPriceLb.hidden        = YES;
            historyordercell.topToAwardMoneyLb.constant = -20;
            historyordercell.topToAwardMoneyNumLb.constant = -10;
        }
        return historyordercell;
    }
    else if ([_fromWhich isEqualToString:id_waitingorder]||[_fromWhich isEqualToString:id_instoreorder]||[_fromWhich isEqualToString:id_awardorder])
    {
        waitingOrderCell *waitingordercell = [tableView dequeueReusableCellWithIdentifier:@"waitingOrder"];
        waitingordercell = [[NSBundle mainBundle]loadNibNamed:@"waitingOrderCell" owner:self options:nil][0];

        if ([[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"1"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"3"]||[[[SystemConfig  shareSystemConfig]getDeliverType]isEqualToString:@"4"])
        {
           // waitingordercell.leadingToDistanceForAwardMoneyLb.constant = -(_SCREEN_WIDTH_ - 20-3)/4;
            waitingordercell.leadingToDistanceForAwardMoneyLb.constant = -(_SCREEN_WIDTH_ - 20)/4;
            waitingordercell.awardRageLb.hidden = YES;
            waitingordercell.grayline2.hidden   = YES;
            waitingordercell.endAddressImage.hidden = YES;
            waitingordercell.endAddressLb.hidden    = YES;
        }
        //deal time
        NSString *time     =[[_dataSource objectAtIndex:indexPath.row]valueForKey:@"operateTime"];
        NSArray *timeArray = [[time componentsSeparatedByString:@" "][1] componentsSeparatedByString:@":"];
        NSString *timeStringHoursAndMinutes = [NSString stringWithFormat:@"%@:%@",timeArray[0],timeArray[1]];
        waitingordercell.timeLb.text = timeStringHoursAndMinutes;
        //deal distance
        NSString *locateString   = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"reservedCoordinate"];
        
        NSArray *latitudeAndLongtitude = [locateString componentsSeparatedByString:@","];
        
        double latiStartLocation = [[latitudeAndLongtitude firstObject]doubleValue];
        double latiMyLocation    = [[[SystemConfig  shareSystemConfig]getUserLocationLatitude]doubleValue];
        
        double longtiStartLocation = [[latitudeAndLongtitude lastObject]doubleValue];
        double longtiMyLocation    = [[[SystemConfig shareSystemConfig]getUserLocationLongtitude]doubleValue];
        //(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2
        
        double distanceResult      = [self distanceBetweenOrderBy:latiStartLocation  :latiMyLocation :longtiStartLocation :longtiMyLocation];
        
        NSString *distanceResultString;
        
        if (distanceResult > 1000) {
            distanceResultString = [NSString stringWithFormat:@"%.1fkm",distanceResult/1000.00];
        }
        else
        {
            distanceResultString= [NSString stringWithFormat:@"%.fm",distanceResult];
        }
        if ([locateString isEqualToString:@""]||locateString == nil||[locateString isEqual:[NSNull null]]) {
            waitingordercell.distanceLb.text = @"--";
        }else
        {
            waitingordercell.distanceLb.text = distanceResultString;
        }

        waitingordercell.awardRageLb.text = [NSString stringWithFormat:@"%@元",[[_dataSource objectAtIndex:indexPath.row]valueForKey:@"driverDeductScale"]];
        
        if ([[[_dataSource objectAtIndex:indexPath.row]valueForKey:@"mailPayment"]isEqualToString:@"1"]) {
            waitingordercell.payMethodLb.text = @"到付";
        }else if ([[[_dataSource objectAtIndex:indexPath.row]valueForKey:@"mailPayment"]isEqualToString:@"0"])
        {
            waitingordercell.payMethodLb.text = @"寄付";
        }
        waitingordercell.startAddressLb.text = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"reservedPlace"];
        waitingordercell.endAddressLb.text = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"targetAddress"];
        waitingordercell.itemNameLb.text = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"itemName"];
        
        //read or not
        if ([[[_dataSource objectAtIndex:indexPath.row]valueForKey:@"read"]isEqualToString:@"yes"]) {
            waitingordercell.tipDotImageView.hidden = YES;
        }else
        {
            waitingordercell.tipDotImageView.hidden = NO;
        }
        
        return waitingordercell;
    }
    
    return 0;
}
- (IBAction)returnBtClicked:(UIButton *)sender {
    if ([_fromWhich isEqualToString:id_waitingorder]) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:NO];
  
    }
    if ([_displayMethod isEqualToString:@"present"]) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}
- (IBAction)settingBtClicked:(UIButton *)sender {
    [_chooseMileAction showFromTabBar:self.tabBarController.tabBar];
}

- (IBAction)servicePhoneNum:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"拨打客服号码咨询" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    [alert show];
}
#pragma mark alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex  == 0) {
        NSURL *servicePhoneNumberUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[[SystemConfig shareSystemConfig]getServiceNumber]]]; 
        [[UIApplication sharedApplication]openURL:servicePhoneNumberUrl];
    }
}
#pragma mark actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [_settingBt setTitle:[NSString stringWithFormat:@"⊙ %@公里",_DISTANCE_1_] forState:UIControlStateNormal];
        [[SystemConfig shareSystemConfig]saveDistanceToStartAddress:_DISTANCE_1_];
        [self headerRefresh];
    }else if (buttonIndex == 1)
    {
        [_settingBt setTitle:[NSString stringWithFormat:@"⊙ %@公里",_DISTANCE_2_] forState:UIControlStateNormal];
        [[SystemConfig shareSystemConfig]saveDistanceToStartAddress:_DISTANCE_2_];
        [self headerRefresh];
    }else if (buttonIndex == 2)
    {
        [_settingBt setTitle:[NSString stringWithFormat:@"⊙ %@公里",_DISTANCE_3_] forState:UIControlStateNormal];
        [[SystemConfig shareSystemConfig]saveDistanceToStartAddress:_DISTANCE_3_];
        [self headerRefresh];
    }
}

- (IBAction)selectedButtonClicked:(UIButton *)sender {
    SORT = sender.tag;
    switch (SORT) {
        case SORT_BY_TIME:
            [self sortOrderByTime];
            break;
        case SORT_BY_DISTANCE:
            [self sortOrderByDistance];
            break;
        case SORT_BY_MONEY:
            [self sortOrderByMoney];
            break;
        case SORT_BY_AWARDRATE:
            [self sortOrderByAwardRate];
            break;
        case SORT_BY_PAYMETHOD:
            [self sortOrderByPayMethod];
            break;
        default:
            break;
    }
}
-(void)sortOrderByTime
{
    NSLog(@"1");
    if ([_fromWhich isEqualToString:id_instoreorder]) {
        
    }
}
-(void)sortOrderByDistance
{
    NSLog(@"2");
}
-(void)sortOrderByMoney
{
    NSLog(@"3");
}
-(void)sortOrderByAwardRate
{
    NSLog(@"4");
}
-(void)sortOrderByPayMethod
{
    NSLog(@"5");
}

#pragma mark utility
-(double)distanceBetweenOrderBy:(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2{
    
    CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    double distance  = [curLocation distanceFromLocation:otherLocation];
    return distance;
}
-(void)addMarkForOrderAt:(NSInteger)indexInList
{
    NSArray *localArray;
    
    if ([_fromWhich isEqualToString:id_waitingorder]) {
       
         localArray = [[SystemConfig shareSystemConfig]getWaitingOrderList];

    }else if ([_fromWhich isEqualToString:id_instoreorder])
    {
        localArray = [[SystemConfig shareSystemConfig]getInStoreOrderList];
    }
    
    NSMutableArray *newArray = [[NSMutableArray alloc]init];
    
    NSInteger i = -1;
    
    for (NSMutableDictionary *dict in localArray) {
        i++;
        if (i == indexInList) {
            [dict setValue:@"yes" forKey:@"read"];
        }else if (![[dict valueForKey:@"read"]isEqualToString:@"yes"])
        {
            [dict setValue:@"no" forKey:@"read"];
        }
        [newArray addObject:dict];
    }
    if ([_fromWhich isEqualToString:id_waitingorder]) {
        [[SystemConfig shareSystemConfig]saveWaitingOrderList:newArray];
    }else{
        [[SystemConfig shareSystemConfig]saveInStoreOrderList:newArray];
    }
    
}

-(void)compareAndDealTheWaitingOrderDataWithList:(NSArray *)orderList
{
    NSMutableArray *oldArray;
    NSArray *oldcompareArray;
    NSArray *newArray;
    NSArray *newcompareArray;
    NSString *totalString1 = @"";
    if ([_fromWhich isEqualToString:id_waitingorder]||[_fromWhich isEqualToString:id_awardorder]) {
        
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
        
    }else if ([_fromWhich isEqualToString:id_instoreorder])
    {
        if ([[[SystemConfig shareSystemConfig]getIfFirstGetInStoreOrderList]isEqualToString:@"no"]) {
            if ([[SystemConfig shareSystemConfig]getInStoreOrderList].count == 0 ) {
                [[SystemConfig shareSystemConfig]saveInStoreOrderList:orderList];
            }
        }else
        {
            [[SystemConfig shareSystemConfig]saveInStoreOrderList:orderList];
            [[SystemConfig shareSystemConfig]saveIFFirstTimeGetInStoreOrderList:@"no"];
        }
         oldArray = [[NSMutableArray alloc]initWithArray:[[SystemConfig shareSystemConfig]getInStoreOrderList]];
         oldcompareArray = [[SystemConfig shareSystemConfig]getInStoreOrderList];
         newArray = orderList;
         newcompareArray = [[SystemConfig shareSystemConfig]getInStoreOrderList];
         totalString1 = @"";
    }
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
    if ([_fromWhich isEqualToString:id_waitingorder]||[_fromWhich isEqualToString:id_awardorder]) {
        
        [[SystemConfig shareSystemConfig]saveWaitingOrderList:oldArray];

    }else if ([_fromWhich isEqualToString:id_instoreorder])
    {
        [[SystemConfig shareSystemConfig]saveInStoreOrderList:oldArray];
    }
}

#pragma mark network

-(void)connectInStoreOrderDataFromHeader:(BOOL)header
{
    if (header == YES) {
        inStorePageNum = 1;
    }
    [NetWorkTool getRequestWithUrl:__waitingInstoreOrder totalParam:@{@"driverImei":[[SystemConfig shareSystemConfig]getDeviceToken],@"pageNo":[NSString stringWithFormat:@"%ld",(long)inStorePageNum]} addProgressHudOn:self.view Tip:@"获取驻店订单" successReturn:^(id successReturn) {
        
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        if ([[jsonDict valueForKey:@"result"]isEqualToString:@"false"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.removeFromSuperViewOnHide =YES;
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [jsonDict valueForKey:@"msg"];
            hud.minSize = CGSizeMake(108.f, 108.0f);
            [hud hide:YES afterDelay:HudDelayTime];
            _dataSource = @[];
            [_OrderListTableView reloadData];
            [_OrderListTableView.mj_header endRefreshing];
            [_OrderListTableView.mj_footer endRefreshing];
        }
        else
        {
            if (header == YES) {
                inStorePageNum = 1;
            }else if (header == NO)
            {
                inStorePageNum ++;
            }
            _dataSource = [jsonDict valueForKey:@"orderInfos"];
            
            NSMutableArray *realTestArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dict in _dataSource) {
                NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
                [realTestArray addObject:mutableDict];
            }
            
            [self compareAndDealTheWaitingOrderDataWithList:realTestArray];
            
            _dataSource = [[SystemConfig shareSystemConfig]getInStoreOrderList];
            [_OrderListTableView reloadData];
            OrderGodidload = NO;
            [_OrderListTableView.mj_header endRefreshing];
            if ([[jsonDict valueForKey:@"isMore"]isEqualToString:@"false"]) {
                [_OrderListTableView.mj_footer endRefreshingWithNoMoreData];
            }else
            {
                [_OrderListTableView.mj_footer endRefreshing];
            }
        }
    } failed:^(id failed) {
        
    }];
}

-(void)connectAwardOrderDataWith:(BOOL)header
{
    if (header == YES)
    {
        awardPageNum = 1;
        [NetWorkTool getRequestWithUrl:__awardOrder totalParam:@{@"driverImei":[[SystemConfig shareSystemConfig]getDeviceToken],@"pageNo":[NSString stringWithFormat:@"%ld",(long)awardPageNum]} addProgressHudOn:self.view Tip:@"获取抽奖订单" successReturn:^(id successReturn) {
            
            NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//            NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

            if ([[jsonDict valueForKey:@"result"]isEqualToString:@"false"]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.removeFromSuperViewOnHide =YES;
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [jsonDict valueForKey:@"msg"];
                hud.minSize = CGSizeMake(108.f, 108.0f);
                [hud hide:YES afterDelay:HudDelayTime];
                _dataSource = @[];
                [_OrderListTableView reloadData];
                [_OrderListTableView.mj_header endRefreshing];
                [_OrderListTableView.mj_footer endRefreshing];
            }
            else
            {
                awardPageNum ++;
                
                _dataSource = [jsonDict valueForKey:@"orderInfos"];
                
                NSMutableArray *realTestArray = [[NSMutableArray alloc]init];
                for (NSDictionary *dict in _dataSource) {
                    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
                    [realTestArray addObject:mutableDict];
                }
                [self compareAndDealTheWaitingOrderDataWithList:realTestArray];
                _dataSource = [[SystemConfig shareSystemConfig]getWaitingOrderList];
                [_OrderListTableView reloadData];
                OrderGodidload = NO;
                [_OrderListTableView.mj_header endRefreshing];
                if ([[jsonDict valueForKey:@"isMore"]isEqualToString:@"false"]) {
                    [_OrderListTableView.mj_footer endRefreshingWithNoMoreData];
                }else
                {
                    [_OrderListTableView.mj_footer endRefreshing];
                }
            }
        } failed:^(id failed) {
            
        }];
    }else
    {
        [NetWorkTool getRequestWithUrl:__awardOrder totalParam:@{@"driverImei":[[SystemConfig shareSystemConfig]getDeviceToken],@"pageNo":[NSString stringWithFormat:@"%ld",(long)awardPageNum]} addProgressHudOn:self.view Tip:@"获取抽奖订单" successReturn:^(id successReturn) {
            
            NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//            NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

            if ([[jsonDict valueForKey:@"result"]isEqualToString:@"false"]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.removeFromSuperViewOnHide =YES;
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [jsonDict valueForKey:@"msg"];
                hud.minSize = CGSizeMake(108.f, 108.0f);
                [hud hide:YES afterDelay:HudDelayTime];
                _dataSource = @[];
                [_OrderListTableView reloadData];
                [_OrderListTableView.mj_header endRefreshing];
                [_OrderListTableView.mj_footer endRefreshing];
            }
            else
            {
                if (header == YES) {
                    awardPageNum = 1;
                }else if (header == NO)
                {
                    awardPageNum ++;
                }
                _dataSource = [jsonDict valueForKey:@"orderInfos"];
                
                NSMutableArray *realTestArray = [[NSMutableArray alloc]init];
                for (NSDictionary *dict in _dataSource) {
                    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
                    [realTestArray addObject:mutableDict];
                }
                [self compareAndDealTheWaitingOrderDataWithList:realTestArray];
                
                _dataSource = [[SystemConfig shareSystemConfig]getWaitingOrderList];
                [_OrderListTableView reloadData];
                OrderGodidload = NO;
                [_OrderListTableView.mj_header endRefreshing];
                if ([[jsonDict valueForKey:@"isMore"]isEqualToString:@"false"]) {
                    [_OrderListTableView.mj_footer endRefreshingWithNoMoreData];
                }else
                {
                    [_OrderListTableView.mj_footer endRefreshing];
                }
            }
        } failed:^(id failed) {
            
        }];

    }
}

-(void)connectHistoryOrderData
{
    //__weak typeof(self) this = self;
    NSDateFormatter *paramDateFormatter = [[NSDateFormatter alloc]init];
    [paramDateFormatter setDateFormat:@"yyyy-MM-dd"];
    [NetWorkTool getRequestWithUrl:__historyOrder param:@{@"yearMonth":[paramDateFormatter stringFromDate:[NSDate date]],@"startDate":@"",@"endDate":@"",@"pageNo":[NSString stringWithFormat:@"%ld",(long)defaultPageNum]} addProgressHudOn:self.view Tip:@"获取历史订单" successReturn:^(id successReturn) {
        
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        
        _dataSource = [jsonDict valueForKey:@"orders"];
        
        if (_dataSource.count == 0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.removeFromSuperViewOnHide =YES;
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"暂无历史订单";
            hud.minSize = CGSizeMake(108.f, 108.0f);
            [hud hide:YES afterDelay:HudDelayTime];
            _dataSource = @[];
            [_OrderListTableView reloadData];
            [_OrderListTableView.mj_header endRefreshing];
            [_OrderListTableView.mj_footer endRefreshing];
            
        }else{
            [_OrderListTableView  reloadData];
        }
        
        GoDidLoad = NO;
        
        if ([[jsonDict valueForKey:@"more"]isEqualToString:@"false"]){
            [_OrderListTableView.mj_footer endRefreshingWithNoMoreData];
            
            if (_dataSource.count > 5) {
                 [_OrderListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
        else
        {
            [_OrderListTableView.mj_footer endRefreshing];

            //            [_OrderListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        [_OrderListTableView.mj_header endRefreshing];
        
    } failed:^(id failed) {
        [_OrderListTableView.mj_header endRefreshing];
        [_OrderListTableView.mj_footer endRefreshing];
    }];
}

-(void)connectHistoryOrderDataWithHeader:(BOOL)header
{
    //__weak typeof(self) this = self;
    NSDateFormatter *paramDateFormatter = [[NSDateFormatter alloc]init];
    [paramDateFormatter setDateFormat:@"yyyy-MM-dd"];
    [NetWorkTool getRequestWithUrl:__historyOrder param:@{@"yearMonth":[paramDateFormatter stringFromDate:[NSDate date]],@"startDate":@"",@"endDate":@"",@"pageNo":[NSString stringWithFormat:@"%ld",(long)defaultPageNum]} addProgressHudOn:self.view Tip:@"获取历史订单" successReturn:^(id successReturn) {
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        _dataSource = [jsonDict valueForKey:@"orders"];
        [_OrderListTableView  reloadData];
        
        GoDidLoad = NO;
        
        if ([[jsonDict valueForKey:@"more"]isEqualToString:@"false"]){
            [_OrderListTableView.mj_footer endRefreshingWithNoMoreData];
            [_OrderListTableView scrollsToTop];
        }
        else
        {
            [_OrderListTableView.mj_footer endRefreshing];
        }
        [_OrderListTableView.mj_header endRefreshing];
        [_OrderListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    } failed:^(id failed) {
        [_OrderListTableView.mj_header endRefreshing];
        [_OrderListTableView.mj_footer endRefreshing];
    }];
}

-(void)connectWaitingOrderDataWithHeader:(BOOL)header
{
    //__weak typeof(self) this = self;
    [NetWorkTool getRequestWithUrl:__waitingOrder totalParam:@{@"driverImei":[[SystemConfig shareSystemConfig]getDeviceToken],@"pageNo":[NSString stringWithFormat:@"%ld",(long)defaultPageNum],@"kilometerNumber":[[SystemConfig shareSystemConfig]getDistanceToStartAddress],} addProgressHudOn:self.view Tip:@"获取待接订单" successReturn:^(id successReturn) {
        
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        //后台强制指派订单需要先显示
        if ([[SystemConfig shareSystemConfig]getWaitingOrderListFromRunningData].count != 0) {
            _dataSource = [[SystemConfig shareSystemConfig]getWaitingOrderListFromRunningData];
            
            NSMutableArray *realTestArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dict in _dataSource) {
                NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
                [realTestArray addObject:mutableDict];
            }
            
            [self compareAndDealTheWaitingOrderDataWithList:realTestArray];
            
            _dataSource = [[SystemConfig shareSystemConfig]getWaitingOrderList];
            
            [_OrderListTableView reloadData];
            OrderGodidload = NO;
            
            [_OrderListTableView.mj_header endRefreshing];
            
        }
        else
        {
            //自动派单订单
            if ([[jsonDict valueForKey:@"result"]isEqualToString:@"false"]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.removeFromSuperViewOnHide =YES;
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [jsonDict valueForKey:@"msg"];
                hud.minSize = CGSizeMake(108.f, 108.0f);
                [hud hide:YES afterDelay:HudDelayTime];
                _dataSource = @[];
                [_OrderListTableView reloadData];
                [_OrderListTableView.mj_header endRefreshing];
                [_OrderListTableView.mj_footer endRefreshing];
            }
            else
            {
                _dataSource = [jsonDict valueForKey:@"orderInfos"];
                
                NSMutableArray *realTestArray = [[NSMutableArray alloc]init];
                for (NSDictionary *dict in _dataSource) {
                    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
                    [realTestArray addObject:mutableDict];
                }
                
                [self compareAndDealTheWaitingOrderDataWithList:realTestArray];
                
                _dataSource = [[SystemConfig shareSystemConfig]getWaitingOrderList];
                
                [_OrderListTableView reloadData];
                OrderGodidload = NO;
                
                [_OrderListTableView.mj_header endRefreshing];
                if ([[jsonDict valueForKey:@"isMore"]isEqualToString:@"false"]) {
                    [_OrderListTableView.mj_footer endRefreshingWithNoMoreData];
                }else
                {
                    [_OrderListTableView.mj_footer endRefreshing];
                }

            }
        }
        if ([[jsonDict valueForKey:@"isMore"]isEqualToString:@"false"]) {
            [_OrderListTableView.mj_footer endRefreshingWithNoMoreData];
        }
        else{
            [_OrderListTableView.mj_footer endRefreshing];
        }
        
    } failed:^(id failed) {
        [_OrderListTableView.mj_header endRefreshing];
        [_OrderListTableView.mj_footer endRefreshing];
        NSLog(@"get waiting order error %@",failed);
    }];
    
}

-(void)connectWaitingOrderData
{
    //__weak typeof(self) this = self;
    [NetWorkTool getRequestWithUrl:__waitingOrder totalParam:@{@"driverImei":[[SystemConfig shareSystemConfig]getDeviceToken],@"pageNo":[NSString stringWithFormat:@"%ld",(long)defaultPageNum],@"kilometerNumber":[[SystemConfig shareSystemConfig]getDistanceToStartAddress],} addProgressHudOn:self.view Tip:@"获取待接订单" successReturn:^(id successReturn) {
        
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

         //自动派单订单
            if ([[jsonDict valueForKey:@"result"]isEqualToString:@"false"]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.removeFromSuperViewOnHide =YES;
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [jsonDict valueForKey:@"msg"];
                hud.minSize = CGSizeMake(108.f, 108.0f);
                [hud hide:YES afterDelay:HudDelayTime];
                _dataSource = @[];
                [_OrderListTableView reloadData];
                [_OrderListTableView.mj_header endRefreshing];
                [_OrderListTableView.mj_footer endRefreshing];
            }
            else
            {
                _dataSource = [jsonDict valueForKey:@"orderInfos"];
                
                NSMutableArray *realTestArray = [[NSMutableArray alloc]init];
                for (NSDictionary *dict in _dataSource) {
                    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
                    [realTestArray addObject:mutableDict];
                }
                
                [self compareAndDealTheWaitingOrderDataWithList:realTestArray];
                
                _dataSource = [[SystemConfig shareSystemConfig]getWaitingOrderList];
                
                [_OrderListTableView reloadData];
                OrderGodidload = NO;
                
                [_OrderListTableView.mj_header endRefreshing];
                if ([[jsonDict valueForKey:@"isMore"]isEqualToString:@"false"]) {
                    [_OrderListTableView.mj_footer endRefreshingWithNoMoreData];
                }else
                {
                    [_OrderListTableView.mj_footer endRefreshing];
                }
            }
        
        if ([[jsonDict valueForKey:@"isMore"]isEqualToString:@"false"]) {
            [_OrderListTableView.mj_footer endRefreshingWithNoMoreData];
        }
        else{
            [_OrderListTableView.mj_footer endRefreshing];
        }
        
    } failed:^(id failed) {
        [_OrderListTableView.mj_header endRefreshing];
        [_OrderListTableView.mj_footer endRefreshing];
        NSLog(@"get waiting order error %@",failed);
    }];

}
-(void)dealloc
{
    _OrderListTableView.mj_header = nil;
    _OrderListTableView.mj_footer = nil;
}


- (IBAction)checkOrderNumPerDay:(UIButton *)sender {
    
    SignDateResultVc *orderNumPerDayView = [[SignDateResultVc alloc]init];
    orderNumPerDayView.fromWhich = @"orderlist";
    [self.navigationController pushViewController:orderNumPerDayView animated:YES];
    
}
@end
