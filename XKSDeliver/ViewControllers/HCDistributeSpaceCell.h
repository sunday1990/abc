//
//  HCDistributeSpaceCell.h
//  SpaceHome
//
//  Created by suhc on 2017/1/11.
//
//

#import <UIKit/UIKit.h>
#import "HCDistributeSpaceItem.h"

@interface HCDistributeSpaceCell : UITableViewCell

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
@property (nonatomic, strong) HCDistributeSpaceItem *item;

@end
