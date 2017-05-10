//
//  NetworkingState.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/30.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Reachability.h"

#define HudDelayTime 1.5


@interface NetworkingState : NSObject

@property (nonatomic,strong)MBProgressHUD *addHud;

+(NetworkingState *)shareNetworkstate;
-(void)getNeworkingTipOn:(UIView *)targetview withTip:(NSString *)tips;

@end
