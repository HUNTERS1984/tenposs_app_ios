//
//  TopScreenDataSource.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/29/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Const.h"

#define SPACING_ITEM_PRODUCT 8
#define SPACING_ITEM_PHOTO 8

@protocol TopScreenDataSourceDelegate <NSObject>

- (void)dataLoadedWithError:(NSError *)error;

- (void)needRefreshItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)needRefreshSectionAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface TopScreenDataSource : NSObject <UICollectionViewDataSource>

@property(weak, nonatomic) id <TopScreenDataSourceDelegate> delegate;

- (void)registerClassForCollectionView:(UICollectionView *)collection;

-(instancetype)initWithDelegate: (id <TopScreenDataSourceDelegate>) delegate;

- (void)fetchContent;

- (CellSpanType)cellSpanTypeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath withCollectionWidth:(CGFloat)superWidth;

- (CGSize)sizeForHeaderAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView;

- (CGSize)sizeForFooterAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView;

@end
