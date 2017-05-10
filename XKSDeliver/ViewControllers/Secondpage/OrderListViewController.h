//
//  OrderListViewController.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/21.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OrderListViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIView *selectTypeBoard;
- (IBAction)selectedButtonClicked:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UILabel *barTitleLb;

@property (weak, nonatomic) IBOutlet UITableView *OrderListTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderListTableToBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderListTableToBottom;


- (IBAction)returnBtClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *settingBt;

@property (weak, nonatomic) IBOutlet UIButton *serviceBt;

- (IBAction)servicePhoneNum:(UIButton *)sender;

//action sheet
@property (nonatomic,strong)UIActionSheet *chooseMileAction;


//adjust constraint  隐藏提成条目

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingToDistanceForAwardmoney;

@property (nonatomic,copy)NSString *fromWhich;
@property (nonatomic,copy)NSString *displayMethod;
@property (nonatomic,copy)NSString *ifAutoAssignOrder;

//data
@property (nonatomic,strong)NSArray *dataSource;


@property (weak, nonatomic) IBOutlet UIView *checkOrderNumBackView;

- (IBAction)checkOrderNumPerDay:(UIButton *)sender;





@end
