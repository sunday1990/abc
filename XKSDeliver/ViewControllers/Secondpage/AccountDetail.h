//
//  AccountDetail.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/20.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"

@interface AccountDetail : UIViewController<UITableViewDelegate,UITableViewDataSource>


// account detail
@property (weak, nonatomic) IBOutlet UILabel *accountTimeLb;
@property (weak, nonatomic) IBOutlet UISegmentedControl *listChooseSegment;

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender;


@property (weak, nonatomic) IBOutlet UIView *accountDetailBkView;

@property (weak, nonatomic) IBOutlet UITableView *accountDetailTableView;


- (IBAction)servicePhoneNum:(UIButton *)sender;

- (IBAction)barReturnBtClicked:(UIButton *)sender;

@property (nonatomic,strong)NSString *whichMonth;
@property (nonatomic,strong)NSArray *dataSource;





@end
