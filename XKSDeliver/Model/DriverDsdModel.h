//
//  DriverDsdModel.h
//  XKSDeliver
//
//  Created by ccSunday on 2017/2/20.
//  Copyright © 2017年 同行必达. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DriverDsdModel : NSObject
@property (nonatomic,copy)NSString *userID;     //员工id
@property (nonatomic,copy)NSString *name;       //姓名
@property (nonatomic,copy)NSString *workTime;   //工时
@property (nonatomic,copy)NSString *unitNum;    //单量
@property (nonatomic,copy)NSString *isSupport;  //是否是支援
@property (nonatomic,copy)NSString *positionType;//职位类型
@property (nonatomic,copy)NSString *salaryType;   //工资类型
@property (nonatomic,strong)NSMutableArray *valuesArray;

@end
//员工Id、姓名、工时（0—24）、单量、是否是支援（"1"是，"0" 或 “NULL”不是）、职位类型、工资类型】
