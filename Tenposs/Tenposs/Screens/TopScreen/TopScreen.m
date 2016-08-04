//
//  TopScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/3/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "TopScreen.h"
#import "TopScreenDataSource.h"

@interface TopScreen ()<TopScreenDataSourceDelegate>
@property TopScreenDataSource *dataSource;
@end

@implementation TopScreen

- (void)loadView{
    [super loadView];
    self.dataSource = [[TopScreenDataSource alloc]initWithDelegate:self];
    [self.dataSource registerClassForCollectionView:self.collectionView];
    self.collectionView.dataSource = self.dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.dataSource fetchContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TopScreenDataSourceDelegate

- (void)dataLoadedWithError:(NSError *)error{
    [self.collectionView reloadData];
}

- (void)needRefreshItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}

- (void)needRefreshSectionAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
}


@end
