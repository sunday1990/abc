//
//  HCTextViewItem.h
//  SpaceHome
//
//  Created by suhc on 2017/1/20.
//
//

#import "HCBaseItem.h"

@interface HCTextViewItem : HCBaseItem

/**标题*/
@property (nonatomic, copy) NSString *title;

/**内容*/
@property (nonatomic, copy) NSString *content;

/**(副标题)是否可以编辑*/
@property (nonatomic, assign, getter=isCanEdit) BOOL canEdit;

/**提示文字*/
@property (nonatomic, copy) NSString *placehoder;

/**输入框输入的文字最大个数*/
@property (nonatomic, assign) NSInteger maxInputLength;

/**键盘类型*/
@property (nonatomic, assign) UIKeyboardType keyBoardType;

/**是否是必填项*/
@property (nonatomic, assign, getter=isMustWrite) BOOL mustWrite;

+ (instancetype)itemWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder;
- (instancetype)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder;

@end
