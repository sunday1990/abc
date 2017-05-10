//
//  RunningOrderCell.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/16.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
@interface RunningOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderSubmitTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *startAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *endAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;


@property (strong, nonatomic)UIButton *bottomOrderStateLabel;

@property (nonatomic,weak)UIViewController *vc;

@end
