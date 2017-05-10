//
//  SalaryItem.h
//  XKSDeliver
//
//  Created by ccSunday on 2017/2/18.
//  Copyright © 2017年 同行必达. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SalaryItem : NSObject
@property (nonatomic, copy)NSString *salaryType;    //对应的工资类型
@property (nonatomic, assign)NSInteger salaryTypeID;//工资类型所对应的ID
@end
