//
//  pushOrderToListCell.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/16.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"

@interface pushOrderToListCell : UITableViewCell



#define _CELL_MAINTITLE_WAITING @"待接订单"
#define _CELL_SUBTITLE_WAITING  @"当前是否有需要配送的订单"
#define _CELL_MAINTITLE_HISTORY @"历史订单"
#define _CELL_SUBTITLE_HISTORY  @"完成的订单都在这里"

#define _CELL_STATEIMAGE_WAITING @"waiting_Order@2x"
#define _CELL_STATEIMAGE_HISTORY @"history_Order@2x"



@property (weak, nonatomic) IBOutlet UIImageView *orderStateImage;

@property (weak, nonatomic) IBOutlet UILabel *orderStateMainTitle;

@property (weak, nonatomic) IBOutlet UILabel *orderStateSubTitle;

@property (weak, nonatomic) IBOutlet UILabel *orderNum;



@end
