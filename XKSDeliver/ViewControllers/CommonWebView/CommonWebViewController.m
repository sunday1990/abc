//
//  CommonWebViewController.m
//  XKSDeliver
//
//  Created by ccSunday on 2017/2/17.
//  Copyright © 2017年 同行必达. All rights reserved.
//

#import "CommonWebViewController.h"
#import <WebKit/WebKit.h>

@interface CommonWebViewController ()<IMYWebViewDelegate>
{
    UIWebView *localWebView;
    int valState;
}

@end

@implementation CommonWebViewController
@synthesize showWebView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    showWebView = [[IMYWebView alloc]initWithFrame:CGRectMake(0, UI_NAV_BAR_HEIGHT, _SCREEN_WIDTH_, _SCREEN_HEIGHT_-UI_NAV_BAR_HEIGHT) usingUIWebView:NO];
    showWebView.delegate = self;
    [self.view addSubview:showWebView];
    if ([_url rangeOfString:@"http://"].length == 0&&[_url rangeOfString:@"https://"].length == 0) {
        _url = [@"http://" stringByAppendingString:_url];
    }
    [showWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)webView:(IMYWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestUrl = request.URL.absoluteString;
    NSLog(@"requestUrl===%@",requestUrl);
    
    return YES;
}

- (void)webViewDidFinishLoad:(IMYWebView *)webView{
    if (self.webviewSuccessLoaded) {
        self.webviewSuccessLoaded(webView);
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
