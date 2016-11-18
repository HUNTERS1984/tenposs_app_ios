//
//  CouponDataSource_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/14/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "CouponDataSource_t2.h"
#import "Const.h"
#import "Utils.h"
#import "Item_Cell_Coupon_t2.h"
#import "UIButton+HandleBlock.h"

#define t2_coupon_cell_reveal   0.1
#define t2_coupon_cell_spacing  15

@interface CouponDataSource_t2()
@property (strong, nonatomic) StoreCoupon *mainData;
@end

@implementation CouponDataSource_t2

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

- (instancetype)initWithStoreId:(NSInteger)store_id{
    self = [super init];
    if (self) {
        if(!self.mainData){
            self.mainData = [StoreCoupon new];
            self.mainData.store_id = store_id;
        }
    }
    return self;
}

-(void)reloadDataSource{
    self.mainData.pageindex = 1;
    [self.mainData removeAllCoupons];
    [self loadData];
}

-(void) loadData{
    
    if([self.mainData.coupons count] != 0 && [self.mainData.coupons count] == self.mainData.total_coupons){
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
            NSError *error = [NSError errorWithDomain:[CommunicatorConst getErrorMessage:ERROR_CONTENT_FULLY_LOADED]  code:ERROR_CONTENT_FULLY_LOADED userInfo:nil];
            [self.delegate dataLoaded:self withError:error];
        }
        return;
    }
    
    CouponCommunicator *request = [CouponCommunicator new];
    Bundle *params = [Bundle new];
    [params put:KeyAPI_APP_ID value:APP_ID];
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    [params put:KeyAPI_TIME value:currentTime];
    NSArray *strings = [NSArray arrayWithObjects:APP_ID,currentTime,[@(_mainData.store_id) stringValue],APP_SECRET,nil];
    [params put:KeyAPI_SIG value:[Utils getSigWithStrings:strings]];
    [params put:KeyAPI_STORE_ID value:[@(_mainData.store_id) stringValue]];
    [params put:KeyAPI_PAGE_INDEX value:[@(_mainData.pageindex) stringValue]];
    [params put:KeyAPI_PAGE_SIZE value:@"20"];
    [request execute:params withDelegate:self];
    
}

- (BOOL)isEqualTo:(SimpleDataSource *)second{
    return NO;
}

- (void)registerClassForCollectionView:(UICollectionView *)collection{
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Cell_Coupon_t2 class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Coupon_t2 class])];
}

- (NSInteger)numberOfItem{
    return [self.mainData.coupons count];
}

- (NSObject *)itemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < [self.mainData.coupons count]) {
        return [self.mainData.coupons objectAtIndex:indexPath.row];
    }
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self numberOfItem];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CouponObject *coupon = (CouponObject *)[self itemAtIndexPath:indexPath];
    __weak CouponObject *weakCoupon = coupon;
    __weak CouponDataSource_t2 *weakSelf = self;
    Item_Cell_Coupon_t2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Cell_Coupon_t2 class]) forIndexPath:indexPath];
    if(cell && coupon){
        [cell configureCellWithData:coupon];
        [cell.userButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            if (weakSelf.couponUseDelegate && [weakSelf.couponUseDelegate respondsToSelector:@selector(onCouponUse:)]) {
                [weakSelf.couponUseDelegate onCouponUse:weakCoupon];
            }
        }];
    }
    return cell;
}


- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath withCollectionWidth:(CGFloat)superWidth{
    
    CGFloat width = superWidth - (15*2) - (superWidth * t2_coupon_cell_reveal);
    CGFloat height = [Item_Cell_Coupon_t2 getCellHeightWithWidth:width];
    return CGSizeMake(width,height);
}

- (CGSize)sizeForHeaderAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    return CGSizeZero;
}

- (CGSize)sizeForFooterAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    return CGSizeZero;
}

- (UIEdgeInsets)insetForSection:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 20, 0);
}

- (CGFloat)minimumLineSpacingForSection:(NSInteger)section{
    return 15;
}

- (CGFloat)minimumInteritemSpacingForSection:(NSInteger)section{
    return t2_coupon_cell_spacing;
}

#pragma mark - TenpossCommunicatorDelegate

- (void)completed:(TenpossCommunicator*)request data:(Bundle*) responseParams{
    NSInteger errorCode =[responseParams getInt:KeyResponseResult];
    NSError *error = nil;
    if (errorCode != ERROR_OK) {
        NSString *errorDomain = [responseParams get:KeyResponseError];
        error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:nil];
    }else{
        CouponResponse *data = (CouponResponse *)[responseParams get:KeyResponseObject];
        if (data.coupons && [data.coupons count] > 0) {
            _mainData.total_coupons = data.total_coupons;
            for (CouponObject *coupon in data.coupons) {
                [_mainData addCoupon:coupon];
            }
        }else if(data.total_coupons == 0){
            if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
                NSError *error = [NSError errorWithDomain:[CommunicatorConst getErrorMessage:ERROR_DATASOURCE_NO_CONTENT]  code:ERROR_DATASOURCE_NO_CONTENT userInfo:nil];
                [self.delegate dataLoaded:self withError:error];
                return;
            }
        }else if (data.total_coupons > 0 && (!data.coupons || [data.coupons count] <= 0)){
            if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
                NSError *error = [NSError errorWithDomain:[CommunicatorConst getErrorMessage:ERROR_UNKNOWN]  code:ERROR_UNKNOWN userInfo:nil];
                [self.delegate dataLoaded:self withError:error];
                return;
            }
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
        [self.delegate dataLoaded:self withError:error];
    }
    [_mainData increasePageIndex:1];
}

- (void)begin:(TenpossCommunicator*)request data:(Bundle*) responseParams{}

-( void)cancelAllRequest{}




@end
