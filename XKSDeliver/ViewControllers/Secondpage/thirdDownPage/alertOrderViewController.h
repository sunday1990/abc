//
//  alertOrderViewController.h
//  alertcusteomdf
//
//  Created by 同行必达 on 15/12/17.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol alertOrderView <NSObject>

@required
-(void)alertOrderViewClicked:(NSString *)tag;

@end

@interface alertOrderViewController : UIViewController

@property (nonatomic,assign)id <alertOrderView>alertOrderDelegate;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewToTop;

@property AVAudioPlayer *orderComePlayer;

- (IBAction)getOrderBtClicked:(UIButton *)sender;


@end
