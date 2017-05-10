//
//  UINavigationController+Push.m
//  SpaceHome
//
//  Created by ccSunday on 16/8/1.
//
//

#import "UINavigationController+PushPop.h"

@implementation UINavigationController (PushPop)
+ (void)load{
    
//    Method a = class_getInstanceMethod(self, @selector(pushViewController:animated:));
//    Method b = class_getInstanceMethod(self, @selector(SHpushViewController:animated:));
//    method_exchangeImplementations(a, b);
//    
//    Method c  = class_getInstanceMethod(self, @selector(popViewControllerAnimated:));
//    Method d = class_getInstanceMethod(self, @selector(SHpopViewControllerAnimated:));
//    method_exchangeImplementations(c, d);
}

- (void)SHpushViewController:(UIViewController *)viewController animated:(BOOL)animated{

    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
        self.viewControllers.firstObject.hidesBottomBarWhenPushed = NO;
    }
    [self SHpushViewController:viewController animated:YES];
    
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//   //这里有两个条件不允许手势执行，1、当前控制器为根控制器；2、如果这个push、pop动画正在执行（私有属性）
//    return self.viewControllers.count != 1 && ![[self valueForKey:@"_isTransitioning"] boolValue];
//}

- (UIViewController *)SHpopViewControllerAnimated:(BOOL)animated{
    
    return [self SHpopViewControllerAnimated:animated];
    
}
@end
