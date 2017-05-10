//
//  UserInfoVc.m
//  XKSDeliver
//
//  Created by 同行必达 on 16/5/6.
//  Copyright © 2016年 同行必达. All rights reserved.
//

#import "UserInfoVc.h"
#import "NetWorkTool.h"
#import "SystemConfig.h"

@interface UserInfoVc ()<UIAlertViewDelegate>

@end

@implementation UserInfoVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    [self connectUserData];
    
}
-(void)prepareData
{
    _titleNameArray = [[NSMutableArray alloc]init];
    _infoDataSource = [[NSMutableArray alloc]init];
    _infoNameDataSource = [[NSMutableArray alloc]init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray *)[_infoDataSource objectAtIndex:section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleNameArray.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_titleNameArray objectAtIndex:section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userinfo"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"userinfo"];
    }
    
    cell.textLabel.text = [[_infoDataSource objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    cell.detailTextLabel.text = [[_infoNameDataSource objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    return cell;
}


-(void)connectUserData
{
    [NetWorkTool getRequestWithUrl:_UserInfo_ param:@{@"driverIMEI":[[SystemConfig shareSystemConfig]getDeviceToken]} addProgressHudOn:self.view Tip:@"获取个人信息" successReturn:^(id successReturn) {
        
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];
        if ([jsonDict[@"result"]boolValue] == true) {
            [_titleNameArray removeAllObjects];
            [_titleNameArray addObjectsFromArray:[[[jsonDict valueForKey:@"infos"]objectAtIndex:0]valueForKey:@"titleNameArray"]];
            [_infoNameDataSource removeAllObjects];
            [_infoNameDataSource addObjectsFromArray:[[[jsonDict valueForKey:@"infos"]objectAtIndex:0]valueForKey:@"dataValueArray"]];
            
            [_infoDataSource removeAllObjects];
            [_infoDataSource addObjectsFromArray:[[[jsonDict valueForKey:@"infos"]objectAtIndex:0]valueForKey:@"dataKeyArray"]];
            
            [_userInfoTableView reloadData];
        }else{
            ALERT_HUD(self.view, jsonDict[@"msg"]);
        }
        
        
        
    } failed:^(id failed) {
        
    }];
}


- (IBAction)returnBtClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)serviceBtClicked:(UIButton *)sender {
    
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


@end
