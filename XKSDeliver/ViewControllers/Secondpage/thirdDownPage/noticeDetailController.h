//
//  noticeDetailController.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/12/8.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AfterReadReloadNoticeList <NSObject>

@optional
-(void)reloadListFromHeader;
@end

@interface noticeDetailController : UIViewController

@property (nonatomic,assign)id <AfterReadReloadNoticeList>reloadNoticeListDelegate;

@property (nonatomic,copy)NSString *noticeID;
@property (nonatomic,assign)NSInteger indexPathRowNum;

- (IBAction)returnBtClicked:(UIButton *)sender;
- (IBAction)serviceButtonClicked:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *originLb;
@property (weak, nonatomic) IBOutlet UITextView *detailTv;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailTvHeight;



@property (weak, nonatomic) IBOutlet UILabel *pageLb;
@property (weak, nonatomic) IBOutlet UIButton *nextPageBt;
@property (weak, nonatomic) IBOutlet UIButton *lastPageBt;
- (IBAction)nextBtClicked:(UIButton *)sender;
- (IBAction)lastBtClicked:(UIButton *)sender;

@property (nonatomic,copy)NSString *fromType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomToTabBar;


@end
