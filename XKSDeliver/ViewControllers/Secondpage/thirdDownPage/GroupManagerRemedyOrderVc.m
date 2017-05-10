//
//  GroupManagerRemedyOrderVc.m
//  XKSDeliver
//
//  Created by fong on 16/10/16.
//  Copyright © 2016年 同行必达. All rights reserved.
//

#import "GroupManagerRemedyOrderVc.h"
#import "UITableViewCell+GetTbView.h"
#import "ChooseAddressViewController.h"
#import "common.h"
#import "NetWorkTool.h"
#import "SystemConfig.h"
#import "MemberRemedyCell.h"
#import "DriverDsdModel.h"
typedef enum : NSUInteger {
    WorkTime = 1000,
}TfType;

@interface GroupManagerRemedyOrderVc ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation GroupManagerRemedyOrderVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self basicUI];
   // [self connectLocalWorkerInfo];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self connectLocalWorkerInfo];
}

-(void)viewDidAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}

-(void)basicUI
{
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.maximumDate = [NSDate dateWithTimeInterval:0 sinceDate:[NSDate date]];
    _datePicker.minimumDate = [NSDate dateWithTimeInterval:-24*3600 sinceDate:[NSDate date]];
    
    _workerListTbView.delegate = self;
    _workerListTbView.dataSource = self;
    _workerListTbView.backgroundColor = LIGHT_WHITE_COLOR;
    _workerListTbView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _timeFormatter = [[NSDateFormatter alloc]init];
    [_timeFormatter setDateFormat:@"YYYY-MM-dd"];
    
    _dataSource = [[NSMutableArray alloc]init];
    
    [_chooseTimeBt setTitle:[_timeFormatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    
    _timeParam = [_timeFormatter stringFromDate:[NSDate date]];
}

#pragma mark tableview  delegate datesource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"MemberCell";
    MemberRemedyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MemberRemedyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (_dataSource.count >0) {
        DriverDsdModel *model = [_dataSource objectAtIndex:indexPath.row];
        cell.model = model;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return  102;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField.tag >= WorkTime) {
        
        if ([textField.text integerValue] > 24) {
            textField.text = @"0";
            ALERT_VIEW(@"不得超过24个小时");
            return;
        }
    }
    
    if (textField.tag >= WorkTime) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[_dataSource objectAtIndex:(textField.tag-WorkTime)]];
        [arr removeObjectAtIndex:2];
        if ([textField.text isEqualToString:@""]) {
            [arr insertObject:@"0" atIndex:2];
        }else
        {
            [arr insertObject:textField.text atIndex:2];
        }
        
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:arr];
        [_dataSource removeObjectAtIndex:(textField.tag - WorkTime)];
        [_dataSource insertObject:array atIndex:(textField.tag - WorkTime)];
        
        NSLog(@"");
        
    }else
    {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[_dataSource objectAtIndex:textField.tag]];
        [arr removeObjectAtIndex:3];
        if ([textField.text isEqualToString:@""]) {
            [arr insertObject:@"0" atIndex:3];
            
        }else
        {
            [arr insertObject:textField.text atIndex:3];
        }
        [_dataSource removeObjectAtIndex:textField.tag];
        [_dataSource insertObject:arr atIndex:textField.tag];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)popBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)chooseRemedyOrderDate:(UIButton *)sender{
    self.pickerBack.hidden = NO;
    self.pickerContainer.hidden = NO;
//    self.tabBarController.tabBar.hidden = YES;
}

- (IBAction)submitOrder:(UIButton *)sender {
    [self connectToSubmitOrder];
}

- (IBAction)confirmBtClicked:(UIButton *)sender {
    self.pickerBack.hidden = YES;
    self.pickerContainer.hidden = YES;
    _timeParam = [_timeFormatter stringFromDate:_datePicker.date];
    [_chooseTimeBt setTitle:[_timeFormatter stringFromDate:_datePicker.date] forState:UIControlStateNormal];
    
    [self connectLocalWorkerInfo];

    NSLog(@"time choose%@",_timeParam);
//    self.tabBarController.tabBar.hidden = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y == 0) {
        [_workerListTbView reloadData];
    }
}


- (IBAction)addHelpWorkers:(UIButton *)sender {
    ChooseAddressViewController *chooseAddressVc = [[ChooseAddressViewController alloc]init];
    chooseAddressVc.fromWhich = @"add_help_worker";
    chooseAddressVc.dateString = _timeParam;
    chooseAddressVc.positionArray = self.postionArray;
    [self.navigationController pushViewController:chooseAddressVc animated:YES];
}

-(void)connectLocalWorkerInfo
{
    
    __weak typeof(self) this = self;
    [_dataSource removeAllObjects];
    [NetWorkTool getRequestWithUrl:__RemedyWorkerList totalParam:@{@"date":_timeParam,@"driverIMEI":[[SystemConfig shareSystemConfig]getDeviceToken],@"timestamp":[NSString stringWithFormat:@"%@",[NSDate date]]} addProgressHudOn:self.view Tip:@"" successReturn:^(id successReturn) {
        
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

    if ([[jsonDict valueForKey:@"result"]isEqualToString:@"true"]) {
        
        NSMutableArray *originalArray = [NSMutableArray arrayWithArray:(NSArray *)[jsonDict valueForKey:@"driverGSDLList"]];
        _postionArray = (NSArray *)[jsonDict valueForKey:@"driversFullTimeAndSalary"];
        for (NSArray *array in originalArray) {
            DriverDsdModel *model = [[DriverDsdModel alloc]init];
            model.userID = array[0];
            model.name = array[1];
            model.workTime = array[2];
            model.unitNum = array[3];
            model.isSupport = array[4];
            model.positionType = array[5];
            if (array.count == 7) {
                model.salaryType = array[6];
            }
            [_dataSource addObject:model];
        }
        _cityNameLb.text = [jsonDict valueForKey:@"cityName"];
        _brandNameLb.text = [jsonDict valueForKey:@"brandName"];
        _customerNameLb.text = [jsonDict valueForKey:@"customerName"];
        
        if ([[jsonDict valueForKey:@"flag"]integerValue] != 1) {
            
            _addMemberBt.enabled = YES;
            _submitOrderBt.enabled = YES;
            
        }
    
        ALERT_HUD(this.view,[jsonDict valueForKey:@"msg"]);
        
        [_workerListTbView reloadData];
    
    }else
    {
        [_workerListTbView reloadData];

        ALERT_VIEW([jsonDict valueForKey:@"msg"]);
    }
        
    } failed:^(id failed) {
        
    }];
}

-(void)connectToSubmitOrder
{
    unsigned int outCount, i;
    NSString *value;
    objc_property_t *properties = class_copyPropertyList([DriverDsdModel class], &outCount);
    NSMutableArray *propertyArr = [NSMutableArray array];
    for (i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [propertyArr addObject:propertyName];
    }
    NSMutableArray *uploadArray = [NSMutableArray array];
    for (DriverDsdModel *model in _dataSource) {
        
        for (NSString *property in propertyArr) {
            if ([property isEqualToString:@"valuesArray"]) {
                continue;
            }
           NSString *value = [model valueForKey:property];
            if (value != nil) {
                [model.valuesArray addObject:value];
            }
        }
        [uploadArray addObject:model.valuesArray];
    }
    NSLog(@"uploadarr%@",uploadArray);
    NSString *goodsIDArr = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:uploadArray options:0 error:nil] encoding:NSUTF8StringEncoding];
    __weak typeof(self) this = self;
    [NetWorkTool postRequestWithUrl:__RemedyWorkerList param:@{@"date":_timeParam,@"driverIMEI":[[SystemConfig shareSystemConfig]getDeviceToken],@"param":goodsIDArr,@"timestamp":[NSString stringWithFormat:@"%@",[NSDate date]]} addProgressHudOn:self.view Tip:@"" successReturn:^(id successReturn) {
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        //        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        if ([[jsonDict valueForKey:@"result"]isEqualToString:@"true"]) {
            
            [this connectLocalWorkerInfo];
//            self.tabBarController.tabBar.hidden = YES;
           // ALERT_HUD(this.view,[successReturn valueForKey:@"msg"]);
            
        }else
        {
            ALERT_VIEW([jsonDict valueForKey:@"msg"]);
        }
        
        
    } failed:^(id failed) {
        
    }];
}


@end
