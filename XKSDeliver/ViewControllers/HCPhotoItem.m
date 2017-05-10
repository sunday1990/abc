//
//  HCPhotoItem.m
//  SpaceHome
//
//  Created by suhc on 2017/2/8.
//
//

#import "HCPhotoItem.h"

@implementation HCPhotoItem

+ (instancetype)itemWithController:(UIViewController *)controller title:(NSString *)title maxCount:(NSUInteger)maxCount needClip:(BOOL)needClip{
    return [[HCPhotoItem alloc] initWithController:controller title:title maxCount:maxCount needClip:needClip];
}

- (instancetype)initWithController:(UIViewController *)controller title:(NSString *)title maxCount:(NSUInteger)maxCount needClip:(BOOL)needClip{
    if (self = [super init]) {
        self.controller = controller;
        self.title = title;
        self.maxCount = maxCount;
        self.needClip = needClip;
    }
    return self;
}

- (NSInteger)maxCount{
    if (!_maxCount) {
        return 1;
    }else{
        return _maxCount;
    }
}

- (NSMutableArray *)photos{
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

- (NSMutableArray *)deletePhotos{
    if (!_deletePhotos) {
        _deletePhotos = [NSMutableArray array];
    }
    return _deletePhotos;
}

- (NSMutableArray *)addPhotos{
    if (!_addPhotos) {
        _addPhotos = [NSMutableArray array];
    }
    return _addPhotos;
}

@end
