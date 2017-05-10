//
//  WithDrawMoneyController.m
//  XKSDeliver
//
//  Created by 同行必达 on 15/11/24.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import "WithDrawMoneyController.h"
#import "SystemConfig.h"
#import "NetWorkTool.h"

NSInteger withDraw = 88;
NSInteger dailNum  = 77;

@interface WithDrawMoneyController ()

@end

@implementation WithDrawMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)returnBtClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)serviceBtClicked:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"拨打客服号码咨询" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    alert.tag = dailNum;
    
    [alert show];
}
#pragma mark alert delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == dailNum) {
        if (buttonIndex  == 0) {
            NSURL *servicePhoneNumberUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[[SystemConfig shareSystemConfig]getServiceNumber]]];
            [[UIApplication sharedApplication]openURL:servicePhoneNumberUrl];
        }
    }else if (alertView.tag == withDraw)
    {
        if (buttonIndex == 0) {
            
        }else if (buttonIndex == 1)
        {
            [self connectToConfirmWithDrawMoney];
        }
    }
}

- (IBAction)confirmToWithdrawBt:(UIButton *)sender {
    
    [_withDrawMoneyTf resignFirstResponder];
    
    if ([_withDrawMoneyTf.text isEqualToString:@""]) {
        ALERT_VIEW(@"输入的提现金额为空请重新输入!");
    }else
    {
        NSString *message = [NSString stringWithFormat:@"确认提现 ￥%@ 元",_withDrawMoneyTf.text];
        UIAlertView *withDrawAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        withDrawAlert.tag = withDraw;
        [withDrawAlert show];
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![_withDrawMoneyTf isExclusiveTouch]) {
        [_withDrawMoneyTf resignFirstResponder];
    }
}
-(void)connectToConfirmWithDrawMoney
{
    [NetWorkTool getRequestWithUrl:__withDrawHistoryRecord param:@{@"detailOrApplyMark":@"1",@"applyMoney":_withDrawMoneyTf.text,} addProgressHudOn:self.view Tip:@"正在提现" successReturn:^(id successReturn) {
        
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        if ([[jsonDict valueForKey:@"result"]isEqualToString:@"true"]) {
            
            NSString *tipString = [NSString stringWithFormat:@"您已经成功提出 ￥%@元 的提现申请",_withDrawMoneyTf.text];
            ALERT_VIEW(tipString);
            
        }else
        {
            ALERT_VIEW([jsonDict valueForKey:@"msg"]);
        }
        
    } failed:^(id failed) {
                
    }];
    
}
@end
