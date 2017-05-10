//
//  SHSelectPaymentTypeView.h
//  SpaceHome
//
//  Created by suhc on 16/5/12.
//
//

#import <UIKit/UIKit.h>
#import "SalaryGroup.h"

@interface SHSelectPayTypeView : UIView

+ (instancetype)selectPayTypeViewWithController:(UIViewController *)controlelr;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic,copy)void(^selectedBlock)(NSString *fullTimeWork,NSString *salaryType);
/**
 *  数据模型
 */
@property (nonatomic, strong) NSMutableArray *group;

@property (nonatomic, copy)NSString *name;

- (void)show;

- (void)hide;

@end
