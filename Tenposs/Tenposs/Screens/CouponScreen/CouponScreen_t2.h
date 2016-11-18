//
//  CouponScreen_t2.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/14/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMCenteredCircularCollectionView.h"
#import "PMCenteredCollectionViewFlowLayout.h"
#import "SimpleDataSource.h"
#import "StaffCommunicator.h"
#import "CouponDataSource_t2.h"

@interface CouponScreen_t2 : UIViewController <UICollectionViewDelegate,
                                                PMCenteredCircularCollectionViewDelegate,
                                                UICollectionViewDelegateFlowLayout,
                                                SimpleDataSourceDelegate,
                                                UITableViewDelegate,
                                                UITableViewDataSource,
                                                TenpossCommunicatorDelegate,
                                                CouponUseDelegate>

@property (strong, nonatomic) CouponDataSource_t2 *dataSource;
@property (strong, nonatomic) UINavigationController *mainNavigationController;
@property (assign, nonatomic) NSInteger store_id;
@property (strong, nonatomic) StaffCategory *staffCate;
@end
