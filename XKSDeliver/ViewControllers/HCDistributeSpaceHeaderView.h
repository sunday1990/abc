//
//  HCDistributeSpaceHeaderView.h
//  SpaceHome
//
//  Created by suhc on 2017/1/11.
//
//

#import <UIKit/UIKit.h>

@class HCDistributeSpaceGroup;
@interface HCDistributeSpaceHeaderView : UITableViewHeaderFooterView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

/**
 *  数据模型
 */
@property (nonatomic, strong) HCDistributeSpaceGroup *group;

@end
