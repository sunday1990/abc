//
//  HCDistributeSpaceGroup.h
//  SpaceHome
//
//  Created by suhc on 2017/1/11.
//
//

#import "HCBaseItem.h"

@interface HCDistributeSpaceGroup : HCBaseItem

/**标题*/
@property (nonatomic, copy) NSString *title;

/**该组所有的元素*/
@property (nonatomic, strong) NSMutableArray *items;

/**右边按钮的文字*/
@property (nonatomic, copy) NSString *rightText;

/**右边按钮的图片*/
@property (nonatomic, copy) NSString *rightImage;

/**右边视图的操作*/
@property (nonatomic, copy) void(^opertion)(id);

/**弹窗选中的索引(针对SHPopView从1开始)*/
@property (nonatomic, assign) NSInteger popOptionIndex;

/**弹窗选中的标题*/
@property (nonatomic, copy) NSString *popOption;

/**右边switch的数组*/
@property (nonatomic, strong) NSArray *switchOptions;

/**右边switch选择的第几个(从0开始)*/
@property (nonatomic, assign) NSInteger switchFlag;

@end
