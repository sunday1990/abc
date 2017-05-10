//
//  GroupManagerRemedyOrderVc.h
//  XKSDeliver
//
//  Created by fong on 16/10/16.
//  Copyright © 2016年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupManagerRemedyOrderVc : UIViewController

@property (nonatomic, strong)NSArray *postionArray;//职位数组，需要传递到支援名单页面。

- (IBAction)popBack:(UIButton *)sender;

- (IBAction)chooseRemedyOrderDate:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *cityNameLb;
@property (weak, nonatomic) IBOutlet UILabel *brandNameLb;
@property (weak, nonatomic) IBOutlet UILabel *customerNameLb;


@property (weak, nonatomic) IBOutlet UIButton *addMemberBt;
@property (weak, nonatomic) IBOutlet UIButton *submitOrderBt;


@property (weak, nonatomic) IBOutlet UITableView *workerListTbView;


@property (weak, nonatomic) IBOutlet UIView *pickerBack;
@property (weak, nonatomic) IBOutlet UIView *pickerContainer;

@property (weak, nonatomic) IBOutlet UIButton *chooseTimeBt;
@property (nonatomic,copy)NSString *timeParam;
@property (nonatomic,strong)NSDateFormatter *timeFormatter;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)submitOrder:(UIButton *)sender;


- (IBAction)confirmBtClicked:(UIButton *)sender;
- (IBAction)addHelpWorkers:(UIButton *)sender;

@end
