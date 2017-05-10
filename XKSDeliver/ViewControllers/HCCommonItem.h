//
//  HCCommonItem.h
//  SpaceHome
//
//  Created by suhc on 2017/2/7.
//
//

#import "HCBaseItem.h"

@interface HCCommonItem : HCBaseItem

@property (nonatomic, copy) NSString *objKey;

/**
 *  @param object 要绑定的object
 *  @param key    绑定的key
 *
 *  @return      item实例
 */
+ (instancetype)associateObject:(id)object withKey:(NSString *)key;

/**
 *  @param object 要绑定的object
 *  @param key    绑定的key
 *
 *  @return      item实例
 */
- (instancetype)associateObject:(id)object withKey:(NSString *)key;

/**
 *  移除绑定
 *
 *  @param key
 */
- (void)removeAssociateObjectWithKey:(NSString *)key;

/**
 *  通过key获取绑定的object
 *
 *  @return      绑定的object
 */
- (id)getAssociatedObjectWithKey:(NSString *)key;

/**
 *  移除所有的绑定
 */
- (void)removeAllAssociateObjects;


@end
