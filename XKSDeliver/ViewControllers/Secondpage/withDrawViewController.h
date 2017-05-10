//
//  withDrawViewController.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/20.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface withDrawViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

//withdraw
//余额
//tixian button
//交易明细
//table view
@property (weak, nonatomic) IBOutlet UILabel *balanceLb;

@property (weak, nonatomic) IBOutlet UITableView *withDrawListTableView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *dataTypeChangeControl;


- (IBAction)listControlCLicked:(UISegmentedControl *)sender;

- (IBAction)returnBtClicked:(UIButton *)sender;

- (IBAction)servicePhoneNum:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *withDrawBt;

- (IBAction)toWithDrawMoneyBtClicked:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *tableViewTitleLb;

@property (nonatomic,strong)NSArray *dataSource;
@property (nonatomic,copy)NSString *dataType;


@end
