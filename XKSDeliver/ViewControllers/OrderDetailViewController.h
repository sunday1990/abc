//
//  OrderDetailViewController.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/12.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WaitingOrderDetail,
    RunningOrderDetail,
    
} OrderDetailType;

@interface

OrderDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *orderTypeLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderTypeViewToTop;
@property (weak, nonatomic) IBOutlet UIView *orderTypeView;

@property (weak, nonatomic) IBOutlet UILabel *orderNoLb;

@property (weak, nonatomic) IBOutlet UILabel *reservingTimeLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reservingTimeViewToTop;
@property (weak, nonatomic) IBOutlet UIView *reservingTimeView;

@property (weak, nonatomic) IBOutlet UILabel *receiveOrderTimeLb;

@property (weak, nonatomic) IBOutlet UILabel *getPackageTimeLb;

@property (weak, nonatomic) IBOutlet UILabel *sendPersonLb;

@property (weak, nonatomic) IBOutlet UILabel *receivePersonLb;

@property (weak, nonatomic) IBOutlet UILabel *orderGenerateTimeLb;
@property (weak, nonatomic) IBOutlet UITextView *startAndEndAddressTv;
@property (weak, nonatomic) IBOutlet UILabel *awardLb;
@property (weak, nonatomic) IBOutlet UILabel *weightLb;

@property (weak, nonatomic) IBOutlet UILabel *goodsNameLb;
@property (weak, nonatomic) IBOutlet UILabel *distanceLb;
@property (weak, nonatomic) IBOutlet UILabel *PayMethodLb;
@property (weak, nonatomic) IBOutlet UILabel *customPayMoneyLb;
@property (weak, nonatomic) IBOutlet UILabel *noteLb;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewJumpedUp;
@property (weak, nonatomic) IBOutlet UIScrollView *orderDetailBckScrollView;
@property (weak, nonatomic) IBOutlet UIButton *planTraceBt;

- (IBAction)planTraceBtClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *deliverVerityCodeTf;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendVertifyCodeToTf;


- (IBAction)servicePhoneNum:(UIButton *)sender;
- (IBAction)returnBtClicked:(UIButton *)sender;

- (IBAction)dailSendPersonPhone:(UIButton *)sender;
- (IBAction)dailReceivePersonPhone:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *sendVerityCodeBt;

- (IBAction)startToSendClicked:(UIButton *)sender;

@property (nonatomic,strong)NSString *orderId;
@property (nonatomic,strong)NSMutableDictionary *dataSource;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *packagePropertyToTop;

@end
