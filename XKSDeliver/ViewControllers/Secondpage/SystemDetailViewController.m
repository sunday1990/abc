//
//  SystemDetailViewController.m
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/14.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import "SystemDetailViewController.h"
#import "common.h"
#import "NetWorkTool.h"
#import "MJRefresh.h"
#import "NoticeCell.h"
#import "noticeDetailController.h"
#import "textBoardView.h"
#import "UMSocial.h"
#import "UMSocialControllerService.h"
#import <Social/Social.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>


NSInteger changeSuccess = 666;

NSInteger noticePageNumber = 1;

BOOL godidload = NO;


@interface SystemDetailViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,AfterReadReloadNoticeList>

@end

@implementation SystemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ROOT_VIEW_BGCOLOR;
    noticePageNumber = 1;
    [self judgePushFromWhich];
    [self initData];
    godidload = YES;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
    if ([_fromWhich isEqualToString:_SYSPAGETITTLE4_]) {
        if (godidload == YES) {
            return;
        }
        [self headerRefresh];
    }
    if ([WXApi isWXAppInstalled]) {
        _TimeLineBt.hidden = NO;
        _weChantSessionBt.hidden = NO;
    }else{
        _TimeLineBt.hidden = YES;
        _weChantSessionBt.hidden = YES;
    }
    
    if ([QQApiInterface isQQInstalled]) {
        _qqSesstionBt.hidden = NO;
    }else{
        _qqSesstionBt.hidden = YES;
    }
    if (_page6BackView) {
//        _page6BackView.frame = CGRectMake(0, UI_NAV_BAR_HEIGHT, WIDTH, _page6BackView.height);
        self.tabBarController.tabBar.hidden = YES;
    }

}
-(void)judgePushFromWhich
{
    if ([_fromWhich isEqualToString:_SYSPAGETITTLE1_]) {
        _barTitleLabel.text = _SYSPAGETITTLE1_;
        [self deploySysPage1UI];
        
    }else if ([_fromWhich isEqualToString:_SYSPAGETITTLE2_])
    {
        _barTitleLabel.text = _SYSPAGETITTLE2_;
        [self deploySysPage2UI];
    }
    else if ([_fromWhich isEqualToString:_SYSPAGETITTLE3_])
    {
     //   _barTitleLabel.text = _SYSPAGETITTLE3_;
    }
    else if ([_fromWhich isEqualToString:_SYSPAGETITTLE4_])
    {
        _barTitleLabel.text = _SYSPAGETITTLE4_;
        [self deploySysPage4UI];
    }
    else if ([_fromWhich isEqualToString:_SYSPAGETITTLE5_])
    {
     //   _barTitleLabel.text = _SYSPAGETITTLE5_;
    }
    else if ([_fromWhich isEqualToString:_SYSPAGETITTLE6_])
    {
        _barTitleLabel.text = _SYSPAGETITTLE6_;
        [self deploySysPage6UI];
    }
    else if ([_fromWhich isEqualToString:_SYSPAGETITILE7_])
    {
        _barTitleLabel.text = _SYSPAGETITILE7_;
        [self deploySysPage7UI];
    }
}
-(void)initData
{
    [[NSUserDefaults standardUserDefaults]setValue:@"false" forKey:@"noticeMore"];
}
//layout
-(void)deploySysPage1UI
{
    _page1BackView.hidden         = NO;
    _confirmPasswordBt.backgroundColor = GetColor(clearColor);
    _modifyPasswordToTop.constant = _SCREEN_HEIGHT_/5;
}
-(void)deploySysPage2UI
{
    
    _page2BackView.hidden         = NO;
    _bundleNumTf.text = [[SystemConfig shareSystemConfig]getUserName];
    _bundlePasswordTf.text = [[SystemConfig shareSystemConfig]getUserPassword];
    _bundlePasswordTf.secureTextEntry = YES;
    _bundleConfirmBt.titleLabel.font = GetFont(14);
    _modifyBundlenumTotop.constant = _SCREEN_HEIGHT_/5;
    [self checkDevice];
}
-(void)deploySysPage3UI
{
    //empty
}
-(void)deploySysPage4UI
{
    _page4BackView.hidden         = NO;
    _noticeTableView.delegate     = self;
    _noticeTableView.dataSource   = self;
    if ([_fromType isEqualToString:@"present"]) {
        _noticeTableToBottom.constant = 0;
    }
    
    [self footerRefresh];
    [self headerRefresh];
}

#pragma mark about notice
#pragma mark ***************************************************
#pragma mark refresh and load

- (void)headerRefresh
{
    __weak __typeof(self) this = self;
    _noticeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:this refreshingAction:@selector(refreshNoticeHeader)];
    [_noticeTableView.mj_header beginRefreshing];
}
-(void)refreshNoticeHeader
{
    [self connectNoticeDataWith:@"header"];
}
- (void)footerRefresh
{
    __weak __typeof(self) this = self;
    _noticeTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:this refreshingAction:@selector(refreshNoticeFooter)];
}
-(void)refreshNoticeFooter
{
    [self connectNoticeDataWith:@"footer"];
}

#pragma  mark tableview delegate datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _CELL_HEIGHT_;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeCell *noticeCell = [tableView dequeueReusableCellWithIdentifier:@"noticeCell"];
    noticeCell = [[NSBundle mainBundle]loadNibNamed:@"NoticeCell" owner:self options:nil][0];
    noticeCell.subTitleLb.text = [[_dataArray objectAtIndex:indexPath.row]valueForKey:@"noticeContent"];
    if ([[[[_dataArray objectAtIndex:indexPath.row]valueForKey:@"readStatus"] stringValue]isEqualToString:@"0"]) {
        [noticeCell.noticeTitleLb setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0]];
        [noticeCell.subTitleLb setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
        [noticeCell.timeLb setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];

        [noticeCell.noticeTitleLb setTextColor:[UIColor blackColor]];
        [noticeCell.subTitleLb setTextColor:[UIColor blackColor]];
        [noticeCell.timeLb setTextColor:[UIColor blackColor]];
    }else
    {
        [noticeCell.noticeTitleLb setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
    }
    noticeCell.noticeTitleLb.text = [[_dataArray objectAtIndex:indexPath.row]valueForKey:@"noticeTitle"];
    noticeCell.timeLb.text        = [[_dataArray objectAtIndex:indexPath.row]valueForKey:@"publicTime"];
    
    return  noticeCell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  _dataArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    noticeDetailController *noticeDetailView = [[noticeDetailController alloc]init];
    noticeDetailView.reloadNoticeListDelegate = self;
    noticeDetailView.noticeID = [[_dataArray objectAtIndex:indexPath.row]valueForKey:@"noticeId"];
    noticeDetailView.indexPathRowNum = indexPath.row;
    
    if ([_fromType isEqualToString:@"present"]) {
        noticeDetailView.fromType = @"present";
        [self presentViewController:noticeDetailView animated:YES completion:^{
            
        }];
    }
    else
    {
        noticeDetailView.fromType = @"pop";
        [self.navigationController pushViewController:noticeDetailView animated:YES];
    }

}
-(void)reloadListFromHeader
{
    [self headerRefresh];
}
#pragma mark ***************************************************

-(void)deploySysPage5UIx
{
    
}

-(void)deploySysPage6UI
{
    _page6BackView.hidden = NO;
    _aboutSystemTv.text   = @"     侠刻送致力于同城极速配送服务，隶属于北京同行必达科技有限公司，业务范围遍及全国20多个城市，共有3000多名专业全职快递员，并与麦当劳、肯德基、吉野家、沃尔玛等大型连锁企业达成长期战略合作，是国内专业领先的同城配送平台。侠刻送基于移动互联网LBS技术的高科技服务平台，用户可通过微信、手机APP、官方网站等方式在线下单，由就近的配送员接单并完成服务，全程凭密收发、专人直送，闪电配送，确保配送物品极速，安全，准时送达。\n       本软件为侠刻送的快递员端，快递师傅可以通过本软件实时定位，接单，规划路线，查询个人账户，高效完成速递任务。\n\n\n Copyright © 2015 - 2025 北京同行必达科技有限公司 版权所有";
    _VersionNumLb.text = [NSString stringWithFormat:@"%@%@",@"版本号:",_VERSION_NUM_];
//    _page6BackView.frame = CGRectMake(0, UI_NAV_BAR_HEIGHT, WIDTH, _page6BackView.height);
}

-(void)deploySysPage7UI
{
    
    _page7BackView.hidden = NO;
    
    [self connectShareAndInviteData];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![_ordPasswordTf isExclusiveTouch]) {
        [_ordPasswordTf resignFirstResponder];
    }
    if (![_wantPasswordTf isExclusiveTouch]) {
        [_wantPasswordTf resignFirstResponder];
    }
    if (![_confirmPasswordTf isExclusiveTouch]) {
        [_confirmPasswordTf resignFirstResponder];
    }
    if (![_bundleNumTf isExclusiveTouch]) {
        [_bundleNumTf resignFirstResponder];
    }
    if (![_bundlePasswordTf isExclusiveTouch]) {
        [_bundlePasswordTf resignFirstResponder];
    }

}

- (IBAction)barReturnBtClicked:(id)sender {
    if ([_fromType isEqualToString:@"present"]) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];

    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)servicePhoneNum:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"拨打客服号码咨询" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    [alert show];
}
#pragma mark alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == changeSuccess) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else
    {
    if (buttonIndex  == 0) {
        NSURL *servicePhoneNumberUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[[SystemConfig shareSystemConfig]getServiceNumber]]];
        [[UIApplication sharedApplication]openURL:servicePhoneNumberUrl];
    }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark network


- (IBAction)confirmNewPassword:(UIButton *)sender {
    if ([_ordPasswordTf.text isEqualToString:@""]) {
        ALERT_VIEW(@"请输入您的旧密码!");
    }
    else if ([_wantPasswordTf.text isEqualToString:@""])
    {
        ALERT_VIEW(@"请输入您要设定的新密码!");
    }
    else if ([_confirmPasswordTf.text isEqualToString:@""])
    {
        ALERT_VIEW(@"请再次输入新密码!");
    }
    else if (![_wantPasswordTf.text isEqualToString:_confirmPasswordTf.text])
    
    {
        ALERT_VIEW(@"两次输入的新密码不一致!");
    }
    else if ([_wantPasswordTf.text length]<6 || [_wantPasswordTf.text length]>12)
    {
        ALERT_VIEW(@"请输入6-12位新密码!");
    }
    else
    {
        [NetWorkTool postToChangePasswordParam:@{@"oldp":_ordPasswordTf.text,@"newp":_wantPasswordTf.text,@"nowDate":[NSString stringWithFormat:@"%@",[NSDate date]]} addProgressHudOn:self.view successReturn:^(id successReturn)
        {
            
            if ([successReturn isEqualToString:@"null"]) {
                ALERT_VIEW(@"服务出错，请重新尝试");
            }
            else
            {
                if ([successReturn isEqualToString:@"1"]) {
                    
                    [[SystemConfig shareSystemConfig]saveUserPassword:_wantPasswordTf.text];
                    UIAlertView *changePassAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"修改密码成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    changePassAlert.tag = changeSuccess;
                    [changePassAlert show];
                }else{
                    ALERT_VIEW(@"旧密码错误，请重新确认");
                }
            }
        } failed:^(id failed) {
            NSLog(@"changepasswordfailed: %@",[failed description]);
        }];
    }
    
}

-(void)checkDevice
{
    
    [NetWorkTool getRequestWithUrl:__checkDevice param:@{@"nowDate":[NSString stringWithFormat:@"%@",[NSDate date]],@"imei":[[SystemConfig shareSystemConfig]getDeviceToken]} addProgressHudOn:self.view Tip:@"核查" successReturn:^(id successReturn) {
        
        NSDictionary *jsonDict = [[NSDictionary alloc]init];
        jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"msg%@",jsonDict[@"msg"]);
        if ([[jsonDict valueForKey:@"result"]isEqualToString:@"false"]) {
            [_bundleConfirmBt setBackgroundColor:[UIColor clearColor]];
            [_bundleConfirmBt setTitle:[jsonDict objectForKey:@"msg"] forState:UIControlStateNormal];
            _bundleConfirmBt.userInteractionEnabled = YES;
        }
        else if ([[jsonDict valueForKey:@"result"]isEqualToString:@"true"])
        {
            _bundleConfirmBt.userInteractionEnabled = NO;
            [_bundleConfirmBt setBackgroundColor:[UIColor clearColor]];
            [_bundleConfirmBt setTitleColor:LIGHT_WHITE_COLOR forState:UIControlStateNormal];
            [_bundleConfirmBt setTitle:@"设备已绑定" forState:UIControlStateNormal];
        }
                
    } failed:^(id failed) {
        
    }];
}

- (IBAction)bundleConfirmBtClicked:(UIButton *)sender {
    
    
    [NetWorkTool getToBundleDeviceWithParam:@{@"n":_bundleNumTf.text,@"p":_bundlePasswordTf.text,} addProgressHudOn:self.view successReturn:^(id successReturn) {
        if ([successReturn[0]isEqualToString:@"true"]) {
            ALERT_VIEW(successReturn[1]);
        }else
        {
            
            [_bundleConfirmBt setTitle:successReturn[1] forState:UIControlStateNormal];
            _bundleConfirmBt.userInteractionEnabled = NO;
            ALERT_VIEW(successReturn[1]);
 
        }

    } failed:^(id failed) {
        
    }];
}
-(void)connectNoticeDataWith:(NSString *)header
{
    
    if ([header isEqualToString:@"header"]) {
        noticePageNumber = 1;
    }
    NSDictionary *dict = [[NSDictionary alloc]init];
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"noticeMore"]isEqualToString:@"false"]) {
        //false
        [NetWorkTool getNoticeDataAddProgressHudOn:self.view Tip:@"获取通知列表" successReturn:^(id successReturn) {
            NSDictionary *jsonDict = [[NSDictionary alloc]init];
            jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//            NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

            noticePageNumber ++;
                        
            if ([[jsonDict valueForKey:@"result"]isEqualToString:@"true"])
            {
                if ([[[jsonDict valueForKey:@"noticeInfos"]class]isSubclassOfClass:[NSString class]]) {
                    _dataArray = @[];
                    
                }else
                {
                    _dataArray =[jsonDict valueForKey:@"noticeInfos"];
                }
                [[SystemConfig shareSystemConfig]saveNoticeInfo:[jsonDict valueForKey:@"noticeInfos"]];

                if ([[jsonDict valueForKey:@"more"]isEqualToString:@"false"])
                {
                    [[NSUserDefaults standardUserDefaults]setValue:@"false" forKey:@"noticeMore"];
                    [_noticeTableView.mj_footer endRefreshingWithNoMoreData];
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults]setValue:@"true" forKey:@"noticeMore"];
                    [_noticeTableView.mj_footer endRefreshing];
                }
                [_noticeTableView reloadData];
                [_noticeTableView.mj_header endRefreshing];
                if ([[[jsonDict valueForKey:@"noticeInfos"]class]isSubclassOfClass:[NSString class]]) {
                    
                }else
                {
                    if (_dataArray.count > 5) {
                        [_noticeTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    }
                }
            }
            else
            {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.removeFromSuperViewOnHide =YES;
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [jsonDict valueForKey:@"msg"];
                hud.minSize = CGSizeMake(108.f, 108.0f);
                [hud hide:YES afterDelay:HudDelayTime*0.2];
                [_noticeTableView.mj_header endRefreshing];
            }
        } failed:^(id failed) {
        }];
        
    }else if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"noticeMore"]isEqualToString:@"true"])
    {
        dict = @{@"noticeType":@"",@"pageNo":[NSString stringWithFormat:@"%ld",(long)noticePageNumber],@"newTime":[NSString stringWithFormat:@"%@",[NSDate date]]};
        [NetWorkTool getRequestWithUrl:__noticeData param:dict addProgressHudOn:self.view
                                   Tip:@"获取通知列表" successReturn:^(id successReturn) {
                                       NSDictionary *jsonDict = [[NSDictionary alloc]init];
                                       jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//                                      jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

                                       noticePageNumber ++;
                                       
                                       if ([jsonDict isEqualToDictionary:@{}]) {
                                           _dataArray = @[];
                                       }
                                       
                                       if ([[jsonDict valueForKey:@"result"]isEqualToString:@"true"])
                                       {
                                           _dataArray =[jsonDict valueForKey:@"noticeInfos"];
                                           [[SystemConfig shareSystemConfig]saveNoticeInfo:[jsonDict valueForKey:@"noticeInfos"]];

                                           [_noticeTableView reloadData];
                                           [_noticeTableView.mj_header endRefreshing];

                                       }else
                                       {
                                           MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                           hud.removeFromSuperViewOnHide =YES;
                                           hud.mode = MBProgressHUDModeText;
                                           hud.labelText = [jsonDict valueForKey:@"msg"];
                                           hud.minSize = CGSizeMake(108.f, 108.0f);
                                           [hud hide:YES afterDelay:HudDelayTime*0.2];
                                           [_noticeTableView.mj_header endRefreshing];
                                       }
                                       
                                       if ([[jsonDict valueForKey:@"more"]isEqualToString:@"false"]) {
                                           [[NSUserDefaults standardUserDefaults]setValue:@"false" forKey:@"noticeMore"];
                                           [_noticeTableView.mj_footer endRefreshingWithNoMoreData];
                                       }
                                       else
                                       {
                                           [[NSUserDefaults standardUserDefaults]setValue:@"true" forKey:@"noticeMore"];
                                           [_noticeTableView.mj_footer endRefreshing];
                                       }
                                       
                                       if (_dataArray.count > 1) {
                                           [_noticeTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                                       }
                                       
                                   } failed:^(id failed) {
                                       
                                   }];
    }
}

-(void)connectShareAndInviteData
{
    [NetWorkTool getRequestWithUrl:__shareAndInvite param:@{@"nowDate":[NSString stringWithFormat:@"%@",[NSDate date]]} addProgressHudOn:self.view Tip:@"获取信息" successReturn:^(id successReturn) {
        
    NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

//        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil];
        
        _shareDetail = jsonDict;
        
        _inviteCodeLb.text         = [[jsonDict valueForKey:@"msg"]valueForKey:@"cardCode"];
        _invitePersonNumLb.text    = [[jsonDict valueForKey:@"msg"]valueForKey:@"inCount"];
        _inviteAwardMoneyLb.text   = [[[jsonDict valueForKey:@"msg"]valueForKey:@"reward"]stringValue];
        _awardPricipleTv.text      = [[[jsonDict valueForKey:@"msg"]valueForKey:@"rewardRule"]stringByReplacingOccurrencesOfString:@"#$" withString:@"\n\n"];
        _activityRule = [[[jsonDict valueForKey:@"msg"]valueForKey:@"activityRule"]stringByReplacingOccurrencesOfString:@"#$" withString:@"\n\n"];
        
        
    } failed:^(id failed) {
        
    }];
}

- (IBAction)checkEventDetailBtCikcked:(UIButton *)sender {
    textBoardView *textInstruction = [[textBoardView alloc]init];
    textInstruction.textContent = _activityRule;
    textInstruction.barTitleString = @"活动说明";
    [self.navigationController pushViewController:textInstruction animated:NO];
    
}

- (IBAction)shareToTimeLine:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [[_shareDetail valueForKey:@"msg"]valueForKey:@"linkUrl"];
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:[[_shareDetail valueForKey:@"msg"]valueForKey:@"title"] image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[_shareDetail valueForKey:@"msg"]valueForKey:@"shareImg"]]]] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        sender.userInteractionEnabled = YES;
        if (response.responseCode == UMSResponseCodeSuccess) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
        }
    }];
}

- (IBAction)shareToWeChant:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = [[_shareDetail valueForKey:@"msg"]valueForKey:@"title"];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [[_shareDetail valueForKey:@"msg"]valueForKey:@"linkUrl"];

    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:[[_shareDetail valueForKey:@"msg"]valueForKey:@"shareContent"] image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[_shareDetail valueForKey:@"msg"]valueForKey:@"shareImg"]]]] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        sender.userInteractionEnabled = YES;
        if (response.responseCode == UMSResponseCodeSuccess) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
        }
    }];

}

- (IBAction)shareToSinaBlog:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
/*
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        NSLog(@"response is %@",response);
    }];
*/
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSina] content:[[_shareDetail valueForKey:@"msg"]valueForKey:@"shareContent"] image:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[_shareDetail valueForKey:@"msg"]valueForKey:@"shareImg"]]] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        sender.userInteractionEnabled = YES;
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
        }
    }];
}

- (IBAction)shareToQQ:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    //mac电脑只能接到纯文字完整内容
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQQ] content:[[_shareDetail valueForKey:@"msg"]valueForKey:@"shareContent"] image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        sender.userInteractionEnabled  = YES;
        if (response.responseCode == UMSResponseCodeSuccess) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
        }
    }];
}

- (IBAction)shareToMessage:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSms] content:[[_shareDetail valueForKey:@"msg"]valueForKey:@"shareContent"] image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        sender.userInteractionEnabled = YES;
        if (response.responseCode == UMSResponseCodeSuccess) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
        }
    }];

}






@end
