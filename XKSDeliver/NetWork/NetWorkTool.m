//
//  NetWorkTool.m
//  XKSDeliver
//
//  Created by 同行必达 on 15/10/19.
//  Copyright © 2015年 同行必达. All rights reserved.
//
#import "NetWorkTool.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "NetworkingState.h"
#import "SystemConfig.h"
#import "SaveUUIDinKeychain.h"

@implementation NetWorkTool

#pragma mark COMMON POST REQUEST
+(void)postRequestWithUrl:(NSString *)url param:(NSDictionary *)param addProgressHudOn:(UIView *)targetview Tip:(NSString *)tip successReturn:(SuccessBlock)successReturn failed:(FailedBlock)failed
{
    
    if (targetview !=nil) {
        [[NetworkingState shareNetworkstate]getNeworkingTipOn:targetview withTip:tip];
    }
    NSMutableDictionary *baseParam = [NSMutableDictionary dictionaryWithObjects:@[    [[SystemConfig shareSystemConfig]getDeviceToken]]                                                                                  forKeys:@[@"imei",]];
    NSArray *keyArray   = [param allKeys];
    NSArray *valueArray = [param allValues];
    for (int i = 0; i < keyArray.count; i++) {
        [baseParam setValue:valueArray[i] forKey:keyArray[i]];
    }
   // NSLog(@"----common-request------getnetwork param:%@",baseParam);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
//    manager.requestSerialize
    [manager setSecurityPolicy:[NetWorkTool customSecurityPolicy]];
    [manager.requestSerializer setValue:[[SystemConfig shareSystemConfig]getDeviceToken]
 forHTTPHeaderField:@"IMEI"];
    [manager.requestSerializer setValue:@"TRUE" forHTTPHeaderField:@"EKS-Mobile"];
    [manager.requestSerializer setValue:@"TRUE" forHTTPHeaderField:@"BRCY-Mobile"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"EKS-Device-Type"];
    [manager.requestSerializer setValue:@"driver" forHTTPHeaderField:@"EKS-Client-Type"];
    [manager.requestSerializer setValue:[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"] forHTTPHeaderField:@"EKS-DDS-Version"];
    [manager.requestSerializer setValue:[[SystemConfig shareSystemConfig]getSessionId] forHTTPHeaderField:@"Cookie"];

    NSString *  URLTmp1 = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];  //转码成UTF-8  否则可能会出现错误
 
    //转码成UTF-8  否则可能会出现错误
    
    [manager POST:URLTmp1 parameters:baseParam constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *dataString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"datastring=%@",dataString);
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (successReturn) {
            successReturn(responseObject);
        }
        //此处没有做加密处理，退出登录后的操作没有
        for (UIView *view in [targetview subviews]) {
            if (view.tag == MISSTAG) {
                view.hidden = YES;
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failed(error);
        for (UIView *view in [targetview subviews]) {
            if (view.tag == MISSTAG) {
                view.hidden = YES;
            }
        }
       // NSLog(@"errorTitle %@ detail %@",tip,error);
        ALERT_VIEW(LOSTCONNECT);
    }];

}

#pragma mark  COMMON GET REQUEST

+(void)getRequestWithUrl:(NSString *)url param:(NSDictionary *)param addProgressHudOn:(UIView *)targetview Tip:(NSString *)tip successReturn:(SuccessBlock)successReturn failed:(FailedBlock)failed;
{
    
    if (targetview !=nil) {
        [[NetworkingState shareNetworkstate]getNeworkingTipOn:targetview withTip:tip];
    }
    
    NSMutableDictionary *baseParam = [NSMutableDictionary dictionaryWithObjects:@[[[SystemConfig shareSystemConfig]getDeviceToken],]                                                                                  forKeys:@[@"imei",]];
    NSArray *keyArray   = [param allKeys];
    NSArray *valueArray = [param allValues];
    for (int i = 0; i < keyArray.count; i++) {
        [baseParam setValue:valueArray[i] forKey:keyArray[i]];
    }
  //  NSLog(@"----common-request------getnetwork param:%@",baseParam);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
    [manager setSecurityPolicy:[NetWorkTool customSecurityPolicy]];

    [manager.requestSerializer setValue:[[SystemConfig shareSystemConfig]getDeviceToken] forHTTPHeaderField:@"IMEI"];
    [manager.requestSerializer setValue:@"TRUE" forHTTPHeaderField:@"EKS-Mobile"];
    [manager.requestSerializer setValue:@"TRUE" forHTTPHeaderField:@"BRCY-Mobile"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"EKS-Device-Type"];
    [manager.requestSerializer setValue:@"driver" forHTTPHeaderField:@"EKS-Client-Type"];
    [manager.requestSerializer setValue:[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"] forHTTPHeaderField:@"EKS-DDS-Version"];
    [manager.requestSerializer setValue:[[SystemConfig shareSystemConfig]getSessionId] forHTTPHeaderField:@"Cookie"];
    
    [manager GET:url parameters:baseParam success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {

        for (UIView *view in [targetview subviews]) {
            if (view.tag == MISSTAG) {
                view.hidden = YES;
            }
        }
        successReturn(responseObject);
        
        //NSLog(@"%@",operation);
        
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failed(error);
        for (UIView *view in [targetview subviews]) {
                if (view.tag == MISSTAG) {
                    view.hidden = YES;
                }
        }
            
        NSLog(@"errorTitle:%@ detail:%@",tip,error);
        ALERT_VIEW(LOSTCONNECT);
    }];
}
#pragma mark total param get request
+(void)getRequestWithUrl:(NSString *)url totalParam:(NSDictionary *)param addProgressHudOn:(UIView *)targetview Tip:(NSString *)tip successReturn:(SuccessBlock)successReturn failed:(FailedBlock)failed
{
    if (targetview !=nil) {
        [[NetworkingState shareNetworkstate]getNeworkingTipOn:targetview withTip:tip];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
    [manager setSecurityPolicy:[NetWorkTool customSecurityPolicy]];

    
    [manager.requestSerializer setValue:[[SystemConfig shareSystemConfig]getDeviceToken] forHTTPHeaderField:@"IMEI"];
    [manager.requestSerializer setValue:@"TRUE" forHTTPHeaderField:@"EKS-Mobile"];
    [manager.requestSerializer setValue:@"TRUE" forHTTPHeaderField:@"BRCY-Mobile"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"EKS-Device-Type"];
    [manager.requestSerializer setValue:@"driver" forHTTPHeaderField:@"EKS-Client-Type"];
    [manager.requestSerializer setValue:[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"] forHTTPHeaderField:@"EKS-DDS-Version"];
    [manager.requestSerializer setValue:[[SystemConfig shareSystemConfig]getSessionId] forHTTPHeaderField:@"Cookie"];
    [manager GET:url parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        successReturn(responseObject);
        
        for (UIView *view in [targetview subviews]) {
            if (view.tag == MISSTAG) {
                view.hidden = YES;
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failed(error);
        
        NSLog(@"%@",operation);
        for (UIView *view in [targetview subviews]) {
            if (view.tag == MISSTAG) {
                view.hidden = YES;
            }
        }
        NSLog(@"errorTitle %@ detail %@",tip,error);
        ALERT_VIEW(LOSTCONNECT);
    }];
}

#pragma mark BUNDLE DEVICE

+(void)getToBundleDeviceWithParam:(NSDictionary *)param addProgressHudOn:(UIView *)targetview successReturn:(SuccessBlock)successReturn failed:(FailedBlock)failed
{
    [[NetworkingState shareNetworkstate]getNeworkingTipOn:targetview withTip:@"绑定手机"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[[SystemConfig shareSystemConfig]getDeviceToken] forHTTPHeaderField:@"IMEI"];
    [manager.requestSerializer setValue:@"TRUE" forHTTPHeaderField:@"EKS-Mobile"];
    [manager.requestSerializer setValue:@"TRUE" forHTTPHeaderField:@"BRCY-Mobile"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"EKS-Device-Type"];
    [manager.requestSerializer setValue:@"driver" forHTTPHeaderField:@"EKS-Client-Type"];
    [manager.requestSerializer setValue:[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"] forHTTPHeaderField:@"EKS-DDS-Version"];
    [manager.requestSerializer setValue:[[SystemConfig shareSystemConfig]getSessionId] forHTTPHeaderField:@"Cookie"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
    [manager setSecurityPolicy:[NetWorkTool customSecurityPolicy]];

    
    NSMutableDictionary *baseParam = [NSMutableDictionary dictionaryWithObjects:@[[[SystemConfig shareSystemConfig]getDeviceToken],@"ios"] forKeys:@[@"imei",@"appType"]];
    NSArray *keyArray   = [param allKeys];
    NSArray *valueArray = [param allValues];
    for (int i = 0; i < keyArray.count; i++) {
        [baseParam setValue:valueArray[i] forKey:keyArray[i]];
    }
    [manager POST:__bundleDevice parameters:baseParam success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *returnString = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        //{"result":"false","msg":"该用户在系统中已存在绑定信息，如需要绑定新设备请联系管理员"}
        // 0:"{"  1:"result"  2:":"  3:"false"  4:","  5:"msg"  6:":" 7:"该用户在系统中已存在绑定信息，如需要绑定新设备请联系管理员"
        NSArray *array = [returnString componentsSeparatedByString:@"\""];
        //        for (NSString *string in array) {
        //            NSLog(@"outputelement %@\n",string);
        //        }
        NSArray *returnArray = @[array[3],array[7]];
        successReturn(returnArray);
        [[targetview subviews]lastObject].hidden = YES;

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failed(error);
        NSLog(@"get to bundle devicereturn error%@ operation%@",error,operation);
        [[targetview subviews]lastObject].hidden = YES;
        ALERT_VIEW(LOSTCONNECT);
    }];
}

+(void)getNoticeDataAddProgressHudOn:(UIView *)targetview Tip:(NSString *)tip successReturn:(SuccessBlock)successReturn failed:(FailedBlock)failed
{
    
    [[NetworkingState shareNetworkstate]getNeworkingTipOn:targetview withTip:tip];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
    [manager setSecurityPolicy:[NetWorkTool customSecurityPolicy]];

    
    [manager.requestSerializer setValue:[[SystemConfig shareSystemConfig]getDeviceToken] forHTTPHeaderField:@"IMEI"];
    [manager.requestSerializer setValue:@"TRUE" forHTTPHeaderField:@"EKS-Mobile"];
    [manager.requestSerializer setValue:@"TRUE" forHTTPHeaderField:@"BRCY-Mobile"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"EKS-Device-Type"];
    [manager.requestSerializer setValue:@"driver" forHTTPHeaderField:@"EKS-Client-Type"];
    [manager.requestSerializer setValue:[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"] forHTTPHeaderField:@"EKS-DDS-Version"];
    [manager.requestSerializer setValue:[[SystemConfig shareSystemConfig]getSessionId] forHTTPHeaderField:@"Cookie"];
    [manager GET:__noticeData parameters:@{@"newTime":[NSString stringWithFormat:@"%@",[NSDate date]]} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        successReturn(responseObject);
                
        for (UIView *view in [targetview subviews]) {
            if (view.tag == MISSTAG) {
                view.hidden = YES;
            }
        }
        //NSLog(@"notciedata %@",operation);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failed(error);
        for (UIView *view in [targetview subviews]) {
            if (view.tag == MISSTAG) {
                view.hidden = YES;
            }
        }
        //NSLog(@"errorTitle %@ detail %@",tip,error);
        ALERT_VIEW(LOSTCONNECT);
    }];
}

#pragma UPLOAD LOCATION
+(void)postToUpLoadLocationWithParam:(NSDictionary *)param successReturn:(SuccessBlock)successReturn failed:(FailedBlock)failed
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager setSecurityPolicy:[NetWorkTool customSecurityPolicy]];

    
    [manager.requestSerializer setValue:[[SystemConfig shareSystemConfig]getDeviceToken] forHTTPHeaderField:@"IMEI"];
    [manager.requestSerializer setValue:@"TRUE" forHTTPHeaderField:@"EKS-Mobile"];
    [manager.requestSerializer setValue:@"TRUE" forHTTPHeaderField:@"BRCY-Mobile"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"EKS-Device-Type"];
    [manager.requestSerializer setValue:@"driver" forHTTPHeaderField:@"EKS-Client-Type"];
    [manager.requestSerializer setValue:[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"] forHTTPHeaderField:@"EKS-DDS-Version"];
    [manager.requestSerializer setValue:[[SystemConfig shareSystemConfig]getSessionId] forHTTPHeaderField:@"Cookie"];
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
    [manager POST:__uploadLocation parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        successReturn(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
       // NSLog(@"--------%@",operation);
        failed(error);
        //ALERT_VIEW(LOSTCONNECT);
    }];
}
#pragma mark LOGIN

+(void)postToLoginWithParam:(NSDictionary *)param addProgressHudOn:(UIView *)targetview successReturn:(SuccessBlock)successReturn failed:(FailedBlock)failed
{
    //[[SystemConfig shareSystemConfig]getDeviceToken]
    [[NetworkingState shareNetworkstate]getNeworkingTipOn:targetview withTip:@"登录中"];
    NSMutableDictionary *baseParam = [NSMutableDictionary dictionaryWithObjects:@[@"driverMobile",
                                                                               [[SystemConfig shareSystemConfig]getDeviceToken],
                                                                                            [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"],
                                                                                       @"ios",]
                                                                        forKeys:@[
                                                                                  @"lt",
                                                                                     @"imei",
                                                                                  @"version",
                                                                                       @"os",]];
    NSArray *keyArray   = [param allKeys];
    NSArray *valueArray = [param allValues];
    for (int i = 0; i < keyArray.count; i++) {
        [baseParam setValue:valueArray[i] forKey:keyArray[i]];
    }
 //   NSLog(@"----------login param:%@",baseParam);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
        [manager setSecurityPolicy:[NetWorkTool customSecurityPolicy]];

        [manager.requestSerializer setValue:@"TRUE" forHTTPHeaderField:@"BRCY-Mobile"];
    if (![[[SystemConfig  shareSystemConfig]getSessionId]isEqualToString:@""]) {

        [manager.requestSerializer setValue:[[SystemConfig shareSystemConfig]getSessionId] forHTTPHeaderField:@"Cookie"];
        [manager.requestSerializer setValue:[[SystemConfig shareSystemConfig]getSessionId] forHTTPHeaderField:@"Set-Cookie"];
    }
        NSLog(@"userlogin=%@",__userLogin);
        [manager POST:__userLogin parameters:baseParam success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {

            if ([[operation.response allHeaderFields]valueForKey:@"Set-Cookie"]==nil)
            {
                //do not cover the local session id
            }
            else{
                [[SystemConfig shareSystemConfig]saveSesstionID:[[operation.response allHeaderFields] valueForKey:@"Set-Cookie"]];
            }
            [[targetview subviews]lastObject].hidden = YES;
            
            successReturn(responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            failed(error);
            NSLog(@"login return error %@",error);
            [[targetview subviews]lastObject].hidden = YES;
            ALERT_VIEW(LOSTCONNECT);
        }];
}

#pragma mark CHANGEPASSWORD
+(void)postToChangePasswordParam:(NSDictionary *)param addProgressHudOn:(UIView *)targetview successReturn:(SuccessBlock)successReturn failed:(FailedBlock)failed
{
    [[NetworkingState shareNetworkstate]getNeworkingTipOn:targetview withTip:@"修改密码"];
    NSMutableDictionary *baseParam = [NSMutableDictionary dictionaryWithObjects:@[[[SystemConfig shareSystemConfig]getDeviceToken]] forKeys:@[@"imei"]];
    NSArray *keyArray   = [param allKeys];
    NSArray *valueArray = [param allValues];
    for (int i = 0; i < keyArray.count; i++) {
        [baseParam setValue:valueArray[i] forKey:keyArray[i]];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer= [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",@"",nil];
    [manager setSecurityPolicy:[NetWorkTool customSecurityPolicy]];

    
    
    [manager.requestSerializer setValue:[[SystemConfig shareSystemConfig]getDeviceToken] forHTTPHeaderField:@"IMEI"];
    [manager.requestSerializer setValue:@"TRUE" forHTTPHeaderField:@"EKS-Mobile"];
    [manager.requestSerializer setValue:@"TRUE" forHTTPHeaderField:@"BRCY-Mobile"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"EKS-Device-Type"];
    [manager.requestSerializer setValue:@"driver" forHTTPHeaderField:@"EKS-Client-Type"];
    [manager.requestSerializer setValue:[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"] forHTTPHeaderField:@"EKS-DDS-Version"];
    [manager.requestSerializer setValue:[[SystemConfig shareSystemConfig]getSessionId] forHTTPHeaderField:@"Cookie"];
    
  //  NSLog(@"change password param %@",baseParam);

    [manager POST:__changePassword parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSMutableData *deviceIdentifer = [[NSMutableData alloc]init];
        NSMutableData *newPassword     = [[NSMutableData alloc]init];
        NSMutableData *ordPassword     = [[NSMutableData alloc]init];
        NSMutableData *nowTime         = [[NSMutableData alloc]init];
        [deviceIdentifer appendData:[[NSString stringWithFormat:@"%@",[baseParam objectForKey:@"imei"]]dataUsingEncoding:NSUTF8StringEncoding]];
        [newPassword appendData:[[NSString stringWithFormat:@"%@",[baseParam objectForKey:@"newp"]]dataUsingEncoding:NSUTF8StringEncoding]];
        [ordPassword appendData:[[NSString stringWithFormat:@"%@",[baseParam objectForKey:@"oldp"]]dataUsingEncoding:NSUTF8StringEncoding]];
        [nowTime appendData:[[NSString stringWithFormat:@"%@",[baseParam objectForKey:@"nowDate"]]dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [formData appendPartWithFormData:deviceIdentifer name:@"imei"];
        [formData appendPartWithFormData:newPassword name:@"newp"];
        [formData appendPartWithFormData:ordPassword name:@"oldp"];
        [formData appendPartWithFormData:nowTime name:@"nowDate"];
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"transfer into dictionary%@",dic);
        NSString *dicString = [NSString stringWithFormat:@"%@",dic];
        NSArray *separatedStringArray = [dicString componentsSeparatedByString:@"\""];

        if ([dic isEqual:[NSNull null]]) {
            NSString *string = @"null";
            successReturn(string);
        }
        else
        {
            successReturn(separatedStringArray[3]);
        }
        [[targetview subviews]lastObject].hidden = YES;

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"change password return error%@ operation%@",error,operation);
        failed(error);
        [[targetview subviews]lastObject].hidden = YES;
        ALERT_VIEW(LOSTCONNECT);
    }];
}

+(void)postToSendGetPackageCodeWith:(NSDictionary *)param addProgressHudOn:(UIView *)targetview successReturn:(SuccessBlock)successReturn failed:(FailedBlock)failed
{
    [[NetworkingState shareNetworkstate]getNeworkingTipOn:targetview withTip:@"正在执行"];
    NSMutableDictionary *baseParam = [NSMutableDictionary dictionaryWithObjects:@[[[SystemConfig shareSystemConfig]getDeviceToken]] forKeys:@[@"imei"]];
    NSArray *keyArray   = [param allKeys];
    NSArray *valueArray = [param allValues];
    for (int i = 0; i < keyArray.count; i++) {
        [baseParam setValue:valueArray[i] forKey:keyArray[i]];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer= [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",@"",nil];
    [manager setSecurityPolicy:[NetWorkTool customSecurityPolicy]];

    
    [manager.requestSerializer setValue:[[SystemConfig shareSystemConfig]getDeviceToken] forHTTPHeaderField:@"IMEI"];
    [manager.requestSerializer setValue:@"TRUE" forHTTPHeaderField:@"EKS-Mobile"];
    [manager.requestSerializer setValue:@"TRUE" forHTTPHeaderField:@"BRCY-Mobile"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"EKS-Device-Type"];
    [manager.requestSerializer setValue:@"driver" forHTTPHeaderField:@"EKS-Client-Type"];
    [manager.requestSerializer setValue:[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"] forHTTPHeaderField:@"EKS-DDS-Version"];
    [manager.requestSerializer setValue:[[SystemConfig shareSystemConfig]getSessionId] forHTTPHeaderField:@"Cookie"];
    
   // NSLog(@"send getpackage code param %@",baseParam);
    [manager POST:__sendGetPackageCode parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSMutableData *deviceIdentifer = [[NSMutableData alloc]init];
        NSMutableData *orderId     = [[NSMutableData alloc]init];
        NSMutableData *arriveTime     = [[NSMutableData alloc]init];
        NSMutableData *isQuJianPass    = [[NSMutableData alloc]init];
        [deviceIdentifer appendData:[[NSString stringWithFormat:@"%@",[baseParam objectForKey:@"imei"]]dataUsingEncoding:NSUTF8StringEncoding]];
        [orderId appendData:[[NSString stringWithFormat:@"%@",[baseParam objectForKey:@"orderId"]]dataUsingEncoding:NSUTF8StringEncoding]];
        [arriveTime appendData:[[NSString stringWithFormat:@"%@",[baseParam objectForKey:@"arriveTime"]]dataUsingEncoding:NSUTF8StringEncoding]];
        [isQuJianPass appendData:[[NSString stringWithFormat:@"%@",[baseParam objectForKey:@"isQuJianPass"]]dataUsingEncoding:NSUTF8StringEncoding]];
        
        [formData appendPartWithFormData:deviceIdentifer name:@"imei"];
        [formData appendPartWithFormData:orderId name:@"orderId"];
        [formData appendPartWithFormData:arriveTime name:@"arriveTime"];
        [formData appendPartWithFormData:isQuJianPass name:@"isQuJianPass"];
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        successReturn(responseObject);
        
        [[targetview subviews]lastObject].hidden = YES;
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"post to get package code  error%@ operation%@",error,operation);
        failed(error);
        [[targetview subviews]lastObject].hidden = YES;
        ALERT_VIEW(LOSTCONNECT);
    }];

}
+(void)postToSendReceiveCodeWith:(NSDictionary *)param addProgressHudOn:(UIView *)targetview successReturn:(SuccessBlock)successReturn failed:(FailedBlock)failed
{
    [[NetworkingState shareNetworkstate]getNeworkingTipOn:targetview withTip:@"正在执行"];
    NSMutableDictionary *baseParam = [NSMutableDictionary dictionaryWithObjects:@[[[SystemConfig shareSystemConfig]getDeviceToken]] forKeys:@[@"imei"]];
    NSArray *keyArray   = [param allKeys];
    NSArray *valueArray = [param allValues];
    for (int i = 0; i < keyArray.count; i++) {
        [baseParam setValue:valueArray[i] forKey:keyArray[i]];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer= [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",@"",nil];
    [manager setSecurityPolicy:[NetWorkTool customSecurityPolicy]];

    [manager.requestSerializer setValue:[[SystemConfig shareSystemConfig]getDeviceToken] forHTTPHeaderField:@"IMEI"];
    [manager.requestSerializer setValue:@"TRUE" forHTTPHeaderField:@"EKS-Mobile"];
    [manager.requestSerializer setValue:@"TRUE" forHTTPHeaderField:@"BRCY-Mobile"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"EKS-Device-Type"];
    [manager.requestSerializer setValue:@"driver" forHTTPHeaderField:@"EKS-Client-Type"];
    [manager.requestSerializer setValue:[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"] forHTTPHeaderField:@"EKS-DDS-Version"];
    [manager.requestSerializer setValue:[[SystemConfig shareSystemConfig]getSessionId] forHTTPHeaderField:@"Cookie"];
    
  //  NSLog(@"send receive code  %@",baseParam);
    
    [manager POST:__startToDeliver parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSMutableData *deviceIdentifer = [[NSMutableData alloc]init];
        NSMutableData *orderId         = [[NSMutableData alloc]init];
        NSMutableData *arriveTime      = [[NSMutableData alloc]init];
        NSMutableData *isShouJianPass  = [[NSMutableData alloc]init];
        NSMutableData *courierTakePwd  = [[NSMutableData alloc]init];
        NSMutableData *isQuJianPass    =[[NSMutableData alloc]init];
        
        [deviceIdentifer appendData:[[NSString stringWithFormat:@"%@",[baseParam objectForKey:@"imei"]]dataUsingEncoding:NSUTF8StringEncoding]];
        [orderId appendData:[[NSString stringWithFormat:@"%@",[baseParam objectForKey:@"orderId"]]dataUsingEncoding:NSUTF8StringEncoding]];
        [arriveTime appendData:[[NSString stringWithFormat:@"%@",[baseParam objectForKey:@"arriveTime"]]dataUsingEncoding:NSUTF8StringEncoding]];
        [isShouJianPass appendData:[[NSString stringWithFormat:@"%@",[baseParam objectForKey:@"isShouJianPass"]]dataUsingEncoding:NSUTF8StringEncoding]];
        [courierTakePwd appendData:[[NSString stringWithFormat:@"%@",[baseParam objectForKey:@"courierTakePwd"]]dataUsingEncoding:NSUTF8StringEncoding]];
     //   NSLog(@"************%@",[[baseParam valueForKey:@"courierTakePwd"]dataUsingEncoding:NSUTF8StringEncoding]);
        
        [isQuJianPass appendData:[[NSString stringWithFormat:@"%@",[baseParam objectForKey:@"isQuJianPass"]]dataUsingEncoding:NSUTF8StringEncoding]];

        [formData appendPartWithFormData:deviceIdentifer name:@"imei"];
        [formData appendPartWithFormData:orderId name:@"orderId"];
        [formData appendPartWithFormData:arriveTime name:@"arriveTime"];
        [formData appendPartWithFormData:isShouJianPass name:@"isShouJianPass"];
        [formData appendPartWithFormData:isQuJianPass name:@"isQuJianPass"];
        [formData appendPartWithFormData:courierTakePwd name:@"courierTakePwd"];

        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        successReturn(responseObject);
        
        [[targetview subviews]lastObject].hidden = YES;
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"post to send receive code error%@ operation%@",error,operation);
        failed(error);
        [[targetview subviews]lastObject].hidden = YES;
        ALERT_VIEW(LOSTCONNECT);
    }];
}

+(void)postToSendCompleteCodeWith:(NSDictionary *)param addProgressHudOn:(UIView *)targetview successReturn:(SuccessBlock)successReturn failed:(FailedBlock)failed
{
    [[NetworkingState shareNetworkstate]getNeworkingTipOn:targetview withTip:@"正在执行"];
    NSMutableDictionary *baseParam = [NSMutableDictionary dictionaryWithObjects:@[[[SystemConfig shareSystemConfig]getDeviceToken]] forKeys:@[@"imei"]];
    NSArray *keyArray   = [param allKeys];
    NSArray *valueArray = [param allValues];
    for (int i = 0; i < keyArray.count; i++) {
        [baseParam setValue:valueArray[i] forKey:keyArray[i]];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer= [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",@"",nil];
    
    [manager setSecurityPolicy:[NetWorkTool customSecurityPolicy]];
    
    [manager.requestSerializer setValue:[[SystemConfig shareSystemConfig]getDeviceToken] forHTTPHeaderField:@"IMEI"];
    [manager.requestSerializer setValue:@"TRUE" forHTTPHeaderField:@"EKS-Mobile"];
    [manager.requestSerializer setValue:@"TRUE" forHTTPHeaderField:@"BRCY-Mobile"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"EKS-Device-Type"];
    [manager.requestSerializer setValue:@"driver" forHTTPHeaderField:@"EKS-Client-Type"];
    [manager.requestSerializer setValue:[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"] forHTTPHeaderField:@"EKS-DDS-Version"];
    [manager.requestSerializer setValue:[[SystemConfig shareSystemConfig]getSessionId] forHTTPHeaderField:@"Cookie"];
    
    [manager POST:__sendToComplete parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSMutableData *deviceIdentifer   = [[NSMutableData alloc]init];
        NSMutableData *orderId           = [[NSMutableData alloc]init];
        NSMutableData *serviceEndTime        = [[NSMutableData alloc]init];
        NSMutableData *isShouJianPass    = [[NSMutableData alloc]init];
        NSMutableData *isQuJianPass      = [[NSMutableData alloc]init];
        NSMutableData *customerTakePwd   = [[NSMutableData alloc]init];
        
        [deviceIdentifer appendData:[[NSString stringWithFormat:@"%@",[baseParam objectForKey:@"imei"]]dataUsingEncoding:NSUTF8StringEncoding]];
        [orderId appendData:[[NSString stringWithFormat:@"%@",[baseParam objectForKey:@"orderId"]]dataUsingEncoding:NSUTF8StringEncoding]];
        [serviceEndTime appendData:[[NSString stringWithFormat:@"%@",[baseParam objectForKey:@"serviceEndTime"]]dataUsingEncoding:NSUTF8StringEncoding]];
        [isShouJianPass appendData:[[NSString stringWithFormat:@"%@",[baseParam objectForKey:@"isShouJianPass"]]dataUsingEncoding:NSUTF8StringEncoding]];
        [isQuJianPass appendData:[[NSString stringWithFormat:@"%@",[baseParam objectForKey:@"isQuJianPass"]]dataUsingEncoding:NSUTF8StringEncoding]];
        [customerTakePwd appendData:[[NSString stringWithFormat:@"%@",[baseParam objectForKey:@"customerTakePwd"]]dataUsingEncoding:NSUTF8StringEncoding]];


        [formData appendPartWithFormData:deviceIdentifer name:@"imei"];
        [formData appendPartWithFormData:orderId name:@"orderId"];
        [formData appendPartWithFormData:serviceEndTime name:@"serviceEndTime"];
        [formData appendPartWithFormData:isShouJianPass name:@"isShouJianPass"];
        [formData appendPartWithFormData:isQuJianPass name:@"isQuJianPass"];
        [formData appendPartWithFormData:customerTakePwd name:@"customerTakePwd"];
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        successReturn(responseObject);
        
        [[targetview subviews]lastObject].hidden = YES;
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"post to send complete error%@ operation%@",error,operation);
        failed(error);
        [[targetview subviews]lastObject].hidden = YES;
        ALERT_VIEW(LOSTCONNECT);
    }];
}

//证书的验证
+ (AFSecurityPolicy *)customSecurityPolicy
{
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES; //还是必须设成YES
    securityPolicy.validatesDomainName = NO;//不验证证书的域名
    return securityPolicy;
}



@end
