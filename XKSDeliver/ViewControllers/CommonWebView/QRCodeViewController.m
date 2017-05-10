//
//  CustomViewController.m
//  QRCode
//
//  Created by Mac_Mini on 15/9/15.
//  Copyright (c) 2015年 Chenxuhun. All rights reserved.
//

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRView.h"
#import "CommonWebViewController.h"
@interface QRCodeViewController () <AVCaptureMetadataOutputObjectsDelegate,QRViewDelegate,UIImagePickerControllerDelegate>
{
    UIImagePickerController *imagePicker;
}
@property (strong, nonatomic) AVCaptureDevice * device;
@property (strong, nonatomic) AVCaptureDeviceInput * input;
@property (strong, nonatomic) AVCaptureMetadataOutput * output;
@property (strong, nonatomic) AVCaptureSession * session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * preview;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleNavLabel.text = @"扫一扫";
    if (![self checkCamera]) {

        return;
    }
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    //增加条形码扫描
    //    _output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,
    //                                    AVMetadataObjectTypeEAN8Code,
    //                                    AVMetadataObjectTypeCode128Code,
    //                                    AVMetadataObjectTypeQRCode];
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity =AVLayerVideoGravityResize;
    _preview.frame = CGRectMake(0, UI_NAV_BAR_HEIGHT, WIDTH, HEIGHT-UI_NAV_BAR_HEIGHT);
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    [_session startRunning];
    
    
    QRView *qrRectView = [[QRView alloc] initWithFrame:CGRectMake(0, UI_NAV_BAR_HEIGHT, WIDTH, HEIGHT-UI_NAV_BAR_HEIGHT)];
    qrRectView.transparentArea = CGSizeMake(200, 200);
    qrRectView.backgroundColor = [UIColor clearColor];
    qrRectView.delegate = self;
    [self.view addSubview:qrRectView];
   
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2-75, UI_NAV_BAR_HEIGHT+12, 150, 60)];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    label.centerX = self.view.centerX;
    label.font = [UIFont systemFontOfSize:18];
    label.text = @"将取景框对准二维码即可自动扫描";
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    
    //修正扫描区域
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidth = self.view.frame.size.width;
    CGRect cropRect = CGRectMake((screenWidth - qrRectView.transparentArea.width) / 2,
                                 (screenHeight - qrRectView.transparentArea.height) / 2,
                                 qrRectView.transparentArea.width,
                                 qrRectView.transparentArea.height);
    
    [_output setRectOfInterest:CGRectMake(cropRect.origin.y / screenHeight,
                                          cropRect.origin.x / screenWidth,
                                          cropRect.size.height / screenHeight,
                                          cropRect.size.width / screenWidth)];
}

-(BOOL)checkCamera
{
    if ([self validateCamera]) {
        //继续
        return YES;
    } else {
        
        UIAlertAction *alertAction= [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"退出录入");
            //返回到上一页
#ifdef DEBUG
//            if (self.qrUrlBlock) {
//                self.qrUrlBlock(@"88399");
//            }
#else
            
#endif
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有摄像头或摄像头不可用" preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:alertAction];
        [self presentViewController:alertVc animated:YES completion:nil];
        return NO;
    }
}

- (BOOL)validateCamera {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

#pragma mark QRViewDelegate
-(void)scanTypeConfig:(QRItem *)item {
    
    if (item.type == QRItemTypeQRLight) {
        [self openSystemLight:item];
    } else if (item.type == QRItemTypeAlbum) {
        [self choicePhoto];
    }
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] >0)
    {
        //停止扫描
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    NSLog(@" =============%@",stringValue);
    if (self.qrUrlBlock) {
        [self.navigationController popViewControllerAnimated:YES];
        self.qrUrlBlock(stringValue);

    }
    [_session startRunning];
}

- (void)choicePhoto{
    //调用相册
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
//选中图片的回调
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *content = @"" ;
    //取出选中的图片
    UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(pickImage);
    CIImage *ciImage = [CIImage imageWithData:imageData];
    
    //创建探测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
    NSArray *feature = [detector featuresInImage:ciImage];
    
    //取出探测到的数据
    for (CIQRCodeFeature *result in feature) {
        content = result.messageString;
    }
    //进行处理(音效、网址分析、页面跳转等)
    if (content.length>0) {
        [imagePicker dismissViewControllerAnimated:YES completion:^{
            if (self.qrUrlBlock) {
                [self.navigationController popViewControllerAnimated:YES];
                self.qrUrlBlock(content);
            }
        }];
    }else{
        ALERT_HUD(imagePicker.view, @"未检测到二维码！");
    }
}

/**
 开灯

 @param button
 */
- (void)openSystemLight:(UIButton *)button{
    UIButton *sender = button;
    sender.selected = !sender.selected;
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (sender.selected) {
                
                [sender setTitle:@"关灯" forState:UIControlStateNormal];
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
            } else {
                [sender setTitle:@"开灯" forState:UIControlStateNormal];
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                
            }
            [device unlockForConfiguration];
        }
    }
}

@end
