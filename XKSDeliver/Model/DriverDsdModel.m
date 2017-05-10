//
//  DriverDsdModel.m
//  XKSDeliver
//
//  Created by ccSunday on 2017/2/20.
//  Copyright © 2017年 同行必达. All rights reserved.
//

#import "DriverDsdModel.h"

@implementation DriverDsdModel
- (NSMutableArray *)valuesArray{
    if (!_valuesArray) {
        _valuesArray = [NSMutableArray array];
    }
    return _valuesArray;
}
@end
