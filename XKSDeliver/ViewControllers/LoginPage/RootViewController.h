//
//  RootViewController.h
//  XKSDeliver
//
//  Created by ccSunday on 2017/2/16.
//  Copyright © 2017年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"

@interface RootViewController : UIViewController<UINavigationControllerDelegate>
@property(nonatomic,retain)UIButton *leftNavButton;
@property(nonatomic,retain)UIButton *rightNavButton;
@property(nonatomic,retain)UILabel *titleNavLabel;
@property(nonatomic,retain)UIView *lineView;
@property(nonatomic,retain)UIView *bgNvaView;


-(void)backButtonClick:(UIButton *)button;
-(void)rightNavButtonClick:(UIButton *)button;
-(void)receiveLogOutNotification;
-(void)receiveLoginNotification;

@end
