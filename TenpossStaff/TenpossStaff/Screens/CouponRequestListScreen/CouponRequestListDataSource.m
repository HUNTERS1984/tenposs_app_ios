//
//  CouponRequestListDataSource.m
//  TenpossStaff
//
//  Created by Phúc Nguyễn on 10/14/16.
//  Copyright © 2016 PhucNguyen. All rights reserved.
//

#import "CouponRequestListDataSource.h"
#import "Item_Coupon_Request.h"
#import "MockupData.h"
#import "CouponRequestListRequest.h"
#import "Const.h"


@interface CouponRequestListDataSource()

@property (strong, nonatomic) CouponRequestListModel *mainData;

@end

@implementation CouponRequestListDataSource

static NSString *ident = @"coupon_request_cell";

- (instancetype)initWithDelegate:(id<SimpleDataSourceDelegate>)delegate{
    self = [super initWithDelegate:delegate];
    if (self) {
        if(!_mainData){
            _mainData = [CouponRequestListModel new];
        }
    }
    return self;
}

- (void)reloadDataSource{
    [self cancelOldRequest];
    [_mainData removeAllCouponRequests];
    _mainData.total = 0;
    [self loadData];
}

- (void)loadData{
    
    if(_mainData && [_mainData.list_request count] > 0 && [_mainData.list_request count] == _mainData.total){
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
            NSError *error = [NSError errorWithDomain:@"" code:ERROR_CONTENT_FULLY_LOADED userInfo:nil];
            [self.delegate dataLoaded:self withError:error];
        }
        return;
    }
    
    CouponRequestListRequest *request = [CouponRequestListRequest new];
    Bundle *params = [Bundle new];
    [params put:KeyAPI_APP_ID value:APP_ID];
    [request execute:params withDelegate:self andAuthHeaderType:AuthenticationType_authorization];

}

- (BOOL)isEqualTo:(SimpleDataSource *)second{
    return NO;
}

- (void)registerClassForCollectionView:(UICollectionView *)collection{
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([Item_Coupon_Request class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([Item_Coupon_Request class])];
}

- (NSInteger)numberOfItem{
    return [_mainData.list_request count];
}

- (NSObject *)itemAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *item = nil;
    @try {
        item = [self.mainData.list_request objectAtIndex:indexPath.row];
    } @catch (NSException *exception) {
        NSLog(@"Error %@", exception.description);
    } @finally {
        
    }
    return item;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_mainData.list_request count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CouponRequestModel *request = (CouponRequestModel *)[self itemAtIndexPath:indexPath];
    Item_Coupon_Request *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Item_Coupon_Request class]) forIndexPath:indexPath];
    if(cell && request){
        [cell configureCellWithData:request];
    }
    return cell;
}

//- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath withCollectionWidth:(CGFloat)superWidth{
//    CGFloat width = (superWidth - 4*SPACING_ITEM_PHOTO)/3;
//    CGFloat height = [Item_Cell_Photo getCellHeightWithWidth:width];
//    return CGSizeMake(width,height);
//}

- (CGSize)sizeForHeaderAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    return CGSizeZero;
}

- (CGSize)sizeForFooterAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView{
    return CGSizeZero;
}

//- (UIEdgeInsets)insetForSection{
//    return UIEdgeInsetsMake(8, 8, 8, 8);
//}

#pragma mark - TenpossCommunicatorDelegate

- (void)completed:(TenpossCommunicator*)request data:(Bundle*) responseParams{
    NSInteger errorCode =[responseParams getInt:KeyResponseResult];
    NSError *error = nil;
    if (errorCode != ERROR_OK) {
        NSString *errorDomain = [CommunicatorConst getErrorMessage:errorCode];
        error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:nil];
    }else{
       CouponRequestListResponse *data = (CouponRequestListResponse *)[responseParams get:KeyResponseObject];
        if (data.list_request && [data.list_request count] > 0) {
            _mainData.total = data.total;
            for (CouponRequestModel *item in data.list_request) {
                [_mainData addCouponRequest:item];
            }
        }else{
            if ([_mainData.list_request count] > 0) {
                error = [NSError errorWithDomain:[CommunicatorConst getErrorMessage:ERROR_CONTENT_FULLY_LOADED] code:ERROR_CONTENT_FULLY_LOADED userInfo:nil];
            }else{
                error = [NSError errorWithDomain:[CommunicatorConst getErrorMessage:ERROR_DETAIL_DATASOURCE_NO_CONTENT] code:ERROR_DETAIL_DATASOURCE_NO_CONTENT userInfo:nil];
            }
        }
        [_mainData increasePageIndex:1];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoaded:withError:)]) {
        [self.delegate dataLoaded:self withError:error];
    }
}

- (void)begin:(TenpossCommunicator*)request data:(Bundle*) responseParams{}

-( void)cancelAllRequest{}

- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath withCollectionWidth:(CGFloat)superWidth{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 80);
}

@end
