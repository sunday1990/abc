//
//  ViewController.m
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/10.
//  Copyright © 2015年 同行必达. All rights reserved.
//



#import "OrderViewController.h"
#import "common.h"
#import "LoginViewController.h"
#import "RunningOrderCell.h"
#import "pushOrderToListCell.h"
#import "OrderDetailViewController.h"
#import "OrderListViewController.h"
#import "NetWorkTool.h"
#import "MJRefresh.h"

#import "SaveUUIDinKeychain.h"
#import "PDKeychainBindings.h"
#import "noticeDetailController.h"
#import "AppDelegate.h"

#import "ActViewController.h"
#import "QRCodeViewController.h"

#define kAlphaNum  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define kAlpha      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define kNumbers     @"0123456789"
#define kNumbersPeriod  @"0123456789."

static NSString *runingCellreuseIdentifer = @"RunningCell";
static NSString *pushCellreuseIdentifer   = @"PushCell";

@interface OrderViewController ()<UIAlertViewDelegate,UIScrollViewDelegate,JugeLogin,UITextFieldDelegate>
{

    NSString *orderSerialNo;//订单编号，用户自己输入的
    NSString *customerId;   //店家id扫描获得的
    NSDictionary *itemDic;
    BOOL alertOnShow;
}

@property (nonatomic, strong)OrderDetailViewController *orderDetailVC;
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _historyNum = @"0";
    [self TologinView];
    
    [self deployBasicLayout];
    
//    [self setupAlertController];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self closeChangeStatusView];
    _signInOrOutBack.hidden = YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    if (!alertOnShow) {
        [self connectHistoryOrderCompeletedNumData];
        [self orderInfoChangeListening];
    }
}


//定义UITextFiled的代理方法：
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    NSString *filtered =
    [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [string isEqualToString:filtered];
    return basic;
}

-(void)orderInfoChangeListening
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orderStateChanged:) name:_NOTIFICATION_NAME_ object:nil];
}
-(void)orderStateChanged:(NSNotification *)notification
{
    if ([[notification.object valueForKey:@"notiState"]isEqualToString:_NOTI_CANCEL_ORDER_]||[[notification.object valueForKey:@"notiState"]isEqualToString:_NOTI_UPDATE_ORDER_]) {
        [_orderTableView reloadData];
    }
}
#pragma mark footer and header Refresh
-(void)headerRefresh
{
   // __weak __typeof(self) this = self;
    _orderTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(accountRefreshFromOrderHeader)];
    [_orderTableView.mj_header beginRefreshing];
}
-(void)accountRefreshFromOrderHeader
{
    [self connetRunningOrderData];
}

- (void)setupAlertController{
    // 准备初始化配置参数
    NSString *title = @"扫码订单";
    NSString *message = @"请输入订单编号";
    NSString *okButtonTitle = @"确定";
    NSString *cancelButtonTitile = @"取消";
    // 初始化
    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // 创建文本框
    WEAK(self);
    [alertDialog addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"订单编号";
        textField.delegate = weakself;
        textField.secureTextEntry = NO;
        textField.keyboardType = UIKeyboardTypeAlphabet;
    }];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *userEmail = alertDialog.textFields.firstObject;
        orderSerialNo = userEmail.text;
        [self createScanOrder];
        alertOnShow = NO;
    }];
    
    UIAlertAction *cancelAction= [UIAlertAction actionWithTitle:cancelButtonTitile style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel order");
        UITextField *userEmail = alertDialog.textFields.firstObject;
        userEmail.text = nil;
        orderSerialNo = nil;
        alertOnShow = NO;
 
    }];

    // 添加操作（顺序就是呈现的上下顺序）
    [alertDialog addAction:okAction];
    [alertDialog addAction:cancelAction];
    [self presentViewController:alertDialog animated:YES completion:nil];

}

-(void)TologinView
{
    LoginViewController *loginView = [[LoginViewController alloc]init];
    loginView.Jugedelegate = self;
    [self.navigationController pushViewController:loginView animated:NO];
}
-(void)deployBasicLayout
{
    self.navigationController.navigationBar.hidden = YES;
    [_upRightBt setTitle:[[NSUserDefaults standardUserDefaults]valueForKey:@"signInOrOut"] forState:UIControlStateNormal];
    _signInOrOutBack.layer.cornerRadius = 5;
    if (_dataSource.count == 2) {
        _orderTableView.scrollEnabled = NO;
    }

    [_changStatusBt setTitle:[[SystemConfig shareSystemConfig]getUserStatus] forState:UIControlStateNormal];
    //statusBar backgroundColor
    UIView *statusBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH_,[UIApplication sharedApplication].statusBarFrame.size.height)];
    statusBar.backgroundColor = _TABBAR_BLUE_;
    [self.view addSubview:statusBar];
    
    UIView *chooseStatusView = [[UIView alloc]init];
    chooseStatusView.frame = CGRectMake(10, 64+10, 0, 0);
    chooseStatusView.backgroundColor    = _TABLE_HEADERGREEN_;
    chooseStatusView.layer.cornerRadius = 5;
    chooseStatusView.alpha              = 0.95;
    chooseStatusView.userInteractionEnabled = YES;

    _changeStatusView = chooseStatusView;
    [self.view addSubview:chooseStatusView];
    _orderTableView.backgroundColor = LIGHT_WHITE_COLOR;//ROOT_VIEW_BGCOLOR
    _orderTableView.tableFooterView = [[UIView alloc]init];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark tableview delegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //驻店员工
    if ([[[SystemConfig shareSystemConfig]getIfHasAwardOrder]isEqualToString:@"1"]) {
        if([[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"1"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"3"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"4"]) {
            
            //全职等类型
            if (indexPath.row == _dataSource.count-2 || indexPath.row == _dataSource.count - 1||indexPath.row == _dataSource.count -3||indexPath.row == _dataSource.count -4||indexPath.row == _dataSource.count -5) {
                
                pushOrderToListCell *pushOrderListCell = [tableView dequeueReusableCellWithIdentifier:pushCellreuseIdentifer];
                pushOrderListCell.orderNum.backgroundColor = _TEXT_TIPRED_;
                pushOrderListCell.orderNum.layer.cornerRadius = 15;
                pushOrderListCell.orderNum.layer.masksToBounds = YES;
                pushOrderListCell.orderNum.adjustsFontSizeToFitWidth = YES;
                
                if (indexPath.row == _dataSource.count - 4)
                {
                    pushOrderListCell.orderStateImage.image = LOADIMAGE(@"waiting_Order@2x", @"png");
                    pushOrderListCell.orderStateMainTitle.text = id_waitingorder;
                    pushOrderListCell.orderStateSubTitle.text  = @"当前是否有需要配送的订单";
                    
                    if ([[SystemConfig shareSystemConfig]getWaitingOrderListFromRunningData].count==0) {
                        pushOrderListCell.orderNum.hidden = YES;
                    }else
                    {
                        pushOrderListCell.orderNum.hidden = NO;
                    }
                    pushOrderListCell.orderNum.text = [NSString stringWithFormat:@"指派:%lu",(unsigned long)[[SystemConfig shareSystemConfig]getWaitingOrderListFromRunningData].count];
                }
                else if (indexPath.row == _dataSource.count - 3)
                {
                    pushOrderListCell.orderStateImage.image = LOADIMAGE(@"inStoreOrder@2x",@"png");
                    pushOrderListCell.orderStateMainTitle.text = id_instoreorder;
                    pushOrderListCell.orderStateSubTitle.text  = @"驻店员工的驻店订单在这里";
                    pushOrderListCell.orderNum.hidden          = YES;
                }
                else if (indexPath.row == _dataSource.count -2)
                {
                    pushOrderListCell.orderStateImage.image = LOADIMAGE(@"history_Order@2x", @"png");
                    pushOrderListCell.orderStateMainTitle.text = id_historyorder;
                    pushOrderListCell.orderStateSubTitle.text  = @"完成的订单都在这里";
                    pushOrderListCell.orderNum.hidden = NO;
                    pushOrderListCell.orderNum.backgroundColor = _TEXT_TIPGRAY_;
                    pushOrderListCell.orderNum.text = _historyNum;
                }
                else if (indexPath.row == _dataSource.count - 5)
                {
                    pushOrderListCell.orderStateImage.image  = LOADIMAGE(@"award_order@2x", @"png");
                    pushOrderListCell.orderStateMainTitle.text = @"抽奖订单";
                    pushOrderListCell.orderStateSubTitle.text = @"当前是否有抽奖订单";
                    pushOrderListCell.orderNum.hidden = YES;
                }
                //扫一扫，只有驻点有这个功能
                else if (indexPath.row == _dataSource.count - 1)
                {
                    pushOrderListCell.orderStateImage.image = LOADIMAGE(@"award_order@2x", @"png");
                    pushOrderListCell.orderStateMainTitle.text = id_scan;
                    pushOrderListCell.orderStateSubTitle.text  = @"点击扫一扫订单";
                    pushOrderListCell.orderNum.hidden = YES;
                    pushOrderListCell.orderNum.backgroundColor = _TEXT_TIPGRAY_;
                }
                
                return pushOrderListCell;
            }
            else
            {
                RunningOrderCell *runningOrderCell = [tableView dequeueReusableCellWithIdentifier:runingCellreuseIdentifer];
                
                runningOrderCell.startAddressLabel.text = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"reservedPlace"];
                runningOrderCell.endAddressLabel.text = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"targetAddress"];
                runningOrderCell.orderCodeLabel.text = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"orderNo"];
                
                NSInteger status = [[[_dataSource objectAtIndex:indexPath.row]valueForKey:@"orderTaskStatus"]integerValue];
                NSString *bottomOrderStateStr;
                // 判断订单是否取消
                switch (status) {
                    case 0:
                        runningOrderCell.orderStateLabel.text = @"未接收";
                        break;
                    case 1:
                        runningOrderCell.orderStateLabel.text = @"已接单";
                        bottomOrderStateStr = @"去取件";
                        break;
                    case 2:
                        runningOrderCell.orderStateLabel.text = @"等待上门取件";
                        bottomOrderStateStr = @"已取件";
                        break;
                    case 3:
                        runningOrderCell.orderStateLabel.text = @"已开始服务，前往目的地点";
                        bottomOrderStateStr = @"已送达";
                        break;
                    case 4:
                        runningOrderCell.orderStateLabel.text = @"已取件，正在派送中";
                        break;
                    case 5:
                        runningOrderCell.orderStateLabel.text = @"已申请取消订单，等待确认";
                        break;
                    default:
                        runningOrderCell.orderStateLabel.text = @"未知订单状态";
                        break;
                }
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                
                runningOrderCell.orderSubmitTimeLabel.text = [[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"reservedTime"]componentsSeparatedByString:@" "][1];
                //runningOrderCell.orderSubmitTimeLabel.text = [formatter stringFromDate:date];
                runningOrderCell.dateTimeLabel.text = [[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"reservedTime"]componentsSeparatedByString:@" "][0];
                //orderSourceFlag
                if ([[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"orderSourceFlag"]integerValue]==90) {
                    runningOrderCell.bottomOrderStateLabel.hidden = NO;
                    runningOrderCell.bottomOrderStateLabel.tag = indexPath.row;
                    NSLog(@"tag;%ld",(long)runningOrderCell.bottomOrderStateLabel.tag);
                    [runningOrderCell.bottomOrderStateLabel setTitle:bottomOrderStateStr forState:UIControlStateNormal];
                    [runningOrderCell.bottomOrderStateLabel setTitleColor:LightTextColor forState:UIControlStateNormal];
                    [runningOrderCell.contentView bringSubviewToFront:runningOrderCell.bottomOrderStateLabel];
                }
                return runningOrderCell;
            }
        }
        else
        {
            //众包等类型
            if (indexPath.row == _dataSource.count -1||indexPath.row == _dataSource.count - 2) {
                pushOrderToListCell *pushOrderListCell = [tableView dequeueReusableCellWithIdentifier:pushCellreuseIdentifer];
                pushOrderListCell.orderNum.backgroundColor = _TEXT_TIPRED_;
                pushOrderListCell.orderNum.layer.cornerRadius = 15;
                pushOrderListCell.orderNum.layer.masksToBounds = YES;
                pushOrderListCell.orderNum.adjustsFontSizeToFitWidth = YES;
                
                if (indexPath.row == _dataSource.count - 2)
                {
                    pushOrderListCell.orderStateImage.image = LOADIMAGE(@"waiting_Order@2x", @"png");
                    pushOrderListCell.orderStateMainTitle.text = id_waitingorder;
                    pushOrderListCell.orderStateSubTitle.text  = @"当前是否有需要配送的订单";
                    if ([[SystemConfig shareSystemConfig]getWaitingOrderListFromRunningData].count==0) {
                        pushOrderListCell.orderNum.hidden = YES;
                    }else
                    {
                        pushOrderListCell.orderNum.hidden = NO;
                    }
                    pushOrderListCell.orderNum.text = [NSString stringWithFormat:@"指派:%lu",(unsigned long)[[SystemConfig shareSystemConfig]getWaitingOrderListFromRunningData].count];
                }
                else if (indexPath.row == _dataSource.count -1)
                {
                    pushOrderListCell.orderStateImage.image = LOADIMAGE(@"history_Order@2x", @"png");
                    pushOrderListCell.orderStateMainTitle.text = id_historyorder;
                    pushOrderListCell.orderStateSubTitle.text  = @"完成的订单都在这里";
                    pushOrderListCell.orderNum.hidden = NO;
                    pushOrderListCell.orderNum.backgroundColor = _TEXT_TIPGRAY_;
                    pushOrderListCell.orderNum.text = _historyNum;
                }
                return pushOrderListCell;
            }
            else
            {
         
                if ([[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"0"]&&[[[SystemConfig shareSystemConfig]getIFAmateurGameRight]isEqualToString:@"1"]) {
                    
                    pushOrderToListCell *pushOrderListCell = [tableView dequeueReusableCellWithIdentifier:pushCellreuseIdentifer];
                    pushOrderListCell.orderNum.backgroundColor = _TEXT_TIPRED_;
                    pushOrderListCell.orderNum.layer.cornerRadius = 15;
                    pushOrderListCell.orderNum.layer.masksToBounds = YES;
                    pushOrderListCell.orderNum.adjustsFontSizeToFitWidth = YES;
                    
                    if (indexPath.row == _dataSource.count -3) {
                     
                    pushOrderListCell.orderStateImage.image = LOADIMAGE(@"award_order@2x", @"png");
                    pushOrderListCell.orderStateMainTitle.text = id_awardorder;
                    pushOrderListCell.orderStateSubTitle.text = @"抽奖订单都在这里";
                    pushOrderListCell.orderNum.hidden = YES;

                    return pushOrderListCell;
                        
                    }
                    else
                    {
                        RunningOrderCell *runningOrderCell = [tableView dequeueReusableCellWithIdentifier:runingCellreuseIdentifer];
                        
                        runningOrderCell.startAddressLabel.text = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"reservedPlace"];
                        runningOrderCell.endAddressLabel.text = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"targetAddress"];
                        runningOrderCell.orderCodeLabel.text = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"orderNo"];
                        
                        NSInteger status = [[[_dataSource objectAtIndex:indexPath.row]valueForKey:@"orderTaskStatus"]integerValue];
                        
                        // 判断订单是否取消
                        switch (status) {
                            case 0:
                                runningOrderCell.orderStateLabel.text = @"未接收";
                                break;
                            case 1:
                                runningOrderCell.orderStateLabel.text = @"已接单";
                                break;
                            case 2:
                                runningOrderCell.orderStateLabel.text = @"等待上门取件";
                                break;
                            case 3:
                                runningOrderCell.orderStateLabel.text = @"已开始服务，前往目的地点";
                                break;
                            case 4:
                                runningOrderCell.orderStateLabel.text = @"已取件，正在派送中";
                                break;
                            case 5:
                                runningOrderCell.orderStateLabel.text = @"已申请取消订单，等待确认";
                                break;
                            default:
                                runningOrderCell.orderStateLabel.text = @"未知订单状态";
                                break;
                        }
                        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                        
                        runningOrderCell.orderSubmitTimeLabel.text = [[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"reservedTime"]componentsSeparatedByString:@" "][1];
                        //runningOrderCell.orderSubmitTimeLabel.text = [formatter stringFromDate:date];
                        runningOrderCell.dateTimeLabel.text = [[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"reservedTime"]componentsSeparatedByString:@" "][0];
                        return runningOrderCell;
                    }
                    
                }else
                {
                    RunningOrderCell *runningOrderCell = [tableView dequeueReusableCellWithIdentifier:runingCellreuseIdentifer];
                    
                    runningOrderCell.startAddressLabel.text = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"reservedPlace"];
                    runningOrderCell.endAddressLabel.text = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"targetAddress"];
                    runningOrderCell.orderCodeLabel.text = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"orderNo"];
                    
                    NSInteger status = [[[_dataSource objectAtIndex:indexPath.row]valueForKey:@"orderTaskStatus"]integerValue];
                    // 判断订单是否取消
                    switch (status) {
                        case 0:
                            runningOrderCell.orderStateLabel.text = @"未接收";
                            break;
                        case 1:
                            runningOrderCell.orderStateLabel.text = @"已接单";
                            break;
                        case 2:
                            runningOrderCell.orderStateLabel.text = @"等待上门取件";
                            break;
                        case 3:
                            runningOrderCell.orderStateLabel.text = @"已开始服务，前往目的地点";
                            break;
                        case 4:
                            runningOrderCell.orderStateLabel.text = @"已取件，正在派送中";
                            break;
                        case 5:
                            runningOrderCell.orderStateLabel.text = @"已申请取消订单，等待确认";
                            break;
                        default:
                            runningOrderCell.orderStateLabel.text = @"未知订单状态";
                            break;
                    }
                    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                    
                    runningOrderCell.orderSubmitTimeLabel.text = [[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"reservedTime"]componentsSeparatedByString:@" "][1];
                    //runningOrderCell.orderSubmitTimeLabel.text = [formatter stringFromDate:date];
                    runningOrderCell.dateTimeLabel.text = [[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"reservedTime"]componentsSeparatedByString:@" "][0];
                    return runningOrderCell;
                }
            }
        }
    }
    else
    {
        if([[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"1"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"3"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"4"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"5"]) {
            
            //全职等类型
            if (indexPath.row == _dataSource.count-2 || indexPath.row == _dataSource.count - 1||indexPath.row == _dataSource.count -3||indexPath.row == _dataSource.count -4) {
                
                pushOrderToListCell *pushOrderListCell = [tableView dequeueReusableCellWithIdentifier:pushCellreuseIdentifer];
                pushOrderListCell.orderNum.backgroundColor = _TEXT_TIPRED_;
                pushOrderListCell.orderNum.layer.cornerRadius = 15;
                pushOrderListCell.orderNum.layer.masksToBounds = YES;
                pushOrderListCell.orderNum.adjustsFontSizeToFitWidth = YES;
                
                if (indexPath.row == _dataSource.count - 4)
                {
                    pushOrderListCell.orderStateImage.image = LOADIMAGE(@"waiting_Order@2x", @"png");
                    pushOrderListCell.orderStateMainTitle.text = id_waitingorder;
                    pushOrderListCell.orderStateSubTitle.text  = @"当前是否有需要配送的订单";
                    
                    if ([[SystemConfig shareSystemConfig]getWaitingOrderListFromRunningData].count==0) {
                        pushOrderListCell.orderNum.hidden = YES;
                    }else
                    {
                        pushOrderListCell.orderNum.hidden = NO;
                    }
                    pushOrderListCell.orderNum.text = [NSString stringWithFormat:@"指派:%lu",(unsigned long)[[SystemConfig shareSystemConfig]getWaitingOrderListFromRunningData].count];
                }
                else if (indexPath.row == _dataSource.count - 3)
                {
                    pushOrderListCell.orderStateImage.image = LOADIMAGE(@"inStoreOrder@2x",@"png");
                    pushOrderListCell.orderStateMainTitle.text = id_instoreorder;
                    pushOrderListCell.orderStateSubTitle.text  = @"驻店员工的驻店订单在这里";
                    pushOrderListCell.orderNum.hidden          = YES;
                }
                else if (indexPath.row == _dataSource.count -2)
                {
                    pushOrderListCell.orderStateImage.image = LOADIMAGE(@"history_Order@2x", @"png");
                    pushOrderListCell.orderStateMainTitle.text = id_historyorder;
                    pushOrderListCell.orderStateSubTitle.text  = @"完成的订单都在这里";
                    pushOrderListCell.orderNum.hidden = NO;
                    pushOrderListCell.orderNum.backgroundColor = _TEXT_TIPGRAY_;
                    pushOrderListCell.orderNum.text = _historyNum;
                }
                else if (indexPath.row == _dataSource.count - 1)
                {
                    pushOrderListCell.orderStateImage.image = LOADIMAGE(@"sao@2x", @"png");
                    pushOrderListCell.orderStateMainTitle.text = id_scan;
                    pushOrderListCell.orderStateSubTitle.text  = @"点击扫一扫订单";
                    pushOrderListCell.orderNum.hidden = YES;
                    pushOrderListCell.orderNum.backgroundColor = _TEXT_TIPGRAY_;
                }

                return pushOrderListCell;
            }
            else
            {
                RunningOrderCell *runningOrderCell = [tableView dequeueReusableCellWithIdentifier:runingCellreuseIdentifer];
                runningOrderCell.startAddressLabel.text = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"reservedPlace"];
                runningOrderCell.endAddressLabel.text = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"targetAddress"];
                runningOrderCell.orderCodeLabel.text = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"orderNo"];
                
                NSInteger status = [[[_dataSource objectAtIndex:indexPath.row]valueForKey:@"orderTaskStatus"]integerValue];
                NSString *bottomOrderStateStr;

                // 判断订单是否取消
                switch (status) {
                    case 0:
                        runningOrderCell.orderStateLabel.text = @"未接收";
                        break;
                    case 1:
                        runningOrderCell.orderStateLabel.text = @"已接单";
                        bottomOrderStateStr = @"去取件";
                        break;
                    case 2:
                        runningOrderCell.orderStateLabel.text = @"等待上门取件";
                        bottomOrderStateStr = @"已取件";

                        break;
                    case 3:
                        runningOrderCell.orderStateLabel.text = @"已开始服务，前往目的地点";
                        bottomOrderStateStr = @"已送达";

                        break;
                    case 4:
                        runningOrderCell.orderStateLabel.text = @"已取件，正在派送中";
                        break;
                    case 5:
                        runningOrderCell.orderStateLabel.text = @"已申请取消订单，等待确认";
                        break;
                    default:
                        runningOrderCell.orderStateLabel.text = @"未知订单状态";
                        break;
                }
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                
                runningOrderCell.orderSubmitTimeLabel.text = [[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"reservedTime"]componentsSeparatedByString:@" "][1];
                //runningOrderCell.orderSubmitTimeLabel.text = [formatter stringFromDate:date];
                runningOrderCell.dateTimeLabel.text = [[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"reservedTime"]componentsSeparatedByString:@" "][0];
                if ([[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"orderSourceFlag"]integerValue]==90) {
                    runningOrderCell.bottomOrderStateLabel.hidden = NO;

                    [runningOrderCell.bottomOrderStateLabel setTitle:bottomOrderStateStr forState:UIControlStateNormal];
                    runningOrderCell.bottomOrderStateLabel.tag = indexPath.row;
                    NSLog(@"tag;%ld",(long)runningOrderCell.bottomOrderStateLabel.tag);
                    [runningOrderCell.bottomOrderStateLabel setTitleColor:LightTextColor forState:UIControlStateNormal];
                    [runningOrderCell.contentView bringSubviewToFront:runningOrderCell.bottomOrderStateLabel];

                    

                }
                return runningOrderCell;
            }
        }
        else
        {
            //众包等类型
            if (indexPath.row == _dataSource.count -1||indexPath.row == _dataSource.count - 2) {
                pushOrderToListCell *pushOrderListCell = [tableView dequeueReusableCellWithIdentifier:pushCellreuseIdentifer];
                pushOrderListCell.orderNum.backgroundColor = _TEXT_TIPRED_;
                pushOrderListCell.orderNum.layer.cornerRadius = 15;
                pushOrderListCell.orderNum.layer.masksToBounds = YES;
                pushOrderListCell.orderNum.adjustsFontSizeToFitWidth = YES;
                
                if (indexPath.row == _dataSource.count - 2)
                {
                    pushOrderListCell.orderStateImage.image = LOADIMAGE(@"waiting_Order@2x", @"png");
                    pushOrderListCell.orderStateMainTitle.text = id_waitingorder;
                    pushOrderListCell.orderStateSubTitle.text  = @"当前是否有需要配送的订单";
                    if ([[SystemConfig shareSystemConfig]getWaitingOrderListFromRunningData].count==0) {
                        pushOrderListCell.orderNum.hidden = YES;
                    }else
                    {
                        pushOrderListCell.orderNum.hidden = NO;
                    }
                    pushOrderListCell.orderNum.text = [NSString stringWithFormat:@"指派:%lu",(unsigned long)[[SystemConfig shareSystemConfig]getWaitingOrderListFromRunningData].count];
                }
                else if (indexPath.row == _dataSource.count -1)
                {
                    pushOrderListCell.orderStateImage.image = LOADIMAGE(@"history_Order@2x", @"png");
                    pushOrderListCell.orderStateMainTitle.text = id_historyorder;
                    pushOrderListCell.orderStateSubTitle.text  = @"完成的订单都在这里";
                    pushOrderListCell.orderNum.hidden = NO;
                    pushOrderListCell.orderNum.backgroundColor = _TEXT_TIPGRAY_;
                    pushOrderListCell.orderNum.text = _historyNum;
                }
                return pushOrderListCell;
            }
            else
            {
                RunningOrderCell *runningOrderCell = [tableView dequeueReusableCellWithIdentifier:runingCellreuseIdentifer];
                runningOrderCell.startAddressLabel.text = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"reservedPlace"];
                runningOrderCell.endAddressLabel.text = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"targetAddress"];
                runningOrderCell.orderCodeLabel.text = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"orderNo"];
                
                NSInteger status = [[[_dataSource objectAtIndex:indexPath.row]valueForKey:@"orderTaskStatus"]integerValue];
                // 判断订单是否取消
                switch (status) {
                    case 0:
                        runningOrderCell.orderStateLabel.text = @"未接收";
                        break;
                    case 1:
                        runningOrderCell.orderStateLabel.text = @"已接单";
                        break;
                    case 2:
                        runningOrderCell.orderStateLabel.text = @"等待上门取件";
                        break;
                    case 3:
                        runningOrderCell.orderStateLabel.text = @"已开始服务，前往目的地点";
                        break;
                    case 4:
                        runningOrderCell.orderStateLabel.text = @"已取件，正在派送中";
                        break;
                    case 5:
                        runningOrderCell.orderStateLabel.text = @"已申请取消订单，等待确认";
                        break;
                    default:
                        runningOrderCell.orderStateLabel.text = @"未知订单状态";
                        break;
                }
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                
                runningOrderCell.orderSubmitTimeLabel.text = [[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"reservedTime"]componentsSeparatedByString:@" "][1];
                //runningOrderCell.orderSubmitTimeLabel.text = [formatter stringFromDate:date];
                runningOrderCell.dateTimeLabel.text = [[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"reservedTime"]componentsSeparatedByString:@" "][0];
                return runningOrderCell;
            }
        }
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[[SystemConfig shareSystemConfig]getIfHasAwardOrder]isEqualToString:@"1"]) {
        
        if ([[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"1"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"3"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"4"]) {
            
            if (indexPath.row == _dataSource.count-1 || indexPath.row == _dataSource.count-2 || indexPath.row == _dataSource.count-3 || indexPath.row == _dataSource.count-4|| indexPath.row == _dataSource.count-5){
                return _CELL_HEIGHT_;
            }
            else
            {
                if ([[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"orderSourceFlag"]integerValue]==90) {
                    return _RUNNINGCELL_HEIGHT_+6+44+6;
                }else
                return _RUNNINGCELL_HEIGHT_;
            }
        }
        else if ([[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"0"]&&[[[SystemConfig shareSystemConfig]getIFAmateurGameRight]isEqualToString:@"0"])
        {
            if (indexPath.row == _dataSource.count - 1 || indexPath.row == _dataSource.count - 2) {
                
                return _CELL_HEIGHT_;
                
            }else
            {
                _RUNNINGCELL_HEIGHT_;
            }
        }
        else if ([[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"0"]&&[[[SystemConfig shareSystemConfig]getIFAmateurGameRight]isEqualToString:@"1"])
        {
            if (indexPath.row == _dataSource.count - 1 || indexPath.row == _dataSource.count -2 || indexPath.row == _dataSource.count - 3){
                return _CELL_HEIGHT_;
            }else
            {
                return  _RUNNINGCELL_HEIGHT_;
            }
        }
        else
        {
            if (indexPath.row == _dataSource.count -1 || indexPath.row == _dataSource.count-2 || indexPath.row == _dataSource.count -3)
            {
                return _CELL_HEIGHT_;
            }
            else
            {
                return _RUNNINGCELL_HEIGHT_;
            }
        }

    }else
    {
        if ([[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"1"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"3"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"4"]) {
            
            if (indexPath.row == _dataSource.count-1 || indexPath.row == _dataSource.count-2 || indexPath.row == _dataSource.count-3|| indexPath.row == _dataSource.count-4){
                return _CELL_HEIGHT_;
            }
            else
            {
                if ([[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"orderSourceFlag"]integerValue]==90) {
                    return _RUNNINGCELL_HEIGHT_+6+44+6;
                }else

                    return _RUNNINGCELL_HEIGHT_;
            }
        }
        else
        {
            if (indexPath.row == _dataSource.count -1 || indexPath.row == _dataSource.count-2) {
                return _CELL_HEIGHT_;
            }else
            {
                return _RUNNINGCELL_HEIGHT_;
            }
        }
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[SystemConfig shareSystemConfig]getIfHasAwardOrder]isEqualToString:@"1"]) {
        
        OrderListViewController *orderListView = [[OrderListViewController alloc]init];
        if ([[SystemConfig shareSystemConfig]getWaitingOrderListFromRunningData].count == 0) {
            orderListView.ifAutoAssignOrder = @"yes";
        }
        else
        {
            orderListView.ifAutoAssignOrder = @"no";
        }
        if ([[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"1"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"3" ]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"4"]) {
            if (indexPath.row == _dataSource.count-2) {
                orderListView.fromWhich                = id_historyorder;
                [self.navigationController pushViewController:orderListView animated:YES];
            }
            else if (indexPath.row == _dataSource.count-3)
            {
                orderListView.fromWhich                = id_instoreorder;
                [self.navigationController pushViewController:orderListView animated:NO];
            }
            else if (indexPath.row == _dataSource.count -4)
            {
                orderListView.fromWhich                = id_waitingorder;
                [self.navigationController pushViewController:orderListView animated:NO];
            }
            else if (indexPath.row == _dataSource.count - 5)
            {
                orderListView.fromWhich                = id_awardorder;
                [self.navigationController pushViewController:orderListView animated:NO];
            }else if (indexPath.row == _dataSource.count - 1)
            {
                QRCodeViewController *qrVC = [[QRCodeViewController alloc] init];
                WEAK(self);
                //uitisaa83f67e93f43ca8b9d7ec7d0fc21a4
                qrVC.qrUrlBlock = ^(NSString *info){//获取到店家ID后，根据状态判断要不要输入订单编号
                    alertOnShow = YES;
                    customerId = info;
                    if ([[[SystemConfig shareSystemConfig]getIFHasOrderNo]isEqualToString:@"true"]) {//需要填写订单编号
                        //弹出一个框输入文本，确定后请求数据
//                        [weakself presentViewController:alertDialog animated:YES completion:nil];
                        [weakself setupAlertController];
                        
                    }else{
                        //弹框确认直接请求数据
                        UIAlertController *al = [UIAlertController alertControllerWithTitle:@"扫一扫订单" message: [NSString stringWithFormat:@"是否加入该订单"] preferredStyle:UIAlertControllerStyleAlert];
                        
                        // 创建操作
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            [weakself createScanOrder];
                            alertOnShow = NO;

                        }];
                        UIAlertAction *cancelAction= [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            NSLog(@"cancel order");
                            alertOnShow = NO;

                        }];
//                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                        // 添加操作（顺序就是呈现的上下顺序）
                        [al addAction:okAction];
                        [al addAction:cancelAction];
                        [self presentViewController:al animated:YES completion:nil];

                    }
                    NSLog(@"info:%@",info);
                    
                };
                [self.navigationController pushViewController:qrVC animated:YES];
            }
            else{
//                OrderDetailViewController *orderDetailView = [[OrderDetailViewController alloc]init];
//                orderDetailView.orderId = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"orderId"];
//                [self.navigationController pushViewController:orderDetailView animated:YES];
                self.orderDetailVC = [[OrderDetailViewController alloc]init];
                self.orderDetailVC.orderId = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"orderId"];
                [self.navigationController pushViewController:self.orderDetailVC animated:YES];

            }
        }
        else
        {
            if (indexPath.row == _dataSource.count-1) {
                orderListView.fromWhich                = id_historyorder;
                [self.navigationController pushViewController:orderListView animated:YES];
            }
            else if (indexPath.row == _dataSource.count -2)
            {
                orderListView.fromWhich                = id_waitingorder;
                
                [self.navigationController pushViewController:orderListView animated:NO];
            }
            else if (indexPath.row == _dataSource.count - 3)
            {
                orderListView.fromWhich                = id_awardorder;
                [self.navigationController pushViewController:orderListView animated:NO];
            }
            else
            {
//                OrderDetailViewController *orderDetailView = [[OrderDetailViewController alloc]init];
//                orderDetailView.orderId = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"orderId"];
//                [self.navigationController pushViewController:orderDetailView animated:YES];
                self.orderDetailVC = [[OrderDetailViewController alloc]init];
                self.orderDetailVC.orderId = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"orderId"];
                [self.navigationController pushViewController:self.orderDetailVC animated:YES];

            }
        }
    }
    else
    {
        OrderListViewController *orderListView = [[OrderListViewController alloc]init];
        if ([[SystemConfig shareSystemConfig]getWaitingOrderListFromRunningData].count == 0) {
            orderListView.ifAutoAssignOrder = @"yes";
        }
        else
        {
            orderListView.ifAutoAssignOrder = @"no";
        }
        if ([[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"1"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"3" ]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"4"]) {
            if (indexPath.row == _dataSource.count-2) {
                orderListView.fromWhich                = id_historyorder;
                [self.navigationController pushViewController:orderListView animated:YES];
            }
            else if (indexPath.row == _dataSource.count-3)
            {
                orderListView.fromWhich                = id_instoreorder;
                [self.navigationController pushViewController:orderListView animated:NO];
            }
            else if (indexPath.row == _dataSource.count -4)
            {
                orderListView.fromWhich                = id_waitingorder;
                [self.navigationController pushViewController:orderListView animated:NO];
            }else if (indexPath.row == _dataSource.count - 1)
            {
                WEAK(self);
                QRCodeViewController *qrVC = [[QRCodeViewController alloc] init];
                qrVC.qrUrlBlock = ^(NSString *info){
                    NSLog(@"info:%@",info);
                    alertOnShow = YES;
                    customerId = info;
                    if ([[[SystemConfig shareSystemConfig]getIFHasOrderNo]isEqualToString:@"true"]) {//需要填写订单编号
                        //弹出一个框输入文本，确定后请求数据
//                        [weakself presentViewController:alertDialog animated:YES completion:nil];
                        [self setupAlertController];
                    }else{
                        //                        typedef  void (^block)(NSString *str)
                        
                        
                        //                        void ^(testBlock)(NSString *st)= ^(NSString *str){
                        //
                        //                        };
                        //弹框确认直接请求数据
                        UIAlertController *al = [UIAlertController alertControllerWithTitle:@"扫一扫订单" message: [NSString stringWithFormat:@"是否加入该订单"] preferredStyle:UIAlertControllerStyleAlert];
                        
                        // 创建操作
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            alertOnShow = NO;

                            [weakself createScanOrder];
                        }];
                        UIAlertAction *cancelAction= [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            alertOnShow = NO;

                            NSLog(@"cancel order");
                        }];
                        
                        // 添加操作（顺序就是呈现的上下顺序）
                        [al addAction:okAction];
                        [al addAction:cancelAction];
                        [self presentViewController:al animated:YES completion:nil];
                        
                    }
                };
                [self.navigationController pushViewController:qrVC animated:YES];
            }
            else{
//                self.orderDetailVC = [[OrderDetailViewController alloc]init];
//                self.orderDetailVC.orderId = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"orderId"];
//                [self.navigationController pushViewController:self.orderDetailVC animated:YES];
                
                self.orderDetailVC = [[OrderDetailViewController alloc]init];
                self.orderDetailVC.orderId = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"orderId"];
                [self.navigationController pushViewController:self.orderDetailVC animated:YES];

            }
        }
        else
        {
            if (indexPath.row == _dataSource.count-1) {
                orderListView.fromWhich                = id_historyorder;
                [self.navigationController pushViewController:orderListView animated:YES];
            }
            else if (indexPath.row == _dataSource.count -2)
            {
                orderListView.fromWhich                = id_waitingorder;
                
                [self.navigationController pushViewController:orderListView animated:NO];
            }
            else
            {
                self.orderDetailVC = [[OrderDetailViewController alloc]init];
                self.orderDetailVC.orderId = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"orderId"];
                [self.navigationController pushViewController:self.orderDetailVC animated:YES];

            }
        }

    }
}
#pragma mark scrollview delegate method
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self closeChangeStatusView];
}

#pragma mark buttonevent
- (IBAction)changeStatusClicked:(UIButton *)sender {
     if (_changeStatusView.frame.size.width >0) {
        [self closeChangeStatusView];
    }
    else
    {
        [self displayChangeStatusView];
    }
}
-(void)displayChangeStatusView
{
    [UIView animateWithDuration:0.3 animations:^{
        _changeStatusView.frame = CGRectMake(10, 64+10, _SCREEN_WIDTH_/3, _SCREEN_HEIGHT_/4);
    } completion:^(BOOL finished) {
        for (int i = 0; i < 3; i++) {
            UIButton *statusButton = [[UIButton alloc]initWithFrame:CGRectMake(_STATUS_BUTTON_GAP, (_STATUS_BUTTON_GAP + ((_changeStatusView.frame.size.height-4*_STATUS_BUTTON_GAP)/3+_STATUS_BUTTON_GAP)*i), _changeStatusView.frame.size.width-2*_STATUS_BUTTON_GAP,(_changeStatusView.frame.size.height-4*_STATUS_BUTTON_GAP)/3)];
            statusButton.tag = i;
            statusButton.layer.cornerRadius = 5;
            if (i==0) {
                [statusButton setTitle:_status_online_ forState:UIControlStateNormal];
                statusButton.backgroundColor = _STATUSCOLOR_ONLINE_;
            }else if (i==1)
            {
                [statusButton setTitle:_status_rest_ forState:UIControlStateNormal];
                statusButton.backgroundColor = _STATUSCOLOR_RESTPERIOD_;
            }else if (i==2)
            {
                [statusButton setTitle:_status_quit_ forState:UIControlStateNormal];
                statusButton.backgroundColor = _STATUSCOLOR_UPLINE_;
            }
            [statusButton addTarget:self action:@selector(statusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_changeStatusView addSubview:statusButton];
            _statusButton = statusButton;
        }
    }];
}
-(void)closeChangeStatusView
{
    for (UIButton *button in [_changeStatusView subviews]) {
        [button removeFromSuperview];
    }
    [UIView animateWithDuration:0.1 animations:^{
        _changeStatusView.frame = CGRectMake(10,64+10,0,0);
    } completion:^(BOOL finished) {
      
        for (UIButton *button in [_changeStatusView subviews]) {
            [button removeFromSuperview];
        }

    }];
}


-(void)statusButtonClicked:(UIButton *)sender
{
    if (sender.tag == 0) {
        [self closeChangeStatusView];
        [_changStatusBt setTitle:_status_online_ forState:UIControlStateNormal];
    }else if (sender.tag == 1)
    {
        [self closeChangeStatusView];
        [self performSelector:@selector(resetStatusToOnline) withObject:self afterDelay:_REST_TIME_];
        [_changStatusBt setTitle:_status_rest_ forState:UIControlStateNormal];
    }else if (sender.tag == 2)
    {
        [self closeChangeStatusView];
        [_changStatusBt setTitle:_status_quit_ forState:UIControlStateNormal];
    }
    [self upLoadDeliverStatusWith:sender.tag];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![_statusButton isExclusiveTouch]) {
        [self closeChangeStatusView];
    }
}
#pragma mark alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex  == 0) {
            NSURL *servicePhoneNumberUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[[SystemConfig shareSystemConfig]getServiceNumber]]];
            [[UIApplication sharedApplication]openURL:servicePhoneNumberUrl];
     }
}
#pragma mark network
-(void)connectHistoryOrderCompeletedNumData
{
    __weak typeof(self) this = self;
    UIView *placeHolderView = [[UIView alloc]init];
    [NetWorkTool getRequestWithUrl:__historyOrderCompeletedNum param:nil addProgressHudOn:placeHolderView Tip:@"" successReturn:^(id successReturn) {
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        _historyNum = [jsonDict valueForKey:@"completedOrder"];
        NSLog(@"historyNUm=%@",_historyNum);
        [this headerRefresh];
        
    } failed:^(id failed) {
        [this headerRefresh];
    }];
}

-(void)connetRunningOrderData
{
    __weak typeof(self) this = self;
    NSLog(@"url%@",[NSString stringWithFormat:@"%@",__runningOrder]);
    [NetWorkTool getRequestWithUrl:__runningOrder totalParam:@{@"imei":[[SystemConfig shareSystemConfig]getDeviceToken],} addProgressHudOn:self.view Tip:@"进行中订单" successReturn:^(id successReturn) {
//        isHasOrderNo判断该值，要判断是否加入订单编号功能：对正在进行订单http://101.200.90.137:20068/client/m/order/driverordersyn?imei=867910026167355,同时判断orderSourceFlag是不是扫一扫订单
//        参数isHasOrderNo：true填写订单编号；false不填
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        [_dataSource removeAllObjects];
        
        
        NSLog(@"跟踪问题log:%@",jsonDict);
        
        [[SystemConfig shareSystemConfig]saveDeliverType:[jsonDict valueForKey:@"fullTimeWork"]];       //是否是驻店
        
        [[SystemConfig shareSystemConfig]saveIfHasAwardOrder:[[jsonDict valueForKey:@"hasAwardOrders"]stringValue]];//有没有抽奖
        
        [[SystemConfig shareSystemConfig]saveIfAmateurToGame:[[jsonDict valueForKey:@"isIncludeJian"]stringValue]];////众包是否有抽奖活动
        
        [[SystemConfig shareSystemConfig]saveIfHasOrderNo:[jsonDict valueForKey:@"isHasOrderNo"]];//需不需要填写订单编号
        
        _dataSource = [[NSMutableArray alloc]initWithArray:[jsonDict valueForKey:@"executingOrderInfos"]];
        
        //驻店员工
        if ([[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"1"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"3"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"4"]) {
         //   [_upRightBt setImage:[UIImage imageNamed:@"signLogin@2x.png"] forState:UIControlStateNormal];
            [_upRightBt setTitle:[[NSUserDefaults standardUserDefaults]valueForKey:@"signInOrOut"] forState:UIControlStateNormal];
        }
        else
        {
            [_upRightBt setImage:[UIImage imageNamed:@"service@2x.png"] forState:UIControlStateNormal];
        }
        
        for (NSDictionary *dict in [jsonDict valueForKey:@"executingOrderInfos"]) {
            NSString *stateNumString = [[dict valueForKey:@"orderTaskStatus"]stringValue];
            NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]initWithDictionary:dict];
            [mutableDic setValue:stateNumString forKey:@"orderTaskStatus"];
            [_dataSource removeObject:dict];
            [_dataSource addObject:mutableDic];
        }
        
        NSArray *unReceiveArray = [jsonDict valueForKey:@"unreceiveOrderInfos"];
        if (unReceiveArray.count != 0){
            
            NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:unReceiveArray];
            [[SystemConfig shareSystemConfig]saveWaitingOrderlistFromRunningData:mutableArray];
        }else
        {
            NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:@[]];
            [[SystemConfig shareSystemConfig]saveWaitingOrderlistFromRunningData:mutableArray];
        }
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:_dataSource];
        [[SystemConfig shareSystemConfig]saveRunningOrderList:array];
        
        
        if ([[[SystemConfig shareSystemConfig]getIfHasAwardOrder]isEqualToString:@"1"]) {//是否有抽奖订单
            [this delivertypeDealWithAward];
        }
        else
        {
            [this deliverTypeDeal];
        }
        
        if (![[jsonDict valueForKey:@"isSignOut"]isEqualToString:@"Y"]) {
            _signOutBt.hidden = YES;
            _signBackHeight.constant = 51;
        }
        
        [_orderTableView reloadData];
        [_orderTableView.mj_header endRefreshing];
        
        
    } failed:^(id failed) {
        [_dataSource removeAllObjects];
        [_dataSource addObject:@{@"empty1":@""}];
        [_dataSource addObject:@{@"empty2":@""}];
        [_orderTableView reloadData];
        [_orderTableView.mj_header endRefreshing];
    }];
}
//有抽奖订单
-(void)delivertypeDealWithAward
{
    if ([[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"1"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"3"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"4"]) {
        
        [_dataSource addObject:@{@"empty1":@""}]; //待接
        [_dataSource addObject:@{@"empty2":@""}]; //驻店
        [_dataSource addObject:@{@"empty3":@""}]; //抽奖
        [_dataSource addObject:@{@"empty4":@""}]; //历史
        [_dataSource addObject:@{@"empty5":@""}]; //二维码？？？

    }else
    {
        if ([[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"0"]&&[[[SystemConfig shareSystemConfig]getIFAmateurGameRight]isEqualToString:@"0"]) {
            
            [_dataSource addObject:@{@"empty1":@""}]; //待接
            [_dataSource addObject:@{@"empty3":@""}]; //历史
            
        }else
        {
            [_dataSource addObject:@{@"empty1":@""}]; //待接
            [_dataSource addObject:@{@"empty2":@""}]; //抽奖
            [_dataSource addObject:@{@"empty3":@""}]; //历史
        }
    }
    
    if ([[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"1"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"3"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"4"]) {
        if (_dataSource.count == 3) {
            _runningOrderStateLabel.text = @"暂时没有进行中的订单";
            _runningOrderSubLabel.text   = @"请到待接订单查看或接单";
        }
    }else
    {
        if (_dataSource.count == 2) {
            _runningOrderStateLabel.text = @"暂时没有进行中的订单";
            _runningOrderSubLabel.text   = @"请到待接订单查看或接单";
        }
    }
}

//没有抽奖订单
-(void)deliverTypeDeal
{

    if ([[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"1"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"3"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"4"]) {
        
        [_dataSource addObject:@{@"empty1":@""}]; //待接
        [_dataSource addObject:@{@"empty2":@""}]; //驻店
        [_dataSource addObject:@{@"empty3":@""}]; //历史
        [_dataSource addObject:@{@"empty4":@""}]; //二维码？？？
        
    }else
    {
        [_dataSource addObject:@{@"empty1":@""}]; //待接
        [_dataSource addObject:@{@"empty2":@""}]; //历史
    }
    
    if ([[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"1"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"3"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"4"]) {
        
        if (_dataSource.count == 3) {
            _runningOrderStateLabel.text = @"暂时没有进行中的订单";
            _runningOrderSubLabel.text   = @"请到待接订单查看或接单";
        }
        
    }
    else
    {
        if (_dataSource.count == 2) {
            _runningOrderStateLabel.text = @"暂时没有进行中的订单";
            _runningOrderSubLabel.text   = @"请到待接订单查看或接单";
        }
    }

}

-(void)upLoadDeliverStatusWith:(NSInteger)status
{
    NSString *statusString = nil;
    switch (status) {
        case 0:
            statusString = _status_online_;
            break;
        case 1:
            statusString = _status_rest_;
            break;
        case 2:
            statusString = _status_quit_;
            break;
        default:
            break;
    }
    
    [NetWorkTool getRequestWithUrl:__changeDeliverStatus param:@{@"controlStatus":[NSString stringWithFormat:@"%ld",(long)status],} addProgressHudOn:self.view Tip:[NSString stringWithFormat:@"切换至#%@#状态",statusString] successReturn:^(id successReturn) {
        
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        if ([[jsonDict valueForKey:@"result"]isEqualToString:@"true"]) {
            [[SystemConfig shareSystemConfig]saveUserStatus:statusString];
            [_changStatusBt setTitle:[[SystemConfig shareSystemConfig]getUserStatus] forState:UIControlStateNormal];
            ALERT_VIEW(@"更改状态成功");
        }else{
            [_changStatusBt setTitle:[[SystemConfig shareSystemConfig]getUserStatus] forState:UIControlStateNormal];
            ALERT_VIEW(@"更改状态失败");
        }
        
    } failed:^(id failed) {
        
    }];
}
-(void)resetStatusToOnline
{
    UIView *view = [[UIView alloc]init];
    [NetWorkTool getRequestWithUrl:__changeDeliverStatus param:@{@"controlStatus":@"0",} addProgressHudOn:view Tip:@"resetStatus" successReturn:^(id successReturn) {
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];

        if ([[jsonDict valueForKey:@"result"]isEqualToString:@"true"]) {
            [[SystemConfig shareSystemConfig]saveUserStatus:_status_online_];
            [_changStatusBt setTitle:[[SystemConfig shareSystemConfig]getUserStatus] forState:UIControlStateNormal];
        }
    } failed:^(id failed) {
        NSLog(@"error resetStatus %@",failed);
        [_changStatusBt setTitle:[[SystemConfig shareSystemConfig]getUserStatus] forState:UIControlStateNormal];
    }];
}
#pragma mark delegate from login
-(void)sendLoginStatusString:(NSString *)status
{
    if ([status isEqualToString:@"1"]) {
        NSLog(@"********返回登陆状态的代理方法**********");
        [self resetStatusToOnline];
    }
    //这个版本先去掉
//    [self requestActivity];
}
-(void)upLoadLocationPerSecond
{
    [NSTimer scheduledTimerWithTimeInterval:_UPLOAD_LOCATION_INTERVAL_ target:self selector:@selector(ToUpLoadLocation) userInfo:nil repeats:YES];
}
#pragma mark upload location
-(void)ToUpLoadLocation
{
    NSString *imeiString = [[SystemConfig shareSystemConfig]getDeviceToken];
    // from android "MM-dd HH:mm:ss"
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    // splice the param string
    NSString *OtherFourParam = [NSString stringWithFormat:@";%@,%@,%@,gps",[[SystemConfig shareSystemConfig]getUserLocationLatitude],[[SystemConfig shareSystemConfig]getUserLocationLongtitude],[dateFormatter stringFromDate:[NSDate date]]];
    NSString *paramString = [imeiString stringByAppendingString:OtherFourParam];
    
    if ([[[SystemConfig shareSystemConfig]getUserLocationLatitude]isEqualToString:@""])
    {
        return;
    }
    [NetWorkTool postToUpLoadLocationWithParam:@{@"p":paramString,} successReturn:^(id successReturn) {
        
    //NSLog(@"实时上传的经纬度 %@",paramString);
//          NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

       // NSLog(@"upload success %@",jsonDict);
        
    } failed:^(id failed) {
        // NSLog(@"upload failed %@",failed);
    }];
}


- (IBAction)signLoginIn:(UIButton *)sender {
    
    if ([[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"1"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"3"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"4"]) {
        
        if (sender.selected == YES) {
            sender.selected = NO;
            _signInOrOutBack.hidden = YES;
        }else if(sender.selected == NO)
        {
            sender.selected = YES;
            _signInOrOutBack.hidden = NO;
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"拨打客服号码咨询" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        
        [alert show];
    }
}

- (IBAction)signInBt:(UIButton *)sender {
    _signInOrOutBack.hidden = YES;
    [NetWorkTool getRequestWithUrl:__signLogin totalParam:@{@"imei":[[SystemConfig shareSystemConfig]getDeviceToken],@"isOrNoSign":@"Y"} addProgressHudOn:self.view Tip:@"签到中" successReturn:^(id successReturn) {
                NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

                if ([[jsonDict valueForKey:@"result"]isEqualToString:@"true"]) {
    
                    [_upRightBt setTitle:@"已到店" forState:UIControlStateNormal];
                    [[NSUserDefaults standardUserDefaults]setValue:@"已到店" forKey:@"signInOrOut"];
                    ALERT_VIEW([jsonDict valueForKey:@"msg"]);
    
                }else
                {
                    ALERT_VIEW([jsonDict valueForKey:@"msg"]);
                }
            } failed:^(id failed) {
            }];
}

- (IBAction)signOutBt:(UIButton *)sender {
    _signInOrOutBack.hidden = YES;
    [NetWorkTool getRequestWithUrl:__signLogin totalParam:@{@"imei":[[SystemConfig shareSystemConfig]getDeviceToken],@"isOrNoSign":@"N"} addProgressHudOn:self.view Tip:@"签退中" successReturn:^(id successReturn) {
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        if ([[jsonDict valueForKey:@"result"]isEqualToString:@"true"]) {
            [_upRightBt setTitle:@"已离店" forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults]setValue:@"已离店" forKey:@"signInOrOut"];
            ALERT_VIEW([jsonDict valueForKey:@"msg"]);
        }else
        {
            ALERT_VIEW([jsonDict valueForKey:@"msg"]);
        }
    } failed:^(id failed) {
    }];
}

- (void)requestActivity{
    
    NSDictionary *dict = @{@"driverIMEI":[[SystemConfig shareSystemConfig]getDeviceToken]};
    [NetWorkTool postRequestWithUrl:__ActivityUrl param:dict addProgressHudOn:self.view Tip:@"" successReturn:^(id successReturn) {
        if ([successReturn[@"result"] isEqualToString:@"true"]) {
            NSDictionary *jsonReturn =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            //        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

            NSDictionary *jsonDict = jsonReturn[@"data"];
            
            if ([jsonDict[@"hasActivity"] boolValue] == YES) {
                ActivityModel *actModel = [ActivityModel mj_objectWithKeyValues:jsonDict];
                NSLog(@"actmodel=%@",actModel);
                NSLog(@"JSONDICT=%@",jsonDict);
                ActViewController *actVC = [[ActViewController alloc]init];
                actVC.url = actModel.linkUrl;
                actVC.actModel = actModel;
                [self presentViewController:actVC animated:YES completion:nil];
                // ALERT_HUD(this.view,[successReturn valueForKey:@"msg"]);
                
            }
        }else{
            ALERT_HUD(self.view, successReturn[@"msg"]);
        }
    } failed:^(id failed) {
        
    }];
}

//driverIMEI	driverIMEI	true	String	手机IMEI码
//customerId	customerId	True	String	店家ID
//orderSerialNo	orderSerialNo	True	String	订单编号；（如何判断需要填订单编号，他只能是数字、字母大小写；如果不需要填写，默认是空“”；）
- (void)createScanOrder{
//    uitis8ecbbc348f143308748b03b8e120759
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[[SystemConfig shareSystemConfig]getDeviceToken] forKey:@"driverIMEI"];//必填
    if ([[[SystemConfig shareSystemConfig]getIFHasOrderNo]isEqualToString:@"true"]) {      //需要填写订单编号
        if (orderSerialNo.length>0) {
            [dict setObject:orderSerialNo forKey:@"orderSerialNo"];
        }else{
            return;
        }
    }
    [dict setObject:customerId forKey:@"customerId"];                                 //必填
    [NetWorkTool postRequestWithUrl:__scanOrder param:dict addProgressHudOn:self.view Tip:@"" successReturn:^(id successReturn) {
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        //        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];
//        UITextField *userEmail = alertDialog.textFields.firstObject;
//        userEmail.text = @"";
        orderSerialNo = @"";

        if ([jsonDict[@"result"]boolValue]==true) {
//            [self connetRunningOrderData];
            
            [self  connectHistoryOrderCompeletedNumData];
//            [self headerRefresh];
        }else{
            [self headerRefresh];

            ALERT_HUD(self.view, @"错误的二维码");
        }
    } failed:^(id failed) {
        [self headerRefresh];
 
    }];
}

- (void)changeOrderState:(UIButton *)btn{
    NSLog(@"btn.title%@",btn.titleLabel.text);
    NSLog(@"btn.tag=%ld",btn.tag);
//    self.orderDetailVC.orderId = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"orderId"];
    itemDic = [_dataSource objectAtIndex:btn.tag];
    
    if ([[itemDic objectForKey:@"orderTaskStatus"]isEqualToString:@"1"]) {
        [self connectToSendGetPackageVerifyCode];
    }
    else if ([[itemDic objectForKey:@"orderTaskStatus"]isEqualToString:@"2"])
    {
        [self connectToSendCustomerReceiveVerifyCode];
    }
    else if ([[itemDic objectForKey:@"orderTaskStatus"]isEqualToString:@"3"])
    {
        [self connectToCompeleteOrder];
    }
    
}

-(void)connectToSendGetPackageVerifyCode
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss SSS";
    
    [NetWorkTool postToSendGetPackageCodeWith:@{@"orderId":[itemDic valueForKey:@"orderId"],
                                                @"arriveTime":[formatter stringFromDate:[NSDate date]],
                                                @"isQuJianPass":[itemDic valueForKey:@"isQuJianPass"],
                                                @"isShouJianPass":[itemDic valueForKey:@"isShouJianPass"],@"nowDate":[NSString stringWithFormat:@"%@",[NSDate date]]} addProgressHudOn:self.view successReturn:^(id successReturn) {
                                                    
                                                    NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                                                    
                                                    //        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];
                                                    
                                                    if ([[jsonDict valueForKey:@"result"]isEqualToString:@"true"]) {
                                                        
                                                        [itemDic setValue:@"2" forKey:@"orderTaskStatus"];
                                                        [_orderTableView reloadData];
                                                    }else if ([[jsonDict valueForKey:@"result"]isEqualToString:@"false"])
                                                    {
                                                        ALERT_VIEW([jsonDict valueForKey:@"msg"])
                                                    }
                                                    
                                                    
                                                } failed:^(id failed) {
                                                    
                                                }];
}


-(void)connectToSendCustomerReceiveVerifyCode
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss SSS";
    [NetWorkTool postToSendReceiveCodeWith:@{@"orderId":[itemDic valueForKey:@"orderId"],
                                             @"serviceStartTime":[formatter stringFromDate:[NSDate date]],
//                                             @"courierTakePwd":_deliverVerityCodeTf.text,
                                             @"isQuJianPass":[itemDic valueForKey:@"isQuJianPass"],
                                             @"isShouJianPass":[itemDic valueForKey:@"isShouJianPass"],@"nowDate":[NSString stringWithFormat:@"%@",[NSDate date]]} addProgressHudOn:self.view successReturn:^(id successReturn) {
                                                 NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                                                 
                                                 //        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];
                                                 
                                                 if ([[jsonDict valueForKey:@"result"]isEqualToString:@"true"]) {
                                                     
                                                     [itemDic setValue:@"3" forKey:@"orderTaskStatus"];
                                                     [_orderTableView reloadData];

                                                 }
                                                 else if ([[jsonDict valueForKey:@"result"]isEqualToString:@"false"])
                                                 {
                                                     ALERT_VIEW([jsonDict valueForKey:@"msg"])
                                                 }
                                                 
                                                 
                                             } failed:^(id failed) {
                                                 
                                             }];
    
}

-(void)connectToCompeleteOrder
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss SSS";
    [NetWorkTool postToSendCompleteCodeWith:@{@"orderId":[itemDic valueForKey:@"orderId"],
                                              @"serviceEndTime":[formatter stringFromDate:[NSDate date]],
                                              @"isQuJianPass":[itemDic valueForKey:@"isQuJianPass"],
                                              @"isShouJianPass":[itemDic valueForKey:@"isShouJianPass"],
//                                              @"customerTakePwd":_deliverVerityCodeTf.text,
                                              @"nowDate":[NSString stringWithFormat:@"%@",[NSDate date]]} addProgressHudOn:self.view successReturn:^(id successReturn) {
                                                  
                                                  NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                                                  if ([[jsonDict valueForKey:@"result"]isEqualToString:@"true"])
                                                  {
                                                      [self connetRunningOrderData];
                                                  }
                                                  else
                                                  {
                                                      ALERT_VIEW([jsonDict valueForKey:@"msg"])
                                                  }
                                              } failed:^(id failed) {
                                                  
                                              }];
    
}


@end
