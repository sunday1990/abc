//
//  AboutSystemViewController.m
//  XKSDeliver
//
//  Created by ccSunday on 2017/2/23.
//  Copyright © 2017年 同行必达. All rights reserved.
//

#import "AboutSystemViewController.h"

@interface AboutSystemViewController ()
{


}
@end

@implementation AboutSystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 _aboutSystemTv.text   = @"     侠刻送致力于同城极速配送服务，隶属于北京同行必达科技有限公司，业务范围遍及全国20多个城市，共有3000多名专业全职快递员，并与麦当劳、肯德基、吉野家、沃尔玛等大型连锁企业达成长期战略合作，是国内专业领先的同城配送平台。侠刻送基于移动互联网LBS技术的高科技服务平台，用户可通过微信、手机APP、官方网站等方式在线下单，由就近的配送员接单并完成服务，全程凭密收发、专人直送，闪电配送，确保配送物品极速，安全，准时送达。\n       本软件为侠刻送的快递员端，快递师傅可以通过本软件实时定位，接单，规划路线，查询个人账户，高效完成速递任务。\n\n\n Copyright © 2015 - 2025 北京同行必达科技有限公司 版权所有";
 _VersionNumLb.text = [NSString stringWithFormat:@"%@%@",@"版本号:",_VERSION_NUM_];
 _page6BackView.frame = CGRectMake(0, UI_NAV_BAR_HEIGHT, WIDTH, _page6BackView.height);

 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
