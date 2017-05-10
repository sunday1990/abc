//
//  RemedyCell.h
//  XKSDeliver
//
//  Created by fong on 16/10/16.
//  Copyright © 2016年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+GetTbView.h"

@interface RemedyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *positionLb;
@property (weak, nonatomic) IBOutlet UITextField *workTime;
@property (weak, nonatomic) IBOutlet UITextField *orderNum;

@end
