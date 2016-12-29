//
//  BasicCollectionViewController.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/8/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "BasicCollectionViewController.h"
#import "GrandViewController.h"
#import "ItemDetailScreen.h"
#import "ItemDetailScreen_t2.h"
#import "CouponDetailScreen.h"
#import "NewsDetailScreen.h"
#import "StaffDetailScreen.h"
#import "SVPullToRefresh.h"
#import "UIViewController+LoadingView.h"
#import "UIFont+Themify.h"
#import "HexColors.h"
#import "NewsScreenDetailDataSource_t2.h"
#import "GlobalMapping.h"

@interface BasicCollectionViewController ()

@end

@implementation BasicCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

/*
-(instancetype)initWithDataSource:(SimpleDataSource *)dataSource{
    self = [super initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
    if(self){
        self.dataSource = dataSource;
        self.dataSource.delegate = self;
    }
    return self;
}
*/

- (void)loadView{
    [super loadView];
    if (_dataSource) {
        self.dataSource.delegate = self;
    }
}

- (void)setBkgColor:(UIColor *)bkgColor{
    _bkgColor = bkgColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_bkgColor) {
        [self.collectionView setBackgroundColor:_bkgColor];
    }
    if (_dataSource && !_dataSource.delegate) {
        _dataSource.delegate = self;
    }
    if (self.navigationController && [self.navigationController.viewControllers count] > 1) {

        AppSettings *settings = [[AppConfiguration sharedInstance] getAvailableAppSettings];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                       style:UIBarButtonItemStylePlain target:self action:@selector(didPressBackButton)];
        self.navigationItem.leftBarButtonItem = backButton;
        [self.navigationItem setHidesBackButton:YES animated:YES];
        [self.navigationItem setBackBarButtonItem:nil];
        [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                       [UIFont themifyFontOfSize:20/*[UIUtils getTextSizeWithType:settings.font_size]*/], NSFontAttributeName,
                                                                       [UIColor colorWithHexString:settings.title_color], NSForegroundColorAttributeName,
                                                                       nil]
                                                             forState:UIControlStateNormal];
        [self.navigationItem.leftBarButtonItem setTitle:[NSString stringWithFormat: @"%@", [UIFont stringForThemifyIdentifier:@"ti-angle-left"]]];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setUp];
}

- (void)didPressBackButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
}

- (void)setUp{
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = _dataSource;
    [_dataSource registerClassForCollectionView:self.collectionView];
    
    
    if([self checkForInternetConnection]){
        
    }else{
        __weak BasicCollectionViewController *weakSelf = self;
        [self showErrorScreen:NSLocalizedString(@"no_internet_connection", nil) andRetryButton:^{
            [weakSelf setUp];
        }];
        return;
    }
    
    [self showLoadingViewWithMessage:@""];
    
    __weak __typeof__(self) weakSelf = self;
    __weak __typeof__(self.dataSource) wDataSource = self.dataSource;
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [wDataSource loadData];
    }];
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf showLoadingViewWithMessage:@""];
        [wDataSource reloadDataSource];
    }];
    
    [self.dataSource loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataSource isKindOfClass:[NewsScreenDetailDataSource_t2 class]]) {
        if (indexPath.section == 0 && [collectionView numberOfSections] > 1) {
            [collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *item = [self.dataSource itemAtIndexPath:indexPath];
    AppSettings *settings = [[AppConfiguration sharedInstance] getAvailableAppSettings];
    if ([self.parentViewController isKindOfClass:[GrandViewController class]]) {
        [((GrandViewController *)self.parentViewController) performSegueWithObject:item];
    }else{
        UINavigationController *navigation;
        
        if (_mainNavigationController) {
            navigation = _mainNavigationController;
        }else if (self.navigationController){
            navigation = self.navigationController;
        }
        
        if ([item isKindOfClass:[ProductObject class]]) {
            ProductObject *product = (ProductObject *)item;

            if (settings.template_id == 1) {
                ItemDetailScreen *controller = [[UIUtils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([ItemDetailScreen class])];
                controller.item = product;
                [navigation pushViewController:controller animated:YES];
            }else{
                ItemDetailScreen_t2 *controller = [[ItemDetailScreen_t2 alloc] initWithItem:product];
                [navigation pushViewController:controller animated:YES];
            }
            
        }else if ([item isKindOfClass:[CouponObject class]]) {
            CouponObject *coupon = (CouponObject *)item;
            CouponDetailScreen *controller = [[UIUtils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([CouponDetailScreen class])];
            controller.coupon = coupon;
            [navigation pushViewController:controller animated:YES];
            
        }else if ([item isKindOfClass:[PhotoObject class]]) {
            PhotoObject *photo = (PhotoObject *)item;
            Bundle *extra = [Bundle new];
            [extra put:PhotoViewer_PHOTO value:photo];
            UIViewController *photoViewer = [GlobalMapping getPhotoViewer:settings.template_id andExtra:extra];
            [navigation presentViewController:photoViewer animated:YES completion:nil];
        }else if ([item isKindOfClass:[NewsObject class]]) {
            NewsObject *news = (NewsObject *)item;
            NewsDetailScreen *controller = [[UIUtils mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([NewsDetailScreen class])];
            controller.news = news;
            [navigation pushViewController:controller animated:YES];
        }else if ([item isKindOfClass:[StaffObject class]]){
            StaffObject *staff = (StaffObject *)item;
            StaffDetailScreen *controller = [[StaffDetailScreen alloc] initWithStaff:staff];
            [navigation pushViewController:controller animated:YES];
            
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.dataSource sizeForCellAtIndexPath:indexPath withCollectionWidth:collectionView.bounds.size.width];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return [self.dataSource insetForSection:section];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return [self.dataSource minimumLineSpacingForSection:section];;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return [self.dataSource minimumInteritemSpacingForSection:section];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return [self.dataSource sizeForHeaderAtSection:section inCollectionView:collectionView];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return [self.dataSource sizeForFooterAtSection:section inCollectionView:collectionView];
}

#pragma mark - Private methods

- (void)showPhoto:(PhotoObject *)photoObject{
    
}

- (void)handleDataSourceError:(NSError *)error{
    [self.collectionView.pullToRefreshView stopAnimating];
    [self.collectionView.infiniteScrollingView stopAnimating];
    if (!error) {
        [self removeAllInfoView];
        [self.collectionView reloadData];
        return;
    }
    [self removeAllInfoView];
    NSString *message = @"Unknow Error";
    switch (error.code) {
        case ERROR_DATASOURCE_NO_CONTENT:{
            //TODO: need localize
            message = NSLocalizedString(@"NO CONTENT",nil);
            [self showErrorScreen:message];
        }
            break;
        case ERROR_DETAIL_DATASOURCE_NO_CONTENT:{
            message = NSLocalizedString(@"NO CONTENT",nil);
            [self showErrorScreen:message];
        }
            break;
        case ERROR_CONTENT_FULLY_LOADED:{
            [self removeInfiniteLoading];
        }
            break;
        case ERROR_DETAIL_DATASOURCE_IS_LAST:{
        }break;
        case ERROR_DETAIL_DATASOURCE_IS_FIRST:{
        }break;
        case ERROR_INVALID_TOKEN:{
            [self invalidateCurrentUserSession];
        }
        default:
            break;
    }
}

- (void)removeInfiniteLoading{
    [self.collectionView.infiniteScrollingView stopAnimating];
    self.collectionView.showsInfiniteScrolling = NO;
}

- (void)removePullToRefresh{
    [self.collectionView.pullToRefreshView stopAnimating];
    self.collectionView.showsPullToRefresh = NO;
}

#pragma mark - SimpleDataSourceDelegate

- (void)dataLoaded:(SimpleDataSource *)executor withError:(NSError *)error{
    [self handleDataSourceError:error];
}

- (void)needRefreshItemAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)needRefreshSectionAtIndexPath:(NSIndexPath *)indexPath{
    
}



@end
