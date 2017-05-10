//
//  HCDistributeSpaceCell.m
//  SpaceHome
//
//  Created by suhc on 2017/1/11.
//
//

#import "HCDistributeSpaceCell.h"
#import "SimpleSwitch.h"
#import "ReactiveCocoa.h"

@interface HCDistributeSpaceCell ()
{
    /**标题*/
    UILabel *_titleView;
    /**副标题*/
    UITextField *_subTitleView;
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
@implementation HCDistributeSpaceCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
#warning 由于此处Cell如果重用会导致IQKeyboardManager使用时出现问题，所以此处不重用
    HCDistributeSpaceCell *cell = [[HCDistributeSpaceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    NSLog(@"哈哈");
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //选中样式
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews{
    
    //标题
    _titleView = [UILabel labelWithFont:GetFont(14) textColor:DarkTextColor];
    [self.contentView addSubview:_titleView];
    
    //副标题
    _subTitleView = [[UITextField alloc] init];
    _subTitleView.textColor = LightTextColor;
    _subTitleView.font = GetFont(12);
    [self.contentView addSubview:_subTitleView];
    
    __weak typeof(_subTitleView) weakSubTitleCanEditField = _subTitleView;
    WEAK(self)
    [_subTitleView.rac_textSignal subscribeNext:^(id x) {
        NSString *content = (NSString *)x;
        if (weakself.item.maxInputLength) {
            UITextRange *selectedRange = [weakSubTitleCanEditField markedTextRange];
            //获取高亮部分
            UITextPosition *position = [weakSubTitleCanEditField positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (content.length > weakself.item.maxInputLength) {
                    weakSubTitleCanEditField.text = [content substringToIndex:weakself.item.maxInputLength];
//                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请输入不超过%zd个字",weakself.item.maxInputLength]];
                }
            } else{
                // 有高亮选择的字符串，则暂不对文字进行统计和限制
            }
        }
        weakself.item.subTitle = content;
    }];
    
    //底部分割线
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self.contentView addSubview:_bottomLine];
}

- (void)setItem:(HCDistributeSpaceItem *)item{
    _item = item;
    
    //标题
    if (_item.isMustWrite) {
        //必填项
        NSString *titleText = [NSString stringWithFormat:@"*%@",_item.title];
        NSMutableAttributedString *attStrM = [[NSMutableAttributedString alloc] initWithString:titleText];
        [attStrM setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, titleText.length - _item.title.length)];
        _titleView.attributedText = attStrM;
    }else{
        //非必填项
        _titleView.text = _item.title;
    }
    
    //副标题
    _subTitleView.text = _item.subTitle;
    _subTitleView.placeholder = _item.placehoder;
    _subTitleView.keyboardType = _item.keyBoardType;
    _subTitleView.userInteractionEnabled = _item.canEdit;
    _subTitleView.secureTextEntry  = _item.secureTextEntry;
    [self setupAccessoryView];
    
    //底部分割线
    _bottomLine.hidden = !_item.needBottomLine;
}

- (void)setupAccessoryView{
    if ([self.contentView.subviews containsObject:self.accessoryBtn]) {
        [self.accessoryBtn removeFromSuperview];
        self.accessoryBtn = nil;
    }
    if ([self.contentView.subviews containsObject:self.accessorySwitch]) {
        [self.accessorySwitch removeFromSuperview];
        self.accessorySwitch = nil;
    }
    self.accessoryView = nil;
    
    if (_item.rightText || _item.rightImage) {
        [self.accessoryBtn setTitle:_item.rightText forState:UIControlStateNormal];
        [self.accessoryBtn setImage:GetImage(_item.rightImage) forState:UIControlStateNormal];
        self.accessoryView = self.accessoryBtn;
    }
    
    if (_item.switchOptions) {
        self.accessorySwitch.titles = _item.switchOptions;
        self.accessorySwitch.flag = _item.switchFlag;
        self.accessoryView = self.accessorySwitch;
    }
    
    if (_item.opertion) {
        self.accessoryView.userInteractionEnabled = YES;
    }else{
        self.accessoryView.userInteractionEnabled = NO;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //标题
    CGFloat titleWidth = 0;
   
    if (_item.isMustWrite) {
        //必填项
        titleWidth = [_titleView.attributedText.string widthForFont:_titleView.font];
        _titleView.frame = CGRectMake(9, 0, titleWidth, self.height);
    }else{
        //非必填项
        titleWidth = [_titleView.text widthForFont:_titleView.font];
        _titleView.frame = CGRectMake(16, 0, titleWidth, self.height);
    }
    
    if (_item.rightText && _item.rightImage) {
        [self.accessoryBtn sizeToFit];
        self.accessoryBtn.width += 4;
        
        CGFloat imgLeftInset = [self.accessoryBtn.titleLabel.text widthForFont:self.accessoryBtn.titleLabel.font];
        self.accessoryBtn.imageEdgeInsets = UIEdgeInsetsMake(0, imgLeftInset + 4, 0, 0);
        
        CGFloat titleRightInset = self.accessoryBtn.imageView.image.size.width + 4;
        self.accessoryBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -titleRightInset, 0, titleRightInset);
    }else if (_item.rightText){
        [self.accessoryBtn sizeToFit];
    }else if (_item.rightImage){
        [self.accessoryBtn sizeToFit];
        self.accessoryBtn.width += 20;
    }
    
    if (_item.rightText || _item.rightImage){
        self.accessoryBtn.height = self.height;
        self.accessoryBtn.centerY = self.height * 0.5;
    }
    
    self.accessoryView.right = self.width - 16;
    
    //副标题(不可编辑)
    CGFloat subTitleWidth = 0;
    if (self.accessoryView) {
        subTitleWidth = self.accessoryView.left - _titleView.right - 11 * 2;
    }else{
        subTitleWidth = self.width - _titleView.right - 11 - 16;
    }
    
    //副标题
    _subTitleView.frame = CGRectMake(_titleView.right + 11, 0, subTitleWidth, self.height);
    
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
        _accessoryBtn.titleLabel.font = GetFont(12);
        [_accessoryBtn addTarget:self action:@selector(accessoryBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _accessoryBtn;
}

- (void)accessoryBtnDidClick:(UIButton *)button{
    [button setTitle:_item.rightText forState:UIControlStateNormal];
    if (_item.opertion) {
        _item.opertion(button);
    }
}

- (SimpleSwitch *)accessorySwitch{
    if (!_accessorySwitch) {
        _accessorySwitch = [[SimpleSwitch alloc] init];
        [_accessorySwitch addTarget:self action:@selector(accessorySwitchValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _accessorySwitch;
}

- (void)accessorySwitchValueDidChanged:(SimpleSwitch *)simpleSwitch{
    _item.switchFlag = simpleSwitch.flag;
    if (_item.opertion) {
        _item.opertion(simpleSwitch);
    }
}

- (void)dealloc{
    NSLog(@"%@---dealloc",NSStringFromClass(self.class));
}

@end
