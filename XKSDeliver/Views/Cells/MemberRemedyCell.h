//
//  MemberRemedyCell.h
//  XKSDeliver
//
//  Created by fong on 16/11/6.
//  Copyright © 2016年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+GetTbView.h"
#import "common.h"
#import "DriverDsdModel.h"

@interface MemberRemedyCell : UITableViewCell

@property (strong, nonatomic)  UIView *backView;

@property (strong, nonatomic)  UILabel *nameLb;

@property (strong, nonatomic)  UILabel *positionNameLb;

@property (strong, nonatomic)  UITextField *workTimeTf;

@property (strong, nonatomic)  UITextField *orderNumTf;

@property (nonatomic, strong)UILabel *salaryTypelb;

@property (nonatomic, strong)UILabel *salaryDetailLb;

@property (nonatomic,strong)DriverDsdModel *model;


@end
