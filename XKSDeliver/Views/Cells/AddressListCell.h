//
//  AddressListCell.h
//  XKSDeliver
//
//  Created by 同行必达 on 16/3/4.
//  Copyright © 2016年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressListCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *deleteHistoryBt;

@property (weak, nonatomic) IBOutlet UILabel *historyAddressLabel;

@property (weak, nonatomic) IBOutlet UIImageView *listKindIV;


@end
