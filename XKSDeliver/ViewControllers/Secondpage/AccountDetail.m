//
//  AccountDetail.m
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/20.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import "AccountDetail.h"
#import "AccountDetailCell.h"
#import "NetWorkTool.h"
#import "MJRefresh.h"
#import "historyOrderDetailViewController.h"

NSString *AccountDetailType = @"1";
NSInteger pageNum = 1;



@interface AccountDetail ()<UIAlertViewDelegate>

@end

@implementation AccountDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    [self deployAccountDetailUI];
    [self headerRefresh];
}

-(void)viewWillDisappear:(BOOL)animated
{
    AccountDetailType  = @"1";
}

-(void)deployAccountDetailUI
{
    _accountDetailTableView.delegate   = self;
    _accountDetailTableView.dataSource = self;
    _accountTimeLb.text                = _whichMonth;
    
}
#pragma mark refresh and load
- (void)headerRefresh
{
    __weak __typeof(self) this = self;
    _accountDetailTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:this refreshingAction:@selector(refreshFromHeader)];
    [_accountDetailTableView.mj_header beginRefreshing];
}
-(void)refreshFromHeader
{
    [self connectAccountDetailData];
}

#pragma  mark tableview delegate datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _CELL_HEIGHT_;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountDetailCell *accountDetailCell = [tableView dequeueReusableCellWithIdentifier:@"accoutCell"];
    accountDetailCell = [[NSBundle mainBundle]loadNibNamed:@"AccountDetailCell" owner:self options:nil][0];
    accountDetailCell.moneyDetailLb.text = [NSString stringWithFormat:@"￥%@",[[_dataSource objectAtIndex:indexPath.row]valueForKey:@"money"]];
    
    if ([AccountDetailType isEqualToString:@"1"]) {
        accountDetailCell.moneyDetailLb.textColor = _TEXT_GREEN_;
    }else{
        accountDetailCell.moneyDetailLb.textColor = _TEXT_RED_;
    }
    
    accountDetailCell.timeLb.text = [NSString stringWithFormat:@"%@ %@",[[_dataSource objectAtIndex:indexPath.row]valueForKey:@"date"],[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"exchangeReason"]];
    
    NSString *stateString = nil;
    if ([AccountDetailType isEqualToString:@"1"]) {
        stateString =[[[_dataSource objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"1"]?@"充值":@"订单提成";
        
    }else if ([AccountDetailType isEqualToString:@"0"])
    {
       stateString =[[[_dataSource objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"4"]?@"订单扣款":@"提款";
    }
    
    accountDetailCell.handleStateLb.text = stateString;
    
    return  accountDetailCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _dataSource.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    historyOrderDetailViewController *orderDetailView = [[historyOrderDetailViewController alloc]init];
    orderDetailView.fromWhich = @"AccountDetail";
    orderDetailView.orderNumber = [[_dataSource objectAtIndex:indexPath.row]valueForKey:@"orderId"];
    
    if ([AccountDetailType isEqualToString:@"1"]) {
        if ([[[_dataSource objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"1"]) {
        }else
        {
            [self.navigationController pushViewController:orderDetailView animated:YES];
        }
    }
    else if ([AccountDetailType isEqualToString:@"0"])
    {
       // [self.navigationController pushViewController:orderDetailView animated:YES];
    }

}

#pragma mark
- (IBAction)servicePhoneNum:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"拨打客服号码咨询" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    [alert show];
}

- (IBAction)barReturnBtClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex  == 0) {
        NSURL *servicePhoneNumberUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[[SystemConfig shareSystemConfig]getServiceNumber]]];
        [[UIApplication sharedApplication]openURL:servicePhoneNumberUrl];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark segment
- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    if ([sender selectedSegmentIndex]==0) {
        AccountDetailType = @"1";
        [self headerRefresh];
    }else if ([sender selectedSegmentIndex]==1)
    {
        AccountDetailType = @"0";
        [self headerRefresh];
    }
}

#pragma mark network
-(void)connectAccountDetailData
{
    NSString *startDate = [_whichMonth stringByAppendingString:@"-01"];
    NSString *endDate   = [_whichMonth stringByAppendingString:@"-31"];
    
    [NetWorkTool getRequestWithUrl:__accountDetailInfo param:@{@"exchangeType":AccountDetailType,@"startDate":startDate,@"endDate":endDate,@"pageNo":[NSString stringWithFormat:@"%ld",(long)pageNum],} addProgressHudOn:self.view Tip:@"加载用户明细" successReturn:^(id successReturn){
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        _dataSource = [jsonDict valueForKey:@"infos"];
        if (_dataSource.count == 0) {
            //无记录
            [_accountDetailTableView.mj_header endRefreshing];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.removeFromSuperViewOnHide =YES;
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"暂无交易记录";
            hud.minSize = CGSizeMake(108.f, 108.0f);
            [hud hide:YES afterDelay:HudDelayTime*0.3];
            [_accountDetailTableView reloadData];
        }
        else
        {
            [_accountDetailTableView reloadData];
            [_accountDetailTableView.mj_header endRefreshing];
        }

    } failed:^(id failed) {
        [_accountDetailTableView.mj_header endRefreshing];
    }];
}


@end
