//
//  RegisterViewController.m
//  XKSDeliver
//
//  Created by ccSunday on 2017/2/16.
//  Copyright © 2017年 同行必达. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterDataModel.h"
#import "SimpleSwitch.h"
#import "HCCommonItem.h"
#import "ReactiveCocoa.h"
@interface RegisterViewController ()
{
    HCDistributeSpaceItem *nameItem;        //姓名
    HCDistributeSpaceItem *sexItem;         //性别
    HCDistributeSpaceItem *IDItem;          //身份证号
    HCDistributeSpaceItem *phoneItem;       //手机号
    HCDistributeSpaceItem *passwordItem;    //密码
    HCDistributeSpaceItem *confirmPwItem;   //确认密码
    HCDistributeSpaceItem *departMentItem;  //城市
    HCDistributeSpaceItem *cityItem;        //部门
}
@property (nonatomic, strong)RegisterDataModel *model;
@property (nonatomic, strong)HCPopView *popView;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleNavLabel.text = @"注册";
    [self getData];
}

- (void)configGroupItems{
     WEAK(self);
    HCDistributeSpaceGroup *group = [self addCommonGroupWithHeader:nil];
    //姓名，性别，身份证号，手机号，密码，确认密码，城市，部门
    nameItem = [HCDistributeSpaceItem itemWithTitle:@"姓名:" placeHolder:@"请填写姓名"];
    sexItem = [HCDistributeSpaceItem itemWithTitle:[NSString stringWithFormat:@"%@:",self.model.dataTitleArray[2]] placeHolder:@""];
    sexItem.switchOptions = self.model.dataValueArray[2];
    sexItem.switchFlag = 0;
    sexItem.canEdit = NO;
    sexItem.opertion = ^(SimpleSwitch *switchView){
        NSLog(@"switchViewFlag---%zd",switchView.flag);
    };

    IDItem = [HCDistributeSpaceItem itemWithTitle:@"身份证号:" placeHolder:@"请填写身份证号"];
    
    phoneItem = [HCDistributeSpaceItem itemWithTitle:@"手机号:" placeHolder:@"请填写手机号"];
    phoneItem.maxInputLength = 11;
    phoneItem.keyBoardType = UIKeyboardTypePhonePad;
    
    passwordItem = [HCDistributeSpaceItem itemWithTitle:@"密码:" placeHolder:@"请填写密码"];
    passwordItem.secureTextEntry = YES;
    
    confirmPwItem = [HCDistributeSpaceItem itemWithTitle:@"确认密码:" placeHolder:@"请再次输入密码"];
    //secureTextEntry
    confirmPwItem.secureTextEntry = YES;
    
    cityItem = [HCDistributeSpaceItem itemWithTitle:[NSString stringWithFormat:@"%@:",self.model.dataTitleArray[0]] placeHolder:@""];
    cityItem.rightText = @"请选择";
    cityItem.rightImage = @"jiantou";
    cityItem.canEdit = NO;
    WEAK(cityItem);
    cityItem.opertion = ^(UIButton *button){
        [HCPopView popViewWithController:weakself tableView:weakself.tableView item:weakcityItem header:@"请选择城市" titles:weakself.model.dataValueArray[0]];
        [weakself.tableView reloadData];
    };
    departMentItem = [HCDistributeSpaceItem itemWithTitle:[NSString stringWithFormat:@"%@:",self.model.dataTitleArray[1]] placeHolder:@""];
    departMentItem.rightText = @"请选择";
    departMentItem.rightImage = @"jiantou";
    departMentItem.canEdit = NO;
    WEAK(departMentItem);
    departMentItem.opertion = ^(UIButton *button){
        [HCPopView popViewWithController:weakself tableView:weakself.tableView item:weakdepartMentItem header:@"请选择城市" titles:weakself.model.dataValueArray[1]];
        [weakself.tableView reloadData];
    };
    UIView *footerView = [[UIView alloc]init];
    footerView.size = CGSizeMake(_SCREEN_WIDTH_, 400);
    footerView.backgroundColor = ROOT_VIEW_BGCOLOR;
    
    UIButton *registerBtn = CUSTOMBUTTON;
    registerBtn.frame = CGRectMake(12, 24,_SCREEN_WIDTH_-24, 44);
    registerBtn.layer.cornerRadius = registerBtn.height/2;
    registerBtn.backgroundColor = Blue_Color;
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:LIGHT_WHITE_COLOR forState:UIControlStateNormal];
    [[registerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakself registerClient];

    }];
    [footerView addSubview:registerBtn];
    
    UITextView *tipInfoTv = [[UITextView alloc]initWithFrame:CGRectMake(24, registerBtn.bottom+12, WIDTH-24-12, 60) textContainer:nil];
    tipInfoTv.backgroundColor = ROOT_VIEW_BGCOLOR;
    tipInfoTv.editable = NO;
    tipInfoTv.text = @"注:\n 1、登陆用户名即是手机号；\n 2、注册完成后，请尽快到公司完善相关信息！";
    tipInfoTv.textColor = LIGHT_GRAY_COLOR;
    [footerView addSubview:tipInfoTv];
    
    
    HCCommonItem *registerItem = [HCCommonItem associateObject:footerView withKey:@"registerView"];

    [group.items addObjectsFromArray:@[nameItem,sexItem,IDItem,phoneItem,passwordItem,confirmPwItem,cityItem,departMentItem,registerItem]];
}

- (void)getData{
    [NetWorkTool getRequestWithUrl:__RegisterConfigs param:nil addProgressHudOn:self.view Tip:@"获取信息" successReturn:^(id successReturn){
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        NSDictionary *dict = [jsonDict valueForKey:@"data"];
        self.model = [RegisterDataModel mj_objectWithKeyValues:dict];
        [self configGroupItems];
        NSLog(@"dict=%@",dict);
        [self.tableView reloadData];
    } failed:^(id failed) {
        
    }];
}

- (void)registerClient{
    NSLog(@"注册");
//    NSLog(@"city:%@",self.model.dataKeyArray[0][cityItem.popOptionIndex-1]);
//    NSLog(@"department:%@",self.model.dataKeyArray[1][departMentItem.popOptionIndex-1]);
    
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    NSString *date = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
   
    [contentDic setObject:@"1" forKey:@"opeType"];
    
    [contentDic setObject:date forKey:@"time"];
    
    if (nameItem.subTitle.length<=0) {
        ALERT_HUD(self.view, @"请输入姓名");
        return;
    }else{
        [contentDic setObject:nameItem.subTitle forKey:@"driverName"];
    }
    
    [contentDic setObject:@(sexItem.switchFlag) forKey:@"driverSex"];
    if (IDItem.subTitle.length<=0) {
        ALERT_HUD(self.view, @"请输入身份证号");
        return;
    }else{
#ifdef DEBUG
        [contentDic setObject:IDItem.subTitle forKey:@"idcardNumber"];
#else 
        if ([[SystemConfig shareSystemConfig]validateIDCardNumber:IDItem.subTitle]) {
            [contentDic setObject:IDItem.subTitle forKey:@"idcardNumber"];
        }else{
            ALERT_HUD(self.view, @"身份证号输入有误");
            return;
        }
#endif
    }
    if (phoneItem.subTitle.length<=0||phoneItem.subTitle.length>11) {
        ALERT_HUD(self.view, @"请输入电话");
        return;
    }else{
        [contentDic setObject:phoneItem.subTitle forKey:@"cellPhone"];
    }
    if (passwordItem.subTitle.length<=0) {
        ALERT_HUD(self.view, @"填写密码");
        return;
    }else{
        [contentDic setObject:passwordItem.subTitle forKey:@"driverPwd"];
    }
    
    if (confirmPwItem.subTitle.length<=0) {
        ALERT_HUD(self.view, @"请再次输入密码");
        return;
    }
    
    if (![confirmPwItem.subTitle isEqualToString:passwordItem.subTitle]) {
        ALERT_HUD(self.view, @"密码不一致，请重新输入");
        return;
    }
    
    if (cityItem.popOptionIndex <= 0) {
        ALERT_HUD(self.view, @"请选择城市");
        return;
    }else{
        [contentDic setObject:self.model.dataKeyArray[0][cityItem.popOptionIndex-1] forKey:@"cityId"];
    }
    if (departMentItem.popOptionIndex == 0) {
        ALERT_HUD(self.view, @"请选择部门");
        return;
    }else{
        [contentDic setObject:self.model.dataKeyArray[1][departMentItem.popOptionIndex-1] forKey:@"companyId"];
    }
    NSString *jsonString = [contentDic mj_JSONString];
    NSDictionary *params = @{@"param":jsonString}; //服务器最终接受到的对象，是一个字典，key为“ios”，value为“json字符串”
    [NetWorkTool postRequestWithUrl:__RegisterSubmits param:params addProgressHudOn:self.view Tip:@"上传数据中" successReturn:^(id successReturn) {
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        
        if ([[jsonDict objectForKey:@"result"]isEqualToString:@"true"]) {
            ALERT_HUD(self.view, jsonDict[@"msg"]);
            [[SystemConfig shareSystemConfig]saveUserName:phoneItem.subTitle];
            [[SystemConfig shareSystemConfig]saveUserPassword:passwordItem.subTitle];
            if (self.successRegist) {
                self.successRegist();
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            ALERT_HUD(self.view, jsonDict[@"msg"]);
        }
    } failed:^(id failed) {
        
    }];
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

@end
