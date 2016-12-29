//
//  CouponRequestListScreen.m
//  TenpossStaff
//
//  Created by Phúc Nguyễn on 10/13/16.
//  Copyright © 2016 PhucNguyen. All rights reserved.
//

#import "CouponRequestListScreen.h"
#import "CouponRequestListDataSource.h"
#import "UIViewController+LoadingView.h"
#import "CouponAlertView.h"
#import "NetworkCommunicator.h"
#import "Const.h"
#import "SVProgressHUD.h"

@interface CouponRequestListScreen () <SimpleDataSourceDelegate, CouponAlertViewDelegate>
@property(strong, nonatomic) CouponRequestListDataSource *dataSource;
@property (weak, nonatomic)IBOutlet UICollectionView *collectionView;
@end

@implementation CouponRequestListScreen

- (void)loadView{
    [super loadView];
    self.dataSource = [[CouponRequestListDataSource alloc] initWithDelegate:self];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.dataSource registerClassForCollectionView:self.collectionView];
    self.collectionView.dataSource = self.dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showLoadingViewWithMessage:@""];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.dataSource loadData];
    
//    __weak __typeof__(self) weakSelf = self;
//    __weak __typeof__(self.dataSource) wDataSource = self.dataSource;
//    [self.collectionView addPullToRefreshWithActionHandler:^{
//        [weakSelf showLoadingViewWithMessage:@""];
//        [wDataSource reloadDataSource];
//    }];
//    
//    [self.collectionView addInfiniteScrollingWithActionHandler:^{
//        [wDataSource loadData];
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SimpleDataSourceDelegate

- (void)dataLoaded:(SimpleDataSource *)executor withError:(NSError *)error{
    if (error) {
        switch (error.code) {
            case ERROR_DATASOURCE_NO_CONTENT:{
                [self showErrorScreen:@"NO CONTENT"];
//                [self removePullToRefresh];
//                [self removeInfiniteLoading];
            }
                break;
            case ERROR_UNKNOWN:{
                [self showErrorScreen:error.domain];
//                [self removeInfiniteLoading];
            }break;
            case ERROR_CONTENT_FULLY_LOADED:{
                [self removeAllInfoView];
//                [self removeInfiniteLoading];
            }break;
            default:
                [self showErrorScreen:@"データなし"];
//                [self removePullToRefresh];
//                [self removeInfiniteLoading];
                break;
        }
    }else{
        [self.collectionView reloadData];
//        [self.collectionView.infiniteScrollingView stopAnimating];
//        [self.collectionView.pullToRefreshView stopAnimating];
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
    if ([item isKindOfClass:[CouponRequestModel class]]) {
        CouponRequestModel *request = (CouponRequestModel *) item;
        CouponAlertView *alert = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([CouponAlertView class])];
        alert.coupon = request;
        [alert showFrom:self withType:CouponAlertImageTypeSend title:request.title description:request.desc positiveButton:@"Accept" negativeButton:@"Reject" delegate:self];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.dataSource sizeForCellAtIndexPath:indexPath withCollectionWidth:collectionView.bounds.size.width];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

#pragma mark - CouponAlertViewDelegate

- (void)onPositiveButtonTapped:(CouponAlertView *)alertView{
    //TODO: send accept request
    if (alertView.coupon) {
        NSMutableDictionary * params = [NSMutableDictionary new];
        [params setObject:@"approve" forKey:KeyAPI_ACTION];
        [params setObject:[@(alertView.coupon.coupon_id) stringValue] forKey:KeyAPI_COUPON_ID];
        [params setObject:APP_ID forKey:KeyAPI_APP_ID];
        [params setObject:alertView.coupon.code forKey:KeyAPI_COUPON_CODE];

        [[NetworkCommunicator shareInstance] POSTNoParams:API_COUPON_ACCEPT parameters:params onCompleted:^(BOOL isSuccess, NSDictionary *dictionary) {
            if(isSuccess){
                [self showAlertView:@"情報" message:@"承認しました"];
                [self.dataSource reloadDataSource];
            }else{
                [self showAlertView:@"エラー" message:@"承認できませんでした"];
            }
        }];
    }
    
    [alertView dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)onNegativeButtonTapped:(CouponAlertView *)alertView{
    
    if (alertView.coupon) {
        NSMutableDictionary * params = [NSMutableDictionary new];
        [params setObject:@"reject" forKey:KeyAPI_ACTION];
        [params setObject:[@(alertView.coupon.coupon_id) stringValue] forKey:KeyAPI_COUPON_ID];
        [params setObject:APP_ID forKey:KeyAPI_APP_ID];
        [params setObject:alertView.coupon.code forKey:KeyAPI_COUPON_CODE];
        
        [[NetworkCommunicator shareInstance] POSTNoParams:API_COUPON_ACCEPT parameters:params onCompleted:^(BOOL isSuccess, NSDictionary *dictionary) {
            if(isSuccess){
                [self showAlertView:@"情報" message:@"承認しませんでした"];
                [self.dataSource reloadDataSource];
            }else{
            }
        }];
    }
    
    [alertView dismissViewControllerAnimated:YES completion:nil];
}
@end
