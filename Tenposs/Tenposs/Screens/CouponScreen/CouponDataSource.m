//
//  CouponDataSource.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/22/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "CouponDataSource.h"
#import "DataModel.h"
#import "Item_Cell_Coupon.h"
#import "MockupData.h"

@interface CouponDataSource()
@property (strong, nonatomic) StoreCoupon *mainData;
@end

@implementation CouponDataSource

- (instancetype)initWithDelegate:(id<SimpleDataSourceDelegate>)delegate andStoreId:(NSInteger)store_id{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        if(!self.mainData){
            self.mainData = [StoreCoupon new];
            self.mainData.store_id = store_id;
        }
    }
    return self;
}

-(void) loadData{
    if (!self.mainData) {
        self.mainData = [StoreCoupon new];
    }
    
    if (self.mainData.total_coupons != 0 && [self.mainData.coupons count] == self.mainData.total_coupons ) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
            NSError *error = [NSError errorWithDomain:CouponDetailError_fullyLoaded code:-9904 userInfo:nil];
            [self.delegate dataLoaded:self withError:error];
        }
        return;
    }
    
    NSData *data = nil;
    
    data = [MockupData fetchDataWithResourceName:@"coupon_items"];
    NSError *error = nil;
    StoreCoupon *couponData = [[StoreCoupon alloc]initWithData:data error:&error];
    
    if (error == nil) {
        if (couponData && [couponData.coupons count] > 0) {
            for (CouponObject *coupon in couponData.coupons) {
                [self.mainData addCoupon:coupon];
            }
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
        [self.delegate dataLoaded:self withError:error];
    }
}

- (void)registerClassForCollectionView:(UICollectionView *)collection{
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_Coupon class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Coupon class])];
}

- (NSInteger)numberOfItem{
    return [self.mainData.coupons count];
}

- (NSObject *)itemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.mainData.coupons objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self numberOfItem];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CouponObject *photo = (CouponObject *)[self itemAtIndexPath:indexPath];
    Item_Cell_Coupon *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Coupon class]) forIndexPath:indexPath];
    if(cell && photo){
        [cell configureCellWithData:photo];
    }
    return cell;
}


- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath withCollectionWidth:(CGFloat)superWidth{
    CGFloat width = superWidth;
    CGFloat height = [Item_Cell_Coupon getCellHeightWithWidth:width];
    return CGSizeMake(width,height);
}

- (CGSize)sizeForHeaderAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    return CGSizeZero;
}

- (CGSize)sizeForFooterAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    return CGSizeZero;
}


@end
