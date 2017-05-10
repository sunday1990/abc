//
//  UITableViewCell+GetTbView.m
//  MutipleDimensionAssistant
//
//  Created by fong on 16/6/14.
//  Copyright © 2016年 ZXWW. All rights reserved.
//

#import "UITableViewCell+GetTbView.h"

@implementation UITableViewCell (GetTbView)


+(instancetype)getTableView:(UITableView *)tableView
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass(self)];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
}

@end
