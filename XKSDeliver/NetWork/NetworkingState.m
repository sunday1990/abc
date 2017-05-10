//
//  NetworkingState.m
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/30.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import "NetworkingState.h"
#import <UIKit/UIKit.h>
#import "common.h"


@implementation NetworkingState

+(NetworkingState *)shareNetworkstate
{
    NetworkingState *networkState;

    if (!networkState) {
        networkState = [[NetworkingState alloc]init];
    }
    
    return networkState;
}


-(void)getNeworkingTipOn:(UIView *)targetview withTip:(NSString *)tips
{
    if ([Reachability isConnectionAvailable]==NO) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:targetview animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"无网络访问";
        hud.minSize = CGSizeMake(108.f, 108.0f);
        [hud hide:YES afterDelay:HudDelayTime];
    }
    else
    {
        if (!_addHud) {
            _addHud = [[MBProgressHUD alloc]initWithView:targetview];
            _addHud.tag = MISSTAG;

        }
        //[MBProgressHUD showHUDAddedTo:targetview animated:targetview];
        /*
         UIResponder *nextResponder = [targetview nextResponder];
         if ([nextResponder isKindOfClass:[UIViewController class]]) {
         loginView.delegate = (id)nextResponder;
         }
         */
        _addHud.labelText      = tips;
        [_addHud show:YES];
        _addHud.hidden = NO;
        [targetview addSubview:_addHud];
    }
}

@end

