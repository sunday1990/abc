//
//  textBoardView.m
//  XKSDeliver
//
//  Created by 同行必达 on 15/12/22.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import "textBoardView.h"
#import "NetWorkTool.h"

@interface textBoardView ()

@end

@implementation textBoardView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([_barTitleString isEqualToString:@"xiakezhiguize"]) {
        [self connetXiaKeZhiRuleData];
    }
    else
    {
        _textDetailTv.text = _textContent;
        _barTitleLb.text = _barTitleString;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)retrunBt:(UIButton *)sender {
    if ([_barTitleString isEqualToString:@"xiakezhiguize"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(void)connetXiaKeZhiRuleData
{
    [NetWorkTool getRequestWithUrl:__xiakeScoreRule param:@{@"nowDate":[NSString stringWithFormat:@"%@",[NSDate date]]} addProgressHudOn:self.view Tip:@"侠刻值规则" successReturn:^(id successReturn) {
        
//        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        _textDetailTv.text = [jsonDict valueForKey:@"msg"];
        
    } failed:^(id failed) {
        
    }];

}

@end
