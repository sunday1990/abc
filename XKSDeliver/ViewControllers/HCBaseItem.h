//
//  HCBaseItem.h
//  SpaceHome
//
//  Created by suhc on 2017/2/8.
//
//

#import <Foundation/Foundation.h>
#import "common.h"
@interface HCBaseItem : NSObject

/**cell高度*/
@property (nonatomic, assign) CGFloat cellHeight;

/**是否需要底部的分割线*/
@property (nonatomic, assign, getter=isNeedBottomLine) BOOL needBottomLine;

/**TableView*/
@property (nonatomic, weak) UITableView *tableView;

@end
