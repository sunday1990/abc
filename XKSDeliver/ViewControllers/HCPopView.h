//
//  HCPopView.h
//  SpaceHome
//
//  Created by suhc on 2017/1/12.
//
//

#import <UIKit/UIKit.h>

@class HCDistributeSpaceItem,HCDistributeSpaceGroup;
@interface HCPopView : UIView

/**
 *  根据标题和内容数组创建PopView
 *
 *  @param header     标题
 *  @param controller 需要添加弹窗的controller
 *  @param titles     内容数组
 *  @param tableView  所在的tableView
 *  @param group      所对应的group
 */
+ (instancetype)popViewWithController:(UIViewController *)controller tableView:(UITableView *)tableView group:(HCDistributeSpaceGroup *)group header:(NSString *)header titles:(NSArray *)titles;

/**
 *  根据标题和内容数组创建PopView
 *
 *  @param header     标题
 *  @param controller 需要添加弹窗的controller
 *  @param titles     内容数组
 *  @param tableView  所在的tableView
 *  @param item      所对应的item
 */
+ (instancetype)popViewWithController:(UIViewController *)controller tableView:(UITableView *)tableView item:(HCDistributeSpaceItem *)item header:(NSString *)header titles:(NSArray *)titles;

/**
 *  数据模型
 */
@property (nonatomic, strong) HCDistributeSpaceItem *item;

@property (nonatomic, strong) HCDistributeSpaceGroup *group;

@end







@interface HCPopViewCell : UITableViewCell

/**
 *  快速创建cell
 *
 *  @param tableView 需要创建cell的tableView
 *
 *  @return 创建好的cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 *  内容
 */
@property (nonatomic, copy) NSString *content;

/**选中了某个cell*/
@property (nonatomic, copy) void(^contentDidBeSelect)(UIButton *);

/**选中状态*/
@property (nonatomic, assign, getter=isSelect) BOOL select;

@end
