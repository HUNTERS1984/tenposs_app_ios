//
//  CouponDataSource_t2.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/14/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "SimpleDataSource.h"
#import "DataModel.h"
#import "CouponCommunicator.h"
#import "PMCenteredCircularCollectionView.h"

@protocol CouponUseDelegate <NSObject>

- (void)onCouponUse:(CouponObject *)coupon;

@end

@interface CouponDataSource_t2 : SimpleDataSource <TenpossCommunicatorDelegate>
@property (weak, nonatomic) id<CouponUseDelegate> couponUseDelegate;
- (instancetype)initWithDelegate:(id<SimpleDataSourceDelegate>)delegate andStoreId:(NSInteger)store_id;
- (instancetype)initWithStoreId:(NSInteger)store_id;
@end
