//
//  UtilityMethod.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/19.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import "MBProgressHUD.h"
#import "UIColor+expanded.h"

#ifndef UtilityMethod_h
#define UtilityMethod_h
#import <UIKit/UIKit.h>

//alert view
#define ALERT_VIEW(STR) {UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:STR delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];[alert show];}

//load image
#define LOADIMAGE(file,type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:type]]

//RGB color
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define ALERT_HUD(TARGET,STR) {MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:TARGET animated:YES];hud.labelText = STR;[hud hide:YES afterDelay:1.5];hud.mode = MBProgressHUDModeText;hud.removeFromSuperViewOnHide =YES;hud.minSize = CGSizeMake(108.f, 40.0f);hud.yOffset = _SCREEN_WIDTH_/5*3;hud.layer.cornerRadius = 50; hud.labelFont = [UIFont fontWithName:@"Helvetica" size:14.0];}

//获取颜色、font、图片

#define GetColor(color) [UIColor color]
#define GetImage(imageName)  [UIImage imageNamed:imageName]
#define GetFont(x) [UIFont systemFontOfSize:x]
#define GetBoldFont(x) [UIFont boldSystemFontOfSize:x]
//字体
#define FONT(font) [UIFont systemFontOfSize:font]
#define BOLDFONT(font) [UIFont boldSystemFontOfSize:font]

//颜色
#define Color(color) [UIColor color]
#define ROOT_VIEW_BGCOLOR [UIColor colorWithHexString:@"0xefefef"]
#define HexColor(hexStr) [UIColor colorWithHexString:hexStr]
#define LineColourValue [UIColor colorWithHexString:@"0xe1e2e5"]
#define DarkTextColor   [UIColor colorWithHexString:@"0x333333"]
#define LightTextColor  [UIColor colorWithHexString:@"0x666666"]
#define LIGHT_GRAY_COLOR [UIColor colorWithHexString:@"0x999999"]
#define LIGHT_WHITE_COLOR [UIColor colorWithHexString:@"0xffffff"]
//绿色
#define GREEN_COLOR   [UIColor colorWithHexString:@"#00c9b2"]
//黄色
#define YELLOW_COLOR1 [UIColor colorWithHexString:@"#ffad2d"]
//红色
#define RED_COLOR     [UIColor colorWithHexString:@"#ff6464"]

#define RGB(__r,__g,__b) [UIColor colorWithRed:(1.0*(__r)/255 )\
green:(1.0*(__g)/255) \
blue:(1.0*(__b)/255)\
alpha:1]

#define CURRENT_TIME [[NSDate date] timeIntervalSince1970] * 1000;
//图片
#define IMAGE(imageName) [UIImage imageNamed:imageName]
//快速创建控件
//按钮
#define CUSTOMBUTTON [UIButton buttonWithType:UIButtonTypeCustom]
//标签
#define UILABEL [[UILabel alloc] init]



//weak
#define WEAK(object)     __weak typeof(object) weak##object = object;
//自定义Log
#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"<%s:%d> %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif

#endif /* UtilityMethod_h */
