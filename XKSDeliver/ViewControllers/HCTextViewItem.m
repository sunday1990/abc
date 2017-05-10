//
//  HCTextViewItem.m
//  SpaceHome
//
//  Created by suhc on 2017/1/20.
//
//

#import "HCTextViewItem.h"

@implementation HCTextViewItem

+ (instancetype)itemWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder{
    return [[HCTextViewItem alloc] initWithTitle:title placeHolder:placeHolder];
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
