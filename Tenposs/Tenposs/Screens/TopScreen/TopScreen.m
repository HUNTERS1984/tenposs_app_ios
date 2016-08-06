//
//  TopScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/3/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TopScreen.h"
#import "TopScreenDataSource.h"
#import "UIViewController+LoadingView.h"
#import "Const.h"

@interface TopScreen ()<TopScreenDataSourceDelegate, UICollectionViewDelegateFlowLayout>
@property TopScreenDataSource *dataSource;
@end

@implementation TopScreen

- (void)loadView{
    [super loadView];
    self.dataSource = [[TopScreenDataSource alloc]initWithDelegate:self];
    [self.dataSource registerClassForCollectionView:self.collectionView];
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showLoadingViewWithMessage:@""];
    [self.dataSource fetchContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TopScreenDataSourceDelegate

- (void)dataLoadedWithError:(NSError *)error{
    [self.collectionView reloadData];
    [self removeLoadingView];
}

- (void)needRefreshItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}

- (void)needRefreshSectionAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    TopScreenDataSource *dataSource = (TopScreenDataSource *)self.collectionView.dataSource;
    return [dataSource sizeForCellAtIndexPath:indexPath withCollectionWidth:collectionView.bounds.size.width];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 8, 5, 8);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    TopScreenDataSource *dataSource = (TopScreenDataSource *)self.collectionView.dataSource;
    return [dataSource sizeForHeaderAtSection:section inCollectionView:collectionView];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    TopScreenDataSource *dataSource = (TopScreenDataSource *)self.collectionView.dataSource;
    return [dataSource sizeForFooterAtSection:section inCollectionView:collectionView];
}


@end
