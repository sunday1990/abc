//
//  RootViewController.m
//  XKSDeliver
//
//  Created by ccSunday on 2017/2/16.
//  Copyright © 2017年 同行必达. All rights reserved.
//

#import "RootViewController.h"
@interface RootViewController ()

@end

#define GOTO_LOGIN_TAG  123321

@implementation RootViewController
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self isRootViewController]) {
        self.tabBarController.tabBar.hidden = NO;
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self isRootViewController]) {
        self.tabBarController.tabBar.hidden = NO;
        self.bgNvaView.backgroundColor = [UIColor colorWithHexString:@"#00c9b2"];
        self.titleNavLabel.textColor = [UIColor whiteColor];
    }else{
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.tabBarController.tabBar.hidden = YES;
        self.bgNvaView.backgroundColor = RGB(39, 91, 187);
        self.titleNavLabel.textColor = LIGHT_WHITE_COLOR;
//        self.bgNvaView.backgroundColor = [UIColor whiteColor];
//        self.titleNavLabel.textColor = [UIColor colorWithHexString:@"#121212"];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"push"] isEqualToString:@"push"]) {
        //推送导航栏背景调整
        self.bgNvaView.backgroundColor = [UIColor whiteColor];
        self.titleNavLabel.textColor = [UIColor colorWithHexString:@"#121212"];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
}


-(void)receiveLoginNotification
{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = _DEFAULT_BACK_;
    //背景
    _bgNvaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH_, 64)];
    self.bgNvaView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgNvaView];
    
    //标题
    _titleNavLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, _SCREEN_WIDTH_-160, 44)];
    self.titleNavLabel.textAlignment=NSTextAlignmentCenter;
    self.titleNavLabel.font = [UIFont systemFontOfSize:18];
    self.titleNavLabel.textColor = _DEFAULT_BACK_;
    self.titleNavLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.bgNvaView addSubview:_titleNavLabel];
    
    //导航下的线
    _lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 63.5, _SCREEN_WIDTH_, 0.5)];
    _lineView.backgroundColor=_DEFAULT_BACK_;
    _lineView.hidden = NO;
    [self.bgNvaView addSubview:_lineView];
    
    //左侧按钮
    _leftNavButton=[MyControl createButtonWithFrame:CGRectMake(20, 20.5, 44, 44) ImageName:nil Target:self Action:@selector(backButtonClick:) Title:nil];
    _leftNavButton.titleLabel.font = GetFont(15);
    [_leftNavButton setTitle:@"返回" forState:UIControlStateNormal];
//    [_leftNavButton setImage:[UIImage imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
    [self.bgNvaView addSubview:_leftNavButton];
    
    //右侧按钮
    _rightNavButton = [MyControl createButtonWithFrame:CGRectMake(_SCREEN_WIDTH_-50 -8, 23.5, 70, 37) ImageName:nil Target:self Action:@selector(rightNavButtonClick:) Title:nil];
    self.rightNavButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.bgNvaView addSubview:_rightNavButton];
}

-(void)receiveGonggao
{
    for (UINavigationController *nav in self.tabBarController.viewControllers) {
        nav.visibleViewController.tabBarController.selectedIndex = 2;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)isRootViewController
{
    return (self == self.navigationController.viewControllers.firstObject);
}


- (void)backButtonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavButtonClick:(UIButton *)button{
    NSLog(@"右导航点击了");
}

@end
