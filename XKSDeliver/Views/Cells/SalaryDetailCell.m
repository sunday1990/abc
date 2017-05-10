//
//  SalaryDetailCell.m
//  XKSDeliver
//
//  Created by ccSunday on 2017/2/17.
//  Copyright © 2017年 同行必达. All rights reserved.
//

#import "SalaryDetailCell.h"

@interface SalaryDetailCell ()


@end

@implementation SalaryDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    CGFloat width = WIDTH/4;
    _dateLb = UILABEL;
    _dateLb.frame = CGRectMake(0, 0,width, 60);
    _dateLb.textAlignment = NSTextAlignmentCenter;
    _dateLb.font = GetFont(14);
    _dateLb.backgroundColor = YELLOW_COLOR1;
    _dateLb.textColor = LIGHT_WHITE_COLOR;
    [self.contentView addSubview:_dateLb];

    _gongshiLb = UILABEL;
    _gongshiLb.frame = CGRectMake(_dateLb.right+2, 0,width, 60);
    _gongshiLb.textAlignment = NSTextAlignmentCenter;
    _gongshiLb.font = GetFont(14);
    _gongshiLb.backgroundColor = YELLOW_COLOR1;
    _gongshiLb.textColor = LIGHT_WHITE_COLOR;
    [self.contentView addSubview:_gongshiLb];

    _danliangLb = UILABEL;
    _danliangLb.frame = CGRectMake(_gongshiLb.right+2, 0,width, 60);
    _danliangLb.textAlignment = NSTextAlignmentCenter;
    _danliangLb.font = GetFont(14);
    _danliangLb.backgroundColor = YELLOW_COLOR1;
    _danliangLb.textColor = LIGHT_WHITE_COLOR;
    [self.contentView addSubview:_danliangLb];

    _mendianLb = UILABEL;
    _mendianLb.frame = CGRectMake(_danliangLb.right+2, 0,width, 60);
    _mendianLb.textAlignment = NSTextAlignmentCenter;
    _mendianLb.font = GetFont(14);
    _mendianLb.backgroundColor = YELLOW_COLOR1;
    _mendianLb.textColor = LIGHT_WHITE_COLOR;
    [self.contentView addSubview:_mendianLb];
}

- (void)updateWithArray:(NSArray *)array{
    [self clean];
    _dateLb.text = array[0];
    _gongshiLb.text = array[1];
    _danliangLb.text = array[2];
    _mendianLb.text = array[3];
}
- (void)clean{
    _dateLb.text = nil;
    _gongshiLb.text = nil;
    _danliangLb.text = nil;
    _mendianLb.text = nil;
}
@end
