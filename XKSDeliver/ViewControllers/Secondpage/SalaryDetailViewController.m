//
//  SalaryDetailViewController.m
//  XKSDeliver
//
//  Created by ccSunday on 2017/2/17.
//  Copyright © 2017年 同行必达. All rights reserved.
//

#import "SalaryDetailViewController.h"
#import "MJRefresh.h"
#import "SalaryDetailCell.h"
@interface SalaryDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView *mainTableView;
    
    NSArray *gsdlArray;
    
    NSArray *dataArray;
    
}
@property (nonatomic, strong)UIView *section0View;

@property (nonatomic, strong)UIView *section1View;
@end

@implementation SalaryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    gsdlArray = [NSArray array];
    dataArray = [NSArray array];

    self.titleNavLabel.text = @"工资明细";
    [self.rightNavButton setImage:GetImage(@"phoneImage@") forState:UIControlStateNormal];
    [self setupTableview];
    [self requestData];
    
}

- (void)setupTableview{
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, UI_NAV_BAR_HEIGHT, WIDTH, HEIGHT-UI_NAV_BAR_HEIGHT) style:UITableViewStyleGrouped];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.backgroundColor = ROOT_VIEW_BGCOLOR;
    mainTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:mainTableView];


}

- (void)requestData{
    __weak typeof(self) this = self;
//    gsdl":[["2016-10-08",18,null,"商户测试"]],"data":[["2016-08",44,60,4600]]
    [NetWorkTool getRequestWithUrl:__salaryDetailInfo param:@{@"driverIMEI":[[SystemConfig shareSystemConfig]getDeviceToken]} addProgressHudOn:self.view Tip:@"获取工资信息" successReturn:^(id successReturn) {
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        if ([jsonDict[@"result"]boolValue] == true ) {
            gsdlArray = jsonDict[@"gsdl"];
            dataArray = jsonDict[@"data"];
//            if (gsdlArray.count == 0) {
//                gsdlArray = @[@[@"2016-10-08",@"18",@"3",@"商户测试"],@[@"2016-10-08",@"18",@"2",@"商户测试"],@[@"2016-10-08",@"18",@"2",@"商户测试"],@[@"2016-10-08",@"18",@"2",@"商户测试"]];
//            }
//            if (dataArray.count == 0) {
//                dataArray = @[@[@"2016-10-08",@"18",@"2",@"商户测试"],@[@"2016-10-08",@"18",@"2",@"商户测试"],@[@"2016-10-08",@"18",@"2",@"商户测试"],@[@"2016-10-08",@"18",@"2",@"商户测试"]];
//            }
            [mainTableView reloadData];
        }else{
            ALERT_HUD(self.view, jsonDict[@"msg"]);
        }
        
    } failed:^(id failed) {
        ALERT_HUD(self.view, @"数据错误");
        
    }];


}

#pragma mark footer and header Refresh
- (void)headerRefresh
{
    __weak __typeof(self) this = self;
    mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:this refreshingAction:@selector(accountRefreshFromHeader)];
    [mainTableView.mj_header beginRefreshing];
}

-(void)accountRefreshFromHeader
{
//    [self connectAccontData];
}

- (void)footerRefresh
{
    __weak __typeof(self) this = self;
    mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:this refreshingAction:@selector(accountRefreshFromFooter)];
}

-(void)accountRefreshFromFooter
{
//    [self connectAccontData];
}



#pragma mark UITableViewDelagate
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.section0View;
    }else{
        return self.section1View;
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        
        return gsdlArray.count==0?1:gsdlArray.count;
    }else{
        return dataArray.count==0?1:dataArray.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (gsdlArray.count == 0) {
            static NSString *Identifier = @"salary0EmptyCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            }
            cell.textLabel.text = @"当月没有日结记录";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            return cell;
        }else{
            static NSString *Identifier = @"salary0Cell";

            SalaryDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if (cell == nil) {
                cell = [[SalaryDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            }
            [cell updateWithArray:gsdlArray[indexPath.row]];
            return cell;
        }
    }else{
        if (dataArray.count == 0) {
            static NSString *Identifier = @"salary1EmptyCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            }
            cell.textLabel.text = @"暂时没有月工资记录";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            return cell;
        }else{
            static NSString *Identifier = @"salary1Cell";
            
            SalaryDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if (cell == nil) {
                cell = [[SalaryDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            }
            [cell updateWithArray:dataArray[indexPath.row]];
            return cell;
        }
    }
}


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

- (void)rightNavButtonClick:(UIButton *)button{
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"拨打客服号码咨询" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
//    [alert show];
    UIAlertAction *doneAction= [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString * telUrl = [NSString stringWithFormat:@"tel://%@",[[SystemConfig shareSystemConfig]getServiceNumber]];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:telUrl] options:[NSDictionary dictionary] completionHandler:nil];

    }];
    UIAlertAction *cancelAction= [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要拨打电话么？" preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:doneAction];
    [alertVc addAction:cancelAction];
    [self presentViewController:alertVc animated:YES completion:nil];

}

- (UIView *)section0View{
    if (!_section0View) {
        SalaryDetailCell *cell = [[SalaryDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"section0"];
        [cell updateWithArray:@[@"截止日期",@"工时/时",@"单量/单",@"门店"]];
        cell.dateLb.backgroundColor = cell.gongshiLb.backgroundColor = cell.danliangLb.backgroundColor = cell.mendianLb.backgroundColor = Blue_Color;
        _section0View = cell.contentView;
    }
    return _section0View;
}
- (UIView *)section1View{
    if (!_section1View) {
        SalaryDetailCell *cell = [[SalaryDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"section1"];
        [cell updateWithArray:@[@"月份",@"工时/时",@"单量/单",@"工资/元"]];
        cell.dateLb.backgroundColor = cell.gongshiLb.backgroundColor = cell.danliangLb.backgroundColor = cell.mendianLb.backgroundColor = Blue_Color;
        _section1View = cell.contentView;
    }
    return _section1View;
}


@end
