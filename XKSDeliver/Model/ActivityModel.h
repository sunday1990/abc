//
//  ActivityModel.h
//  XKSDeliver
//
//  Created by ccSunday on 2017/2/17.
//  Copyright © 2017年 同行必达. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject

@property (nonatomic,copy)NSString *hasActivity;//true代表有活动；否则无活动；ok;

@property (nonatomic,copy)NSString *linkUrl;    //海报链接地址；

@property (nonatomic,copy)NSString *btnLinkUrl; //分享和海报详情链接地址；

@property (nonatomic,copy)NSString *isShowBtn; // 0-显示，1-不显示;——

@property (nonatomic,copy)NSString *btnMsg;     //进入海报详情的控件显示文字；

@property (nonatomic,copy)NSString *isShowShareBtn;//:0-显示，1-不显示;——

@property (nonatomic,copy)NSString *shareBtnMsg; //分享控件显示的文字；

@property (nonatomic,copy)NSString *shareTitle;   //分享内容的标题；

@property (nonatomic,copy)NSString *shareImg ;     //分享的图片地址；


@end
