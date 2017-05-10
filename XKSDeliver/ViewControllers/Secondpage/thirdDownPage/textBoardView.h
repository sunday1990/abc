//
//  textBoardView.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/12/22.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface textBoardView : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *barTitleLb;

- (IBAction)retrunBt:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextView *textDetailTv;

@property (nonatomic,copy)NSString *textContent;

@property (nonatomic,copy)NSString *barTitleString;


@end
