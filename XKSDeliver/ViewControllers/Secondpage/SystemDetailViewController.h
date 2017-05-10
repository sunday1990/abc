//
//  SystemDetailViewController.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/14.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemDetailViewController : UIViewController


@property (nonatomic,copy)NSString *fromWhich;

@property (weak, nonatomic) IBOutlet UILabel *barTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *barReturnBt;

- (IBAction)barReturnBtClicked:(id)sender;

- (IBAction)servicePhoneNum:(UIButton *)sender;


//section 1

@property (weak, nonatomic) IBOutlet UIView *page1BackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *modifyPasswordToTop;
@property (weak, nonatomic) IBOutlet UITextField *ordPasswordTf;
@property (weak, nonatomic) IBOutlet UITextField *wantPasswordTf;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTf;
@property (weak, nonatomic) IBOutlet UIButton *confirmPasswordBt;

- (IBAction)confirmNewPassword:(UIButton *)sender;


//section 2
@property (weak, nonatomic) IBOutlet UIView *page2BackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *modifyBundlenumTotop;
@property (weak, nonatomic) IBOutlet UITextField *bundleNumTf;
@property (weak, nonatomic) IBOutlet UITextField *bundlePasswordTf;
@property (weak, nonatomic) IBOutlet UIButton *bundleConfirmBt;

- (IBAction)bundleConfirmBtClicked:(UIButton *)sender;

//section 3

//section 4

@property (weak, nonatomic) IBOutlet UIView *page4BackView;

@property (weak, nonatomic) IBOutlet UITableView *noticeTableView;

@property (nonatomic,strong)NSArray *dataArray;

@property (nonatomic,strong)NSString *fromType;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noticeTableToBottom;

//section 6
@property (weak, nonatomic) IBOutlet UIView *page6BackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *page6BackViewToTop;
@property (weak, nonatomic) IBOutlet UITextView *aboutSystemTv;
@property (weak, nonatomic) IBOutlet UILabel *VersionNumLb;


//section 7

@property (weak, nonatomic) IBOutlet UIView *page7BackView;

@property (weak, nonatomic) IBOutlet UILabel *inviteCodeLb;

- (IBAction)checkEventDetailBtCikcked:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *invitePersonNumLb;

@property (weak, nonatomic) IBOutlet UILabel *inviteAwardMoneyLb;

@property (weak, nonatomic) IBOutlet UITextView *awardPricipleTv;

@property (nonatomic,copy) NSString *activityRule;

@property (nonatomic,strong) NSDictionary *shareDetail;


@property (weak, nonatomic) IBOutlet UIButton *TimeLineBt;

@property (weak, nonatomic) IBOutlet UIButton *weChantSessionBt;

@property (weak, nonatomic) IBOutlet UIButton *sinaBlogBt;

@property (weak, nonatomic) IBOutlet UIButton *qqSesstionBt;

@property (weak, nonatomic) IBOutlet UIButton *messageBt;


- (IBAction)shareToTimeLine:(UIButton *)sender;

- (IBAction)shareToWeChant:(UIButton *)sender;

- (IBAction)shareToSinaBlog:(UIButton *)sender;

- (IBAction)shareToQQ:(UIButton *)sender;

- (IBAction)shareToMessage:(UIButton *)sender;


@end
