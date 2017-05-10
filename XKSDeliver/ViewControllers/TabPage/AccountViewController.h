//
//  AccountViewController.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/10.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *accountTableView;

- (IBAction)servicePhoneNum:(UIButton *)sender;

@property (nonatomic,strong)NSDictionary *dataSource;

@property (weak, nonatomic) IBOutlet UIView *emptyBackView;

@property (weak, nonatomic) IBOutlet UITextView *emptyTipTv;


@property (weak, nonatomic) IBOutlet UILabel *userNameLb;

@property (weak, nonatomic) IBOutlet UIButton *signBt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userInfoBtTrailingConstriants;

- (IBAction)checkUserInfomation:(UIButton *)sender;

- (IBAction)checkSignDateResult:(UIButton *)sender;


@end
