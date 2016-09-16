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
#import "CommunicatorConst.h"
#import "Utils.h"
#import "Const.h"

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
