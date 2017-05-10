//
//  HCCommonItem.m
//  SpaceHome
//
//  Created by suhc on 2017/2/7.
//
//

#import "HCCommonItem.h"

@implementation HCCommonItem

+ (instancetype)associateObject:(id)object withKey:(NSString *)key{
    HCCommonItem *item = [[HCCommonItem alloc] init];
    item.objKey = key;
    if ([object isKindOfClass:[UIView class]]) {
        item.cellHeight = ((UIView *)object).height;
    }
    objc_setAssociatedObject(item, (__bridge const void *)(key), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return item;
}

- (instancetype)associateObject:(id)object withKey:(NSString *)key{
    HCCommonItem *item = [[HCCommonItem alloc] init];
    item.objKey = key;
    if ([object isKindOfClass:[UIView class]]) {
        item.cellHeight = ((UIView *)object).height;
    }
    objc_setAssociatedObject(item, (__bridge const void *)(key), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return item;
}

- (id)getAssociatedObjectWithKey:(NSString *)key{
    return objc_getAssociatedObject(self, (__bridge const void *)(key));
}

- (void)removeAssociateObjectWithKey:(NSString *)key{
    id value = objc_getAssociatedObject(self, (__bridge const void *)(key));
    if ([value isKindOfClass:[UIView class]]) {
        [value removeFromSuperview];
    }
}

- (void)removeAllAssociateObjects{
    objc_removeAssociatedObjects(self);
}

@end
