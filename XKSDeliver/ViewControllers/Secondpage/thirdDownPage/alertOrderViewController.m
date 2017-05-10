//
//  alertOrderViewController.m
//  alertcusteomdf
//
//  Created by 同行必达 on 15/12/17.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import "alertOrderViewController.h"
#import "common.h"

@interface alertOrderViewController ()

@end

@implementation alertOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_orderComePlayer stop];
    
    // Do any additional setup after loading the view from its nib.
    
    if ([UIScreen mainScreen].bounds.size.height < 500) {
        _imageViewToTop.constant = 120;
    }
    [self settingMusic];
    [self performSelector:@selector(autoFinishAlert) withObject:nil afterDelay:_ALERT_DISPLAY_TIME_];
}
-(void)autoFinishAlert
{
    [_orderComePlayer stop];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)settingMusic
{
    // 取出资源的URL
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"new_order.caf" withExtension:nil];
    // 创建播放器
    NSError *error = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    _orderComePlayer = player;
    _orderComePlayer.numberOfLoops = -1;
    [_orderComePlayer prepareToPlay];
    [_orderComePlayer play];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getOrderBtClicked:(UIButton *)sender {
    
    [_orderComePlayer stop];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self.alertOrderDelegate alertOrderViewClicked:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
}
@end
