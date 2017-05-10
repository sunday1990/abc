//
//  SaveUUIDinKeychain.h
//  XKSDeliver
//
//  Created by 同行必达 on 15/11/2.
//  Copyright © 2015年 同行必达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDKeychainBindings.h"
#import "common.h"
@interface SaveUUIDinKeychain : NSObject


+(SaveUUIDinKeychain *)shareKeyChain;

-(NSString *)getUUIDatKeyChain;
-(void)initUUIDKeyInKeyChain;
-(void)setUUID;


@end
