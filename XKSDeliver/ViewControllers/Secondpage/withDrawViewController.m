//
//  withDrawViewController.m
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/20.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import "withDrawViewController.h"
#import "common.h"
#import "WithDrawListCell.h"
#import "WithDrawMoneyController.h"
#import "NetWorkTool.h"
#import "MJRefresh.h"
#import "textBoardView.h"

NSInteger pageNo = 1;



@interface withDrawViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>

@end

@implementation withDrawViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self deployUI];
}
-(void)viewDidAppear:(BOOL)animated
{
    //_dataType = @"withdrawData";
   // _dataTypeChangeControl.selectedSegmentIndex = 0;
    
    if ([_dataType isEqualToString:@"withdrawData"]) {
        _dataTypeChangeControl.selectedSegmentIndex = 0;
        [_withDrawBt setTitle:@"提现" forState:UIControlStateNormal];

    }else if ([_dataType isEqualToString:@"xiakezhi"])
    {
        _dataTypeChangeControl.selectedSegmentIndex = 1;
         [_withDrawBt setTitle:@"侠刻值规则" forState:UIControlStateNormal];

    }
    
    [self headerRefresh];
    [self footerRefresh];
}
-(void)deployUI
{
    _withDrawListTableView.delegate = self;
    _withDrawListTableView.dataSource = self;
    _withDrawBt.layer.cornerRadius = 4;
    _withDrawBt.userInteractionEnabled = YES;
}

#pragma mark refresh and load
- (void)headerRefresh
{
    __weak __typeof(self) this = self;
    _withDrawListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:this refreshingAction:@selector(refreshFromHeader)];
    [_withDrawListTableView.mj_header beginRefreshing];
}
- (void)footerRefresh
{
    __weak __typeof(self) this = self;
    _withDrawListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:this refreshingAction:@selector(refreshFromFooter)];
}

-(void)refreshFromHeader
{
    if ([_dataType isEqualToString:@"withdrawData"]) {
        
        [self connectToWithDrawHistoryListDataFromHeader:YES];

    }
    else if ([_dataType isEqualToString:@"xiakezhi"])
    {
        [self connectToXiaKeScoreDataFromHeader:YES];
    }
    
}
-(void)refreshFromFooter
{
    if ([_dataType isEqualToString:@"withdrawData"]) {
        
        [self connectToWithDrawHistoryListDataFromHeader:NO];
    }
    else if ([_dataType isEqualToString:@"xiakezhi"])
    {
        [self connectToXiaKeScoreDataFromHeader:NO];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma  mark tableview delegate datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _CELL_HEIGHT_-20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WithDrawListCell *withDrawListCell = [tableView dequeueReusableCellWithIdentifier:@"withDrawList"];
    withDrawListCell = [[NSBundle mainBundle]loadNibNamed:@"WithDrawListCell" owner:self options:nil][0];
    
    if ([_dataType isEqualToString:@"withdrawData"]) {
        withDrawListCell.moneyLb.text = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"exchangeMoney"];
        withDrawListCell.timeLb.text = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"exchangeTime"];
        withDrawListCell.reasonLb.text = @"";
    }
    else if ([_dataType isEqualToString:@"xiakezhi"])
    {
        withDrawListCell.moneyLb.text = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"exchangeXkz"];
        withDrawListCell.timeLb.text = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"exchangeTime"];
        withDrawListCell.reasonLb.text = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"exchangeRea"];
    }
    
    
    return  withDrawListCell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _dataSource.count;
}
- (IBAction)listControlCLicked:(UISegmentedControl *)sender {
    
    if ([sender selectedSegmentIndex]==0) {
        _dataType = @"withdrawData";
        _tableViewTitleLb.text = @"交易明细";
        [_withDrawBt setTitle:@"提现" forState:UIControlStateNormal];
        [self refreshFromHeader];
    }
    else if ([sender selectedSegmentIndex] == 1)
    {
        _dataType = @"xiakezhi";
        _tableViewTitleLb.text = @"侠刻值明细";
        [_withDrawBt setTitle:@"侠刻值规则" forState:UIControlStateNormal];
        [self refreshFromHeader];
    }
}

- (IBAction)returnBtClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)servicePhoneNum:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"拨打客服号码咨询" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    [alert show];
}

- (IBAction)toWithDrawMoneyBtClicked:(UIButton *)sender {
    
    if ([_dataType isEqualToString:@"withdrawData"]) {
        WithDrawMoneyController *withDrawMoneyView = [[WithDrawMoneyController alloc]init];
        [self.navigationController pushViewController:withDrawMoneyView animated:YES];
    }
    else if ([_dataType isEqualToString:@"xiakezhi"])
    {
        textBoardView *textBoard = [[textBoardView alloc]init];
        textBoard.barTitleString = @"xiakezhiguize";
        [self.navigationController pushViewController:textBoard animated:YES];
    }
}

#pragma mark alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex  == 0) {
        NSURL *servicePhoneNumberUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[[SystemConfig shareSystemConfig]getServiceNumber]]];
        [[UIApplication sharedApplication]openURL:servicePhoneNumberUrl];
    }
}
#pragma mark network
-(void)connectToWithDrawHistoryListDataFromHeader:(BOOL)header
{
    if (header == YES) {
        pageNo = 1;
    }
    [NetWorkTool getRequestWithUrl:__withDrawHistoryRecord param:@{@"detailOrApplyMark":@"0",@"pageNo":[NSString stringWithFormat:@"%ld",(long)pageNo],} addProgressHudOn:self.view Tip:@"获取提现记录" successReturn:^(id successReturn) {
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];
        _balanceLb.text =   [NSString stringWithFormat:@"￥%.2f",[[jsonDict valueForKey:@"account"]floatValue]];
        _dataSource = [jsonDict valueForKey:@"infos"];

        
        if ([[jsonDict valueForKey:@"accountException"]isEqualToString:@"0"]) {
            
        }else if ([[jsonDict valueForKey:@"accountException"]isEqualToString:@"1"])
        {
            _withDrawBt.backgroundColor = [UIColor grayColor];
            _withDrawBt.userInteractionEnabled = NO;
            ALERT_VIEW([jsonDict valueForKey:@"exceptionPhone"]);
        }
        
        if (_dataSource.count == 0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.removeFromSuperViewOnHide =YES;
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"暂无提现记录";
            hud.minSize = CGSizeMake(108.f, 108.0f);
            [hud hide:YES afterDelay:HudDelayTime*0.3];
            [_withDrawListTableView reloadData];
            [_withDrawListTableView.mj_header endRefreshing];

        }else
        {
            if ([[[jsonDict valueForKey:@"totalPage"]stringValue]isEqualToString:[NSString stringWithFormat:@"%ld",(long)pageNo]]) {
                [_withDrawListTableView.mj_footer endRefreshingWithNoMoreData];
            }else
            {
                [_withDrawListTableView.mj_footer endRefreshing];
            }
            pageNo ++;
            [_withDrawListTableView reloadData];
            [_withDrawListTableView.mj_header endRefreshing];
            
            if (_dataSource.count > 5) {
                [_withDrawListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            
        }
        
    } failed:^(id failed) {
        [_withDrawListTableView.mj_header endRefreshing];
    }];
}

-(void)connectToXiaKeScoreDataFromHeader:(BOOL)header
{
    if (header == YES) {
        pageNo = 1;
    }
    [NetWorkTool getRequestWithUrl:__xiakeScoreRecord param:@{@"imei":[[SystemConfig shareSystemConfig]getDeviceToken],@"pageNo":[NSString stringWithFormat:@"%ld",(long)pageNo],} addProgressHudOn:self.view Tip:@"获取侠刻值记录" successReturn:^(id successReturn) {
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];
        _balanceLb.text = [[jsonDict valueForKey:@"msg"]valueForKey:@"xkzaccount"];
        _dataSource = [[jsonDict valueForKey:@"msg"]valueForKey:@"infos"];
        
        if (_dataSource.count == 0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.removeFromSuperViewOnHide =YES;
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"暂无侠刻值记录";
            hud.minSize = CGSizeMake(108.f, 108.0f);
            [hud hide:YES afterDelay:HudDelayTime*0.3];
            [_withDrawListTableView.mj_header endRefreshing];

        }
        else
        {
            if ([[[[jsonDict valueForKey:@"msg"]valueForKey:@"totalPage"]stringValue]isEqualToString:[NSString stringWithFormat:@"%ld",(long)pageNo]]) {
                [_withDrawListTableView.mj_footer endRefreshingWithNoMoreData];
            }else
            {
                [_withDrawListTableView.mj_footer endRefreshing];

            }
            pageNo ++;
            [_withDrawListTableView reloadData];
            [_withDrawListTableView.mj_header endRefreshing];
            
            if (_dataSource.count > 5) {
                [_withDrawListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
    } failed:^(id failed) {
        [_withDrawListTableView.mj_header endRefreshing];
    }];

    
}



@end
