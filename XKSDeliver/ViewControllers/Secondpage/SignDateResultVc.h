//
//  SignDateResultVc.h
//  XKSDeliver
//
//  Created by 同行必达 on 16/5/6.
//  Copyright © 2016年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignDateResultVc : UIViewController

 
@property (nonatomic,copy)NSString *fromWhich;

@property (weak, nonatomic) IBOutlet UILabel *pageTitleLb;


@property (weak, nonatomic) IBOutlet UILabel *displayMonthLb;


@property (weak, nonatomic) IBOutlet UIButton *lastMonthBt;
- (IBAction)checkLastMonth:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *nextMonthBt;

- (IBAction)checkNextMonth:(UIButton *)sender;


- (IBAction)returnBtClicked:(UIButton *)sender;

- (IBAction)serviceBtClicked:(UIButton *)sender;

@property (nonatomic,strong)NSArray *signDataSource;
@property (nonatomic,strong)NSArray *signPerDaySource;
@property (nonatomic,assign)NSInteger maxDay;
@property (nonatomic,copy)NSString *joinWorkDate;

@property (nonatomic,strong) UITableView *daySignRecordTbView;

@property (weak, nonatomic) IBOutlet UIView *backView;


@end
