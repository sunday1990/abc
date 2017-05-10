//
//  HCTextViewCell.m
//  SpaceHome
//
//  Created by suhc on 2017/1/20.
//
//

#import "HCTextViewCell.h"
#import "ReactiveCocoa.h"

@interface HCTextViewCell ()
{
    /**标题*/
    UILabel *_titleView;
    /**输入框*/
    UITextView *_textView;
    /**提示文字*/
    UILabel *_placeHolderView;
    /**底部分割线*/
    UIView *_bottomLine;
}
@end
@implementation HCTextViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"HCTextViewCell_ID";
    HCTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[HCTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
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
    _titleView = [UILabel labelWithFont:FONT(14) textColor:GetColor(grayColor)];
    [self.contentView addSubview:_titleView];
    
    //输入框
    _textView = [[UITextView alloc] init];
    _textView.textColor = GetColor(grayColor);
    _textView.font = FONT(12);
    [self.contentView addSubview:_textView];
    _textView.textContainerInset = UIEdgeInsetsZero;
    
    //提示文字
    _placeHolderView = UILABEL;
    _placeHolderView.userInteractionEnabled = NO;
    _placeHolderView.textColor = RGB(200, 200, 205);
    _placeHolderView.font = FONT(12);
    [_textView addSubview:_placeHolderView];
    
    WEAK(self)
    WEAK(_textView)
    WEAK(_placeHolderView)
    [_textView.rac_textSignal subscribeNext:^(id x) {
        NSString *content = (NSString *)x;
        weak_placeHolderView.hidden = content.length > 0;
        
        if (weakself.item.maxInputLength) {
            UITextRange *selectedRange = [weak_textView markedTextRange];
            //获取高亮部分
            UITextPosition *position = [weak_textView positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (content.length > weakself.item.maxInputLength) {
                    weak_textView.text = [content substringToIndex:weakself.item.maxInputLength];
//                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请输入不超过%zd个字",weakself.item.maxInputLength]];
                }
            } else{
                // 有高亮选择的字符串，则暂不对文字进行统计和限制
            }
        }
        weakself.item.content = content;
    }];
    
    //底部分割线
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self.contentView addSubview:_bottomLine];
}

- (void)setItem:(HCTextViewItem *)item{
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
    
    //输入框
    _textView.text = _item.content;
    _textView.keyboardType = _item.keyBoardType;
    _textView.userInteractionEnabled = _item.canEdit;
    
    //提示文字
    _placeHolderView.text = _item.placehoder;
    _placeHolderView.hidden = _item.content.length > 0;
    
    //底部分割线
    _bottomLine.hidden = !_item.needBottomLine;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //标题
    CGFloat titleWidth = 0;
    CGFloat titleHeight = 50;
    if (_item.isMustWrite) {
        //必填项
        titleWidth = [_titleView.attributedText.string widthForFont:_titleView.font];
        _titleView.frame = CGRectMake(9, 0, titleWidth, titleHeight);
    }else{
        //非必填项
        titleWidth = [_titleView.text widthForFont:_titleView.font];
        _titleView.frame = CGRectMake(16, 0, titleWidth, titleHeight);
    }
    
    //输入框
    _textView.frame = CGRectMake(_titleView.right + 11, 18, self.width - _titleView.right - 11 - 16, 85 - 18 * 2);
    
    //提示文字
    _placeHolderView.frame = CGRectMake(3, 0, _textView.width, 12);
    
    //底部分割线
    _bottomLine.frame = CGRectMake(0, self.height - 1, self.width, 1);
}

- (void)dealloc{
    NSLog(@"%@---dealloc",NSStringFromClass(self.class));
}

@end
