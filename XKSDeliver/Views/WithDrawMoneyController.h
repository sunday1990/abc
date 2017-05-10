//
//  WithDrawMoneyController.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/11/24.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithDrawMoneyController : UIViewController

- (IBAction)returnBtClicked:(UIButton *)sender;

- (IBAction)serviceBtClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *withDrawMoneyTf;

- (IBAction)confirmToWithdrawBt:(UIButton *)sender;


@end
