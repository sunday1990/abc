//
//  AccountInfoModel.h
//  XKSDeliver
//
//  Created by ccSunday on 2017/2/17.
//  Copyright © 2017年 同行必达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface AccountInfoModel : NSObject

@property (nonatomic,strong)NSArray *infos;


@end

@interface AccountModel : NSObject

@end

@interface DetailModel : NSObject

@property (nonatomic, copy)NSString *expense;

@property (nonatomic, copy)NSString *income;

@property (nonatomic, copy)NSString *yearMonth;

@end

