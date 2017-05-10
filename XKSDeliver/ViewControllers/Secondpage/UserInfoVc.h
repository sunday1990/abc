//
//  UserInfoVc.h
//  XKSDeliver
//
//  Created by 同行必达 on 16/5/6.
//  Copyright © 2016年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UserInfoVc : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *userInfoTableView;
@property (strong, nonatomic)NSMutableArray *infoDataSource;
@property (strong, nonatomic)NSMutableArray *infoNameDataSource;
@property (strong, nonatomic)NSMutableArray *titleNameArray;
- (IBAction)returnBtClicked:(UIButton *)sender;
- (IBAction)serviceBtClicked:(UIButton *)sender;
@end
