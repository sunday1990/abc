//
//  AddressListNetdataCell.m
//  XKSDeliver
//
//  Created by 同行必达 on 16/3/4.
//  Copyright © 2016年 同行必达. All rights reserved.
//

#import "AddressListNetdataCell.h"

@implementation AddressListNetdataCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)salaryTypeLb{
    if (!_salaryTypeLb) {
        _salaryTypeLb = [MyControl createLabelWithFrame:CGRectMake(12,_mainTitleLabel.bottom , WIDTH, 20) Font:13 Text:@""];
        _salaryTypeLb.textColor = DarkTextColor;
        [self.contentView addSubview:_salaryTypeLb];
    }
    return _salaryTypeLb;
}

@end
