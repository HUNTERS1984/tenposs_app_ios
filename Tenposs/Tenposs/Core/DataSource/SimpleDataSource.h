//
//  SimpleDataSource.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/8/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SimpleDataSource;

@protocol SimpleDataSourceDelegate <NSObject>
@required
- (void)dataLoaded:(SimpleDataSource *)executor withError:(NSError *)error;
- (void)needRefreshItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)needRefreshSectionAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface SimpleDataSource : NSObject <UICollectionViewDataSource>

@property(weak, nonatomic) id<SimpleDataSourceDelegate> delegate;

//@property (strong, nonatomic) NSObject *mainData;

- (instancetype)initWithDelegate:(id<SimpleDataSourceDelegate>)delegate;

-(void)reloadDataSource;

- (void)loadData;

- (void)registerClassForCollectionView:(UICollectionView *)collection;

- (NSInteger)numberOfItem;

- (NSObject *)itemAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)isEqualTo:(SimpleDataSource *)second;

- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath withCollectionWidth:(CGFloat)superWidth;

- (CGSize)sizeForHeaderAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView;

- (CGSize)sizeForFooterAtSection:(NSInteger)section inCollectionView:(UICollectionView *)collectionView;

- (UIEdgeInsets)insetForSection;

@end
