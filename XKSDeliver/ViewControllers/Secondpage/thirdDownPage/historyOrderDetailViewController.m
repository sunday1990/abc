//
//  historyOrderDetailViewController.m
//  XKSDeliver
//
//  Created by 同行必达 on 15/11/17.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import "historyOrderDetailViewController.h"
#import "SystemConfig.h"
#import "NetWorkTool.h"

#import "UMSocial.h"
#import "UMSocialControllerService.h"
#import <Social/Social.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>




@interface historyOrderDetailViewController ()<UIAlertViewDelegate>

@end

@implementation historyOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self connectOrderDetailData];
    [self deployUI];
    
}
-(void)deployUI
{
    if ([_fromWhich isEqualToString:@"OrderListViewController"]) {
        _orderDetailTitleLb.text = @"历史订单详情";
    }else if ([_fromWhich isEqualToString:@"AccountDetail"])
    {
        _orderDetailTitleLb.text = @"订单详细信息";
    }
    if ([[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"1"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"3"]||[[[SystemConfig shareSystemConfig]getDeliverType]isEqualToString:@"4"]) {
        _topToLineThree.constant = -30;
        [self updateViewConstraints];
    }
    if ([WXApi isWXAppInstalled]) {
        _timeLineBt.hidden = NO;
        _weChantBt.hidden = NO;
    }else{
        _timeLineBt.hidden = YES;
        _weChantBt.hidden = YES;
    }
    
    if ([QQApiInterface isQQInstalled]) {
        _QQBt.hidden = NO;
    }else{
        _QQBt.hidden = YES;
    }

    
}
-(void)connectOrderDetailData
{
    __weak typeof(self) this = self;
    
    [NetWorkTool getRequestWithUrl:__orderDetail param:@{@"orderId":_orderNumber,} addProgressHudOn:self.view Tip:@"订单详情" successReturn:^(id successReturn) {
    NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        if ([[jsonDict valueForKey:@"isAwardOrder"]isEqualToString:@"1"])
        {
            _contentsizeToBottom.constant = 49+50;
            _shareView.hidden             = NO;
            [this deployUI];
            [this connetToOrderShareData];
        }
        this.dataSource = jsonDict;
        [this loadDataFromProperty];
    } failed:^(id failed) {
        
    }];
}
-(void)loadDataFromProperty
{
    _orderNumberLb.text         = [_dataSource objectForKey:@"orderNo"];
    
    //order status
    if ([[[_dataSource objectForKey:@"orderTaskStatus"]stringValue]isEqualToString:@"4"]) {
        _orderStateLb.text          = @"已经完成";
    }else
    {
        _orderStateLb.text          = [[_dataSource valueForKey:@"orderTaskStatus"]stringValue];
    }
    
    if ([[_dataSource valueForKey:@"orderExecuteTypeStr"]isEqualToString:@""]) {
        _lineOrderToTop.constant = -30;
    }else
    {
        _orderTypeLb.text        = [_dataSource valueForKey:@""];
    }
    
    //paymentTypeStr = ?
    if ([[_dataSource valueForKey:@"paymentTypeStr"]isEqualToString:@"已支付"]) {
        _orderMoneyLb.text          = [_dataSource objectForKey:@"paymentTypeStr"];
    }
    else if ([[_dataSource valueForKey:@"paymentTypeStr"]isEqualToString:@""])
    {
        //payerType  支付方【0、寄件人1、收件人】
        if ([[_dataSource objectForKey:@"payerType"]isEqualToString:@"1"]) {
            _orderMoneyLb.text          = [NSString stringWithFormat:@"%@(收件人现金支付)",[_dataSource objectForKey:@"serviceMoney"]];
        }else
        {
            _orderMoneyLb.text          = [NSString stringWithFormat:@"%@元(寄件人现金支付)",[_dataSource objectForKey:@"serviceMoney"]];
        }
    }
    _driverDeductLb.text        = [NSString stringWithFormat:@"%@元",[_dataSource objectForKey:@"driverDeductScale"]];
    _customerNameLb.text        = [_dataSource objectForKey:@"sendUserName"];
    _receivePackageNameLb.text  = [_dataSource objectForKey:@"receiveUserName"];
    _addressTv.text          = [NSString stringWithFormat:@"寄件地址:   %@\n收件地址:   %@",[_dataSource objectForKey:@"reservedPlace"],[_dataSource objectForKey:@"targetAddress"]];
    _addressTv.font          = [UIFont fontWithName:@"Helvetica" size:16.0];
    _orderConfirmLb.text     = [_dataSource objectForKey:@"operateTime"];
    
    if ([[_dataSource valueForKey:@"sendTimeAppointment"]isEqualToString:@""]) {
        _reserveArriveTimeLbToOrderConfirmLb.constant = -30;
    }
    else
    {
        _reserveArriveTimeLb.text = [_dataSource valueForKey:@"orderExecuteTypeStr"];
    }

    _getPackageTimeLb.text      = [_dataSource objectForKey:@"arriveTime"];
    
    if ([[_dataSource objectForKey:@"itemName"]isEqualToString:@""]) {
    
        _goodsNameLb.text           = @"--";
    }else
    {
        _goodsNameLb.text           = [_dataSource objectForKey:@"itemName"];
    }
    
    _packageArriveTimeLb.text   = [_dataSource objectForKey:@"serviceEndTime"];
    _totalUseTimeLb.text        = [NSString stringWithFormat:@"%@分钟",[_dataSource objectForKey:@"useTime"]];
    _remarkLb.text              = [_dataSource objectForKey:@"userMemoInfo"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)returnBtClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)callServiceBtClicked:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"拨打客服号码咨询" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    [alert show];
}
#pragma mark alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex  == 0) {
        NSURL *servicePhoneNumberUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[[SystemConfig shareSystemConfig] getServiceNumber]]];
        [[UIApplication sharedApplication]openURL:servicePhoneNumberUrl];
    }
}

-(CGSize)textSizeWithText:(NSString *) text font:(UIFont*) font width:(CGFloat) width
{
    if (text==nil||[text isKindOfClass:[NSNull class]]) {
        
        return CGSizeZero;
    }
    CGSize size=[self textSizeWithText:text font:font];
    int row = size.width/width+1;
    return CGSizeMake(width, row*(size.height+1));
}
-(CGSize)textSizeWithText:(NSString *) text font:(UIFont *) font{
    if (text==nil||[text isKindOfClass:[NSNull class]]) {
        
        return CGSizeZero;
    }
    return [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
}


- (IBAction)shareToTimeLineBtClicked:(UIButton *)sender {
    
    [self shareToTimeLine:sender];
}

- (IBAction)shareBtClicked:(UIButton *)sender {
    
    if (sender.tag == 111) {
        [self shareBtClicked:sender];
    }else if (sender.tag == 222)
    {
        [self shareToWeChant:sender];
    }else if (sender.tag == 333)
    {
        [self shareToSinaBlog:sender];
    }else if (sender.tag == 444)
    {
        [self shareToQQ:sender];
    }else if (sender.tag == 555)
    {
        [self shareToMessage:sender];
    }
}

-(void)shareToTimeLine:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [[_shareContent valueForKey:@"msg"]valueForKey:@"linkUrl"];
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:[[_shareContent valueForKey:@"msg"]valueForKey:@"title"] image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[_shareContent valueForKey:@"msg"]valueForKey:@"shareImg"]]]] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        sender.userInteractionEnabled = YES;
        if (response.responseCode == UMSResponseCodeSuccess) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
        }
    }];
}

-(void)shareToWeChant:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = [[_shareContent valueForKey:@"msg"]valueForKey:@"title"];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [[_shareContent valueForKey:@"msg"]valueForKey:@"linkUrl"];
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:[[_shareContent valueForKey:@"msg"]valueForKey:@"shareContent"] image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[_shareContent valueForKey:@"msg"]valueForKey:@"shareImg"]]]] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        sender.userInteractionEnabled = YES;
        if (response.responseCode == UMSResponseCodeSuccess) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
        }
    }];
    
}

-(void)shareToSinaBlog:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    /*
     [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
     NSLog(@"response is %@",response);
     }];
     */
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSina] content:[[_shareContent valueForKey:@"msg"]valueForKey:@"shareContent"] image:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[_shareContent valueForKey:@"msg"]valueForKey:@"shareImg"]]] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        sender.userInteractionEnabled = YES;
        if (response.responseCode == UMSResponseCodeSuccess) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
        }
    }];
}

-(void)shareToQQ:(UIButton *)sender{
    
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    //mac电脑只能接到纯文字完整内容
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQQ] content:[[_shareContent valueForKey:@"msg"]valueForKey:@"shareContent"] image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        sender.userInteractionEnabled  = YES;
        if (response.responseCode == UMSResponseCodeSuccess) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
        }
    }];
}

-(void)shareToMessage:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSms] content:[[_shareContent valueForKey:@"msg"]valueForKey:@"shareContent"] image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        sender.userInteractionEnabled = YES;
        if (response.responseCode == UMSResponseCodeSuccess) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
        }
    }];
    
}

-(void)connetToOrderShareData
{
    [NetWorkTool getRequestWithUrl:__shareOrder param:@{@"orderId":_orderNumber} addProgressHudOn:self.view Tip:@"" successReturn:^(id successReturn) {
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        _shareContent = jsonDict;
        
        
    }failed:^(id failed) {
    }];
}








@end
