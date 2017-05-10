//
//  ShareView.h
//  SpaceHome
//
//  Created by apple on 15/10/29.
//
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "common.h"
@interface ShareView : UIView

singletonInterface(ShareView)
/**
 *  创建分享面板
 *
 *  @param controller 需要添加分享面板的controller
 *  @param title      分享的标题
 *  @param imageName  分享的图片
 *  @param url        点击分享内容跳转的链接
 */
- (void)shareViewWithController:(UIViewController *)controller title:(NSString *)title image:(NSString *)imageName url:(NSString *)url;

- (void)shareViewWithController:(UIViewController *)controller title:(NSString *)title image:(NSString *)imageName url:(NSString *)url filtersIndex:(NSArray *)index;


- (void)shareViewRatioWithController:(UIViewController *)controller title:(NSString *)title image:(NSString *)imageName url:(NSString *)url;



- (void)shareViewWithController:(UIViewController *)controller title:(NSString *)title content:(NSString *)content image:(NSString *)imageName url:(NSString *)ur;
/**
 同上
 
 @param controller 同上
 @param title      同上
 @param imageName  同上
 @param url        同上
 @param index      需要显示的元素id
 */

- (void)shareViewWithController:(UIViewController *)controller title:(NSString *)title content:(NSString *)content image:(NSString *)imageName url:(NSString *)url filtersIndex:(NSArray *)index;


- (void)inviteViewWithController:(UIViewController *)controller title:(NSString *)title content:(NSString *)content image:(NSString *)imageName url:(NSString *)url;

@end
