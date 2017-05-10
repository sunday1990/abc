//
//  ChooseAddressViewController.m
//  sample0128
//
//  Created by 同行必达 on 16/3/2.
//  Copyright © 2016年 同行必达. All rights reserved.
//

#import "ChooseAddressViewController.h"
#import "AddressListCell.h"
#import "AddressListNetdataCell.h"
#import "SystemConfig.h"
#import "NetWorkTool.h"
#import "SalaryGroup.h"
#import "SHSelectPayTypeView.h"
#import "IQKeyboardManager.h"
@interface ChooseAddressViewController ()<BMKPoiSearchDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{

    NSMutableArray *salaryArray;
    NSString *_fullTimeWork;
    NSString *_salaryType;
    NSDictionary *_resultWorkerDic;
}
@end

@implementation ChooseAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self deployUI];
    [self initData];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

-(void)deployUI
{
    _searchTf.delegate = self;
    
    if ([_fromWhich isEqualToString:@"add_help_worker"]) {
        _searchTf.placeholder = @"请填写姓名";
    }else if ([_fromWhich isEqualToString:@"shop_address"])
    {
        _searchTf.placeholder = @"请填写店铺名称";
    }else if ([_fromWhich isEqualToString:@"change_shop"])
    {
        _searchTf.placeholder = @"请输入商家名称";
    }
    
    [_searchTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _addressTableView.frame = CGRectMake(0, UI_NAV_BAR_HEIGHT, WIDTH, HEIGHT-UI_NAV_BAR_HEIGHT);
    _addressTableView.dataSource = self;
    _addressTableView.delegate   = self;
    _addressTableView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
}
-(void)initData
{
    _searchTf.text = _keyWord;
    _addressDataSource = [[NSMutableArray alloc]init];
    
    if ([_fromWhich isEqualToString:@"shop_address"]) {
        
        [self connectShopAddressWith:@""];
        
    }else if ([_fromWhich isEqualToString:@"add_help_worker"])
    {
        salaryArray = [NSMutableArray array];
        [self getData];
        [self connectHelpWorkerWith:@""];
        
    }else if ([_fromWhich isEqualToString:@"change_shop"])
    {
        [self connectShopNameWith:_searchTf.text];
    }
    
    if ([_searchTf.text isEqualToString:@""] || !_searchTf.text) {
        
        [_addressDataSource removeAllObjects];
        
        if ([_fromWhich isEqualToString:@"shop_address"]) {
          
            [_addressDataSource addObjectsFromArray:[[SystemConfig shareSystemConfig]getHistoryShopAddressArray]];
            
        }
        else if ([_fromWhich isEqualToString:@"target_address"])
        {
            [_addressDataSource addObjectsFromArray:[[SystemConfig shareSystemConfig]getHistoryAddressArray]];
        }
        else if ([_fromWhich isEqualToString:@"change_shop"])
        {
            [self connectShopNameWith:_searchTf.text];
        }
//        else if ([_fromWhich isEqualToString:@"add_help_worker"])
//        {
//            [self connectHelpWorkerWith:_searchTf.text];
//        }
        
        [_addressTableView reloadData];
        
        
    }else
    {
        if ([_fromWhich isEqualToString:@"shop_address"]) {
            [self connectShopAddressWith:_searchTf.text];
        }
        else if ([_fromWhich isEqualToString:@"target_address"])
        {
            [self searchAddressWithKeyword:_keyWord];
        }
        else if ([_fromWhich isEqualToString:@"add_help_worker"])
        {
            [self connectHelpWorkerWith:_searchTf.text];
            
        }else if ([_fromWhich isEqualToString:@"change_shop"])
        {
            [self connectShopNameWith:_searchTf.text];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidChange:(id)sender
{
    
    if ([_fromWhich isEqualToString:@"shop_address"]) {
        
        if ([_searchTf.text isEqualToString:@""]||!_searchTf.text) {
            
            [self displayHistoryKeywords];
        }else
        {
            [_addressDataSource removeAllObjects];
            [self connectShopAddressWith:_searchTf.text];
        }
    }
    else if ([_fromWhich isEqualToString:@"target_address"])
    {
        if ([_searchTf.text isEqualToString:@""]||!_searchTf.text)
        {
            [self displayHistoryKeywords];
        }else
        {
            [self searchAddressWithKeyword:_searchTf.text];
        }
    }
    else if ([_fromWhich isEqualToString:@"add_help_worker"])
    {
        [_addressDataSource removeAllObjects];
        [self connectHelpWorkerWith:_searchTf.text];
        
    }else if ([_fromWhich isEqualToString:@"change_shop"])
    {
        [_addressDataSource removeAllObjects];
        [self connectShopNameWith:_searchTf.text];
    }
    
}

-(void)displayHistoryKeywords
{
    
    if ([_fromWhich isEqualToString:@"shop_address"]) {
        [_addressDataSource removeAllObjects];
        [_addressDataSource addObjectsFromArray:[[SystemConfig shareSystemConfig]getHistoryShopAddressArray]];
    }
    else if ([_fromWhich isEqualToString:@"target_address"])
    {
        [_addressDataSource removeAllObjects];
        [_addressDataSource addObjectsFromArray:[[SystemConfig shareSystemConfig]getHistoryAddressArray]];
    }
    
    [_addressTableView reloadData];
}
-(void)checkLocalShopAddress
{
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in [[SystemConfig shareSystemConfig]getShopInfo]) {
        
    if ([[dict valueForKey:@"customerName"]rangeOfString:_searchTf.text].location != NSNotFound) {
            [resultArray addObject:dict];
        }
    }
    [_addressDataSource removeAllObjects];
    [_addressDataSource addObjectsFromArray:resultArray];
    [_addressTableView reloadData];

}
//搜索地点
-(void) searchAddressWithKeyword:(NSString *) keyword
{
    if (!_searcher)
    {
        //初始化检索对象
        _searcher =[[BMKPoiSearch alloc]init];
        _searcher.delegate = self;
    }
    //发起检索
    BMKCitySearchOption *option = [[BMKCitySearchOption alloc]init];
    option.city = @"北京";
    option.pageIndex = 0;
    option.pageCapacity = 20;
    option.keyword = keyword;
    BOOL flag = [_searcher poiSearchInCity:option];
    
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
    
}
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
        
    [_addressDataSource removeAllObjects];
    [_addressDataSource addObjectsFromArray:poiResult.poiInfoList];
    [_addressTableView reloadData];
    
}
-(void)dealloc
{
    _searcher.delegate = nil;
    _addressDataSource = nil;
}

- (IBAction)displayWholeListClicked:(UIButton *)sender {
    
    [_addressDataSource removeAllObjects];
    [_addressDataSource addObjectsFromArray:[[SystemConfig shareSystemConfig]getShopInfo]];
    
    [self connectShopAddressWith:@""];
    
}

- (IBAction)returnBtClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clearBtClicked:(UIButton *)sender {
    _searchTf.text = @"";
    [_addressDataSource removeAllObjects];
    
    if ([_fromWhich isEqualToString:@"shop_address"]) {
       
        [_addressDataSource addObjectsFromArray:[[SystemConfig shareSystemConfig]getHistoryShopAddressArray]];
    }
    else if ([_fromWhich isEqualToString:@"target_address"])
    {
        [_addressDataSource addObjectsFromArray:[[SystemConfig shareSystemConfig]getHistoryAddressArray]];
    }
    
    [_addressTableView reloadData];
}

#pragma mark tableview delegate and datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _addressDataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if ([[_addressDataSource objectAtIndex:indexPath.row]isKindOfClass:[NSString class]]) {
        return 40;
        
    }else if ([[_addressDataSource objectAtIndex:indexPath.row]isKindOfClass:[NSDictionary class]])
    {
        return 50+20;
    
    }else if ([[_addressDataSource objectAtIndex:indexPath.row]isKindOfClass:[BMKPoiInfo class]])
    {
        return 50;
    }
    
    
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[_addressDataSource objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]){
        
        AddressListCell *historyAddressCell = [tableView  dequeueReusableCellWithIdentifier:@"historyAddresCell"];
        historyAddressCell = [[NSBundle mainBundle]loadNibNamed:@"AddressListCell" owner:self options:nil][0];
        historyAddressCell.historyAddressLabel.text = [_addressDataSource objectAtIndex:indexPath.row];
        historyAddressCell.deleteHistoryBt.hidden = NO;
        historyAddressCell.deleteHistoryBt.tag = indexPath.row;
        [historyAddressCell.deleteHistoryBt addTarget:self action:@selector(deleteOneHistory:) forControlEvents:UIControlEventTouchDown];
        return historyAddressCell;
        
    }else if ([[_addressDataSource objectAtIndex:indexPath.row]isKindOfClass:[NSDictionary class]])
    {
        AddressListNetdataCell *netdataAddressCell = [tableView  dequeueReusableCellWithIdentifier:@"netdataAddressCell"];
        netdataAddressCell = [[NSBundle mainBundle]loadNibNamed:@"AddressListNetdataCell" owner:self options:nil][0];
        if ([_fromWhich isEqualToString:@"shop_address"]||[_fromWhich isEqualToString:@"target_address"]) {
            netdataAddressCell.mainTitleLabel.text = [[_addressDataSource objectAtIndex:indexPath.row]valueForKey:@"customerName"];
            netdataAddressCell.subTitleLabel.text = @"详细地址订单执行中可见。";
        }
        else if([_fromWhich isEqualToString:@"change_shop"])
        {
            netdataAddressCell.mainTitleLabel.text = [[_addressDataSource objectAtIndex:indexPath.row]valueForKey:@"bizCustomerName"];
            netdataAddressCell.subTitleLabel.text = @"详细地址订单执行中可见。";
        }else if ([_fromWhich isEqualToString:@"add_help_worker"])
        {
            netdataAddressCell.mainTitleLabel.text = [NSString stringWithFormat:@"%@(%@)",[[_addressDataSource objectAtIndex:indexPath.row]valueForKey:@"bizCustomerName"],[[_addressDataSource objectAtIndex:indexPath.row]valueForKey:@"contactPhone"]];
            netdataAddressCell.subTitleLabel.text = [[_addressDataSource objectAtIndex:indexPath.row]valueForKey:@"brandName"];
            if ([[[_addressDataSource objectAtIndex:indexPath.row]valueForKey:@"salaryType"]length]<=0) {
                netdataAddressCell.salaryTypeLb.text = [NSString stringWithFormat:@"工资类型：暂无"];
            }else{
                netdataAddressCell.salaryTypeLb.text = [NSString stringWithFormat:@"工资类型：%@",[[_addressDataSource objectAtIndex:indexPath.row]valueForKey:@"salaryType"]];
            }
        }
        
        return netdataAddressCell;
        
    }
    else if ([[_addressDataSource  objectAtIndex:indexPath.row]isKindOfClass:[BMKPoiInfo class]])
    {
        AddressListNetdataCell *netdataAddressCell = [tableView  dequeueReusableCellWithIdentifier:@"netdataAddressCell"];
        netdataAddressCell = [[NSBundle mainBundle]loadNibNamed:@"AddressListNetdataCell" owner:self options:nil][0];
        
        BMKPoiInfo *poiInfomation = [_addressDataSource objectAtIndex:indexPath.row];
        netdataAddressCell.mainTitleLabel.text = poiInfomation.name;
        netdataAddressCell.subTitleLabel.text  = poiInfomation.address;
        return netdataAddressCell;
    }
    
    return 0;
}
-(void)deleteOneHistory:(UIButton *)button
{
    NSMutableArray *tempArray;
    if ([_fromWhich isEqualToString:@"shop_address"]) {
        tempArray = [NSMutableArray arrayWithArray:[[SystemConfig shareSystemConfig] getHistoryShopAddressArray]];
    }
    else if ([_fromWhich isEqualToString:@"target_address"])
    {
        tempArray = [NSMutableArray arrayWithArray:[[SystemConfig shareSystemConfig]getHistoryAddressArray]];
    }
    [tempArray removeObject:[tempArray objectAtIndex:button.tag]];
    
    if ([_fromWhich isEqualToString:@"shop_address"]) {
        [[SystemConfig shareSystemConfig]saveHistoryShopAddress:tempArray];
        [_addressDataSource removeAllObjects];
        [_addressDataSource addObjectsFromArray:[[SystemConfig shareSystemConfig]getHistoryShopAddressArray]];
    }else if ([_fromWhich isEqualToString:@"target_address"])
    {
        [[SystemConfig shareSystemConfig]saveHistoryAddress:tempArray];
        [_addressDataSource removeAllObjects];
        [_addressDataSource addObjectsFromArray:[[SystemConfig shareSystemConfig]getHistoryAddressArray]];
    }
 
    [_addressTableView reloadData];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
   
    
    if ([[_addressDataSource objectAtIndex:indexPath.row]isKindOfClass:[NSString class]]) {
        _searchTf.text = [_addressDataSource objectAtIndex:indexPath.row];
        
        if ([_fromWhich isEqualToString:@"shop_address"]) {
            
            [self connectShopAddressWith:_searchTf.text];
            
        }else if ([_fromWhich isEqualToString:@"target_address"])
        {
            [self searchAddressWithKeyword:_searchTf.text];
        }
        
    }else if ([[_addressDataSource objectAtIndex:indexPath.row]isKindOfClass:[NSDictionary class]])
    {
        if ([_fromWhich isEqualToString:@"change_shop"]) {
            [self connectToChangeShop:[_addressDataSource objectAtIndex:indexPath.row]];
        }
        else if ([_fromWhich isEqualToString:@"add_help_worker"])
        {
            _resultWorkerDic = [_addressDataSource objectAtIndex:indexPath.row];
            [self addpickerView];
        }
        else{
        
            [self.ChooseAddressDelegate didselectedShopInfo:[_addressDataSource objectAtIndex:indexPath.row]];
            [self.navigationController popViewControllerAnimated:YES];
        }
 
    }
    else if ([[_addressDataSource objectAtIndex:indexPath.row]isKindOfClass:[BMKPoiInfo class]])
    {
        [self saveHistorySearchAddress];
        [self.ChooseAddressDelegate didSelectedBMKPoiInfo:[_addressDataSource objectAtIndex:indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }

}

-(void)saveHistorySearchAddress
{
    NSMutableArray *tempArray;
    
    if ([_fromWhich isEqualToString:@"shop_address"]) {
        
        tempArray=[NSMutableArray arrayWithArray:[[SystemConfig shareSystemConfig]getHistoryShopAddressArray]];

    }else if ([_fromWhich isEqualToString:@"target_address"])
    {
        tempArray = [NSMutableArray arrayWithArray:[[SystemConfig shareSystemConfig]getHistoryAddressArray]];
    }
    
    [tempArray removeObject:_searchTf.text];
    [tempArray insertObject:_searchTf.text atIndex:0];
    
    if (tempArray.count > 10)
    {
        NSArray *subArray = [tempArray subarrayWithRange:NSMakeRange(0, 10)];
        
       [[SystemConfig  shareSystemConfig]saveHistoryAddress:subArray];

    }else
    {
        [[SystemConfig shareSystemConfig]saveHistoryAddress:tempArray];
    }
    
}

#pragma mark textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_fromWhich isEqualToString:@"shop_address"]) {
        _addressTableToTop.constant = 55;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([_fromWhich isEqualToString:@"shop_address"]) {
        _addressTableToTop.constant = 5;
    }
}


#pragma mark scrollView method


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark network

-(void)connectShopAddressWith:(NSString *)tfContent
{
    [NetWorkTool getRequestWithUrl:__shopAddressList totalParam:@{@"driverIMEI":[[SystemConfig shareSystemConfig]getDeviceToken],@"bizCustomerName":tfContent} addProgressHudOn:self.view Tip:@"获取店家列表" successReturn:^(id successReturn) {
        
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        if ([[jsonDict valueForKey:@"result"]isEqualToString:@"true"]) {
            
            if ([_searchTf.text isEqualToString:@""]||!_searchTf.text) {
                [[SystemConfig shareSystemConfig]saveShopInfo:[jsonDict valueForKey:@"infos"]];
            }
            [_addressDataSource removeAllObjects];
            [_addressDataSource addObjectsFromArray:[jsonDict valueForKey:@"infos"]];
            [_addressTableView reloadData];
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.removeFromSuperViewOnHide =YES;
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [jsonDict valueForKey:@"msg"];
            hud.minSize = CGSizeMake(108.f, 108.0f);
            [hud hide:YES afterDelay:HudDelayTime];
        }

        
    } failed:^(id failed) {
        
    }];
    
}

-(void)connectShopNameWith:(NSString *)tfContent
{
    
    [NetWorkTool getRequestWithUrl:__shopNameList totalParam:@{@"bizCustomerName":tfContent,@"driverIMEI":[[SystemConfig shareSystemConfig]getDeviceToken],@"isOrNoSupport":@"N"} addProgressHudOn:nil Tip:@"获取店铺" successReturn:^(id successReturn) {
        
    NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        if ([[jsonDict valueForKey:@"result"]isEqualToString:@"true"]) {
            
            if ([_searchTf.text isEqualToString:@""]||!_searchTf.text) {
                [[SystemConfig shareSystemConfig]saveShopInfo:[jsonDict valueForKey:@"infos"]];
            }
            [_addressDataSource removeAllObjects];
            [_addressDataSource addObjectsFromArray:[jsonDict valueForKey:@"infos"]];
            [_addressTableView reloadData];
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.removeFromSuperViewOnHide =YES;
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [jsonDict valueForKey:@"msg"];
            hud.minSize = CGSizeMake(108.f, 108.0f);
            [hud hide:YES afterDelay:HudDelayTime];
        }
        
    } failed:^(id failed) {
        
    }];

}
-(void)connectToChangeShop:(NSDictionary *)resultShop
{
    [NetWorkTool postRequestWithUrl:__shopNameList param:@{@"driverIMEI":[[SystemConfig shareSystemConfig]getDeviceToken],@"bizCustomerId":[resultShop valueForKey:@"bizCustomerId"],@"bizCustomerName":[resultShop valueForKey:@"bizCustomerName"],@"isOrNoSupport":@"N"} addProgressHudOn:self.view Tip:@"修改驻店" successReturn:^(id successReturn){
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];


        if ([[jsonDict valueForKey:@"result"]isEqualToString:@"true"]) {
            
            if ([[jsonDict valueForKey:@"msg"]isEqualToString:@"success"]) {
                
                NSString *tip = [NSString stringWithFormat:@"更换为新的驻店：%@",[resultShop valueForKey:@"bizCustomerName"]];
                ALERT_VIEW(tip);
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                ALERT_VIEW([jsonDict valueForKey:@"msg"]);
            }
        }else{
            ALERT_VIEW([jsonDict valueForKey:@"msg"]);
        }
        
    } failed:^(id failed) {
        
    }];
}

//提交支援名单
-(void)connectToAddHelperWorker:(NSDictionary *)resultWorker
{
    
    [NetWorkTool postRequestWithUrl:__HelpWorkerList param:@{@"driverIMEI":[[SystemConfig shareSystemConfig]getDeviceToken],@"bizCustomerName":[resultWorker valueForKey:@"bizCustomerName"],@"bizCustomerId":[resultWorker valueForKey:@"bizCustomerId"],@"isOrNoSupport":@"Y",@"date":_dateString,@"fullTimeWork":_fullTimeWork,@"salaryType":_salaryType} addProgressHudOn:self.view Tip:@"添加人员" successReturn:^(id successReturn) {
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        //        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        if ([[jsonDict valueForKey:@"result"]isEqualToString:@"true"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.removeFromSuperViewOnHide =YES;
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [jsonDict valueForKey:@"msg"];
            hud.minSize = CGSizeMake(108.f, 108.0f);
            [hud hide:YES afterDelay:HudDelayTime];
        }
        
    } failed:^(id failed) {
        
    }];
    
}

//获取支援名单
-(void)connectHelpWorkerWith:(NSString *)tfContent
{
    [NetWorkTool getRequestWithUrl:__HelpWorkerList totalParam:@{@"driverIMEI":[[SystemConfig shareSystemConfig]getDeviceToken],@"bizCustomerName":tfContent,@"isOrNoSupport":@"Y",@"date":_dateString} addProgressHudOn:self.view Tip:@"获取列表" successReturn:^(id successReturn) {
        
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        if ([[jsonDict valueForKey:@"result"]isEqualToString:@"true"]) {
            
            [_addressDataSource removeAllObjects];
            [_addressDataSource addObjectsFromArray:[jsonDict valueForKey:@"infos"]];
            [_addressTableView reloadData];            
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.removeFromSuperViewOnHide =YES;
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [jsonDict valueForKey:@"msg"];
            hud.minSize = CGSizeMake(108.f, 108.0f);
            [hud hide:YES afterDelay:HudDelayTime];
        }
        
    } failed:^(id failed) {
        
    }];
}

- (void)getData{
    for (NSArray *items in self.positionArray) {
        SalaryGroup *group = [[SalaryGroup alloc]init];
        group.positionName = items[0];
        group.positionType = [items[1]integerValue];
        [salaryArray addObject:group];
        for (int i = 2; i<items.count; i++) {
            if (i%2==0) {//偶数
                SalaryItem *item = [[SalaryItem alloc]init];
                item.salaryType = items[i];
                item.salaryTypeID = [items[i+1]integerValue];
                [group.items addObject:item];
            }else{
                continue;
            }
        }
        NSLog(@"group.items=%@",group.items);
    }
    NSLog(@"groups=%@",salaryArray);

}

- (void)addpickerView{
    SHSelectPayTypeView *payTypeView = [SHSelectPayTypeView selectPayTypeViewWithController:self];
    payTypeView.group = salaryArray;
    payTypeView.name = [_resultWorkerDic valueForKey:@"bizCustomerName"];
    WEAK(self);
    payTypeView.selectedBlock = ^(NSString *fullTimeWork,NSString *salaryType){
        NSLog(@"fulltimework:%@,\n salaryType:%@",fullTimeWork,salaryType);
        _salaryType = salaryType;
        _fullTimeWork = fullTimeWork;
        if (_fullTimeWork.length<=0) {
            _fullTimeWork = @"0";
        }
        [weakself connectToAddHelperWorker:_resultWorkerDic];
    };
    [self.view addSubview:payTypeView];

}

@end
