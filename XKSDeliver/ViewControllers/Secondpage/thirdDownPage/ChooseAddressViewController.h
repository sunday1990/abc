//
//  ChooseAddressViewController.h
//  sample0128
//
//  Created by 同行必达 on 16/3/2.
//  Copyright © 2016年 同行必达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>

@protocol chooseAddressDelegate <NSObject>

@required

-(void)didSelectedBMKPoiInfo:(BMKPoiInfo *) poiInfo;
-(void)didselectedShopInfo:(NSDictionary *) shopInfo;

@end

@interface ChooseAddressViewController : UIViewController


@property (nonatomic,strong)NSString *fromWhich;
@property (nonatomic,strong)NSString *keyWord;
@property (nonatomic,strong)NSMutableArray *addressDataSource;
@property (nonatomic,strong)NSArray *positionArray;
@property (weak, nonatomic) IBOutlet UITextField *searchTf;

@property (weak, nonatomic) IBOutlet UITableView *addressTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressTableToTop;

@property (nonatomic,copy) NSString *dateString;


@property (strong, nonatomic) BMKPoiSearch *searcher;

@property (weak,nonatomic)id <chooseAddressDelegate>ChooseAddressDelegate;

- (IBAction)displayWholeListClicked:(UIButton *)sender;


- (IBAction)returnBtClicked:(UIButton *)sender;

- (IBAction)clearBtClicked:(UIButton *)sender;


@end




