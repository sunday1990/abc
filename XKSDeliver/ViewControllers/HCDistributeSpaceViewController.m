//
//  HCDistributeSpaceViewController.m
//  SpaceHome
//
//  Created by suhc on 2017/1/11.
//
//



#import "HCDistributeSpaceViewController.h"
#import "HCDistributeSpaceCell.h"
#import "HCDistributeSpaceHeaderView.h"
#import "HCTextViewCell.h"
#import "HCCommonCell.h"
#import "common.h"
static CGFloat padding = 12.f;


@interface HCDistributeSpaceViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation HCDistributeSpaceViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupTableView];
}

#pragma mark - UI
/**
 *  设置tableview
 */
- (void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, UI_NAV_BAR_HEIGHT,_SCREEN_WIDTH_ ,_SCREEN_HEIGHT_ - UI_NAV_BAR_HEIGHT) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(padding, 0, 0, 0);
    tableView.bounces = YES;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - UITableViewDataSource
/**
 *  一共有多少组(默认是一组)
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.groups.count;
}

/**
 *  每组有多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HCDistributeSpaceGroup *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HCDistributeSpaceGroup *group = self.groups[indexPath.section];
    
    HCBaseItem *item = group.items[indexPath.row];
    item.tableView = tableView;
    
    NSInteger count = group.items.count;
    
    if (indexPath.row == count - 1) {
        item.needBottomLine = NO;
    }else{
        item.needBottomLine = YES;
    }
    
    if ([item isKindOfClass:[HCTextViewItem class]]){
        HCTextViewCell *cell = [HCTextViewCell cellWithTableView:tableView];
        cell.item = (HCTextViewItem *)item;
        if (item.cellHeight == 0) {
            item.cellHeight = 85;
        }
        return cell;
    }else if ([item isKindOfClass:[HCDistributeSpaceItem class]]) {
        HCDistributeSpaceCell *cell = [HCDistributeSpaceCell cellWithTableView:tableView];
        cell.item = (HCDistributeSpaceItem *)item;
        if (item.cellHeight == 0) {
            item.cellHeight = 50;
        }
        
        return cell;
    }else if ([item isKindOfClass:[HCCommonItem class]]) {
        HCCommonCell *cell = [HCCommonCell cellWithTableView:tableView];
        cell.item = (HCCommonItem *)item;

        return cell;
    }else if ([item isKindOfClass:[HCPhotoItem class]]) {
//        HCPhotoView *cell = [HCPhotoView cellWithTableView:tableView];
//        cell.item = (HCPhotoItem *)item;
//        if (item.cellHeight == 0) {
//            item.cellHeight = 100;
//        }
//        
//        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
//选中某一行cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HCDistributeSpaceGroup *group = self.groups[indexPath.section];
    if ([group.items[indexPath.row] isKindOfClass:[HCDistributeSpaceItem class]]) {
        HCDistributeSpaceItem *item = group.items[indexPath.row];
        if (item.cellSelected) {
            item.cellSelected(indexPath);
        }
    }else
        return;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HCDistributeSpaceGroup *group = self.groups[indexPath.section];
    
    HCBaseItem *item = group.items[indexPath.row];
    
    return item.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    HCDistributeSpaceGroup *group = self.groups[section];
    
    return group.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 12.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HCDistributeSpaceHeaderView *headerView = [HCDistributeSpaceHeaderView headerViewWithTableView:tableView];
    
    HCDistributeSpaceGroup *group = self.groups[section];
    group.needBottomLine = group.title;
    
    headerView.group = group;
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    
    return view;
}

- (HCDistributeSpaceGroup *)addCommonGroupWithHeader:(NSString *)header{
    HCDistributeSpaceGroup *group = [[HCDistributeSpaceGroup alloc] init];
    group.title = header;
    
    [self.groups addObject:group];
    return group;
}

#pragma mark - 懒加载
- (NSMutableArray *)groups{
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

@end
