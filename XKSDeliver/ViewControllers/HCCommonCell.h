//
//  HCCommonCell.h
//  SpaceHome
//
//  Created by suhc on 2017/2/7.
//
//

#import <UIKit/UIKit.h>
#import "HCCommonItem.h"

@interface HCCommonCell : UITableViewCell

/**
 *  快速创建cell
 *
 *  @param tableView 需要创建cell的tableView
 *
 *  @return 创建好的cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 *  数据模型
 */
@property (nonatomic, strong) HCCommonItem *item;

@end
