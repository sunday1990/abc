//
//  SignRecordCell.h
//  XKSDeliver
//
//  Created by fong on 16/11/6.
//  Copyright © 2016年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+GetTbView.h"

@interface SignRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *signTypeLb;
@property (weak, nonatomic) IBOutlet UILabel *signTimeLb;

@end
