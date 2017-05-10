//
//  HCPopView.m
//  SpaceHome
//
//  Created by suhc on 2017/1/12.
//
//

//每一行的高度
#define Cell_Height 44.f
//头部标题的高度
#define HeaderView_Height 44.f
//数据很多时，默认显示的行数
#define MaxCount 6

#import "HCPopView.h"
#import "ReactiveCocoa.h"
#import "UIImage+Extensions.h"
#import "HCDistributeSpaceItem.h"
#import "HCDistributeSpaceGroup.h"

@interface HCPopView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_titles;
    UITableView *_tableView;
    UITableView *_selfTableView;
}
@end
@implementation HCPopView
+ (instancetype)popViewWithController:(UIViewController *)controller tableView:(UITableView *)tableView group:(HCDistributeSpaceGroup *)group header:(NSString *)header titles:(NSArray *)titles{
    return [[HCPopView alloc] initWithController:controller tableView:tableView group:group item:nil header:header titles:titles];
}

+ (instancetype)popViewWithController:(UIViewController *)controller tableView:(UITableView *)tableView item:(HCDistributeSpaceItem *)item header:(NSString *)header titles:(NSArray *)titles{
    return [[HCPopView alloc] initWithController:controller tableView:tableView group:nil item:item header:header titles:titles];
}

- (instancetype)initWithController:(UIViewController *)controller tableView:(UITableView *)tableView group:(HCDistributeSpaceGroup *)group item:(HCDistributeSpaceItem *)item header:(NSString *)header titles:(NSArray *)titles{
    if (self = [super init]) {

        _titles = titles;
        self.group = group;
        self.item = item;
        _tableView = tableView;
        
        [controller.view endEditing:YES];
        //设置自己透明（子控件不透明，alpha是包括自己的子控件也透明）
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        [controller.view addSubview:self];
        
        //1.添加蒙板
        UIButton *alphaView = [UIButton buttonWithType:UIButtonTypeCustom];
    
        alphaView.frame = [UIScreen mainScreen].bounds;
        alphaView.backgroundColor = [UIColor darkGrayColor];
        alphaView.alpha = 0.6;
        WEAK(self)
        [[alphaView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [weakself cancel];
        }];
        [self addSubview:alphaView];
        
        //添加tableView(下面的6代表数据很多时，默认显示的行数)
        _selfTableView = [[UITableView alloc] init];
        _selfTableView.scrollEnabled = titles.count > MaxCount;
        _selfTableView.dataSource = self;
        _selfTableView.delegate = self;
        _selfTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self addSubview:_selfTableView];
        
        NSInteger row = 0;
        if (item && item.popOptionIndex) {
            row = item.popOptionIndex - 1;
        }
        if (group && group.popOptionIndex) {
            row = group.popOptionIndex - 1;
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [_selfTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
        //headerView
        UILabel *headerView = [[UILabel alloc] init];
        headerView.backgroundColor = [UIColor whiteColor];
        headerView.textColor = [UIColor colorWithHexString:@"#43464f"];
        headerView.font = GetFont(16);
        headerView.textAlignment = NSTextAlignmentCenter;
        headerView.text = header;
        [self addSubview:headerView];
        
        //tableview的高度
        NSUInteger showCount = (titles.count > MaxCount ? MaxCount : titles.count);
        
        CGFloat tableViewHeight = showCount * Cell_Height;
        _selfTableView.frame = CGRectMake(0, _SCREEN_HEIGHT_ - tableViewHeight, _SCREEN_WIDTH_, tableViewHeight);
        headerView.frame = CGRectMake(0, 0, _SCREEN_WIDTH_, HeaderView_Height);
        headerView.bottom = _selfTableView.top;
        
        //headerView下面的分割线
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA"];
        bottomLine.frame = CGRectMake(0, 0, _SCREEN_WIDTH_, 1);
        bottomLine.top = headerView.bottom - 1;
        [self addSubview:bottomLine];
    }
    return self;
}

#pragma mark - UITableViewDataSource
/**
 *  每组有多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //1.创建cell
    HCPopViewCell *cell = [HCPopViewCell cellWithTableView:tableView];
    
    //2.设置数据
    cell.content = _titles[indexPath.row];
    WEAK(self)
    __weak typeof(tableView) weakTableView = tableView;
    __weak typeof(indexPath) weakIndexPath = indexPath;
    cell.contentDidBeSelect = ^(UIButton *button){
        [weakself tableView:weakTableView didSelectRowAtIndexPath:weakIndexPath];
    };
    if (self.item && [self.item.popOption isEqualToString:_titles[indexPath.row]]) {
        cell.select = YES;
    }else if (self.group && [self.group.popOption isEqualToString:_titles[indexPath.row]]) {
        cell.select = YES;
    }else{
        cell.select = NO;
    }
    
    //3.返回cell
    return cell;
}

#pragma mark - UITableViewDelegate
//选中某一行cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.item) {
        self.item.popOptionIndex = indexPath.row + 1;
        self.item.popOption = _titles[indexPath.row];
        self.item.rightText = _titles[indexPath.row];
    }
    if (self.group) {
        self.group.popOptionIndex = indexPath.row + 1;
        self.group.popOption = _titles[indexPath.row];
        self.group.rightText = _titles[indexPath.row];
    }
    
    [_tableView reloadData];
    
    //移除
    [self cancel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Cell_Height;
}

#pragma mark - 处理分割线
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //按照作者最后的意思还要加上下面这一段，才能做到底部线控制位置，所以这里按stackflow上的做法添加上吧。
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

/**
 *  移除
 */
- (void)cancel{
    [self removeFromSuperview];
}

@end














@interface HCPopViewCell ()
{
    UIButton *_contentView;
}
@end
@implementation HCPopViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"HCPopViewCell_ID";
    HCPopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[HCPopViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //设置选中样式
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //初始化子控件
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews{
    //内容
    _contentView = [UIButton buttonWithType:UIButtonTypeCustom];
    _contentView.titleLabel.font = GetFont(14.f);
    [_contentView setTitleColor:[UIColor colorWithHexString:@"0x5b5e67"] forState:UIControlStateNormal];
    [_contentView setTitleColor:DarkTextColor forState:UIControlStateHighlighted];
    [_contentView setTitleColor:GREEN_COLOR forState:UIControlStateSelected];
    [_contentView setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#f4f5f9"]] forState:UIControlStateHighlighted];
    [_contentView setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#f4f5f9"]] forState:UIControlStateSelected];
    [self.contentView addSubview:_contentView];
    
    WEAK(self)
    [[_contentView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        UIButton *button = (UIButton *)x;
        if (weakself.contentDidBeSelect) {
            weakself.contentDidBeSelect(button);
        }
    }];
}

- (void)setSelect:(BOOL)select{
    _select = select;
    _contentView.selected = _select;
}

- (void)setContent:(NSString *)content{
    _content = content;
    
    [_contentView setTitle:_content forState:UIControlStateNormal];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _contentView.frame = self.bounds;
}

@end
