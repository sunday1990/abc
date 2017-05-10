//
//  HCPhotoItem.h
//  SpaceHome
//
//  Created by suhc on 2017/2/8.
//
//

#import "HCBaseItem.h"

@interface HCPhotoItem : HCBaseItem

/**标题*/
@property (nonatomic, copy) NSString *title;

/**最多可以上传的照片数*/
@property (nonatomic, assign) NSInteger maxCount;

/**所有图片*/
@property (nonatomic, strong) NSMutableArray *photos;

/**删除的图片*/
@property (nonatomic, strong) NSMutableArray *deletePhotos;

/**新增加的图片*/
@property (nonatomic, strong) NSMutableArray *addPhotos;

/**是否是必填项*/
@property (nonatomic, assign, getter=isMustWrite) BOOL mustWrite;

/**提示标题*/
@property (nonatomic, copy) NSString *tipTitle;

/**提示内容*/
@property (nonatomic, copy) NSString *tipContent;

/**是否需要裁切*/
@property (nonatomic, assign, getter=isNeedClip) BOOL needClip;

@property (nonatomic, weak) UIViewController *controller;

+ (instancetype)itemWithController:(UIViewController *)controller title:(NSString *)title maxCount:(NSUInteger)maxCount needClip:(BOOL)needClip;

- (instancetype)initWithController:(UIViewController *)controller title:(NSString *)title maxCount:(NSUInteger)maxCount needClip:(BOOL)needClip;

@end
