//
//  LoginViewController.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/13.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JugeLogin <NSObject>
@required
-(void)sendLoginStatusString:(NSString *)status;
@end

@interface LoginViewController : UIViewController

@property (nonatomic,assign) id<JugeLogin>Jugedelegate;

//default controller view
@property (strong, nonatomic) IBOutlet UIView *loginControllerview;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UIImageView *AccountTfImage;
@property (weak, nonatomic) IBOutlet UITextField *AccountTf;
@property (weak, nonatomic) IBOutlet UIImageView *PasswordTfImage;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTf;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtContentToTop;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIView *loginBtContainer;

- (IBAction)loginBtClicked:(UIButton *)sender;
@property (strong, nonatomic)  UIButton *bindleBtn;
@property (strong, nonatomic)  UIButton *clearBtn;
@property (strong, nonatomic)  UIButton *loginBtn;

- (IBAction)clearDataBtClicked:(UIButton *)sender;



- (IBAction)bindBtnClicked:(UIButton *)sender;

@end
