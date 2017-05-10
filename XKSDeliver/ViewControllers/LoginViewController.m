//
//  LoginViewController.m
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/13.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import "LoginViewController.h"
#import "common.h"
#import "SystemDetailViewController.h"
#import "NetWorkTool.h"
#import "SystemConfig.h"
#import "OrderViewController.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
//@class OrderViewController;

@interface LoginViewController()

@end
@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self deployUI];
//    [self defaultAutoLogin];
  //  [self dealKeyboard];]
//    [self requestActivity];
    
}
- (void)requestActivity{
    
    NSDictionary *dict = @{@"driverIMEI":[[SystemConfig shareSystemConfig]getDeviceToken]};
    [NetWorkTool postRequestWithUrl:__ActivityUrl param:dict addProgressHudOn:self.view Tip:@"" successReturn:^(id successReturn) {
//        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        if ([jsonDict[@"result"] isEqualToString:@"true"]) {
            NSDictionary *json = jsonDict[@"data"];
            
            if ([json[@"hasActivity"] boolValue] == YES) {
            }
        }else{
            ALERT_HUD(self.view, successReturn[@"msg"]);
        }
    } failed:^(id failed) {
        
    }];
}



-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
-(void)defaultAutoLogin
{
    NSDictionary *dict = @{@"n":[[SystemConfig shareSystemConfig]getUserName],@"p":[[SystemConfig shareSystemConfig]getUserPassword]};
    
    if (![[[SystemConfig shareSystemConfig]getUserPassword]isEqualToString:@""]) {
        [NetWorkTool postToLoginWithParam:@{@"n":[[SystemConfig shareSystemConfig]getUserName],@"p":[[SystemConfig shareSystemConfig]getUserPassword]} addProgressHudOn:self.view successReturn:^(id successReturn) {
            
            
            if ([[successReturn valueForKey:ifsuccess]isEqualToString:@"1"]) {
                
                [[SystemConfig shareSystemConfig]saveLoginTime:[NSString stringWithFormat:@"%@",[NSDate date]]];
                [[NSUserDefaults standardUserDefaults]setValue:[NSDate date] forKey:@"uploadtime"];
                
                [[SystemConfig shareSystemConfig]saveOnlineStatus:[successReturn valueForKey:_ONLINE_STATUS_]];
                [[SystemConfig shareSystemConfig]saveUserStatus:_status_online_];
                
                [[SystemConfig shareSystemConfig]saveSleepTime:[successReturn valueForKey:_SLEEP_TIME_]];
                [[SystemConfig shareSystemConfig]saveServiceNumber:[successReturn valueForKey:_SERVICE_NUMBER_]];
                [[SystemConfig shareSystemConfig]savePositionOffsetPeriod:[successReturn valueForKey:_POSITION_OFFSET_PERIOD_]];
                [[SystemConfig shareSystemConfig]saveSessionTimeOut:[successReturn valueForKey:_SESSIOIN_TIMEOUT_]];
                
                [self.Jugedelegate sendLoginStatusString:@"1"];
                
                self.navigationController.tabBarController.tabBar.hidden = NO;
                self.tabBarController.selectedIndex = 0;
//                [self dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if ([[successReturn valueForKey:ifsuccess]isEqualToString:@"74"])
            {
                ALERT_VIEW(@"您被禁止登陆，详情请咨询客服,客服电话：进入绑定手机页面点击右上角");
            }
            else if ([[successReturn valueForKey:ifsuccess]isEqualToString:@"-1331"])
            {
                ALERT_VIEW(@"不匹配的IMEI码，请绑定当前手机或使用已绑定手机");
            }
            else if ([[successReturn valueForKey:ifsuccess]isEqualToString:@"-1333"])
            {
                ALERT_VIEW(@"请绑定手机");
            }
            else if ([[successReturn valueForKey:ifsuccess]isEqualToString:@"4"])
            {
                ALERT_VIEW(@"错误的登录名或密码");
            }
            else if ([[successReturn valueForKey:ifsuccess]isEqualToString:@"-1332"])
            {
                ALERT_VIEW(@"未提交IMEI码");
            }
            
            
        } failed:^(id failed) {
            
        }];
    }
}

-(void)deployUI
{
    self.navigationController.tabBarController.tabBar.hidden = YES;
    _AccountTf.text = [[SystemConfig shareSystemConfig]getUserName];
    _AccountTf.keyboardType = UIKeyboardTypeNumberPad;
    _PasswordTf.text = [[SystemConfig shareSystemConfig]getUserPassword];
    [_AccountTfImage addSubview:_AccountTf];
    [_PasswordTfImage addSubview:_PasswordTf];    
    _loginBtContentToTop.constant = _SCREEN_HEIGHT_/5*3-20;
    _logoImageView.animationImages = @[LOADIMAGE(@"loginPagelogo_@2x", @"png"),LOADIMAGE(@"loginPagelogo_@2x", @"png"),LOADIMAGE(@"loginPagelogo_@2x", @"png")];
    _logoImageView.animationDuration = 1;
    _logoImageView.animationRepeatCount = 0;
    [_logoImageView startAnimating];
}

-(void)dealKeyboard
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)keyboardWillChangeFrame:(NSNotification *)note
{
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    [UIView animateWithDuration:duration animations:^{
       // _scrollViewJumpedUp.constant =_SCREEN_HEIGHT_ - [note.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue].origin.y;
        _loginControllerview.frame = CGRectMake(0,-(_SCREEN_HEIGHT_-[note.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue].origin.y), _SCREEN_WIDTH_, _SCREEN_HEIGHT_);
        
    } completion:^(BOOL finished) {
      //  _loginControllerview.frame = CGRectMake(0,0, _SCREEN_WIDTH_, _SCREEN_HEIGHT_);
    }];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![_AccountTf isExclusiveTouch]) {
        [_AccountTf resignFirstResponder];
    }
    if (![_PasswordTf isExclusiveTouch]) {
        [_PasswordTf resignFirstResponder];
    }
}

- (IBAction)loginBtClicked:(UIButton *)sender {
    NSDictionary *dict = @{@"n":[[SystemConfig shareSystemConfig]getUserName],@"p":[[SystemConfig shareSystemConfig]getUserPassword]};
    NSLog(@"userInfo%@",dict);
    if (![[[SystemConfig shareSystemConfig]getUserName]isEqualToString:_AccountTf.text]) {
        [[SystemConfig shareSystemConfig]clearSystemConfigData];
    }
    if (![_AccountTf.text isEqualToString:@""]) {
        if (![_PasswordTf.text isEqualToString:@""]) {
            [NetWorkTool postToLoginWithParam:@{@"n":_AccountTf.text,@"p":_PasswordTf.text,} addProgressHudOn:self.view successReturn:^(id successReturn) {
                if ([[successReturn valueForKey:ifsuccess]isEqualToString:@"1"]) {
                    
                    [[SystemConfig shareSystemConfig]saveLoginTime:[NSString stringWithFormat:@"%@",[NSDate date]]];
                    [[NSUserDefaults standardUserDefaults]setValue:[NSDate date] forKey:@"uploadtime"];
                    
                    [[SystemConfig shareSystemConfig]saveUserName:_AccountTf.text];
                    [[SystemConfig shareSystemConfig]saveUserPassword:_PasswordTf.text];
                    [[SystemConfig shareSystemConfig]saveOnlineStatus:[successReturn valueForKey:_ONLINE_STATUS_]];
                    [[SystemConfig shareSystemConfig]saveUserStatus:_status_online_];
                    
                    [[SystemConfig shareSystemConfig]saveSleepTime:[successReturn valueForKey:_SLEEP_TIME_]];
                    [[SystemConfig shareSystemConfig]saveServiceNumber:[successReturn valueForKey:_SERVICE_NUMBER_]];
                    [[SystemConfig shareSystemConfig]savePositionOffsetPeriod:[successReturn valueForKey:_POSITION_OFFSET_PERIOD_]];
                    [[SystemConfig shareSystemConfig]saveSessionTimeOut:[successReturn valueForKey:_SESSIOIN_TIMEOUT_]];
                    self.navigationController.tabBarController.tabBar.hidden = NO;
                    self.tabBarController.selectedIndex  = 0;
                    [self.Jugedelegate sendLoginStatusString:@"1"];
                    [self.navigationController popViewControllerAnimated:NO];

                    //[self newThreadToUpLoadLocation];
                }
                else if ([[successReturn valueForKey:ifsuccess]isEqualToString:@"74"])
                {
                    ALERT_VIEW(@"您被禁止登陆，详情请咨询客服,客服电话：进入绑定手机页面点击右上角");
                }
                else if ([[successReturn valueForKey:ifsuccess]isEqualToString:@"-1331"])
                {
                    ALERT_VIEW(@"不匹配的IMEI码，请绑定当前手机或使用已绑定手机");
                }
                else if ([[successReturn valueForKey:ifsuccess]isEqualToString:@"-1333"])
                {
                    ALERT_VIEW(@"请绑定手机");
                }
                else if ([[successReturn valueForKey:ifsuccess]isEqualToString:@"4"])
                {
                    ALERT_VIEW(@"错误的登录名或密码");
                }
                else if ([[successReturn valueForKey:ifsuccess]isEqualToString:@"-1332"])
                {
                    ALERT_VIEW(@"未提交IMEI码");
                }

            } failed:^(id failed) {
            }];
            
        }else
        {
            ALERT_VIEW(@"请输入密码");
        }
        
    }else
    {
        ALERT_VIEW(@"请输入账户名称");
    }
}

#pragma mark upload location
-(void)newThreadToUpLoadLocation
{
   // NSString *imeiString = @"864593021304521";
    NSString *imeiString = [[SystemConfig shareSystemConfig]getDeviceToken];
    // from android "MM-dd HH:mm:ss"
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    // splice the param string
    NSString *OtherFourParam = [NSString stringWithFormat:@";%@,%@,%@,gps",[[SystemConfig shareSystemConfig]getUserLocationLatitude],[[SystemConfig shareSystemConfig]getUserLocationLongtitude],[dateFormatter stringFromDate:[NSDate date]]];
    NSString *paramString = [imeiString stringByAppendingString:OtherFourParam];
    
    [NetWorkTool postToUpLoadLocationWithParam:@{@"p":paramString,} successReturn:^(id successReturn) {
        
//        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        NSLog(@"upload success %@",jsonDict);
    } failed:^(id failed) {
       // NSLog(@"upload failed %@",failed);
    }];
}

//之前的清理密码,改为注册
- (IBAction)clearDataBtClicked:(UIButton *)sender {
    [self userRegister];
}

- (void)userRegister{
    //注册
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    WEAK(self);
    registerVC.successRegist = ^{
        _AccountTf.text = [[SystemConfig shareSystemConfig]getUserName];
        _PasswordTf.text = [[SystemConfig shareSystemConfig]getUserPassword];
        [weakself defaultAutoLogin];
    };
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)bindBtnClicked:(UIButton *)sender {
    SystemDetailViewController *systemDetailView = [[SystemDetailViewController alloc]init];
    systemDetailView.fromWhich = _SYSPAGETITTLE2_;
    [self.navigationController pushViewController:systemDetailView animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
