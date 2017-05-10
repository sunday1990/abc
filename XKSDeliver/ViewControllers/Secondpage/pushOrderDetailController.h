//
//  pushOrderDetailController.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/11/16.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pushOrderDetailController : UIViewController



@property (weak, nonatomic) IBOutlet UILabel *titleLb;

- (IBAction)returnBtClicked:(UIButton *)sender;

- (IBAction)confirmOrderBtClicked:(UIButton *)sender;

- (IBAction)planTraceBtClicked:(UIButton *)sender;

//Basic UI


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineOrderTypeToTop;

@property (weak, nonatomic) IBOutlet UILabel *orderTypeLb;

@property (weak, nonatomic) IBOutlet UILabel *reservingArriveTimeLb;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTwoTopToLineOne;

@property (weak, nonatomic) IBOutlet UILabel *orderReserveTimeLb;

@property (weak, nonatomic) IBOutlet UILabel *reserveArriveTimeLb;


@property (weak, nonatomic) IBOutlet UITextView *addressTv;

@property (weak, nonatomic) IBOutlet UILabel *awardMoneyLb;
@property (weak, nonatomic) IBOutlet UILabel *packageWeightLb;
@property (weak, nonatomic) IBOutlet UILabel *packageNameLb;
@property (weak, nonatomic) IBOutlet UILabel *askMoneyLb;
@property (weak, nonatomic) IBOutlet UILabel *payPersonLb;
@property (weak, nonatomic) IBOutlet UILabel *getPackageDistanceLb;
@property (weak, nonatomic) IBOutlet UILabel *distanceLb;
@property (weak, nonatomic) IBOutlet UILabel *noteLb;

@property (nonatomic,copy)NSString *fromWhich;
@property (nonatomic,copy)NSString *orderId;
@property (nonatomic,copy)NSString *displayMethod;

@property (nonatomic,strong)NSDictionary *dataSource;
// top to address not six
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToLinesix;

@property (weak, nonatomic) IBOutlet UIButton *planTraceBt;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToLineNine;


//隐藏金额



@end
