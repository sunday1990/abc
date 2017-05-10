//
//  RemedyOrderViewController.h
//  sample0128
//
//  Created by 同行必达 on 16/2/19.
//  Copyright © 2016年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemedyOrderViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIPickerView *weightPickerView;

@property (weak, nonatomic) IBOutlet UIButton *arrivalTimeBt;

@property (weak, nonatomic) IBOutlet UITextField *customerAddressDetailTf;
@property (weak, nonatomic) IBOutlet UITextField *packageNameTf;
@property (weak, nonatomic) IBOutlet UITextField *customerNameTf;
@property (weak, nonatomic) IBOutlet UITextField *customerPhoneNum;

@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backScrollToTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line6TopToLine5;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line3Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line2Height;


@property (weak, nonatomic) IBOutlet UIButton *shopAddressBt;

- (IBAction)chooseShopAddressClicked:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *targetAddressBt;



- (IBAction)chooseTargetAddressClicked:(UIButton *)sender;

- (IBAction)chooseArrivalTimeBt:(UIButton *)sender;

- (IBAction)returnBtClicked:(UIButton *)sender;

- (IBAction)remedyOrderBtClicked:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UISegmentedControl *remedyOrderSegmentControl;

- (IBAction)remedyOrderTypeChanged:(UISegmentedControl *)sender;

@property (nonatomic,strong)NSMutableDictionary *delegateReturnData;

@property (weak, nonatomic) IBOutlet UIButton *remedyOrderBt;

- (IBAction)callServiceNum:(UIButton *)sender;



@end
