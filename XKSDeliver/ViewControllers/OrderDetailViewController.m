//
//  OrderDetailViewController.m
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/12.
//  Copyright © 2015年 同行必达. All rights reserved.
//


//*********页面数据 由 上个页面 保存本地 本详情页面从本地取出
#import "OrderDetailViewController.h"
#import "common.h"
#import "SaveUUIDinKeychain.h"
#import "SystemConfig.h"
#import "MapViewController.h"
#import "NetWorkTool.h"


NSInteger serviceTag = 12;
NSInteger sendphoneTag = 13;
NSInteger receivephoneTag = 14;

NSString *txtMsgState1 = @"发送取件密码";
NSString *txtMsgState2 = @"提交取件密码并发送收件密码";
NSString *txtMsgState3 = @"完成订单";

NSString *deliverState1 = @"去取件";
NSString *deliverState2 = @"已取件";
NSString *deliverState3 = @"已送达";

@interface OrderDetailViewController ()<UIAlertViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    NSArray *returnKeyBoardarray;
}
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dealLocalData];
    [self deployUI];
    [self dealKeyboard];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self listeningOrderInfoStatus];
}
-(void)listeningOrderInfoStatus
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orderInfoChanged:) name:_NOTIFICATION_NAME_ object:nil];
}
-(void)orderInfoChanged:(NSNotification *)notification
{
    if ([[notification.object valueForKey:@"notiState"]isEqualToString:_NOTI_CANCEL_ORDER_]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([[notification.object valueForKey:@"notiState"]isEqualToString:_NOTI_UPDATE_ORDER_])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)dealLocalData
{
    for (NSDictionary *orderInfoDic in [[SystemConfig shareSystemConfig]getRunningOrder]) {
        
        if ([[orderInfoDic valueForKey:@"orderId"]isEqualToString:_orderId]) {
            _dataSource = [[NSMutableDictionary alloc]initWithDictionary:orderInfoDic];
        }
    }
}
-(void)deployUI
{
    self.view.userInteractionEnabled   = YES;
    _sendVerityCodeBt.hidden = NO;
    _orderDetailBckScrollView.delegate = self;
    _deliverVerityCodeTf.delegate      = self;
    
    //不显示提成
    if ([[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"1"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"3"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"4"]) {
        _packagePropertyToTop.constant = -30;
    }
    
    UITapGestureRecognizer *singTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fingerTaped:)];
    [self.view addGestureRecognizer:singTap];
    
    if ([[_dataSource valueForKey:@"isQuJianPass"]isEqualToString:@"Y"]&&[[_dataSource valueForKey:@"isShouJianPass"]isEqualToString:@"Y"]) {
        _sendVertifyCodeToTf.constant = -50;
        
        if ([[_dataSource valueForKey:@"orderTaskStatus"]isEqualToString:@"1"]) {
            [_sendVerityCodeBt setTitle:deliverState1 forState:UIControlStateNormal];
        }else if ([[_dataSource valueForKey:@"orderTaskStatus"]isEqualToString:@"2"])
        {
            [_sendVerityCodeBt setTitle:deliverState2 forState:UIControlStateNormal];
        }else if ([[_dataSource valueForKey:@"orderTaskStatus"]isEqualToString:@"3"])
        {
            [_sendVerityCodeBt setTitle:deliverState3 forState:UIControlStateNormal];
        }else
        {
            _sendVerityCodeBt.hidden = YES;
        }
        
    }else
    {
        if ([[_dataSource valueForKey:@"orderTaskStatus"]isEqualToString:@"1"]) {
            _sendVertifyCodeToTf.constant = -50;
            [_sendVerityCodeBt setTitle:txtMsgState1 forState:UIControlStateNormal];
        }else if ([[_dataSource valueForKey:@"orderTaskStatus" ]isEqualToString:@"2"])
        {
            [_sendVerityCodeBt setTitle:txtMsgState2 forState:UIControlStateNormal];
            
        }else if ([[_dataSource valueForKey:@"orderTaskStatus"]isEqualToString:@"3"])
        {
            [_sendVerityCodeBt setTitle:txtMsgState3 forState:UIControlStateNormal];
            
        }else
        {
            _sendVerityCodeBt.hidden = YES;
        }
    }
    
    
    if ([[_dataSource objectForKey:@"orderExecuteTypeStr"]isEqualToString:@""]) {
        _orderTypeViewToTop.constant = 0;
        _orderTypeView.hidden = YES;
    }
    else
    {
        _orderTypeLb.text = [_dataSource valueForKey:@"orderExecuteTypeStr"];
    }
    
    
    _orderNoLb.text            = [_dataSource valueForKey:@"orderNo"];
    
    if ([[_dataSource objectForKey:@"sendTimeAppointment"]isEqualToString:@""]) {
        _reservingTimeViewToTop.constant = -20;
        _reservingTimeView.hidden = YES;
    }
    else
    {
        _reservingTimeLb.text = [_dataSource valueForKey:@"sendTimeAppointment"];
    }
    
    _receiveOrderTimeLb.text   = [[_dataSource valueForKey:@"receiveTime"]substringToIndex:19];
    if ([[_dataSource valueForKey:@"serviceStartTime"]isEqualToString:@""]) {
        _getPackageTimeLb.text = @"待取件";
    }else
    {
        _getPackageTimeLb.text     = [[_dataSource valueForKey:@"serviceStartTime"]substringToIndex:19];
    }
    _sendPersonLb.text         = [_dataSource valueForKey:@"sendUserName"];
    _receivePersonLb.text      = [_dataSource valueForKey:@"receiveUserName"];
    _orderGenerateTimeLb.text  = [[_dataSource valueForKey:@"reservedTime"]substringToIndex:19];
    _startAndEndAddressTv.text = [NSString stringWithFormat:@"起点：%@\n终点：%@",[_dataSource valueForKey:@"reservedPlace"],[_dataSource valueForKey:@"targetAddress"]];
    _awardLb.text              = [NSString stringWithFormat:@"%@元",[_dataSource valueForKey:@"driverDeductScale"]];
    _weightLb.text             = [NSString stringWithFormat:@"%@公斤",[_dataSource valueForKey:@"itemWeight"]];
    _goodsNameLb.text          = [_dataSource valueForKey:@"itemName"];
    _distanceLb.text           = [NSString stringWithFormat:@"%@公里",[_dataSource valueForKey:@"kilometerNumber"]];
    
    _PayMethodLb.text          = [_dataSource valueForKey:@"payerTypeStr"];
    
    if ([[_dataSource valueForKey:@"paymentTypeStr"]isEqualToString:@"已支付"]) {
        _customPayMoneyLb.text     = @"已支付";
    }
    else
    {
        if ([[_dataSource valueForKey:@"payerTypeStr"]isEqualToString:@"收件人"]) {
            _customPayMoneyLb.text     = [NSString stringWithFormat:@"%@元(请向发件人代收费)",[_dataSource valueForKey:@"factMoney"]];
        }else
        {
            _customPayMoneyLb.text     = [NSString stringWithFormat:@"%@(请向收件人代收费)",[_dataSource valueForKey:@"factMoney"]];
        }
    }
        
    _noteLb.text               = [_dataSource valueForKey:@"memoInfo"];
    
    [[NSUserDefaults standardUserDefaults]setValue:[_dataSource valueForKey:@"cloudCallNumber"] forKey:@"sendPhoneNum"];
    [[NSUserDefaults standardUserDefaults]setValue:[_dataSource valueForKey:@"customerUserPhone"] forKey:@"receivePhoneNum"];
    
}
-(void)dealKeyboard
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)keyboardWillChangeFrame:(NSNotification *)note
{
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
        [UIView animateWithDuration:duration animations:^{
            _scrollViewJumpedUp.constant =_SCREEN_HEIGHT_ - [note.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue].origin.y;
        } completion:^(BOOL finished) {
        }];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)servicePhoneNum:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"拨打客服号码咨询" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    alert.tag = serviceTag;
    [alert show];
}
#pragma mark alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == serviceTag) {
        if (buttonIndex  == 0) {
            NSURL *servicePhoneNumberUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[[SystemConfig shareSystemConfig] getServiceNumber]]];
            [[UIApplication sharedApplication]openURL:servicePhoneNumberUrl];
        }
    }else if (alertView.tag == sendphoneTag)
    {
        if (buttonIndex == 0) {
            NSURL *servicePhoneNumberUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"sendPhoneNum"]]];
            [[UIApplication sharedApplication]openURL:servicePhoneNumberUrl];
        }
    
    }else if (alertView.tag == receivephoneTag)
    {
        
        if (buttonIndex == 0) {
            NSURL *servicePhoneNumberUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"receivePhoneNum"]]];
            [[UIApplication sharedApplication]openURL:servicePhoneNumberUrl];
        }
    }
}

#pragma mark setting about textfield

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_deliverVerityCodeTf resignFirstResponder];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
-(void)fingerTaped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}

- (IBAction)returnBtClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dailSendPersonPhone:(UIButton *)sender {
    NSString *phoneString = [[NSUserDefaults standardUserDefaults]valueForKey:@"sendPhoneNum"];
    NSString *tipString = [NSString stringWithFormat:@"拨打寄件人号码 #%@#",phoneString];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:tipString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = sendphoneTag;
    [alert show];
}

- (IBAction)dailReceivePersonPhone:(UIButton *)sender {
    NSString *phoneString = [[NSUserDefaults standardUserDefaults]valueForKey:@"receivePhoneNum"];
    NSString *tipString = [NSString stringWithFormat:@"拨打收件人号码 #%@#",phoneString];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:tipString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = receivephoneTag;
    [alert show];
}

- (IBAction)startToSendClicked:(UIButton *)sender {
    
    if ([[_dataSource objectForKey:@"orderTaskStatus"]isEqualToString:@"1"]) {
        [self connectToSendGetPackageVerifyCode];
    }
    else if ([[_dataSource objectForKey:@"orderTaskStatus"]isEqualToString:@"2"])
    {
            if ([[_dataSource valueForKey:@"isQuJianPass"]isEqualToString:@""]&&[[_dataSource valueForKey:@"isShouJianPass"]isEqualToString:@""])
        {
            
            if ([_deliverVerityCodeTf.text isEqualToString:@""]) {
                ALERT_VIEW(@"请输入验证码");
            }
            else{
                [self connectToSendCustomerReceiveVerifyCode];
            }
        }
        else
        {
            [self connectToSendCustomerReceiveVerifyCode];
        }
    }
    else if ([[_dataSource objectForKey:@"orderTaskStatus"]isEqualToString:@"3"])
    {
        if ([[_dataSource valueForKey:@"isQuJianPass"]isEqualToString:@""]&&[[_dataSource valueForKey:@"isShouJianPass"]isEqualToString:@""]) {
            
            if ([_deliverVerityCodeTf.text isEqualToString:@""]) {
                ALERT_VIEW(@"请输入验证码");
            }
            else{
                [self connectToCompeleteOrder];
            }
        }
        else{
            [self connectToCompeleteOrder];
        }
    }
}
- (IBAction)planTraceBtClicked:(UIButton *)sender {
    
    MapViewController *mapView = [[MapViewController alloc]init];
    mapView.pushFromWhere = @"planTrace";
    mapView.orderID = [_dataSource valueForKey:@"orderId"];
    [self.navigationController pushViewController:mapView animated:YES];
}

#pragma mark network 

-(void)connectToSendGetPackageVerifyCode
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss SSS";
    
    [NetWorkTool postToSendGetPackageCodeWith:@{@"orderId":_orderId,
                                                @"arriveTime":[formatter stringFromDate:[NSDate date]],
                                                @"isQuJianPass":[_dataSource valueForKey:@"isQuJianPass"],
                                                @"isShouJianPass":[_dataSource valueForKey:@"isShouJianPass"],@"nowDate":[NSString stringWithFormat:@"%@",[NSDate date]]} addProgressHudOn:self.view successReturn:^(id successReturn) {
        
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
       
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];
                                            
    if ([[jsonDict valueForKey:@"result"]isEqualToString:@"true"]) {
        
        [_dataSource setValue:@"2" forKey:@"orderTaskStatus"];
        _deliverVerityCodeTf.text = @"";
        
        NSMutableArray *dataArray = [[NSMutableArray alloc]initWithArray:[[SystemConfig shareSystemConfig]getRunningOrder]];

        for (NSDictionary *dict in [[SystemConfig shareSystemConfig]getRunningOrder]) {
            if ([[dict valueForKey:@"orderId"]isEqualToString:_orderId]) {
                [dataArray removeObject:dict];
                [dataArray addObject:_dataSource];
                [[SystemConfig shareSystemConfig]saveRunningOrderList:dataArray];
            }
        }
        if ([[_dataSource valueForKey:@"isQuJianPass"]isEqualToString:@"Y"]&&[[_dataSource valueForKey:@"isShouJianPass"]isEqualToString:@"Y"]) {
            [_sendVerityCodeBt setTitle:deliverState2 forState:UIControlStateNormal];
        }
        else
        {
            [_sendVerityCodeBt setTitle:txtMsgState2 forState:UIControlStateNormal];
            NSDateFormatter *fomatter = [[NSDateFormatter alloc]init];
            [fomatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            _getPackageTimeLb.text =[fomatter stringFromDate:[NSDate date]];
            ALERT_VIEW(@"取件密码发送成功!");
            _sendVertifyCodeToTf.constant = 5;
        }
        
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
    [NetWorkTool postToSendReceiveCodeWith:@{@"orderId":_orderId,
                                             @"serviceStartTime":[formatter stringFromDate:[NSDate date]],
                                             @"courierTakePwd":_deliverVerityCodeTf.text,
                                             @"isQuJianPass":[_dataSource valueForKey:@"isQuJianPass"],
                                             @"isShouJianPass":[_dataSource valueForKey:@"isShouJianPass"],@"nowDate":[NSString stringWithFormat:@"%@",[NSDate date]]} addProgressHudOn:self.view successReturn:^(id successReturn) {
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                                                 
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        if ([[jsonDict valueForKey:@"result"]isEqualToString:@"true"]) {
                                                     
        [_dataSource setValue:@"3" forKey:@"orderTaskStatus"];
        _deliverVerityCodeTf.text = @"";
            
        NSMutableArray *dataArray = [[NSMutableArray alloc]initWithArray:[[SystemConfig shareSystemConfig]getRunningOrder]];
                                                     
            for (NSDictionary *dict in [[SystemConfig shareSystemConfig]getRunningOrder]) {
                if ([[dict valueForKey:@"orderId"]isEqualToString:_orderId]) {
                [dataArray removeObject:dict];
                [dataArray addObject:_dataSource];
                [[SystemConfig shareSystemConfig]saveRunningOrderList:dataArray];
                }
            }
            if ([[_dataSource valueForKey:@"isQuJianPass"]isEqualToString:@"Y"]&&[[_dataSource valueForKey:@"isShouJianPass"]isEqualToString:@"Y"]) {
                    [_sendVerityCodeBt setTitle:deliverState3 forState:UIControlStateNormal];
                }
            else
                {
                    [_sendVerityCodeBt setTitle:txtMsgState3 forState:UIControlStateNormal];
                    _sendVertifyCodeToTf.constant = 5;
                }
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
    [NetWorkTool postToSendCompleteCodeWith:@{@"orderId":_orderId,
                                              @"serviceEndTime":[formatter stringFromDate:[NSDate date]],
                                              @"isQuJianPass":[_dataSource valueForKey:@"isQuJianPass"],
                                              @"isShouJianPass":[_dataSource valueForKey:@"isShouJianPass"],
                                              @"customerTakePwd":_deliverVerityCodeTf.text,
                                              @"nowDate":[NSString stringWithFormat:@"%@",[NSDate date]]} addProgressHudOn:self.view successReturn:^(id successReturn) {
                                                  
    NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//    NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];
    
    if ([[jsonDict valueForKey:@"result"]isEqualToString:@"true"])
    {
        NSMutableArray *dataArray = [[NSMutableArray alloc]initWithArray:[[SystemConfig shareSystemConfig]getRunningOrder]];
        
        for (NSDictionary *dict in [[SystemConfig shareSystemConfig]getRunningOrder]) {
            if ([[dict valueForKey:@"orderId"]isEqualToString:_orderId]) {
                [dataArray removeObject:dict];
                [[SystemConfig shareSystemConfig]saveRunningOrderList:dataArray];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    else
    {
        ALERT_VIEW([jsonDict valueForKey:@"msg"])
    }
    } failed:^(id failed) {
        
    }];
    
}

-(NSMutableArray *)getIfsendPass:(NSString *)orderID
{
    NSMutableArray *returnArray = [[NSMutableArray alloc]init];
    NSArray *array = [[SystemConfig shareSystemConfig]getRunningOrder];
    for (NSDictionary *dict in array) {
        if ([[dict valueForKey:@"orderId"]isEqualToString:orderID]) {
            [returnArray addObject:[dict valueForKey:@"isQuJianPass"]];
            [returnArray addObject:[dict valueForKey:@"isShouJianPass"]];
        }
    }
    return returnArray;
}

@end
