//
//  QRMenu.m
//  QRCode
//
//  Created by Mac_Mini on 15/9/15.
//  Copyright (c) 2015年 Chenxuhun. All rights reserved.
//
#import "QRMenu.h"

@implementation QRMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
     
        [self setupQRItem];
        
    }
    
    return self;
}

- (void)setupQRItem {
    
    QRItem *lightItem = [[QRItem alloc] initWithFrame:(CGRect){
        .origin.x = 12,
        .origin.y = 0,
        .size.width = 30,
        .size.height = self.bounds.size.height
    } titile:@"开灯"];
    lightItem.type = QRItemTypeQRLight;
    [self addSubview:lightItem];
    
    QRItem *albumItem = [[QRItem alloc] initWithFrame: (CGRect){
        
        .origin.x = WIDTH-120,
        .origin.y = 0,
        .size.width = 100,
        .size.height = self.bounds.size.height
    } titile:@"从相册中选择"];
    albumItem.type = QRItemTypeAlbum;
    [self addSubview:albumItem];
    
    [lightItem addTarget:self action:@selector(qrScan:) forControlEvents:UIControlEventTouchUpInside];
    [albumItem addTarget:self action:@selector(qrScan:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Action

- (void)qrScan:(QRItem *)qrItem {
    
    if (self.didSelectedBlock) {
        
        self.didSelectedBlock(qrItem);
    }
}

@end
