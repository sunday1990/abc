//
//  SHSelectPaymentTypeView.m
//  test
//
//  Created by suhc on 16/5/12.
//  Copyright © 2016年 kongjianjia. All rights reserved.
//

#import "SHSelectPayTypeView.h"

@interface SHSelectPayTypeView ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    
    UIViewController *_controller;

    UIButton *_cancelBtn;
    
    UIButton * _doneBtn;
    
    NSInteger _selectedIndex;//0列
    
    NSInteger _secondSelctedIndex;//1列
    
    UILabel *titleLabel;
    
}
//@property (nonatomic, weak)UIViewController 
@end

@implementation SHSelectPayTypeView

+ (instancetype)selectPayTypeViewWithController:(UIViewController *)controlelr{
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds controller:controlelr];
}

- (instancetype)initWithFrame:(CGRect)frame controller:(UIViewController *)controlelr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _selectedIndex = 0;
        _controller = controlelr;
        
        UIView *alphaView = [[UIView alloc] init];
        alphaView.backgroundColor = [UIColor blackColor];
        alphaView.alpha = 0.5;
        alphaView.frame = self.bounds;
        [self addSubview:alphaView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
        [alphaView addGestureRecognizer:tap];
        
        UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 176-44, WIDTH, 44+44)];
        barView.backgroundColor = [UIColor whiteColor];
        [self addSubview:barView];
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelBtn.frame = CGRectMake(12, 12, 40, 20);
        [_cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        _cancelBtn.backgroundColor = [UIColor colorWithHexString:@"#ed4349"];
        _cancelBtn.layer.cornerRadius = _cancelBtn.height * 0.5;
        _cancelBtn.clipsToBounds = YES;
        [barView addSubview:_cancelBtn];
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
        [doneBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        doneBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 52, _cancelBtn.top, _cancelBtn.width, _cancelBtn.height);
        [doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        doneBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        doneBtn.layer.borderWidth = 1;
        doneBtn.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
        doneBtn.layer.cornerRadius = doneBtn.height * 0.5;
        doneBtn.clipsToBounds = YES;
        [barView addSubview:doneBtn];
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:15.f];
        titleLabel.textColor = GREEN_COLOR;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"是否选择：--";
        titleLabel.frame = CGRectMake(doneBtn.right, 0, _cancelBtn.left - doneBtn.right, 44);
        [barView addSubview:titleLabel];

        
        UILabel *positionTypeLb = [MyControl createLabelWithFrame:CGRectMake(0, 44, WIDTH/2, 44) Font:13 Text:@"职位类型"];
        positionTypeLb.textColor = DarkTextColor;
        positionTypeLb.textAlignment = NSTextAlignmentCenter;
        [barView addSubview:positionTypeLb];
        
        UILabel *salaryTypeLb = [MyControl createLabelWithFrame:CGRectMake(WIDTH/2, 44, WIDTH/2, 44) Font:13 Text:@"工资类型"];
        salaryTypeLb.textColor = DarkTextColor;
        salaryTypeLb.textAlignment = NSTextAlignmentCenter;
        [barView addSubview:salaryTypeLb];
        
        UIView *verticalView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH/2, positionTypeLb.top, 0.5, 44)];
        verticalView.backgroundColor = LineColourValue;
        [barView addSubview:verticalView];
        
        UIView *bottomView = [[UIView alloc] init];
//        bottomView.backgroundColor = [UIColor whiteColor];
        bottomView.backgroundColor = YELLOW_COLOR1;
        bottomView.frame = CGRectMake(0, barView.bottom, WIDTH, 176+44-barView.height);
        [self addSubview:bottomView];
        
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.frame = bottomView.bounds;
        _pickerView.backgroundColor = LIGHT_WHITE_COLOR;
        [bottomView addSubview:_pickerView];
        for (int i = 0; i < 4; i++) {
            UIView *lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(0, barView.top + 44 * (i + 1), self.width, 0.5);
            lineView.backgroundColor = LineColourValue;
            [self addSubview:lineView];
        }
        
    }
    
    return self;
}

-(void)setGroup:(NSMutableArray *)group{
    _group = group;
}
- (void)cancel{
    NSLog(@"取消");
    [self removeFromSuperview];
}

- (void)done{

    NSLog(@"确定");
    [self removeFromSuperview];
    if (self.selectedBlock) {
        SalaryGroup *group = _group[_selectedIndex];
        SalaryItem *item = group.items[_secondSelctedIndex];
        
        self.selectedBlock([NSString stringWithFormat:@"%ld",(long)group.positionType],[NSString stringWithFormat:@"%ld",item.salaryTypeID]);
    }
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return  _group.count;
    }else{
        SalaryGroup *groups = _group[_selectedIndex];
        return groups.items.count;
    }
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSMutableDictionary *attrDic = [NSMutableDictionary dictionary];
    attrDic[NSFontAttributeName] = [UIFont systemFontOfSize:1.f];
    attrDic[NSForegroundColorAttributeName] = DarkTextColor;
    if (component == 0) {
        SalaryGroup *groups = _group[row];
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:groups.positionName attributes:attrDic];
        return attStr;
    }else{
        SalaryGroup *groups = _group[_selectedIndex];
        SalaryItem *item = groups.items[row];
        
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:item.salaryType attributes:attrDic];
        return attStr;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        _selectedIndex = row;
        [pickerView reloadComponent:1];
    }else{
        _secondSelctedIndex = row;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 44;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return self.width/2;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self clearSeparatorWithView:_pickerView];
}

//调用如下方法清除row的分割线
- (void)clearSeparatorWithView:(UIView * )view{
    if(view.subviews != 0){
        if(view.bounds.size.height < 5){
            view.backgroundColor = [UIColor clearColor];
        }
        
        [view.subviews enumerateObjectsUsingBlock:^( UIView *  obj, NSUInteger idx, BOOL *  stop) {
            [self clearSeparatorWithView:obj];
        }];
    }
    
}

- (void)setName:(NSString *)name{
    _name = name;
    titleLabel.text = [NSString stringWithFormat:@"是否选择：%@",_name];
}
@end
