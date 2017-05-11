//
//  HCDistributeSpaceItem.h
//  SpaceHome
//
//  Created by suhc on 2017/1/11.
//
//

#import "HCBaseItem.h"

@interface HCDistributeSpaceItem : HCBaseItem

/**标题*/
@property (nonatomic, copy) NSString *title;

/**副标题*/
@property (nonatomic, copy) NSString *subTitle;

/**(副标题)是否可以编辑*/
@property (nonatomic, assign, getter=isCanEdit) BOOL canEdit;

/**提示文字*/
@property (nonatomic, copy) NSString *placehoder;

/**是否是必填项*/
@property (nonatomic, assign, getter=isMustWrite) BOOL mustWrite;

/**右边按钮的文字*/
@property (nonatomic, copy) NSString *rightText;

/**右边按钮的图片*/
@property (nonatomic, copy) NSString *rightImage;

/**右边视图的操作*/
@property (nonatomic, copy) void(^opertion)(id);
/**所在cell被点击的操作*/
@property (nonatomic, copy) void (^cellSelected)(id);

/**键盘类型*/
@property (nonatomic, assign) UIKeyboardType keyBoardType;

/**
 是否是密码键盘
 */
@property (nonatomic, assign) BOOL secureTextEntry;

/**右边switch的数组*/
@property (nonatomic, strong) NSArray *switchOptions;

/**弹窗选中的索引(针对HCPopView从1开始)*/
@property (nonatomic, assign) NSInteger popOptionIndex;

/**弹窗选中的标题(针对HCPopView)*/
@property (nonatomic, copy) NSString *popOption;

/**输入框输入的文字最大个数*/
@property (nonatomic, assign) NSInteger maxInputLength;

/**右边switch选择的第几个(从0开始)*/
@property (nonatomic, assign) NSInteger switchFlag;

/**数字大小写*/
@property (nonatomic, assign)BOOL numAndLetter;

+ (instancetype)itemWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder;
- (instancetype)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder;

@end
