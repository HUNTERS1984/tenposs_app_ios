//
//  TopScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/3/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TopScreen.h"
#import "GrandViewController.h"

#import "TopScreenDataSource.h"
#import "TopScreenDataSource_t2.h"
#import "TopDataSource.h"

#import "UIViewController+LoadingView.h"

#import "Const.h"
#import "UIUtils.h"
#import "HexColors.h"

#import "MenuScreen.h"
#import "NewsScreen.h"
#import "CouponScreen.h"

#import "GlobalMapping.h"

#import "ShareAppScreen.h"


@interface TopScreen ()<TopScreenDataSourceDelegate, UICollectionViewDelegateFlowLayout>
@property TopDataSource *dataSource;
@end

@implementation TopScreen

- (void)loadView{
    [super loadView];
    [self setTitle:@"Global Work"];
    AppSettings *settings = [[AppConfiguration sharedInstance] getAvailableAppSettings];
    if (settings.template_id == 1) {
        self.dataSource = [[TopScreenDataSource alloc]initWithDelegate:self];
        [self.dataSource registerClassForCollectionView:self.collectionView];
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }else if (settings.template_id == 2){
        self.dataSource = [[TopScreenDataSource_t2 alloc]initWithDelegate:self];
        [self.dataSource registerClassForCollectionView:self.collectionView];
        [self.collectionView setBackgroundColor:[UIColor colorWithHexString:@"#F3F3F3"]];
    }
    
    self.collectionView.dataSource = self.dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showLoadingViewWithMessage:@""];
    [self.dataSource fetchContent];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)title{
    return @"ホーム";
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TopDataSource *dataSource = nil;
    if ([self.collectionView.dataSource isKindOfClass:[TopScreenDataSource class]]) {
        dataSource = (TopScreenDataSource *)self.collectionView.dataSource;
    }else if([self.collectionView.dataSource isKindOfClass:[TopScreenDataSource_t2 class]]){
        dataSource = (TopScreenDataSource_t2 *)self.collectionView.dataSource;
    }
    if (dataSource) {
        NSObject *item = [dataSource dataAtIndexPath:indexPath];
        if(item){
                if ([self.parentViewController isKindOfClass:[GrandViewController class]]) {
                    [((GrandViewController *)self.parentViewController) performSegueWithObject:item];
                }
        }
    }
}

#pragma mark - TopScreenDataSourceDelegate

- (void)dataLoadedWithError:(NSError *)error{
    [self.collectionView reloadData];
    [self removeLoadingView];
    
    if ([[UserData shareInstance] getToken]) {
        AppSettings *settings = [[AppConfiguration sharedInstance] getAvailableAppSettings];
        UIViewController *shareApp = [GlobalMapping getShareAppScreen:settings.template_id andExtra:nil];
        [self presentViewController:shareApp animated:YES completion:nil];
    }
}

- (void)needRefreshItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}

- (void)needRefreshSectionAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat superWidth = self.collectionView.frame.size.width;
    CGSize cellSize = CGSizeZero;
    if ([self.collectionView.dataSource isKindOfClass:[TopScreenDataSource class]]) {
        TopScreenDataSource *dataSource = (TopScreenDataSource *)self.collectionView.dataSource;
        cellSize = [dataSource sizeForCellAtIndexPath:indexPath withCollectionWidth:superWidth];
    }else if ([self.collectionView.dataSource isKindOfClass:[TopScreenDataSource_t2 class]]) {
        TopScreenDataSource_t2 *dataSource = (TopScreenDataSource_t2 *)self.collectionView.dataSource;
        cellSize = [dataSource sizeForCellAtIndexPath:indexPath withCollectionWidth:superWidth];
    }
    return cellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets edge = UIEdgeInsetsZero;
    if ([self.collectionView.dataSource isKindOfClass:[TopScreenDataSource class]]) {
        TopScreenDataSource *dataSource = (TopScreenDataSource *)self.collectionView.dataSource;
        edge = [dataSource insetForSectionAtIndex:section];
    }else if ([self.collectionView.dataSource isKindOfClass:[TopScreenDataSource_t2 class]]) {
        TopScreenDataSource_t2 *dataSource = (TopScreenDataSource_t2 *)self.collectionView.dataSource;
        edge = [dataSource insetForSectionAtIndex:section];
    }
    return edge;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    CGFloat lineSpacing = 0;
    if ([self.collectionView.dataSource isKindOfClass:[TopScreenDataSource class]]) {
        TopScreenDataSource *dataSource = (TopScreenDataSource *)self.collectionView.dataSource;
        lineSpacing = [dataSource minimumLineSpacingForSection:section];
    }else if ([self.collectionView.dataSource isKindOfClass:[TopScreenDataSource_t2 class]]) {
        TopScreenDataSource_t2 *dataSource = (TopScreenDataSource_t2 *)self.collectionView.dataSource;
        lineSpacing = [dataSource minimumLineSpacingForSection:section];
    }
    return lineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    CGFloat interSpacing = 0;
    if ([self.collectionView.dataSource isKindOfClass:[TopScreenDataSource class]]) {
        TopScreenDataSource *dataSource = (TopScreenDataSource *)self.collectionView.dataSource;
        interSpacing = [dataSource minimumInteritemSpacingForSection:section];
    }else if ([self.collectionView.dataSource isKindOfClass:[TopScreenDataSource_t2 class]]) {
        TopScreenDataSource_t2 *dataSource = (TopScreenDataSource_t2 *)self.collectionView.dataSource;
        interSpacing = [dataSource minimumInteritemSpacingForSection:section];
    }
    return interSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize headerSize = CGSizeZero;
    if ([self.collectionView.dataSource isKindOfClass:[TopScreenDataSource class]]) {
        TopScreenDataSource *dataSource = (TopScreenDataSource *)self.collectionView.dataSource;
        headerSize = [dataSource sizeForHeaderAtSection:section inCollectionView:collectionView];
    }else if ([self.collectionView.dataSource isKindOfClass:[TopScreenDataSource_t2 class]]) {
        TopScreenDataSource_t2 *dataSource = (TopScreenDataSource_t2 *)self.collectionView.dataSource;
        headerSize = [dataSource sizeForHeaderAtSection:section inCollectionView:collectionView];
    }
    return headerSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGSize footerSize = CGSizeZero;
    if ([self.collectionView.dataSource isKindOfClass:[TopScreenDataSource class]]) {
        TopScreenDataSource *dataSource = (TopScreenDataSource *)self.collectionView.dataSource;
        footerSize = [dataSource sizeForFooterAtSection:section inCollectionView:collectionView];
    }else if ([self.collectionView.dataSource isKindOfClass:[TopScreenDataSource_t2 class]]) {
        TopScreenDataSource_t2 *dataSource = (TopScreenDataSource_t2 *)self.collectionView.dataSource;
        footerSize = [dataSource sizeForFooterAtSection:section inCollectionView:collectionView];
    }
    return footerSize;
}

#pragma mark - Navigation Methods

- (void)handleItemTouched:(NSObject *)item{
    if (item) {
        if ([self.parentViewController isKindOfClass:[GrandViewController class]]) {
            [((GrandViewController *)self.parentViewController) performSegueWithObject:item];
        }
    }
}

- (void)performNavigateToScreenWithId:(NSInteger)screenId{
    Bundle *extra = [Bundle new];
    [extra put:VC_EXTRA_NAVIGATION value:self.mainNavigationController];
    UIViewController *screen = [GlobalMapping getViewControllerWithId:screenId withExtraData:extra];
    [self.mainNavigationController pushViewController:screen animated:YES];
}

@end
