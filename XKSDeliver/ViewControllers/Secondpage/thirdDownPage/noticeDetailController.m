//
//  noticeDetailController.m
//  XKSDeliver
//
//  Created by 同行必达 on 15/12/8.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import "noticeDetailController.h"
#import "SystemConfig.h"
#import "NetWorkTool.h"

@interface noticeDetailController ()<UIAlertViewDelegate>

@end

@implementation noticeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self deployNoticeInfoUI];
    [self connectToNoticeInfo];
    [self dispalyUIData];
}
-(void)deployNoticeInfoUI
{
    
    if ([_fromType isEqualToString:@"present"]) {
        _bottomToTabBar.constant = 0;
    }
    else
    {
        _bottomToTabBar.constant = 49;
    }
    
    _detailTvHeight.constant =_SCREEN_HEIGHT_ - 64 -100 - self.tabBarController.tabBar.frame.size.height;

    //[_detailTv setFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
    
    if (_indexPathRowNum == 0) {
        _lastPageBt.hidden = YES;
    }
    if (_indexPathRowNum == [[SystemConfig shareSystemConfig]getNoticeInfo].count-1)
    {
        _nextPageBt.hidden = YES;
    }
}
-(void)dispalyUIData
{
    _titleLb.text = [[[[SystemConfig shareSystemConfig]getNoticeInfo]objectAtIndex:_indexPathRowNum ]valueForKey:@"noticeTitle"];
    
    _titleLb.adjustsFontSizeToFitWidth = YES;
    

    _timeLb.text  =[NSString stringWithFormat:@"时间:%@",[[[[SystemConfig shareSystemConfig]getNoticeInfo]objectAtIndex:_indexPathRowNum ]valueForKey:@"publicTime"]];
    _originLb.text = [NSString stringWithFormat:@"来源:%@",[[[[SystemConfig shareSystemConfig]getNoticeInfo]objectAtIndex:_indexPathRowNum ]valueForKey:@"companyName"]];
    _detailTv.text = [NSString stringWithFormat:@"  %@",[[[[SystemConfig shareSystemConfig]getNoticeInfo]objectAtIndex:_indexPathRowNum ]valueForKey:@"noticeContent"]];
    _pageLb.text = [NSString stringWithFormat:@"%d/%ld",_indexPathRowNum+1,(unsigned long)[[SystemConfig shareSystemConfig] getNoticeInfo].count];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)returnBtClicked:(UIButton *)sender {
    
    if ([_fromType isEqualToString:@"present"])
    {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self.reloadNoticeListDelegate reloadListFromHeader];
}

- (IBAction)serviceButtonClicked:(UIButton *)sender {
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
- (IBAction)nextBtClicked:(UIButton *)sender {
    _lastPageBt.hidden = NO;
    ++_indexPathRowNum;
    if (_indexPathRowNum == [[SystemConfig shareSystemConfig]getNoticeInfo].count-1) {
        _nextPageBt.hidden = YES;
    }
    [self dispalyUIData];
    [self connectToNoticeInfo];
}

- (IBAction)lastBtClicked:(UIButton *)sender {
    _nextPageBt.hidden = NO;
    --_indexPathRowNum;
    if (_indexPathRowNum == 0) {
        _lastPageBt.hidden = YES;
    }
    [self dispalyUIData];
    [self connectToNoticeInfo];
}
-(void)connectToNoticeInfo
{
    NSString *urlString = nil;
    urlString = [NSString stringWithFormat:@"%@/%@",__noticeData,[[[[SystemConfig shareSystemConfig]getNoticeInfo]objectAtIndex:_indexPathRowNum] valueForKey:@"noticeId"]];
    
    [NetWorkTool getRequestWithUrl:urlString param:nil addProgressHudOn:self.view Tip:@"进行阅读" successReturn:^(id successReturn) {
        
        
    } failed:^(id failed) {
        
    }];
}




@end
