//
//  SalaryDetailCell.h
//  XKSDeliver
//
//  Created by ccSunday on 2017/2/17.
//  Copyright © 2017年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
@interface SalaryDetailCell : UITableViewCell

@property (nonatomic, strong)UILabel *dateLb;       //日期

@property (nonatomic, strong)UILabel *gongshiLb;    //工时

@property (nonatomic, strong)UILabel *danliangLb;   //单量

@property (nonatomic, strong)UILabel *mendianLb;    //门店

- (void)updateWithArray:(NSArray *)array;

@end
