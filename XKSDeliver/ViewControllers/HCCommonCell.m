//
//  HCCommonCell.m
//  SpaceHome
//
//  Created by suhc on 2017/2/7.
//
//

#import "HCCommonCell.h"

@interface HCCommonCell ()

@end
@implementation HCCommonCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"HCCommonCell_ID";
    HCCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[HCCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //选中样式
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)setItem:(HCCommonItem *)item{
    _item = item;
    
    [_item removeAssociateObjectWithKey:_item.objKey];
    
    //添加自定义内容
    if (_item.objKey) {
        UIView *objView = [_item getAssociatedObjectWithKey:_item.objKey];
        if (objView) {
            [self.contentView addSubview:objView];
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //添加自定义内容
    if (_item.objKey) {
        UIView *objView = [_item getAssociatedObjectWithKey:_item.objKey];
        if (objView) {
            objView.frame = CGRectMake(0, 0, self.width, _item.cellHeight);
        }
    }
}

- (void)dealloc{
    NSLog(@"%@---dealloc",NSStringFromClass(self.class));
}

@end
