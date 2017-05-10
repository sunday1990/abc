//
//  AddressListNetdataCell.h
//  XKSDeliver
//
//  Created by 同行必达 on 16/3/4.
//  Copyright © 2016年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
@interface AddressListNetdataCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (nonatomic, strong)UILabel *salaryTypeLb ;
@end
