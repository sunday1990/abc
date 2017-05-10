//
//  SalaryGroup.h
//  XKSDeliver
//
//  Created by ccSunday on 2017/2/18.
//  Copyright © 2017年 同行必达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "common.h"
#import "SalaryItem.h"
@interface SalaryGroup : NSObject

@property (nonatomic,strong)NSMutableArray *items;//对应的工资类型数组

@property (nonatomic,assign)NSInteger positionType;//职位类型

@property (nonatomic, copy)NSString *positionName;//职位名称

@end
