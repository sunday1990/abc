//
//  SalaryGroup.m
//  XKSDeliver
//
//  Created by ccSunday on 2017/2/18.
//  Copyright © 2017年 同行必达. All rights reserved.
//

#import "SalaryGroup.h"

@implementation SalaryGroup

- (NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

@end
