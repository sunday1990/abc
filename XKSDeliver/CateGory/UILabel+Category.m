//
//  UILabel+Category.m
//  SpaceHome
//
//  Created by suhc on 2017/1/11.
//
//

#import "UILabel+Category.h"

@implementation UILabel (Category)

+ (instancetype)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor{
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    return label;
}

@end
