//
//  SaveUUIDinKeychain.m
//  XKSDeliver
//
//  Created by 同行必达 on 15/11/2.
//  Copyright © 2015年 同行必达. All rights reserved.
//



#import "SaveUUIDinKeychain.h"


@implementation SaveUUIDinKeychain


+(SaveUUIDinKeychain *)shareKeyChain
{
    SaveUUIDinKeychain *uuidKeyChain;
    if (!uuidKeyChain) {
        uuidKeyChain = [[SaveUUIDinKeychain alloc]init];
    }
    return uuidKeyChain;
}

-(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}
-(NSString *)getUUIDatKeyChain
{
    NSString *uuid;
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    uuid = [bindings stringForKey:UUID];
    return uuid;
}
-(void)initUUIDKeyInKeyChain
{
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    [bindings setString:@"" forKey:UUID];
   // [bindings removeObjectForKey:UUID];
}
-(void)setUUID
{
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
   // NSLog(@"key chain %@",[bindings class]);
    if ([[bindings stringForKey:UUID]isEqualToString:@""]) {
        [bindings setString:[self uuid] forKey:UUID];
    }else
    {
    }
}

@end
