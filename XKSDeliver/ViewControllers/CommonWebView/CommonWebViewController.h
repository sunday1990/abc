//
//  CommonWebViewController.h
//  XKSDeliver
//
//  Created by ccSunday on 2017/2/17.
//  Copyright © 2017年 同行必达. All rights reserved.
//

#import "RootViewController.h"
#import "IMYWebView.h"

@interface CommonWebViewController : RootViewController

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) void(^webviewSuccessLoaded)(IMYWebView *webview);
@property (nonatomic, strong)IMYWebView *showWebView;

@end
