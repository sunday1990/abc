//
//  ViewController.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/10.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunningOrderCell.h"
#import "pushOrderToListCell.h"

#define _STATUS_BUTTON_GAP 7

typedef  void (^block)(NSString *str);

@interface OrderViewController : UIViewController




// bar
@property (weak, nonatomic) IBOutlet UIButton *changStatusBt;
@property (weak, nonatomic) IBOutlet UIView *signInOrOutBack;

- (IBAction)changeStatusClicked:(UIButton *)sender;
@property (weak,nonatomic)UIButton *statusButton;
@property (weak,nonatomic)UIView *changeStatusView;

- (IBAction)signLoginIn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *runningOrderStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *runningOrderSubLabel;
@property (weak, nonatomic) IBOutlet UITableView *orderTableView;

//datasource
@property (strong, nonatomic)NSMutableArray *dataSource;
@property (copy, nonatomic)NSString *historyNum;

@property (weak, nonatomic) IBOutlet UIButton *upRightBt;

@property (weak, nonatomic) IBOutlet UIButton *signOutBt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signBackHeight;

- (IBAction)signInBt:(UIButton *)sender;

- (IBAction)signOutBt:(UIButton *)sender;


@end

