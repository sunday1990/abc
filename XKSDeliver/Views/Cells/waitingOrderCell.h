//
//  waitingOrderCell.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/22.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#define waitingCellHeight 80

#import <UIKit/UIKit.h>

@interface waitingOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *distanceLb;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *awardRageLb;
@property (weak, nonatomic) IBOutlet UILabel *payMethodLb;


@property (weak, nonatomic) IBOutlet UIImageView *tipDotImageView;
@property (weak, nonatomic) IBOutlet UILabel *startAddressLb;



@property (weak, nonatomic) IBOutlet UIImageView *endAddressImage;

@property (weak, nonatomic) IBOutlet UILabel *endAddressLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingToDistanceForAwardMoneyLb;

@property (weak, nonatomic) IBOutlet UILabel *itemNameLb;



@property (weak, nonatomic) IBOutlet UIView *grayline2;


@end
