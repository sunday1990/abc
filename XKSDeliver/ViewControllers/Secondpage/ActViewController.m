//
//  ActViewController.m
//  XKSDeliver
//
//  Created by ccSunday on 2017/2/17.
//  Copyright © 2017年 同行必达. All rights reserved.
//

#import "ActViewController.h"
#import "ShareView.h"

@interface ActViewController ()

@end

@implementation ActViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bgNvaView.hidden = YES;
    self.showWebView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    WEAK(self);

    UIButton *leftBtn;
    UIButton *rightBtn;
    
    if (self.actModel.isShowBtn.intValue == 1) {
        leftBtn = CUSTOMBUTTON;
        leftBtn.frame = CGRectMake(WIDTH/2-100, _SCREEN_HEIGHT_-150, 80, 30);
        leftBtn.layer.cornerRadius = 5;
        leftBtn.layer.shadowColor = LIGHT_GRAY_COLOR.CGColor;
        leftBtn.titleLabel.font = GetFont(13);
        [leftBtn setTitle:self.actModel.btnMsg forState:UIControlStateNormal];
        [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            NSLog(@"jump");
            [[ShareView sharedShareView]shareViewWithController:self title:self.actModel.shareTitle content:@"同行必达" image:self.actModel.shareImg url:self.actModel.btnLinkUrl filtersIndex:@[@"0",@"1",@"2",@"3",@"5",@"6"]];
        }];
        [leftBtn setTitleColor:LIGHT_WHITE_COLOR forState:UIControlStateNormal];
        leftBtn.backgroundColor = YELLOW_COLOR1;

    }
    //share
//    if (self.actModel.isShowShareBtn.intValue == 1) {
        rightBtn = CUSTOMBUTTON;
        rightBtn.frame = CGRectMake(WIDTH/2+20, _SCREEN_HEIGHT_-150, 80, 30);
        rightBtn.layer.cornerRadius = 5;
        rightBtn.layer.shadowColor = LIGHT_GRAY_COLOR.CGColor;
        rightBtn.titleLabel.font = GetFont(13);
        [rightBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            NSLog(@"share");
            [weakself dismissViewControllerAnimated:YES completion:nil];
        }];
        [rightBtn setTitleColor:LIGHT_WHITE_COLOR forState:UIControlStateNormal];
        rightBtn.backgroundColor = YELLOW_COLOR1;
    
    self.webviewSuccessLoaded = ^(IMYWebView *webview){
        [webview addSubview:leftBtn];
        [webview addSubview:rightBtn];
    };
}

//左侧
- (void)leftBtnClick{
    CommonWebViewController *webVC = [[CommonWebViewController alloc]init];
    webVC.url = self.actModel.btnLinkUrl;
    [self.navigationController pushViewController:webVC animated:YES];
}
//右侧
- (void)rightBtnClick{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)backButtonClick:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
