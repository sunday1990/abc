//
//  ShareView.m
//  SpaceHome
//
//  Created by apple on 15/10/29.
//
//

#import "ShareView.h"
#import "SharesBtn.h"
#import "UMSocialDataService.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialData.h"
#import <MessageUI/MessageUI.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
@interface ShareView ()<MFMessageComposeViewControllerDelegate>
{
    UIView *_shareBgView;
  
}
/**
 *  分享的页面
 */
@property (nonatomic, strong) UIViewController *controller;
/**
 *  分享标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  分享图片
 */
@property (nonatomic, strong) NSData *imageData;
/**
 *  分享链接
 */
@property (nonatomic, copy) NSString *url;
/**
 *  发送信息页面
 */
@property (nonatomic, strong) MFMessageComposeViewController *messageComposeVc;
/**
 *  分享链接
 */
@property (nonatomic, copy) NSString *content;
@end

@implementation ShareView
singletonImplementation(ShareView)

- (void)shareViewWithController:(UIViewController *)controller title:(NSString *)title content:(NSString *)content image:(NSString *)imageName url:(NSString *)ur
{
    self.backgroundColor = [UIColor clearColor];
    self.frame = [UIScreen mainScreen].bounds;
    
    _controller = controller;
    _title = title;
    _content = content;
    if ([imageName rangeOfString:@"http"].length > 0) {
        _imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageName]]];
    }else{
        _imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",imageName]]];
    }
    if( _imageData == nil )
        _imageData = UIImagePNGRepresentation([UIImage imageNamed:@"icon"]);
    _url = ur;
    
    UIView *window = _controller.view;
    
    [window addSubview:self];
    
    //蒙板
    UIView *alphaView = [MyControl viewWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH_, _SCREEN_HEIGHT_)];
    alphaView.backgroundColor = GetColor(blackColor);
    alphaView.alpha = 0.5;
    [self addSubview:alphaView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
    [alphaView addGestureRecognizer:tap];
    
    //分享面板
    _shareBgView = [MyControl viewWithFrame:CGRectMake(0, _SCREEN_HEIGHT_, _SCREEN_WIDTH_, 264)];
    _shareBgView.backgroundColor = [UIColor colorWithHexString:@"0xf1f1f1"];
    [self addSubview:_shareBgView];
    
//    UIView *lineView = [MyControl viewWithFrame:CGRectMake(0, 0, _shareBgView.width, 4)];
//    lineView.backgroundColor = RGB(177, 177, 177);
//    [_shareBgView addSubview:lineView];
    
    //取消
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(0, _shareBgView.height - 44, _shareBgView.width, 44);
    cancleBtn.backgroundColor =GetColor(whiteColor);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = GetFont(18);
    [cancleBtn setTitleColor:[UIColor colorWithHexString:@"0x333333"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [_shareBgView addSubview:cancleBtn];
    
    NSArray *imagesArr = @[@"qq",@"qqkongjian",@"weixin",@"pengyouquan",@"sina",@"duanxin",@"lianjie"];
    NSArray *titlesArr = @[@"QQ",@"QQ空间",@"微信",@"朋友圈",@"新浪微博",@"短信",@"复制链接"];
    
    CGFloat shareViewH = _shareBgView.height - 44 - 4;
    
    for (int i = 0; i < imagesArr.count; i++) {
        SharesBtn *btn = [SharesBtn buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((_SCREEN_WIDTH_/4)*(i%4), (shareViewH/2)*(i/4), _SCREEN_WIDTH_/4, shareViewH/2);
        [btn setImage:GetImage(imagesArr[i]) forState:UIControlStateNormal];
        [btn setTitle:titlesArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
        btn.tag = 231 + i;
        [btn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_shareBgView addSubview:btn];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _shareBgView.frame = CGRectMake(0, _SCREEN_HEIGHT_ - 264, _SCREEN_WIDTH_, 264);
    }];
}

- (void)shareViewWithController:(UIViewController *)controller title:(NSString *)title content:(NSString *)content image:(NSString *)imageName url:(NSString *)url filtersIndex:(NSArray *)index{
    NSArray *imagesArr = @[@"qq",@"qqkongjian",@"weixin",@"pengyouquan",@"sina",@"duanxin",@"lianjie"];
    NSArray *titlesArr = @[@"QQ",@"QQ空间",@"微信",@"朋友圈",@"新浪微博",@"短信",@"复制链接"];

    self.backgroundColor = [UIColor clearColor];
    self.frame = [UIScreen mainScreen].bounds;
    
    _controller = controller;
    _title = title;
    _content = content;
    if ([imageName rangeOfString:@"http"].length > 0) {
        _imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageName]]];
    }else{
        _imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",imageName]]];
    }
    if( _imageData == nil )
        _imageData = UIImagePNGRepresentation([UIImage imageNamed:@"icon"]);
    _url = url;
    
    UIView *window = _controller.view;
    
    [window addSubview:self];
    
    //蒙板
    UIView *alphaView = [MyControl viewWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH_, _SCREEN_HEIGHT_)];
    alphaView.backgroundColor = GetColor(blackColor);
    alphaView.alpha = 0.5;
    [self addSubview:alphaView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
    [alphaView addGestureRecognizer:tap];
    
    //分享面板
    _shareBgView = [MyControl viewWithFrame:CGRectMake(0, _SCREEN_HEIGHT_, _SCREEN_WIDTH_, 264)];
    _shareBgView.backgroundColor = [UIColor colorWithHexString:@"0xf1f1f1"];
    [self addSubview:_shareBgView];
    
//    UIView *lineView = [MyControl viewWithFrame:CGRectMake(0, 0, _shareBgView.width, 4)];
//    lineView.backgroundColor = RGB(177, 177, 177);
//    [_shareBgView addSubview:lineView];
    
    //取消
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(0, _shareBgView.height - 44, _shareBgView.width, 44);
    cancleBtn.backgroundColor =GetColor(whiteColor);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = GetFont(18);
    [cancleBtn setTitleColor:[UIColor colorWithHexString:@"0x333333"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [_shareBgView addSubview:cancleBtn];
    
    CGFloat shareViewH = _shareBgView.height - 44 - 4;
    
    for (int i = 0; i < index.count; i++) {
        SharesBtn *btn = [SharesBtn buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((WIDTH/4)*(i%4), (shareViewH/2)*(i/4), WIDTH/4, shareViewH/2);
        [btn setImage:GetImage(imagesArr[[index[i] integerValue]]) forState:UIControlStateNormal];
        
        [btn setTitle:titlesArr[[index[i] integerValue]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
        btn.tag = 231 + [index[i] integerValue];
        [btn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_shareBgView addSubview:btn];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _shareBgView.frame = CGRectMake(0, HEIGHT - 264, WIDTH, 264);
    }];




}

- (void)shareViewWithController:(UIViewController *)controller title:(NSString *)title image:(NSString *)imageName url:(NSString *)url{
    
    [self shareViewWithController:controller title:title content:@"我在空间家APP上找到一个好位置，地段好又划算，快来看看吧！" image:imageName url:url];
   
}
- (void)shareViewRatioWithController:(UIViewController *)controller title:(NSString *)title image:(NSString *)imageName url:(NSString *)url
{
    _controller = controller;
    _title = title;
    _content = @"无需亲临现场，720度无死角，带您身临其境!";
    _imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",imageName]]];
    _url = url;
    
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *window = _controller.view;
    //蒙板
    UIView *alphaView = [MyControl viewWithFrame:CGRectMake(0, 0, HEIGHT, WIDTH)];
    alphaView.backgroundColor = GetColor(blackColor);
    alphaView.alpha = 0.5;
    [window addSubview:alphaView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
    [alphaView addGestureRecognizer:tap];
    
    //分享面板
    int svHeight = 260;
    int lvHeight = 4;
    int btnHegiht = 44;
    int sbHeight = (svHeight-lvHeight-btnHegiht)/2;
    _shareBgView = [MyControl viewWithFrame:CGRectMake((HEIGHT-WIDTH)/2, WIDTH - svHeight, WIDTH, svHeight)];
    _shareBgView.backgroundColor = [UIColor colorWithHexString:@"0xf1f1f1"];
    [window addSubview:_shareBgView];
//    UIView *lineView = [MyControl viewWithFrame:CGRectMake(0, 0, WIDTH, 4)];
//    lineView.backgroundColor = RGB(177, 177, 177);
//    [_shareBgView addSubview:lineView];
    
    NSArray *imagesArr = @[@"qq",@"qqkongjian",@"weixin",@"pengyouquan",@"sina",@"duanxin",@"lianjie"];
    NSArray *titlesArr = @[@"QQ",@"QQ空间",@"微信",@"朋友圈",@"新浪微博",@"短信",@"复制链接"];
    
    for (int i = 0; i < imagesArr.count; i++) {
        SharesBtn *btn = [SharesBtn buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((WIDTH/4)*(i%4), lvHeight+sbHeight*(i/4), WIDTH/4, sbHeight);
        [btn setImage:GetImage(imagesArr[i]) forState:UIControlStateNormal];
        [btn setTitle:titlesArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
        btn.tag = 231 + i;
        [btn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_shareBgView addSubview:btn];
    }
    
    //取消
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(0, svHeight-btnHegiht, WIDTH, btnHegiht);
    cancleBtn.backgroundColor =GetColor(whiteColor);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = GetFont(18);
    [cancleBtn setTitleColor:[UIColor colorWithHexString:@"0x333333"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [_shareBgView addSubview:cancleBtn];

}

- (void)clickShareBtn:(SharesBtn *)btn{
    
    NSInteger platformIndex = btn.tag - 231;
    if( _imageData == nil )
    {
        _imageData = [NSData dataWithData:UIImagePNGRepresentation([UIImage imageNamed:@"share_default"])];
    }
    switch (platformIndex) {
        case 0:
        {
            //分享到QQ
            [self shareToQQ];
        }
            break;
        case 1:
        {
            //分享到QQ空间
            [self shareToQZone];
        }
            break;
        case 2:
        {
           //分享到微信
            [self shareToWeChat];
        }
            break;
        case 3:
        {
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
            //分享到朋友圈
            [self shareToFriendsCircle];
        }
            break;
        case 4:
        {
            //分享到新浪微博
//            [self shareToSina];
        }
            break;
        case 5:
        {
            //分享到短信
            [self shareToMessage];
        }
            break;
        case 6:
        {
            //复制链接
            [self copyUrl];
        }
            break;

        default:
            break;
    }
}

/**
 *  取消
 */
- (void)cancel{
    [UIView animateWithDuration:0.3 animations:^{
        _shareBgView.frame = CGRectMake(0, HEIGHT , WIDTH, _shareBgView.height);
    }completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

/**
 *  分享到QQ
 */
- (void)shareToQQ{
    
    [self cancel];
    if ( ![QQApiInterface isQQInstalled]) {
//        [MBProgressHUD showErrorWithStatus:@"未安装QQ！"];
        ALERT_HUD(self.controller.view, @"未安装QQ！");
        return;
    }

    [[UMSocialDataService defaultDataService] socialData].extConfig.title = _title;
    [UMSocialData defaultData].extConfig.qqData.url = _url;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:_content image:_imageData location:nil urlResource:nil presentedController:_controller completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            
            NSString *shareName = [[shareResponse.data allKeys] objectAtIndex:0];
            
            if ([shareName isEqual:@"qq"]) {
                [UMSocialData defaultData].extConfig.qqData.url = _url;
            } else if ([shareName isEqual:@"qzone"]) {
                [UMSocialData defaultData].extConfig.qzoneData.url = _url;
            }
        }
    }];
}

/**
 *  分享到QQ空间
 */
- (void)shareToQZone{
    [self cancel];
    if ( ![QQApiInterface isQQInstalled]) {
//        [SVProgressHUD showErrorWithStatus:@"未安装QQ！"];
        ALERT_HUD(self.controller.view, @"未安装QQ！");
        return;
    }

    [[UMSocialDataService defaultDataService] socialData].extConfig.title = _title;
    [UMSocialData defaultData].extConfig.qzoneData.url = _url;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:_content image:_imageData location:nil urlResource:nil presentedController:_controller completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            
            NSString *shareName = [[shareResponse.data allKeys] objectAtIndex:0];
            
            if ([shareName isEqual:@"qq"]) {
                [UMSocialData defaultData].extConfig.qqData.url = _url;
            } else if ([shareName isEqual:@"qzone"]) {
                [UMSocialData defaultData].extConfig.qzoneData.url = _url;
            }
        }
    }];
}

/**
 *  分享到微信
 */
- (void)shareToWeChat{
    [self cancel];
    if(![WXApi isWXAppInstalled])
    {
//        [SVProgressHUD showErrorWithStatus:@"未安装微信！"];
        ALERT_HUD(self.controller.view, @"未安装微信！");

        return;
    }
   
    [[UMSocialDataService defaultDataService] socialData].extConfig.title = _title;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = _url;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_content image:_imageData location:nil urlResource:nil presentedController:_controller completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            
            NSString *shareName = [[shareResponse.data allKeys] objectAtIndex:0];
            
            if ([shareName isEqual:@"wxtimeline"]) {
                
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _url;
            } else if ([shareName isEqual:@"wxsession"]) {
                
                [UMSocialData defaultData].extConfig.wechatSessionData.url = _url;
            }
        }
    }];
}

/**
 *  分享到朋友圈
 */
- (void)shareToFriendsCircle{
    [self cancel];
    if(![WXApi isWXAppInstalled])
    {
//        [SVProgressHUD showErrorWithStatus:@"未安装微信！"];
        ALERT_HUD(self.controller.view, @"未安装微信！");

        return;
    }
    
    [[UMSocialDataService defaultDataService] socialData].extConfig.title = _title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = _url;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_content image:_imageData location:nil urlResource:nil presentedController:_controller completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            
            NSString *shareName = [[shareResponse.data allKeys] objectAtIndex:0];
            
            if ([shareName isEqual:@"wxtimeline"]) {
                
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _url;
            } else if ([shareName isEqual:@"wxsession"]) {
                
                [UMSocialData defaultData].extConfig.wechatSessionData.url = _url;
            }
        }
    }];
}


/**
 *  分享到短信
 */
- (void)shareToMessage{
    
    [self cancel];
    
    //检测设备有没有发短信的功能
    if([MFMessageComposeViewController canSendText]){
        
        if (_messageComposeVc == nil) {
            MFMessageComposeViewController *messageComposeVc = [[MFMessageComposeViewController alloc] init];
            _messageComposeVc = messageComposeVc;
        }
        
        _messageComposeVc.body = [NSString stringWithFormat:@"空间家：%@%@",_title,_url];
        _messageComposeVc.messageComposeDelegate = self;
        
        UIViewController *viewController = [[_messageComposeVc viewControllers] lastObject];
        UINavigationBar *navigationBar = viewController.navigationController.navigationBar;
        
        //取消的颜色
        navigationBar.tintColor = [UIColor orangeColor];
        
        //新信息的颜色
        NSMutableDictionary *attributesMd = [NSMutableDictionary dictionary];
        attributesMd[NSForegroundColorAttributeName] = [UIColor blackColor];
        navigationBar.titleTextAttributes = attributesMd;
        
        [_controller presentViewController:_messageComposeVc animated:YES completion:^{
            
        }];
        
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"设备没有短信功能" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
    }
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"取消发送");
            [_messageComposeVc dismissViewControllerAnimated:YES completion:^{
                
            }];
            break;
            
        case MessageComposeResultSent:

            [_messageComposeVc dismissViewControllerAnimated:YES completion:^{
//                [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                ALERT_HUD(self.controller.view, @"分享成功！");

            }];
            
            break;
            
//        case MessageComposeResultFailed:
//            NSLog(@"发送失败");
//            [_messageComposeVc dismissViewControllerAnimated:YES completion:^{
////                [SVProgressHUD showSuccessWithStatus:@"分享失败"];
//                ALERT_HUD(self.controller.view, @"分享失败！");
//
//            }];
//            break;
//            
//        default:
//            break;
    }
}

/**
 *  复制链接
 */
- (void)copyUrl{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _url;
    
//    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
    ALERT_HUD(self.controller.view, @"复制成功！");

}

#pragma mark - 邀请好友
- (void)inviteViewWithController:(UIViewController *)controller title:(NSString *)title content:(NSString *)content image:(NSString *)imageName url:(NSString *)url{
    self.backgroundColor = [UIColor clearColor];
    self.frame = [UIScreen mainScreen].bounds;
    
    _controller = controller;
    _title = title;
    
    _imageData = UIImagePNGRepresentation([UIImage imageNamed:imageName]);
    
    _content = content;
    _url = url;
    
    UIView *window = (UIView *)[UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self];
    
    //蒙板
    UIView *alphaView = [MyControl viewWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    alphaView.backgroundColor = [GetColor(blackColor) colorWithAlphaComponent:.5f];
    [self addSubview:alphaView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
    [alphaView addGestureRecognizer:tap];
    
    //分享面板
    _shareBgView = [MyControl viewWithFrame:CGRectMake(0, HEIGHT , WIDTH, 148)];
    _shareBgView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self addSubview:_shareBgView];
    
    //取消
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(0, _shareBgView.height - 44, _shareBgView.width, 44);
    cancleBtn.backgroundColor = GetColor(whiteColor);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = GetFont(18);
    [cancleBtn setTitleColor:[UIColor colorWithHexString:@"#121212"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [_shareBgView addSubview:cancleBtn];
    
    NSArray *imagesArr = @[@"qq",@"weixin",@"pengyouquan",@"sina"];
    NSArray *titlesArr = @[@"QQ",@"微信",@"朋友圈",@"新浪微博"];
    
    CGFloat shareBtnW = 60.f;
    NSUInteger count = imagesArr.count;
    CGFloat margin = 20;
    CGFloat padding = (WIDTH - count * shareBtnW - margin * 2) / (count - 1);
    
    for (int i = 0; i < count; i++) {
        SharesBtn *btn = [SharesBtn buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(margin + (shareBtnW + padding) * i, 0, shareBtnW, 104);
        [btn setImage:GetImage(imagesArr[i]) forState:UIControlStateNormal];
        [btn setTitle:titlesArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
        btn.titleLabel.font = GetFont(14.f);
        btn.tag = 231 + i;
        [btn addTarget:self action:@selector(clickInviteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_shareBgView addSubview:btn];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _shareBgView.frame = CGRectMake(0, HEIGHT - _shareBgView.height, WIDTH, _shareBgView.height);
    }];
}

- (void)clickInviteBtn:(UIButton *)btn{
    NSInteger platformIndex = btn.tag - 231;
    if( _imageData == nil )
    {
        _imageData = [NSData dataWithData:UIImagePNGRepresentation([UIImage imageNamed:@"share_default"])];
    }
    switch (platformIndex) {
        case 0:
        {
            //分享到QQ
            [self shareToQQ];
        }
            break;
        case 1:
        {
            //分享到微信
            [self shareToWeChat];
        }
            break;
        case 2:
        {
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
            //分享到朋友圈
            [self shareToFriendsCircle];
        }
            break;
        case 3:
        {
            //分享到新浪微博
//            [self shareToSina];
        }
            break;
            
        default:
            break;
    }
}
@end
