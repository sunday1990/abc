//
//  Foundation+Log.h
//  TableViewMvc
//
//  Created by 同行必达 on 16/4/12.
//  Copyright © 2016年 同行必达. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (Log)

+ (NSString *)searchAllSubviews:(UIView *)superview;

- (NSString *)description;


@end


@interface NSDictionary (Log)

- (NSString *)descriptionWithLocale:(id)locale


@end


@interface NSArray (Log)

- (NSString *)descriptionWithLocale:(id)locale;

@end

