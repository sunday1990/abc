//
//  RunningOrderCell.m
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/16.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import "RunningOrderCell.h"

@implementation RunningOrderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIButton *)bottomOrderStateLabel{
    if (!_bottomOrderStateLabel) {
        _bottomOrderStateLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomOrderStateLabel.frame = CGRectMake(60, 140+6, WIDTH-120, 44);
        [_bottomOrderStateLabel addTarget:self.vc action:@selector(changeOrderState:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomOrderStateLabel setTitle:@"扫一扫订单状态" forState:UIControlStateNormal];
        
        
        
        _bottomOrderStateLabel.titleLabel.font = BOLDFONT(18);
        _bottomOrderStateLabel.titleLabel.textColor = [UIColor blackColor];
        _bottomOrderStateLabel.layer.borderWidth = 1.0f;
        _bottomOrderStateLabel.layer.cornerRadius = 10;
        _bottomOrderStateLabel.layer.borderColor = RGB(39, 91, 187).CGColor;
        _bottomOrderStateLabel.hidden = YES;
        [self.contentView addSubview:_bottomOrderStateLabel];
    }
    return _bottomOrderStateLabel;
}
@end
