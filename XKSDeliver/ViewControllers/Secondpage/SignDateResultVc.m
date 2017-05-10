//
//  SignDateResultVc.m
//  XKSDeliver
//
//  Created by 同行必达 on 16/5/6.
//  Copyright © 2016年 同行必达. All rights reserved.
//

#import "SignDateResultVc.h"
#import "NetWorkTool.h"
#import "SystemConfig.h"
#import "SignRecordCell.h"


#define _Button_Gap_ 5
#define _Button_Width_  40
#define _Button_Height_ 40
#define _Button_Num_Inline_ 7

#define _Button_Container_Y_ 104/667.0*_SCREEN_HEIGHT_


@interface SignDateResultVc ()<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy)NSString *checkMonth;
@property (nonatomic,copy)NSString *checkDay;
@property (nonatomic,assign)BOOL isSignOut;

@end

@implementation SignDateResultVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self basicUISetting];
    [self dealData];
    [self connectData];
}
-(void)basicUISetting
{
    if ([_fromWhich isEqualToString:@"account"]) {
        
        _pageTitleLb.text = @"签到记录";
        
    }else if ([_fromWhich isEqualToString:@"orderlist"])
    {
        _pageTitleLb.text = @"每日单量";
    }
}
-(void)dealData
{
    _signDataSource  = [[NSArray alloc]init];
    _signPerDaySource = [[NSArray alloc]init];
    
    if ([_fromWhich isEqualToString:@"account"]) {
        
        _checkMonth = [self dateToString:[NSDate date]];
        
    }else if ([_fromWhich isEqualToString:@"orderlist"])
    {
        NSDateFormatter *checkParamFomatter =[[NSDateFormatter alloc]init];
        [checkParamFomatter setDateFormat:@"yyyy-MM-dd"];
        NSString *resultString = [checkParamFomatter stringFromDate:[NSDate date]];
        _checkMonth = resultString;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    
    _maxDay = range.length;
    
}

-(void)connectData
{

    if ([_fromWhich isEqualToString:@"account"]) {
        [self connnectSignDateResult];
        
    }else if ([_fromWhich isEqualToString:@"orderlist"])
    {
        [self connnectOrderNumPerDayResult];
    }
}

#pragma mark utility

-(NSDate *)stringToDate:(NSString *)Stringdate
{
    NSDateFormatter *checkParamFomatter =[[NSDateFormatter alloc]init];
    [checkParamFomatter setDateFormat:@"yyyy-MM"];
    NSDate *dateFromString = [checkParamFomatter dateFromString:Stringdate];
   // NSDate *localDate = [dateFromString dateByAddingTimeInterval:3600*8];
    
    return dateFromString;
}

-(NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter *checkParamFomatter =[[NSDateFormatter alloc]init];
    [checkParamFomatter setDateFormat:@"yyyy-MM"];
    NSString *resultString = [checkParamFomatter stringFromDate:date];
    
    return resultString;
}

-(void)deployCalender
{
    for (UIView *view in [_backView subviews]) {
        [view removeFromSuperview];
    }
    
    _displayMonthLb.text = _checkMonth;
    //  控制宏在上方
    //  deal last line
    NSInteger ADDLINE;
    if (_signDataSource.count%7==0) {
        ADDLINE = 0;
    }else
    {
        ADDLINE = 1;
    }
    
    UIView *buttonContainer = [[UIView alloc]initWithFrame:CGRectMake(
                                                                      (_SCREEN_WIDTH_
                                                                       -(_Button_Num_Inline_*_Button_Width_
                                                                         +
                                                                         (_Button_Num_Inline_-1)
                                                                         *_Button_Gap_))/2.0,
                                                                      0,
                                                                      _Button_Width_*_Button_Num_Inline_+_Button_Gap_*(_Button_Num_Inline_-1),
                                                                      _Button_Height_*(_signDataSource.count/_Button_Num_Inline_+ADDLINE)+_Button_Gap_*(_signDataSource.count/_Button_Num_Inline_+ADDLINE-1))];
    buttonContainer.backgroundColor = [UIColor clearColor];
    
    NSInteger TAG = 0;
    
    for (int VERTICAL=0; VERTICAL < _signDataSource.count/_Button_Num_Inline_+ADDLINE; VERTICAL++) {
        
        NSInteger NUM_INLINE_ADD_EXCEPTION;
        //deal the last line
        if ((VERTICAL+1)==(_signDataSource.count/_Button_Num_Inline_)+ADDLINE) {
            
            if (_signDataSource.count==0) {
                NUM_INLINE_ADD_EXCEPTION = _signDataSource.count%_Button_Num_Inline_;
            }
            else if(_signDataSource.count%_Button_Num_Inline_==0)
            {
                NUM_INLINE_ADD_EXCEPTION = _Button_Num_Inline_;
            }
            else
            {
                NUM_INLINE_ADD_EXCEPTION = _signDataSource.count%_Button_Num_Inline_;
            }
        }else
        {
            NUM_INLINE_ADD_EXCEPTION = _Button_Num_Inline_;
        }
        
        for (int HORIZON= 0; HORIZON < NUM_INLINE_ADD_EXCEPTION; HORIZON++) {
            UIButton *singleButton = [[UIButton alloc]initWithFrame:CGRectMake(HORIZON*(_Button_Width_+_Button_Gap_), (_Button_Height_+_Button_Gap_)*VERTICAL, _Button_Width_, _Button_Height_)];
            
            singleButton.backgroundColor = [UIColor clearColor];
            singleButton.layer.cornerRadius = 5;
            singleButton.layer.borderColor = [UIColor blackColor].CGColor;
            singleButton.tag                =TAG;
            singleButton.titleLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:22.0];
            [singleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [singleButton setTitle:[NSString stringWithFormat:@"%ld",TAG+1]forState:UIControlStateNormal];
            
            [singleButton setTitleColor:RGBCOLOR(180, 180, 180) forState:UIControlStateNormal];
            if ([_fromWhich isEqualToString:@"account"]) {
                [singleButton setTitleColor:RGBCOLOR(1,1,1) forState:UIControlStateNormal];
            }
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
            NSDateFormatter *formatter2 = [[NSDateFormatter alloc]init];
            [formatter1 setDateFormat:@"dd"];
            [formatter2 setDateFormat:@"MM"];
            NSString *nowDayString = [formatter1 stringFromDate:[NSDate date]];
            NSString *nowMonthString = [formatter2 stringFromDate:[NSDate date]];
            
          if (TAG+1 > [nowDayString integerValue]&&[[_checkMonth substringFromIndex:5]isEqualToString:nowMonthString]) {
                [_nextMonthBt setTitle:@"当前月" forState:UIControlStateNormal];
                _nextMonthBt.userInteractionEnabled = NO;
                [singleButton setTitleColor:RGBCOLOR(230, 230, 230) forState:UIControlStateNormal];
              singleButton.userInteractionEnabled = NO;
                //singleButton.backgroundColor = [UIColor grayColor];
            }else if ([[_joinWorkDate substringToIndex:7]isEqualToString:_checkMonth]&&TAG+1<[[_joinWorkDate substringFromIndex:8]integerValue]){
                [singleButton setTitleColor:RGBCOLOR(230, 230, 230) forState:UIControlStateNormal];
                singleButton.userInteractionEnabled = NO;
               // singleButton.backgroundColor = [UIColor grayColor];
            }
            else
            {
                [_nextMonthBt setTitle:@"下个月" forState:UIControlStateNormal];
                _nextMonthBt.userInteractionEnabled = YES;
                
                if ([_fromWhich isEqualToString:@"account"]) {
                    if ([[[_signDataSource objectAtIndex:TAG]stringValue]isEqualToString:@"0"]) {
                        
                        [singleButton setImage:[UIImage imageNamed:@"unsign" ]forState:UIControlStateNormal];
                        //singleButton.backgroundColor = [UIColor redColor];
                        
                    }else if ([[_signDataSource objectAtIndex:TAG]integerValue] > 0)
                    {
                        [singleButton setImage:[UIImage imageNamed:@"sign"] forState:UIControlStateNormal];
                        // singleButton.backgroundColor = [UIColor greenColor];
                    }
                    
                    [singleButton addTarget:self action:@selector(checkThisDay:) forControlEvents:UIControlEventTouchDown];

                }else
                {
                    // 2015-05-12
                    
                    if ([[_checkDay substringFromIndex:8]integerValue]==TAG+1) {
                        
                        NSString *dayString = [NSString stringWithFormat:@"%ld ",TAG+1];
                        NSString *ordernum = [_signDataSource objectAtIndex:TAG];
                        NSString *totalString = [NSString stringWithFormat:@"%@%@",dayString,ordernum];
                        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:totalString];
                        NSRange range1 = NSMakeRange(0, [dayString length]);
                        NSRange range2 = NSMakeRange([dayString length], [ordernum length]);
                        NSDictionary *attributeDict = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:16.0]};
                        NSDictionary *attributeDict2 = @{NSForegroundColorAttributeName:RGBCOLOR(79, 150, 21),NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]};
                        [attributeString addAttributes:attributeDict range:range1];
                        [attributeString addAttributes:attributeDict2 range:range2];
                        [singleButton setAttributedTitle:attributeString forState:UIControlStateNormal];
                        
                    }
                    [singleButton addTarget:self action:@selector(checkThisDay:) forControlEvents:UIControlEventTouchDown];
                }
            }
            singleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -singleButton.titleLabel.intrinsicContentSize.width);
            singleButton.titleEdgeInsets = UIEdgeInsetsMake(0, -singleButton.imageView.frame.size.width, 0, 0);
            TAG++;
            [buttonContainer addSubview:singleButton];
        }
    }
    
    UIScrollView *backScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, _SCREEN_WIDTH_,_Button_Height_*(_signDataSource.count/_Button_Num_Inline_+ADDLINE)+_Button_Gap_*(_signDataSource.count/_Button_Num_Inline_+ADDLINE-1)+2)];
    
    
    backScroll.contentSize    = CGSizeMake(_SCREEN_WIDTH_,                                                                       _Button_Height_*(_signDataSource.count/_Button_Num_Inline_+ADDLINE)+_Button_Gap_*(_signDataSource.count/_Button_Num_Inline_+ADDLINE-1)+2);
    
    [backScroll addSubview:buttonContainer];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,_Button_Height_*(_signDataSource.count/_Button_Num_Inline_+ADDLINE)+_Button_Gap_*(_signDataSource.count/_Button_Num_Inline_+ADDLINE-1)+3, _SCREEN_WIDTH_, 1)];
    lineView.backgroundColor = RGBCOLOR(246, 246, 246);
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,_Button_Height_*(_signDataSource.count/_Button_Num_Inline_+ADDLINE)+_Button_Gap_*(_signDataSource.count/_Button_Num_Inline_+ADDLINE-1)+4, _SCREEN_WIDTH_, 40)];
    
    UIButton *thisMonthSign = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH_, 40)];
    [thisMonthSign setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    thisMonthSign.backgroundColor = RGBCOLOR(39, 91, 187) ;
    [thisMonthSign setTitle:@"查看当月记录" forState:UIControlStateNormal];
    [thisMonthSign addTarget:self action:@selector(toThisMonth:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIView *signIn = [[UIView alloc]initWithFrame:CGRectMake(0, 45, _SCREEN_WIDTH_, 40)];
//    
//    UILabel *signInLb = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 80, 30)];
//    signInLb.layer.cornerRadius = 5;
//    signInLb.layer.masksToBounds = YES;
//    signInLb.backgroundColor = RGBCOLOR(232, 121, 91);
//    signInLb.text = @"签到";
//    signInLb.textAlignment = NSTextAlignmentCenter;
//    signInLb.textColor = [UIColor whiteColor];
//    [signIn addSubview:signInLb];
//    
//    UILabel *signTime = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, _SCREEN_WIDTH_-85, 30)];
//    signTime.text = @"2011.9.1";
//    [signIn addSubview:signTime];
//    
//    UIView *signOut = [[UIView alloc]initWithFrame:CGRectMake(0, 80, _SCREEN_WIDTH_, 40)];
//    UILabel *signOutLb = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 80, 30)];
//    signOutLb.layer.cornerRadius = 5;
//    signOutLb.layer.masksToBounds = YES;
//    signOutLb.backgroundColor = RGBCOLOR(102, 172, 19);
//    signOutLb.text = @"签退";
//    signOutLb.textAlignment = NSTextAlignmentCenter;
//    signOutLb.textColor = [UIColor whiteColor];
//    [signOut addSubview:signOutLb];
//    
//    UILabel *quitTime = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, _SCREEN_WIDTH_-85, 30)];
//    quitTime.text = @"2011.9.1";
//    [signOut addSubview:quitTime];
    
    [bottomView addSubview:thisMonthSign];
    
    UITableView *daySignRecord = [[UITableView alloc]initWithFrame:CGRectMake(0, _Button_Height_*(_signDataSource.count/_Button_Num_Inline_+ADDLINE)+_Button_Gap_*(_signDataSource.count/_Button_Num_Inline_+ADDLINE-1)+4+40, _SCREEN_WIDTH_, _SCREEN_HEIGHT_ - (_Button_Height_*(_signDataSource.count/_Button_Num_Inline_+ADDLINE)+_Button_Gap_*(_signDataSource.count/_Button_Num_Inline_+ADDLINE-1)+4+40+49+64+40)) style:UITableViewStylePlain];
    
    daySignRecord.delegate = self;
    daySignRecord.dataSource = self;
    daySignRecord.hidden = YES;
    
    daySignRecord.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _daySignRecordTbView = daySignRecord;
    
    daySignRecord.delegate = self;
    daySignRecord.dataSource = self;
    
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0,_Button_Height_*(_signDataSource.count/_Button_Num_Inline_+ADDLINE)+_Button_Gap_*(_signDataSource.count/_Button_Num_Inline_+ADDLINE-1)+4+40+1, _SCREEN_WIDTH_, 2)];
    lineView2.backgroundColor = RGBCOLOR(246, 246, 246);
    
    bottomView.backgroundColor = [UIColor whiteColor];
    
    [_backView addSubview:lineView];
    [_backView addSubview:lineView2];
    [_backView addSubview:bottomView];
    [_backView addSubview:backScroll];
    [_backView addSubview:daySignRecord];
    
    
}

#pragma mark tableview  delegate datesource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SignRecordCell *signRecordCell = [SignRecordCell getTableView:tableView];
    
    //NSLog(@"********%@",[[[_signPerDaySource objectAtIndex:indexPath.row]objectAtIndex:3]class]);
    
    if ([[[_signPerDaySource objectAtIndex:indexPath.row]objectAtIndex:3]integerValue] == 0) {
    signRecordCell.signTypeLb.text = @"签退";
    signRecordCell.signTypeLb.backgroundColor = RGBCOLOR(102, 172, 19);
    }else
    {
    signRecordCell.signTypeLb.text = @"签到";
    signRecordCell.signTypeLb.backgroundColor = RGBCOLOR(232, 121, 91);
        //RGBCOLOR(232, 121, 91)
    }
    signRecordCell.signTimeLb.text = [NSString stringWithFormat:@"%@ 【%@】",[[_signPerDaySource objectAtIndex:indexPath.row]objectAtIndex:2],[[_signPerDaySource objectAtIndex:indexPath.row]objectAtIndex:1]];
    signRecordCell.signTypeLb.layer.cornerRadius = 5;
    signRecordCell.signTypeLb.layer.masksToBounds = YES;
    
    return signRecordCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  _CELL_HEIGHT_;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _signPerDaySource.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}




-(void)toThisMonth:(UIButton *)sender
{
    
    if ([_checkMonth isEqualToString:[self dateToString:[NSDate date]]]) {
        return;
    }
    
    [self dealData];
    
    if ([_fromWhich isEqualToString:@"account"]) {
        [self connnectSignDateResult];
    }else
    {
        NSDateFormatter *checkParamFomatter =[[NSDateFormatter alloc]init];
        [checkParamFomatter setDateFormat:@"yyyy-MM-dd"];
        NSString *resultString = [checkParamFomatter stringFromDate:[NSDate date]];
        _checkMonth = resultString;
        [self connnectOrderNumPerDayResult];
    }
}

-(void)connnectSignDateResult
{
    __weak typeof(self) this = self;
    /*
     数组元素>0  含有签到记录  0 是未签到
     */
   
    [NetWorkTool getRequestWithUrl:_SignResult_ param:@{@"driverIMEI": [[SystemConfig shareSystemConfig]getDeviceToken],@"attendRecordMonth":_checkMonth} addProgressHudOn:self.view Tip:@"签到详情" successReturn:^(id successReturn) {

        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        if ([[jsonDict valueForKey:@"result"]isEqualToString:@"true"]) {
            _signDataSource = [jsonDict valueForKey:@"data"];
            _maxDay = [[jsonDict valueForKey:@"maxDay"]integerValue];
            _checkMonth = [jsonDict valueForKey:@"attendRecordMonth"];
        }else
        {
            _signDataSource = @[];
            ALERT_HUD(self.view,jsonDict[@"msg"]);
        }
        
        if ([[jsonDict valueForKey:@"isSignOut"]isEqualToString:@"Y"]) {
            _isSignOut = YES;
        }else
        {
            _isSignOut = NO;
        }
        
        _joinWorkDate = [jsonDict valueForKey:@"hireDate"];
        if ([[[jsonDict valueForKey:@"hireDate"]substringToIndex:7]isEqualToString:_checkMonth]) {
            [_lastMonthBt setTitle:@"入职月" forState:UIControlStateNormal];
            _lastMonthBt.userInteractionEnabled = NO;
        }else{
            [_lastMonthBt setTitle:@"上个月" forState:UIControlStateNormal];
            _lastMonthBt.userInteractionEnabled = YES;
        }
        
        [this deployCalender];
        
    } failed:^(id failed) {
        
    }];
}

-(void)connnectSignDateResultWithDay:(NSInteger)day
{
    __weak typeof(self) this = self;
    
    NSString *date;
    
    if (day+1 > 9) {
        date = [NSString stringWithFormat:@"%ld",day + 1];
        
    }else{
        date = [NSString stringWithFormat:@"0%ld",day +1];
    }
    
    /*
     数组元素>0  含有签到记录  0 是未签到
     */
    NSString *requeststr = [NSString stringWithFormat:@"%@/%@",_SignResult_,[[SystemConfig shareSystemConfig]getDeviceToken]];
    
    [NetWorkTool getRequestWithUrl:requeststr param:@{@"attendRecordMonth":_checkMonth,@"day":date,@"timestamp":[NSString stringWithFormat:@"%@",[NSDate date]]} addProgressHudOn:self.view Tip:@"签到详情" successReturn:^(id successReturn) {
        
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];

        //        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        if ([[jsonDict valueForKey:@"result"]isEqualToString:@"true"]) {
            
            _daySignRecordTbView.hidden = NO;
            
        }else
        {
            _daySignRecordTbView.hidden = YES;
            ALERT_VIEW([jsonDict valueForKey:@"msg"]);
        }
        
        _signPerDaySource = [jsonDict valueForKey:@"details"];
        [_daySignRecordTbView reloadData];
        
        NSLog(@"checkTodaySignNum  %lu",(unsigned long)_signPerDaySource.count);
        
    
    } failed:^(id failed) {
        
    }];
}


-(void)connnectOrderNumPerDayResult
{
    
    __weak typeof(self) this = self;
    
    [NetWorkTool getRequestWithUrl:_orderNum_ param:@{@"driverIMEI":[[SystemConfig shareSystemConfig]getDeviceToken],@"attendRecordDay":_checkMonth} addProgressHudOn:self.view Tip:@"查询日单量" successReturn:^(id successReturn) {
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:[[NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingAllowFragments error:nil]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:successReturn options:NSJSONReadingMutableContainers error:nil];

        if ([[jsonDict valueForKey:@"result"]isEqualToString:@"true"]) {
            _signDataSource = [jsonDict valueForKey:@"data"];
            _maxDay = [[jsonDict valueForKey:@"maxDay"]integerValue];
            _checkMonth = [jsonDict valueForKey:@"attendRecordMonth"];
            _checkDay = [jsonDict valueForKey:@"attendRecordDay"];
        }else
        {
            _signDataSource = @[];
        }
        _joinWorkDate = [jsonDict valueForKey:@"hireDate"];
        if ([[[jsonDict valueForKey:@"hireDate"]substringToIndex:7]isEqualToString:_checkMonth]) {
            [_lastMonthBt setTitle:@"入职月" forState:UIControlStateNormal];
            _lastMonthBt.userInteractionEnabled = NO;
        }else{
            [_lastMonthBt setTitle:@"上个月" forState:UIControlStateNormal];
            _lastMonthBt.userInteractionEnabled = YES;
        }
        
        [this deployCalender];
        
    } failed:^(id failed) {
        
    }];
}


-(void)checkThisDay:(UIButton *)sender
{
    
    if ([_fromWhich isEqualToString:@"account"]) {

        if (_isSignOut) {
            [self connnectSignDateResultWithDay:sender.tag];
        }
        
    }else if ([_fromWhich isEqualToString:@"orderlist"])
    {
        if (sender.tag+1 > 9) {
            _checkMonth = [NSString stringWithFormat:@"%@-%ld",_checkMonth,sender.tag+1];
            
        }else{
            _checkMonth = [NSString stringWithFormat:@"%@-0%ld",_checkMonth,sender.tag+1];
        }
        [self connnectOrderNumPerDayResult];
    }
}

- (IBAction)checkLastMonth:(UIButton *)sender {
    
    [self addOrDeleteOneDay:@"-"];
    
    if ([_fromWhich isEqualToString:@"account"]) {
        [self connnectSignDateResult];
    }else
    {
        _checkMonth = [NSString stringWithFormat:@"%@-01",_checkMonth];
        [self connnectOrderNumPerDayResult];
    }
    
}

- (IBAction)checkNextMonth:(UIButton *)sender {
    [self addOrDeleteOneDay:@"+"];
    if ([_fromWhich isEqualToString:@"account"]) {
        [self connnectSignDateResult];
    }else
    {
        _checkMonth = [NSString stringWithFormat:@"%@-01",_checkMonth];
        [self connnectOrderNumPerDayResult];
    }

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



-(void)addOrDeleteOneDay:(NSString *)deal
{
    if ([deal isEqualToString:@"+"]) {
        
        if ([[_checkMonth substringFromIndex:5]isEqualToString:@"12"]) {
           NSInteger year = [[_checkMonth substringToIndex:4]integerValue]+1;
            _checkMonth = [NSString stringWithFormat:@"%ld-%@",(long)year,@"01"];
            NSLog(@"");
        }else
        {
            NSInteger day = [[_checkMonth substringFromIndex:5]integerValue]+1;

            if (day > 9) {
                _checkMonth = [NSString stringWithFormat:@"%@-%ld",[_checkMonth substringToIndex:4],(long)(day)];
            }else
            {
                _checkMonth = [NSString stringWithFormat:@"%@-0%ld",[_checkMonth substringToIndex:4],(long)(day)];
            }
            
        }
    }
    else if ([deal isEqualToString:@"-"])
    {
        if ([[_checkMonth substringFromIndex:5]isEqualToString:@"01"]) {
            NSInteger year = [[_checkMonth substringToIndex:4]integerValue]-1;
            
            _checkMonth = [NSString stringWithFormat:@"%ld-%@",(long)year,@"12"];
            NSLog(@"");
        }else
        {
            NSInteger day = [[_checkMonth substringFromIndex:5]integerValue]-1;
            
            if (day > 9) {
                _checkMonth = [NSString stringWithFormat:@"%@-%ld",[_checkMonth substringToIndex:4],(long)(day)];
            }else
            {
                _checkMonth = [NSString stringWithFormat:@"%@-0%ld",[_checkMonth substringToIndex:4],(long)(day)];
            }
            
            NSLog(@"");
        }
    }
}



@end
