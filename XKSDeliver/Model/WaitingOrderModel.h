//
//  WaitingOrderModel.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/12/7.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WaitingOrderModel : NSObject


//时间  距离  提成  结算
@property (nonatomic,copy)NSString *reserveTime ;
@property (nonatomic,copy)NSString *disTance;
@property (nonatomic,copy)NSString *awardMoney;
@property (nonatomic,copy)NSString *payMethod;

-(NSComparisonResult)compareWithReserveTime:(WaitingOrderModel *)anotherOrder Method:(NSString *)method;
-(NSComparisonResult)compareWithDistance:(WaitingOrderModel *)anotherOrder Method:(NSString *)method;
-(NSComparisonResult)compareWithAwardMoney:(WaitingOrderModel *)anotherOrder Method:(NSString *)method;
-(NSComparisonResult)reverseCompareWithPayMethod:(WaitingOrderModel *)anotherOrder Method:(NSString *)method;


@end
