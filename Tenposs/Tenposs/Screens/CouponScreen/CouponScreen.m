//
//  CouponScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/22/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "CouponScreen.h"
#import "CouponDataSource.h"
#import "UIViewController+LoadingView.h"
#import "DataModel.h"
#import "CouponDetailScreen.h"
#import "UIUtils.h"

@interface CouponScreen ()<SimpleDataSourceDelegate>
/// Data source
@property (strong, nonatomic) CouponDataSource *dataSource;


@end

@implementation CouponScreen

- (void)loadView{
    [super loadView];
    self.dataSource = [[CouponDataSource alloc] initWithDelegate:self andStoreId:self.store_id];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.dataSource registerClassForCollectionView:self.collectionView];
    self.collectionView.dataSource = self.dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    
    [self showLoadingViewWithMessage:@""];
    [self.dataSource loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)title{
    return @"Coupons";
}

#pragma mark - SimpleDataSourceDelegate
- (void)dataLoaded:(SimpleDataSource *)executor withError:(NSError *)error{
    if (error) {
        switch (error.code) {
            case ERROR_NO_CONTENT:{
                [self showErrorScreen:@"NO CONTENT"];
            }
                break;
            case ERROR_UNKNOWN:{
                [self showErrorScreen:error.domain];
            }
            default:
                [self showErrorScreen:@"UNKOWN ERROR"];
                break;
        }
    }else{
        [self.collectionView reloadData];
        [self removeLoadingView];
    }
}

- (void)needRefreshItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)needRefreshSectionAtIndexPath:(NSIndexPath *)indexPath{

}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *item = [self.dataSource itemAtIndexPath:indexPath];
    if ([item isKindOfClass:[CouponObject class]]) {
        CouponObject *coupon = (CouponObject *)item;
        CouponDetailScreen *detailScreen = [[UIUtils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([CouponDetailScreen class])];
        detailScreen.coupon = coupon;
        [self.navigationController pushViewController:detailScreen animated:YES];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.dataSource sizeForCellAtIndexPath:indexPath withCollectionWidth:collectionView.bounds.size.width];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return [self.dataSource sizeForHeaderAtSection:section inCollectionView:collectionView];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return [self.dataSource sizeForFooterAtSection:section inCollectionView:collectionView];
}

@end
