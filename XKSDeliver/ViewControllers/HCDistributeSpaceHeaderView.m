//
//  HCDistributeSpaceHeaderView.m
//  SpaceHome
//
//  Created by suhc on 2017/1/11.
//
//

#import "HCDistributeSpaceHeaderView.h"
#import "HCDistributeSpaceGroup.h"
#import "SimpleSwitch.h"
#import "ReactiveCocoa.h"

@interface HCDistributeSpaceHeaderView ()
{
    /**标题*/
    UILabel *_titleView;
    
    /**底部分割线*/
    UIView *_bottomLine;
}
/**
 *  右边按钮
 */
@property (nonatomic, strong) UIButton *accessoryBtn;
/**
 *  右边开关
 */
@property (nonatomic, strong) SimpleSwitch *accessorySwitch;
@end
@implementation HCDistributeSpaceHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView{
    static NSString *headerID = @"HCDistributeSpaceHeaderView_identifier";
    HCDistributeSpaceHeaderView *headerView = (HCDistributeSpaceHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (headerView == nil) {
        headerView = [[HCDistributeSpaceHeaderView alloc] initWithReuseIdentifier:headerID];
    }
    
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    //标题
    _titleView = [UILabel labelWithFont:FONT(14) textColor:GetColor(blackColor)];
    [self.contentView addSubview:_titleView];
    
    //底部分割线
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self.contentView addSubview:_bottomLine];

}

- (void)setGroup:(HCDistributeSpaceGroup *)group{
    _group = group;
    
    //标题
    _titleView.text = _group.title;
    
    [self setupAccessoryView];
    
    //底部分割线
    _bottomLine.hidden = !_group.needBottomLine;
}

- (void)setupAccessoryView{
    [self.accessoryBtn removeFromSuperview];
    [self.accessorySwitch removeFromSuperview];
    self.accessoryBtn = nil;
    self.accessorySwitch = nil;
    
    WEAK(self)
    if (_group.rightText || _group.rightImage) {
        [self.accessoryBtn setTitle:_group.rightText forState:UIControlStateNormal];
        [self.accessoryBtn setImage:IMAGE(_group.rightImage) forState:UIControlStateNormal];
        [[self.accessoryBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [weakself.accessoryBtn setTitle:weakself.group.rightText forState:UIControlStateNormal];
            if (weakself.group.opertion) {
                weakself.group.opertion(x);
            }
        }];
        [weakself.contentView addSubview:weakself.accessoryBtn];
    }
    
    if (_group.switchOptions) {
        self.accessorySwitch.titles = _group.switchOptions;
        self.accessorySwitch.flag = _group.switchFlag;
        [[self.accessorySwitch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
            weakself.group.switchFlag = weakself.accessorySwitch.flag;
            if (weakself.group.opertion) {
                weakself.group.opertion(x);
            }
        }];
        [weakself.contentView addSubview:weakself.accessorySwitch];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //标题
    CGFloat titleWidth = [_titleView.text widthForFont:_titleView.font];
    _titleView.frame = CGRectMake(16, 0, titleWidth, self.height);    
    
    if (_group.rightText && _group.rightImage) {
        [self.accessoryBtn sizeToFit];
        self.accessoryBtn.width += 4;
        
        CGFloat imgLeftInset = [self.accessoryBtn.titleLabel.text widthForFont:self.accessoryBtn.titleLabel.font];
        self.accessoryBtn.imageEdgeInsets = UIEdgeInsetsMake(0, imgLeftInset + 4, 0, 0);
        
        CGFloat titleRightInset = self.accessoryBtn.imageView.image.size.width + 4;
        self.accessoryBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -titleRightInset, 0, titleRightInset);
    }else if (_group.rightText){
        [self.accessoryBtn sizeToFit];
    }else if (_group.rightImage){
        [self.accessoryBtn sizeToFit];
        self.accessoryBtn.width += 20;
    }
    
    if (_group.rightText || _group.rightImage){
        self.accessoryBtn.height = self.height;
        self.accessoryBtn.centerY = self.height * 0.5;
    }
    
    self.accessoryBtn.right = self.width - 16;
    self.accessoryBtn.centerY = self.height * 0.5;
    
    self.accessorySwitch.right = self.width - 16;
    self.accessorySwitch.centerY = self.height * 0.5;
    
    //底部分割线
    _bottomLine.frame = CGRectMake(0, self.height - 1, self.width, 1);
}

#pragma mark - 懒加载
- (UIButton *)accessoryBtn{
    if (!_accessoryBtn) {
        _accessoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置基本属性
        _accessoryBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_accessoryBtn setTitleColor:LightTextColor forState:UIControlStateNormal];
        _accessoryBtn.titleLabel.font = FONT(12);
    }
    return _accessoryBtn;
}

- (SimpleSwitch *)accessorySwitch{
    if (!_accessorySwitch) {
        _accessorySwitch = [[SimpleSwitch alloc] init];
    }
    return _accessorySwitch;
}

- (void)dealloc{
    NSLog(@"%@---dealloc",NSStringFromClass(self.class));
}

@end
