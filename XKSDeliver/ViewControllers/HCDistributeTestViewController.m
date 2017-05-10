//
//  HCDistributeTestViewController.m
//  SpaceHome
//
//  Created by suhc on 2017/1/11.
//
//

#import "HCDistributeTestViewController.h"
#import "IQKeyboardManager.h"
#import "SimpleSwitch.h"
@interface HCDistributeTestViewController ()
{
    HCDistributeSpaceItem *_projectName;
    HCPhotoItem *_photoItem;
}
@end

@implementation HCDistributeTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleNavLabel.text = @"测试发布";
    
    [self setProjectGroup];
    
    [self setCenterGroups];
    
    [self setBottomGroup];
}

- (void)setProjectGroup{
    HCDistributeSpaceGroup *projectGroup = [self addCommonGroupWithHeader:nil];
    
    _projectName = [HCDistributeSpaceItem itemWithTitle:@"项目名称" placeHolder:@"请输入项目名称"];
    
    HCTextViewItem *projectIntroduction = [HCTextViewItem itemWithTitle:@"项目介绍" placeHolder:@"请输入项目介绍"];
    projectIntroduction.maxInputLength = 6;
    projectIntroduction.mustWrite = YES;
    projectIntroduction.content = @"这是项目介绍";
//    NSArray *photos = @[
//                        [UIImage imageNamed:@"mapPagecertification"],
//                        [UIImage imageNamed:@"mapPagecertification"],
//                        [UIImage imageNamed:@"mapPagecertification"],
//                        [UIImage imageNamed:@"mapPagecertification"],
//                        [UIImage imageNamed:@"mapPagecertification"]
//                        ];
//    
//    _photoItem = [[HCPhotoItem alloc] init];
//    _photoItem.title = @"照片信息";
//    _photoItem.controller = self;
//    _photoItem.maxCount = 8;
//    _photoItem.needClip = YES;
//    [_photoItem.photos addObjectsFromArray:photos];
    [projectGroup.items addObjectsFromArray:@[_projectName,projectIntroduction]];
}

- (void)setCenterGroups{
    for (int i = 0; i < 6; i++) {
        HCDistributeSpaceGroup *group = [self addCommonGroupWithHeader:[NSString stringWithFormat:@"标题%d",i]];
        
        HCDistributeSpaceItem *item1 = [HCDistributeSpaceItem itemWithTitle:[NSString stringWithFormat:@"姓名%zd",i] placeHolder:[NSString stringWithFormat:@"请输入姓名%zd",i]];
        HCDistributeSpaceItem *item2 = [HCDistributeSpaceItem itemWithTitle:[NSString stringWithFormat:@"电话%d",i] placeHolder:[NSString stringWithFormat:@"请输入电话%zd",i]];

        item1.rightText = @"请选择";
        item1.rightImage = @"jiantou";
        item2.keyBoardType = UIKeyboardTypeNumberPad;
        [group.items addObjectsFromArray:@[item1,item2]];
    }
}

- (void)setBottomGroup{
    HCDistributeSpaceGroup *bottomGroup = [self addCommonGroupWithHeader:nil];
    
    HCDistributeSpaceItem *item1 = [HCDistributeSpaceItem itemWithTitle:@"租售状态" placeHolder:nil];
    item1.switchOptions = @[@"出租",@"出售"];
    item1.switchFlag = 1;
    item1.opertion = ^(SimpleSwitch *switchView){
        NSLog(@"switchViewFlag---%zd",switchView.flag);
    };
    
    HCDistributeSpaceItem *item2 = [HCDistributeSpaceItem itemWithTitle:@"入住时间" placeHolder:@"请输入入住时间"];
    item2.mustWrite = YES;
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    view.size = CGSizeMake(self.tableView.width, 90);
    UITextField *textField = [[UITextField alloc] init];
    textField.frame = CGRectMake(20, 20, _SCREEN_WIDTH_ - 40, 50);
    textField.backgroundColor = [UIColor orangeColor];
    [view addSubview:textField];
    HCCommonItem *item5 = [HCCommonItem associateObject:view withKey:@"view"];
    
    HCDistributeSpaceItem *item3 = [HCDistributeSpaceItem itemWithTitle:@"租售状态" placeHolder:nil];
    item3.rightText = @"请选择";
    item3.rightImage = @"jiantou";
    
    WEAK(self)
    WEAK(_photoItem)
    item3.opertion = ^(UIButton *button){
        NSLog(@"photos=%@\naddPhotos=%@\ndeletePhotos=%@\n",weak_photoItem.photos,weak_photoItem.addPhotos,weak_photoItem.deletePhotos);
        [weakself.tableView reloadData];
    };
    
    HCTextViewItem *item6 = [HCTextViewItem itemWithTitle:@"项目详情" placeHolder:@"请输入项目介绍"];
    item6.maxInputLength = 100;
    item6.mustWrite = YES;
    item6.placehoder = @"请输入项目详情（不超过100个字）";
    
    [bottomGroup.items addObjectsFromArray:@[item1,item2,item3,item5,item6]];
}

- (void)dealloc{
    NSLog(@"%@---dealloc",NSStringFromClass(self.class));
}

@end
