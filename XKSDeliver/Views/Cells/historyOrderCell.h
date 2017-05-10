//
//  historyOrderCell.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/22.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#define _HistoryCellHight_ 85

#import <UIKit/UIKit.h>

@interface historyOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *startAddressLb;
@property (weak, nonatomic) IBOutlet UILabel *endAddressLb;

@property (weak, nonatomic) IBOutlet UILabel *orderPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLb;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToAwardMoneyLb;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToAwardMoneyNumLb;

@property (weak, nonatomic) IBOutlet UILabel *orderPriceLbTitleLb;



@end
