//
//  SimpleSwitch.h
//  SpaceHome
//
//  Created by ccSunday on 15/11/23.
//
//

#import <UIKit/UIKit.h>
#import "common.h"
@interface SimpleSwitch : UIControl
/**
 *  当前选中的序号(从0开始,默认为0)
 */
@property (nonatomic, assign) NSInteger flag;

/**
 *  标题数组
 */
@property (nonatomic, strong) NSArray *titles;
/**
 *  是否响应外界
 */
@property (nonatomic, assign )BOOL canNotEdit;

@property (nonatomic, copy) void(^valueChanged)(NSInteger flag);

- (void)setFlag:(NSInteger)flag triggerAction:(BOOL)triggerAction;

- (instancetype)initWithTitles:(NSArray *)titles flag:(NSInteger)flag triggerAction:(BOOL)triggerAction;

+ (instancetype)switchWithTitles:(NSArray *)titles flag:(NSInteger)flag;

- (instancetype)initWithTitles:(NSArray *)titles flag:(NSInteger)flag;

@end
