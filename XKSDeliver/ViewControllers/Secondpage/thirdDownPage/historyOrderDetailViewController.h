//
//  historyOrderDetailViewController.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/11/17.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef enum : NSUInteger {
//    <#MyEnumValueA#>,
//    <#MyEnumValueB#>,
//    <#MyEnumValueC#>,
//} orderStutas;

// 此页用作订单详情页  历史订单  账户记录中


@interface historyOrderDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *orderDetailTitleLb;

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLb;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLb;


@property (weak, nonatomic) IBOutlet UILabel *orderMoneyLb;
@property (weak, nonatomic) IBOutlet UILabel *driverDeductLb;
@property (weak, nonatomic) IBOutlet UILabel *customerNameLb;
@property (weak, nonatomic) IBOutlet UILabel *receivePackageNameLb;

//address

@property (weak, nonatomic) IBOutlet UITextView *addressTv;



@property (weak, nonatomic) IBOutlet UILabel *orderConfirmLb;
@property (weak, nonatomic) IBOutlet UILabel *reserveArriveTimeLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reserveArriveTimeLbToOrderConfirmLb;    //-30隐藏
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineOrderToTop;
    //-30隐藏

@property (weak, nonatomic) IBOutlet UILabel *getPackageTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *packageArriveTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLb;

@property (weak, nonatomic) IBOutlet UILabel *totalUseTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *remarkLb;


// address adjust
@property (weak, nonatomic) IBOutlet UIView *lineSixBackView;
@property (weak, nonatomic) IBOutlet UIView *lineSevenBackView;


- (IBAction)returnBtClicked:(UIButton *)sender;
- (IBAction)callServiceBtClicked:(UIButton *)sender;

@property (nonatomic,strong)NSString *fromWhich;
// order number 
@property (nonatomic,strong)NSString *orderNumber;
@property (nonatomic,strong)NSDictionary *dataSource;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToLineThree;


//有抽奖订单 srollview to bottom + shareView' height

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentsizeToBottom;

@property (weak, nonatomic) IBOutlet UIView *shareView;


- (IBAction)shareToTimeLineBtClicked:(UIButton *)sender;


- (IBAction)shareBtClicked:(UIButton *)sender;

@property (nonatomic,strong)NSDictionary *shareContent;


@property (weak, nonatomic) IBOutlet UIButton *timeLineBt;

@property (weak, nonatomic) IBOutlet UIButton *weChantBt;

@property (weak, nonatomic) IBOutlet UIButton *QQBt;



@end
