//
//  AccountViewController.m
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/10.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import "AccountViewController.h"
#import "common.h"
#import "AccountFirstCell.h"
#import "AccountCell.h"
#import "AccountDetail.h"
#import "withDrawViewController.h"
#import "NetWorkTool.h"
#import "MJRefresh.h"
#import "SignDateResultVc.h"
#import "UserInfoVc.h"
#import "SalaryDetailViewController.h"
#import "ActViewController.h"
@interface AccountViewController ()<UIAlertViewDelegate>
{
    UIButton *salaryDetailBtn;
}
@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self headerRefresh];

}

-(void)viewDidAppear:(BOOL)animated
{
    
}

-(void)deployUIDeliverType13
{
    
    _emptyBackView.hidden  = NO;
    _emptyTipTv.text       = [NSString stringWithFormat:@"%@\n您好,您为我司驻店员工,工资定期结发,祝您工作愉快!\n工作过程中务必多多注意安全!!!",[[_dataSource valueForKey:@"account"]valueForKey:@"name"]];
    _userNameLb.text = [[_dataSource valueForKey:@"account"]valueForKey:@"name"];
    _signBt.hidden = NO;

//    _emptyBackView.hidden  = NO;
//    _emptyTipTv.text       = [NSString stringWithFormat:@"%@\n您好,您为我司驻店员工,工资定期结发,祝您工作愉快!\n工作过程中务必多多注意安全!!!",[[_dataSource valueForKey:@"account"]valueForKey:@"name"]];
//    _userNameLb.text = [[_dataSource valueForKey:@"account"]valueForKey:@"name"];
//    
//    salaryDetailBtn = CUSTOMBUTTON;
//    salaryDetailBtn.frame = CGRectMake(12, _signBt.bottom+12, WIDTH-24, 44);
//    salaryDetailBtn.backgroundColor = Blue_Color;
//    salaryDetailBtn.hidden = YES;
//    salaryDetailBtn.layer.cornerRadius = 3;
//    [salaryDetailBtn setTitle:@"账单明细" forState:UIControlStateNormal];
//    salaryDetailBtn.titleLabel.textColor = DarkTextColor;
//    [[salaryDetailBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
//        NSLog(@"查看账单明细");
////        SalaryDetailViewController *salaryVC = [[SalaryDetailViewController alloc]init];
////        [self.navigationController pushViewController:salaryVC animated:YES];
//    }];
//    [_emptyBackView addSubview:salaryDetailBtn];
//    
//    _emptyTipTv.top = salaryDetailBtn.bottom+12;
    
}
#pragma mark footer and header Refresh
- (void)headerRefresh
{
    __weak __typeof(self) this = self;
    _accountTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:this refreshingAction:@selector(accountRefreshFromHeader)];
    [_accountTableView.mj_header beginRefreshing];
}
-(void)accountRefreshFromHeader
{
    [self connectAccontData];
}
- (void)footerRefresh
{
    __weak __typeof(self) this = self;
    _accountTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:this refreshingAction:@selector(accountRefreshFromFooter)];
}
-(void)accountRefreshFromFooter
{
    [self connectAccontData];
}


#pragma mark network

-(void)connectAccontData
{
    __weak typeof(self) this = self;
    
    [NetWorkTool getRequestWithUrl:__accountInfo param:nil addProgressHudOn:self.view Tip:@"获取用户信息" successReturn:^(id successReturn) {
        
    NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    
    _dataSource = jsonDict;
    // 快递员类型判断  getDeliverType
    if ([[[jsonDict valueForKey:@"account"]valueForKey:@"fullTimeWork"]isEqualToString:@"0"]||[[[jsonDict valueForKey:@"account"]valueForKey:@"fullTimeWork"]isEqualToString:@"2"])
    {
        
        [this deployLayout];
        [_accountTableView reloadData];
        
    }
    else
    {
        [this deployUIDeliverType13];
    }        
//    //isSignRecord
//    if (!([[[jsonDict valueForKey:@"account"]valueForKey:@"isSignRecord"] isEqualToString:@"Y"])) {//没有签到功能
//        [this deployLayout];
//        [_accountTableView reloadData];
//    }
//    //驻点员工，有查看工资明细的功能
//    if ([[[jsonDict valueForKey:@"account"]valueForKey:@"fullTimeWork"]isEqualToString:@"3"])
//    {
//        [this deployUIDeliverType13];
//    }
        
    [_accountTableView.mj_header endRefreshing];
    [_accountTableView.mj_footer endRefreshing];
    
    } failed:^(id failed) {
    [_accountTableView.mj_header endRefreshing];
    [_accountTableView.mj_footer endRefreshing];
}];
    
}

-(void)deployLayout
{
    _userNameLb.text = [[_dataSource valueForKey:@"account"]valueForKey:@"name"];
    __weak typeof(self) this = self;
    _signBt.hidden = YES;
    _userInfoBtTrailingConstriants.constant = -_SCREEN_WIDTH_;
    _emptyBackView.hidden = YES;
    _accountTableView.hidden = NO;
    _accountTableView.delegate   = this;
    _accountTableView.dataSource = this;
}

#pragma mark tableview  delegate datesource  

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        AccountFirstCell *firstCell = [tableView dequeueReusableCellWithIdentifier:@"accountFirstCell"];
        firstCell = [[NSBundle mainBundle]loadNibNamed:@"AccountFirstCell" owner:self options:nil][0];
        
        
        firstCell.accountBalanceNumLb.text = [NSString stringWithFormat:@"%@",[[_dataSource objectForKey:@"account"]objectForKey:@"balance"]];
        firstCell.accountBalanceNumLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        
        firstCell.xiaKeScoreNumLb.text = [NSString stringWithFormat:@"%@",[[_dataSource objectForKey:@"account"]objectForKey:@"xkzAccount"]];
        
        firstCell.xiaKeScoreNumLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        
        
        [firstCell.accountBalanceBt addTarget:self action:@selector(checkAccountBalace:) forControlEvents:UIControlEventTouchUpInside];
        firstCell.accountBalanceBt.tag = 11;
        [firstCell.xiaKeScoreBt addTarget:self action:@selector(checkAccountBalace:) forControlEvents:UIControlEventTouchUpInside];
        firstCell.xiaKeScoreBt.tag     = 22;
        
        
        return firstCell;
    }
    else
    {
        AccountCell *accountCell = [tableView dequeueReusableCellWithIdentifier:@"accoutCell"];
        accountCell = [[NSBundle mainBundle]loadNibNamed:@"AccountCell" owner:self options:nil][0];
        
        accountCell.timeLabel.text = [[[_dataSource objectForKey:@"infos"]objectAtIndex:indexPath.row-1]valueForKey:@"yearMonth"];
        
        NSString *totolString1 = [NSString stringWithFormat:@"收入: %.1f",[[[[_dataSource objectForKey:@"infos"]objectAtIndex:indexPath.row-1]valueForKey:@"income"]floatValue]];
        NSMutableAttributedString *attributeString1 = [[NSMutableAttributedString alloc]initWithString:totolString1];
        NSString *firstPart1 = @"收入: ";
        NSString *secondPart1 = [NSString stringWithFormat:@"%.1f",[[[[_dataSource objectForKey:@"infos"]objectAtIndex:indexPath.row-1]valueForKey:@"income"]floatValue]];
        NSRange range = NSMakeRange(0, [firstPart1 length]);
        NSDictionary *attributeDict = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]};
        [attributeString1 addAttributes:attributeDict range:range];
        attributeDict =  @{NSForegroundColorAttributeName:[UIColor colorWithRed:79/255.0 green:150/255.0 blue:21/255.0 alpha:1],NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:17.0]};
        range = NSMakeRange([firstPart1 length], [secondPart1 length]);
        [attributeString1 addAttributes:attributeDict range:range];
        
        accountCell.incomeLabel.attributedText = attributeString1;
                 
        NSString *totalString2 = [NSString stringWithFormat:@"支出: %.1f",[[[[_dataSource objectForKey:@"infos"]objectAtIndex:indexPath.row-1]valueForKey:@"expense"]floatValue]];
        NSMutableAttributedString *attribteString2 = [[NSMutableAttributedString alloc]initWithString:totalString2];
        NSString *firstPart2 = @"支出: ";
        NSString *secondPart2 = [NSString stringWithFormat:@"%.1f",[[[[_dataSource objectForKey:@"infos"]objectAtIndex:indexPath.row-1]valueForKey:@"expense"]floatValue]];
        range = NSMakeRange(0, [firstPart2 length]);
        attributeDict = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]};
        [attribteString2 addAttributes:attributeDict range:range];
        range = NSMakeRange([firstPart2 length], [secondPart2 length]);
        attributeDict = @{NSForegroundColorAttributeName:[UIColor colorWithRed:150/255.0 green:34/255.0 blue:0/255.0 alpha:1],NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]};
        [attribteString2 addAttributes:attributeDict range:range];
        
        accountCell.withDrawMoneyNumLabel.attributedText = attribteString2;
        
        return accountCell;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return _CELL_HEIGHT_+10;
    }
    
    return  _CELL_HEIGHT_;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *accountListArray = [_dataSource valueForKey:@"infos"];
    return accountListArray.count+1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountDetail *accountDetail = [[AccountDetail alloc]init];
    if (indexPath.row == 0) {
        withDrawViewController *withDrawView = [[withDrawViewController alloc]init];
    
        [self.navigationController pushViewController:withDrawView animated:NO];
    }
    else
    {
        accountDetail.whichMonth = [[[_dataSource valueForKey:@"infos"]objectAtIndex:indexPath.row-1]valueForKey:@"yearMonth"];
        [self.navigationController pushViewController:accountDetail animated:YES];
    }
}


-(void)checkAccountBalace:(UIButton *)sender
{
    
    withDrawViewController *withDrawView = [[withDrawViewController  alloc]init];
    
    if (sender.tag == 11) {
        withDrawView.dataType = @"withdrawData";
    }
    else if(sender.tag == 22)
    {
        withDrawView.dataType = @"xiakezhi";
    }
    [self.navigationController pushViewController:withDrawView animated:YES];
}


#pragma mark 
- (IBAction)servicePhoneNum:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"拨打客服号码咨询" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    
    
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex  == 0) {
        NSURL *servicePhoneNumberUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[[SystemConfig shareSystemConfig]getServiceNumber]]];
        [[UIApplication sharedApplication]openURL:servicePhoneNumberUrl];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)checkUserInfomation:(UIButton *)sender {
    
    UserInfoVc *userInfoView = [[UserInfoVc alloc]init];
    [self.navigationController pushViewController:userInfoView animated:YES];
}

- (IBAction)checkSignDateResult:(UIButton *)sender {
    
    SignDateResultVc *signResultView = [[SignDateResultVc alloc]init];
    signResultView.fromWhich = @"account";
    [self.navigationController pushViewController:signResultView animated:YES];
    
}


@end
