//
//  TopDataSource.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/8/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TopScreenDataSourceDelegate <NSObject>

- (void)dataLoadedWithError:(NSError *)error;

- (void)needRefreshItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)needRefreshSectionAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface TopDataSource : NSObject <UICollectionViewDataSource, UICollectionViewDelegate>

@property(weak, nonatomic) id <TopScreenDataSourceDelegate> delegate;

- (void)registerClassForCollectionView:(UICollectionView *)collection;

-(instancetype)initWithDelegate: (id <TopScreenDataSourceDelegate>) delegate;

- (NSObject *)dataAtIndexPath:(NSIndexPath *)indexPath;

- (void)fetchContent;

- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath withCollectionWidth:(CGFloat)superWidth;

- (CGSize)sizeForHeaderAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView;

- (CGSize)sizeForFooterAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView;

- (CGFloat)minimumLineSpacingForSection:(NSInteger)section;

- (CGFloat)minimumInteritemSpacingForSection:(NSInteger)section;

- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section;

@end
