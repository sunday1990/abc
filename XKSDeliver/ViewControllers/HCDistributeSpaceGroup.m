//
//  HCDistributeSpaceGroup.m
//  SpaceHome
//
//  Created by suhc on 2017/1/11.
//
//

#import "HCDistributeSpaceGroup.h"

@implementation HCDistributeSpaceGroup

- (NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (CGFloat)cellHeight{
    if (self.title) {
        //有标题
        return 50.f;
    }else{
        //无标题
        return 0.000001;
    }
}

@end
