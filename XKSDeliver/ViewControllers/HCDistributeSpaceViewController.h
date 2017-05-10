//
//  HCDistributeSpaceViewController.h
//  SpaceHome
//
//  Created by suhc on 2017/1/11.
//
//

#import "RootViewController.h"
#import "HCDistributeSpaceGroup.h"
#import "HCDistributeSpaceItem.h"
#import "HCTextViewItem.h"
#import "HCCommonItem.h"
#import "HCPopView.h"
#import "HCPhotoItem.h"

@interface HCDistributeSpaceViewController : RootViewController

/**
 *  通过标题添加一个组模型
 *
 *  @param header 标题
 *
 *  @return 组模型
 */
- (HCDistributeSpaceGroup *)addCommonGroupWithHeader:(NSString *)header;

/**
 *  保存所有组的数据
 */
@property (nonatomic, strong) NSMutableArray *groups;

/**
 *  TableView
 */
@property (nonatomic, weak) UITableView *tableView;

@end
