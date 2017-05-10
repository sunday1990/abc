//
//  MemberRemedyCell.m
//  XKSDeliver
//
//  Created by fong on 16/11/6.
//  Copyright © 2016年 同行必达. All rights reserved.
//

#import "MemberRemedyCell.h"

@implementation MemberRemedyCell

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
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 90)];
    _backView.backgroundColor = RGBCOLOR(102, 172, 19);
    [self.contentView addSubview:_backView];
    
    _nameLb = [MyControl createLabelWithFrame:CGRectMake(0, 0, WIDTH/4, 60) Font:14 Text:@""];
    _nameLb.textColor = LIGHT_WHITE_COLOR;
    _nameLb.text = @"";
    _nameLb.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:_nameLb];
    
    
    
    _positionNameLb = [MyControl createLabelWithFrame:CGRectMake(_nameLb.right, 0, WIDTH/4, 60) Font:14 Text:@""];
    _positionNameLb.textAlignment = NSTextAlignmentCenter;

    _positionNameLb.text = @"";
    _positionNameLb.textColor = LIGHT_WHITE_COLOR;
    [_backView addSubview:_positionNameLb];
    
    UIView *verticalView = [[UIView alloc]initWithFrame:CGRectMake(_nameLb.right, 0, 1, _nameLb.height)];
    verticalView.backgroundColor = LineColourValue;
    [_backView addSubview:verticalView];
    
    
    _workTimeTf = [MyControl createTextFieldWithFrame:CGRectMake(_positionNameLb.right+12, 12,(WIDTH/2-36)/2 , 60-24) placeholder:@"请输入" passWord:NO leftImageView:nil rightImageView:nil Font:14];
//    _workTimeTf.rac_textSignal
    _workTimeTf.textAlignment = NSTextAlignmentCenter;
    _workTimeTf.layer.cornerRadius = 6;
    _workTimeTf.keyboardType = UIKeyboardTypeDecimalPad;
    _workTimeTf.textColor = LIGHT_WHITE_COLOR;
    _workTimeTf.layer.borderWidth = 1.0f;
    _workTimeTf.layer.borderColor = LIGHT_WHITE_COLOR.CGColor;
    WEAK(self);
    [_workTimeTf.rac_textSignal subscribeNext:^(id x) {
        NSString *content = (NSString *)x;
        NSLog(@"content1%@",content);
        if ([content integerValue] > 24) {
            _workTimeTf.text = @"0";
            ALERT_VIEW(@"不得超过24个小时");
            return;
        }else{
            if (content.intValue>0) {
                weakself.model.workTime = content;
            }else{
                weakself.model.workTime = @"0";
            }
        }

    }];

    [_backView addSubview:_workTimeTf];
    
    _orderNumTf = [MyControl createTextFieldWithFrame:CGRectMake(_workTimeTf.right+12, 12,(WIDTH/2-36)/2 , 60-24) placeholder:@"请输入" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    _orderNumTf.textAlignment = NSTextAlignmentCenter;
    _orderNumTf.keyboardType = UIKeyboardTypeDecimalPad;
    _orderNumTf.textColor = LIGHT_WHITE_COLOR;
    _orderNumTf.layer.cornerRadius = 6;
    _orderNumTf.layer.borderWidth = 1.0f;
    _orderNumTf.layer.borderColor = LIGHT_WHITE_COLOR.CGColor;

    [_orderNumTf.rac_textSignal subscribeNext:^(id x) {
        NSString *content = (NSString *)x;
        NSLog(@"content2%@",content);
        if (content.intValue>0) {
            weakself.model.unitNum = content;
        }else{
            weakself.model.unitNum = @"0";
        }

        
    }];
    
    [_backView addSubview:_orderNumTf];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _nameLb.height-1, WIDTH, 1)];
    lineView.backgroundColor = LineColourValue;
    [_backView addSubview:lineView];
    
    self.salaryTypelb = [MyControl createLabelWithFrame:CGRectMake(0, self.nameLb.bottom, WIDTH/4, 30) Font:14 Text:@"工资类型:"];
    
    _salaryTypelb.textAlignment = NSTextAlignmentCenter;

    self.salaryTypelb.textColor = LIGHT_WHITE_COLOR;
    [self.backView addSubview:self.salaryTypelb];
    
    self.salaryDetailLb = [MyControl createLabelWithFrame:CGRectMake(self.salaryTypelb.right+12, self.salaryTypelb.top, WIDTH/4, 30) Font:14 Text:@""];
    _salaryDetailLb.textAlignment = NSTextAlignmentCenter;

    self.salaryDetailLb.textColor = LIGHT_WHITE_COLOR;
    [self.backView addSubview:self.salaryDetailLb];
}

- (void)setModel:(DriverDsdModel *)model{
    _model = model;
    if (_model.positionType.intValue == 0) {//众包
        _positionNameLb.text = @"众包";
    }else if (_model.positionType.intValue == 1){//兼职
        _positionNameLb.text = @"兼职";
    }else if (_model.positionType.intValue == 3){//全职
        _positionNameLb.text = @"全职";
    }
    _nameLb.text = model.name;
    _workTimeTf.text = _model.workTime;
    _orderNumTf.text = _model.unitNum;
    if (_model.isSupport.integerValue == 1) {//是支援
        _backView.backgroundColor = RGBCOLOR(102, 172, 19);//绿
    }else{
        _backView.backgroundColor = RGBCOLOR(232, 121, 91);//红
    }
    self.salaryDetailLb.text = _model.salaryType;
}
@end
