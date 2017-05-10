//
//  RemedyOrderViewController.m
//  sample0128
//
//  Created by 同行必达 on 16/2/19.
//  Copyright © 2016年 同行必达. All rights reserved.
//

#import "RemedyOrderViewController.h"
#import "common.h"
#import "ChooseAddressViewController.h"
#import "NetWorkTool.h"


#define _WEIGHT_COMPONENT_NUM 10
#define _MARGIN_LINE_ 10

NSInteger packagName       = 1000;
NSInteger customerName     = 1001;
NSInteger customerPhoneNum = 1002;

NSString *bfOraf = @"before";

@interface RemedyOrderViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,chooseAddressDelegate,UIAlertViewDelegate>

@property (nonatomic,weak)UIView       *backView;
@property (nonatomic,weak)UIView       *whiteView;
@property (nonatomic,weak)UIDatePicker *arrvivalTimePicker;

@end

@implementation RemedyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self deployUI];
    [self initdata];
}
-(void)initdata
{
    bfOraf = @"before";
    if ([[[[SystemConfig shareSystemConfig]getMainShopInfo]valueForKey:@"coordinate"]length]<=0||[[[[SystemConfig shareSystemConfig]getMainShopInfo]valueForKey:@"customerId"]intValue]==0) {
        ALERT_HUD(self.view , @"数据错误");
        return;
    }
    
    _delegateReturnData = [NSMutableDictionary dictionaryWithDictionary:@{@"cordinate":[[[SystemConfig shareSystemConfig]getMainShopInfo]valueForKey:@"coordinate"],@"customerId":[[[SystemConfig shareSystemConfig]getMainShopInfo]valueForKey:@"customerId"]}];
    [_shopAddressBt setTitle:[[[SystemConfig shareSystemConfig]getMainShopInfo]valueForKey:@"customerName"] forState:UIControlStateNormal];
}
-(void)deployUI
{
    self.navigationController.navigationBarHidden = YES;
    
    _remedyOrderSegmentControl.selectedSegmentIndex = 0;
    _line6TopToLine5.constant                       = -50;
    
    _weightPickerView.dataSource = self;
    _weightPickerView.delegate   = self;
    _packageNameTf.delegate    = self;
    _packageNameTf.tag         = packagName;
    _customerNameTf.delegate   = self;
    _customerNameTf.tag        = customerName;
    _customerPhoneNum.delegate = self;
    _customerPhoneNum.tag        = customerPhoneNum;
    
    _shopAddressBt.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
    _targetAddressBt.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
    
    
    UITapGestureRecognizer *tapToReturnKeyBoard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnKeyBoard)];
    
    [_backScrollView addGestureRecognizer:tapToReturnKeyBoard];
    
    
}
-(void)returnKeyBoard
{
    [self.view endEditing:YES];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.view endEditing:YES];
}

#pragma mark pickerview delegate and datasource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _WEIGHT_COMPONENT_NUM;
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    label.backgroundColor = [UIColor whiteColor];
    
    label.text = [NSString stringWithFormat:@"%ld公斤",row+1];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:15.0];
    
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseShopAddressClicked:(UIButton *)sender {
    
    ChooseAddressViewController *chooseAddress = [[ChooseAddressViewController alloc]init];
    chooseAddress.fromWhich = @"shop_address";
    chooseAddress.ChooseAddressDelegate = self;
    if (!_shopAddressBt.titleLabel.text) {
        chooseAddress.keyWord = @"";
    }else
    {
        chooseAddress.keyWord = _shopAddressBt.titleLabel.text;
    }
    [self.navigationController pushViewController:chooseAddress animated:YES];
}

- (IBAction)chooseTargetAddressClicked:(UIButton *)sender {
    ChooseAddressViewController *chooseAddress = [[ChooseAddressViewController alloc]init];
    chooseAddress.fromWhich = @"target_address";
    if (!_targetAddressBt.titleLabel.text) {
        chooseAddress.keyWord = @"";
    }else
    {
        chooseAddress.keyWord = _targetAddressBt.titleLabel.text;
    }
    chooseAddress.ChooseAddressDelegate = self;
    [self.navigationController pushViewController:chooseAddress animated:YES];
}

- (IBAction)chooseArrivalTimeBt:(UIButton *)sender {
    
    [self.view endEditing:YES];
    self.tabBarController.tabBar.hidden = YES;
    _backScrollToTop.constant = 0;
    
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH_, _SCREEN_HEIGHT_)];
    
    backview.backgroundColor = [UIColor blackColor];
    backview.alpha           = 0.8;
    _backView = backview;
    
    UITapGestureRecognizer *oneTapToHide = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideTheChooseTimeView:)];
    [backview addGestureRecognizer:oneTapToHide];
    
    UIView *whiteBack = [[UIView  alloc]initWithFrame:CGRectMake(_MARGIN_LINE_,_SCREEN_HEIGHT_/3,_SCREEN_WIDTH_-2*_MARGIN_LINE_,_SCREEN_HEIGHT_/3)];
    whiteBack.layer.cornerRadius = 15;
    whiteBack.backgroundColor    = [UIColor whiteColor];
    _whiteView = whiteBack;
    
    [self.view addSubview:backview];
    [self.view addSubview:whiteBack];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    UIDatePicker *datePicker  = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, whiteBack.frame.size.height/3, whiteBack.frame.size.width, whiteBack.frame.size.height/3)];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.locale         = locale;
    datePicker.minimumDate    = [NSDate dateWithTimeIntervalSinceNow:-5*24*3600];
    datePicker.maximumDate    = [NSDate date];
    _arrvivalTimePicker = datePicker;
    
    [whiteBack addSubview:datePicker];

}

-(void)hideTheChooseTimeView:(UIGestureRecognizer *)gesture
{
    self.tabBarController.tabBar.hidden = NO;
    _backView.hidden  = YES;
    _whiteView.hidden = YES;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
    NSString *timeString = [dateFormatter stringFromDate:_arrvivalTimePicker.date];
    [_arrivalTimeBt setTitle:timeString forState:UIControlStateNormal];
}

- (IBAction)returnBtClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark remedy order

- (IBAction)remedyOrderBtClicked:(UIButton *)sender {
    [self.view endEditing:YES];
    
    NSString *targetAddressString = [NSString stringWithFormat:@"%@%@",_targetAddressBt.titleLabel.text,_customerAddressDetailTf.text];
    
    NSString *targetCoordinate = [_delegateReturnData valueForKey:@"cordinate"];
    
    NSString *receiverName = [[[SystemConfig shareSystemConfig]getMainShopInfo]valueForKey:@"customerName"];
    
    NSString *receiverNum = [[[SystemConfig shareSystemConfig]getMainShopInfo]valueForKey:@"contactPhone"];
    
    if ([_shopAddressBt.titleLabel.text isEqualToString:@""]||!_shopAddressBt.titleLabel.text||[_shopAddressBt.titleLabel.text isEqualToString:@"null"])
    {
        ALERT_VIEW(@"请选择店家地址!");
        return;
    }
    if (![_targetAddressBt.titleLabel.text isEqualToString:@""] && _targetAddressBt.titleLabel.text != nil) {
        
        if ([_customerAddressDetailTf.text isEqualToString:@""]) {
            ALERT_VIEW(@"已经填写客户地址，请填写地址详情!");
            return;
        }
    }
    else
    {
        targetAddressString = @"";
            //
        targetCoordinate = [_delegateReturnData valueForKey:@"cordinate"];
    }
    
    if ([_packageNameTf.text isEqualToString:@""]) {
        ALERT_VIEW(@"请填写物品名称!");
        return;
    }
    

    if (![_customerNameTf.text isEqualToString:@""]) {
        
        receiverName = _customerNameTf.text;
    }
    if (![_customerPhoneNum.text isEqualToString:@""]) {
        
        receiverNum = _customerPhoneNum.text;
    }


    if (_remedyOrderSegmentControl.selectedSegmentIndex == 1) {
        if ([_arrivalTimeBt.titleLabel.text isEqualToString:@"点选"]) {
            ALERT_VIEW(@"请选择送达时间!");
            return;
        }
    }
    
    
    if ([[_delegateReturnData valueForKey:@"customerId"]isEqualToString:@""]||[[_delegateReturnData valueForKey:@"customerId"]isEqualToString:@"null"]||![_delegateReturnData valueForKey:@"customerId"]) {
        
        ALERT_VIEW(@"所选店家信息不全!");
        return;
        
    }
    
    if ([[_delegateReturnData valueForKey:@"cordinate"]isEqualToString:@""]||[[_delegateReturnData valueForKey:@"cordinate"]isEqualToString:@"null"]||![_delegateReturnData valueForKey:@"cordinate"]) {
        
        ALERT_VIEW(@"所选店家信息不全!");
        return;
        
    }
    
    /*
     {
     cordinate = "39.957112,116.357672";
     customerId = eks;
     }
     */
    
    
    if ([bfOraf isEqualToString:@"before"]) {
        
        _remedyOrderBt.userInteractionEnabled = NO;
        _remedyOrderBt.backgroundColor        = _DEFAULT_BACK_;
        
        
        [NetWorkTool postRequestWithUrl:__remedyOrder param:@{@"receiverName":receiverName,
                                                              @"receiverPhone":receiverNum,
                                                              @"targetAddress":targetAddressString,
                                                              @"targetAddressCoordinate":targetCoordinate,
                                                              @"imei":[[SystemConfig shareSystemConfig]getDeviceToken],
                                                              @"customerId":[_delegateReturnData valueForKey:@"customerId"],
                                                              @"beforeOrAfter":bfOraf,
                                                              @"itemWeight":[NSString stringWithFormat:@"%ld",[_weightPickerView selectedRowInComponent:0]],
                                                              @"itemName":_packageNameTf.text,
                                                              } addProgressHudOn:self.view Tip:@"补单中" successReturn:^(id successReturn){
                                                                  

                                                                  NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                                                                  //        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];
                                                  
    if ([[jsonDict  valueForKey:@"result"]isEqualToString:@"false"]) {
        ALERT_VIEW([jsonDict valueForKey:@"msg"]);
    }else
    {
        ALERT_VIEW([jsonDict valueForKey:@"msg"]);
    }
                                                                  
                                                                  [self.navigationController popViewControllerAnimated:YES];
        
                                                                  
    } failed:^(id failed) {
                                                                  
    }];
    }
    else if ([bfOraf isEqualToString:@"after"])
    {
        
        _remedyOrderBt.userInteractionEnabled = NO;
        _remedyOrderBt.backgroundColor        = _DEFAULT_BACK_;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *timeString = [dateFormatter stringFromDate:_arrvivalTimePicker.date];
        [NetWorkTool postRequestWithUrl:__remedyOrder param:@{@"reservedTime":timeString,
                                                              @"receiverName":receiverName,
                                                              @"receiverPhone":receiverNum,
                                                              @"targetAddress":targetAddressString,
                                                              @"targetAddressCoordinate":targetCoordinate,
                                                              @"imei":[[SystemConfig shareSystemConfig]getDeviceToken],
                                                              @"customerId":[_delegateReturnData valueForKey:@"customerId"],
                                                              @"beforeOrAfter":bfOraf,
                                                              @"itemWeight":
                                                                  [NSString stringWithFormat:@"%ld",[_weightPickerView selectedRowInComponent:0]],
                                                              @"itemName":_packageNameTf.text,
                                                              } addProgressHudOn:self.view Tip:@"补单中" successReturn:^(id successReturn){
                                                                  
                                                                  
                                                                  //    NSLog(@"%@",jsonDict);
                                                                  NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                                                                  //        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];
                                                                  
  
        if ([[jsonDict  valueForKey:@"result"]isEqualToString:@"false"]) {
                ALERT_VIEW([jsonDict valueForKey:@"msg"]);
            
        }else
        {
                ALERT_VIEW([jsonDict valueForKey:@"msg"]);
        }
                                                                  [self.navigationController popViewControllerAnimated:YES];

    
                                                                  
    } failed:^(id failed) {
                                                                  
    }];
    }
    
}

- (IBAction)remedyOrderTypeChanged:(UISegmentedControl *)sender {
    
    if ([sender selectedSegmentIndex] == 0) {
        _line6TopToLine5.constant                       = -50;
        bfOraf = @"before";

    }
    else if ([sender selectedSegmentIndex]==1)
    {
        _line6TopToLine5.constant                       = 0;
        bfOraf = @"after";
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == packagName)
    {
            _backScrollToTop.constant = -50;
    }
    else if (textField.tag == customerName)
    {
        _backScrollToTop.constant = -50*4;
    }
    else if (textField.tag == customerPhoneNum)
    {
        _backScrollToTop.constant = -50*5;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
        _backScrollToTop.constant = 0;
}

#pragma mark choose address delegate

-(void)didSelectedBMKPoiInfo:(BMKPoiInfo *) poiInfo
{
    
    NSString *totalAddress = [NSString stringWithFormat:@"%@%@",poiInfo.address,poiInfo.name];
    
    [_delegateReturnData setValue:[NSString stringWithFormat:@"%f,%f",poiInfo.pt.latitude,poiInfo.pt.longitude] forKey:@"cordinate"];
    
    [_targetAddressBt setTitle:totalAddress forState:UIControlStateNormal];
        
    if (_targetAddressBt.frame.size.width < [totalAddress length]*15.0) {
        
        NSInteger letterNumPerLine;
        
        if ((NSInteger)_targetAddressBt.frame.size.width % 15 == 0) {
        
            letterNumPerLine = (NSInteger)_targetAddressBt.frame.size.width % 15;
            
        }else
        {
            letterNumPerLine = (NSInteger)_targetAddressBt.frame.size.width % 15 + 1;
        }
        
        NSInteger lineNum;
        if ([totalAddress length]%letterNumPerLine == 0) {
            lineNum = [totalAddress length]/letterNumPerLine;
        }
        else
        {
            lineNum = [totalAddress length]/letterNumPerLine;
        }
        _line3Height.constant = (lineNum - 1) * 15.0+50;
    }
    
}
-(void)didselectedShopInfo:(NSDictionary *) shopInfo
{
    [_shopAddressBt setTitle:[shopInfo valueForKey:@"customerName"] forState:UIControlStateNormal];
    [self saveHistoryShopSearchAddressWith:[shopInfo valueForKey:@"customerName"]];
    
    [_delegateReturnData setValue:[shopInfo valueForKey:@"customerId"] forKey:@"customerId"];
    [_delegateReturnData setValue:[shopInfo valueForKey:@"coordinate"] forKey:@"cordinate"];
    
    if (_shopAddressBt.frame.size.width < [[shopInfo valueForKey:@"customerName"] length]*15.0) {
        
        NSInteger letterNumPerLine;
        
        if ((NSInteger)_shopAddressBt.frame.size.width % 15 == 0) {
            
            letterNumPerLine = (NSInteger)_shopAddressBt.frame.size.width % 15;
            
        }else
        {
            letterNumPerLine = (NSInteger)_shopAddressBt.frame.size.width % 15 + 1;
        }
        
        NSInteger lineNum;
        if ([[shopInfo valueForKey:@"customerName"] length]%letterNumPerLine == 0) {
            lineNum = [[shopInfo valueForKey:@"customerName"] length]/letterNumPerLine;
        }
        else
        {
            lineNum = [[shopInfo valueForKey:@"customerName"] length]/letterNumPerLine;
        }
        _line2Height.constant = (lineNum - 1) * 15.0+50;
    }

}
-(void)saveHistoryShopSearchAddressWith:(NSString *)shopName
{
    NSMutableArray *tempArray;
    tempArray=[NSMutableArray arrayWithArray:[[SystemConfig shareSystemConfig]getHistoryShopAddressArray]];
    [tempArray removeObject:shopName];
    [tempArray insertObject:shopName atIndex:0];
    if (tempArray.count > 10)
    {
        NSArray *subArray = [tempArray subarrayWithRange:NSMakeRange(0, 10)];
        
        [[SystemConfig shareSystemConfig]saveHistoryShopAddress:subArray];
    }else
    {
        [[SystemConfig shareSystemConfig]saveHistoryShopAddress:tempArray];
    }
}




- (IBAction)callServiceNum:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"拨打客服号码咨询" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    alert.tag = 111;
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 111) {
        if (buttonIndex  == 0) {
            NSURL *servicePhoneNumberUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[[SystemConfig shareSystemConfig]getServiceNumber]]];
            [[UIApplication sharedApplication]openURL:servicePhoneNumberUrl];
        }
    }
}


@end
