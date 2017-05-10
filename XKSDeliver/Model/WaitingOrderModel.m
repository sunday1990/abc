//
//  WaitingOrderModel.m
//  XKSDeliver
//
//  Created by 同行必达 on 15/12/7.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import "WaitingOrderModel.h"

@implementation WaitingOrderModel



//method   asc  asending   desc  descending

-(NSComparisonResult)compareWithReserveTime:(WaitingOrderModel *)anotherOrder Method:(NSString *)method
{
    NSComparisonResult compareResult;
    if ([method isEqualToString:@"asc"]) {
        
        if ([self.reserveTime integerValue]>[anotherOrder.reserveTime integerValue])
        {
            compareResult = NSOrderedAscending;
            
        }else if([self.reserveTime integerValue]<[anotherOrder.reserveTime integerValue])
        {
            compareResult = NSOrderedAscending;
        }else
        {
            compareResult = NSOrderedSame;
        }
    }
    else if ([method isEqualToString:@"desc"])
    {
        if ([self.reserveTime integerValue]>[anotherOrder.reserveTime integerValue])
        {
            compareResult = NSOrderedDescending;
        }
        else if([self.reserveTime integerValue]<[anotherOrder.reserveTime integerValue])
        {
            compareResult = NSOrderedDescending;
        }
        else
        {
            compareResult = NSOrderedSame;
        }
    
    }
    else
    {
        compareResult = NSOrderedSame;
    }
    
    return compareResult;
}
-(NSComparisonResult)compareWithDistance:(WaitingOrderModel *)anotherOrder Method:(NSString *)method
{
    NSComparisonResult compareResult;
    
    return compareResult;
}
-(NSComparisonResult)compareWithAwardMoney:(WaitingOrderModel *)anotherOrder Method:(NSString *)method
{
    NSComparisonResult compareResult;
    
    return compareResult;
}
-(NSComparisonResult)reverseCompareWithPayMethod:(WaitingOrderModel *)anotherOrder Method:(NSString *)method
{
    NSComparisonResult compareResult;
    
    return compareResult;
}

-(void)dealloc
{
    _awardMoney = nil;
    _disTance   = nil;
    _awardMoney = nil;
    _payMethod  = nil;
}


@end
