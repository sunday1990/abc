//
//  HCDistributeSpaceItem.m
//  SpaceHome
//
//  Created by suhc on 2017/1/11.
//
//

#import "HCDistributeSpaceItem.h"

@implementation HCDistributeSpaceItem

+ (instancetype)itemWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder{
    return [[HCDistributeSpaceItem alloc] initWithTitle:title placeHolder:placeHolder];
}

- (instancetype)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder{
    if (self = [super init]) {
        self.title = title;
        self.placehoder = placeHolder;
        //默认可以编辑
        self.canEdit = YES;
    }
    return self;
}

@end
