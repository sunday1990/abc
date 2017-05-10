//
//  pushOrderToListCell.m
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/16.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import "pushOrderToListCell.h"

@implementation pushOrderToListCell

- (void)awakeFromNib {
    // Initialization code
    _orderStateImage.image     = LOADIMAGE(_CELL_STATEIMAGE_WAITING, @"png");
    _orderStateMainTitle.text  = _CELL_MAINTITLE_WAITING;
    _orderStateSubTitle.text   = _CELL_SUBTITLE_WAITING;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
