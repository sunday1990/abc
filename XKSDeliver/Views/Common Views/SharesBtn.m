//
//  SharesBtn.m
//  SpaceHome
//
//  Created by apple on 15/10/29.
//
//

#import "SharesBtn.h"

@implementation SharesBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupBasicAttribute];
    }
    return self;
}

- (void)setupBasicAttribute
{
    self.imageView.contentMode = UIViewContentModeCenter;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = GetColor(clearColor);
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, (self.height-50-10-25)/2+50+10, self.width, 25);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((self.width-50)/2, (self.height-50-10-25)/2, 50, 50);
}


@end
