//
//  SimpleSwitch.m
//  SpaceHome
//
//  Created by ccSunday on 15/11/23.
//
//

#import "SimpleSwitch.h"

#define kHEIGHT 30
#define KMargin 10 //文字距离背景边框的距离
#define KNoWordsWidth 60  //没有文字时候的宽度
#define KFont [UIFont systemFontOfSize:14.f]
#define KSwitchColor [UIColor colorWithHexString:@"#ffad2d"]

@interface SimpleSwitch(){
    //当前选中的按钮
    UIButton *knobBtn;
}

@end

@implementation SimpleSwitch

/**
 *  模仿系统：不让外面改变自己的尺寸(外界只可以改变位置，不可以改变宽高)
 */
- (void)setFrame:(CGRect)frame{
    if (self.titles) {
        NSUInteger count = self.titles.count;
        
        //取出最长的字符串
        NSString *maxStr = @"";
        
        for (NSString *str in self.titles) {
            maxStr = (maxStr.length < str.length ? str : maxStr);
        }
        
        CGSize maxSize = [maxStr sizeWithAttributes:@{NSFontAttributeName:KFont}];
        CGFloat maxWidth = maxSize.width + KMargin * 2;
        
        [super setFrame:CGRectMake(frame.origin.x, frame.origin.y, maxWidth * count, kHEIGHT)];
        
    }else{
        [super setFrame:CGRectMake(frame.origin.x, frame.origin.y, KNoWordsWidth, kHEIGHT)];
    }
    
}

- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    
    if (_titles == nil) {
        self.size = CGSizeMake(KNoWordsWidth, kHEIGHT);
    }else{
        NSUInteger count = _titles.count;
        
        //取出最长的字符串
        NSString *maxStr = @"";
        
        for (NSString *str in _titles) {
            maxStr = (maxStr.length < str.length ? str : maxStr);
        }
        
        CGSize maxSize = [maxStr sizeWithAttributes:@{NSFontAttributeName:KFont}];
        CGFloat maxWidth = maxSize.width + KMargin * 2;
        
        self.size = CGSizeMake(maxWidth * count, kHEIGHT);
    }
    
    //设置内容
    [self createContents];
}

- (void)setFlag:(NSInteger)flag{
    [self setFlag:flag triggerAction:YES];
}

- (void)setFlag:(NSInteger)flag triggerAction:(BOOL)triggerAction
{
    if (flag < 0) {
        flag = 0;
    }
    _flag = flag;
    
    CGFloat btnWidth = KNoWordsWidth * 0.5;
    if (self.titles) {
        btnWidth = self.width / self.titles.count;
    }
    
    [knobBtn setTitle:self.titles[_flag] forState:UIControlStateNormal];
    knobBtn.frame = CGRectMake(btnWidth * _flag, 0.5, btnWidth, kHEIGHT-1);
    if (triggerAction) {
         [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

//画出所有文字
- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    NSString *str = @"";
    CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:KFont}];
    NSUInteger count = self.titles.count;
    CGFloat width = self.width / count;
    for (int i = 0; i < count; i++) {
        NSString *str = self.titles[i];
        CGRect textRect = CGRectMake(width * i, (kHEIGHT - size.height) * 0.5, width, self.height);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        NSMutableDictionary *attrDic = [NSMutableDictionary dictionary];
        attrDic[NSFontAttributeName] = KFont;
        attrDic[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#878b97"];
        attrDic[NSParagraphStyleAttributeName] = paragraphStyle;
        
        [str drawInRect:textRect withAttributes:attrDic];
    }
    
    UIGraphicsPopContext();
}

/**
 *  创建按钮
 */
- (void)createContents{
    self.backgroundColor = [UIColor clearColor];
    
    knobBtn = [[UIButton alloc] init];
    CGFloat btnWidth = KNoWordsWidth * 0.5;
    if (self.titles) {
        btnWidth = self.width / self.titles.count;
    }
    
    knobBtn.frame = CGRectMake(btnWidth * self.flag, 0.5, btnWidth, kHEIGHT-1);
    [knobBtn setBackgroundColor:KSwitchColor];
    [knobBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (self.titles) {
        [knobBtn setTitle:self.titles[self.flag] forState:UIControlStateNormal];
    }
    knobBtn.titleLabel.font = KFont;
    knobBtn.layer.cornerRadius = knobBtn.height * 0.5;
    [self addSubview:knobBtn];
    
    self.layer.cornerRadius = self.height * 0.5;
    self.layer.borderColor = KSwitchColor.CGColor;
    self.layer.borderWidth = 0.5f;
    self.clipsToBounds = YES;
    
    //添加手势
    //1.点击手势，加到simpleSwitch上
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
    
    //2.拖动手势，加到按钮上
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [knobBtn addGestureRecognizer:panGesture];
}

#pragma mark - UIGestureRecognizer Method
/**
 *  点击手势
 */
- (void)handleTap:(UITapGestureRecognizer *)sender{
    if (self.canNotEdit) {
//        [SVProgressHUD showErrorWithStatus:@"此处不能进行修改"];
        return;
    }
    if(CGRectContainsPoint(knobBtn.frame,[sender locationInView:self]) != YES){
        CGPoint point = [sender locationInView:self];
        NSInteger count = 2;
        if (self.titles) {
            count = self.titles.count;
        }
        int width = self.width / count;
        
        for(int i = 0; i < count; i++ )
        {
            if(point.x > width * i && point.x < width * (i + 1)){
                [UIView animateWithDuration:0.2 animations:^{
                    knobBtn.frame = CGRectMake(width * i, 0, width, self.height);
                } completion:^(BOOL finished) {
                    [knobBtn setTitle:self.titles[i] forState:UIControlStateNormal];
                    self.flag = i;
                    
                    if (self.valueChanged) {
                        self.valueChanged(self.flag);
                    }
                }];
                
            }
        }
    }
}

/**
 *  拖拽手势
 */
- (void)handlePan:(UIPanGestureRecognizer *)sender{
    
    if (self.canNotEdit) {
//        [SVProgressHUD showErrorWithStatus:@"此处不能进行修改"];
        return;
    }
    
    NSInteger count = 2;
    if (self.titles) {
        count = self.titles.count;
    }
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        //1.拖拽中
        CGPoint position = [sender translationInView:self];
        CGPoint center = CGPointMake(knobBtn.centerX + position.x, knobBtn.centerY);
        
        //确保按钮不被拖出框
        if (center.x > knobBtn.width * 0.5 && center.x  < self.width/count * (count - 1) + knobBtn.width * 0.5){
            //改变按钮的中心点位置
            knobBtn.center = center;
            [sender setTranslation:CGPointZero inView:self];
        }
    }else if (sender.state == UIGestureRecognizerStateEnded){
        //2.拖拽结束
        //获得按钮中心点的x坐标
        CGFloat centerX = knobBtn.centerX;
        
        int width = self.width/count;
        for(int i = 0; i < count; i++ ){
            
            if(centerX >= width * i  && centerX <= width * (i+1)){
                [UIView animateWithDuration:0.2 animations:^{
                    knobBtn.frame = CGRectMake(width * i, 0, width, self.height);
                } completion:^(BOOL finished) {
                    [knobBtn setTitle:self.titles[i] forState:UIControlStateNormal];
                    self.flag = i;
                    if (self.valueChanged) {
                        self.valueChanged(self.flag);
                    }
                }];
               
            }
        }
    }
    
}

#pragma mark - 创建方法
+ (instancetype)switchWithTitles:(NSArray *)titles flag:(NSInteger)flag{
    return [[self alloc] initWithTitles:titles flag:flag];
}

- (instancetype)initWithTitles:(NSArray *)titles flag:(NSInteger)flag{
    return [self initWithTitles:titles flag:flag triggerAction:YES];
}

- (instancetype)initWithTitles:(NSArray *)titles flag:(NSInteger)flag triggerAction:(BOOL)triggerAction{
    SimpleSwitch *simpleSwitch = [[SimpleSwitch alloc] init];
    simpleSwitch.titles = titles;
    [simpleSwitch setFlag:flag triggerAction:triggerAction];
    return simpleSwitch;
}

@end
